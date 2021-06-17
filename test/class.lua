LuaUnit = dofile "lib/luaunit.lua"
dofile "src/class.lua"
-- TODO: For unix
for file in io.popen("dir test /a:-d /b"):lines() do
	if file:match("^Test%w+%.lua$") then
		dofile("test/"..file)
	end
end
local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
