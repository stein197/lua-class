function class(name)
	_G[name] = {}
	return function(descriptor)
		descriptor.__extends = {}
		descriptor.__implements = {}
		-- TODO
		function descriptor.instanceof()
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

function extends(classlist)
end

function implements(interfacelist)
end

function new(classname)
	return function(...)
		return _G[classname].new(...)
	end
end
