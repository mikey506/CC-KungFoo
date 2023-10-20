local movementSpeed = 0.5  -- Default movement speed
 
-- Function to handle attacking without turning
local function cycleAttack()
    if turtle.attack() then
        print("Turtle attacked in front")
    end
    if turtle.attackUp() then
        print("Turtle attacked above")
    end
    if turtle.attack() then
        print("Turtle attacked in front again")
    end
end
 
-- Function to set the movement speed
local function setMovementSpeed(speed)
    movementSpeed = speed
    print("Movement speed set to: " .. movementSpeed)
end
 
-- Function to move forward, left, or right with collision detection and avoidance
local function moveRandomly()
    local direction = math.random(1, 4)  -- Randomly choose a direction (1: left, 2: right, 3-4: forward)
    local detectSuccess, blockData = turtle.inspectDown()
 
    if direction >= 3 and direction <= 4 then
        if detectSuccess and (blockData.name == "minecraft:sand" or blockData.name == "minecraft:air" or blockData.name == "minecraft:water") then
            print("Detected " .. blockData.name)
            local whichway = math.random(1, 2)
            print("Moving back and turning right on restricted area")
            turtle.back(2)
            if whichway == 1 then
                turtle.turnRight()
                print("Turning Right on restricted area")
            else
                turtle.turnLeft()
                print("Turning Left on restricted area")
            end
        else
            if not turtle.forward() then
                print("Turtle blocked while moving forward")
            else
                print("Turtle moving forward")
                cycleAttack()
                return
            end
        end
    elseif direction == 1 then
        if detectSuccess and (blockData.name == "minecraft:sand" or blockData.name == "minecraft:air" or blockData.name == "minecraft:water") then
            return
        end
        turtle.turnRight()
        print("Turning Right")
    elseif direction == 2 then
        if detectSuccess and (blockData.name == "minecraft:sand" or blockData.name == "minecraft:air" or blockData.name == "minecraft:water") then
            return
        end
        turtle.turnLeft()
        print("Turning Left")
    end
end
 
-- Main loop
while true do
    moveRandomly()
    sleep(movementSpeed)  -- Pause between movements
end
