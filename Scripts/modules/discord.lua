local discordRPC = require("discord_rpc")
local discord = {}

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