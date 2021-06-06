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
		Type.delete(ExampleA)
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
			"Cannot declare trait \"TraitA\". Trait with this name already exists",
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
	test_classUses = function () end;
	-- test Class():uses(), getTraits...
}
