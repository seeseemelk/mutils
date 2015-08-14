local common = package("be.seeseemelk.common")

---
-- Enums allow you to easily make tables of types
-- @type table
-- @name Enum
local Enum = common:class "Enum" ()

---
-- Create a new enum with certain values
-- @param ... The values to add
function Enum:Enum(...)
	Object.Object(self)

	self.types = {}

	for index, name in ipairs({...}) do
		self.types[name] = 2 ^ (index - 1)
	end
end

---
-- Check if the enum has a certain value
-- @param value The value to check for
-- @return True if it has the value, false otherwise
function Enum:has(value)
	return self.types[value] ~= nil
end