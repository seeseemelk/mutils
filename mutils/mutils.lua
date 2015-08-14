Package, Class = unpack(require("mutils.class"))
package = Package.package
class = Class.class
delete = Class.delete

---
-- Import a class into the global namespace
-- If it is already loaded it will just return
-- the class without loading it again
-- @param path The path of the class to import
-- @return The imported class
function import(path)
	local pkg = Package.get(path)

	if pkg then
		return pkg
	else
		require("mutils." .. path)
		return Package.get(path)
	end
end
