local LuaUnit = require "lib.luaunit"
require "src.class"

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

TestClass = {
	testExistence = function ()
		LuaUnit.assertTable(A)
		LuaUnit.assertTable(B)
		LuaUnit.assertNil(C)
	end;
	testInstantiating = function () end; -- TODO
	testInstantiaingNotModifyingClass = function () end;
	testInstanceof = function () end; -- TODO
	testGetClass = function () end; -- TODO
}

local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
