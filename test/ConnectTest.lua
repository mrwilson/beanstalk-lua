local beanstalk = require("src.beanstalk")

--Initialise beanstalk object
b = beanstalk:new()

--Connect on default parameters
b:connect("localhost",11300)