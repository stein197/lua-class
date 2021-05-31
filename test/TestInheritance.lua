TestInheritance = {

	setupClass = function ()
		class "ExampleA" {
			field = 0;
			constructor = function (self, f)
				self.field = f
			end;
			method = function (self)
				return self.field
			end;
		}
		class "ExampleB0" extends "ExampleA" {}
		class "ExampleB1" extends "ExampleA" {
			method = function (self)
				return "B1"
			end
		}
		class "ExampleB2" extends "ExampleA" {
			field = 2;
			constructor = function (self, f)
				self.field = f ^ 2
			end
		}
	end;

	teardownClass = function ()
		_G["ExampleA"] = nil
		_G["ExampleB0"] = nil
		_G["ExampleB1"] = nil
		_G["ExampleB2"] = nil
	end;

	test_extendingNotExistingClassThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot find class \"NotDefined\"",
			function ()
				class "ErrorClass1" extends "NotDefined" {}
			end
		)
	end;
	
	test_declarationErrorDeletesReference = function ()
		pcall(function ()
			class "ErrorClass2" extends "NotDefined" {}
			LuaUnit.assertNil(New)
		end)
	end;

	test_classInheritsConstructor = function ()
		LuaUnit.assertEquals(ExampleB0(2).field, 2)
	end;

	test_classInheritsMethods = function ()
		LuaUnit.assertEquals(ExampleB0():method(), 0)
	end;

	test_classInheritsProperties = function ()
		LuaUnit.assertEquals(ExampleB0().field, 0)
		LuaUnit.assertEquals(ExampleB1().field, 0)
	end;

	test_classOverridesMethods = function ()
		LuaUnit.assertEquals(ExampleB1():method(), "B1")
	end;

	test_classOverridesProperties = function ()
		LuaUnit.assertEquals(ExampleB2(3).field, 9)
	end;

	test_instanceof = function ()
		LuaUnit.assertTrue(ExampleB0():instanceof(ExampleB0))
		LuaUnit.assertTrue(ExampleB0():instanceof "ExampleB0")
		LuaUnit.assertTrue(ExampleB2(3):instanceof "ExampleA")
		LuaUnit.assertTrue(ExampleB2(3):instanceof(Object))
	end;

	test_getClass = function ()
		LuaUnit.assertEquals(ExampleB0():getClass(), ExampleB0)
	end;

	test_constructorOverriding = function ()
		LuaUnit.assertEquals(ExampleB2(4).field, 16)
	end;
}
