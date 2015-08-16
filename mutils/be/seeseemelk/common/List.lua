local common = package("be.seeseemelk.common")

---
-- The List class adds extra features to Lua's standard table API
-- @class table
-- @name List
local List = common:class "List" ()

List.values = {}

---
-- Create a new List object
-- @param filter (Optional) Only accept values of these types. Is string or class
--    Can be string, number, function, a class, ...
function List:List(filter)
	self.values = {}
	self.filter = filter
end

---
-- Put a value in the List at a certain index
-- @param index Where should the value be stored
-- @param value What should be stored
-- @return This object for fluent syntax
function List:put(index, value)
	if value == nil then
		self.values[index] = nil
	elseif filter then
		if isCompatible(value, self.filter) then
			self.values[index] = value
		else
			error("Incorrect type for this List")
		end
	else
		self.values[index] = value
	end
	return self
end

---
-- Get whatever value is stored at an index
-- @param index The index to retrieve
-- @return The value of whatever was stored there
function List:get(index)
	return self.values[index]
end

---
-- Add a value to the List
-- It is appended to the end of the List
-- @param value The value to add
-- @param ... (Optional) extra values to add
-- @return This List for fluent syntax
function List:add(value, ...)
	if self.filter then
		if isCompatible(value, self.filter) then
			self.values[#self.values + 1] = value
			return self
		else
			error("Tried to add " .. Class.getType(value) .. " when only " .. Class.getType(self.filter) .. " is allowed")
		end
	else
		self.values[#self.values + 1] = value
	end

	if #{...} > 0 then
		self:add(...)
	end

	return self
end

---
-- Check if the List has anything in a certain entry
-- @param index The index to check
-- @return True if there is something in the entry, false if it is empty
function List:has(index)
	return self.values[index] ~= nil
end

---
-- Copy the values from a list or a table
-- @param list The List or the table to copy from
-- @return This list for fluent syntax
function List:copyFrom(list)
	local tbl = list
	if instanceof(list, List) then
		tbl = list:asTable()
	end

	for name, value in pairs(tbl) do
		self:put(name, value)
	end

	return self
end

---
-- Get the List as a normal Lua List
-- @return A normal lua List containing the data
function List:asTable()
	return self.values
end

---
-- Get the contents of the List as a vararg
-- @return A vararg with the contents of the List
function List:unpack()
	return unpack(self:asList())
end

---
-- Insert a value into the List
-- Shifts other elements up
-- @param position Location where to insert
-- @param value The value to insert
-- @return This object for fluent syntax
function List:insert(position, value)
	if not value then
		value = position
		position = nil
	end

	List.insert(self.values, position, value)

	return self
end

---
-- Remove an entry from the List
-- Moves elements down to fill gaps
-- @param position (Optional) The position of the entry. Nil for the last element
-- @return This object for fluent syntax
function List:remove(position)
	List.remove(self.values, position)
	return self
end

---
-- Get the length of this List
-- Only accounts for numbered entries starting from 1 without nils
-- @return The length if the List
function List:getLength()
	return #self.values
end

---
-- Return all elements of this List as a string
-- A start and end index can be used.
-- If they are left empty the beginning and end of the List
-- will be used respectively
-- @param separator (Optional) A string to place in between each index
-- @param startIndex (Optional) The element to start with
-- @param endIndex (Optional) The element to end with
-- @return A string with each index separated by the separator
function List:concat(separator, startIndex, endIndex)
	return table.concat(self.values, separator, startIndex, endIndex)
end

---
-- Sorts the List elements in a given order in-place
-- @param comparator A function that can be used to compare elements
--    (by default: func(a, b) return a < b end)
-- @return This List for fluent syntax
function List:sort(comparator)
	table.sort(self.values, comparator)
	return self
end

---
-- Create a new instances of this List with the same values
-- Note: it does not copy the List recursively
-- @return The copy of the List
function List:clone()
	local clone = Object.clone(self)
	for key, value in pairs(self.values) do
		clone.values[key] = value
	end
	return clone
end

---
-- This method will dump the List to a string
-- It is meant to be printed to the console or written to a file
-- Note that you should use this for debugging, not serialisation
-- @return A string containing a dump of the List
function List:dump(splitter)
	local str = List("string")
	local recurse = List()
	splitter = splitter or "|  "

	local function nice(val)
		return List():add("(", Class.getType(value), ")", tostring(val)):concat()
	end

	local function dump(tbl, depth)
		for index, value in pairs(tbl) do
			local line = List("string")
			line:add(string.rep(splitter, depth))
			if type(value) == "table" then
				line:add(nice(value), " = {\n")
				if antirecurse[value] then
					line:add(string.rep(splitter, depth), "<recursive>\n")
				else
					antirecurse[value] = value
					dumptbl(value, depth + 1, antirecurse)
				end
				line:add(string.rep(splitter, depth), "}")
			else
				line:add(string.rep(nice(index)), " = ", nice(value))
			end
			line:add("\n")
			str:add(line:concat())
		end
	end

	str:add(List():add("{"):concat())
	dump(self:asList(), 1)
	str:add(List():add("}"):concat())

	return str:concat("\r\n")
end
