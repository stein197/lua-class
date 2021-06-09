local function table_slice(tbl, from, to)
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

local function delete_last_type()
	Type.delete(__lastType)
	__lastType = nil
end

local function get_type_name_from_enum(value)
	return switch (value) {
		[Type.INSTANCE] = "instance";
		[Type.CLASS] = "class";
	}
end;

local function get_declaration_message_error(entityType, name)
	return "Cannot declare "..get_type_name_from_enum(entityType).." \""..name.."\""
end

local function concat_sentence_list(...)
	local sentenceList = {...}
	for i, sentence in pairs(sentenceList) do
		sentenceList[i] = sentence:gsub("^%s*([a-z])", function (fChar)
			return fChar:upper()
		end)
	end
	return table.concat(sentenceList, ". ")
end

local function check_type_name(entityType, name)
	if not name:match("^[a-zA-Z][a-zA-Z0-9]*$") then
		error(concat_sentence_list(get_declaration_message_error(entityType, name), "The name contains invalid characters"))
	end
end

local function check_type_absence(entityType, name)
	local foundType = Type.find(name)
	if foundType then
		local errMsg = get_declaration_message_error(entityType, name)
		if type(foundType) == "table" and foundType.__meta and foundType.__meta.type then
			error(concat_sentence_list(errMsg, get_type_name_from_enum(foundType.__meta.type).." with this name already exists"))
		else
			error(concat_sentence_list(errMsg, "Global variable with this name already exists"))
		end
	end
end

local function check_type_meta_absence(entityType, name, descriptor)
	if descriptor.__meta then
		delete_last_type()
		error(concat_sentence_list(get_declaration_message_error(entityType, name), "Declaration of field \"__meta\" is not allowed"))
	end
end

-- TODO
local function check_type_not_deriving(entityType, name, typeA, typeB)
	local parents = {
		typeA
	}
	while #parents > 0 do
		local parent = parents[#parents]
		if parent == typeB then
			delete_last_type()
			error(concat_sentence_list(get_declaration_message_error(entityType, name), "Class \""..typeB.__meta.name.."\" is already a base of class \""..typeA.__meta.name.."\""))
		end
		table.remove(parents, #parents)
		local parentBaseList = parent.__meta.parents
		if parentBaseList then
			for k, v in pairs(parentBaseList) do
				table.insert(parents, v)
			end
		end
	end
end

-- TODO: Check if child derives already derived class (like C extends A -> D extends C,A)
local function check_type_extend_list(entityType, name, extendList)
	for i = 1, #extendList do
		local parent = extendList[i]
		if parent.__meta.type ~= Type.CLASS then
			delete_last_type()
			error(concat_sentence_list(get_declaration_message_error(entityType, name), "Cannot extend "..get_type_name_from_enum(parent.__meta.type).." \""..parent.."\""))
		end
		if parent == __lastType then
			delete_last_type()
			error(concat_sentence_list(get_declaration_message_error(entityType, name), "Class cannot extend itself"))
		end
		for j = i, #extendList do
			if i == j then
				goto continue
			end
			local compareParent = extendList[j]
			check_type_not_deriving(entityType, name, parent, compareParent)
			check_type_not_deriving(entityType, name, compareParent, parent)
			::continue::
		end
	end
end

local function resolve_type_extend_list(entityType, name, extendList)
	local parentList = {}
	for i, parent in pairs(extendList) do
		local parentRef = Type.find(parent)
		if not parentRef then
			delete_last_type()
			error(concat_sentence_list(get_declaration_message_error(entityType, name), "Cannot find "..get_type_name_from_enum(entityType).." \""..parent.."\""))
		end
		table.insert(parentList, parentRef)
	end
	return parentList
end

local function type_descriptor_handler(descriptor)
	local meta = __lastType.__meta
	check_type_meta_absence(meta.type, meta.name, descriptor)
	setmetatable(descriptor, {
		__index = __lastType;
		__call = function (...)
			local object = setmetatable({}, {
				__index = _G[meta.name]
			})
			if descriptor.constructor then
				descriptor.constructor(object, table.unpack(table_slice({...}, 2)))
			end
			object.__meta = {
				type = Type.INSTANCE,
				class = descriptor
			}
			return object
		end
	})
	for parentName, parent in pairs(__lastType.__meta.parents) do
		parent.__meta.children[meta.name] = descriptor
	end
	_G[meta.name] = descriptor
	__lastType = nil
end

local function type_index(self, key)
	local baseClasses = self.__meta.parents
	for name, ref in pairs(baseClasses) do
		local m = ref[key]
		if m then
			-- self[key] = m -- TODO: Need save?
			return m
		end
	end
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

	-- TODO: But it does not delete from instances
	delete = function(ref)
		if not ref then
			return
		end
		if type(ref) == "string" then
			ref = _G[ref]
		end
		if ref == Object then
			error "Deleting \"Object\" class is not allowed"
		end
		if not ref or not ref.__meta or not ref.__meta.type or ref.__meta.type == Type.INSTANCE then
			error "Cannot delete variable. It is not a type"
		end
		local typeName = ref.__meta.name
		for parentName, parent in pairs(ref.__meta.parents) do
			parent.__meta.children[typeName] = nil
			if #parent.__meta.children == 0--[[  and parent ~= Object ]] then
				-- TODO: It throws error sometimes
				-- parent.__meta.children = nil
			end
		end
		if ref.__meta.children then
			for childName, child in pairs(ref.__meta.children) do
				Type.delete(child)
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
		local parents = {
			self.__meta.class
		}
		while #parents > 0 do
			local parent = parents[#parents]
			if parent == ref then
				break
			end
			table.remove(parents, #parents)
			local parentBaseList = parent.__meta.parents
			if parentBaseList then
				for k, v in pairs(parentBaseList) do
					table.insert(parents, v)
				end
			end
		end
		return #parents > 0
	end;

	getClass = function (self)
		return self.__meta.class
	end;
}

function class(name)
	check_type_name(Type.CLASS, name)
	check_type_absence(Type.CLASS, name)
	local ref = setmetatable({
		__meta = {
			name = name,
			type = Type.CLASS,
			parents = {
				Object = Object
			}
		}
	}, {
		__index = type_index
	})
	_G[name] = ref
	__lastType = ref
	return type_descriptor_handler
end

function extends(...)
	local parents = {}
	local extendList = resolve_type_extend_list(Type.CLASS, __lastType.__meta.name, {...})
	check_type_extend_list(Type.CLASS, __lastType.__meta.name, extendList)
	for i, parent in pairs(extendList) do
		parents[parent.__meta.name] = parent
		if not parent.__meta.children then
			parent.__meta.children = {}
		end
	end
	__lastType.__meta.parents = parents
	setmetatable(__lastType, {
		__index = type_index
	})
	return type_descriptor_handler
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
function null() end -- TODO: Delete

class 'TypeBase' {

	ref = nil;

	constructor = function (self, ref)
		if not ref then
			error "Type reference cannot be nil"
		end
		self.ref = Type.find(ref)
		if not self.ref then
			error("Cannot find type \""..ref.."\"")
		end
	end;

	getMeta = function (self, key)
		if key then
			return self.ref.__meta[key]
		else
			return self.ref.__meta
		end
	end;

	delete = function (self)
		Type.delete(self)
	end;
}

class "Class" extends 'TypeBase' {}
