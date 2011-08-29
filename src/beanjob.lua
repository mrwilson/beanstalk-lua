local setmetatable = setmetatable 

module("beanjob")

beanjob = {}

function beanjob:new(id, data)
	local object = { id = id, data = data }
	setmetatable(object, { __index = beanjob })
	return object
end

function beanjob:getdata()
	return self.data
end

function beanjob:getid()
	return self.id
end

function beanjob:setdata(entry)
	self.data = entry
end

function beanjob:setid(jobid)
	self.id = jobid
end

return beanjob