# Lua OOP emulator
## Basic concepts
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
If there is a try to create already existing class, an error will be thrown:
```lua
class "A" {--[[ ... ]]}
class "A" {} -- Throws "Cannot declare class. Variable or class with name "A" already exists"
```
There is a restriction on class names. They only can contain alphanumeric characters and cannot start with number:
```lua
class "0 numeric.dot" {} -- Throws "Cannot declare class. Classname "0 numeric" contains invalid characters"
```
## Inheritance
This package also supports inheritance:
```lua
class "B" extends "A" {

	echo = function ()
		print "Echo from B class"
	end
}
```
The method `echo` overrides the parent's one. If we omit the method, then it'll return "Echo from B class". There is also support for constructor and property overriding.

## Switch statement
You can create switch-like statements and even expressions using function `switch`:
```lua
local var = "b"
switch (var) {
	a = 1; -- Use string key
	[1] = 2; -- Or numeric one
	[Object()] = 3; -- Or even class instances
	[{"b", "c"}] = function () -- Use multiple values. Mostly functions will be used as code block
		print "Switch!" -- Prints "Switch!"
	end;
	[default] = function () -- Use default fallback
		var = 12
	end
}
-- Or even use it as expression
local var = switch "b" {
	a = 1;
	b = 2;
	c = 3;
}
print(var) -- Prints "2"
```

## API
|Method|Description|
|---|---|
|`Object():getClass()`|Returns reference to a class that created current instance|
|`Object():instanceof(classname)`|Returns true if the object is instance of supplied class. Class name can be either string or direct reference to a class|

There is also special Class API. This package defines own class `Class` which can be used to retrieve info about classes. To use it, pass any class to the constructor like `local aInfo = Class(A)`. This class contains next methods:
|Method|Description|
|---|---|
|`Class():getMeta()`|Returns metainfo about class as a table. The returned table contains fields `name`, `parent`|
|`Class():getName()`|Same as `Class():getMeta("name")`|
|`Class():getParent()`|Same as `Class():getMeta("parent")`|

