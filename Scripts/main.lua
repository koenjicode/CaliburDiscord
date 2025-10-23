local calibur = require("modules.calibur")

local preview_character_present = false

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
        end

        local action = "VS CPU"

        if calibur.IsTrainingMode() then
            if calibur.IsMockBattle() then
                action = "Mock Battle"
            else
                action = "Training Mode"
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
            if calibur.IsUsingCreation() then
                local name = calibur.GetCharacterName()
                if calibur.text.IsAllUppercase(name) then
                    name = calibur.text.FormatText(name)
                end
                local style = calibur.structs.GetCharacterText(char_id)
                presence.smallImageKey = "999"
                presence.smallImageText = string.format("%s (%s)", name, style)
            else
                presence.smallImageKey = char_id
                presence.smallImageText = calibur.structs.GetCharacterText(char_id)
            end
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
        if preview_character_present then
            return {
                state = "Character Select"
            }
        end
    end



    -- Unknown State
    return {
        state = "Waiting",
    }
end

NotifyOnNewObject("/Game/UI/Preview/BP_LuxPreviewCharaStudio.BP_LuxPreviewCharaStudio_C", function(ConstructedObject)
    preview_character_present = true
    print(string.format("Constructed: %s\n", ConstructedObject:GetFullName()))
    if true then

    end
end)

RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    preview_character_present = false
    ExecuteWithDelay(1000, function()
        print(calibur.GetLevelName())
        calibur.discord.UpdatePresence(get_activity_info())
    end)
end)

calibur.discord.Initialise(1430288174047039510, 544750)