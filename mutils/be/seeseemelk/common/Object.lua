local common = package("be.seeseemelk.common")

---
-- The object class is a default class that every class extends either directly
-- or indirectly
-- @class table
-- @name Object
local Class = common:class "Object" ()

---
-- Check if this object is an of class
-- @param class The class or name of the class
-- @return True when it is an instance of that class, false otherwise
function Object:instanceof(class)
	assert(class, "Class to compare with has to be of type table")

	local classname = type(class) == "string" and class or Class.getName(class)
	local selfname = Class.getName(self)
	local parentnames = Class.getParentNames(self)

	if selfname == classname then
		return true
	end

	for index, name in ipairs(parentnames) do
		if name == classname then
			return true
		end
	end

	return false
end

---
-- Create a new instances of this object with the same values
-- Note: it does not copy tables recursively
-- @return The copy of the object
function Object:clone()
	local object = {}
	for key, value in pairs(self) do
		object[key] = value
	end
	return object
end
