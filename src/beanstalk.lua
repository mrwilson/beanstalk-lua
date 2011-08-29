local print = print
local setmetatable = setmetatable
local require = require
local beanjob = require("src.beanjob")
local string = string
local error = error

module("beanstalk")

beanstalk = {}
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
	else
		print("Bad connection: "..err)
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

function beanstalk:reserve()
	if self.connection ~= nil then
		self.connection:send("reserve"..crlf)
		line = self.connection:receive( "*l")
		print(line)
		if starts(line,"RESERVED") then
			id, data = string.match( line, "%S+ (%S+) (%S+)" )
			line = self.connection:receive( "*l")
			
			job = beanjob:new(line, id)
			return job
		else
			error(line)
		end
	else 
		error("No connection detected.")
	end
end

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

function starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

return beanstalk 