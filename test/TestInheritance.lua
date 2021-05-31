TestInheritance = {

	setupClass = function ()
		-- class "A" {
		-- 	field = 0;
		-- 	constructor = function (self, f)
		-- 		self.field = f
		-- 	end;
		-- 	method = function (self)
		-- 		return self.field
		-- 	end;
		-- }
		-- class "B0" extends "A" {}
		-- class "B1" extends "A" {
		-- 	method = function (self)
		-- 		return "B1"
		-- 	end
		-- }
		-- class "B2" extends "A" {
		-- 	field = 2;
		-- 	constructor = function (self, f)
		-- 		self.field = f ^ 2
		-- 	end
		-- }
	end;

	teardownClass = function ()
		_G["A"] = nil
		_G["B0"] = nil
		_G["B1"] = nil
		_G["B2"] = nil
	end;

	test_extendingNotExistingClassThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot find class \"NotDefined\"",
			function ()
				class "New" extends "NotDefined" {}
			end
		)
	end;

	test_classInheritsConstructor = function ()
		LuaUnit.assertEquals(B0(2).field, 2)
	end;

	test_classInheritsMethods = function ()
		LuaUnit.assertEquals(B0():method(), 0)
	end;

	test_classInheritsProperties = function ()
		LuaUnit.assertEquals(B0().field, 0)
		LuaUnit.assertEquals(B1().field, 0)
	end;

	-- test_сlassOverridesConstructor = function ()
	-- 	LuaUnit.assertEquals(B2(4).field, 16)
	-- end;

	test_classOverridesMethods = function ()
		LuaUnit.assertEquals(B1():method(), "B1")
	end;

	test_classOverridesProperties = function ()
		LuaUnit.assertEquals(B2().field, 2)
	end;

	test_instanceof = function ()
		LuaUnit.assertTrue(B0():instanceof(B0))
		LuaUnit.assertTrue(B0():instanceof "B0")
		LuaUnit.assertTrue(B2():instanceof "A")
		LuaUnit.assertTrue(B3():instanceof(Object))
	end;

	test_getClass = function ()
		LuaUnit.assertEquals(B0():getClass(), B0)
	end;
}
