local computerID = os.getComputerID()
local movementSpeed = 0.5
local serverID = nil
local authenticated = false
 
-- Attempt to load settings from config.json
local config = {}
 
if fs.exists("config.json") then
    local file = fs.open("config.json", "r")
    local configStr = file.readAll()
    file.close()
    config = textutils.unserialize(configStr)
end
 
-- Function to save settings to config.json
local function saveConfig()
    local file = fs.open("config.json", "w")
    file.write(textutils.serialize(config))
    file.close()
end
 
-- Prompt the user to set the movement speed if not in the config
if config.movementSpeed then
    movementSpeed = config.movementSpeed
else
    while true do
        write("Enter the movement speed (0.5-2): ")
        local input = tonumber(read())
        if input and input >= 0.5 and input <= 2 then
            movementSpeed = input
            config.movementSpeed = movementSpeed
            saveConfig()
            break
        else
            print("Invalid input. Please enter a value between 0.5 and 2.")
        end
    end
end
 
-- Prompt the user to set the server ID if not in the config
if config.serverID then
    serverID = config.serverID
else
    while true do
        write("Enter the server ID: ")
        local input = tonumber(read())
        if input then
            serverID = input
            config.serverID = serverID
            saveConfig()
            break
        else
            print("Invalid input. Please enter a numeric server ID.")
        end
    end
end
 
-- Store whether the turtle is authenticated
local authenticated = false
 
local function cycleAttack()
    local x, y, z = gps.locate()
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
        rednet.send(serverID, "ATTACK: " .. attackInfo .. " - " .. x .. "/" .. y .. "/" .. z, "TurtleEvent")
    end
 
    sleep(1)
end
 
local function moveRandomly()
    local direction = math.random(1, 4)  -- Randomly choose a direction (1: left, 2: right, 3-4: forward)
    local detectSuccess, blockData = turtle.inspectDown()
 
    local x, y, z = gps.locate()
 
    if direction >= 3 and direction <= 4 then
        if detectSuccess and blockData then
            local blockName = blockData.name
 
            if blockName == "minecraft:sand" or blockName == "minecraft:air" or blockName == "minecraft:water" then
                rednet.send(serverID, "DETECTED: " .. blockName .. " - " .. x .. "/" .. y .. "/" .. z, "TurtleEvent")
                print("Detected " .. blockName)
                local whichway = math.random(1, 2)
                print("Leaving restricted area")
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
        else
            print("No Block Detected Under Turtle, moving forward.")
            turtle.forward()
            return
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
        moveRandomly()
        sleep(movementSpeed)  -- Pause between movements
    end
end
