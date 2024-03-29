-- Storing a whole string for every token would be... questionable, so here's a table that mimics an enum.
-- String keys get their ordinal number, ordinals get the corresponding string.
-- Not all of these will be implemented. Probably still missing a bunch. Will be added... later.
TokensEnum = {
    -- Operators
    "logicEQ";
    "logicNE";
    "logicGE";
    "logicLE";
    "logicAND";
    "logicOR";
    "logicNOT";

    "assign";
    "assignAdd";
    "assignSub";
    "assingMul";
    "assignDiv";
    "assignMod";
    "assignAND";
    "assignOR";
    "assignXOR";
    "assignLSH";
    "assignRSH";

    "bitwiseAND";
    "bitwiseOR";
    "bitwiseXOR";
    "bitwiseNOT";
    "bitwiseLSH";
    "bitwiseRSH";

    "mathIncrement";
    "mathDecrement";
    "mathAdd";
    "mathSub";
    "mathMul";
    "mathDiv";
    "mathMod";

    -- Control symbols
    "ternaryAsk";
    "teraryAnswer";

    "listSep";
    "statementSep";

    "openParen";
    "closeParen";
    "openBracket";
    "closeBracket";
    "openCurl";
    "closeCurl";
    "openArrow";
    "closeArrow";

    -- Identifiers and Literals
    "word";
    "stringLiteral";
    "numberLiteral";

    -- Type Keywords
    "char";
    "short";
    "int";
    "long";

    "float";
    "double";

    "struct";
    "enum";
    "union";

    "signed";
    "unsigned";
    "const";
    "constexpr";
    "volatile";
    "auto";

    "void";

    "bool";

    "literalTrue";
    "literalFalse";

    -- Control Keywords
    "controlIf";
    "controlElse";

    "controlWhile";
    "controlFor";
    "controlDo";

    "controlSwitch";
    "controlCase";

    "controlBreak";
    "controlContinue";
    "controlGoto";
    "controlReturn";

    -- Extra
    "sizeof";
    "typedef";
    "typeof";
    "ellipses";
}

-- Sets up the name -> ordinal part of the pseudo-enum.
for index, name in ipairs(TokensEnum) do
    TokensEnum[name] = index
end