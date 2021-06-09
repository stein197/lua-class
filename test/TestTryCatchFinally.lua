TestTryCatchFinally = {

	["test: Error in try() is being silent"] = function ()
		try(
			function ()
				error "Error"
			end
		)
		try {
			function ()
				error "Error"
			end
		}
	end;

	["test: No errors in try() is silent"] = function ()
		try(function () end)
		try {function () end}
	end;

	["test: Error in try() is being processed in catch()"] = function ()
		local var1
		local var2
		try(function ()
			error "Error"
		end):catch(function (msg)
			var1 = msg
		end)
		try {
			function ()
				error "Error"
			end
		} :catch {
			function (msg)
				var2 = msg
			end
		}
		LuaUnit.assertStrContains(var1, "Error")
		LuaUnit.assertStrContains(var2, "Error")
	end;

	["test: No errors in try() won't make catch() execute"] = function ()
		local var1
		local var2
		try(function () end):catch(function (msg)
			var1 = msg
		end)
		try {
			function () end
		} :catch {
			function (msg)
				var2 = msg
			end
		}
		LuaUnit.assertNil(var1)
		LuaUnit.assertNil(var2)
	end;

	["test: finally() executes after error in try()"] = function ()
		local var1
		local var2
		try(function ()
			error "Error"
		end):catch(function (msg)
			var1 = msg
		end):finally(function ()
			var1 = "Finally"
		end)
		try {
			function ()
				error "Error"
			end
		} :catch {
			function (msg)
				var2 = msg
			end
		} :finally {
			function ()
				var2 = "Finally"
			end
		}
		LuaUnit.assertEquals(var1, "Finally")
		LuaUnit.assertEquals(var2, "Finally")
	end;

	["test: finally() executes after no errors in try()"] = function ()
		local var1
		local var2
		try(function () end):catch(function (msg)
			var1 = msg
		end):finally(function ()
			var1 = "Finally"
		end)
		try {
			function () end
		} :catch {
			function (msg)
				var2 = msg
			end
		} :finally {
			function ()
				var2 = "Finally"
			end
		}
		LuaUnit.assertEquals(var1, "Finally")
		LuaUnit.assertEquals(var2, "Finally")
	end;

	["test: finally() as expression after error"] = function ()
		local var1 = try(function ()
			error "Error"
		end):catch(function (msg)
			var1 = msg
		end):finally(function ()
			return "Finally"
		end)
		local var2 = try {
			function ()
				error "Error"
			end
		} :catch {
			function (msg)
				var2 = msg
			end
		} :finally {
			function ()
				return "Finally"
			end
		}
		LuaUnit.assertEquals(var1, "Finally")
		LuaUnit.assertEquals(var2, "Finally")
	end;

	["test: finally() as expression after no errors"] = function ()
		local var1 = try(function () end):catch(function (msg)
			var1 = msg
		end):finally(function ()
			return "Finally"
		end)
		local var2 = try {
			function () end
		} :catch {
			function (msg)
				var2 = msg
			end
		} :finally {
			function ()
				return "Finally"
			end
		}
		LuaUnit.assertEquals(var1, "Finally")
		LuaUnit.assertEquals(var2, "Finally")
	end;

	["test: return a value from previous blocks to finally()"] = function ()
		local var1
		local var2
		try {
			function ()
				return "try"
			end
		} :catch {
			function ()
				return "catch"
			end
		} :finally {
			function (msg)
				var1 = msg
			end
		}
		try {
			function ()
				error "Error"
			end
		} :catch {
			function ()
				return "catch"
			end
		} :finally {
			function (msg)
				var2 = msg
			end
		}
		LuaUnit.assertEquals(var1, "try")
		LuaUnit.assertEquals(var2, "catch")
	end; -- TODO
}
