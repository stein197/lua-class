namespace "alpha"

interface "I1" {
	i1 = function () end
}

interface "I2" {
	i2 = function () end
}

class "A" {
	a = function ()
		return "a"
	end
}

class "B" extends "A" {
	b = function ()
		return "b"
	end
}

class "C" extends "B" implements (alpha.I1, "alpha.I2") {
	c = function ()
		return "c"
	end
}

class "D" implements ("I2") {}
