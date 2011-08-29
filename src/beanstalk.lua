local print = print
local setmetatable = setmetatable
local require = require

module("beanstalk")

beanstalk = {}

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
	repeat
		line = conn:receive( "*l")
		print( line )
		parseLine( line )
	until line == ""
end

function beanstalk:listen(tube)

return beanstalk 