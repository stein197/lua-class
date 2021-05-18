LuaUnit = dofile "lib/luaunit.lua"
dofile "src/class.lua"
dofile "test/SimpleClass.lua"
dofile "test/ClassExtends.lua"

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

class "C" extends "B" {

	method1 = function (self)
		return "overrided"
	end;
}

local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
