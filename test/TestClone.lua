TestClone = {

	setupClass = function ()
		class 'A' {
			a = 1;
			b = 2;
			m = function (self)
				return self.a..self.b
			end;
		}
		class 'B' extends 'A' {}
	end;

	teardownClass = function ()
		Type.delete(A)
	end;

	["test: clone() returns cloned object"] = function ()
		local a = A()
		local aClone = a:clone()
		a.a = 10
		a.b = "string"
		aClone.a = -10
		LuaUnit.assertFalse(a == aClone)
		LuaUnit.assertEquals(a.a, 10)
		LuaUnit.assertEquals(a.b, "string")
		LuaUnit.assertEquals(aClone.a, -10)
		LuaUnit.assertEquals(aClone.b, 2)
	end;

	["test: clone() preserves derived methods"] = function ()
		local clone = A():clone()
		LuaUnit.assertEquals(clone:m(), "12")
		LuaUnit.assertTrue(clone:instanceof(A))
		LuaUnit.assertEquals(clone:getClass(), A)
		LuaUnit.assertTrue(B():clone():instanceof "A")
		LuaUnit.assertTrue(B():clone():instanceof "B")
	end;

	["test: clone() deeply clones tables"] = function ()
		local a = A()
		a.a = {
			a = 1,
			b = {
				a = "a"
			}
		}
		local clone = a:clone()
		clone.a.a = 2
		clone.a.b.a = "b"
		LuaUnit.assertEquals(a.a, {
			a = 1,
			b = {
				a = "a"
			}
		})
		LuaUnit.assertEquals(clone.a, {
			a = 2,
			b = {
				a = "b"
			}
		})
	end;

	["test: clone() deeply clones instance fields"] = function ()
		local a = A()
		a.b = B()
		a.b.a = 100
		local clone = a:clone()
		LuaUnit.assertFalse(a.b == clone.b)
		LuaUnit.assertEquals(a.b:m(), "1002")
		clone.b.a = 10
		LuaUnit.assertEquals(clone.b:m(), "102")
	end;
}
