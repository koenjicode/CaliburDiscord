local calibur = require("modules.calibur")

local preview_character_present = false

local function get_activity_info()
    local level_name = calibur.GetLevelName()

    -- In a Battle
    if string.match(level_name, "^STG") then
        local player_index = calibur.GetPlayerSide()
        local char_id = nil

        -- Only run character logic if the player is not local
        if player_index > 0 then
            local character = calibur.GetBattleCharacter(player_index)
            char_id = calibur.character.GetCharacterID(character)
        end

        local network_environment = nil
        if calibur.IsOnlineMatch() then
            network_environment = "Online"
        else
            network_environment = "Offline"
        end

        local action = nil
        -- Check if we're in training mode.
        if calibur.IsTrainingMode() then
            -- If we are, check the stage to see if we're in a mock battle.
            if calibur.IsMockBattle() then
                action = "Mock Battle"
            else
                action = "Training Mode"
            end
            -- Check if the Player is using a Creation character with the special outro flag.
        elseif calibur.IsLibraMode() then
            action = "Libra of Soul"
            -- Similar check, but we flip the Creation character check to see if they're playing as a regular character instead.
        elseif calibur.IsStoryMode() then
            action = "Soul Chronicle"
            -- Check if the ReplayManager is actively playing back a match.
        elseif calibur.IsReplayMatch() then
            action = "Watching Replay"
            -- Check if the Timer is infinite and it uses a specific draw behaviour.
        elseif calibur.IsArcadeMode() then
            action = "Arcade Mode"
            -- Check if both player characters have any skills equipped.
        elseif calibur.IsSpecialMatch() then
            action = "Special Versus"
            -- Checks if both players have controller indexes.
        elseif calibur.IsLocalPVP() then
            action = "Local Versus"
            -- Checks if both players DON'T have controller indexes.
        elseif calibur.IsCPUMatch() then
            action = "CPU VS CPU"
        else
            -- And if all of these things fail, then they're playing a regular, ordinary, boring CPU match.
            action = "VS CPU"
        end

        -- Online doesn't utilise the Controller indexes I heavily rely on when checking things offline.
        -- We'll try and figure out specific network match stuff at a later date.
        if network_environment == "Online" then
            action = "Networked Match"
        end

        -- Base presence
        local presence = {
            state = string.format("%s: %s", network_environment, action),
            startTimestamp = os.time(),
            largeImageKey = string.lower(level_name),
            largeImageText = calibur.structs.GetStageText(level_name),
        }

        -- Additional presence if character index is valid
        if char_id then
            -- Check for Vodkalibur replacement
            char_id = calibur.vodkalibur.GetAdjustedCharID(char_id)

            if calibur.IsUsingCreation() then
                local name = calibur.GetCharacterName()
                if calibur.text.IsAllUppercase(name) then
                    name = calibur.text.FormatText(name)
                end
                local style = calibur.structs.GetCharacterText(char_id)
                presence.smallImageKey = "999"
                presence.smallImageText = string.format("%s (%s)", name, style)
            else
                presence.smallImageKey = string.lower(char_id)
                presence.smallImageText = calibur.structs.GetCharacterText(char_id)
            end
        end

        return presence
    end

    -- In Character Select
    if level_name == "Creation" then
        return {
            state = "Character Creation",
            startTimestamp = os.time(),
        }
    end

    -- In Character Select
    if level_name == "BattleSetup" then
        return {
            state = "Preparing"
        }
    end

    -- Unknown State
    return {
        state = "Waiting",
    }
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    preview_character_present = false
    ExecuteWithDelay(1000, function()
        print(calibur.GetLevelName())
        calibur.discord.UpdatePresence(get_activity_info())
    end)
end)

math.randomseed(os.time())
calibur.discord.Initialise(1430288174047039510, 544750)