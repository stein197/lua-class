LuaUnit = dofile "lib/luaunit.lua"
dofile "src/class.lua"
local command
if package.config:sub(1, 1) == "/" then
	command = "ls test | grep \"^Test.*\\.lua$\""
else
	command = "dir test /a:-d /b | findstr \"^Test.*\\.lua$\""
end
for file in io.popen(command):lines() do
	dofile("test/"..file)
end
local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
