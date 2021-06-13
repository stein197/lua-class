TestOpertatorOverloading = {

	setupClass = function ()
		class 'Overloading' {
			len = 10;
			tostring = "Overloading";
			add = 20;
			sub = 30;
			mul = 40;
			div = 50;
			pow = 60;
			mod = 70;
			idiv = 80;
			eq = "eq";
			lt = 90;
			le = 100;
			band = 1;
			bor = 1;
			bxor = 1;
			bnot = true;
			shl = 1;
			shr = 3;
			__call = function (self, ...)
				return {...}
			end;
			__tostring = function (self)
				return self.tostring
			end;
			__concat = function (self, value)
				return self:__tostring()..value..self:__tostring()
			end;
			__metatable = false;
			__len = function (self)
				return self.len
			end;
			__pairs = function ()
				local a = 0
				return function ()
					a = a + 1
					if a < 10 then
						return a
					end
				end
			end;
			__add = function (self, value)
				return self.add + value
			end;
			__sub = function (self, value)
				return self.sub - value;
			end;
			__mul = function (self, value)
				return self.mul * value
			end;
			__div = function (self, value)
				return self.div / value
			end;
			__pow = function (self, value)
				return self.pow ^ value
			end;
			__mod = function (self, value)
				return self.mod % value
			end;
			__idiv = function (self, value)
				return self.idiv // value
			end;
			__eq = function (self, value)
				return self.eq == value.eq
			end;
			__lt = function (self, value)
				return self.lt < value
			end;
			__le = function (self, value)
				return self.le <= value
			end;
			__band = function (self, value)
				return self.band & value
			end;
			__bor = function (self, value)
				return self.bor | value
			end;
			__bxor = function (self, value)
				return self.bxor ~ value
			end;
			__bnot = function (self)
				return not self.bnot
			end;
			__shl = function (self, value)
				return self.shl << value
			end;
			__shr = function (self, value)
				return self.shr >> value
			end;
		}
		class 'OverloadingChild' extends 'Overloading' {
			__sub = function (self, value)
				return self.sub - value * 2
			end;
			["*"] = function (self, value)
				return (self.mul * value + 1)
			end
		}
		class 'OverloadingKeys' {
			len = 10;
			add = 20;
			sub = 30;
			mul = 40;
			div = 50;
			pow = 60;
			mod = 70;
			idiv = 80;
			eq = "eq";
			lt = 90;
			le = 100;
			band = 1;
			bor = 1;
			bxor = 1;
			bnot = true;
			shl = 1;
			shr = 3;
			["()"] = function (self, ...)
				return {...}
			end;
			[".."] = function (self, value)
				return "OverloadingKeys"..value.."OverloadingKeys"
			end;
			["#"] = function (self)
				return self.len
			end;
			["+"] = function (self, value)
				return self.add + value
			end;
			["-"] = function (self, value)
				return self.sub - value;
			end;
			["*"] = function (self, value)
				return self.mul * value
			end;
			["/"] = function (self, value)
				return self.div / value
			end;
			["^"] = function (self, value)
				return self.pow ^ value
			end;
			["%"] = function (self, value)
				return self.mod % value
			end;
			["//"] = function (self, value)
				return self.idiv // value
			end;
			["=="] = function (self, value)
				return self.eq == value.eq
			end;
			["<"] = function (self, value)
				return self.lt < value
			end;
			["<="] = function (self, value)
				return self.le <= value
			end;
			["&"] = function (self, value)
				return self.band & value
			end;
			["|"] = function (self, value)
				return self.bor | value
			end;
			["~"] = function (self, value)
				return self.bxor ~ value
			end;
			["not"] = function (self)
				return not self.bnot
			end;
			["<<"] = function (self, value)
				return self.shl << value
			end;
			[">>"] = function (self, value)
				return self.shr >> value
			end;
		}
	end;

	teardownClass = function ()
		Type.delete(Overloading)
		Type.delete(OverloadingKeys)
	end;

	["test: __index() raises error"] = function ()
		LuaUnit.assertErrorMsgContains(
			"Cannot declare class \"IndexOverloading\". Declaration of field \"__index\" is not allowed",
			function ()
				class "IndexOverloading" {
					__index = {}
				}
			end
		)
	end;

	["test: __call() is correct"] = function ()
		LuaUnit.assertEquals(Overloading()("a", "b", "c"), {"a", "b", "c"})
	end;

	["test: __tostring() is correct"] = function ()
		LuaUnit.assertEquals(tostring(Overloading()), "Overloading")
	end;

	["test: __concat() is correct"] = function ()
		LuaUnit.assertEquals(Overloading().."string", "OverloadingstringOverloading")
	end;

	["test: __metatable() is correct"] = function ()
		LuaUnit.assertFalse(getmetatable(Overloading()))
	end;

	["test: __len() is correct"] = function ()
		LuaUnit.assertEquals(#Overloading(), 10);
	end;

	["test: __pairs() is correct"] = function ()
		local a = Overloading()
		local t = {}
		for i in pairs(a) do
			table.insert(t, i)
		end
		LuaUnit.assertEquals(t, {1, 2, 3, 4, 5, 6, 7, 8, 9})
	end;

	["test: __add() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() + 100, 120)
	end;

	["test: __sub() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() - 100, -70)
	end;

	["test: __mul() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() * 100, 4000)
	end;

	["test: __div() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() / 25, 2)
	end;

	["test: __pow() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() ^ 2, 3600)
	end;

	["test: __mod() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() % 11, 4)
	end;

	["test: __idiv() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() // 6, 13)
	end;

	["test: __eq() is correct"] = function ()
		local a = Overloading()
		local b = Overloading()
		a.a = "a"
		b.b = "b"
		LuaUnit.assertTrue(a == b)
	end;

	["test: __lt() is correct"] = function ()
		LuaUnit.assertTrue(Overloading() < 100)
	end;

	["test: __le() is correct"] = function ()
		LuaUnit.assertTrue(Overloading() <= 100)
	end;

	["test: __band() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() & 3, 1)
	end;

	["test: __bor() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() | 2, 3)
	end;

	["test: __bxor() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() ~ 3, 2)
	end;

	["test: __bnot() is correct"] = function ()
		LuaUnit.assertFalse(not Overloading())
	end;

	["test: __shl() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() << 3, 8)
	end;

	["test: __shr() is correct"] = function ()
		LuaUnit.assertEquals(Overloading() >> 1, 1)
	end;

	["test: [\"()\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys()("a", "b", "c"), {"a", "b", "c"})
	end;

	["test: [\"..\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys().."string", "OverloadingKeysstringOverloadingKeys")
	end;

	["test: [\"#\"] is correct"] = function ()
		LuaUnit.assertEquals(#OverloadingKeys(), 10);
	end;

	["test: [\"+\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() + 100, 120)
	end;

	["test: [\"-\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() - 100, -70)
	end;

	["test: [\"*\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() * 100, 4000)
	end;

	["test: [\"/\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() / 2, 25)
	end;

	["test: [\"^\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() ^ 2, 3600)
	end;

	["test: [\"percent_sign\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() % 11, 4)
	end;

	["test: [\"//\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() // 6, 13)
	end;

	["test: [\"==\"] is correct"] = function ()
		local a = OverloadingKeys()
		local b = OverloadingKeys()
		a.a = "a"
		b.b = "b"
		LuaUnit.assertTrue(a == b)
	end;

	["test: [\"<\"] is correct"] = function ()
		LuaUnit.assertTrue(OverloadingKeys() < 100)
	end;

	["test: [\"<=\"] is correct"] = function ()
		LuaUnit.assertTrue(OverloadingKeys() <= 100)
	end;

	["test: [\"&\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() & 3, 1)
	end;

	["test: [\"|\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() | 2, 3)
	end;

	["test: [\"~\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() ~ 3, 2)
	end;

	["test: [\"not\"] is correct"] = function ()
		LuaUnit.assertFalse(not OverloadingKeys())
	end;

	["test: [\"<<\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() << 3, 8)
	end;

	["test: [\">>\"] is correct"] = function ()
		LuaUnit.assertEquals(OverloadingKeys() >> 1, 1)
	end;

	["test: Classes won't be created after declaration errors"] = function ()
		pcall(function ()
			class "IndexOverloading" {__index = {}}
		end)
		LuaUnit.assertNil(IndexOverloading)
	end;

	["test: Overloaded operator in parent is being inherited/overrided in child class"] = function ()
		LuaUnit.assertEquals(OverloadingChild() + 10, 30)
		LuaUnit.assertEquals(#OverloadingChild(), 10)
		LuaUnit.assertEquals(OverloadingChild() - 10, 10)
		LuaUnit.assertEquals(OverloadingChild() * 10, 401)
	end;
}
