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

    openParenthesis = 36;
    closeParenthesis = 37;
    openBracket = 38;
    closeBracket = 39;
    openCurl = 40;
    closeCurl = 41;
    openArrow = 42;
    closeArrow = 43;

    -- Identifiers and Literals
    identifier = 44;
    stringLiteral = 45;
    numberLiteral = 46;

    -- Type Keywords
    char = 47;
    short = 48;
    int = 49;
    long = 50;

    float = 51;
    double = 52;

    struct = 53;
    enum = 54;
    union = 55;

    signed = 56;
    unsigned = 57;
    const = 58;
    constexpr = 59;
    volatile = 60;
    auto = 61;

    void = 62;

    bool = 63;
    literalTrue = 64;
    literalFalse = 65;

    -- Control Keywords
    controlIf = 66;
    controlElse = 67;

    controlWhile = 68;
    controlFor = 69;
    controlDo = 70;

    controlSwitch = 71;
    controlCase = 72;

    controlBreak = 73;
    controlContinue = 74;
    controlGoto = 75;
    controlReturn = 76;

    -- Extra
    sizeof = 77;
    typedef = 78;
    typeof = 79;
}