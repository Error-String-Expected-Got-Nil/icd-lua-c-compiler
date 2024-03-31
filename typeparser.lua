require("config/tokenenum")

-- Type format:
-- {main = "int", size = <size in bits>, isSigned = true/false, isConst = true/false}
-- {main = "float", size = <size in bits>, isConst = true/false}
-- {main = "struct", subtypes = {type, type, type...}, subtypeKeys = {key, key, key...}, isConst = true/false}
-- {main = "ptr", reftype = <type>, isConst = true/false}
-- {main = "void"}
-- {main = "function", returntype = <type>, argtypes = {type, type, type...}}