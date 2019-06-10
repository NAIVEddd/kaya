require('token')
Lex = { index = 1 }

function Lex:new(file)
    o = {}
    setmetatable(o, self)
    self.__index = self
    o.file = file
    return o
end

function Lex:tokenlist()
    local file = io.open(self.file, "r")
    local content = file:read('*a')
    local count = 1
    local list = {}
    for word in string.gmatch(content, "[%a%p%d]+") do
        list[count] = Token:new(count, word)
        count = count + 1
    end
    list.index = 1
    return list
end
