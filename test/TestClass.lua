TestClass = {

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
		class "ExampleB" {}
		class "ExampleC" {
			field = nil;
			constructor = function (self, value)
				self:method(value)
			end;
			method = function (self, value)
				self.field = value
			end;
		}
	end;

	teardownClass = function ()
		_G["ExampleA"] = nil
		_G["ExampleB"] = nil
		_G["ExampleC"] = nil
	end;

	test_existence = function ()
		LuaUnit.assertTable(ExampleA)
		LuaUnit.assertNil(NotExistingClass)
	end;

	test_constructor = function ()
		LuaUnit.assertEquals(ExampleA().field, 0)
		LuaUnit.assertEquals(ExampleA(10).field, 10)
	end;

	test_constructorCreatesDifferentInstances = function ()
		local a = ExampleA(2)
		local b = ExampleA(5)
		LuaUnit.assertEquals(a.field, 2)
		LuaUnit.assertEquals(b.field, 5)
		LuaUnit.assertFalse(a.field == b.field)
	end;

	test_constructorCallsMethod = function ()
		LuaUnit.assertEquals(ExampleC(2).field, 2)
	end;

	test_method = function ()
		local a = ExampleA(2)
		local b = ExampleA(5)
		LuaUnit.assertEquals(a:method(), 2)
		LuaUnit.assertEquals(b:method(), 5)
	end;

	test_classesAreGlobal = function ()
		LuaUnit.assertEquals(_G['ExampleA'], ExampleA)
		LuaUnit.assertEquals(_G['ExampleC'], ExampleC)
	end;

	test_instanceof = function ()
		local a = ExampleA()
		local b = ExampleB()
		LuaUnit.assertTrue(a:instanceof "ExampleA")
		LuaUnit.assertTrue(a:instanceof(ExampleA))
		LuaUnit.assertTrue(b:instanceof "ExampleB")
		LuaUnit.assertTrue(b:instanceof(ExampleB))
		LuaUnit.assertFalse(a:instanceof "ExampleB")
		LuaUnit.assertFalse(a:instanceof(ExampleB))
		LuaUnit.assertFalse(ExampleB:instanceof "ExampleA")
		LuaUnit.assertFalse(ExampleB:instanceof(ExampleA))
		LuaUnit.assertTrue(a:instanceof "Object")
		LuaUnit.assertTrue(a:instanceof(Object))
		LuaUnit.assertTrue(b:instanceof "Object")
		LuaUnit.assertTrue(b:instanceof(Object))
		LuaUnit.assertTrue(a:instanceof(a:getClass()))
		LuaUnit.assertTrue(b:instanceof(b:getClass()))
	end;

	test_getClass = function ()
		local a = ExampleA()
		local b = ExampleB()
		LuaUnit.assertEquals(a:getClass(), ExampleA)
		LuaUnit.assertEquals(b:getClass(), ExampleB)
	end;

	test_classRedeclareThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class. Variable with name \"ExampleA\" already exists",
			function ()
				class "ExampleA" {}
			end
		)
	end;

	test_classInvalidNameThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class. Name \"invalid name\" contains invalid characters",
			function ()
				class "invalid name" {}
			end
		)
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class. Name \"0numeric0\" contains invalid characters",
			function ()
				class "0numeric0" {}
			end
		)
	end;
}
