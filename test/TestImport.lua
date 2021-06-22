TestImport = {

	setupClass = function ()
		os.execute("mkdir src\\system")
		os.execute("mkdir src\\graphics")
		os.execute("echo import \"system.Directory\"; namespace \"system\" {class \"File\" {getDir = function () return system.Directory() end}} > src\\system\\File.lua")
		os.execute("echo namespace \"system\" {class \"Directory\" {}} > src\\system\\Directory.lua")
		os.execute("echo namespace \"graphics\" {class \"Point\" {}} > src\\graphics\\Point.lua")
		import "system.File"
		import "graphics.Point"
	end;

	teardownClass = function ()
		os.execute("rmdir /s /q src\\system src\\graphics")
		Type.delete("system.File")
		Type.delete("system.Directory")
		Type.delete("graphics.Point")
	end;

	["test: Import works"] = function ()
		system.File():getDir():instanceof 'system.Directory'
		system.File():getDir():instanceof(system.Directory)
		graphics.Point()
	end;

	["test: Import with asterisk imports all files in a directory"] = function () error "Not implemented" end; -- TODO
}
