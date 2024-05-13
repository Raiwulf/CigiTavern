-- I would define constants for easier read/modifications
local storageIndex <const> = 1000
local releaseStorageDelay <const> = 1000

local function releaseStorage(player)
    -- I would check if the given parameter exist, otherwise return or throw exception

    if not player then
        return
    end

    player:setStorageValue(storageIndex, -1)
    end

function onLogout(player)
    -- I would check if the given parameter exist, otherwise return or throw exception
    if not player then
        return
    end

    if player:getStorageValue(storageIndex) == 1 then
        addEvent(releaseStorage, releaseStorageDelay, player)
    end

    return true
end