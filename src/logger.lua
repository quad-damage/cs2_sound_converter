local logger = {}

local function color(code)
    return string.format("\27[%dm", code)
end

local color = {
    reset = color(0),

    fg = {
        black = color(30),
        red = color(31),
        green = color(32),
        yellow = color(33),
        blue = color(34),
        magenta = color(35),
        cyan = color(36),
        white = color(37),
        default = color(39),
        bright_black = color(90),
        bright_red = color(91),
        bright_green = color(92),
        bright_yellow = color(93),
        bright_blue = color(94),
        bright_magenta = color(95),
        bright_cyan = color(96),
        bright_white = color(97)
    },

    bg = {
        black = color(40),
        red = color(41),
        green = color(42),
        yellow = color(43),
        blue = color(44),
        magenta = color(45),
        cyan = color(46),
        white = color(47),
        extended = color(48),
        default = color(49),
        bright_black = color(100),
        bright_red = color(101),
        bright_green = color(102),
        bright_yellow = color(103),
        bright_blue = color(104),
        bright_magenta = color(105),
        bright_cyan = color(106),
        bright_white = color(107)
    }
}

local LOG_LEVEL = {
    DEBUG   =   1,
    INFO    =   2,
    WARN    =   3,
    ERROR   =   4
}

local LOG_LEVEL_color = {
    [LOG_LEVEL.DEBUG]   =   color.bg.bright_blue .. color.fg.bright_white,
    [LOG_LEVEL.INFO]    =   color.bg.bright_black .. color.fg.bright_white,
    [LOG_LEVEL.WARN]    =   color.bg.bright_yellow .. color.fg.bright_white,
    [LOG_LEVEL.ERROR]   =   color.bg.bright_red .. color.fg.bright_white
}

local LOG_LEVEL_PREFIX = {
    [LOG_LEVEL.DEBUG]   =   " DEBUG ",
    [LOG_LEVEL.INFO]    =   " INFO  ",
    [LOG_LEVEL.WARN]    =   " WARN  ",
    [LOG_LEVEL.ERROR]   =   " ERROR "
}

function logger:printf(log_level, fmt, ...)
    local call_stack = debug.getinfo(3, "Sl")
    local prefix = LOG_LEVEL_color[log_level] .. LOG_LEVEL_PREFIX[log_level] .. color.bg.default .. color.bg.default
    print(string.format("%s%s |%s| %s | %s", (color.bg.default .. color.fg.bright_white), os.date("%H:%M:%S"), prefix, string.format("%s:%s", call_stack.source:sub(2), call_stack.currentline), string.format(fmt, ...)))
end

function logger:debug(fmt, ...) self:printf(LOG_LEVEL.DEBUG, fmt, ...) end
function logger:info(fmt, ...) self:printf(LOG_LEVEL.INFO, fmt, ...) end
function logger:warn(fmt, ...) self:printf(LOG_LEVEL.WARN, fmt, ...) end
function logger:error(fmt, ...) self:printf(LOG_LEVEL.ERROR, fmt, ...) end

return logger