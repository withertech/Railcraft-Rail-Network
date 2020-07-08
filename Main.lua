
-- Import libraries
local GUI = require("GUI")
local system = require("System")
local component = require("component")
local filesystem = require("Filesystem")
local ticket = component.get("ticket_machine")

---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 80, 40, 0xE1E1E1))


-- Get localization table dependent of current system language
local localization = system.getCurrentScriptLocalization()

local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 2, 2))
local comboBox = layout:addChild(GUI.comboBox(1, 1, 30, 3, 0xDDDDDD, 0x2D2D2D, 0xCCCCCC, 0x888888))
local printButton = layout:addChild(GUI.button(1, 1, 26, 3, 0xEEEEEE, 0x000000, 0xAAAAAA, 0x0, "Print Ticket"))
local adminTextBox = layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, nil, "New Station Name"))
local adminSaveButton = layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Save"))
local adminAddButton = layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Add Station"))
local adminRemoveButton = layout:addChild(GUI.button(1, 1, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Remove Station"))
layout:setPosition(1, 1, comboBox)
layout:setPosition(2, 1, printButton)
layout:setPosition(1, 2, adminTextBox)
layout:setPosition(1, 2, adminSaveButton)
layout:setPosition(2, 2, adminRemoveButton)
layout:setPosition(2, 2, adminAddButton)
printButton.onTouch = function()
  ticket.setDestination(comboBox:getItem(comboBox.selectedItem).text)
  ticket.printTicket(1)
end
adminSaveButton.onTouch = function()
  filesystem.write("/Users/" .. system.getUser() .. "/Application data/Rail Network/stations", "")
  for i = 1, comboBox:count() do
    filesystem.append("/Users/" .. system.getUser() .. "/Application data/Rail Network/stations", comboBox:getItem(i).text .. "\n")
  end
end
adminAddButton.onTouch = function()
  comboBox:addItem(adminTextBox.text)
end
adminRemoveButton.onTouch = function()
  comboBox:removeItem(comboBox.selectedItem)
end


-- Create callback function with resizing rules when window changes its' size
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
stations = filesystem.readLines("/Users/" .. system.getUser() .. "/Application data/Rail Network/stations")
for i,line in ipairs(stations) do
  comboBox:addItem(line)
end
workspace:draw()

