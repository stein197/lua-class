TestSwitch = {

	testSimple = function ()
		local var
		switch (2) {
			[1] = function ()
				var = 1
			end;
			[2] = function ()
				var = 2
			end;
			[3] = function ()
				var = 3
			end;
		}
		LuaUnit.assertEquals(var, 2)
	end;

	testMultipleSwitch = function ()
		local var
		local val = "c"
		switch (val) {
			[{"a", "b"}] = function ()
				var = "a, b"
			end;
			[{"c", "d"}] = function ()
				var = val
			end;
			e = function ()
				var = "e"
			end;
		}
		LuaUnit.assertEquals(var, "c")
	end;

	testSwitchAsExpression = function ()
		local var = switch "b" {
			a = 1;
			b = 2;
			c = 3;
		}
		LuaUnit.assertEquals(var, 2)
	end;
}
