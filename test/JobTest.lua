local string = string
local beanjob = require("src.beanjob")
local beanstalk = require("src.beanstalk")

--Initialise beanstalk object
b = beanstalk:new()

--Connect on default parameters
b:connect("localhost",11300)
b:use("tunnel")
b:put("eurostar",0)
b:watch("tunnel")
job = b:reserve()
print(job:getid())