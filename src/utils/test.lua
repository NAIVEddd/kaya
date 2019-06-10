require('lex')
require('parse')
require('semant')
require('debug')

l = Lex:new('../../test/test1.tig')
list = l:tokenlist()
-- for _, tk in ipairs(list) do
--     print(tk.name)
-- end

-- tk = list[1]
-- print(tk.name, tk:kind())

function pt(tab)
    for k, v in pairs(tab) do
        print(k, v)
        if type(v) == 'table' then
            pt(v)
        end
    end
end

_, expr = ParseExp(list, 1)
transExp({}, {}, {}, expr)
