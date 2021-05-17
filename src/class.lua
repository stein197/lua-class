-- TODO: Use: debug and debug.getInfo, __index for _G, setfenv, add new() and clone()
function string.split(self, separator)
	separator = separator or "%s"
	local parts = {}
	for part in self:gmatch("([^"..separator.."]*)") do
		table.insert(parts, part)
	end
	return parts
end

function table.slice(tbl, from, to)
	local sliced = {}
	from = from or 1
	to = to or #tbl
	if from < 0 then
		from = #tbl + from + 1
	end
	if to < 0 then
		to = #tbl + to + 1
	end
	for i = from, to do
		table.insert(sliced, tbl[i])
	end
	return sliced
end

Object = {
	__currentclassname = nil;
	__currentnamespace = _G;

	instanceof = function (self, classname)
		local classref = Object.getclass(classname)
		local metatable = getmetatable(self)
		while metatable ~= nil and metatable.__index ~= classref do
			metatable = getmetatable(metatable)
		end
		return metatable ~= nil
	end;

	nameisvalid = function (identifier, includedots)
		local pattern
		if includedots then
			pattern = "^[a-zA-Z][a-zA-Z0-9%.]*$"
		else
			pattern = "^[a-zA-Z][a-zA-Z0-9]*$"
		end
		return identifier:match(pattern)
	end;

	getcurrentclass = function ()
		return Object.__currentnamespace[Object.__currentclassname]
	end;

	-- Returns class by name
	-- If name is string it resolves relatively to current namespace,
	-- then relative to global space
	getclass = function (name)
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
			return name
		else
			error("Classname \""..name.."\" is not a string nor a table")
		end
	end;

	-- TODO: __call metamethod
	createdescriptor = function (descriptor)
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
		-- local currentclass = Object.getcurrentclass()
		-- for k, v in pairs(descriptor) do
		-- 	currentclass[k] = v
		-- end
	end
}

-- Creates a namespace or switches between them
function namespace(name)
	if name:len() == 0 then
		Object.__currentnamespace = _G
		return
	end
	if not Object.nameisvalid(name, true) then
		error("Namespace \""..name.."\" contains invalid characters")
	end
	local parts = name:split(".")
	local currentnamespace = _G
	for k, v in pairs(parts) do
		if not currentnamespace[v] then
			currentnamespace[v] = {}
		end
		currentnamespace = currentnamespace[v]
		if type(currentnamespace) ~= "table" then
			error("Cannot define a namespace \""..name.."\". Key \""..v.."\" already exists")
		end
	end
	Object.__currentnamespace = currentnamespace
end

function class(name)
	if not Object.nameisvalid(name) then
		error("Classname \""..name.."\" contains invalid characters")
	end
	if Object.getclass(name) then
		error("Cannot override existing class \""..name.."\"")
	end
	Object.__currentnamespace[name] = setmetatable({}, {__index = Object})
	Object.__currentclassname = name
	return Object.createdescriptor
end

function extends(classname)
	Object.__currentnamespace[Object.__currentclassname] = setmetatable(Object.getcurrentclass(), {__index = Object.getclass(classname)})
	return Object.createdescriptor
end
