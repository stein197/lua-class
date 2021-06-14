local function string_split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local function table_clone(tbl)
	if tbl.__meta and tbl.__meta.type == Type.INSTANCE then
		return tbl:clone()
	end
	local clone = {}
	for k, v in pairs(tbl) do
		local vType = type(v)
		local isScalar = vType == "boolean" or vType == "number" or vType == "string"
		if isScalar then
			clone[k] = v
		elseif vType == "table" then
			clone[k] = table_clone(v)
		end
	end
	return clone
end

local __meta = {
	lastType = nil,
	ns = _G
}

local function namespace_get_full_name(ns)
	local result = ns.__meta.name
	local current = ns.__meta.parent
	while current do
		result = current.__meta.name.."."..result
		current = current.__meta.parent
	end
	return result
end

local function resolve_full_name(name)
	if __meta.ns ~= _G then
		return namespace_get_full_name(__meta.ns).."."..name
	end
	return name
end

local function resolve_type_from_string(ref)
	local parts = string_split(ref, ".")
	ref = _G
	for i, part in pairs(parts) do
		ref = ref[part]
		if not ref then
			return nil
		end
	end
	return ref
end

local function delete_last_type()
	Type.delete(__meta.lastType)
	__meta.lastType = nil
end

local function get_type_name_from_enum(value)
	return switch (value) {
		[Type.INSTANCE] = "instance";
		[Type.CLASS] = "class";
		[Type.NAMESPACE] = "namespace";
	}
end;

local function get_declaration_message_error(entityType, name)
	return "Cannot declare "..get_type_name_from_enum(entityType).." \""..resolve_full_name(name).."\""
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
	local regex = "^%a%w*$"
	switch (entityType) {
		[Type.CLASS] = function ()
			if not name:match(regex) then
				error(concat_sentence_list(get_declaration_message_error(entityType, name), "The name contains invalid characters"))
			end
		end;
		[Type.NAMESPACE] = function ()
			local parts = string_split(name, ".")
			for i, part in ipairs(parts) do
				if not part:match(regex) then
					error(concat_sentence_list(get_declaration_message_error(entityType, name), "The name contains invalid characters"))
				end
			end
		end;
	}
end

local function check_type_absence(entityType, name)
	local foundType = Type.find(resolve_full_name(name))
	if foundType then
		local errMsg = get_declaration_message_error(entityType, name)
		if type(foundType) == "table" and foundType.__meta and foundType.__meta.type then
			error(concat_sentence_list(errMsg, get_type_name_from_enum(foundType.__meta.type).." with this name already exists"))
		else
			error(concat_sentence_list(errMsg, "Global variable with this name already exists"))
		end
	end
end

local function check_ns_can_create(name)
	local parts = string_split(name, ".")
	local lastNS = _G
	for i, part in pairs(parts) do
		local lastNS = lastNS[part]
		if not lastNS or type(lastNS) == "table" and lastNS.__meta and lastNS.__meta.type == Type.NAMESPACE then
			return
		end
	end
	error(concat_sentence_list(get_declaration_message_error(Type.NAMESPACE, name), get_type_name_from_enum(lastNS.__meta.type).." with this name already exists"))
end

local function check_ns_nesting(name)
	if __meta.ns ~= _G then
		error(concat_sentence_list(get_declaration_message_error(Type.NAMESPACE, name), "Nesting namespace declarations are not allowed"))
	end
end

local function check_type_field_absence(entityType, name, descriptor, field)
	if descriptor[field] then
		delete_last_type()
		error(concat_sentence_list(get_declaration_message_error(entityType, name), "Declaration of field \""..field.."\" is not allowed"))
	end
end

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

