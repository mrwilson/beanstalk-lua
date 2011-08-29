module("beanstalk")

local conn = require( "socket" ).tcp()

Beanstalk = {}

	function Beanstalk:new (o)
		o = o or {} -- create object if user does not provide one
		setmetatable(o, self)
		self.__index = self
		return o
	end
	
	function Beanstalk:connect(server, port)
		Beanstalk.connection = conn:connect( server, port )
	end