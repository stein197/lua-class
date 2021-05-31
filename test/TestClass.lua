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
		class "CallFromConstructor" {
			constructor = function (self)
				self:method()
			end;
			method = function () end;
		}
	end;

	teardownClass = function ()
		_G["ExampleA"] = nil
		_G["ExampleB"] = nil
		_G["CallFromConstructor"] = nil
	end;

	testExistence = function ()
		LuaUnit.assertTable(ExampleA)
		LuaUnit.assertNil(NotExistingClass)
	end;

	testConstructor = function ()
		LuaUnit.assertEquals(ExampleA().field, 0)
		LuaUnit.assertEquals(ExampleA(10).field, 10)
	end;

	testInstantiating = function ()
		LuaUnit.assertTable(ExampleA())
	end;

	testConstructorCreatesDifferentInstances = function ()
		local a = ExampleA(2)
		local b = ExampleA(5)
		LuaUnit.assertFalse(a.field == b.field)
	end;

	testConstructorCallMethod = function ()
		CallFromConstructor()
	end;

	testMethod = function ()
		local a = ExampleA(2)
		local b = ExampleA(5)
		LuaUnit.assertEquals(a:method(), 2)
		LuaUnit.assertEquals(b:method(), 5)
	end;

	testClassesAreGlobal = function ()
		LuaUnit.assertEquals(_G['ExampleA'], ExampleA)
		LuaUnit.assertEquals(_G['CallFromConstructor'], CallFromConstructor)
	end;

	testInstanceof = function ()
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

	testGetClass = function ()
		local a = ExampleA()
		local b = ExampleB()
		LuaUnit.assertEquals(a:getClass(), ExampleA)
		LuaUnit.assertEquals(b:getClass(), ExampleB)
	end;

	testClassRedeclareThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class. Variable with name \"ExampleA\" already exists",
			function ()
				class "ExampleA" {}
			end
		)
	end;

	testClassInvalidNameThrowsError = function ()
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
