--#(ComputerCraft) CC-Tweaked: Simple Script to help keep weather n environmental factors using Command Computer
 
if not commands then
  print("Error: Command Computer required to execute this script")
  error()
end
 
commands.execAsync("time set day")
commands.execAsync("weather clear")
print("Cleared up weather and reset time")
 
print("Coordinates: ", gps.locate())
 
local home = vector.new(0, 70, 0)
local position = vector.new(gps.locate())
local displacement = position - home
 
print("I am ", tostring(displacement), "from the middle of the map")
 
 
