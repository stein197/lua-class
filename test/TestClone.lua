TestClone = {

	setupClass = function ()
		class 'A' {
			a = 1;
			b = 2;
			m = function (self)
				return self.a..self.b
			end;
		}
	end;

	teardownClass = function ()
		Type.delete(A)
	end;

	["test: clone() returns cloned object"] = function () error "Not implemented" end; -- TODO
	["test: clone() preserves derived methods"] = function () error "Not implemented" end; -- TODO
	["test: clone() processes deep clone"] = function () error "Not implemented" end; -- TODO
	["test: clone() clones instance fields"] = function () error "Not implemented" end; -- TODO
}
