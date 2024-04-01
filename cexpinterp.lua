-- Scans file then feeds it directly to the expression parser and prints the result.

require("scanner")
require("expressionparser")
require("utils/tableutils")

File = io.open("exptest.txt")

Test = coroutine.create(Scan)
coroutine.resume(Test, File)

Tokens = {}

while true do
    local success, token = coroutine.resume(Test)

    if not token then break end

    print(token[1], token[2] or " ", token[3] or " ", TokensEnum[token[1]])

    table.insert(Tokens, token)
end

Expression = ParseExpression(Tokens)

print("")

table.printDump(Expression)