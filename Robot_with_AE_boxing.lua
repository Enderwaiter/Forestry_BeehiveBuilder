local component = require("component")
local robot = require("robot")
local sides = require("sides")

-- count
-- This function is necessary.
-- If it is not present, directly detecting that there are no items in the chest will result in an error.
local function countItemsInChestSlot(slot)
  return component.inventory_controller.getSlotStackSize(sides.forward, slot)
end

local function countItemsInSlot(slot)
  robot.select(slot)
  return robot.count()
end

local function getSlotItemINM(item)
  local itemINM = component.inventory_controller.getStackInInternalSlot(item)
  return itemINM
end

-- detect
local function detect()
  local name = "gendustry:ImportCover"
  for slot = 1, 27 do
    if countItemsInChestSlot(slot) > 1 then
      local slotname = component.inventory_controller.getStackInSlot(sides.forward, slot)
      if slotname.name == name then
        component.inventory_controller.suckFromSlot(sides.forward, slot, 1)
        for islot = 1, robot.inventorySize() do
          if countItemsInSlot(islot) > 0 then
            local islotname = getSlotItemINM(islot)
            if islotname.name == name then
              robot.select(islot)
              component.inventory_controller.equip(islot)
            end
          end
        end
        robot.useDown()
        return true
      end
    end
  end
end

-- main
while true do
  if detect() then
    print("true")
    robot.select(1)
  else
    print("false")
  end
  os.sleep(3)
end
