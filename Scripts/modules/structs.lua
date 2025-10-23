-- modules/Structs.lua
local Structs = {}

-- Character IDs (decimal, sparse mapping for direct lookups)
Structs.characters = {
    [1] = "Mitsurugi",
    [2] = "Seong Mi-Na",
    [3] = "Taki",
    [4] = "Maxi",
    [5] = "Voldo",
    [6] = "Sophitia",
    [7] = "Siegfried",
    [9] = "Hwang",
    [11] = "Ivy",
    [12] = "Kilik",
    [13] = "Xianghua",
    [15] = "Yoshimitsu",
    [17] = "Nightmare",
    [18] = "Astaroth",
    [19] = "Inferno",
    [20] = "Cervantes",
    [21] = "Raphael",
    [22] = "Talim",
    [23] = "Cassandra",
    [34] = "Setsuka",
    [35] = "Tira",
    [36] = "Zasalamel",
    [40] = "Hilde",
    [45] = "Creation",
    [48] = "Amy",
    [96] = "2B",
    [97] = "Haohmaru",
    [98] = "Groh",
    [100] = "Azwel",
    [101] = "Geralt",
    [102] = "Lesser Lizardman",
    [103] = "Evil Kilik",
    [104] = "Evil Grøh",
    [105] = "Boss Azwel",
}

Structs.blacklisted = {
    45,  -- Creation
    102, -- Lesser Lizardman
    103, -- Evil Kilik
    104, -- Evil Grøh
    105, -- Boss Azwel
}

-- Stage Indexes (string keys for lookup by level name)
Structs.stages = {
    STG001 = "Shrine of Eurydice: Cloud Sanctuary",
    STG002 = "Ostrheinsburg Castle: Hall of the Chosen",
    STG003 = "Windswept Plains",
    STG004 = "Astral Chaos: Tide of the Damned",
    STG005 = "Kunpaetku Temple: Serpentine Banquet",
    STG006 = "Master Swordsman's Cave: Azure Horizon",
    STG008 = "Indian Port: Impending Storm",
    STG009 = "Snow-Capped Showdown",
    STG010 = "Sunken Desert Ruins",
    STG011 = "Cursed Moonlit Woods",
    STG012 = "Replica Kaer Morhen",
    STG014 = "City Ruins: Eternal Apocalypse",
    STG015 = "Faraway Meadow",
    STG016 = "Gairyu Isle",
    STG015_R = "Grand Labyrinth - Sealed Corridor",
    STG011_R = "Silver Wolves' Haven",
    STG017 = "Murakumo Shrine Grounds",
    STG006_R = "Master Swordsman's Cave: Wicked Depths",
    STG018 = "Motien Pass Ruins",
    STG011_R_V = "Silver Wolves' Haven (Daytime)",
    STG001_V = "Shrine of Eurydice (Evening)",
    STG006_V = "Master Swordsman's Cave (Evening)",
    STG017_V = "Murakumo Shrine Grounds (Night)",
}

Structs.battle_states = {
    [0]  = "EBM_DUMMY",
    [1]  = "EBM_START",
    [2]  = "EBM_NORMAL",
    [3]  = "EBM_GAMESET",
    [4]  = "EBM_REPLAY",
    [5]  = "EBM_WIN",
    [6]  = "EBM_STAGE_INTRO",
    [7]  = "EBM_PLAYER_INTRO",
    [8]  = "EBM_STAGE_TRANSITION",
    [9]  = "EBM_MOTION_CHANGE",
    [10] = "EBM_END",
    [11] = "EBM_CONTINUE",
    [12] = "EBM_GAMEOVER",
    [13] = "EBM_FREE_EVENT",
    [14] = "EBM_RELOAD",
    [15] = "EBM_EXHIBITION",
    [16] = "EBM_PROFILE",
    [17] = "EBM_EVENT",
    [18] = "EBM_ENDING",
    [19] = "EBM_ENDEVENT",
    [20] = "EBM_SHORT_REPLAY",
}

-- Helper functions
function Structs.IsBlacklisted(id)
    for _, blockedId in ipairs(Structs.blacklisted) do
        if blockedId == id then
            return true
        end
    end
    return false
end

function Structs.GetCharacterText(id)
    return Structs.characters[id] or ("Unknown Character [" .. tostring(id) .. "]")
end

function Structs.GetStageText(level)
    return Structs.stages[level] or "Unknown Stage"
end

function Structs.GetBattleState(value)
    return Structs.battle_states[value] or "Unknown"
end

return Structs