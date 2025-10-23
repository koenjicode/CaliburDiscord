local Calibur = {}
local UEHelpers = require("UEHelpers")

Calibur.character   = require("modules.character")
Calibur.structs     = require("modules.structs")
Calibur.discord     = require("modules.discord")
Calibur.text        = require("modules.text")

function Calibur.GetBattleManager()
    local manager_instance = FindFirstOf("LuxBattleManager")
    return manager_instance
end

function Calibur.GetBattleSetupPreviewCharaManager()
    local preview_instance = FindFirstOf("BP_LuxBattleSetupPreviewCharaManager_C")
    return preview_instance
end

function Calibur.GetBattleSetup()
    local bm = FindFirstOf("LuxBattleManager")
    return bm.BattleSetupOverride
end

function Calibur.GetLevelName()
    local persistent_level = UEHelpers.GetPersistentLevel()
    local full_name = persistent_level:GetFullName()

    return full_name:match("%.(.-):PersistentLevel")
end

function Calibur.IsTrainingMode()
    local bs = Calibur.GetBattleSetup()
    return bs.bEndless
end

function Calibur.IsMockBattle()
    return Calibur.GetLevelName() == "STG013"
end

function Calibur.IsCPUMatch()
    local bs = Calibur.GetBattleSetup()
    return (bs.PlayerLeft.InputDeviceID == -1 and bs.PlayerRight.InputDeviceID == -1)
end

function Calibur.IsLocalPVP()
    local bs = Calibur.GetBattleSetup()
    return (bs.PlayerLeft.InputDeviceID >= 0 and bs.PlayerRight.InputDeviceID >= 0)
end

function Calibur.GetPlayerSide()
    local bs = Calibur.GetBattleSetup()

    if Calibur.IsTrainingMode() then
        return 1
    end

    if Calibur.IsLocalPVP() then
        return 0
    end

    if bs.PlayerLeft.InputDeviceID >= 0 then
        return 1
    elseif bs.PlayerRight.InputDeviceID >= 0 then
        return 2
    else
        return 0
    end
end

function Calibur.GetPlayerSetupBySide(side_index)
    local bs = Calibur.GetBattleSetup()
    return (side_index == 1) and bs.PlayerLeft or bs.PlayerRight
end

function Calibur.GetPlayerSetup()
    local bs = Calibur.GetBattleSetup()
    return (Calibur.GetPlayerSide() == 1) and bs.PlayerLeft or bs.PlayerRight
end

function Calibur.IsUsingCreation()
    local ps = Calibur.GetPlayerSetup()
    return Calibur.character.IsCreation(ps)
end

function Calibur.GetCharacterName()
    local ps = Calibur.GetPlayerSetup()
    return Calibur.character.GetCharacterName(ps)
end

function Calibur.IsOnlineMatch()
    local bm = Calibur.GetBattleManager()
    return bm:IsOnline()
end

function Calibur.IsOnlineMatch()
    local bm = Calibur.GetBattleManager()
    return bm:IsOnline()
end

-- Returns the preview character in the Character Select.
function Calibur.GetPreviewCharacter(index)
    local preview_manager = Calibur.GetBattleSetupPreviewCharaManager()
    return (index == 1) and preview_manager.FightStyle_L or preview_manager.FightStyle_R
end

function Calibur.GetBattleCharacter(index)
    local lux_manager = Calibur.GetBattleManager()
    return lux_manager.BattleCharaArray[index]
end

return Calibur
