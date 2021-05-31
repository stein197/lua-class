TestMeta = {

	setupClass = function ()
		class "ExampleA" {}
		class "ExampleB0" extends "ExampleA" {}
		class "ExampleB1" extends "ExampleA" {}
		class "ExampleC" extends "ExampleB1" {}
	end;

	teardownClass = function ()
		_G["ExampleA"] = nil
		_G["ExampleB0"] = nil
		_G["ExampleB1"] = nil
		_G["ExampleC"] = nil
	end;

	test_getMeta_returnsTable = function ()
		LuaUnit.assertTable(Class(ExampleA):getMeta())
	end;

	test_getMeta_withKey_returnsValue = function ()
		LuaUnit.assertEquals(Class(ExampleB0):getMeta("name"), "ExampleB0")
	end;

	test_getParent_isCorrect = function ()
		LuaUnit.assertNil(Class(Object):getParent())
		LuaUnit.assertEquals(Class(ExampleA):getParent(), Object)
		LuaUnit.assertEquals(Class(ExampleB1):getParent(), ExampleA)
	end;

	test_getName_isCorrect = function ()
		LuaUnit.assertEquals(Class(ExampleC):getName(), "ExampleC")
	end;

	test_getChildren_isCorrect = function ()
		LuaUnit.assertEquals(Class(ExampleA):getChildren(), {
			ExampleB0 = ExampleB0;
			ExampleB1 = ExampleB1;
		})
		LuaUnit.assertEquals(Class(ExampleB1):getChildren(), {
			ExampleC = ExampleC
		})
		LuaUnit.assertNil(Class(ExampleC):getChildren())
	end;

	-- TODO
	-- test_getTraits_isCorrect = function () end;
}
