local taskWindow
local toggleButton
local taskButton

local buttonX
local buttonY
local tick
local fps = 1000 / 60
local buttonMoveSpeed = 4

function init()
    taskWindow = g_ui.displayUI('task')
    taskWindow:hide()
    toggleButton = modules.client_topmenu.addLeftButton('toggleButton', tr('Show Task'), '/images/topbuttons/task.png', toggle)
    taskButton = taskWindow:recursiveGetChildById('taskButton')
end

function show()
    taskWindow:show()
    taskWindow:raise()
    taskWindow:focus()
    moveTaskButton()
end

function trigger()
    print("triggered button")
    buttonX = -1
end

function toggle()
    if taskWindow:isVisible() then
        hide()
    else
        show()
    end
end

function hide()
    taskWindow:hide()
    removeEvent(tick)
end

function terminate()
    taskWindow:destroy()
    toggleButton:destroy()
end

function moveTaskButton()
    local windowPos = taskWindow:getPosition()
    local buttonPos = taskButton:getPosition()
    buttonX = buttonPos.x - windowPos.x
    buttonY = buttonPos.y - windowPos.y

    tick = cycleEvent(updateButtonPosition, fps)
end

function updateButtonPosition()
    local windowPos = taskWindow:getPosition()
    local windowWidth = taskWindow:getWidth()
    local windowHeight = taskWindow:getHeight()

    -- Calculate the maximum allowed position for the button
    local maxX = windowPos.x + windowWidth - taskButton:getWidth()

    -- Update button position
    buttonX = math.max(windowPos.x, buttonX - buttonMoveSpeed)

    -- Reset button position if it goes beyond the left edge
    if buttonX <= windowPos.x then
        buttonX = maxX
        buttonY = math.random(windowPos.y, windowPos.y + windowHeight - taskButton:getHeight())
    end

    taskButton:setPosition({x = buttonX, y = buttonY})
end


