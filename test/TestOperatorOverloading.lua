TestOpertatorOverloading = {

	setupClass = function ()
		class 'Overloading' {
			newindex = 0;
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
			bxor = 2;
			bnot = true;
			bshl = 1;
			bshr = 1;
			__newindex = function (self, key, value)
				self:getClass()[key] = value * 2
			end;
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
			-- __mode
			-- __gc
			__len = function (self)
				return self.len
			end;
			-- __pairs
			-- __ipairs
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
				return self.eq == value
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
			__bshl = function (self, value)
				return self.bshl << value
			end;
			__bshr = function (self, value)
				return self.bshr >> value
			end;
		}
		class 'OverloadingChild' extends 'Overloading' {}
		class 'OverloadingKeys' {
			newindex = 0;
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
			bxor = 2;
			bnot = true;
			bshl = 1;
			bshr = 1;
			["[]"] = function (self, key, value)
				self:getClass()[key] = value * 2
			end;
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
				return self.eq == value
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
				return self.bshl << value
			end;
			[">>"] = function (self, value)
				return self.bshr >> value
			end;
		}
	end;

	teardownClass = function ()
		Type.delete(Overloading)
		Type.delete(OverloadingKeys)
	end;

	["test: __index() raises error"] = function () error "Not implemented" end; -- TODO
	["test: __newindex() -> [] is correct"] = function () error "Not implemented" end; -- TODO
	["test: __call() -> () is correct"] = function () error "Not implemented" end; -- TODO
	["test: __tostring() -> tostring() is correct"] = function () error "Not implemented" end; -- TODO
	["test: __concat() -> .. is correct"] = function () error "Not implemented" end; -- TODO
	["test: __metatable() -> getmetatable() is correct"] = function () error "Not implemented" end; -- TODO
	["test: __mode() is correct"] = function () error "Not implemented" end; -- TODO
	["test: __gc() is correct"] = function () error "Not implemented" end; -- TODO
	["test: __len() -> # is correct"] = function () error "Not implemented" end; -- TODO
	["test: __pairs() -> pairs() is correct"] = function () error "Not implemented" end; -- TODO
	["test: __ipairs() -> ipairs() is correct"] = function () error "Not implemented" end; -- TODO
	["test: __add() -> + is correct"] = function () error "Not implemented" end; -- TODO
	["test: __sub() -> - is correct"] = function () error "Not implemented" end; -- TODO
	["test: __mul() -> * is correct"] = function () error "Not implemented" end; -- TODO
	["test: __div() -> / is correct"] = function () error "Not implemented" end; -- TODO
	["test: __pow() -> ^ is correct"] = function () error "Not implemented" end; -- TODO
	["test: __mod() -> percent_sign is correct"] = function () error "Not implemented" end; -- TODO
	["test: __idiv() -> // is correct"] = function () error "Not implemented" end; -- TODO
	["test: __eq() -> == is correct"] = function () error "Not implemented" end; -- TODO
	["test: __lt() -> < is correct"] = function () error "Not implemented" end; -- TODO
	["test: __le() -> <= is correct"] = function () error "Not implemented" end; -- TODO
	["test: __band() -> & is correct"] = function () error "Not implemented" end; -- TODO
	["test: __bor() -> | is correct"] = function () error "Not implemented" end; -- TODO
	["test: __bxor() -> ~ is correct"] = function () error "Not implemented" end; -- TODO
	["test: __bnot() -> not is correct"] = function () error "Not implemented" end; -- TODO
	["test: __bshl() -> << is correct"] = function () error "Not implemented" end; -- TODO
	["test: __bshr() -> >> is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"[]\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"()\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"..\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"#\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"+\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"-\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"*\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"/\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"^\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"percent_sign\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"//\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"==\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"<\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"<=\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"&\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"|\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"~\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"not\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\"<<\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: [\">>\"] is correct"] = function () error "Not implemented" end; -- TODO
	["test: Overloaded operator in parent is being inherited in child class"] = function () error "Not implemented" end; -- TODO
}
