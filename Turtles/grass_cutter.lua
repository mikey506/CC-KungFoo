-----------------------------------------------------
--      Terrain Stabilizing Turtle Script
--   Removes grass below, fills with dirt, and
--   discards unwanted items like stone.
-----------------------------------------------------
 
-----------------------------------------------------
--               Configuration
-----------------------------------------------------
local radius = 10         -- Radius to cover
local dirtSlot = 1        -- Slot in inventory containing dirt
local movementSpeed = 0.5 -- Seconds per move
 
-----------------------------------------------------
--          Local Position & Orientation
-----------------------------------------------------
local curX, curY, curZ = 0, 0, 0
local orientation = 0
 
-----------------------------------------------------
--       Orientation & Movement Helpers
-----------------------------------------------------
local function turnLeft()
  turtle.turnLeft()
  orientation = (orientation - 1) % 4
end
 
local function turnRight()
  turtle.turnRight()
  orientation = (orientation + 1) % 4
end
 
local function forward()
  if turtle.forward() then
    if orientation == 0 then curX = curX + 1
    elseif orientation == 1 then curZ = curZ + 1
    elseif orientation == 2 then curX = curX - 1
    elseif orientation == 3 then curZ = curZ - 1
    end
    return true
  end
  return false
end
 
-----------------------------------------------------
--         Grass and Dirt Handling
-----------------------------------------------------
-- Checks if a block name is grass (not grass block)
local function isGrassBlock(blockName)
  return blockName == "minecraft:grass"
end
 
-- Ensures the block below is filled with dirt if it is grass
local function handleBlockBelow()
  local success, data = turtle.inspectDown()
  if success and data then
    if isGrassBlock(data.name) then
      turtle.digDown()  -- Remove the grass block
    end
  end
 
  -- Place dirt if needed
  turtle.select(dirtSlot)
  if not turtle.placeDown() then
    print("Warning: No dirt available to place!")
  end
end
 
-- Discards unwanted items (stone, etc.) from the inventory
local function discardUnwantedItems()
  for slot = 1, 16 do
    local count = turtle.getItemCount(slot)
    if count > 0 then
      local item = turtle.getItemDetail(slot)
      if item and item.name ~= "minecraft:dirt" then
        turtle.select(slot)
        turtle.drop()
      end
    end
  end
  turtle.select(1) -- Reset to the first slot
end
 
-----------------------------------------------------
--         Radius and Movement Logic
-----------------------------------------------------
-- Checks if a position is within the specified radius
local function withinRadius(x, z)
  return (x * x + z * z) <= (radius * radius)
end
 
-- Moves the turtle back to the origin
local function moveToStart()
  while curX > 0 do turnLeft(); forward(); turnRight() end
  while curX < 0 do turnRight(); forward(); turnLeft() end
  while curZ > 0 do turnLeft(); forward(); turnRight() end
  while curZ < 0 do turnRight(); forward(); turnLeft() end
  while orientation ~= 0 do turnRight() end
end
 
-- Moves to the next row in the grid for systematic coverage
local function moveToNextRow(startX, z)
  if (z % 2 == 0) then
    turnRight()
    forward()
    turnRight()
  else
    turnLeft()
    forward()
    turnLeft()
  end
end
 
-----------------------------------------------------
--          Main Terrain Stabilizing Logic
-----------------------------------------------------
local function stabilizeTerrain()
  moveToStart() -- Start at origin
  local startX, startZ = curX, curZ
 
  for z = -radius, radius do
    for x = -radius, radius do
      if withinRadius(x, z) then
        handleBlockBelow()  -- Manage block below
        discardUnwantedItems() -- Clean up inventory
        forward()
      end
    end
    if withinRadius(startX, z + 1) then
      moveToNextRow(startX, z)
    end
  end
end
 
-----------------------------------------------------
--                    MAIN
-----------------------------------------------------
print("Starting Terrain Stabilizing Turtle!")
print("Radius: " .. radius)
print("Dirt Slot: " .. dirtSlot)
print("Press Ctrl+T to stop.")
 
stabilizeTerrain()
 
print("Terrain stabilizing complete!")
 
