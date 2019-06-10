require('expr')

function ptb(tab)
    for k, v in pairs(tab) do print(k, v) end
end
function Expect(tklist, index, str)
    if tklist[index].name == str then
        return index + 1
    else
        error("Expected " .. str)
    end
end
function ParseExp(tklist, index)
    token = tklist[index]
    kind = token:kind()
    local exp = {}
    if kind == 'none' then
        void = {}
    elseif kind == 'int' then
        exp = A_exp:intexp(tonumber(token.name))
        index = index + 1
    elseif kind == 'string' then
        exp = A_exp:strexp(token.name)
        index = index + 1
    elseif kind == 'nil' then
        exp = A_exp:nilexp()
        index = index + 1
    elseif kind == 'let' then
        index, exp = ParseLet(tklist, index)
    elseif kind == 'while' then
        index, exp = ParseWhile(tklist, index)
    elseif kind == 'for' then
        index, exp = ParseFor(tklist, index)
    elseif kind == 'if' then
        index, exp = ParseIf(tklist, index)
    elseif kind == 'lparen' then
        index = Expect(tklist, index, '(')
        index, exp = ParseExpSeq(tklist, index, ";", ")")
        index = Expect(tklist, index, ')')
        exp = A_exp:seqexp(exp)
    elseif kind == 'id' then
        index, exp = ParseIdExp(tklist, index)
    end

    if not tklist[index] then
        return index, exp
    end

    token = tklist[index]
    kind = token:kind()
    local exp2={}
    if kind == 'or' then
        index = Expect(tklist, index, '||')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:ifexp(exp, A_exp:intexp(1), exp2)
    elseif kind == 'and' then
        index = Expect(tklist, index, '&&')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:ifexp(exp, exp2, A_exp:intexp(0))
    elseif kind == 'lt' then
        index = Expect(tklist, index, '<')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('<', exp, exp2)
    elseif kind == 'gt' then
        index = Expect(tklist, index, '>')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('>', exp, exp2)
    elseif kind == 'le' then
        index = Expect(tklist, index, '<=')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('<=', exp, exp2)
    elseif kind == 'ge' then
        index = Expect(tklist, index, '>=')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('>=', exp, exp2)
    elseif kind == 'eq' then
        index = Expect(tklist, index, '=')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('=', exp, exp2)
    elseif kind == 'neq' then
        index = Expect(tklist, index, '<>')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('<>', exp, exp2)
    elseif kind == 'plus' then
        index = Expect(tklist, index, '+')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('+', exp, exp2)
    elseif kind == 'minus' then
        index = Expect(tklist, index, '-')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('-', exp, exp2)
    elseif kind == 'times' then
        index = Expect(tklist, index, '*')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('*', exp, exp2)
    elseif kind == 'divide' then
        index = Expect(tklist, index, '/')
        index, exp2 = ParseExp(tklist, index)
        exp = A_exp:opexp('/', exp, exp2)
    end
    return index, exp
end

function ParseLet(list, index)
    local decs = {}
    local explist = {}
    index = Expect(list, index, 'let')
    index, decs = ParseDecList(list, index)
    index = Expect(list, index, 'in')
    index, explist = ParseExpSeq(list, index, ';', 'end')
    index = Expect(list, index, 'end')
    local exp = A_exp:letexp(decs, explist)
    return index, exp
end

function ParseWhile(list, index)
    local test = {}
    local body = {}
    index = Expect(list, index, 'while')
    index, test = ParseExp(list, index)
    index = Expect(list, index, 'do')
    index, body = ParseExp(list, index)
    local exp = A_exp:whileexp(test, body)
    return index, exp
end

function ParseFor(list, index)
    index = Expect(list, index, 'for')
    symbol = list[index]
    if symbol:kind() ~= 'id' then
        Expect(list, index, 'TokenKind::ID')
    end
    local lo = {}
    local hi = {}
    local body = {}
    index = Expect(list, index + 1, ':=')
    index, lo = ParseExp(list, index)
    index = Expect(list, index, 'to')
    index, hi = ParseExp(list, index)
    index = Expect(list, index, 'do')
    index, body = ParseExp(list, index)
    local exp = A_exp:forexp(symbol.name, lo, hi, body)
    return index, exp
end

