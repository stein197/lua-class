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
		if not classname then
			error "Supplied argument is nil"
		end
		local ref = ClassUtil.findType(classname)
		if not ref then
			if type(classname) == "string" then
				error("Cannot find class \""..classname.."\"")
			else
				error("Cannot find class")
			end
		end
		local metaTable = getmetatable(self)
		while metaTable ~= nil and metaTable.__index ~= ref do
			metaTable = getmetatable(metaTable.__index)
		end
		return metaTable ~= nil
	end;

	getClass = function (self)
		local metatable = getmetatable(self)
		if metatable then
			return metatable.__index
		end
		return nil
	end;
}

ClassUtil = {

	__currentClassName = nil;

	findType = function (name)
		local nameType = type(name)
		local ref
		if nameType == "string" then
			ref = _G[name]
		elseif nameType == "table" then
			ref = name
		else
			error("Classname \""..name.."\" is not a string nor a table")
		end
		if not ref or not ref.__meta then
			return nil
		end
		return ref
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
	if ClassUtil.findType(name) then
		error("Cannot declare class. Variable or class with name \""..name.."\" already exists")
	end
	_G[name] = setmetatable({__meta = {name = name}}, {__index = Object})
	local classref = _G[name]
	ClassUtil.__currentClassName = name
	return ClassUtil.createClass
end

function extends(className)
	local parentClass = ClassUtil.findType(className)
	if not parentClass then
		error("Cannot find class \""..className.."\"")
	end
	local currentClass = _G[ClassUtil.__currentClassName]
	currentClass.__meta.parent = parentClass
	_G[ClassUtil.__currentClassName] = setmetatable(currentClass, {__index = parentClass})
	return ClassUtil.createClass
end

class "Class" {

	ref = nil;

	constructor = function (self, ref)
		if not ref then
			error("Class reference cannot be nil")
		end
		self.ref = ClassUtil.findType(ref)
		if not self.ref then
			error("Cannot find class \""..ref.."\"")
		end
	end;

	getMeta = function (self, key)
		return key and self.ref.__meta[key] or self.ref.__meta
	end;

	getParent = function (self)
		return self:getMeta("parent")
	end;

	getName = function (self)
		return self:getMeta("name")
	end;
}
