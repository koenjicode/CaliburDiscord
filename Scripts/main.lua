local calibur = require("modules.calibur")

local function get_activity_info()
    local level_name = calibur.GetLevelName()

    -- In a Battle
    if string.match(level_name, "^STG") then
        local player_index = calibur.GetPlayerSide()
        print(string.format("Player Side: %s", player_index))
        local char_id = nil

        -- Only run character logic if the player is not local
        if player_index > 0 then
            local character = calibur.GetBattleCharacter(player_index)
            print(character:GetFullName())

            char_id = calibur.character.GetCharacterID(character)
            print(char_id)

            if calibur.structs.IsBlacklisted(char_id) then
                -- Random fallback ID
                char_id = 999
            end
        end

        local action = "VS CPU"

        if calibur.IsTrainingMode() then
            if calibur.IsMockBattle() then
                action = "Mock Battle"
            else
                action = "Training"
            end
        elseif calibur.IsLocalPVP() then
            action = "Local Versus"
        elseif calibur.IsCPUMatch() then
            action = "CPU VS CPU"
        end

        -- Base presence
        local presence = {
            state = "Battle: " .. action,
            startTimestamp = os.time(),
            largeImageKey = string.lower(level_name),
            largeImageText = calibur.structs.GetStageText(level_name),
        }

        -- Additional presence if character index is valid
        if char_id then
            presence.smallImageKey = char_id
            presence.smallImageText = calibur.structs.GetCharacterText(char_id)
        end

        return presence
    end

    -- In Character Select
    if level_name == "Creation" then
        return {
            state = "Character Creation"
        }
    end

    -- In Character Select
    if level_name == "BattleSetup" then
        return {
            state = "Character Select"
        }
    end



    -- Unknown State
    return {
        state = "Waiting",
    }
end

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    ExecuteWithDelay(1000, function()
        print(calibur.GetLevelName())
        calibur.discord.UpdatePresence(get_activity_info())
    end)
end)



RegisterHook("/Script/LuxorGame.LuxBattleLevelScriptActor:OnRoundStarted", function()
    print("Battle Restarted")
end)

calibur.discord.Initialise(1430288174047039510, 544750)