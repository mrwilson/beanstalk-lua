require("beanstalk")

a = Beanstalk:new()
a:connect("localhost",11300)
