TestInheritance = {

	testExtendingNotExistingClassThrowsError = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot find class \"NotDefined\"",
			function ()
				class "New" extends "NotDefined" {}
			end
		)
	end;

	testClassInheritsConstructor = function ()
		local child = ConstructorChild(2, 3)
		LuaUnit.assertEquals(child.a, 2)
		LuaUnit.assertEquals(child.b, 3)
	end;

	testClassInheritsMethods = function ()
		LuaUnit.assertEquals(C():method2(), "method 2")
	end;

	testClassInheritsProperties = function ()
		LuaUnit.assertEquals(ChildDefaultProperties().a, 2)
		LuaUnit.assertEquals(ChildDefaultProperties().b, 3)
	end;

	testClassOverridesConstructor = function ()
		LuaUnit.assertEquals(ChildOverrideConstructor().a, 0)
		LuaUnit.assertEquals(ChildOverrideConstructor().b, 0)
	end;

	testClassOverridesMethods = function ()
		LuaUnit.assertEquals(C():method1(), "overrided")
	end;

	testClassOverridesProperties = function ()
		LuaUnit.assertEquals(ChildOverrideDefaultProperties().a, "a")
		LuaUnit.assertEquals(ChildOverrideDefaultProperties().b, "b")
	end;

	testMetaContainsParentReference = function ()
		LuaUnit.assertEquals(Class(Class(C):getMeta().parent):getMeta("name"), "B")
		LuaUnit.assertEquals(Class(C):getMeta("parent"), B)
		LuaUnit.assertEquals(Class(Class(C):getMeta("parent")):getMeta().name, "B")
	end;

	testInstanceof = function ()
		LuaUnit.assertTrue(C():instanceof(C))
		LuaUnit.assertTrue(C():instanceof "C")
		LuaUnit.assertTrue(C():instanceof "B")
		LuaUnit.assertTrue(ChildOverrideConstructor():instanceof(ChildOverrideConstructor))
	end;

	testInstanceofDerived = function ()
		LuaUnit.assertTrue(C():instanceof(B))
		LuaUnit.assertTrue(C():instanceof(Object))
		LuaUnit.assertTrue(C():instanceof "B")
		LuaUnit.assertTrue(C():instanceof "Object")
		LuaUnit.assertTrue(ChildOverrideConstructor():instanceof(Constructor))
		LuaUnit.assertTrue(ChildOverrideConstructor():instanceof "Constructor")
		LuaUnit.assertTrue(ChildOverrideConstructor():instanceof(Object))
		LuaUnit.assertTrue(ChildOverrideConstructor():instanceof "Object")
	end;

	testGetClass = function ()
		LuaUnit.assertEquals(C():getClass(), C)
		LuaUnit.assertEquals(ChildOverrideConstructor():getClass(), ChildOverrideConstructor)
	end;
}
