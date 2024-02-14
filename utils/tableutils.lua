-- Some extra utilities for tables. Might not use all of these.

function table.reverse(tab, start, finish)
    start = start or 1
    finish = finish or #tab

    local j = finish
    for i = start, (start + finish) // 2 do
        tab[i], tab[j] = tab[j], tab[i]
        j = j - 1
    end

    return tab
end

function table.rotate(tab, amount, start, finish)
    start = start or 1
    finish = finish or #tab

    table.reverse(tab, start, finish)
    table.reverse(tab, start, start + amount - 1)
    table.reverse(tab, start + amount, finish)

    return tab
end

function table.shuffle(tab)
    for i = #tab, 2, -1 do
        local j = math.random(1, i)
        tab[i], tab[j] = tab[j], tab[i]
    end

    return tab
end

function table.range(start, finish)
    local range = {}

    local direction = 1
    if start > finish then
        start, finish = finish, start
        direction = -1
    end

    for i = start, finish, direction do
        table.insert(range, i)
    end

    return range
end

function table.rangeSwap(tab, width, first, second)
    for offset = 0, width - 1 do
        local i, j = first + offset, second + offset
        tab[i], tab[j] = tab[j], tab[i]
    end

    return tab
end

function table.binarySearch(tab, target, start, finish, comparison)
    --Note that binary searches assume the target table is already sorted, and will not work properly if it isn't.
    start = start or 1
    finish = finish or #tab

    --Search failure condition.
    if finish < start then
        return nil
    end

    --comparison(a, b) returns true if `a` should go before `b` in a fully sorted table.
    comparison = comparison or function(a, b) return a < b end

    local middle = (start + finish) // 2
    if tab[middle] == target then
        return middle
    else
        if comparison(tab[middle], target) then
            return table.binarySearch(tab, target, middle + 1, finish, comparison)
        else
            return table.binarySearch(tab, target, start, middle - 1, comparison)
        end
    end
end

function table.linearSearch(tab, target, start, finish)
    start = start or 1
    finish = finish or #tab

    for i = start, finish do
        if tab[i] == target then
            return i
        end
    end

    return nil
end

function table.clone(tab)
    local newtab = {}

    for k, v in pairs(tab) do
        newtab[k] = v
    end

    return newtab
end

function table.recursiveClone(tab)
    local newtab

    if type(tab) == "table" then
        newtab = {}
    else
        return tab
    end

    for k, v in pairs(tab) do
        newtab[k] = table.recursiveClone(v)
    end

    return newtab
end

function table.display(tab)
    print(table.concat(tab, " "))
end

function table.printDump(tab, indent, ...)
    indent = indent or 0
    local indentString = string.rep("\t", indent)
    local tableEmpty = true

    for key, value in pairs(tab) do
        tableEmpty = false
        local argType = type(value)
        if argType == "table" then
            if (function(...) for _, check in ipairs({...}) do if value == check then return false end end return true end)(tab, ...) then
                print("\n" .. indentString, key, "[nested table]")
                table.printDump(value, indent + 1, tab, ...)
            else
                print("\n" .. indentString, key, "[recursive table]")
            end
        else
            print(indentString, key, (function()
                if argType == "function" or argType == "file" or argType == "thread" or argType == "userdata" then return "[" .. argType .. "]"
                else return value end
            end)())
        end
    end

    if tableEmpty then print(indentString, "[table was empty]") end

    print("")
end

-- Removes all elements in a table from start to finish, then puts a replacement where start was.
function table.collapse(tab, start, finish, replace)
    for i = 1, finish - start + 1 do
        table.remove(tab, start)
    end

    table.insert(tab, start, replace)

    return tab
end

function table.contains(tab, target)
    for _, v in ipairs(tab) do
        if v == target then
            return true
        end
    end

    return false
end