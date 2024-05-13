function printSmallGuildNames(memberCount)
    -- Check if the given parameter exists, otherwise return or throw an exception
    if not memberCount then
        return
    end

    -- Prepare the SQL query with a placeholder for the member count
    local selectGuildQuery = string.format("SELECT name FROM guilds WHERE max_members < %d;", memberCount)

    -- Execute the query and store the result
    local result = db.storeQuery(selectGuildQuery)

    -- If there are no results, return or throw an exception
    if not result then
        return
    end

    -- Iterate through the results and print the guild names
    while result.next() do
        local guildName = result.getString("name")
        print(guildName)
    end

    -- Dispose result
    result.free()
end
