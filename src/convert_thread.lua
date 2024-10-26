local windows = require("windows")
love.window = require("love.window")
local content_sounds_path, resource_compiler_path, game_mod_path, game_sounds_path, convertlist_filepaths = ...
local convertlist_filenames = { }

local function GetFileName(path)
    local current_idx = #path
    while(path:sub(current_idx, current_idx) ~= "\\") do
        current_idx = current_idx - 1
    end

    return path:sub(current_idx + 1, #path)
end

local function RemoveExtension(name)
    local current_idx = #name
    while(name:sub(current_idx, current_idx) ~= ".") do
        current_idx = current_idx - 1
    end

    return name:sub(1, current_idx - 1)
end

for _, filepath in pairs(convertlist_filepaths) do
    local filename = GetFileName(filepath)
    convertlist_filenames[_] = filename
    windows:CopyFileA(filepath, content_sounds_path .. filename, false)
end

local cmd = string.format("\"%s\"", resource_compiler_path)
for _, filename in pairs(convertlist_filenames) do
    cmd = string.format("%s -i \"%s\"", cmd, content_sounds_path .. filename)
end
cmd = string.format("%s -game \"%s\"", cmd, game_mod_path)

local return_status, command_output =  windows:CreateProcess_WaitForFinish_ReadOut(cmd)
if(return_status) then
    print(command_output)
else
    print("CreateProcess failed.")
end

for _, filename in pairs(convertlist_filenames) do
    windows:CopyFileA(game_sounds_path .. RemoveExtension(filename) .. ".vsnd_c", RemoveExtension(convertlist_filepaths[_]) .. ".vsnd_c", false)
end

local _, __, compiled, failed, skipped = command_output:find(" (%d+) compiled, (%d+) failed, (%d+) skipped,")
compiled, failed, skipped = tonumber(compiled), tonumber(failed), tonumber(skipped)
if(failed > 0) then
    love.window.showMessageBox("Counter-Strike 2 Sound Converter", string.format("%d files have failed to convert.", failed), "error")
elseif(compiled + failed + skipped < #convertlist_filenames) then
    love.window.showMessageBox("Counter-Strike 2 Sound Converter", string.format("%d files have failed to convert.", #convertlist_filenames - (compiled + failed + skipped)), "error")
end