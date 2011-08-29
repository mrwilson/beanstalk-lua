local beanstalk = require("src.beanstalk")
local coroutine = coroutine

b = beanstalk:new()
b:connect("localhost",11300)
b:use("test")
b:use("foo")
