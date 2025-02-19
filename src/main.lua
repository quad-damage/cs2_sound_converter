local game_manager = require("game_manager")
local snow = require("snow")
local windows = require("windows")
local logger = require("logger")

local convert_queue = { }

function love.load()
    snow:init()
    
    font = love.graphics.newFont("Roboto-Regular.ttf", 24)
    font_small = love.graphics.newFont("Roboto-Regular.ttf", 12)

    windows:EnableVirtualTerminalProcessing()

    if(not game_manager:init()) then
        error("A fatal error has occured while initializing the game manager.")
    end

end

function love.draw()
    love.graphics.setBackgroundColor(0.090, 0.090, 0.090, 1)
    
    love.graphics.setFont(font)
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.print("Drag & Drop your audio files", 62, 140)

    game_manager:update()

    snow:draw()
end

function love.filedropped(file)
    logger:info("Added %s", file:getFilename())
    game_manager:convert(file:getFilename())
end

function love.errorhandler(msg)
    love["system"] = require("love.system")
    love["event"] = require("love.event")

    local stack_trace = debug.traceback()
    local error_message = {
        "The program has encountered an unrecoverable error, and must now exit.",
        " ",
        "================================================================",
        stack_trace,
        "================================================================",
        " ",
        "For troubleshooting purposes, please copy the displayed traceback by clicking \"Copy\" and",
        "submit it via our GitHub repository: https://github.com/quad-damage/cs2_sound_converter",
        "or via Discord: @quadruple",
        "Thank you for helping us improve the application."
    }
    error_message = table.concat(error_message, "\n")

    local error_choice = love.window.showMessageBox("Counter-Strike 2 Sound Converter", error_message, {"Copy", "Exit"}, "error")
    if(error_choice == 1) then
        love.system.setClipboardText(stack_trace .. "\n\n" .. table.concat(logger.log, '\n'))
    end

    love.event.quit()
end