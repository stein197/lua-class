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
			parents = {
				Object = Object
			},
			children = {
				ExampleB0 = ExampleB0,
				ExampleB1 = ExampleB1,
			}
		})
	end;

	["test: getMeta(<key>) returns single entry"] = function ()
		LuaUnit.assertEquals(Class(ExampleB0):getMeta("name"), "ExampleB0")
		LuaUnit.assertEquals(Class(ExampleB0):getMeta("parents"), {ExampleA = ExampleA})
	end;

	["test: getMeta(\"parents\") is correct"] = function ()
		LuaUnit.assertNil(Class(Object):getMeta("parents"))
		LuaUnit.assertEquals(Class(ExampleA):getMeta("parents"), {Object = Object})
		LuaUnit.assertEquals(Class(ExampleB1):getMeta("parents"), {ExampleA = ExampleA})
	end;

	["test: getMeta(\"name\") is correct"] = function ()
		LuaUnit.assertEquals(Class(ExampleC):getMeta("name"), "ExampleC")
	end;

	["test: getMeta(\"children\") is correct"] = function ()
		LuaUnit.assertEquals(Class(ExampleA):getMeta("children"), {
			ExampleB0 = ExampleB0;
			ExampleB1 = ExampleB1;
		})
		LuaUnit.assertEquals(Class(ExampleB1):getMeta("children"), {
			ExampleC = ExampleC
		})
		LuaUnit.assertNil(Class(ExampleC):getMeta("children"))
	end;
}
