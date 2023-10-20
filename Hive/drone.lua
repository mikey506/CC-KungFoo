local computerID = os.getComputerID()
 
-- Prompt the user to set the movement speed
while true do
    write("Enter the movement speed (0.5-2): ")
    local input = tonumber(read())
    if input and input >= 0.5 and input <= 2 then
        movementSpeed = input
        break
    else
        print("Invalid input. Please enter a value between 0.5 and 2.")
    end
end
 
-- Prompt the user to set the server ID
local serverID
while true do
    write("Enter the server ID: ")
    local input = tonumber(read())
    if input then
        serverID = input
        break
    else
        print("Invalid input. Please enter a numeric server ID.")
    end
end
 
-- Store whether the turtle is authenticated
local authenticated = false
 
local function cycleAttack(serverID)
    local attackedFront = false
    local attackedAbove = false
 
    -- Check for attacks
    if turtle.attack() then
        print("Turtle attacked in front")
        attackedFront = true
    end
 
    if turtle.attackUp() then
        print("Turtle attacked above")
        attackedAbove = true
    end
 
    -- Construct attack information
    local attackInfo = ""
    if attackedFront then
        attackInfo = "Turtle attacked in front"
        local details = turtle.inspect()
        if details and details.name then
            attackInfo = attackInfo .. " (Entity: " .. details.name .. ")"
        end
    end
 
    if attackedAbove then
        if attackedFront then
            attackInfo = attackInfo .. " and above"
        else
            attackInfo = "Turtle attacked above"
        end
 
        local details = turtle.inspectUp()
        if details and details.name then
            attackInfo = attackInfo .. " (Entity: " .. details.name .. ")"
        end
    end
 
    if attackInfo ~= "" then
        rednet.send(serverID, attackInfo, "TurtleEvent")
    end
 
    sleep(1)
end
 
-- Function to set the movement speed
local function setMovementSpeed(speed)
    movementSpeed = speed
    print("Movement speed set to: " .. movementSpeed)
end
 
-- Function to move forward, left, or right with collision detection and avoidance
local function moveRandomly(serverID)
    local direction = math.random(1, 4)  -- Randomly choose a direction (1: left, 2: right, 3-4: forward)
    local detectSuccess, blockData = turtle.inspectDown()
 
    if direction >= 3 and direction <= 4 then
        if detectSuccess and blockData then
            local blockName = blockData.name
 
            if blockName == "minecraft:sand" or blockName == "minecraft:air" or blockName == "minecraft:water" then
                rednet.send(serverID, "DETECTED: " .. blockName, "TurtleEvent")
                print("Detected " .. blockName)
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
                    cycleAttack(serverID)
                    return
                end
            end
        else
            -- Handle other cases when no block is detected
            -- ...
        end
    end
 
    if direction == 1 then
        -- Handle direction 1
        -- ...
    elseif direction == 2 then
        -- Handle direction 2
        -- ...
    end
end
 
-- Main loop
rednet.open("right")
while true do
    if not authenticated then
        print("Authenticating...")
        rednet.send(serverID, "LOGIN: Drone " .. os.getComputerID() .. " ABC2kr9AJS4dkj389", "TurtleLogin")
        local senderID, response, protocol = rednet.receive(5)
 
        if senderID == serverID and protocol == "TurtleLoginResponse" and response == "LOGIN: ACCEPTED" then
            authenticated = true
            print("Authentication successful.")
        else
            print("Authentication failed. Retrying...")
        end
    else
        moveRandomly(serverID)
        sleep(movementSpeed)  -- Pause between movements
    end
end
