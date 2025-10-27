-- vodkalibur.lua
-- Utility functions for CaliburDiscord and related tools.

local vodkalibur = {}

local vodka_extension = "_VV"

-- Base character IDs to VodkaVerse Replacements
vodkalibur.CharacterMap = {
    [6]  = "ProjectPyrrha",        -- Sophitia
    [5]  = "Astral Ninjutsu II",   -- Voldo
    [96] = "Ars Planetarum",       -- 2B
    [98] = "CodenameKESTREL",      -- Groh
    [13] = "Yan Leixia",           -- Xianghua
    [97] = "Lightning",            -- Haohmaru
    [7]  = "Rekindled Clockwork",  -- Siegfried
    [23] = "Misguided Justice",    -- Cassandra
    [14] = "Demonic Deviant",      -- Cervantes
    [102] = "Aeon",                -- Lesser Lizardman
}

-- Get the VodkaVerse folder.
function vodkalibur.GetVodkaVersePath()
    return IterateGameDirectories().Game.Content.Paks["~mods"].VodkaVerse
end

function vodkalibur.GetVodkaPatchPath()
    return IterateGameDirectories().Game.Content.Battle.AssetPaths
end

function vodkalibur.IsVodkaPatchInstalled()
    local aeon_path = vodkalibur.GetVodkaPatchPath()
    if not aeon_path then return false end

    for _, file in pairs(aeon_path.__files) do
        if string.find(file.__name, "CP_066", 1, true) then
        return true
        end
    end
end

-- Check if an replacement is there based on the loaded files.
function vodkalibur.HasReplacement(char_id)
    local folder = vodkalibur.GetVodkaVersePath()
    if not folder then return false end

    local replacement_name = vodkalibur.CharacterMap[char_id]
    if not replacement_name then return false end

    for _, file in pairs(folder.__files) do
        if string.find(file.__name, replacement_name, 1, true) then
            return true
        end
    end

    return false
end

-- Potentially pull an adjusted Character ID based on the replacements.
function vodkalibur.GetAdjustedCharID(char_id)

    -- Aeon
    if char_id == 102 and vodkalibur.IsVodkaPatchInstalled() then
        local vv_id = tostring(char_id) .. vodka_extension
        print(string.format("Now using Aeon's ID: %s", vv_id))
        return vv_id
    end

    if vodkalibur.HasReplacement(char_id) then
        local vv_id = tostring(char_id) .. vodka_extension
        print(string.format("Now using ID: %s", vv_id))
        return vv_id
    end

    return char_id
end

return vodkalibur
