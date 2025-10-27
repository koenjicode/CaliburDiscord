local discordRPC = require("discord_rpc")
local discord = {}

-- Mod version.
local mod_version = "v1.01.02"

-- Pick a random key between "main1" and "main2"
local random_image_index = math.random(1, 2)

-- Store the last known presence
local lastPresence = {}

-- Compare two tables (shallow)
local function HasPresenceChanged(new, old)
    for k, v in pairs(new) do
        if old[k] ~= v then
            return true
        end
    end
    for k, v in pairs(old) do
        if new[k] ~= v then
            return true
        end
    end
    return false
end

function discord.UpdatePresence(newPresence)
    if not newPresence.largeImageKey then
        newPresence.largeImageKey = random_image_index == 1 and "main1" or "main2"
        newPresence.largeImageText = "CaliburDiscord " .. mod_version
    end

    -- Only update if something actually changed
    if not HasPresenceChanged(newPresence, lastPresence) then
        return -- no change, skip
    end

    -- Perform the update
    discordRPC.updatePresence(newPresence)
    discordRPC.runCallbacks()

    -- Store new presence
    lastPresence = newPresence
end

function discord.Initialise(application_id, steam_id, auto_register)
    auto_register = auto_register or false
    discordRPC.initialize(application_id, auto_register, steam_id)
    print(string.format("Discord Initialised (%s)", discordRPC._VERSION))
end

return discord