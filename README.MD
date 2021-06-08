# Lua OOP emulator
## Basic concepts
This simple lua package allows to emulate object-oriented paradigm by using usual keyword `class`. Just import `class.lua` in project and use it like this:
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
Instantiating is done by direct calling a class name:
```lua
local a = A(1, 2)
a:echo() -- Prints "Echo from A class"
```
All classes are registered in global namespace `_G` - that's why we can access class directly as a function name rather than string as it's done in class definition. All classes are derived from `Object` class. This class contains two methods - `instanceof()` and `getClass()` which are useful. The first one accepts either string or class reference directly, the second returns class reference:
```lua
a:instanceof "A" -- True
a:instanceof(A) -- True
a:instanceof(Object) -- True
a:instanceof(B) -- False
a:instanceof(a:getClass()) -- True
```
If there is a try to create already existing class, an error will be raised:
```lua
class "A" {--[[ ... ]]}
class "A" {} --> Raises error
```
There is a restriction on class names. They only can contain alphanumeric characters and cannot start with number:
```lua
class "0 numeric.dot" {} --> Raises error
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
The method `echo` overrides the parent's one. If we omit the method, then it'll return "Echo from A class". There is also support for constructor and property overriding.

## Multiple inheritance
Classes can derive from multiple base classes:
```lua
class 'A' {

	a = function ()
		return "a"
	end;
}

class 'B' {

	b = function ()
		return "b"
	end;
}

class 'C' extends (A, 'B') {

	c = function ()
		return "c"
	end;
}
C():a() -- returns "a"
```
And also can override methods. But when there is an attempt to derive from classes that contain colliding method names, or derive from already derived class (deep chain), error is raised:
```lua
-- Suppose class A and B contain the same method named "method"
class 'C' extends (A, B) {} -- Raises error
-- Next example:
class 'A' {}
class 'B' extends 'A'
class 'C' extends (B, A) {} -- Error is here because class A is already derived in B
```

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
This library provides simple API to manage hierarchies or to retrieve extra info.
### Type API
|Method|Description|
|---|---|
|`Type.find(<type>)`|Finds and returns type by its name. Nil if type wasn't found|
|`Type.delete(<type>)`|Completely deletes type from hierarchy and global scope. If type has child types, then they are going to die too|

### Object class API
Object is the toppest class that all classes derive automatically. It has the next useful methods:
|Method|Description|
|---|---|
|`Object():getClass()`|Returns reference to a class that created current instance|
|`Object():instanceof(<class>)`|Returns true if the object is instance of supplied class. Class name can be either string or direct reference to a class|

### Class wrapper API
There is also special Class API. This package defines own class `Class` which can be used to retrieve info about classes. To use it, pass any class to the constructor like `local aInfo = Class(A)`. This class contains next methods:
|Method|Description|
|---|---|
|`Class():getMeta(<key>)`|Returns metainfo about class as a table. If `key` is specified then the specified field is returned. The returned table contains fields `name`, `parents`, `type`, `children`|

The `Class` class contains point methods to retrieve single entries like `getName()`, `getParents()` etc.
