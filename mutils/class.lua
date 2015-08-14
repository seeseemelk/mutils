local classMeta = {}
local objectMeta = {}
local packageMeta = {}

local Package = {}
local Class = {}

function classMeta.__call(class, ...)
	local object = {}
	object.__parent = class
	object.__name = object.__parent.__name
	setmetatable(object, objectMeta)
	if object[class.__name] then
		object[class.__name](object, ...)
	end
	return object
end

function objectMeta.__index(object, key)
	return object.__parent[key]
end

function packageMeta.__index(package, key)
	return rawget(Package, key)
end

---
-- Create a new class in this package
-- Calling this class will return a function that can be used to add parents to the class
-- That function will return the class itself when called
-- @param name The name of the class
-- @return The function
function Package:class(name)
	local class = {}
	self.classes[name] = class
	self[name] = class

	class.__name = name
	class.__parents = {}
	class.super = {}
	setmetatable(class, classMeta)

	local addParent = function(...)
		local parents = {...}
		for _, parent in ipairs(parents) do
			class.__parents[#class.__parents + 1] = parent
			for key, value in pairs(parent) do
				if key ~= "__name" and key ~= "__parent" then
					class.super[key] = value
					if key ~= parent.__name and key ~= parent["_" .. parent.__name] and key ~= "super" then
						class[key] = value
					end
				end
			end
		end
		return class
	end

	return addParent
end

---
-- Check if a package exists
-- @param path The fully qualified name as a string
-- @return True if the package exists, false otherwise
function Package.exists(path)
	local dir = _G
	for name in path:gmatch("(%a+)") do
		if dir[name] then
			dir = dir[name]
		else
			return false
		end
	end
	return true
end

---
-- Get a package by its fully qualified name
-- @param path The fully qualified name as a string
-- @return The package or nil if the package does not exist
function Package.get(path)
	local dir = _G
	for name in path:gmatch("(%a+)") do
		if dir[name] then
			dir = dir[name]
		else
			return nil
		end
	end
	return dir
end

---
-- Create a new package
-- @param path The location of the package. Should be equal to the actual file path
-- @return A package object
-- @name package
function Package.package(path)
	local pkg = Package.get(path)
	if pkg then
		return pkg
	else
		local packageName = path:match("(%a+)$")
		pkg = {}
		pkg.path = path
		pkg.classes = {}

		local parent = nil
		local dir = _G
		for part in string.gmatch(path, "(%a+)") do
			dir[part] = {}
			parent = dir
			dir = dir[part]
		end
		parent[packageName] = pkg

		setmetatable(pkg, packageMeta)
		return pkg
	end
end

return {Package, Class}