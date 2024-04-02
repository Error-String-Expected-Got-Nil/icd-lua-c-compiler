require("scanner")
require("utils/tableutils")

File = io.open("test.c")

Test = coroutine.create(Scan)
coroutine.resume(Test, File)

while true do
    local success, token = coroutine.resume(Test)

    if not token then break end

    print(token[1], token[2] or " ", token[3] or " ", TokensEnum[token[1]])
end