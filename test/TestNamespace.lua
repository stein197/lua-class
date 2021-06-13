TestNamespace = {

	setupClass = function ()
		namespace 'Simple' {
			class 'A' {};
			a = function () return 'a' end;
		}
		namespace 'Outer.Inner' {
			class 'A' {};
			a = function () return 'a' end;
		}
	end;

	teardownClass = function ()
		_G['Simple'] = nil
		_G['Outer'] = nil
	end;

	["test: Simple invalid name raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare namespace \"000\". The name contains invalid characters",
			function ()
				namespace "000" {}
			end
		)
	end;

	["test: Nested invalid name raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare namespace \"NS.0\". The name contains invalid characters",
			function ()
				namespace "NS.0" {}
			end
		)
	end;

	["test: Namespaces won't be created after declaration errors"] = function ()
		pcall(function ()
			namespace "000" {}
		end)
		pcall(function ()
			namespace "NS.0" {}
		end)
		LuaUnit.assertNil(_G["000"])
		LuaUnit.assertNil(NS)
	end;

	["test: Simple namespace contains \"__meta\""] = function ()
		LuaUnit.assertEquals(Simple.__meta, {
			name = "Simple",
			type = Type.NAMESPACE
		})
	end;

	["test: Outer namespace contains \"__meta\""] = function ()
		LuaUnit.assertEquals(Outer.__meta, {
			name = "Outer",
			type = Type.NAMESPACE
		})
	end;

	["test: Redeclaring namespace won't rewrite old one"] = function ()
		namespace 'Simple' {
			class 'B' {};
			b = function () return 'b' end;
		}
		LuaUnit.assertTable(Simple.A)
		LuaUnit.assertFunction(Simple.a)
	end;

	["test: Declaring nested namespace with existing outer one won't replace parent namespace"] = function ()
		namespace 'Outer.Inner2' {
			class 'A' {};
			a = function () return 'a' end;
		}
		LuaUnit.assertTable(Outer.Inner.A)
	end;

	["test: Simple namespaces can contain classes"] = function ()
		LuaUnit.assertTable(Simple.A)
	end;

	["test: Nested namespace can contain classes"] = function ()
		LuaUnit.assertTable(Outer.Inner.A)
	end;

	["test: Simple namespaces can contain functions"] = function ()
		LuaUnit.assertFunction(Simple.a);
	end;

	["test: Nested namespace can contain functions"] = function ()
		LuaUnit.assertFunction(Outer.Inner.a);
	end;

	["test: Classes can be referenced inside namespace"] = function ()
		local a = Outer.Inner.A()
		local b = Simple.A();
		LuaUnit.assertTrue(a:instanceof "Outer.Inner.A")
		LuaUnit.assertTrue(a:instanceof(Outer.Inner.A))
		LuaUnit.assertTrue(a:instanceof(Object))
		LuaUnit.assertTrue(b:instanceof "Simple.A")
		LuaUnit.assertTrue(b:instanceof(Simple.A))
		LuaUnit.assertTrue(b:instanceof(Object))
	end;

	["test: Classes contain extra field \"__meta.namespace\""] = function ()
		LuaUnit.assertEquals(Class(Outer.Inner.A):getMeta("namespace"), Outer.Inner)
	end;
}
