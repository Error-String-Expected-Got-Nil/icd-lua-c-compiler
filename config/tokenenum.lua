-- Storing a whole string for every token would be... questionable, so here's a table that mimics an enum.
-- String keys get their ordinal number, ordinals get the corresponding string.
-- Not all of these will be implemented. Probably still missing a bunch. Will be added... later.
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

    -- Extra (I.e. I forgot these and didn't want to manually fix the table)
    "sizeof";
    "typedef";
    "typeof";

    -- Name to Ordinal Indicies
    logicEQ = 1;
    logicNE = 2;
    logicGE = 3;
    logicLE = 4;
    logicAND = 5;
    logicOR = 6;
    logicNOT = 7;

    assign = 8;
    assignAdd = 9;
    assignSub = 10;
    assingMul = 11;
    assignDiv = 12;
    assignMod = 13;
    assignAND = 14;
    assignOR = 15;
    assignXOR = 16;
    assignLSH = 17;
    assignRSH = 18;

    bitwiseAND = 19;
    bitwiseOR = 20;
    bitwiseXOR = 21;
    bitwiseNOT = 22;
    bitwiseLSH = 23;
    bitwiseRSH = 24;

    mathIncrement = 25;
    mathDecrement = 26;
    mathAdd = 27;
    mathSubtract = 28;
    mathMultiply = 29;
    mathDivide = 30;
    mathModulo = 31;

    -- Control symbols
    ternaryAsk = 32;
    teraryAnswer = 33;

    listSep = 34;
    statementSep = 35;

    doubleQuote = 36;
    singleQuote = 37;

    openParenthesis = 38;
    closeParenthesis = 39;
    openBracket = 40;
    closeBracket = 41;
    openCurl = 42;
    closeCurl = 43;
    openArrow = 44;
    closeArrow = 45;

    -- Identifiers and Literals
    identifier = 46;
    stringLiteral = 47;
    numberLiteral = 48;

    -- Type Keywords
    char = 49;
    short = 50;
    int = 51;
    long = 52;

    float = 53;
    double = 54;

    struct = 55;
    enum = 56;
    union = 57;

    signed = 58;
    unsigned = 59;
    const = 60;
    constexpr = 70;
    volatile = 71;
    auto = 72;

    void = 73;

    bool = 74;
    literalTrue = 75;
    literalFalse = 76;

    -- Control Keywords
    controlIf = 77;
    controlElse = 78;

    controlWhile = 79;
    controlFor = 80;
    controlDo = 81;

    controlSwitch = 82;
    controlCase = 83;

    controlBreak = 84;
    controlContinue = 85;
    controlGoto = 86;
    controlReturn = 87;

    -- Extra
    sizeof = 88;
    typedef = 89;
    typeof = 90;
}