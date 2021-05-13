require "util"

Object = {
	__lastclassdefinition = "";
	instanceof = function ()
	end;
	clone = function ()
	end;
	new = function(...)
	end
}

function namespace(name)
	if _G[name] then
		return
	end
	_G[name] = {}
end

function import(path)
	return require(path:gsub("%.", "/"))
end

function class(name)
	_G[name] = setmetatable({}, {__index = Object})
	Object.__lastclassdefinition = name
	return function(descriptor)
		if not descriptor then
			return
		end
		function descriptor.new(...)
			local object = {}
			if descriptor.constructor then
				descriptor.constructor(object, ...)
			end
			return setmetatable(object, {__index = descriptor})
		end
		for k, v in pairs(descriptor) do
			_G[name][k] = v
		end
	end
end

function interface(name) end -- TODO
function trait(name) end -- TODO
function enum(name) end -- TODO
function implements(list) end -- TODO

function extends(classname)
	_G[Object.__lastclassdefinition] = setmetatable(_G[Object.__lastclassdefinition], _G[classname])
	return function(descriptor)
		function descriptor.new(...)
			local object = {}
			if descriptor.constructor then
				descriptor.constructor(object, ...)
			end
			return setmetatable(object, {__index = descriptor})
		end
		for k, v in pairs(descriptor) do
			_G[Object.__lastclassdefinition][k] = v
		end
	end
end

local function createdescriptor(descriptor) end -- TODO

local function identifierisvalid(identifier, includedots)
	local pattern
	if includedots then
		pattern = "^[a-zA-Z][a-zA-Z0-9%.]+$"
	else
		pattern = "^[a-zA-Z][a-zA-Z0-9]+$"
	end
	return identifier:match(pattern)
end
