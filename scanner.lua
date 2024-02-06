require("config/definitions")
require("config/tokenenum")

local defs = Definitions
local charPat = defs.characterPatterns

-- BIG TODO:
-- Currently scans the whole file at once, not really what we want. Risks using up a bunch of resources for large files.
-- Would be better to make it scan single statements at a time and compile at the same time?
-- Need to figure it out.

function Scan(file)
    local position = 0  -- 'position' and 'line' are for debug/logging purposes.
    local line = 1
    local reader
    local tokens = {}
    -- Each token is an array in this 'tokens' array.
    -- The first entry in each array is always the token's enum ID.
    -- Additional entries are any extra data the token needs (like a literal's value).

    local overreadBuffer = {}

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
                -- TODO: Check for keywords

                if buffer:match("^" .. charPat.word .. "$") then
                    table.insert(tokens, {TokensEnum.word, buffer})
                elseif buffer:match("^" .. charPat.decimal .. defs.decimalPoint .. charPat.decimal .. "$") then
                    table.insert(tokens, {TokensEnum.numberLiteral, "float", tonumber(buffer)})
                    -- Maybe throw error. I don't want to deal with floats right now.
                elseif buffer:match("^" .. charPat.decimal .. "$") then
                    table.insert(tokens, {TokensEnum.numberLiteral, "integer", tonumber(buffer)})
                else
                    -- Throw error
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
                    table.insert(tokens, {TokensEnum.stringLiteral, buffer})

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

                    -- TODO: Check for double quote marks to start string parsing
                    -- TODO: Check for single quote marks to start char parsing

                    -- Some repeated code... bad, but not terrible, and I don't think making a function for this is worth it.
                    -- str:gsub() is global substitution, replacing all instances of a pattern in the given string.
                    -- Here, I am matching to the start of the string and replacng with the empty string. gsub returns the string after
                    -- replacement, and the number of replacements made. So I'm using it to check for and clip the prefix at the same time.
                    buffer, replace = buffer:gsub("^" .. defs.lineCommentStart, "")
                    if replace > 0 then
                        unread(buffer)

                        local nextReader = coroutine.create(readLineComment)
                        coroutine.resume(nextReader)
                        reader = nextReader
                    end

                    buffer, replace = buffer:gsub("^" .. defs.blockCommentStart, "")
                    if replace > 0 then
                        unread(buffer)

                        local nextReader = coroutine.create(readBlockComment)
                        coroutine.resume(nextReader)
                        reader = nextReader
                    end

                    for _, operator in ipairs(defs.operators) do
                        buffer, replace = buffer:gsub("^" .. defs.operators[operator], "")

                        if replace > 0 then
                            table.insert(tokens, {TokensEnum[operator]})
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
            -- Unrecognized character, should cause error
        end

        nextReader = coroutine.create(nextReader)
        coroutine.resume(nextReader)
        return nextReader
    end

    local char = nextChar()
    reader = getNextReader(char)
    unread(char)

    while true do
        char = nextChar()

        if not char then
            return tokens
        end

        local success, message = coroutine.resume(reader, char)

        if not success then
            -- Coroutine had an error, handle here
        end

        if message then
            reader = getNextReader(char)
        end
    end
end
