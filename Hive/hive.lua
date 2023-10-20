local computerID = os.getComputerID()
 
-- Find modems
local modemSide = "top"     -- Replace with the correct side where your wireless modem is connected
local monitorSide = "right" -- Replace with the correct side where your monitor is connected
 
-- Check if the modem exists on the specified side
if peripheral.isPresent(modemSide) and peripheral.getType(modemSide) == "modem" then
    print("Modem found on the specified side: " .. modemSide)
 
    -- Check if the monitor exists on the specified side
    if peripheral.isPresent(monitorSide) and peripheral.getType(monitorSide) == "monitor" then
        print("Monitor found on the specified side: " .. monitorSide)
        print("Computer/Turtle ID: " .. computerID)
 
        -- Open the Rednet channel
        rednet.open(modemSide)
        print("Opening Rednet channel on Side: " .. modemSide)
 
        -- Set up monitor for output
        local monitor = peripheral.wrap(monitorSide)
        monitor.clear()
        monitor.setCursorPos(1, 1)
 
        -- Initialize variables for monitor output
        local monitorLines = {}
        local maxLines = 30
 
        while true do
            local senderID, message, protocol = rednet.receive() -- No need to set a timeout
            if protocol == "TurtleLogin" then
                -- Check if the message is not empty
                if message and message ~= "" then
                    print("Received message: " .. message)
 
                    -- Handle the LOGIN request, e.g., check credentials or establish a connection.
                    -- You can add your logic here.
 
                    -- Send a LOGIN response back to the client
                    rednet.send(senderID, "LOGIN: ACCEPTED", "TurtleLoginResponse")
                else
                    print("Received an empty message.")
                    -- Optionally, you can handle empty messages here or ignore them.
                end
            else
                local logMessage = "RX: ID (" .. senderID .. "): " .. message
                print(logMessage)
                table.insert(monitorLines, logMessage)
 
                -- Limit the number of lines displayed on the monitor
                if #monitorLines > maxLines then
                    table.remove(monitorLines, 1)
                end
 
                -- Display the message on the monitor
                monitor.clear()
                monitor.setCursorPos(1, 1)
                for i, line in ipairs(monitorLines) do
                    monitor.setCursorPos(1, i)
                    monitor.write(line)
                end
                -- Optionally, you can handle unknown messages here or ignore them.
            end
        end
    else
        print("Monitor not found on the specified side: " .. monitorSide)
    end
else
    print("Modem not found on the specified side: " .. modemSide)
end
