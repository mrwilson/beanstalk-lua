local print = print
local setmetatable = setmetatable
local require = require
local beanjob = require("src.beanjob")
local string = string

module("beanstalk")

beanstalk = {}
local crlf = "\r\n"

function beanstalk:new() 
	local object = { watching = {} }
	setmetatable(object, { __index = beanstalk })
	return object
end

function beanstalk:connect(server, port)
	self.connection = require( "socket" ).tcp()
	local result, err = self.connection:connect(server,port)
	if result ~= nil then
		print("Successful connection to "..server..":"..port)
	else
		print("Bad connection: "..err)
	end
end

function beanstalk:put(job, priority)
	if self.connection ~= nil then
		repeat
			line = self.connection:receive( "*l")
			
		until line == ""
	end
end

function beanstalk:reserve()
	if self.connection ~= nil then
		repeat
			line = self.connection:receive( "*l")
		until line == ""
	else 
		print ("No connection detected.")
	end
end

function beanstalk:use(tube) 
	print("use - Trying to use: "..tube)
	if self.connection ~= nil then
		self.connection:send("use "..tube..crlf)
		repeat
			line = self.connection:receive( "*l")
			if (starts(line,"USING")) then
				print("use - Successfully using "..tube)
				return nil
			else 
				error()
			end
		until line == ""
	else 
		print ("No connection detected.")
	end
end

function starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

return beanstalk 