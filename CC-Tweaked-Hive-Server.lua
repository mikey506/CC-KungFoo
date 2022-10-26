for i, side in ipairs(rs.getSides()) do --#Loop for each side on the computer that redstone can be used, these can also be used by modems.
if peripheral.getType(side) == 'modem' then --#Did we find a modem... Or some other peripheral?
    print('Found Modem On Side '..side.."!")
    rednet.open(side)
    wireless = peripheral.wrap(side)
    break --#Opened modem, dont open any others.
  end
end

function sendMessage(destination, message, protocol)
  print("Dest: ",destination)
  print("message: ",message)
  if destination and message then
    rednet.send(destination, message, protocol)
    return message
  end
end


function waitForMessage(displayMessage)
  local sender, message, protocol = rednet.receive()
    if displayMessage then 
    print(message)
--    if message == "INIT ABC123" then
--      sendMessage(sender, "CONNECTION_OK", protocol)
--    end
    sendMessage(sender, "MOVEUP", protocol)
    sleep(1)
    sendMessage(sender, "MOVEDOWN", protocol) 
    sleep(1)
    sendMessage(sender, "MOVELEFT", protocol) 
    sleep(1)
    sendMessage(sender, "MOVERIGHT", protocol) 
    sleep(1)
    sendMessage(sender, "MOVEFORWARD", protocol) 
    sleep(1)
    sendMessage(sender, "MOVEBACKWARD", protocol) 
    else return message 
  end
  waitForMessage(true)
end

waitForMessage(true)
