local MSG_INVALID_ARGUMENT_TYPE <const> = "The argument has invalid data type"
local MSG_INVALID_NAME          <const> = "Classname \"%s\" is invalid, only alphanumeric characters are allowed"
local MSG_LOCAL_CLASS_NOT_FOUND <const> = "Local class \"%s\" not found among local variables"
local STRING_EXTENDS            <const> = "extends"
local REGEX_NAME                <const> = "^%a%w*$"

local function validatename(name)
	if not name:match(REGEX_NAME) then
		error(string.format(MSG_INVALID_NAME, name))
	end
end

-- TODO
local function isclass(t)
	-- return type(t) == "table" and 
end

local function findlocalclass(classname)
	local ok, name, value
	for i = 1, math.huge do
		for j = 1, math.huge do
			ok, name, value = pcall(debug.getlocal, i, j)
			if not ok then
				return
			end
			if not name then
				break
			end
			if name == classname and isclass(value) then
				return value
			end
		end
	end
end

local class
class = setmetatable({
	Object = class "Object" {
		instanceof = function (self, cls)
			-- TODO
		end;

		getClass = function (self)
			-- TODO
		end;

		clone = function (self, deep)
			-- TODO
		end;
	};

	Class = class "Class" {
		getMeta = function (self, key)
			-- TODO
		end;
	}
}, {
	__call = function (self, data)
		local datatype = type(data)
		if datatype == "string" then
			validatename(data)
			-- TODO
		elseif datatype == "table" then
			-- TODO
		else
			error(MSG_INVALID_ARGUMENT_TYPE)
		end
	end;

	__index = function (self, key)
		if key == STRING_EXTENDS then
			-- TODO
		else
			local cls = findlocalclass(key)
			if not cls then
				error(string.format(MSG_LOCAL_CLASS_NOT_FOUND, key))
			end
			-- TODO
		end
	end;
})

return class
