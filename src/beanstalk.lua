local print = print
local setmetatable = setmetatable
local require = require
local beanjob = require("src.beanjob")
local string = string
local error = error

module("beanstalk")

beanstalk = {}

--Carriage-return + linefeed for writing to the socket.
local crlf = "\r\n"

--Create a new beanstalk object
function beanstalk:new() 
	local object = { watching = {} }
	setmetatable(object, { __index = beanstalk })
	return object
end

--Connect to a server + port
function beanstalk:connect(server, port)
	self.connection = require( "socket" ).tcp()
	local result, err = self.connection:connect(server,port)
	if result ~= nil then
		print("Successful connection to "..server..":"..port)
		return nil
	else
		error(err)
	end
end

--Put a job into the queue
function beanstalk:put(data, priority)
	if self.connection ~= nil then
		output = "put "..priority.." 1 1 "..#data
		self.connection:send(output..crlf..data..crlf)
		line = self.connection:receive( "*l")
		if starts(line,"INSERTED") then
			print(line)
			return nil
		else
			error(line)
		end	
	end
end

--Watch a tube, for reserving jobs
function beanstalk:watch(tube)
	if self.connection ~= nil then
		self.connection:send("watch "..tube..crlf)
		line = self.connection:receive( "*l")
		if starts(line,"WATCHING") then
			print(line)
			return nil
		else
			error(line)
		end	
	end
end

--Reserve a job from the queue, return a beanjob
function beanstalk:reserve()
	if self.connection ~= nil then
		self.connection:send("reserve"..crlf)
		line = self.connection:receive( "*l")
		print(line)
		if starts(line,"RESERVED") then
			id, data = string.match( line, "%S+ (%S+) (%S+)" )
			line = self.connection:receive("*l")
			job = beanjob:new(line, id)
			return job
		else
			error(line)
		end
	else 
		error("No connection detected.")
	end
end

--Use a tube, for writing jobs
function beanstalk:use(tube)
	if self.connection ~= nil then
		self.connection:send("use "..tube..crlf)
		line = self.connection:receive( "*l")
		if (starts(line,"USING")) then
			print(line)
			return nil
		else 
			error(line)
		end
	else 
		error("No connection")
	end
end

--Utility function for checking whether one string starts with another
function starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

return beanstalk 