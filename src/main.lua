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
        love.window.showMessageBox("Failed to find resourcecompiler.exe", "Failed to find resourcecompiler.exe in your game folder.\nPlease download the workshop tools and try again.", "error", false)
        love.event.quit(0)
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
    -- table.insert(file:getFilename())
    logger:info("Added ", file:getFilename())
    game_manager:convert(file:getFilename())
end