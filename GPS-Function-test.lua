[[--

Script used for testing out command computers with GPS functionality 

--]]

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
 
 
function getPlayers(radius,x,y,z)
  if x then x = "x="..x else x = "" end
  if y then y = ",y="..y else y = "" end
  if z then z = ",z="..z else z = "" end
  local command = "0 @a"
  if radius then
        command = "0 @a["..x..y..z..(",r="..radius).."]"
  end
  local state,result = commands.xp(command)
  local players = {}
  for i = 1, #result do
        table.insert(players,string.match(result[i],"Given 0 experience to (%w+)"))
  end
  return players
end
 
function getPlayer(name)
  local state,result = commands.tp(name.." ~ ~ ~")
  if not state then return false end
  return result[1]:match( "Teleported %S+ to (.?%d+%.?%d*),(.?%d+%.?%d*),(.?%d+%.?%d*)" )
end
 
function kill(name)
  local state1,result1 = commands.gamemode("0 "..name)
  sleep(0.1)
  local state2,result2 = commands.effect(name.." 7 4 100")
  return state1 and state2
end
 
local temp = getPlayer("Emiloons")
print(temp)
--#local ec1 = gettok(temp, 1, 44)
--#local ec2 = gettok(temp, 2, 44)
--#local ec3 = gettok(temp, 3, 44)
 
print("Is Emiloons online?: "..temp)
print("Results: ", getPlayers())
