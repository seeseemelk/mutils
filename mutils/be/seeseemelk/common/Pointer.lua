local common = package("be.seeseemelk.common")

---
-- A pointer class allows you to send a value by-reference
-- instead of by-value. Note that any changed value
-- can only be retrieved with an instance of the pointer class
-- Clones are separate pointer
-- @class table
-- @name Pointer
local Pointer = common:class "Pointer"

---
-- Create a new pointer class
-- @param value (Optional) The value of the pointer
function Pointer:Pointer(value)
	Object.Object(self)
	self.value = value
end

---
-- Get the value that is being saved by this pointer
-- @return The value that is being saved
function Pointer:get()
	return self.value
end

---
-- Set the current value of this pointer
-- @param value The new value of the pointer
-- @return This pointer for fluent syntax
function Pointer:set(value)
	if self.filter then
		if isCompatible(value, self.filter then
			self.value = value
		else
			error("Incorrect value type for this pointer (needs: " .. self.filter ..
				", got: " .. Class.getType(value))
		end
	else
		self.value = value
	end
	return self
end

---
-- Set a filter on the pointer
-- This will limit it so that only values of certain types can be used
-- @param filter A string containing the type to allow or a class
-- @return This pointer for fluent syntax
function Pointer:setFilter(filter)
	self.filter = filter
	return self
end
