local setmetatable = setmetatable 

module("beanjob")

beanjob = {}

function beanjob:new(id, data)
	local object = { id = id, data = data }
	setmetatable(object, { __index = beanjob })
	return object
end

--Get the data field from the job
function beanjob:getdata()
	return self.data
end

--Get the id of the job
function beanjob:getid()
	return self.id
end

return beanjob