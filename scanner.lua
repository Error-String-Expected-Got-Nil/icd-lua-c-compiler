require("config/definitions")
require("config/tokenenum")

local defs = Definitions
local charPat = defs.characterPatterns

function Scan(file)
    local position = 0  -- 'position' and 'line' are for debug/logging purposes.
    local line = 1
    local reader
    -- Each token is an array.
    -- The first entry in each array is always the token's enum ID.
    -- Additional entries are any extra data the token needs (like a literal's value).

    local overreadBuffer = {}

    local tokensBuffer = {}
    local function emitToken(token)
        table.insert(tokensBuffer, token)
    end

    -- If characters need to be "put back", this does it and updates state accordingly.
    local function unread(str)
        position = position - #str

        for i = 1, #str do
            local char = str:sub(i, i)

            if char == defs.newline then line = line - 1 end

            table.insert(overreadBuffer, char)
        end
    end

    local function nextChar()
        if not file:read(0) and #overreadBuffer == 0 then
            -- Returning nil as next character indicates end of file. 
            return nil
        end

        position = position + 1

        local char
        if #overreadBuffer > 0 then
            char = table.remove(overreadBuffer, 1)
        else
            char = file:read(1)
        end

        if char == defs.newline then line = line + 1 end

        return char
    end

    -- The following uses coroutines. Coroutines are, in short, functions you can pause and resume, passing data in and out at the same time.

    -- TODO: String literal reader, character literal reader

    local function readCharacters()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            -- Only supports decimal number literals. Too bad!
            -- Also doesn't support type postfixes. Too bad!
            if not char:match(defs.characters) and not ((char:match(defs.decimalPoint)) and buffer:sub(-1):match("%d")) then
                for _, keyword in ipairs(defs.keywords) do
                    if buffer == defs.keywords[keyword] then
                        emitToken({[0] = line; TokensEnum[keyword]})

                        unread(char)
                        return true
                    end
                end

                if buffer:match("^" .. charPat.word .. "$") then
                    emitToken({[0] = line; TokensEnum.word, buffer})
                elseif buffer:match("^" .. charPat.decimal .. defs.decimalPoint .. charPat.decimal .. "$") then
                    emitToken({[0] = line; TokensEnum.numberLiteral, "float", tonumber(buffer)})
                    error("I'm not dealing with floating point.")
                elseif buffer:match("^" .. charPat.decimal .. "$") then
                    emitToken({[0] = line; TokensEnum.numberLiteral, "int", tonumber(buffer)})
                else
                    error("unrecognized character sequence while parsing")
                end

                unread(char)
                return true
            else
                buffer = buffer .. char
            end
        end
    end

    local function readWhitespace()
        while true do
            local char = coroutine.yield()

            if not char:match(defs.whitespace) then
                unread(char)
                return true
            end
        end
    end

    local function readLineComment()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            -- Storing comments to buffer so they can be logged later.
            buffer = buffer .. char

            if char == defs.newline then
                return true
            end
        end
    end

    local function readBlockComment()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            -- Storing comments to buffer so they can be logged later. Also to find end.
            buffer = buffer .. char

            if buffer:match(defs.blockCommentEnd .. "$") then
                return true
            end
        end
    end

    -- Only supports single-character string bounds and escape sequences. Too bad!
    -- This compiler is going to be very janky, but I suppose that should be expected for a first try.
    local function readStringLiteral()
        local buffer = ""
        local escaped = false

        while true do
            local char = coroutine.yield()

            if escaped then
                buffer = buffer .. (defs.stringEscapeChars[char] or char)
            else
                if char:match(defs.stringEscape) then
                    escaped = true
                elseif char:match(defs.stringBound) then
                    emitToken({[0] = line; TokensEnum.stringLiteral, buffer})

                    return true
                else
                    buffer = buffer .. char
                end
            end
        end
    end

    local function readSymbols()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            if not char:match(defs.symbols) then
                while #buffer > 0 do
                    local replace = 0

                    -- TODO: Check for single quote marks to start char parsing

                    -- Some repeated code... bad, but not terrible, and I don't think making a function for this is worth it.
                    -- str:gsub() is global substitution, replacing all instances of a pattern in the given string.
                    -- Here, I am matching to the start of the string and replacng with the empty string. gsub returns the string after
                    -- replacement, and the number of replacements made. So I'm using it to check for and clip the prefix at the same time.
                    buffer, replace = buffer:gsub("^" .. defs.stringBound, "")
                    if replace > 0 then

                        unread(char)
                        unread(buffer)

                        local nextReader = coroutine.create(readStringLiteral)
                        coroutine.resume(nextReader)
                        reader = nextReader

                        return false
                    end

                    buffer, replace = buffer:gsub("^" .. defs.lineCommentStart, "")
                    if replace > 0 then
                        unread(char)
                        unread(buffer)

                        local nextReader = coroutine.create(readLineComment)
                        coroutine.resume(nextReader)
                        reader = nextReader

                        return false
                    end

                    buffer, replace = buffer:gsub("^" .. defs.blockCommentStart, "")
                    if replace > 0 then
                        unread(char)
                        unread(buffer)

                        local nextReader = coroutine.create(readBlockComment)
                        coroutine.resume(nextReader)
                        reader = nextReader

                        return false
                    end

                    for _, operator in ipairs(defs.operators) do
                        buffer, replace = buffer:gsub("^" .. defs.operators[operator], "")

                        if replace > 0 then
                            emitToken({[0] = line; TokensEnum[operator]})
                            break
                        end

                        -- TODO: Handle unknown symbols/operators. I.e., invoke error.
                    end
                end

                unread(char)
                return true
            else
                buffer = buffer .. char
            end
        end
    end

    -- Determines which reader is next, returning a new coroutine for it.
    local function getNextReader(char)
        local nextReader

        if char:match(defs.symbols) then
            nextReader = readSymbols
        elseif char:match(defs.characters) then
            nextReader = readCharacters
        elseif char:match(defs.whitespace) then
            nextReader = readWhitespace
        else
            error("unrecognized character encountered")
        end

        nextReader = coroutine.create(nextReader)
        coroutine.resume(nextReader)
        return nextReader
    end

    local char = nextChar()
    reader = getNextReader(char)
    unread(char)

    -- Pause before starting read loop when first initialized
    coroutine.yield()
    while true do
        char = nextChar()

        if not char then
            -- Bit hacky, but this is the easiest fix to a minor bug.
            coroutine.resume(reader, defs.newline)

            if #tokensBuffer > 0 then
                for i, v in ipairs(tokensBuffer) do
                    coroutine.yield(v)
                end
                tokensBuffer = {}
            end

            -- Return false when finished
            return false
        end

        -- First return of coroutine.resume is false if coroutine had an error, second result is either error message, or first return of yield
        local success, message = coroutine.resume(reader, char)

        if not success then
            print("coroutine error: ")
            print(message)
            error("character reader fault")
        end

        if message then
            reader = getNextReader(char)
        end

        if #tokensBuffer > 0 then
            for i, v in ipairs(tokensBuffer) do
                coroutine.yield(v)
            end
            tokensBuffer = {}
        end
    end
end
