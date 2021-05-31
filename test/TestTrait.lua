TestTrait = {

	setupClass = function ()
		trait "TraitA" {
			methodA = function ()
				return "a"
			end;
		}
		trait "TraitB" {
			methodB = function ()
				return "b"
			end;
		}
		trait "TraitB0" extends 'TraitA' {}
		trait "TraitC" extends (TraitA, TraitB) {
			methodC = function ()
				return "c"
			end;
		}
		trait "TraitD" extends "TraitC" {
			methodD = function ()
				return "d"
			end;
		}
		class "ExampleA" {}
		class "ExampleB" uses "TraitA" {}
		class "ExampleC" uses (TraitA, TraitB) {}
		class "ExampleD" extends "ExampleB" uses "TraitB" {}
		class "ExampleE" uses "TraitC" {
			methodA = function ()
				return nil
			end;
		}
		class "ExampleF" uses "TraitD" {}
	end;

	teardownClass = function ()
		_G["TraitA"] = nil
		_G["TraitB"] = nil
		_G["TraitB0"] = nil
		_G["TraitC"] = nil
		_G["ExampleA"] = nil
		_G["ExampleB"] = nil
		_G["ExampleC"] = nil
		_G["ExampleD"] = nil
		_G["ExampleE"] = nil
		_G["ExampleF"] = nil
	end;

	test_existance = function ()
		LuaUnit.assertTable(TraitA)
		LuaUnit.assertTable(TraitB)
		LuaUnit.assertTable(TraitC)
		LuaUnit.assertTable(TraitD)
		LuaUnit.assertFunction(TraitA.methodA)
	end;

	test_exampleWithoutTraitsDoesNotContainMethods = function ()
		LuaUnit.assertNil(ExampleA.methodA)
	end;

	test_simpleClassUsageContainsMethods = function ()
		LuaUnit.assertEquals(ExampleB():methodA(), "a")
	end;

	test_traitInheritance = function ()
		LuaUnit.assertEquals(TraitB0.methodA, TraitA.methodA)
	end;

	test_traitMultipleInheritance = function ()
		LuaUnit.assertEquals(TraitC.methodA, TraitA.methodA)
		LuaUnit.assertEquals(TraitC.methodB, TraitB.methodB)
	end;

	test_cannotRedeclareTrait = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare trait. Variable with name \"TraitA\" already exists"
			function ()
				trait "TraitA" {}
			end
		)
	end;

	test_traitsCannotExtendOtherTypes = function () end;
	test_examplesCannotUseNotTraits = function () end;
	test_allExamplesContainDerivedTraitMethods = function () end;
	test_traitsDoNotOverrideClassMethods = function () end;
	test_gettingExampleMeta = function () end;
	test_gettingTraitMeta = function () end;
}
