require("scanner")
require("utils/tableutils")

File = io.open("test.c")

Test = Scan(File)

table.printDump(Test)