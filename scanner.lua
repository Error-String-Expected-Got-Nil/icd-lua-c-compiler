require("config/definitions")
require("config/tokenenum")

local defs = Definitions

function Scan(file)
    local position = 0
    local line = 1
    local reader
    local tokens = {}
    local tokenData = {}
    -- Each token gets added to the 'tokens' array as its ID.
    -- If a token requires additional data, it is put in the 'tokenData' table at the same array index it is at in the
    -- 'tokens' table. 

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
        if #overreadBuffer ~= 0 then
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

            -- Should permit period if previous character was a number, to allow for floats.
            if not char:match(defs.characters) then
                -- Temporary
                table.insert(tokens, buffer)

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

    local function readSymbols()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            if not char:match(defs.symbols) then
                while #buffer > 0 do
                    -- TODO: Check for comment start symbols
                    -- TODO: Check for double quote marks to start string parsing
                    -- TODO: Check for single quote marks to start char parsing

                    for _, operator in ipairs(defs.operators) do
                        local result, replace = buffer:gsub("^" .. defs.operators[operator], "")
                        if replace > 0 then
                            buffer = result
                            table.insert(tokens, {Tokens[operator]})
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
            return tokens, tokenData
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
