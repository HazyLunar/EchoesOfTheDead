--[[
-------------------------------------------------------------------------------------
               Echoes of the Dead Mod for Project Zomboid - Main Logic
-------------------------------------------------------------------------------------
    Author: Hazy Lunar
    Description: An active contributor and modder for Project Zomboid.

    Purpose: The "Echoes of the Dead" mod amplifies the eeriness of Project Zomboid by
             playing randomized, haunting zombie screams whenever a zombie is killed.
             The chilling echoes serve as a stark reminder of the apocalyptic setting,
             enhancing the game's atmosphere and immersion.

    Support Me: If you value my modding endeavors and wish to support me, consider
                commissioning a mod. I offer this service for a modest fee under $50,
                adjusted depending on the mod's complexity. Your support allows me
                to continue creating and refining mods for the community.
                If you feel grateful or just fancy buying me a coffee, visit: https://ko-fi.com/hazylunar

    Contact: I always appreciate feedback, innovative ideas, or collaborative opportunities.
             Don't hesitate to reach out if you have any suggestions or are curious about
             potential modding projects. Connecting with fellow PZ enthusiasts is a joy!
-------------------------------------------------------------------------------------
]]

-- EchoesOfTheDead.lua Uncommon Version

local zombieSounds = {
    "EchoScream1", "EchoScream2", "EchoScream3", "EchoScream4", "EchoScream5",
    "EchoScream6", "EchoScream7", "EchoScream8"
}

local function PlayEchoSoundForPlayer(player)
    local playerLocation = player:getCurrentSquare()
    local screamChanceRoll = ZombRand(1, 100)
    local screamLoudness = ZombRand(50, 110)
    local screamDistance = ZombRand(70, 250)

    if screamChanceRoll <= 5 then
        local soundToPlay = zombieSounds[ZombRand(1, #zombieSounds)]

        -- Checking if player has a valid emitter before playing sound
        local emitter = player:getEmitter()
        if emitter then
            emitter:playSound(soundToPlay)

            if playerLocation then
                getWorldSoundManager():addSound(player, playerLocation:getX(), playerLocation:getY(),
                    playerLocation:getZ(), screamDistance, screamLoudness)
            else
                print("Failed to get player's current square.")
            end
        else
            print("Failed to get emitter for player.")
        end
    end
end

local function EchoesOfTheDead(zombie)
    local onlinePlayers = getOnlinePlayers()
    if onlinePlayers and onlinePlayers:size() > 0 then -- Multiplayer mode
        for i = 0, onlinePlayers:size() - 1 do
            local player = onlinePlayers:get(i)
            if player then
                PlayEchoSoundForPlayer(player)
            else
                print("Warning: Player at index " .. i .. " is null!")
            end
        end
    else                                    -- Singleplayer mode
        local player = getSpecificPlayer(0) -- Singleplayer character is always at index 0
        if player then
            PlayEchoSoundForPlayer(player)
        else
            print("Error: Singleplayer character not found!")
        end
    end
end

Events.OnZombieDead.Add(EchoesOfTheDead)
