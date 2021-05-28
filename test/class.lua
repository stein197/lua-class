LuaUnit = dofile "lib/luaunit.lua"
dofile "src/class.lua"
dofile "test/TestClass.lua"
dofile "test/TestMeta.lua"
-- dofile "test/TestInheritance.lua"
-- dofile "test/TestAPI.lua"
-- dofile "test/TestSwitch.lua"
-- dofile "test/TestTrait.lua"
local runner = LuaUnit.LuaUnit.new()
runner:setOutputType("text")
os.exit(runner:runSuite())
