function removeFromParty(playerId, memberName)
    -- Check if the given parameters exist, otherwise return or throw an exception
    if not playerId or not memberName then
        return
    end

    -- Get the player object
    local player = Player(playerId)
    if not player then
        return
    end

    -- Get the party object
    local party = player:getParty()
    if not party then
        return
    end

    -- Iterate through party members to find and remove the specified member
    local members = party:getMembers()
    for _, member in pairs(members) do
        if member:getName() == memberName then
            party:removeMember(member)
            break  -- Once the member is removed, exit the loop
        end
    end
end
