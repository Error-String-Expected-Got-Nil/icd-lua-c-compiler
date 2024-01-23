require("config/definitions")
require("scanner")

File = io.open("test.c")

Test = Scan(File)

print(table.concat(Test, " "))