Object = {
	__lastclassdefinition = "";
	__extends = {};
	__implements = {};
	instanceof = function()
	end;
	clone = function()
	end;
	new = function(...)
	end
}

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

function interface(name) end
function trait(name) end
function enum(name) end
function implements(list) end

function extends(classname)
	-- if classname:len() == 0 then error
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
