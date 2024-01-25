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

    -- TODO: Special characters for string parsing
    -- TODO: Keywords
}