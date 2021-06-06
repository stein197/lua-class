TestMeta = {

	setupClass = function ()
		class "ExampleA" {}
		class "ExampleB0" extends "ExampleA" {}
		class "ExampleB1" extends "ExampleA" {}
		class "ExampleC" extends "ExampleB1" {}
	end;

	teardownClass = function ()
		Type.delete(ExampleA)
	end;

	["test: getMeta() returns table"] = function ()
		LuaUnit.assertTable(Class(ExampleA):getMeta())
		LuaUnit.assertEquals(Class(ExampleA):getMeta(), {
			name = "ExampleA",
			type = Type.CLASS,
			parent = Object,
			children = {
				ExampleB0 = ExampleB0,
				ExampleB1 = ExampleB1,
			}
		})
	end;

	["test: getMeta(<key>) returns single entry"] = function ()
		LuaUnit.assertEquals(Class(ExampleB0):getMeta("name"), "ExampleB0")
		LuaUnit.assertEquals(Class(ExampleB0):getMeta("parent"), ExampleA)
	end;

	["test: getParent() is correct"] = function ()
		LuaUnit.assertNil(Class(Object):getParent())
		LuaUnit.assertEquals(Class(ExampleA):getParent(), Object)
		LuaUnit.assertEquals(Class(ExampleB1):getParent(), ExampleA)
	end;

	["test: getName() is correct"] = function ()
		LuaUnit.assertEquals(Class(ExampleC):getName(), "ExampleC")
	end;

	["test: getChildren() is correct"] = function ()
		LuaUnit.assertEquals(Class(ExampleA):getChildren(), {
			ExampleB0 = ExampleB0;
			ExampleB1 = ExampleB1;
		})
		LuaUnit.assertEquals(Class(ExampleB1):getChildren(), {
			ExampleC = ExampleC
		})
		LuaUnit.assertNil(Class(ExampleC):getChildren())
	end;
}
