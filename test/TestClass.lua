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
		Type.delete(ExampleA)
		Type.delete(ExampleB)
		Type.delete(ExampleC)
	end;

	["test: Classes exist"] = function ()
		LuaUnit.assertTable(ExampleA)
		LuaUnit.assertNil(NotExistingClass)
	end;

	["test: Constructor behaves correct"] = function ()
		LuaUnit.assertEquals(ExampleA().field, 0)
		LuaUnit.assertEquals(ExampleA(10).field, 10)
	end;

	["test: Constructor creates different instances"] = function ()
		local a = ExampleA(2)
		local b = ExampleA(5)
		LuaUnit.assertEquals(a.field, 2)
		LuaUnit.assertEquals(b.field, 5)
		LuaUnit.assertFalse(a.field == b.field)
	end;

	["test: Methods can be called from inside constructor"] = function ()
		LuaUnit.assertEquals(ExampleC(2).field, 2)
	end;

	["test: Method calls are correct"] = function ()
		local a = ExampleA(2)
		local b = ExampleA(5)
		LuaUnit.assertEquals(a:method(), 2)
		LuaUnit.assertEquals(b:method(), 5)
	end;

	["test: Classes are stored in global scope"] = function ()
		LuaUnit.assertEquals(_G['ExampleA'], ExampleA)
		LuaUnit.assertEquals(_G['ExampleC'], ExampleC)
	end;

	["test: instanceof()"] = function ()
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

	["test: getClass()"] = function ()
		local a = ExampleA()
		local b = ExampleB()
		LuaUnit.assertEquals(a:getClass(), ExampleA)
		LuaUnit.assertEquals(b:getClass(), ExampleB)
	end;

	["test: Class redeclaration raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"ExampleA\". Class with this name already exists",
			function ()
				class "ExampleA" {}
			end
		)
	end;

	["test: Class with invalid characters raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"invalid name\". The name contains invalid characters",
			function ()
				class "invalid name" {}
			end
		)
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"0numeric0\". The name contains invalid characters",
			function ()
				class "0numeric0" {}
			end
		)
	end;

	["test: \"__meta\" field declaration throws error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"MetaField\". Declaration of field \"__meta\" is not allowed",
			function ()
				class "MetaField" {
					__meta = {}
				}
			end
		)
	end;

	["test: Classes won't be created after declaration errors"] = function ()
		pcall(function ()
			class "Error1: Invalid name" {}
		end)
		pcall(function ()
			class "Error2" {
				__meta = 12
			}
		end)
		LuaUnit.assertNil(_G["Error1: Invalid name"])
		LuaUnit.assertNil(_G["Error2"])
	end;
}
