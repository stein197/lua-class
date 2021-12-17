rockspec_format = "3.0"
package = "luass"
version = "4.0.0-1"
source = {
	url = "git+https://github.com/stein197/luass",
	tag = "4.0.0",
	branch = "main"
}
description = {
	summary = "OOP functionality for Lua with classes and familiar syntax",
	detailed = [[

	]],
	homepage = "https://github.com/stein197/luass",
	labels = {
		"class", "inheritance", "oop", "object"
	},
	maintainer = "Nail' Gafarov <nil20122013@gmail.com>"
}
dependencies = {
	"lua >= 5.3"
}
build = {
	type = "builtin",
	modules = {
		luass = "init.lua"
	}
}
