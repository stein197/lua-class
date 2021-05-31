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
		trait "TraitC" extends (TraitA, TraitB) {
			methodC = function ()
				return "c"
			end;
		}
		class "ExampleA" {}
		class "ExampleB" uses "TraitA" {}
		class "ExampleC" extends "ExampleB" uses "TraitB" {}
		class "ExampleD" uses (TraitA, TraitB) {}
		class "ExampleE" uses "TraitC" {
			methodA = function ()
				return nil
			end;
		}
	end;

	teardownClass = function ()
		_G["TraitA"] = nil
		_G["TraitB"] = nil
		_G["TraitC"] = nil
		_G["ExampleA"] = nil
		_G["ExampleB"] = nil
		_G["ExampleC"] = nil
		_G["ExampleD"] = nil
		_G["ExampleE"] = nil
	end;

	test_creating = function () end;
	test_using = function () end;
	test_traitMethodsDoNotOverrideClassOnes = function () end;
	test_meta = function () end;
}
