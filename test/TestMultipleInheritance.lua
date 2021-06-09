TestMultipleInheritance = {

	setupClass = function ()
		class 'ExampleA' {a = function () return 'a' end}
		class 'ExampleB' {b = function () return 'b' end}
		class 'ExampleC' extends (ExampleA, ExampleB) {c = function () return 'c' end}
		class 'ExampleC0' extends (ExampleA, ExampleB) {b = function () return 'B' end}
		class 'ExampleC1' extends 'ExampleC' {}
		class 'ExampleD' {method = function () end}
		class 'ExampleE' {method = function () end}
	end;

	teardownClass = function ()
		Type.delete(ExampleA)
		Type.delete(ExampleB)
		Type.delete(ExampleD)
		Type.delete(ExampleE)
	end;

	["test: Class can derive from multiple classes"] = function ()
		class 'MultA' {}
		class 'MultB' {}
		class 'MultC' extends (MultA, MultB) {}
		Type.delete(MultA)
		Type.delete(MultB)
	end;

	["test: Class cannot derive already derived class"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"ExampleF\". Class \"ExampleB\" is already a base of class \"ExampleC\"",
			function ()
				class 'ExampleF' extends (ExampleC, ExampleB) {}
			end
		)
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"ExampleF\". Class \"ExampleB\" is already a base of class \"ExampleC\"",
			function ()
				class 'ExampleF' extends (ExampleB, ExampleC) {}
			end
		)
	end;

	["test: Class inherits all methods from base classes"] = function ()
		LuaUnit.assertEquals(ExampleC():a(), 'a')
		LuaUnit.assertEquals(ExampleC():b(), 'b')
	end;

	["test: Class can override methods from base classes"] = function ()
		LuaUnit.assertEquals(ExampleC0():b(), 'B')
	end;

	["test: Classes won't be created after declaration errors"] = function ()
		pcall(function ()
			class 'ExampleF' extends (ExampleC, ExampleB) {}
		end)
		pcall(function ()
			class 'ExampleF' extends (ExampleD, ExampleE) {}
		end)
		LuaUnit.assertNil(ExampleF)
	end;

	["test: instanceof()"] = function ()
		LuaUnit.assertTrue(ExampleC():instanceof(ExampleC))
		LuaUnit.assertTrue(ExampleC():instanceof(ExampleA))
		LuaUnit.assertTrue(ExampleC():instanceof(ExampleB))
		LuaUnit.assertTrue(ExampleC():instanceof(Object))
		LuaUnit.assertTrue(ExampleC0():instanceof(Object))
		LuaUnit.assertTrue(ExampleC1():instanceof(ExampleC))
		LuaUnit.assertTrue(ExampleC1():instanceof(ExampleA))
		LuaUnit.assertTrue(ExampleC1():instanceof(ExampleB))
		LuaUnit.assertTrue(ExampleC1():instanceof(Object))

		LuaUnit.assertFalse(ExampleC():instanceof(ExampleD))
		LuaUnit.assertFalse(ExampleC():instanceof(ExampleE))
		LuaUnit.assertFalse(ExampleC0():instanceof(ExampleD))
		LuaUnit.assertFalse(ExampleC0():instanceof(ExampleE))
		LuaUnit.assertFalse(ExampleC1():instanceof(ExampleD))
		LuaUnit.assertFalse(ExampleC1():instanceof(ExampleE))
	end;
}
