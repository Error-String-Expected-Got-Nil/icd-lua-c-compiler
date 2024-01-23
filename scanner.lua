require("config/definitions")

local defs = Definitions

function Scan(file)
    local scanState = {position = 1, line = 1}

    local overreadBuffer = {}

    -- If characters need to be "put back", this does it and updates state accordingly.
    local function reverseRead(str)
        scanState.position = scanState.position - #str

        for i = 1, #str do
            local char = str:sub(i, i)

            if char == defs.newline then scanState.line = scanState.line - 1 end

            table.insert(overreadBuffer, char)
        end
    end

    local function nextChar()
        if not file:read(0) and #overreadBuffer == 0 then
            -- Code here will only run when end of file is reached. Will add code to handle that when I get there.
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

    -- Use coroutines here? Constantly get next character, send to a particular coroutine, swapping out the coroutine as necessary to parse properly?
end