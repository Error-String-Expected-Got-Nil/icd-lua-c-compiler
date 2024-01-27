-- Uses some basic pattern matching to let you format strings with ANSI color codes.

function Colorize(str, tagOpen, tagClose)
    tagOpen = tagOpen or "<"
    tagClose = tagClose or ">"

    local codes = setmetatable({
        blk = "\027[30m";
        red = "\027[31m";
        grn = "\027[32m";
        ylw = "\027[33m";
        blu = "\027[34m";
        mgn = "\027[35m";
        cyn = "\027[36m";
        wht = "\027[37m";

        bblk = "\027[90m";
        bred = "\027[91m";
        bgrn = "\027[92m";
        bylw = "\027[93m";
        bblu = "\027[94m";
        bmgn = "\027[95m";
        bcyn = "\027[96m";
        bwht = "\027[97m";

        blkbg = "\027[40m";
        redbg = "\027[41m";
        grnbg = "\027[42m";
        ylwbg = "\027[43m";
        blubg = "\027[44m";
        mgnbg = "\027[45m";
        cynbg = "\027[46m";
        whtbg = "\027[47m";

        bblkbg = "\027[100m";
        bredbg = "\027[101m";
        bgrnbg = "\027[102m";
        bylwbg = "\027[103m";
        bblubg = "\027[104m";
        bmgnbg = "\027[105m";
        bcynbg = "\027[106m";
        bwhtbg = "\027[107m";

        b = "\027[1m";
        ["/b"] = "\027[2m";

        i = "\027[3m";
        ["/i"] = "\027[23m";

        u = "\027[4m";
        ["/u"] = "\027[24m";

        s = "\027[9m";
        ["/s"] = "\027[29m";

        reset = "\027[0m";
        ["/"] = "\027[0m";
    }, {__index = function(tab, key) error("unrecognized formatting tag \"<" .. key .. ">\" for Colorize() function") end})

    return str:gsub("(%b" .. tagOpen .. tagClose .. ")", function(tag) return codes[tag:sub(2, -2)] end) .. codes.reset
end

function Decolorize(str, tagOpen, tagClose)
    tagOpen = tagOpen or "<"
    tagClose = tagClose or ">"

    return str:gsub("%b" .. tagOpen .. tagClose, "")
end