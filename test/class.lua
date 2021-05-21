LuaUnit = dofile "lib/luaunit.lua"
dofile "src/class.lua"
dofile "test/TestClass.lua"
dofile "test/TestInheritance.lua"
dofile "test/TestAPI.lua"

class "A" {}

class "B" {

	method1 = function (self)
		return "method 1"
	end;

	method2 = function (self)
		return "method 2"
	end;
}

class "Constructor" {

	a = nil;
	b = nil;

	constructor = function (self, a, b)
		self.a = a
		self.b = b
	end;
	
	getSum = function (self)
		return self.a + self.b
	end;
}

class "DefaultProperties" {

	a = 2;
	b = 3;
}

class "ChildDefaultProperties" extends "DefaultProperties" {}

class "ChildOverrideDefaultProperties" extends "DefaultProperties" {
	
	a = "a";
	b = "b";
}

class "C" extends "B" {

	method1 = function (self)
		return "overrided"
	end;
}

class "ConstructorChild" extends "Constructor" {}

class "ChildOverrideConstructor" extends "Constructor" {

	constructor = function (self)
		self.a = 0
		self.b = 0
	end;
}

local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
