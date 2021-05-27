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

Type = {

	INSTANCE = 0;
	CLASS = 1;
	TRAIT = 2;

	find = function (name)
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

	create = function (descriptor)
		local className = Util.__lastTypeName
		_G[className] = setmetatable(descriptor, {
			__index = _G[className];
			__call = function (...)
				local object = setmetatable({}, {__index = descriptor})
				if descriptor.constructor then
					descriptor.constructor(object, table.unpack(table.slice({...}, 2)))
				end
				object.__meta = {
					type = Type.INSTANCE
				}
				return object
			end
		})
		Util.__lastTypeName = nil
	end;

	getNameFromEnum = function (value)
		return switch (entityType) {
			[Type.CLASS] = "class";
			[Type.TRAIT] = "trait";
		}
	end;

	Check = {

		name = function (entityType, name)
			if not name:match("^[a-zA-Z][a-zA-Z0-9]*$") then
				error("Cannot declare "..Util.getNameFromEnum(entityType)..". Name \""..name.."\" contains invalid characters")
			end
		end;

		absence = function (entityType, name)
			if Type.find(name) then
				error("Cannot declare "..Util.getNameFromEnum(entityType)..". Variable with name \""..name.."\" already exists")
			end
		end;
	}
}

Object = {

	__meta = {
		name = "Object"
	};

	instanceof = function (self, classname)
		if not classname then
			error "Supplied argument is nil"
		end
		local ref = Util.findType(classname)
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

function class(name)
	Util.checkTypeName(Type.CLASS, name)
	Util.checkTypeExistance(Type.CLASS, name)
	_G[name] = setmetatable({__meta = {name = name}}, {__index = Object})
	local classref = _G[name]
	Util.__lastTypeName = name
	return Util.createClass
end

function extends(className)
	local parentClass = Util.findType(className)
	if not parentClass then
		error("Cannot find class \""..className.."\"")
	end
	local currentClass = _G[Util.__lastTypeName]
	currentClass.__meta.parent = parentClass
	_G[Util.__lastTypeName] = setmetatable(currentClass, {__index = parentClass})
	return Util.createClass
end

function switch(variable)
	return function (map)
		for case, value in pairs(map) do
			local matches = false
			if type(case) == "table" and (not case.__meta or case.__meta.type ~= Type.INSTANCE) then
				for k, v in pairs(case) do
					if v == variable then
						matches = true
						break
					end
				end
			else
				matches = variable == case
			end
			if matches then
				if type(value) == "function" then
					return value()
				else
					return value
				end
			end
		end
	end
end

function trait(name)
	Util.checkTypeName(Type.TRAIT, name)
	Util.checkTypeExistance(Type.TRAIT, name)
	return function (descriptor)
		descriptor.__meta = {
			name = name;
			type = Type.TRAIT;
		}
		_G[name] = descriptor
	end
end

-- TODO
function uses(...) end

class "Class" {

	ref = nil;

	constructor = function (self, ref)
		if not ref then
			error("Class reference cannot be nil")
		end
		self.ref = Util.findType(ref)
		if not self.ref then
			error("Cannot find class \""..ref.."\"")
		end
	end;

	getMeta = function (self, key)
		if key then
			return self.ref.__meta[key]
		else
			return self.ref.__meta
		end
	end;

	getParent = function (self)
		return self:getMeta("parent")
	end;

	getName = function (self)
		return self:getMeta("name")
	end;

	getTraits = function (self)
		return self:getMeta("traits")
	end;
}
