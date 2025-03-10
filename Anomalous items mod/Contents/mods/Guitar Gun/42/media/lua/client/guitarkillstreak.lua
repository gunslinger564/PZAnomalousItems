


local GunGuitarKillStreak = {}

-- Settings you can tweak
GunGuitarKillStreak.streakTimeout = 15 -- seconds before streak resets
GunGuitarKillStreak.weaponFullType = "HMW.H_ElectricGunGuitar" -- your weapon's full type
GunGuitarKillStreak.streakSounds = {
    [3] = "GuitarLick1", -- play at 3 kills
    [5] = "GuitarLick2", -- play at 5 kills
    [10] = "GuitarLick3", -- play at 10 kills
    [15] = "GuitarLick4", -- play at 15 kills
}

-- Variables to track state
GunGuitarKillStreak.currentStreak = 0
GunGuitarKillStreak.lastKillTime = 0


-- Listen for OnZombieDead event
Events.OnZombieDead.Add(function(zombie)
    -- Get the player and their weapon
    local player = getSpecificPlayer(0)
    if not player then return end
    
    local weapon = player:getPrimaryHandItem()
    if not weapon then return end
    
    -- Check if they're using our guitar gun
    if weapon:getFullType() ~= GunGuitarKillStreak.weaponFullType then return end
    
    -- It's a kill with our weapon! Update streak
        local currentTime = getTimestamp()

    -- Check if streak has timed out
    if (currentTime - GunGuitarKillStreak.lastKillTime) > GunGuitarKillStreak.streakTimeout then
        GunGuitarKillStreak.currentStreak = 0
    end
    
    -- Increment streak and update time
    GunGuitarKillStreak.currentStreak = GunGuitarKillStreak.currentStreak + 1
    GunGuitarKillStreak.lastKillTime = currentTime
    
    -- Check if we should play a sound for this streak level
    local streakSound = GunGuitarKillStreak.streakSounds[GunGuitarKillStreak.currentStreak]
    if streakSound then
        -- Play the guitar lick!
        getSoundManager():PlayWorldSound(streakSound, player:getSquare(), 0, 8, 1, false)
        
        -- Optionally show the streak count on screen
        player:Say("Kill streak: " .. tostring(GunGuitarKillStreak.currentStreak) .. "!")
    end
end)

--[[ play random sound per shot
local currentTime
local lastTime
local count = 0
local newcount
local function guitarSound()
    local player = getSpecificPlayer(0)
    newcount = newcount or count
    if not player then return end

    local weapon = player:getPrimaryHandItem()
    if not weapon then return end
    
    -- Check if they're using our guitar gun
    if weapon:getFullType() ~= "HMW.H_ElectricGunGuitar" then return end
    if newcount > count + 20 then
        newcount =  count
        local sub = weapon:getSwingSound():sub(-1)
        sub = tonumber(sub)
        if sub < 2 then
            weapon:setSwingSound("guitarShoot"..sub+1)
        else weapon:setSwingSound("guitarShoot0")
        end
    end
    newcount = newcount +1
end
Events.OnTick.Add(guitarSound)--]]