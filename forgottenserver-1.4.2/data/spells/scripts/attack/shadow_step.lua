local casts = {}
local interval = 100 -- Random interval between each spell casting (in milliseconds)
local range = 4 -- Range of the dash spell
local area = AREA_BEAM1 -- I was planning to register character's texture as a brush in runtime. Then I would create it with 20% alpha to %80 alpha at last brush

-- Create the spell casts
for i = 1, range do
    casts[i] = Combat()
    casts[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
    casts[i]:setArea(createCombatArea(area))
end

-- Function to move the player
local function shadowStep(creatureId, range)
    local creature = Creature(creatureId)
    local position = creature:getPosition();
    local prevPosition = Position(position);

    -- Validate vars
    if not creature or not position or not prevPosition then
        return
    end

    local posIndex=1

    repeat
        -- Get the next pos by direction
        position:getNextPosition(creature:getDirection())
        local ground = Tile(position)

        -- If not walkable, go to last walkable
        if not ground or not ground:isWalkable() then
            creature:teleportTo(prevPosition)
            return
        end

        prevPosition = Position(position)
        posIndex=posIndex+1
    until posIndex==range

    -- If nothing blocks the way, tp to pos
    creature:teleportTo(position)
end

-- Function to initiate casting with delay
local function initCasting(index, creatureId, variantNumber)
    local creature = Creature(creatureId)
    if not creature then
        return
    end

    local variant = Variant(variantNumber)
    if not variant then
        return
    end

    -- Move the player one square in the specified direction
    shadowStep(creature, creature:getDirection())
end

-- Function to handle the casting of the spell
function onCastSpell(creature, variant)
    -- Schedule the remaining casts with delay
    for i = 1, range do
        addEvent(initCasting, interval * (i - 1), i, creature:getId(), variant:getNumber())
    end

    return true
end
