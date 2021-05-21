TestAPI = {

	testGetMeta = function ()
		LuaUnit.assertEquals(Class(A):getMeta(), {name = "A"})
		LuaUnit.assertEquals(Class(C):getMeta(), {name = "C", parent = B})
	end;

	testGetName = function ()
		LuaUnit.assertEquals(Class(A):getMeta("name"), "A")
		LuaUnit.assertEquals(Class(C):getName(), "C")
	end;

	testGetParent = function ()
		LuaUnit.assertNil(Class(A):getMeta("parent"))
		LuaUnit.assertEquals(Class(C):getParent(), B)
	end;
}
