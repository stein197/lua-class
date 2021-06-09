TestInheritance = {

	setupClass = function ()
		class "ExampleA" {
			field1 = 10;
			field2 = "a";
			constructor = function (self, f1, f2)
				self.field1 = f1
				self.field2 = f2
			end;
			getField1 = function (self)
				return self.field1
			end;
			getField2 = function (self)
				return self.field2
			end;
		}
		-- Inherits everything
		class "ExampleB0" extends "ExampleA" {}
		-- Overrides everything
		class "ExampleB1" extends "ExampleA" {
			field1 = 20;
			field2 = "b";
			constructor = function (self, f1, f2)
				if f1 then
					self.field1 = self.field1 * f1
				end
				if f2 then
					self.field2 = self.field2..f2
				end
			end;
			getField1 = function (self)
				return "ExampleB1:"..self.field1
			end;
			getField2 = function (self)
				return "ExampleB1:"..self.field2
			end;
		}
		-- Partial overriding
		class "ExampleB2" extends "ExampleA" {
			field1 = 25;
			getField1 = function (self)
				return "ExampleB2:"..self.field1
			end;
		}
		-- Deep inheritance
		class "ExampleC0" extends "ExampleB0" {}
		class "ExampleC1" extends "ExampleB1" {
			field1 = 30;
			field2 = "c";
			constructor = function (self, f1, f2)
				if f1 then
					self.field1 = self.field1 * f1
				end
				if f2 then
					self.field2 = self.field2..f2
				end
			end;
			getField1 = function (self)
				return "ExampleC1:"..self.field1
			end;
			getField2 = function (self)
				return "ExampleC1:"..self.field2
			end;
		}
		class "ExampleC2" extends "ExampleB2" {
			getField2 = function (self)
				return "ExampleC2:"..self.field2
			end;
		}
		class "ExampleD0" extends "ExampleC0" {}
		class "ExampleD1" extends "ExampleC1" {
			getField2 = function (self)
				return "ExampleD1:"..self.field2
			end;
		}
	end;

	teardownClass = function ()
		Type.delete(ExampleA)
	end;

	["test: Derived class inherits methods & properties"] = function ()
		LuaUnit.assertEquals(ExampleB0():getField1(), 10)
		LuaUnit.assertEquals(ExampleB0():getField2(), "a")
		LuaUnit.assertEquals(ExampleB0(1):getField1(), 1)
		LuaUnit.assertEquals(ExampleB0(null, "A"):getField2(), "A")
		LuaUnit.assertEquals(ExampleB2():getField2(), "a")
	end;

	["test: Derived class overrides methods & properties"] = function ()
		LuaUnit.assertEquals(ExampleB1():getField1(), "ExampleB1:20")
		LuaUnit.assertEquals(ExampleB1():getField2(), "ExampleB1:b")
		LuaUnit.assertEquals(ExampleB1(2, "b"):getField1(), "ExampleB1:40")
		LuaUnit.assertEquals(ExampleB1(2, "b"):getField2(), "ExampleB1:bb")
		LuaUnit.assertEquals(ExampleB2():getField1(), "ExampleB2:25")
	end;

	["test: Deep class chain inherits methods & properties"] = function ()
		LuaUnit.assertEquals(ExampleC0():getField1(), 10)
		LuaUnit.assertEquals(ExampleC0():getField2(), "a")
		LuaUnit.assertEquals(ExampleC0(15, "A"):getField1(), 15)
		LuaUnit.assertEquals(ExampleC0(15, "A"):getField2(), "A")
		LuaUnit.assertEquals(ExampleD0():getField1(), 10)
	end;

	["test: Deep class chain overrides methods & properties"] = function ()
		LuaUnit.assertEquals(ExampleC1():getField1(), "ExampleC1:30")
		LuaUnit.assertEquals(ExampleC1(35):getField1(), "ExampleC1:1050")
		LuaUnit.assertEquals(ExampleC1().field2, "c")
		LuaUnit.assertEquals(ExampleD1():getField2(), "ExampleD1:c")
	end;

	["test: \"__meta\" field always overrides"] = function ()
		LuaUnit.assertEquals(ExampleB0.__meta, {
			name = "ExampleB0",
			parents = {
				ExampleA = ExampleA
			},
			type = Type.CLASS,
			children = {
				ExampleC0 = ExampleC0
			}
		})
		LuaUnit.assertEquals(ExampleD1.__meta, {
			name = "ExampleD1",
			parents = {
				ExampleC1 = ExampleC1
			},
			type = Type.CLASS,
		})
	end;

	["test: Instance \"__meta\" field is not equal to class ones"] = function ()
		LuaUnit.assertNotEquals(ExampleA().__meta, ExampleA.__meta)
		LuaUnit.assertNotEquals(ExampleC1().__meta, ExampleC1.__meta)
	end;

	["test: instanceof(<string>) returns true for every class in chain"] = function ()
		LuaUnit.assertTrue(ExampleA():instanceof "ExampleA")
		LuaUnit.assertTrue(ExampleA():instanceof "Object")

		LuaUnit.assertTrue(ExampleB0():instanceof "ExampleB0")
		LuaUnit.assertTrue(ExampleB0():instanceof "ExampleA")
		LuaUnit.assertTrue(ExampleB0():instanceof "Object")

		LuaUnit.assertTrue(ExampleC0():instanceof "ExampleC0")
		LuaUnit.assertTrue(ExampleC0():instanceof "ExampleB0")
		LuaUnit.assertTrue(ExampleC0():instanceof "ExampleA")
		LuaUnit.assertTrue(ExampleC0():instanceof "Object")

		LuaUnit.assertTrue(ExampleD1():instanceof "ExampleD1")
		LuaUnit.assertTrue(ExampleD1():instanceof "ExampleC1")
		LuaUnit.assertTrue(ExampleD1():instanceof "ExampleB1")
		LuaUnit.assertTrue(ExampleD1():instanceof "ExampleA")
		LuaUnit.assertTrue(ExampleD1():instanceof "Object")
	end;

	["test: instanceof(<ref>) returns true for every class in chain"] = function ()
		LuaUnit.assertTrue(ExampleA():instanceof(ExampleA))
		LuaUnit.assertTrue(ExampleA():instanceof(Object))

		LuaUnit.assertTrue(ExampleB0():instanceof(ExampleB0))
		LuaUnit.assertTrue(ExampleB0():instanceof(ExampleA))
		LuaUnit.assertTrue(ExampleB0():instanceof(Object))

		LuaUnit.assertTrue(ExampleC0():instanceof(ExampleC0))
		LuaUnit.assertTrue(ExampleC0():instanceof(ExampleB0))
		LuaUnit.assertTrue(ExampleC0():instanceof(ExampleA))
		LuaUnit.assertTrue(ExampleC0():instanceof(Object))

		LuaUnit.assertTrue(ExampleD1():instanceof(ExampleD1))
		LuaUnit.assertTrue(ExampleD1():instanceof(ExampleC1))
		LuaUnit.assertTrue(ExampleD1():instanceof(ExampleB1))
		LuaUnit.assertTrue(ExampleD1():instanceof(ExampleA))
		LuaUnit.assertTrue(ExampleD1():instanceof(Object))
	end;

	["test: getClass() returns derived class"] = function ()
		LuaUnit.assertEquals(ExampleB0():getClass(), ExampleB0)
		LuaUnit.assertEquals(ExampleC0():getClass(), ExampleC0)
		LuaUnit.assertEquals(ExampleD0():getClass(), ExampleD0)
		LuaUnit.assertEquals(ExampleD1():getClass(), ExampleD1)
	end;

	["test: getMeta(\"parents\") returns extended class"] = function ()
		LuaUnit.assertEquals(Class(ExampleA):getMeta("parents"), {Object = Object})
		LuaUnit.assertEquals(Class(ExampleB0):getMeta("parents"), {ExampleA = ExampleA})
		LuaUnit.assertEquals(Class(ExampleC0):getMeta("parents"), {ExampleB0 = ExampleB0})
		LuaUnit.assertEquals(Class(ExampleD1):getMeta("parents"), {ExampleC1 = ExampleC1})
	end;

	["test: getMeta(\"children\") returns all child classes"] = function ()
		LuaUnit.assertEquals(Class(ExampleA):getMeta("children"), {
			ExampleB0 = ExampleB0,
			ExampleB1 = ExampleB1,
			ExampleB2 = ExampleB2
		})
		LuaUnit.assertEquals(Class(ExampleB1):getMeta("children"), {
			ExampleC1 = ExampleC1,
		})
	end;

	["test: getMeta(\"parents\") on Object is nil"] = function ()
		LuaUnit.assertNil(Class(Object):getMeta("parents"))
	end;

	["test: getMeta(\"children\") on Object contains all base classes"] = function ()
		LuaUnit.assertEquals(Class(Object):getMeta("children"), {
			TypeBase = TypeBase,
			ExampleA = ExampleA
		})
	end;

	["test: Extending undefined class raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"ErrorClass1\". Cannot find class \"NotDefined\"",
			function ()
				class "ErrorClass1" extends "NotDefined" {}
			end
		)
	end;

	["test: Class cannot extend itself"] = function () error "Not implemented" end; -- TODO

	["test: Class won't be created after extending undefined class"] = function ()
		pcall(function ()
			class "NotExisting" extends "NotDefined" {}
		end)
		LuaUnit.assertNil(NotExisting)
	end;
}
