Definitions = {
    -- Patterns for certain types of characters, for Lua's built-in pattern matching functions.

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
    blockCommentStart = "/*";
    blockCommentEnd = "*/";

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

        mathIncrement = "++";
        mathDecrement = "--";
        mathAdd = "+";
        mathSubtract = "-";
        mathMultiply = "*";     -- Also pointer sign
        mathDivide = "/";
        mathModulo = "%";

        ternaryAsk = "?";
        ternaryAnswer = ":";

        listSep = ",";
        statementSep = ";";

        doubleQuote = "\"";
        singleQuote = "'";

        openParenthesis = "(";
        closeParenthesis = ")";
        openBracket = "[";
        closeBracket = "]";
        openCurl = "{";
        closeCurl = "}";
        openArrow = "<";        -- Also less than sign
        closeArrow = ">";       -- Also greater than sign
    };

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
    }

    -- TODO: Special characters for string parsing
}