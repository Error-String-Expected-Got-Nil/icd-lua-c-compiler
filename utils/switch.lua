-- Lua does not natively have a switch statement, so this is a function that replicates one.

function SwitchGeneric(operation, subject, ...)
    for _, case in ipairs({...}) do
        if (function()
            if #case[1] == 0 then return true end

            for _, comparison in ipairs(case[1]) do
                if operation(subject, comparison) then return true end
            end

            return false
        end)() then
            if case[3] == "return" then return case[2]() end
            if case[3] == "break" then case[2]() break end
            if case[3] == "condbreak" then
                if case[2]() then break end
            else
                case[2]()
            end
        end
    end
end

function Switch(...)
    SwitchGeneric(function(a, b) return a == b end, ...)
end