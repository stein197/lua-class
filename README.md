# Lua class library
## Basic concepts
Sometimes there is a need to use classes in language that does not support them at all. Fortunately, lua allows us to use some sort of object-oriented paradigm by its dynamic nature. This simple lua package allows to use object-oriented paradigm by using usual keyword `class`.

![](syntax.svg)

## Usage
```lua
local class = require "lua-class"

return class "A" {}
return class "B" : A -- Slow, because it iterates through local variables
return class "C" : extends (A, B) {}
return class {}
return class : A {} -- Slow, because it iterates through local variables
return class : extends (A, B) {}

local o = class.Object()
o:instanceof(class.Object)
o:clone()
local c = o:getClass()

c:getName()
c:getMeta()

```

## Testing
To run tests, call from terminal `.\test.bat` for Windows and `./test.sh` for Linux
You can pass an argument to tests to define memory test iterations count like this - `test 1024`