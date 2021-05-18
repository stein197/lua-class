LuaUnit = dofile "lib/luaunit.lua"
dofile "src/class.lua"
dofile "test/SimpleClass.lua"

class "A" {

	returnSelf = function (self)
		return self
	end;

	methodA = function (self)
		return "A"
	end;
}

class "B" {

	returnSelf = function (self)
		return self
	end;

	methodB = function (self)
		return "B"
	end;
}

class "Constructor" {

	a = nil;
	b = nil;
	sum = nil;

	constructor = function (self, a, b)
		self.a = a
		self.b = b
		self.sum = a + b
	end;
}

local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
