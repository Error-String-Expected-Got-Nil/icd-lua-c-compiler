require("config/tokenenum")
require("utils/tableutils")

-- Temp function to error if any unimplemented tokens are seen
local function validateTokens(tokens)
    local te = TokensEnum
    local allowed = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod, te.numberLiteral, te.openParen, te.closeParen, te.bitwiseNOT}

    for _, token in ipairs(tokens) do
        if not type(tokens[1]) == "string" and not table.contains(allowed, token[1]) then
            error("unrecognized token while parsing expression on line " .. token[0])
        end
    end
end

local function isOp(token)
    local te = TokensEnum
    local operators = {te.mathAdd, te.mathSub, te.mathMul, te.mathDiv, te.mathMod, te.bitwiseAND, te.bitwiseOR, te.bitwiseXOR, te.bitwiseNOT, te.bitwiseLSH, te.bitwiseRSH,
                        te.logicEQ, te.logicNE, te.logicGE, te.logicLE, te.logicAND, te.logicOR, te.logicNOT, te.assign, te.assignAdd, te.assignSub, te.assignMul, te.assignDiv,
                        te.assignMod, te.assignAND, te.assignOR, te.assignXOR, te.assignLSH, te.assignRSH}

    return table.contains(operators, token[1])
end

local function isUnaryOp(token)
    local te = TokensEnum
    local unaryOperators = {te.mathSub, te.mathMul, te.bitwiseAND, te.bitwiseNOT, te.logicNOT}

    return table.contains(unaryOperators, token[1])
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
    -- TODO: Cast operators

    -- Call operations
    local finishedParsingCalls = false
    repeat
        local balance = 0
        local openPos = 0
        for index, token in ipairs(tokens) do
            if token[1] == TokensEnum.openParen and tokens[index - 1][1] == TokensEnum.word then
                if openPos == 0 then
                    openPos = index
                end

                balance = balance + 1
            elseif token[1] == TokensEnum.closeParen and openPos ~= 0 then
                balance = balance - 1

                if balance == 0 then
                    if index == openPos + 1 then
                        table.collapse(tokens, openPos - 1, index, {"call", tokens[openPos - 1][2]})
                        break
                    end

                    local arguments = {}

                    local lastDelimiter = openPos
                    balance = balance - 1
                    for j = openPos, index do
                        -- Have to do parentheses balancing to make sure this isn't a seperator inside a nested function call argument
                        if tokens[j][1] == TokensEnum.openParen then
                            balance = balance + 1
                        elseif tokens[j][1] == TokensEnum.closeParen then
                            balance = balance - 1
                        elseif tokens[j][1] == TokensEnum.listSep and balance == 0 then
                            table.insert(arguments, ParseExpression(table.copySlice(tokens, lastDelimiter + 1, j - 1)))
                            lastDelimiter = j
                        end
                    end
                    balance = balance + 1

                    table.insert(arguments, ParseExpression(table.copySlice(tokens, lastDelimiter + 1, index - 1)))

                    local unit = {"call", tokens[openPos - 1][2]}
                    for _, value in ipairs(arguments) do
                        table.insert(unit, value)
                    end
                    table.collapse(tokens, openPos - 1, index, unit)

                    break
                end
            end
        end

        if balance ~= 0 then
            error("expression has unclosed function call")
        end

        finishedParsingCalls = true
        for index, token in ipairs(tokens) do
            if token[1] == TokensEnum.openParen and tokens[index - 1][1] == TokensEnum.word then
                finishedParsingCalls = false
                break
            end
        end
    until finishedParsingCalls

    -- Explicit precedence
    local finishedGrouping = false
    repeat
        local balance = 0
        local openPos = 0
        for index, token in ipairs(tokens) do
            if token[1] == TokensEnum.openParen then
                if openPos == 0 then
                    openPos = index
                end

                balance = balance + 1
            elseif token[1] == TokensEnum.closeParen then
                if openPos == 0 then
                    error("expression attempts to close unopened parentheses")
                end

                balance = balance - 1

                if balance == 0 then
                    if index == openPos + 1 then
                        error("empty group in expression")
                    end

                    table.collapse(tokens, openPos, index, ParseExpression(table.copySlice(tokens, openPos + 1, index - 1)))
                    break
                end
            end
        end

        if balance ~= 0 then
            error("expression has unclosed parenthesis")
        end

        finishedGrouping = true
        for index, token in ipairs(tokens) do
            if token[1] == TokensEnum.openParen then
                finishedGrouping = false
                break
            end
        end
    until finishedGrouping

    -- TODO: Indexing operations


    -- Prefix unary operators
    for index = #tokens, 1, -1 do
        if isUnaryOp(tokens[index]) then
            if isOp(tokens[index - 1]) then
                if tokens[index + 1] == nil then
                    error("hanging unary operator at end of expression on line " .. tokens[index][0])
                end

                local unopNames = {
                    [TokensEnum.mathSub] = "negate";
                    [TokensEnum.mathMul] = "dereference";
                    [TokensEnum.bitwiseAND] = "reference";
                    [TokensEnum.bitwiseNOT] = "bitwiseNegate";
                    [TokensEnum.logicNOT] = "logicNegate";
                }

                table.collapse(tokens, index, index + 1, {"unop", unopNames[tokens[index][1]], ParseExpression({tokens[index + 1]})})
            end
        end
    end

    while #tokens > 1 do
        local highPrec, highPrecIndex = 0, 0

        for index, token in ipairs(tokens) do
            if isOp(token) then
                local opPrec = Definitions.opPrecedence[TokensEnum[token[1]]]

                if not opPrec then
                    error("invalid operator on line " .. token[0])
                end

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

        -- TODO: If operator is combined assign/operation operator, expand it out to make parsing easier later?

        table.collapse(tokens, highPrecIndex - 1, highPrecIndex + 1, {"op", TokensEnum[tokens[highPrecIndex][1]],
            parseValue(tokens[highPrecIndex - 1]), parseValue(tokens[highPrecIndex + 1])})
    end

    -- In case the expression was a single number or something.
    return parseValue(tokens[1])
end