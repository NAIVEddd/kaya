

Token = { location = 0, name = ""}

function Token:new(loc, name)
    token = {}
    setmetatable(token, self)
    self.__index = self
    token.location = loc or 0
    token.name = name or ""
    return token
end

function Token:isnum()
    return string.match(self.name, "^-?%d+$")
end

function Token:isstr()
    return string.match(self.name, '^".*"$')
end

function Token:issymbol()
    return string.match(self.name, '^[a-zA-Z]+%w*')
end

function Token:issame(str)
    return self.name == str
end

TokenKind = 
{
    NONE = 'none',
    INT = 'int', STRING = 'string', NIL = 'nil',
    LET = 'let', IN = 'in', END = 'end', WHILE = 'while', DO = 'do', FOR = 'for', TO = 'to', IF = 'if', THEN = 'then', ELSE = 'else',
    LPAREN = 'lparen', RPAREN = 'rparen', LBRACK = 'lbrack', RBRACK = 'rbrack', LBRACE = 'lbrace', RBRACE = 'rbrace',
    DOT = 'dot', COMMA = 'comma', SEMICOLON = 'semicolon', OR = 'or', AND = 'and', LT = 'lt', GT = 'gt', LE = 'le', GE = 'ge', EQ = 'eq', NEQ = 'neq', ASSIGN = 'assign',
    PLUS = 'plus', MINUS = 'minus', TIMES = 'times', DIVIDE = 'divide',
    ID = 'id',
    TYPE = 'type', VAR = 'var', FUNCTION = 'function', ARRAY = 'array'
}
function Token:kind()
    if self:isnum() then return TokenKind['INT'] end
    if self:isstr() then return TokenKind['STRING'] end
    if self:issame('nil') then return TokenKind['NIL'] end
    if self:issame('let') then return TokenKind['LET'] end
    if self:issame('in') then return TokenKind['IN'] end
    if self:issame('end') then return TokenKind['END'] end
    if self:issame('while') then return TokenKind['WHILE'] end
    if self:issame('do') then return TokenKind['DO'] end
    if self:issame('for') then return TokenKind['FOR'] end
    if self:issame('to') then return TokenKind['TO'] end
    if self:issame('if') then return TokenKind['IF'] end
    if self:issame('then') then return TokenKind['THEN'] end
    if self:issame('else') then return TokenKind['ELSE'] end
    if self:issame('(') then return TokenKind['LPAREN'] end
    if self:issame(')') then return TokenKind['RPAREN'] end
    if self:issame('[') then return TokenKind['LBRACK'] end
    if self:issame(']') then return TokenKind['RBRACK'] end
    if self:issame('{') then return TokenKind['LBRACE'] end
    if self:issame('}') then return TokenKind['RBRACE'] end
    if self:issame('.') then return TokenKind['DOT'] end
    if self:issame(',') then return TokenKind['COMMA'] end
    if self:issame(';') then return TokenKind['SEMICOLON'] end
    if self:issame('||') then return TokenKind['OR'] end
    if self:issame('&&') then return TokenKind['AND'] end
    if self:issame('<') then return TokenKind['LT'] end
    if self:issame('>') then return TokenKind['GT'] end
    if self:issame('<=') then return TokenKind['LE'] end
    if self:issame('>=') then return TokenKind['GE'] end
    if self:issame('=') then return TokenKind['EQ'] end
    if self:issame('<>') then return TokenKind['NEQ'] end
    if self:issame(':=') then return TokenKind['ASSIGN'] end
    if self:issame('+') then return TokenKind['PLUS'] end
    if self:issame('-') then return TokenKind['MINUS'] end
    if self:issame('*') then return TokenKind['TIMES'] end
    if self:issame('/') then return TokenKind['DIVIDE'] end
    if self:issame('type') then return TokenKind['TYPE'] end
    if self:issame('var') then return TokenKind['VAR'] end
    if self:issame('function') then return TokenKind['FUNCTION'] end
    if self:issame('array') then return TokenKind['ARRAY'] end
    if self:issymbol() then return TokenKind['ID'] end
    return TokenKind[1]
end
