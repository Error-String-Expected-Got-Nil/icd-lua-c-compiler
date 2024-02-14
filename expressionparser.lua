require("config/tokenenum")

-- Temp function to error if any unimplemented tokens are seen
local function validateTokens(tokens)
    local te = TokensEnum
    local allowed = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod, te.numberLiteral}

    for _, token in ipairs(tokens) do
        if not table.contains(allowed, token[1]) then
            error("unrecognized token while parsing expression on line " .. token[0])
        end
    end
end

local function isOp(token)
    local te = TokensEnum
    local operators = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod}

    return table.contains(operators, token[1])
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

-- Note that this mutates the tokens table passed in, make sure to duplicate it and pass in duplicate.
function ParseExpression(tokens)
    validateTokens(tokens)

    -- TODO: Group stuff in parentheses into sub-expressions
    -- Would also catch any non-binary operations here (pointer reference, unary minus, indexing, calling)

    while #tokens > 1 do
        local highPrec, highPrecIndex = 0, 0

        for index, token in ipairs(tokens) do
            if isOp(token) then
                local opPrec = Definitions.opPrecedence[TokensEnum[token[1]]]
                if opPrec > highPrec then
                    highPrec = opPrec
                    highPrecIndex = index
                end
            end
        end

        if highPrec == 0 then
            -- More than one token remaining but there are no operators, expression is invalid.
            error("expression parsing failed, operator expected")
        end

        table.collapse(tokens, highPrecIndex - 1, highPrecIndex + 1, {"op", TokensEnum[tokens[highPrecIndex][1]],
            parseValue(tokens[highPrecIndex - 1]), parseValue(tokens[highPrecIndex + 1])})
    end

    -- In case the expression was a single number or something.
    return {parseValue(tokens[1])}
end