-- I don't like repetitive-pattern like spells in games so I approached the example in a chaotic way. As I researched, I realized this over-time object spawning in random positions can only be achieved by multiple initializations.
-- Every time we run the server, some constants change. Such as : interval, spellAreas.

local casts = {}
--random interval between each spell casting
local interval = math.random(400, 600)
-- random area
local function randomizeEffectArea()
    local area = {}
    local onesCount = 0  -- counter for 1s

    for i = 1, 7 do
        local row = {}
        for j = 1, 7 do
            local value
            if i == 4 and j == 4 then
                value = 2
            else
                value = math.random(0, 1)
                if value == 1 then
                    onesCount = onesCount + 1
                end
            end
            table.insert(row, value)
        end
        table.insert(area, row)
    end

    -- 1s > half
    if onesCount <= 24 then
        -- if fail, repeat
        return randomizeEffectArea()
    end

    return area
end

-- feel free to populate for more areas. you should also increase the loopsize at ln 29
local spellAreas = {
    randomizeEffectArea(),
    randomizeEffectArea(),
    randomizeEffectArea(),
    randomizeEffectArea(),
    randomizeEffectArea(),
    randomizeEffectArea(),
    randomizeEffectArea(),
    randomizeEffectArea()
}

local i = 1
local areaIndex

repeat
    casts[i] = Combat()
    -- copied params from eternal winter spell
    casts[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    casts[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    areaIndex = i % #spellAreas

    if areaIndex == 0 then
        areaIndex = #spellAreas
    end
    -- iteration and setup after each area
    casts[i]:setArea(createCombatArea(spellAreas[areaIndex]))
    -- copied params from eternal winter spell
    function onFormulaValues(player, level, magicLevel)
        local min = (level / 5) + (magicLevel * 5.5) + 25
        local max = (level / 5) + (magicLevel * 11) + 50
        return -min, -max
    end

    casts[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onFormulaValues")

    i = i + 1
until i == 8

-- for delayed/duration casting, we need to use addEvent with standard onCastSpell
local function initCasting(index, creatureId, variantNumber)
    local creature = Creature(creatureId)
    if not creature then
        return
    end

    local variant = Variant(variantNumber)
    if not variant then
        return
    end

    casts[index]:execute(creature, variant)
end

function onCastSpell(creature, variant)
    -- first init without delay
    casts[1]:execute(creature, variant)

    for i = 2, #casts do
        addEvent(initCasting, interval * (i - 1), i, creature:getId(), variant:getNumber())
    end

    return true
end
