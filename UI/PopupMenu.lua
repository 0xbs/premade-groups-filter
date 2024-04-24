-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2024 Bernhard Saumweber
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
-------------------------------------------------------------------------------

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

local popupMenus = {}
local popupMenuActive
local popupFrame
local popupEntrySelected = {}

-- entry = { title = "", value = 0, func = function (entry) end }

function PGF.PopupMenu_Register(name, entries, parent, anchorPoint, relativeTo, relativePoint, offsetX, offsetY, minWidth, maxWidth, fontSize)
    popupMenus[name] = {
        entries = entries,
        parent = parent or UIParent,
        anchorPoint = anchorPoint,
        relativeTo = relativeTo or UIParent,
        relativePoint = relativePoint,
        offsetX = offsetX,
        offsetY = offsetY,
        minWidth = minWidth,
        maxWidth = maxWidth,
        fontSize = fontSize or 12
    }
end

function PGF.PopupMenu_Initialize(name)
    local menu = popupMenus[name]

    -- create frame if it does not yet exist
    if not popupFrame then
        popupFrame = CreateFrame("Frame", nil, nil, "PremadeGroupsFilterPopupMenuFrameTemplate")
        popupFrame:EnableKeyboard(true)
        popupFrame:SetScript("OnKeyDown", function (self, key)
            if key == GetBindingKey("TOGGLEGAMEMENU") then
                PGF.PopupMenu_Hide()
                self:SetPropagateKeyboardInput(false)
            else
                self:SetPropagateKeyboardInput(true)
            end
        end)
    end

    -- set up buttons
    local buttonWidth = menu.minWidth
    local buttonHeight = 20
    local buttonOffsetY = -4
    if not popupFrame.Buttons then popupFrame.Buttons = {} end
    for i, entry in ipairs(menu.entries) do
        -- create new buttons if necessary
        local button = popupFrame.Buttons[i]
        if not button then
            popupFrame.Buttons[i] = CreateFrame("Button", nil, popupFrame, "PremadeGroupsFilterPopupMenuButtonTemplate")
            button = popupFrame.Buttons[i]
            button:SetID(i)
        end
        button.Text:SetText(entry.title)
        button.Text:SetFont(button.Text:GetFont(), menu.fontSize)
        local width = button.Text:GetStringWidth() + 16
        if width > buttonWidth and width >= menu.minWidth and width <= menu.maxWidth then buttonWidth = width end
        button:SetScript("OnClick", function (self)
            popupEntrySelected = entry
            entry.func(entry)
            PGF.PopupMenu_Hide()
        end)
        button:SetSize(buttonWidth, buttonHeight)
        button:SetPoint("TOPLEFT", 6, buttonOffsetY)
        button:Show()
        buttonOffsetY = buttonOffsetY - buttonHeight
    end
    -- make sure all entries have the same width
    for i = 1, #popupFrame.Buttons do
        popupFrame.Buttons[i]:SetWidth(buttonWidth)
    end
    -- hide unused buttons
    for i = #menu.entries + 1, #popupFrame.Buttons do
        popupFrame.Buttons[i]:Hide()
    end

    -- set up frame
    popupFrame.menu = name
    popupFrame:SetSize(buttonWidth + 12, abs(buttonOffsetY) + 4)
    popupFrame:SetParent(menu.parent)
    popupFrame:SetFrameStrata("FULLSCREEN_DIALOG")
    popupFrame:ClearAllPoints()
    if menu.anchorPoint == "cursor" then
        local x, y = GetCursorPosition()
        local scale = popupFrame:GetEffectiveScale()
        popupFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x/scale - 4, y/scale + 4)
    elseif menu.anchorPoint then
        popupFrame:SetPoint(menu.anchorPoint, menu.relativeTo, menu.relativePoint, menu.offsetX, menu.offsetY)
    end
    popupFrame:SetBackdropBorderColor(0.5, 0.5, 0.5)
end

function PGF.PopupMenu_Show(name)
    popupMenuActive = name
    PGF.PopupMenu_Initialize(name)
    popupFrame:Show()
end

function PGF.PopupMenu_Hide()
    popupMenuActive = nil
    if popupFrame then popupFrame:Hide() end
end

function PGF.PopupMenu_Toggle(name)
    if popupMenuActive == name then PGF.PopupMenu_Hide(name) else PGF.PopupMenu_Show(name) end
end

function PGF.Popup_GetSelectedEntry()
    return popupEntrySelected
end
