local beanstalk = require("src.beanstalk")

b = beanstalk:new()
b:connect("localhost",11300)
