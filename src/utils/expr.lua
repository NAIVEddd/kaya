A_var = {}
A_exp = {}
A_dec = {}
A_ty = {}

function A_var:simplevar(varname)
    local var = {}
    setmetatable(var, self)
    self.__index = self
    var.simple = varname
    return var
end
function A_var:fieldvar(_var, _sym)
    local var = {}
    setmetatable(var, self)
    self.__index = self
    field = {var = _var, sym = _sym}
    var.field = field
    return var
end
function A_var:subscriptvar(_var, _exp)
    local var = {}
    setmetatable(var, self)
    self.__index = self
    subscript = {var = _var, exp = _exp}
    var.subscript = subscript
    return var
end

function A_exp:varexp(_var)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.var = _var
    return exp
end
function A_exp:nilexp()
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.nill = true
    return exp
end
function A_exp:intexp(_num)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.intt = _num
    return exp
end
function A_exp:strexp(_str)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.stringg = _str
    return exp
end
function A_exp:callexp(_func, _args)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    call = {func = _func, args = _args}
    exp.call = call
    return exp
end
function A_exp:opexp(_op, _left, _right)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    op = {oper = _op, left = _left, right = _right}
    exp.op = op
    return exp
end
function A_exp:recordexp(_ty, _fields)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.record = {typ = _ty, fields = _fields}
    return exp
end
function A_exp:seqexp(_seq)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.seq = _seq
    return exp
end
function A_exp:assignexp(_var, _exp)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    assign = {var = _var, exp = _exp}
    exp.assign = assign
    return exp
end
function A_exp:ifexp(_test, _then, _else)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    iff = {test = _test, thenn = _then, elsee = _else}
    exp.iff = iff
    return exp
end
function A_exp:whileexp(_test, _body)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    whilee = {test = _test, body = _body}
    exp.whilee = whilee
    return exp
end
function A_exp:forexp(_var, _lo, _hi, _body)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    forr = {var = _var, lo = _lo, hi = _hi, body = _body}
    exp.forr = forr
    return exp
end
function A_exp:breakexp()
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    exp.breakk = true
    return exp
end
function A_exp:letexp(_decs, _body)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    let = {decs = _decs, body = _body}
    exp.let = let
    return exp
end
function A_exp:arrayexp(_type, _size, _init)
    local exp = {}
    setmetatable(exp, self)
    self.__index = self
    array = {typ = _type, size = _size, init = _init}
    exp.array = array
    return exp
end

function A_dec:functiondec(_func)
    local dec = {}
    setmetatable(dec, self)
    self.__index = self
    dec.funcs = _func
    return dec
end
function A_dec:vardec(_var, _type, _init)
    local dec = {}
    setmetatable(dec, self)
    self.__index = self
    var = {var = _var, typ = _type, init = _init}
    dec.var = var
    return dec
end
function A_dec:typedec(_types)
    local dec = {}
    setmetatable(dec, self)
    self.__index = self
    dec.typ = _types
    return dec
end

function A_ty:namety(_name)
    local ty = {}
    setmetatable(ty, self)
    self.__index = self
    ty.name = _name
    return ty
end
function A_ty:recordty(_record)
    local ty = {}
    setmetatable(ty, self)
    self.__index = self
    ty.record = _record
    return ty
end
function A_ty:arrayty(_array)
    local ty = {}
    setmetatable(ty, self)
    self.__index = self
    ty.array = array
    return ty
end

function A_Field(_name, _type)
    local field = {}
    field.name = _name
    field.typ = _type
    return field
end
function List(_head, _tail)
    local list = {}
    list.head = _head
    list.tail = _tail
    return list
end
function A_Fundec(_name, _params, _result, _body)
    local dec = {name = _name, params = _params, result = _result, body = _body}
    return dec
end
function A_Namety(_name, _ty)
    local namety = {name = _name, ty = _ty}
    return namety
end
function A_Efield(_name, _exp)
    local field = {name = _name, exp = _exp}
    return field
end
