-- Color functions
local c = {
    r = function(text)
        term.setTextColor(colors.red)
        term.write(text)
        term.setTextColor(colors.white)
    end,
    g = function(text)
        term.setTextColor(colors.green)
        term.write(text)
        term.setTextColor(colors.white)
    end,
    b = function(text)
        term.setTextColor(colors.blue)
        term.write(text)
        term.setTextColor(colors.white)
    end,
    y = function(text)
        term.setTextColor(colors.yellow)
        term.write(text)
        term.setTextColor(colors.white)
    end,
    bl = function(text)
        term.setTextColor(colors.black)
        term.write(text)
        term.setTextColor(colors.white)
    end,
    wh = function(text)
        term.setTextColor(colors.white)
        term.write(text)
        term.setTextColor(colors.white)
    end
}
 
 
-- Function to handle attacking without turning
local function cycleAttack()
    -- Attack sequence for each move forward
    if turtle.attack() then
        c.r("WRN: ")
        c.b("Attacked ")
        c.g("Front")
        print()
    end
    if turtle.attackUp() then
        c.r("WRN: ")
        c.b("Attacked ")
        c.g("Top")
        print()
    end
    if turtle.attack() then
        c.r("WRN: ")
        c.b("Attacked ")
        c.g("Front")
        print()
    end
end
 
local movementSpeed = 0.5  -- Default movement speed
local consecutiveEmptyCount = 0
local lastMoves = {} -- Table to store the last moves made by the turtle
 
term.clear()
term.setCursorPos(1, 1)
print("--==( Turtle Function Activity )==--")
local serverID = 211  -- Replace with your server's ID
openRednetConnection(serverID)
 
 
-- Function to set the movement speed
local function setMovementSpeed(speed)
    movementSpeed = speed
    c.bl("movementSpeed: " .. movementSpeed)
    print()
end
 
-- Function to reverse the last 4 moves
local function reverseLast4Moves()
    c.r("WRN: ")
    c.g("Excess_EDGE ")
    c.b("Reversing last 4 moves")
    print()
 
    -- Reverse the last 4 moves (in reverse order)
    for i = 1, 4 do
        local lastMove = table.remove(lastMoves)
        if lastMove == 3 then  -- Forward
            turtle.back()
        elseif lastMove == 1 then  -- Left
            if not turtle.detect() then
                if not turtle.turnRight() then
                    c.r("WRN: ")
                    c.g("Blocked while turning right during reversal")
                    print()
                end
                if not turtle.forward() then
                    c.r("WRN: ")
                    c.g("Blocked during forward move during reversal")
                    print()
                end
            else
                c.r("WRN: ")
                c.g("Blocked during left turn during reversal")
                print()
            end
        elseif lastMove == 2 then  -- Right
            if not turtle.detect() then
                if not turtle.turnLeft() then
                    c.r("WRN: ")
                    c.g("Blocked while turning left during reversal")
                    print()
                end
                if not turtle.forward() then
                    c.r("WRN: ")
                    c.g("Blocked during forward move during reversal")
                    print()
                end
            else
                c.r("WRN: ")
                c.g("Blocked during right turn during reversal")
                print()
            end
        end
    end
end
 
-- Function to move forward, left, or right with collision detection and avoidance
local function moveRandomly()
    local direction = math.random(1, 4)  -- Randomly choose a direction (1: left, 2: right, 3-4: forward)
    table.insert(lastMoves, direction)  -- Add the current move to the lastMoves table
 
    -- Attempt to move in the chosen direction
    if direction >= 3 and direction <= 4 then
        local detectSuccess, blockData = turtle.inspectDown()
 
        if detectSuccess and (blockData.name == "minecraft:sand" or blockData.name == "minecraft:air" or blockData.name == "minecraft:water") then
            c.r("WRN: ")
            c.g("Det: "..blockData.name)
            c.wh(" - ")
            c.wh("MV ")
            c.y("Back2 Right2")
            print()
            turtle.back(2)
            turtle.turnRight(2)
            consecutiveEmptyCount = consecutiveEmptyCount + 1
            if consecutiveEmptyCount >= 3 then
                reverseLast4Moves()  -- Reverse the last 3 moves
                return
            end
            return
        else
            consecutiveEmptyCount = 0
            if turtle.forward() then
                return
            else
                c.r("WRN: ")
                c.b("Blocked ")
                c.g("FORWARD_RIGHT")
                print()
                turtle.turnRight()
                return
            end
        end
    end
    if direction == 1 then
        if not turtle.detect() then
            if turtle.turnLeft() then
                cycleAttack()
                if turtle.forward() then
--                    c.g("NOTE: ")
--                    c.b("Move  ")
--                    c.y("LEFT & FORWARD")
--                    print()
                else
                    c.g("NOTICE: ")
                    c.r("Move LEFT ")
                    c.g("LEFT")
                    print()
                end
            else
                c.r("WRN: ")
                c.b("Locked while turning left")
                print()
            end
        elseif direction == 2 then
            if not turtle.detect() then
                if turtle.turnRight() then
                    if turtle.forward() then
                        c.g("NOTE: ")
                        c.r("Move ")
                        c.b("RIGHT")
                        print()
                        return
                    else
                        c.g("NOTICE: ")
                        c.r("Move ")
                        c.b("RIGHT")
                        print()
                        turtle.turnRight()
                        return
                    end
                else
                    c.r("WRN: ")
                    c.b("Blocked ")
                    c.g("while turning right")
                    print()
                end
            end
        end
    end
end
 
-- Usage: Replace 'serverID' with the ID of your server
local serverID = 122  -- Replace with your server's ID
openRednetConnection(serverID)
 
 
-- Main loop
while true do
    moveRandomly()
    sleep(movementSpeed)  -- Pause between movements
end
