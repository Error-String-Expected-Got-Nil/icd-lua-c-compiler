require("config/tokenenum")

-- Temp function to error if any unimplemented tokens are seen
local function validateTokens(tokens)
    local te = TokensEnum
    local allowed = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod, te.numberLiteral}

    for _, token in ipairs(tokens) do
        if (function() for _, t in ipairs(allowed) do if token[1] == t then return false end end return true end) then
            error("attempted to parse expression with unimplmeneted or unrecognized token at line " .. token[0])
        end
    end
end

local function isOp(token)
    local te = TokensEnum
    local operators = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod}

    for _, op in ipairs(operators) do
        if token[1] == op then
            return true
        end
    end

    return false
end

function ParseExpression(tokens)
    validateTokens(tokens)

    -- TODO: Group stuff in parentheses into sub-expressions
    -- Would also catch any indexing or calling operations here.


end