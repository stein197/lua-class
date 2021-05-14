-- TODO: Use: debug and debug.getInfo, __index for _G, setfenv
require "util"

Object = {
	__currentclass = nil;
	__currentnamespace = _G;
	instanceof = function (self, classname)
		local classref
		local classtype = type(classname)
		if classtype == "string"
			classref = getclassbyname(classname)
		elseif classtype == "table"
			classref = classname
		else
			error "Classname \""..classname.."\" is not a string or table"
		end
		
	end;
	clone = function ()
	end;
	new = function(...)
	end
}

-- Creates a namespace or switches between them
function namespace(name)
	if name:len() == 0 then
		Object.__currentnamespace = _G
		return
	end
	if not identifierisvalid(name) then
		error "Namespace \""..name.."\" contains invalid characters"
	end
	local parts = name:split(".")
	local currentnamespace = _G
	for k, v in pairs(parts) do
		if not currentnamespace[v] then
			currentnamespace[v] = {}
		end
		currentnamespace = currentnamespace[v]
		if type(currentnamespace) ~= "table" then
			error "Cannot define a namespace \""..name.."\". Key \""..v.."\" exists and it is not a table"
		end
	end
	Object.__currentnamespace = currentnamespace
end

function class(name)
	if not identifierisvalid(name) then
		error "Classname \""..name.."\" contains invalid characters"
	end
	Object.__currentnamespace[name] = setmetatable({}, {__index = Object})
	Object.__currentclass = name
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
function try() end -- TODO
function catch() end -- TODO
function throw(message) end -- TODO

function extends(classname)
	_G[Object.__currentclass] = setmetatable(_G[Object.__currentclass], _G[classname])
	return function(descriptor)
		function descriptor.new(...)
			local object = {}
			if descriptor.constructor then
				descriptor.constructor(object, ...)
			end
			return setmetatable(object, {__index = descriptor})
		end
		for k, v in pairs(descriptor) do
			_G[Object.__currentclass][k] = v
		end
	end
end

local function createdescriptor(descriptor) end -- TODO

local function getclass(name)
	local classtype = type(name)
	if classtype == "string" then
		local parts = name:split(".")
		local nsparts = table.slice(parts, 1, -2)
		local classname = table.slice(parts, -1)
		local currentnamespace = Object.__currentnamespace
		for i, ns in pairs(nsparts) do
			currentnamespace = currentnamespace[ns]
			if not currentnamespace then
				return nil
			end
		end
		if not currentnamespace[classname] then
			currentnamespace = _G
			for i, ns in pairs(nsparts) do
				currentnamespace = currentnamespace[ns]
				if not currentnamespace then
					return nil
				end
			end
		end
		return currentnamespace[classname]
	elseif classtype == "table" then
		return classname
	else
		error "Classname \""..name.."\" is not a string nor a table"
	end
end

local function identifierisvalid(identifier, includedots)
	local pattern
	if includedots then
		pattern = "^[a-zA-Z][a-zA-Z0-9%.]+$"
	else
		pattern = "^[a-zA-Z][a-zA-Z0-9]+$"
	end
	return identifier:match(pattern)
end
