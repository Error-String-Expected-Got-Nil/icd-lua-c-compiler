Definitions = {
    -- Patterns for certain types of characters, for Lua's built-in pattern matching functions.
    -- Assume all strings (that don't represent table keys) here are actually Lua patterns!! Escape special characters with % as necessary!

    -- symbols: Written out manually, all symbol characters.
    symbols = "[`%-=%[%]\\;',./!@#$%%^&*()+{}|:\"<>?]";

    -- characters: All letters a-z, uppercase or lowercase, plus numbers 0-9, plus the underscore.
    characters = "[%w_]";

    -- whitespace: All whitespace characters. Space, tab, newline, and some other stuff that usually doesn't come up but is in the %s class.
    whitespace = "%s";

    -- Newline character. You could change this if you wanted to, for whatever reason. More power to you.
    newline = "\n";

    -- Comment signifiers. Not in the "operators" list because they are treated specially when scanning.
    lineCommentStart = "//";
    blockCommentStart = "/%*";
    blockCommentEnd = "%*/";

    stringBound = "\"";
    stringEscape = "\\";
    -- Not all escape sequences but like, the ones people actually use. Can add more later or something.
    stringEscapeChars = {
        ["'"] = "'";
        ["\""] = "\"";
        ["\\"] = "\\";
        ["n"] = "\n";
    };
    charBound = "'";

    -- The first of these you might actually want to change, if you want to use commas instead of periods for the decimal point in a float.
    decimalPoint = "%.";

    characterPatterns = {
        word = "[%a_][%w_]*";
        decimal = "%d+";
    };

    -- Array of all operator (for lack of a better term) types followed by keys with those names assigned to their symbols.
    -- If adding an operator, put longer ones first in the array part to make sure they take priority!
    -- This is so, for instance, an increment isn't confused for two plus signs.
    -- Will probably comment out the ones I don't want to implement and have a catch-all "symbol unimplemented" if I ever fail to match in scanning.
    -- TODO: Optimize by ordering array part by symbol frequency in code.
    operators = {
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
        "assignMul";
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

        "ternaryAsk";
        "ternaryAnswer";

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

        logicEQ = "==";
        logicNE = "!=";
        logicGE = ">=";
        logicLE = "<=";
        logicAND = "&&";
        logicOR = "||";
        logicNOT = "!";

        assign = "=";
        assignAdd = "+=";
        assignSub = "-=";
        assignMul = "*=";
        assignDiv = "/=";
        assignMod = "%=";
        assignAND = "&=";
        assignOR = "|=";
        assignXOR = "^=";
        assignLSH = "<<=";
        assignRSH = ">>=";

        bitwiseAND = "&";       -- Also reference sign
        bitwiseOR = "|";
        bitwiseXOR = "^";
        bitwiseNOT = "~";
        bitwiseLSH = "<<";
        bitwiseRSH = ">>";

        mathIncrement = "%+%+";
        mathDecrement = "%-%-";
        mathAdd = "%+";
        mathSubtract = "%-";
        mathMultiply = "%*";     -- Also pointer sign
        mathDivide = "/";
        mathModulo = "%%";

        ternaryAsk = "%?";
        ternaryAnswer = ":";

        listSep = ",";
        statementSep = ";";

        openParen = "%(";
        closeParen = "%)";
        openBracket = "%[";
        closeBracket = "%]";
        openCurl = "{";
        closeCurl = "}";
        openArrow = "<";        -- Also less than sign
        closeArrow = ">";       -- Also greater than sign
    };
    -- Note: The reason I don't just have the keyed part and just run through it with pairs() instead of doing
    -- what I do here (having an array part and using ipairs()) is because, technically speaking, pairs()
    -- does NOT have a strictly defined order. I'm *pretty sure* it should do it in the order the keys are entered
    -- here, but I'm not *completely* sure, and that isn't the defined behavior. So we use the array version to
    -- make sure it always works the same, even if it may be slightly less efficient. 

    -- TODO: Optimize by ordering array part by keyword frequency in code.
    keywords = {
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

        "sizeof";
        "typedef";
        "typeof";

        char = "char";
        short = "short";
        int = "int";
        long = "long";

        float = "float";
        double = "double";

        struct = "struct";
        enum = "enum";
        union = "union";

        signed = "signed";
        unsigned = "unsigned";
        const = "const";
        constexpr = "constexpr";
        volatile = "volatile";
        auto = "auto";

        void = "void";

        bool = "bool";

        literalTrue = "true";
        literalFalse = "false";

        controlIf = "if";
        controlElse = "else";

        controlWhile = "while";
        controlFor = "for";
        controlDo = "do";

        controlSwitch = "switch";
        controlCase = "case";

        controlBreak = "break";
        controlContinue = "continue";
        controlGoto = "goto";
        controlReturn = "return";

        sizeof = "sizeof";
        typedef = "typedef";
        typeof = "typeof";
    }
}