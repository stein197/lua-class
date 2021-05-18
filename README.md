# Lua OOP emulator
This simple lua package allows to emulate object-oriented paradigm by using usual keyword `class`. Just import `class.lua` in project and use it like follows:
```lua
class "A" {

	-- Property
	a = 0;

	-- Constructor
	constructor = function (self, a)
		self.a = a
	end;

	-- Method
	echo = function ()
		print "Echo from A class"
	end
}
```
Instantiating is done by direct calling of class name:
```lua
local a = A(1, 2)
a:echo() -- Prints "Echo from A class"
```
All classes are registered in global namespace `_G` - that's why we can access class directly as a function name rather than string as it's dont in class definition. All classes are derived from `Object` class. This class contains two methods - `instanceof()` and `getClass()` which are useful. The first one accepts either string or class reference directly, the second returns class reference:
```lua
a:instanceof "A" -- True
a:instanceof(A) -- True
a:instanceof(Object) -- True
a:instanceof(B) -- False
a:instanceof(a:getClass()) -- True
```
There is also "static" method `getMeta()` that's called on classes. It returns additional metainfo about class:
```lua
A.getMeta() -- {name = "A"}
```
Calling on class instance returns empty table:
```lua
A():getMeta() -- {}
```
If there is a try to create already existing class, an error will be thrown:
```lua
class "A" {--[[ ... ]]}
class "A" {} -- Throws "Cannot declare class. Variable or class with name "A" already exists"
```
There is a restriction on class names. They only can contain alphanumeric characters and cannot start with number:
```lua
class "0 numeric.dot" {} -- Throws "Cannot declare class. Classname "0 numeric" contains invalid characters"
```
