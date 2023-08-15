-- You can use AE to boxing the beehive
-- And the program will automatically check and fill the blocks in 1~4 slots
local component = require("component")
local robot = require("robot")
local computer = require("computer")

-- movement fuction
local function move()
  while not robot.forward() do
    os.sleep(0.5)
  end
end

-- check items id
local function getSlotItemINM(item)
  local itemINM = component.inventory_controller.getStackInInternalSlot(item)
  local minecraftId = itemINM.id .. "/" .. itemINM.damage
  return minecraftId
end

-- slot items count
local function countItemsInSlot(slot)
  robot.select(slot)
  return robot.count()
end

-- transfer between slots
local function indexNoneItems(start, item)
  local itemId = nil
  for slot = start + 1, robot.inventorySize() do
    if countItemsInSlot(slot) > 0 then
      itemId = getSlotItemINM(slot)
      if itemId == item then
        robot.select(slot)
        robot.transferTo(start)
      end
    end
    if countItemsInSlot(start) ~= 0 then
      return
    end
  end
end

-- place fuction
local function placeItem()
  robot.select(1) -- stone layer
  local itemINM1 = getSlotItemINM(1)
  robot.placeDown()
  if countItemsInSlot(1) == 0 then
    indexNoneItems(1, itemINM1)
    robot.select(1)
    robot.placeDown()
  end
  robot.up()
  robot.select(2) -- cable layer
  local itemINM2 = getSlotItemINM(2)
  robot.placeDown()
  if countItemsInSlot(2) == 0 then
    indexNoneItems(2, itemINM2)
    robot.select(2)
    robot.placeDown()
  end
  robot.up()
  robot.select(3) -- beehive layer
  local itemINM3 = getSlotItemINM(3)
  robot.placeDown()
  if countItemsInSlot(3) == 0 then
    indexNoneItems(3, itemINM3)
    robot.select(3)
    robot.placeDown()
  end
  robot.select(4) -- cover layer
  local itemINM4 = getSlotItemINM(4)
  component.inventory_controller.equip()
  robot.useDown()
  component.inventory_controller.equip()
  if countItemsInSlot(4) == 0 then
    indexNoneItems(4, itemINM4)
    robot.select(4)
    robot.placeDown()
  end
end

-- main
local function main()
  robot.up() -- Ready to put blocks
  for i = 1, 10 do
    for j = 1, 10 do
      placeItem()
      if j < 10 then
        move()
        robot.down()
        robot.down()
      end
    end

    if i % 2 == 1 then
      robot.turnRight()
      move()
      robot.down()
      robot.down()
      robot.turnRight()
    else
      robot.turnLeft()
      move()
      robot.down()
      robot.down()
      robot.turnLeft()
    end
  end
  robot.turnLeft()
  for k = 1, 10 do
    robot.forward()
  end
  robot.turnRight()
end

main()
computer.shutdown()