function ParseIf(list, index)
    local test = {}
    local thenn = {}
    local elsee = {}
    index = Expect(list, index, 'if')
    index, test = ParseExp(list, index)
    if test.seq then
        if test.seq.tail then
            error('If exp test op not correct')
        end
        test = test.seq.head
    end
    index = Expect(list, index, 'then')
    index, thenn = ParseExp(list, index)
    nexttk = list[index]
    if nexttk and nexttk:kind() == 'else' then
        index = Expect(list, index, 'else')
        index, elsee = ParseExp(list, index)
    end
    local exp = A_exp:ifexp(test, thenn, elsee)
    return index, exp
end

function ParseExpSeq(list, index, delim, terminate)
    tk = list[index]
    if tk.name == terminate then
        return index, nil
    end
    local exp = {}
    local tails = {}
    index, exp = ParseExp(list, index)
    tk = list[index]
    if tk.name == delim then
        index = Expect(list, index, delim)
        index, tails = ParseExpSeq(list, index, delim, terminate)
    end
    return index, List(exp, tails)
end

function ParseRecList(list, index, terminate)
    tk = list[index]
    if tk.name == terminate then
        return index, nil
    end
    if not tk:issymbol() then
        error("expect TokenKind::ID")
    end
    local head = {}
    local tail = {}
    fieldname = tk.name
    index = Expect(list, index + 1, '=')
    index, head = ParseExp(list, index)
    tk = list[index]
    if tk.name == ',' then
        index = Expect(list, index, ',')
        index, tail = ParseRecList(list, index, terminate)
    end
    local eflist = List(A_Efield(fieldname, head), tail)
    return index, eflist
end

function ParseIdExp(list, index)
    tk = list[index]
    if not tk:issymbol() then
        error("expect TokenKind::ID")
    end
    local exp = {}
    local simpvar = A_var:simplevar(tk.name)
    index = index + 1
    tk = list[index]
    if tk.name == '.' then
        local fieldvar = simpvar
        repeat
            index = Expect(list, index, '.')
            tk = list[index]
            if not tk:issymbol() then
                error("Expect TokenKind::ID")
            end
            fieldvar = A_var:fieldvar(fieldvar, tk.name)
            index = index + 1
            exp = A_exp:varexp(fieldvar)
            tk = list[index]
        until (not tk:issame('.'))
        if tk.name == ':=' then
            index = Expect(list, index, ':=')
            index, asexp = ParseExp(list, index)
            exp = A_exp:assignexp(field, asexp)
        else
            exp = A_exp:varexp(field)
        end
    end
    local idxexp = {}
    local init = {}
    local size = {}
    local rvexp = {}
    local variable = {}
    local args = {}
    local reclist = {}
    local rve = {}
    if tk.name == '[' then
        index = Expect(list, index, '[')
        index, idxexp = ParseExp(list, index)
        index = Expect(list, index, ']')
        if list[index]:issame('of') then
            index = Expect(list, index, 'of')
            index, init = ParseExp(list, index)
            exp = A_exp:arrayexp(simpvar.simple, idxexp, init)
        else
            variable = A_var:subscriptvar(simpvar, idxexp)
            while list[index]:issame('[') or list[index]:issame('.') do
                print('id exp subscript', index, list[index].name)
                if list[index]:issame('[') then
                    index = Expect(list, index, '[')
                    index, size = ParseExp(list, index)
                    variable = A_var:subscriptvar(variable, size)
                    index = Expect(list, index, ']')
                else
                    index = Expect(list, index, '.')
                    if not list[index]:issymbol() then
                        error("expect TokenKind::ID")
                    end
                    variable = A_var:fieldvar(variable, list[index].name)
                    index = index + 1
                end
            end
            if list[index]:issame(':=') then
                index = Expect(list, index, ':=')
                index, rvexp = ParseExp(list, index)
                exp = A_exp:assignexp(variable, rvexp)
            else
                exp = A_exp:varexp(variable)
            end
        end
    elseif list[index]:issame('(') then
        index = Expect(list, index, '(')
        index, args = ParseExpSeq(list, index, ',', ')')
        index = Expect(list, index, ')')
        exp = A_exp:callexp(simpvar.simple, args)
    elseif list[index]:issame('{') then
        index = Expect(list, index, '{')
        index, reclist = ParseRecList(list, index, '}')
        index = Expect(list, index, '}')
        exp = A_exp:recordexp(simpvar.simple, reclist)
    elseif list[index]:issame(':=') then
        index = Expect(list, index, ':=')
        index, rve = ParseExp(list, index)
        exp = A_exp:assignexp(simpvar, rve)
    else
        exp = A_exp:varexp(simpvar)
    end
    return index, exp
