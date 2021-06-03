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
		class "ExampleD1" extends "ExampleC1" {}
	end;

	teardownClass = function ()
		_G["ExampleA"] = nil
		_G["ExampleB0"] = nil
		_G["ExampleB1"] = nil
		_G["ExampleB2"] = nil
		_G["ExampleC0"] = nil
		_G["ExampleC1"] = nil
		_G["ExampleC2"] = nil
		_G["ExampleD0"] = nil
		_G["ExampleD1"] = nil
	end;

	["test: Derived class inherits methods"] = function ()
		LuaUnit.assertEquals(ExampleB0():getField1(), 10)
		LuaUnit.assertEquals(ExampleB0():getField2(), "a")
		LuaUnit.assertEquals(ExampleB0(1):getField1(), 1)
		LuaUnit.assertEquals(ExampleB0(null, "A"):getField2(), "A")
		LuaUnit.assertEquals(ExampleB2():getField2(), "a")
	end;

	["test: Derived class overrides methods"] = function ()
		LuaUnit.assertEquals(ExampleB1():getField1(), "ExampleB1:20")
		LuaUnit.assertEquals(ExampleB1():getField2(), "ExampleB1:b")
		LuaUnit.assertEquals(ExampleB1(2, "b"):getField1(), "ExampleB1:40")
		LuaUnit.assertEquals(ExampleB1(2, "b"):getField2(), "ExampleB1:bb")
		LuaUnit.assertEquals(ExampleB2():getField1(), "ExampleB2:25")
	end;

	["test: Deep class chain inherits methods"] = function ()
		LuaUnit.assertEquals(ExampleC0():getField1(), 10)
		LuaUnit.assertEquals(ExampleC0():getField2(), "a")
		LuaUnit.assertEquals(ExampleC0(15, "A"):getField1(), 15)
		LuaUnit.assertEquals(ExampleC0(15, "A"):getField2(), "A")
	end;
	["test: Deep class chain overrides methods"] = function () end; -- TODO
	["test: Derived class inhertits properties"] = function () end; -- TODO
	["test: Derived class overrides properties"] = function () end; -- TODO
	["test: Deep class chain inherits properties"] = function () end; -- TODO
	["test: Deep class chain overrides properties"] = function () end; -- TODO
	["test: Derived class inhertits constructor"] = function () end; -- TODO
	["test: Derived class overrides constructor"] = function () end; -- TODO
	["test: Deep class chain inherits constructor"] = function () end; -- TODO
	["test: Deep class chain overrides constructor"] = function () end; -- TODO
	["test: \"__meta\" field always overrides"] = function () end; -- TODO
	["test: instanceof() returns true for every class in chain"] = function () end; -- TODO
	["test: getClass() returns derived class"] = function () end; -- TODO
	["test: getMeta(\"parent\") == getParent()"] = function () end; -- TODO
	["test: getMeta(\"children\") == getChildren()"] = function () end; -- TODO
	["test: getParent() on Object is nil"] = function () end; -- TODO
	["test: getChildren() on Object contains all \"base\" classes"] = function () end; -- TODO
	["test: Deriving from multiple classes raises error"] = function () end; -- TODO
	["test: Class won't be created after deriving from multiple classes"] = function () end; -- TODO

	["test: Extending undefined class raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot find class \"NotDefined\"",
			function ()
				class "ErrorClass1" extends "NotDefined" {}
			end
		)
	end;

	["test: Class won't be created after extending undefined class"] = function ()
		pcall(function ()
			class "NotExisting" extends "NotDefined" {}
		end)
		LuaUnit.assertNil(NotExisting)
	end;
}
