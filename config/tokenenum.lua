-- Storing a whole string for every token would be... questionable, so here's a table that mimics an enum.
-- String keys get their ordinal number, ordinals get the corresponding string.
-- Not all of these will be implemented. I'm just including almost everything for completeness sake because I have to update this manually if I add something new.
Tokens = {
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
    "mathSubtract";
    "mathMultiply";
    "mathDivide";
    "mathModulo";

    -- Control symbols
    "ternaryAsk";
    "teraryAnswer";

    "listSep";
    "statementSep";

    "doubleQuote";
    "singleQuote";

    "openParenthesis";
    "closeParenthesis";
    "openBracket";
    "closeBracket";
    "openCurl";
    "closeCurl";
    "openArrow";
    "closeArrow";

    -- Identifiers and Literals
    "identifier";
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
    "true";
    "false";

    -- Control Keywords
    "if";
    "else";

    "while";
    "for";
    "do";

    "switch";
    "case";

    "break";
    "continue";
    "goto";
}