end

function ParseRecordDec(list, index, terminate)
    if list[index]:issame(terminate) then
        return index, nil
    end
    if not list[index]:issymbol() then
        error("Expect TokenKind::ID")
    end
    local tail
    local fntk = list[index]
    index = Expect(list, index + 1, ':')
    fttk = list[index]  index = index + 1
    if list[index]:issame(',') then
        index = Expect(list, index, ',')
        index, tail = ParseRecordDec(list, index, terminate)
    end
    local fieldlist = List(A_Field(fntk.name, fttk.name), tail)
    return index, fieldlist
end

function ParseTypeDec(list, index)
    if (not list[index]) or ( not list[index]:issame('type')) then
        return index, nil
    end
    index = Expect(list, index, 'type')
    if not list[index]:issymbol() then
        error("Expect TokenType::ID")
    end
    local ty = {}
    local tail = {}
    local dec = {}
    local typename = list[index]
    index = Expect(list, index + 1, '=')
    if list[index]:issame('array') then
        index = Expect(list, index, 'array')
        index = Expect(list, index, 'of')
        if not list[index]:issymbol() then
            error("Expect TokenType::ID")
        end
        ty = A_ty:arrayty(list[index].name)
        index = index + 1
    elseif list[index]:issame('{') then
        index = Expect(list, index, '{')
        index, rd = ParseRecordDec(list, index, '}')
        index = Expect(list, index, '}')
        ty = A_ty:recordty(rd)
    elseif list[index]:issymbol() then
        ty = A_ty:namety(list[index].name)
        index = index + 1
    end
    index, tail = ParseTypeDec(list, index)
    if tail then
        tail = tail.typ
    end
    dec = A_dec:typedec(List(A_Namety(typename.name, ty), tail))
    dec.field = 'type'
    return index, dec
end

function ParseVarDec(list, index)
    index = Expect(list, index, 'var')
    if not list[index]:issymbol() then
        error("Expect TokenKind::ID")
    end
    local init = {}
    local vardec = {}
    local vartype = {}
    local vn = list[index]
    if list[index + 1]:issame(':') then
        index = Expect(list, index + 1, ':')
        if not list[index]:issymbol() then
            error("Expect TokenKind::ID")
        end
        vartype = list[index].name
    end
    index = Expect(list, index + 1, ':=')
    index, init = ParseExp(list, index)
    
    local tmpexp = init
    if tmpexp.intt then
        tmptype = 'int'
    elseif tmpexp.stringg then
        tmptype = 'string'
    elseif tmpexp.record then
        tmptype = tmpexp.record.typ
    end
    if not vartype then
        vartype = tmptype
    end
    vardec = A_dec:vardec(vn.name, vartype, init)
    vardec.field = 'var'
    return index, vardec
end

function ParseFunctionDec(list, index)
    if (not list[index]) or (not list[index]:issame('function')) then
        return index, nil
    end
    local args = {}
    local body = {}
    local tail = {}
    local fundec = {}
    local funrttype = {}
    index = Expect(list, index, 'function')
    local fn = list[index]
    index = Expect(list, index + 1, '(')
    index, args = ParseRecordDec(list, index, ')')
    index = Expect(list, index, ')')
    if list[index]:issame(':') then
        index = Expect(list, index, ':')
        funrttype = list[index].name
        index = index + 1
    end
    index = Expect(list, index, '=')
    index, body = ParseExp(list, index)
    index, tail = ParseFunctionDec(list, index)
    if tail then
        tail = tail.functions
    end
    fundec = A_Fundec(fn.name, args, funrttype, body)
    fundec.field = 'function'
    return index, A_dec:functiondec(List(fundec, tail))
end

function ParseDecList(list, index)
    if (not list[index]) or list[index]:issame('in') then
        return index, nil
    end
    local headdec = {}
    local tail = {}
    if list[index]:issame('type') then
        index, headdec = ParseTypeDec(list, index)
    elseif list[index]:issame('var') then
        index, headdec = ParseVarDec(list, index)
    elseif list[index]:issame('function') then
        index, headdec = ParseFunctionDec(list, index)
    else
        error("Expect Keyword: type | var | function")
    end
    index, tail = ParseDecList(list, index)
    return index, List(headdec, tail)
end
