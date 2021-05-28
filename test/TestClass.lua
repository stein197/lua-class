TestClass = {

	setupClass = function ()
		class "A" {
			field = 0;
			constructor = function (self, f)
				self.field = f
			end;
			method = function (self)
				return self.field
			end;
		}
		class "B" {}
		class "CallFromConstructor" {
			constructor = function (self)
				self:method()
			end;
			method = function () end;
		}
	end;

	teardownClass = function ()
		_G["A"] = nil
		_G["CallFromConstructor"] = nil
	end;

	testExistence = function ()
		LuaUnit.assertTable(A)
		LuaUnit.assertNil(NotExistingClass)
	end;

	testConstructor = function ()
		LuaUnit.assertEquals(A().field, 0)
		LuaUnit.assertEquals(A(10).field, 10)
	end;

	testInstantiating = function ()
		LuaUnit.assertTable(A())
	end;

	testConstructorCreatesDifferentInstances = function ()
		local a = A(2)
		local b = A(5)
		LuaUnit.assertFalse(a.field == b.field)
	end;

	testConstructorCallMethod = function ()
		CallFromConstructor()
	end;

	testMethod = function ()
		local a = A(2)
		local b = A(5)
		LuaUnit.assertEquals(a:method(), 2)
		LuaUnit.assertEquals(b:method(), 5)
	end;

	testClassesAreGlobal = function ()
		LuaUnit.assertEquals(_G['A'], A)
		LuaUnit.assertEquals(_G['CallFromConstructor'], CallFromConstructor)
	end;

	testInstanceof = function ()
		local a = A()
		local b = B()
		LuaUnit.assertTrue(a:instanceof "A")
		LuaUnit.assertTrue(a:instanceof(A))
		LuaUnit.assertTrue(b:instanceof "B")
		LuaUnit.assertTrue(b:instanceof(B))
		LuaUnit.assertFalse(a:instanceof "B")
		LuaUnit.assertFalse(a:instanceof(B))
		LuaUnit.assertFalse(B:instanceof "A")
		LuaUnit.assertFalse(B:instanceof(A))
		LuaUnit.assertTrue(a:instanceof "Object")
		LuaUnit.assertTrue(a:instanceof(Object))
		LuaUnit.assertTrue(b:instanceof "Object")
		LuaUnit.assertTrue(b:instanceof(Object))
		LuaUnit.assertTrue(a:instanceof(a:getClass()))
		LuaUnit.assertTrue(b:instanceof(b:getClass()))
	end;

	testGetClass = function ()
		local a = A()
		local b = B()
		LuaUnit.assertEquals(a:getClass(), A)
		LuaUnit.assertEquals(b:getClass(), B)
	end;

	testClassRedeclareThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class. Variable with name \"A\" already exists",
			function ()
				class "A" {}
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
