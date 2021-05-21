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

	__meta = {
		name = "Object"
	};

	instanceof = function (self, classname)
		local classref = ClassUtil.findClass(classname)
		local metatable = getmetatable(self)
		while metatable ~= nil and metatable.__index ~= classref do
			metatable = getmetatable(metatable.__index)
		end
		return metatable ~= nil
	end;

	getClass = function (self)
		local metatable = getmetatable(self)
		if metatable then
			return metatable.__index
		end
		return nil
	end;

	getMeta = function (name)
		return name and Object.__meta[name] or Object.__meta
	end;
}

ClassUtil = {

	__currentClassName = nil;

	findClass = function (name)
		local classtype = type(name)
		if classtype == "string" then
			return _G[name]
		elseif classtype == "table" then
			return name
		else
			error("Classname \""..name.."\" is not a string nor a table")
		end
	end;
	
	createClass = function (descriptor)
		local className = ClassUtil.__currentClassName
		_G[className] = setmetatable(descriptor, {
			__index = _G[className];
			__call = function (...)
				local object = setmetatable({}, {__index = descriptor})
				if descriptor.constructor then
					descriptor.constructor(object, table.unpack(table.slice({...}, 2)))
				end
				function object.getMeta()
					return object.__meta
				end
				object.__meta = {}
				return object
			end
		})
	end;

	Naming = {

		isValid = function (identifier, includedots)
			local pattern
			if includedots then
				pattern = "^[a-zA-Z][a-zA-Z0-9%.]*$"
			else
				pattern = "^[a-zA-Z][a-zA-Z0-9]*$"
			end
			return identifier:match(pattern)
		end;
	};
}

function class(name)
	if not ClassUtil.Naming.isValid(name) then
		error("Cannot declare class. Classname \""..name.."\" contains invalid characters")
	end
	if ClassUtil.findClass(name) then
		error("Cannot declare class. Variable or class with name \""..name.."\" already exists")
	end
	_G[name] = setmetatable({__meta = {name = name}}, {__index = Object})
	local classref = _G[name]
	function classref.getMeta(prop)
		return prop and classref.__meta[prop] or classref.__meta
	end
	ClassUtil.__currentClassName = name
	return ClassUtil.createClass
end

function extends(className)
	local parentClass = ClassUtil.findClass(className)
	if not parentClass then
		error("Cannot find class \""..className.."\"")
	end
	local currentClass = _G[ClassUtil.__currentClassName]
	currentClass.__meta.extends = parentClass
	_G[ClassUtil.__currentClassName] = setmetatable(currentClass, {__index = parentClass})
	return ClassUtil.createClass
end
