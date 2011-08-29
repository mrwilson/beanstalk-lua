# beanstalk-lua

Lua client for transacting with beanstalkd.

# Example

	client = beanstalk:new("localhost",11300)
	client:watch("tube")
	while true
		job = client:reserve()
		print(job:getdata)
	end

## Todo list

* Finish all of the functions

## Dependencies

* [luasocket](http://w3.impa.br/~diego/software/luasocket/home.html "luasocket")

## License

All code written as part of this project falls under an MIT license, included libraries are licensed as described.