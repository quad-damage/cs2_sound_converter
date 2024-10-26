local windows = require("windows")

local game_manager = {}

function string:endsWith(str)
    return self:sub(-#str) == str
end

function game_manager:init()
    self.game_path = windows:RegGetValueA(windows.HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Steam App 730", "InstallLocation")
    if(self.game_path) then
        self.game_path = self.game_path .. "\\"
    else
        self.game_path = windows:GetOpenFileNameA({"cs2.exe", "cs2.exe"}, "Open Counter-Strike 2 executable")
        if(self.game_path:endsWith("game\\bin\\win64\\cs2.exe")) then
            self.game_path = self.game_path:sub(1, -23)
        end
    end
    print("Game path is: ", self.game_path)

    self.resource_compiler_path = self.game_path .. "game\\bin\\win64\\resourcecompiler.exe"
    if(windows:FileExists(self.resource_compiler_path) == false) then
        return false
    end

    -- Taken by the -game argument to resourcecompiler.exe
    self.game_mod_path = self.game_path .. "game\\core"

    -- /csgo_addons/sound_converter/
    self.content_addon_path = self.game_path .. "content\\csgo_addons\\sound_converter\\"
    windows:CreateDirectoryA(self.content_addon_path)

    -- /csgo_addons/sound_converter/sounds/
    self.content_sounds_path = self.content_addon_path .. "sounds\\"
    windows:CreateDirectoryA(self.content_sounds_path)

    -- /game/csgo_addons/sound_converter/
    self.game_addon_path = self.game_path .. "game\\csgo_addons\\sound_converter\\"
    windows:CreateDirectoryA(self.game_addon_path)

    -- /game/csgo_addons/sound_converter/sounds/
    self.game_sounds_path = self.game_addon_path .. "sounds\\"
    windows:CreateDirectoryA(self.game_sounds_path)

    self.convert_list = { }

    return true
end

function game_manager:convert(file)
    table.insert(self.convert_list, file)
end

function game_manager:update()
    if(#self.convert_list ~= 0) then
        local thread = love.thread.newThread("convert_thread.lua")
        thread:start(self.content_sounds_path, self.resource_compiler_path, self.game_mod_path, self.game_sounds_path, self.convert_list)
        self.convert_list = { }
    end
end

return game_manager