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

    -- Array of all operator (for lack of a better term) types followed by keys with those names assigned to their symbols.
    -- If adding an operator, put longer ones first in the array part to make sure they take priority!
    -- This is so, for instance, a line comment isn't confused for two divisions.
    operators = {
        "lineCommentStart";
        "blockCommentStart";
        "blockCommentEnd";

        lineCommentStart = "//";
        blockCommentStart = "/*";
        blockCommentEnd = "*/";
    };
}