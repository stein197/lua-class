TestMeta = {

	setupClass = function ()
		class "A" {}
		class "B0" extends "A" {}
		class "B1" extends "A" {}
		class "C" extends "B" {}
	end;

	teardownClass = function ()
		_G["A"] = nil
		_G["B"] = nil
		_G["B1"] = nil
		_G["C"] = nil
	end;

	test_getMeta_returnsTable = function ()
		LuaUnit.assertTable(Class(A):getMeta())
	end;

	test_getMeta_withKey_returnsValue = function ()
		LuaUnit.assertEquals(Class(B0):getMeta("name"), "B0")
	end;

	test_getParent_isCorrect = function ()
		LuaUnit.assertEquals(Class(B1):getParent(), A)
	end;

	test_getName_isCorrect = function ()
		LuaUnit.assertEquals(Class(C):getName(), "C")
	end;

	test_getChildren_isCorrect = function ()
		LuaUnit.assertEquals(Class(A):getChildren(), {
			B0, B1
		})
		LuaUnit.assertEquals(Class(B):getChildren(), {
			C
		})
		LuaUnit.assertNil(Class(C):getChildren())
	end;

	-- TODO
	test_getTraits_isCorrect = function () end;
}
