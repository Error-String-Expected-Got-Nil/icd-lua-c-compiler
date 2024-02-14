require("config/tokenenum")

-- Temp function to error if any unimplemented tokens are seen
local function validateTokens(tokens)
    local te = TokensEnum
    local allowed = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod, te.numberLiteral}

    for _, token in ipairs(tokens) do
        -- TODO: this
        -- TEST EXPRESSION PARSER AFTER
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

local function parseValue(token)
    if token[1] == TokensEnum.numberLiteral then
        return {"number", token[2], token[3]}
    elseif token[1] == TokensEnum.word then
        return {"word", token[2]}
    elseif type(token[1]) == "string" then
        -- If the token has already been parsed as a unit of an expression we can ignore it here.
        return token
    end

    error("failed to parse token on line " .. token[0] .. ", value expected, got otherwise")
end

local function parseBinaryExpression(tokens, start, finish, lastPrecedence)
    if start > finish then
        error("failed to parse expression, value expected, got nil")
    end

    local arg1 = parseValue(tokens[start])

    if finish == start then
        return arg1
    end

    local operator = tokens[start + 1]
    local nextPrecedence = Definitions.opPrecedence[TokensEnum[operator[1]]]
    if nextPrecedence > lastPrecedence then
        local expression = {"op", TokensEnum[operator[1]], arg1, parseBinaryExpression(tokens, start + 2, finish, nextPrecedence)}
        table.collapse(tokens, start, start + 2, expression)

        if #tokens == 1 then
            return tokens
        end

        return parseBinaryExpression(tokens, start, finish - 2, nextPrecedence)
    else
        return arg1
    end
end

-- Note that this mutates the tokens table passed in, make sure to duplicate it and pass in duplicate.
function ParseExpression(tokens, start, finish)
    start = start or 1
    finish = finish or #tokens

    validateTokens(tokens)

    -- TODO: Group stuff in parentheses into sub-expressions
    -- Would also catch any non-binary operations here (pointer reference, unary minus, indexing, calling)

    -- By this point (if this were finished), any non-binary expressions should be grouped up and treated as any other value token
    -- So we can just parse everything recursively as a binary expression
    return parseBinaryExpression(tokens, start, finish, 0)
end