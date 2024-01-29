-- Storing a whole string for every token would be... questionable, so here's a table that mimics an enum.
-- String keys get their ordinal number, ordinals get the corresponding string.
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

    -- Keywords
}