require("scanner")
require("utils/tableutils")

File = io.open("test.c")

Test = Scan(File)

for i, v in ipairs(Test) do
    print(v[1], v[2] or " ", v[3] or " ", TokensEnum[v[1]])
end