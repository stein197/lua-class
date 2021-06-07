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

local __lastType = nil

local function deleteLastType()
	Type.delete(__lastType)
	__lastType = nil
end

local function getTypeNameFromEnum(value)
	return switch (value) {
		[Type.INSTANCE] = "instance";
		[Type.CLASS] = "class";
	}
end;


local function getDeclarationMessageError(entityType, name)
	return "Cannot declare "..getTypeNameFromEnum(entityType).." \""..name.."\""
end

local function concatSentenceList(...)
	local sentenceList = {...}
	for i, sentence in pairs(sentenceList) do
		sentenceList[i] = sentence:gsub("^%s*([a-z])", function (fChar)
			return fChar:upper()
		end)
	end
	return table.concat(sentenceList, ". ")
end

local function checkTypeName(entityType, name)
	if not name:match("^[a-zA-Z][a-zA-Z0-9]*$") then
		error(concatSentenceList(getDeclarationMessageError(entityType, name), "The name contains invalid characters"))
	end
end

local function checkTypeAbsence(entityType, name)
	local foundType = Type.find(name)
	if foundType then
		local errMsg = getDeclarationMessageError(entityType, name)
		if type(foundType) == "table" and foundType.__meta and foundType.__meta.type then
			error(concatSentenceList(errMsg, getTypeNameFromEnum(foundType.__meta.type).." with this name already exists"))
		else
			error(concatSentenceList(errMsg, "Global variable with this name already exists"))
		end
	end
end

local function checkTypeMetaAbsence(entityType, name, descriptor)
	if descriptor.__meta then
		deleteLastType()
		error(concatSentenceList(getDeclarationMessageError(entityType, name), "Declaration of field \"__meta\" is not allowed"))
	end
end

local function typeDecriptorHandler(descriptor)
	local meta = __lastType.__meta
	checkTypeMetaAbsence(meta.type, meta.name, descriptor)
	setmetatable(descriptor, {
		__index = __lastType;
		__call = function (...)
			local object = setmetatable({}, {
				__index = _G[meta.name]
			})
			if descriptor.constructor then
				descriptor.constructor(object, table.unpack(table.slice({...}, 2)))
			end
			object.__meta = {
				type = Type.INSTANCE
			}
			return object
		end
	})
	if descriptor.__meta.parent then
		descriptor.__meta.parent.__meta.children[meta.name] = descriptor
	end
	_G[meta.name] = descriptor
	__lastType = nil
end

Type = {

	INSTANCE = 0;
	CLASS = 1;

	find = function (name)
		local nameType = type(name)
		if nameType ~= "string" and not (nameType == "table" and name.__meta) then
			error "Only strings or direct references are allowed as the only argument"
		end
		if nameType == "string" then
			return _G[name]
		else
			return name
		end
	end;

	delete = function(ref)
		if not ref then
			return
		end
		if type(ref) == "string" then
			ref = _G[ref]
		end
		if not ref or not ref.__meta or not ref.__meta.type or ref.__meta.type == Type.INSTANCE then
			error "Cannot delete variable. It is not a type"
		end
		local typeName = ref.__meta.name
		if ref.__meta.parent then
			ref.__meta.parent.__meta.children[typeName] = nil
		end
		if ref.__meta.children then
			for childName, child in pairs(ref.__meta.children) do
				Type.delete(child.__meta.name)
			end
		end
		_G[typeName] = nil
	end;
}

Object = {

	__meta = {
		name = "Object";
		type = Type.CLASS;
		children = {};
	};

	instanceof = function (self, classname)
		if not classname then
			error "Supplied argument is nil"
		end
		local ref = Type.find(classname)
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
	checkTypeName(Type.CLASS, name)
	checkTypeAbsence(Type.CLASS, name)
	local ref = setmetatable({
		__meta = {
			name = name;
			type = Type.CLASS;
			parent = Object;
		}
	}, {
		__index = Object
	})
	_G[name] = ref
	__lastType = ref
	return typeDecriptorHandler
end

function extends(...)
	local lastType = __lastType
	local typeList = {...}
	local className = typeList[1]
	local parent = Type.find(className)
	if not parent then
		deleteLastType()
		error("Cannot find class \""..className.."\"")
	end
	if parent.__meta.type ~= Type.CLASS then
		deleteLastType()
		error("Class cannot extend "..getTypeNameFromEnum(parent.__meta.type).." \""..className.."\"")
	end
	lastType.__meta.parent = parent
	_G[lastType.__meta.name] = setmetatable(lastType, {
		__index = parent
	})
	if not parent.__meta.children then
		parent.__meta.children = {}
	end
	return typeDecriptorHandler
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
		if map[default] then
			local defaultBranch = map[default]
			if type(defaultBranch) == "function" then
				return defaultBranch()
			else
				return defaultBranch
			end
		end
	end
end

function default() end
function null() end

class 'TypeBase' {

	ref = nil;

	getMeta = function (self, key)
		if key then
			return self.ref.__meta[key]
		else
			return self.ref.__meta
		end
	end;

	getName = function (self)
		return self:getMeta("name")
	end;
}

class "Class" extends 'TypeBase' {

	constructor = function (self, ref)
		if not ref then
			error "Class reference cannot be nil"
		end
		self.ref = Type.find(ref)
		if not self.ref then
			error("Cannot find class \""..ref.."\"")
		end
	end;

	getParent = function (self)
		return self:getMeta("parent")
	end;

	getChildren = function (self)
		return self:getMeta("children")
	end;
}
