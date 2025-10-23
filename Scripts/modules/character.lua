local Character = {}

function Character.GetCharacterID(battle_chara)
    return battle_chara.CharaID
end

function Character.GetWeaponID(battle_chara)
    return battle_chara.WeaponID
end

function Character.IsCreation(player_setup)
    local profile_name = player_setup.CreationProfile:GetFullName()
    print(profile_name)

    return string.find(profile_name, "Creation") ~= nil
end

function Character.GetCharacterName(player_setup)
    local char_profile = player_setup.CreationProfile
    return char_profile.characterName
end

return Character