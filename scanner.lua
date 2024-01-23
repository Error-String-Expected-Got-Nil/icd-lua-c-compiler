require("config/definitions")

local defs = Definitions

function Scan(file)
    local scanState = {position = 0, line = 1, reader = nil, tokens = {}}

    local overreadBuffer = {}

    -- If characters need to be "put back", this does it and updates state accordingly.
    local function unread(str)
        scanState.position = scanState.position - #str

        for i = 1, #str do
            local char = str:sub(i, i)

            if char == defs.newline then scanState.line = scanState.line - 1 end

            table.insert(overreadBuffer, char)
        end
    end

    local function nextChar()
        if not file:read(0) and #overreadBuffer == 0 then
            -- Returning nil as next character indicates end of file. 
            return nil
        end

        scanState.position = scanState.position + 1

        local char
        if #overreadBuffer ~= 0 then
            char = table.remove(overreadBuffer, 1)
        else
            char = file:read(1)
        end

        if char == defs.newline then scanState.line = scanState.line + 1 end

        return char
    end

    -- The following uses coroutines. Coroutines are, in short, functions you can pause and resume, passing data in and out at the same time.
    -- TODO: Load tokens into table

    local function readCharacters()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            if not char:match(defs.characters) then
                -- Temporary
                table.insert(scanState.tokens, buffer)

                unread(char)
                return "finished"
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
                return "finished"
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
                return "finished"
            end
        end
    end

    local function readBlockComment()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            -- Storing comments to buffer so they can be logged later. Also to find end.
            buffer = buffer .. char

            if buffer:sub(-#defs.operators.blockCommentEnd) == defs.operators.blockCommentEnd then
                return "finished"
            end
        end
    end

    local function readSymbols()
        local buffer = ""

        while true do
            local char = coroutine.yield()

            if not char:match(defs.symbols) then
                -- Temporary
                table.insert(scanState.tokens, buffer)

                unread(char)
                return "finished"
            else
                buffer = buffer .. char
            end
        end
    end

    -- Determines which reader is next, returning a new coroutine for it.
    local function getNextReader(char)
        local reader

        if char:match(defs.symbols) then
            reader = readSymbols
        elseif char:match(defs.characters) then
            reader = readCharacters
        elseif char:match(defs.whitespace) then
            reader = readWhitespace
        else
            -- Unrecognized character, should cause error
        end

        reader = coroutine.create(reader)
        coroutine.resume(reader)
        return reader
    end

    local char = nextChar()
    scanState.reader = getNextReader(char)
    unread(char)

    while true do
        char = nextChar()

        if not char then
            return scanState.tokens
        end

        local success, message = coroutine.resume(scanState.reader, char)

        if not success then
            -- Coroutine had an error, handle here
        end

        if message == "finished" then
            scanState.reader = getNextReader(char)
        end
    end
end