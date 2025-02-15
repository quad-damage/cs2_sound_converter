local windows = require("windows")
local logger = require("logger")

local game_manager = {}

function string:endsWith(str)
    return self:sub(-#str) == str
end

local function check_registry_path(hkey, lpSubKey, lpValue)
    local game_path = windows:RegGetValueA(hkey, lpSubKey, lpValue)
    
    -- Check if the key even exists.
    if(game_path == nil or #game_path == 0) then
        return false, nil
    end

    if(not game_path:endsWith("\\")) then
        game_path = game_path .. "\\"
    end

    -- Check if resourcecompiler.exe exists.
    if(not windows:FileExists(game_path .. "game\\bin\\win64\\resourcecompiler.exe")) then
        return false, nil
    end

    -- Check if resourcecompiler.dll exists.
    if(not windows:FileExists(game_path .. "game\\bin\\win64\\resourcecompiler.dll")) then
        return false, nil
    end

    return true, game_path
end

function game_manager:init()
    local available_keys = {
        {windows.HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Steam App 730", "InstallLocation"},
        {windows.HKEY_LOCAL_MACHINE, "SOFTWARE\\WOW6432Node\\Valve\\cs2", "installpath"}
    }

    for _, key in pairs(available_keys) do
        logger:debug("Checking key %s %s %s", unpack(key))
        result, self.game_path = check_registry_path(unpack(key))

        if(result) then break end
    end

    if(self.game_path == nil) then
        self.game_path = windows:GetOpenFileNameA({"cs2.exe", "cs2.exe"}, "Open Counter-Strike 2 executable")

        if(self.game_path and self.game_path:endsWith("game\\bin\\win64\\cs2.exe")) then
            self.game_path = self.game_path:sub(1, -23)
        else
            logger:error("No game_path selected in GetOpenFileNameA.")
            love.window.showMessageBox("Failed to find game path", "Failed to find your game folder.\nUse the file open dialog and select the game's executable.", "error", false)
            return false
        end
    end

    self.resource_compiler_path = self.game_path .. "game\\bin\\win64\\resourcecompiler.exe"

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
