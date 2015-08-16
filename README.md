# mutils
Mutils is a Lua library that adds a bunch of OOP practices and OO libraries around standard Lua API
It will allow for a Java-like approach to lua.

## Usage
When you create a class you first have to create a file.
The path this file is in will be the package. Note that we have to define the package before
we can use it.
```lua
-- Create your package
-- mypackage is a handle to the package.
-- This has to be done in each file that contains a class
-- Note that the path does not include the file name, just the directory
-- You can retrieve the handle with Package.get(path)
local mypackage = package("path.to.your.package")

local MyClass = mypackage:class "NameOfClass" (ParentClass1, ParentClass2, ...)
function MyClass:MyClass()
	-- Constructor function
end

function MyClass:_MyClass()
	-- Destructor function
end
```

When you have created the class you can start using it in other files
```lua
-- Import the package and class
local MyClass = import "path.to.your.package.MyClass"
-- Create an instance of the class
local object = MyClass()

-- Note that you don't have to use MyClass as a handle
-- You can also do the following
import "path.to.your.package.MyClass"
local object = path.to.your.package.MyClass()
```

Look at the luadocs for more information on the API (look at class.lua).
You will also find more information on how to use a bunch of included classes
that wrap and extend the current lua API in an OO manner
