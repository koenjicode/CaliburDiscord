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
    [14] = "Demonic Deviant"       -- Cervantes
}

-- Get the VodkaVerse folder.
function vodkalibur.GetVodkaVersePath()
    return IterateGameDirectories().Game.Content.Paks["~mods"].VodkaVerse
end

-- Check if an replacement is there based on the loaded files.
function vodkalibur.HasReplacement(char_id)
    local folder = vodkalibur.GetVodkaVersePath()
    if not folder then return false end

    local replacement_name = vodkalibur.CharacterMap[char_id]
    if not replacement_name then return false end

    for _, file in pairs(vodkalibur.GetVodkaVersePath().__files) do
        print(string.format("Checking VodkaVerse File: %s", file.__name))
        if string.find(file.__name, replacement_name, 1, true) then
            return true
        end
    end

    return false
end

-- Potentially pull an adjusted Character ID based on the replacements.
function vodkalibur.GetAdjustedCharID(char_id)
    if vodkalibur.HasReplacement(char_id) then
        local vv_id = tostring(char_id) .. vodka_extension
        print(string.format("Now using ID: %s", vv_id))
        return vv_id
    end

    return char_id
end

return vodkalibur
