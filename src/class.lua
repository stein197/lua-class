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

	__last = nil;

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

	descriptorHandler = function (descriptor)
		local meta = Type.__last.__meta
		switch (meta.type) {
			[Type.CLASS] = function ()
				_G[meta.name] = setmetatable(descriptor, {
					__index = _G[meta.name];
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
				local ref = _G[meta.name]
				ref.__meta.parent.__meta.children[meta.name] = ref
				if ref.__meta.traits then
					for i, traitRef in pairs(ref.__meta.traits) do
						for mName, m in pairs(traitRef) do
							if not ref[mName] then
								ref[mName] = m
							end
						end
					end
				end
			end;
			[Type.TRAIT] = function ()
				descriptor.__meta = meta
				_G[meta.name] = descriptor
				if meta.traits then
					for tName, t in pairs(meta.traits) do
						for mName, m in pairs(t) do
							if not descriptor[mName] then
								descriptor[mName] = m
							end
						end
					end
				end
			end;
		}
		Type.__last = nil
	end;

	deleteLast = function ()
		_G[Type.__last.__meta.name] = nil
		Type.__last = nil
	end;

	getNameFromEnum = function (value)
		return switch (value) {
			[Type.CLASS] = "class";
			[Type.TRAIT] = "trait";
		}
	end;

	Check = {

		name = function (entityType, name)
			if not name:match("^[a-zA-Z][a-zA-Z0-9]*$") then
				error("Cannot declare "..(Type.getNameFromEnum(entityType))..". Name \""..name.."\" contains invalid characters")
			end
		end;

		absence = function (entityType, name)
			if Type.find(name) then
				error("Cannot declare "..(Type.getNameFromEnum(entityType))..". Variable with name \""..name.."\" already exists") -- TODO: Add type of variable
			end
		end;
	}
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
	Type.Check.name(Type.CLASS, name)
	Type.Check.absence(Type.CLASS, name)
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
	Type.__last = ref
	return Type.descriptorHandler
end

function trait(name)
	Type.Check.name(Type.TRAIT, name)
	Type.Check.absence(Type.TRAIT, name)
	local ref = {
		__meta = {
			name = name,
			type = Type.TRAIT
		}
	}
	_G[name] = ref
	Type.__last = ref
	return Type.descriptorHandler
end

function extends(...)
	local lastType = Type.__last
	local typeList = {...}
	switch (lastType.__meta.type) {
		[Type.CLASS] = function ()
			local className = typeList[1]
			local parent = Type.find(className)
			if not parent then
				Type.deleteLast()
				error("Cannot find class \""..className.."\"")
			end
			if parent.__meta.type ~= Type.CLASS then
				Type.deleteLast()
				error("Class cannot extend "..Type.getNameFromEnum(parent.__meta.type).." \""..className.."\"")
			end
			lastType.__meta.parent = parent
			_G[lastType.__meta.name] = setmetatable(lastType, {
				__index = parent
			})
			if not parent.__meta.children then
				parent.__meta.children = {}
			end
		end;
		[Type.TRAIT] = function ()
			local tList = typeList
			lastType.__meta.traits = {}
			for i, t in pairs(tList) do
				local ref = Type.find(t)
				if not ref then
					Type.deleteLast()
					error("Cannot find trait \""..t.."\"")
				end
				if ref.__meta.type ~= Type.TRAIT then
					Type.deleteLast()
					error("Trait cannot extend "..Type.getNameFromEnum(ref.__meta.name).." \""..t.."\"")
				end
				lastType.__meta.traits[ref.__meta.name] = ref
				if not ref.__meta.children then
					ref.__meta.children = {}
				end
			end
		end;
	}
	return Type.descriptorHandler
end

function uses(...)
	local traitList = {...}
	local lastType = Type.__last
	local lastTypeMeta = lastType.__meta
	if lastTypeMeta.type ~= Type.CLASS then
		Type.deleteLast()
		error("\""..lastTypeMeta.name.."\" is not a class. Only classes can use traits")
	end
	lastTypeMeta.traits = {}
	for i, ref in pairs(traitList) do
		local foundRef = Type.find(ref)
		if not foundRef then
			Type.deleteLast()
			error("Cannot find trait at index "..i)
		end
		if foundRef.__meta.type ~= Type.TRAIT then
			Type.deleteLast()
			error("\""..foundRef.__meta.name.."\" is not a trait")
		end
		lastTypeMeta.traits[foundRef.__meta.name] = foundRef
	end
	return Type.descriptorHandler
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

	getTraits = function (self)
		return self:getMeta("traits")
	end;
}

class "Trait" extends 'TypeBase' {

	constructor = function (self, ref)
		if not ref then
			error "Trait reference cannot be nil"
		end
		self.ref = Type.find(ref)
		if not self.ref then
			error("Cannot find trait \""..ref.."\"")
		end
	end;

	getParent = function (self)
		return self:getMeta("parent")
	end;

	getChildren = function (self)
		return self:getMeta("children")
	end;
}
