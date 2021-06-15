dofile 'src/class.lua'
local initialSize = collectgarbage("count")
local cache = {}
class 'TestingMemoryUsage' {
	__newindex = function () end;
	__call = function () end;
	__tostring = function () end;
	__concat = function () end;
	__metatable = function () end;
	__mode = function () end;
	__gc = function () end;
	__len = function () end;
	__pairs = function () end;
	__ipairs = function () end;
	__add = function () end;
	__sub = function () end;
	__mul = function () end;
	__div = function () end;
	__pow = function () end;
	__mod = function () end;
	__idiv = function () end;
	__eq = function () end;
	__lt = function () end;
	__le = function () end;
	__band = function () end;
	__bor = function () end;
	__bxor = function () end;
	__bnot = function () end;
	__shl = function () end;
	__shr = function () end;
}
local iterationsCount = tonumber(arg[1]) or 1000
for i = 0, iterationsCount do
	table.insert(cache, TestingMemoryUsage())
end
print("Memory test iterations count: "..iterationsCount)
print("Memory usage: "..(collectgarbage("count") - initialSize).."KB")
