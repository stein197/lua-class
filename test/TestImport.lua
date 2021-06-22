TestImport = {

	setupClass = function ()
		os.execute("mkdir src\\system")
		os.execute("mkdir src\\graphics")
		os.execute("mkdir src\\all")
		os.execute("echo import \"system.Directory\"; namespace \"system\" {class \"File\" {getDir = function () return system.Directory() end}} > src\\system\\File.lua")
		os.execute("echo namespace \"system\" {class \"Directory\" {}} > src\\system\\Directory.lua")
		os.execute("echo namespace \"graphics\" {class \"Point\" {}} > src\\graphics\\Point.lua")
		os.execute("echo namespace \"all\" {class \"A\" {}} > src\\all\\A.lua")
		os.execute("echo namespace \"all\" {class \"B\" {}} > src\\all\\B.lua")
	end;

	teardownClass = function ()
		os.execute("rmdir /s /q src\\system src\\graphics src\\all")
		Type.delete("system.File")
		Type.delete("system.Directory")
		Type.delete("graphics.Point")
		Type.delete("all.A")
		Type.delete("all.B")
	end;

	["test: Import works"] = function ()
		import "system.File"
		import "graphics.Point"
		system.File():getDir():instanceof 'system.Directory'
		system.File():getDir():instanceof(system.Directory)
		graphics.Point()
	end;

	["test: Import with asterisk imports all files in a directory"] = function ()
		import "all.*"
		all.A()
		all.B()
	end;

	["test: Switching base path works"] = function () error "Not implemented" end; -- TODO
}
