for i, side in ipairs(rs.getSides()) do --#Loop for each side on the computer that redstone can be used, these can also be used by modems.
if peripheral.getType(side) == 'modem' then --#Did we find a modem... Or some other peripheral?
  print('Found Modem On Side '..side.."!")
  rednet.open(side)
    wireless = peripheral.wrap(side)
  break --#Opened modem, dont open any others.
end
end
function sendMessage(destination, message, protocol)
print("Hive: ",message)
if destination and message then
  rednet.send(destination, message, protocol)
end
end
print("Sending Init command")
print("Drone: ")
print("-ID: ",id)
local locatm = gps.locate(Mikey506)
local initmsg = "INIT ABC123 "
print("-Location: ",gps.locate())
sendMessage(1, initmsg)
function waitForMessage(displayMessage)
  local sender, message, protocol = rednet.receive()
  print(protocol)
    if displayMessage then 
    print("In: ",message)
    if message == "MOVEUP" then 
      turtle.up()
      waitForMessage(true)
    end
    if message == "MOVEDOWN" then 
      turtle.down()
      waitForMessage(true)
    end
        if message == "MOVERIGHT" then 
      turtle.turnRight()
      waitForMessage(true)
    end
        if message == "MOVELEFT" then 
      turtle.turnLeft()
      waitForMessage(true)
    end
    if message == "MOVEFORWARD" then 
      turtle.forward()
      waitForMessage(true)
    end
        if message == "MOVEBACKWARD" then 
      turtle.back()
      waitForMessage(true)
    end
  end
end
waitForMessage(true)
