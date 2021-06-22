local ds = package.config:sub(1, 1)

TestImport = {

	setupClass = function ()
		local q = "\""
		local esc = ""
		if ds == "/" then
			q = "\\"..q
			esc = "\""
		end
		os.execute("mkdir src"..ds.."system")
		os.execute("mkdir src"..ds.."graphics")
		os.execute("mkdir src"..ds.."all")
		os.execute("mkdir scripts")
		os.execute("mkdir scripts"..ds.."system")
		os.execute("echo "..esc.."import "..q.."system.Directory"..q.."; namespace "..q.."system"..q.." {class "..q.."File"..q.." {getDir = function () return system.Directory() end}}"..esc.." > src"..ds.."system"..ds.."File.lua")
		os.execute("echo "..esc.."namespace "..q.."system"..q.." {class "..q.."Directory"..q.." {}}"..esc.." > src"..ds.."system"..ds.."Directory.lua")
		os.execute("echo "..esc.."namespace "..q.."graphics"..q.." {class "..q.."Point"..q.." {}}"..esc.." > src"..ds.."graphics"..ds.."Point.lua")
		os.execute("echo "..esc.."namespace "..q.."all"..q.." {class "..q.."A"..q.." {}}"..esc.." > src"..ds.."all"..ds.."A.lua")
		os.execute("echo "..esc.."namespace "..q.."all"..q.." {class "..q.."B"..q.." {}}"..esc.." > src"..ds.."all"..ds.."B.lua")
		os.execute("echo "..esc.."namespace "..q.."system"..q.." {class "..q.."C"..q.." {}}"..esc.." > scripts"..ds.."system"..ds.."C.lua")
	end;

	teardownClass = function ()
		if ds == "/" then
			os.execute("rm -r src/system src/graphics src/all scripts")
		else
			os.execute("rmdir /s /q src\\system src\\graphics src\\all scripts")
		end
		Type.delete("system.File")
		Type.delete("system.Directory")
		Type.delete("system.C")
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

	["test: Switching base path works"] = function ()
		Type.setBasePath("scripts")
		import "system.C"
		system.C()
		Type.setBasePath("src")
	end;
}