local function check_type_extend_list(entityType, name, extendList)
	for i = 1, #extendList do
		local parent = extendList[i]
		if parent.__meta.type ~= Type.CLASS then
			delete_last_type()
			error(concat_sentence_list(get_declaration_message_error(entityType, name), "Cannot extend "..get_type_name_from_enum(parent.__meta.type).." \""..parent.."\""))
		end
		if parent == __meta.lastType then
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
	local meta = __meta.lastType.__meta
	check_type_field_absence(meta.type, meta.name, descriptor, "__meta")
	check_type_field_absence(meta.type, meta.name, descriptor, "__index")
	setmetatable(descriptor, {
		__index = __meta.lastType;
		__call = function (self, ...)
			local parent = self
			local object = setmetatable({}, {
				__index = parent,
				__newindex = parent["[]"] or parent.__newindex,
				__call = parent["()"] or parent.__call,
				__tostring = parent.__tostring,
				__concat = parent[".."] or parent.__concat,
				__metatable = parent.__metatable,
				__mode = parent.__mode,
				__gc = parent.__gc,
				__len = parent["#"] or parent.__len,
				__pairs = parent.__pairs,
				__ipairs = parent.__ipairs,
				__add = parent["+"] or parent.__add,
				__sub = parent["-"] or parent.__sub,
				__mul = parent["*"] or parent.__mul,
				__div = parent["/"] or parent.__div,
				__pow = parent["^"] or parent.__pow,
				__mod = parent["%"] or parent.__mod,
				__idiv = parent["//"] or parent.__idiv,
				__eq = parent["=="] or parent.__eq,
				__lt = parent["<"] or parent.__lt,
				__le = parent["<="] or parent.__le,
				__band = parent["&"] or parent.__band,
				__bor = parent["|"] or parent.__bor,
				__bxor = parent["~"] or parent.__bxor,
				__bnot = parent["not"] or parent.__bnot,
				__shl = parent["<<"] or parent.__shl,
				__shr = parent[">>"] or parent.__shr
			})
			if descriptor.constructor then
				descriptor.constructor(object, table.unpack({...}))
			end
			object.__meta = {
				type = Type.INSTANCE,
				class = descriptor
			}
			return object
		end
	})
	for parentName, parent in pairs(__meta.lastType.__meta.parents) do
		parent.__meta.children[meta.name] = descriptor
	end
	__meta.ns[meta.name] = descriptor
	__meta.lastType = nil
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
	NAMESPACE = 2;

	find = function (ref)
		local refType = type(ref)
		if refType ~= "string" and not (refType == "table" and ref.__meta) then
			error "Only strings or direct references are allowed as the only argument"
		end
		if refType == "string" then
			return resolve_type_from_string(ref)
		end
		return ref
	end;

	-- TODO: But it does not delete from instances
	delete = function(ref)
		if not ref then
			return
		end
		if type(ref) == "string" then
			ref = resolve_type_from_string(ref)
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

	clone = function (self)
		local clone = setmetatable({}, getmetatable(self))
		for k, v in pairs(self) do
			local vType = type(v)
			local isScalar = vType == "boolean" or vType == "number" or vType == "string"
			if isScalar or k == "__meta" then
				clone[k] = v
			elseif vType == "table" then
				clone[k] = table_clone(v)
			end
		end
		return clone
	end;

	getClass = function (self)
		return self.__meta.class
	end;
}

function class(name)
	check_type_name(Type.CLASS, name)
	check_type_absence(Type.CLASS, name)
	local ns = __meta.ns
	if ns == _G then
		ns = nil
	end
	local ref = setmetatable({
		__meta = {
			name = name,
			type = Type.CLASS,
			namespace = ns,
			parents = {
				Object = Object
			}
		}
	}, {
		__index = type_index
	})
	__meta.ns[name] = ref
	__meta.lastType = ref
	return type_descriptor_handler
end

function extends(...)
	local parents = {}
	local extendList = resolve_type_extend_list(Type.CLASS, __meta.lastType.__meta.name, {...})
	check_type_extend_list(Type.CLASS, __meta.lastType.__meta.name, extendList)
	for i, parent in pairs(extendList) do
		parents[parent.__meta.name] = parent
		if not parent.__meta.children then
			parent.__meta.children = {}
		end
	end
	__meta.lastType.__meta.parents = parents
	setmetatable(__meta.lastType, {
		__index = type_index
	})
	return type_descriptor_handler
end

function namespace(name)
	check_type_name(Type.NAMESPACE, name)
	check_ns_can_create(name)
	check_ns_nesting(name)
	local nameParts = string_split(name, ".")
	local lastRef = _G
	for i, part in ipairs(nameParts) do
		if not lastRef[part] then
			local parent = lastRef
			if lastRef == _G then
				parent = nil
			end
			lastRef[part] = {
				__meta = {
					name = part,
					parent = parent,
					type = Type.NAMESPACE
				}
			}
		end
		lastRef = lastRef[part]
	end
	__meta.ns = lastRef
	return function (descriptor)
		check_type_field_absence(Type.NAMESPACE, name, descriptor, "__meta")
		check_type_field_absence(Type.NAMESPACE, name, descriptor, "__index")
		for k, v in pairs(descriptor) do
			if type(k) == "string" then
				lastRef[k] = v
			end
		end
		__meta.ns = _G
	end
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

function try(f)
	if type(f) == "table" then
		f = f[1]
	end
	local silent, result = pcall(f)
	return TryCatchFinally(silent, result)
end

function default() end
function null() end -- TODO: Delete?

class 'TryCatchFinally' {

	silent = nil;
	result = nil;
	caught = false;

	constructor = function (self, silent, result)
		self.silent = silent
		self.result = result
	end;
	
	catch = function (self, f)
		if self.caught then
			error "Cannot call catch twice"
		end
		self.caught = true
		if not self.silent then
			if type(f) == "table" then
				f = f[1]
			end
			self.result = f(self.result)
		end
		return self
	end;

	finally = function (self, f)
		if type(f) == "table" then
			f = f[1]
		end
		return f(self.result)
	end;
}

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

	getName = function (self)
		if self.ref.__meta.namespace then
			return namespace_get_full_name(self.ref.__meta.namespace).."."..self.ref.__meta.name
		else
			return self.ref.__meta.name
		end
	end;

	delete = function (self)
		Type.delete(self)
	end;
}

class "Class" extends 'TypeBase' {}
