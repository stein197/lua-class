TestNamespace = {

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

	["test: Simple namespace contains \"__meta\""] = function () error "Not implemented" end; -- TODO
	["test: Outer namespace contains \"__meta\""] = function () error "Not implemented" end; -- TODO
	["test: Inner namespace contains \"__meta\""] = function () error "Not implemented" end; -- TODO
	["test: Declaring namespace inside another raises error"] = function () error "Not implemented" end; -- TODO
	["test: Simple namespace declaration error won't create classes"] = function () error "Not implemented" end; -- TODO
	["test: Nested namespace declaration error won't create classes"] = function () error "Not implemented" end; -- TODO
	["test: Simple namespace declaration error won't create functions"] = function () error "Not implemented" end; -- TODO
	["test: Nested namespace declaration error won't create functions"] = function () error "Not implemented" end; -- TODO
	["test: Redeclaring namespace won't rewrite old one"] = function () error "Not implemented" end; -- TODO
	["test: Declaring nested namespace with existing outer one won't replace parent namespace"] = function () error "Not implemented" end; -- TODO
	["test: Simple namespaces can contain classes"] = function () error "Not implemented" end; -- TODO
	["test: Nested namespace can contain classes"] = function () error "Not implemented" end; -- TODO
	["test: Simple namespaces can contain functions"] = function () error "Not implemented" end; -- TODO
	["test: Nested namespace can contain functions"] = function () error "Not implemented" end; -- TODO
	["test: Classes can be referenced inside simple namespace"] = function () error "Not implemented" end; -- TODO
	["test: Classes can be referenced inside nested namespace"] = function () error "Not implemented" end; -- TODO
	["test: Classes contain extra field \"__meta.namespace\""] = function () error "Not implemented" end; -- TODO
}
