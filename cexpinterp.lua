-- Scans file then feeds it directly to the expression parser and prints the result.

require("scanner")
require("expressionparser")
require("utils/tableutils")

Test = io.open("exptest.txt")

Tokens = Scan(Test)

for _, v in ipairs(Tokens) do
    print(v[1], v[2] or " ", v[3] or " ", TokensEnum[v[1]])
end

Expression = ParseExpression(Tokens)

table.printDump(Expression)