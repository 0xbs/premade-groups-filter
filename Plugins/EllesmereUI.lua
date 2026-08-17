-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2026 Bernhard Saumweber
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

-- Optional support for the EllesmereUI skinning API, which paints the dialog and
-- its panels in the user's current EllesmereUI theme:
-- https://github.com/EllesmereGaming/EllesmereUI/blob/main/SKINNING_API.md
--
-- Must be loaded after all UI files.

local PGFAddonName = select(1, ...)
local PGF = select(2, ...)
local C = PGF.C

-- Checkbox geometry. The skin draws the box and its border CHECKBOX_BORDER_INSET in
-- from the edge of the frame, leaving a 16 unit box that holds a 1 unit accent ring,
-- a 2 unit gap and a 10 unit accent block.
local CHECKBOX_SIZE = 24
local CHECKBOX_BORDER_INSET = 4
local ACCENT_BORDER_SIZE = 1
local ACCENT_MARK_GAP = 2
local ACCENT_BOX_SIZE = CHECKBOX_SIZE - 2 * CHECKBOX_BORDER_INSET
local ACCENT_MARK_SIZE = ACCENT_BOX_SIZE - 2 * (ACCENT_BORDER_SIZE + ACCENT_MARK_GAP)

-- Frame level of the accent ring, relative to the checkbox.
local ACCENT_BORDER_LEVEL = 3

-- Height of the dialog footer holding the reset, settings and refresh buttons.
local FOOTER_HEIGHT = 30

-- The glyphs EllesmereUI collapses and expands with, i.e. a minus and a plus. They are
-- Blizzard atlases, but the skin has no public call for them, so the dialog draws them
-- itself the way the skin draws them on the world map: desaturated white, brightening
-- on hover.
local COLLAPSE_ATLAS = "UI-QuestTrackerButton-Secondary-Collapse"
local EXPAND_ATLAS = "UI-QuestTrackerButton-Secondary-Expand"
local GLYPH_SIZE = 16
local GLYPH_ALPHA = 0.75

-- Horizontal offset of a glyph in the title bar from the center of its button, the same
-- offset the skin gives the close button.
local GLYPH_OFFSET_X = -2

-- Padding between an input box border and its text.
local TEXT_INSET = 4

-- Geometry of the flat box the skin draws in place of the artwork of a dropdown, as
-- insets into the frame of the dropdown, which is larger than the artwork it draws.
-- The insets make the box cover exactly the span of the two input boxes of a min max
-- row, at the same height as them.
local DROPDOWN_INSET_LEFT = 22
local DROPDOWN_INSET_RIGHT = 18
local DROPDOWN_INSET_TOP = 5
local DROPDOWN_INSET_BOTTOM = 7

-- Padding between the box of a dropdown and its text, and the room the arrow drawn by
-- the skin takes up on the right of the box.
local DROPDOWN_TEXT_INSET = 10
local DROPDOWN_ARROW_ROOM = 24

-- Alpha of the accent colored highlight on a popup menu entry.
local MENU_HIGHLIGHT_ALPHA = 0.25

-- Gap between the box of a dropdown and its popup menu.
local MENU_GAP = 2

-- Skinned widgets that have to be repainted when the theme changes.
local textBoxes = {}
local checkBoxes = {}

-- The accent ring belonging to each checkbox.
local accentBorders = setmetatable({}, { __mode = "k" })

-- The dropdowns the skin has been applied to.
local dropDowns = setmetatable({}, { __mode = "k" })

-------------------------------------------------------------------------------
--  Widgets
-------------------------------------------------------------------------------

--- Skins a text button, i.e. one of the selection buttons above the dungeon and
--- delve lists, as a flat button with a fill, a border and a hover.
local function SkinTextButton(S, button)
    S.Button(button)
    S.Font(button.Label)
end

--- Creates the accent ring shown while a checkbox is checked, as four strips on a
--- frame above the border drawn by the skin. Starts out hidden.
local function CreateAccentBorder(checkBox)
    local border = CreateFrame("Frame", nil, checkBox)
    border:SetPoint("TOPLEFT", CHECKBOX_BORDER_INSET, -CHECKBOX_BORDER_INSET)
    border:SetPoint("BOTTOMRIGHT", -CHECKBOX_BORDER_INSET, CHECKBOX_BORDER_INSET)
    border:SetFrameLevel(checkBox:GetFrameLevel() + ACCENT_BORDER_LEVEL)
    border:Hide()
    border.Edges = {}
    for _, edgeAnchors in ipairs({
        { "TOPLEFT",    "TOPRIGHT",    isHorizontal = true  },
        { "BOTTOMLEFT", "BOTTOMRIGHT", isHorizontal = true  },
        { "TOPLEFT",    "BOTTOMLEFT",  isHorizontal = false },
        { "TOPRIGHT",   "BOTTOMRIGHT", isHorizontal = false },
    }) do
        local edge = border:CreateTexture(nil, "OVERLAY")
        edge:SetPoint(edgeAnchors[1])
        edge:SetPoint(edgeAnchors[2])
        edge.isHorizontal = edgeAnchors.isHorizontal
        table.insert(border.Edges, edge)
    end
    return border
end

--- Shows the accent ring while the checkbox is checked and hides it otherwise.
local function UpdateAccentBorder(checkBox)
    local border = accentBorders[checkBox]
    if border then border:SetShown(not not checkBox:GetChecked()) end
end

--- Returns the size in UI units closest to desiredSize that covers a whole number of
--- physical pixels and matches the parity of a box of boxSize.
local function GetCenteredSize(region, boxSize, desiredSize)
    local unitsPerPixel = PixelUtil.GetPixelToUIUnitFactor()
    local scale = region:GetEffectiveScale()
    if not scale or scale <= 0 or not unitsPerPixel or unitsPerPixel <= 0 then
        return desiredSize
    end
    local boxPixels = Round(boxSize * scale / unitsPerPixel)
    local markPixels = Round(desiredSize * scale / unitsPerPixel)
    if markPixels % 2 ~= boxPixels % 2 then markPixels = markPixels - 1 end
    if markPixels < 1 then markPixels = 1 end
    return markPixels * unitsPerPixel / scale
end

--- Sizes the accent ring strips and the accent block to a whole number of physical
--- pixels at the current scale, and centers the block on the checkbox.
local function LayoutAccentMark(checkBox)
    local border = accentBorders[checkBox]
    if border then
        for _, edge in ipairs(border.Edges) do
            if edge.isHorizontal then
                PixelUtil.SetHeight(edge, ACCENT_BORDER_SIZE, ACCENT_BORDER_SIZE)
            else
                PixelUtil.SetWidth(edge, ACCENT_BORDER_SIZE, ACCENT_BORDER_SIZE)
            end
        end
    end
    local mark = checkBox:GetCheckedTexture()
    if mark then
        mark:ClearAllPoints()
        mark:SetPoint("CENTER")
        local size = GetCenteredSize(mark, ACCENT_BOX_SIZE, ACCENT_MARK_SIZE)
        mark:SetSize(size, size)
    end
end

--- Paints the accent block and the accent ring in the accent color.
local function PaintAccentMark(S, checkBox)
    local r, g, b = S.GetAccentColor()
    local mark = checkBox:GetCheckedTexture()
    if mark then
        mark:SetVertexColor(1, 1, 1, 1)
        mark:SetColorTexture(r, g, b, 1)
    end
    local border = accentBorders[checkBox]
    if border then
        for _, edge in ipairs(border.Edges) do edge:SetColorTexture(r, g, b, 1) end
    end
end

--- Resizes a checkbox to CHECKBOX_SIZE and moves its anchor down by half the size
--- it loses. The horizontal offset is left unchanged.
local function ResizeCheckBox(checkBox)
    local size = checkBox:GetHeight()
    if not size or size <= CHECKBOX_SIZE then return end
    local point, relativeTo, relativePoint, x, y = checkBox:GetPoint(1)
    checkBox:SetSize(CHECKBOX_SIZE, CHECKBOX_SIZE)
    if point then
        checkBox:SetPoint(point, relativeTo, relativePoint, x, y - (size - CHECKBOX_SIZE) / 2)
    end
end

local function SkinCheckBox(S, checkBox)
    ResizeCheckBox(checkBox)
    S.Checkbox(checkBox, { borderInset = CHECKBOX_BORDER_INSET })
    table.insert(checkBoxes, checkBox)
    accentBorders[checkBox] = CreateAccentBorder(checkBox)
    LayoutAccentMark(checkBox)
    PaintAccentMark(S, checkBox)
    if checkBox.Text then S.Font(checkBox.Text) end
    -- A click toggles the state inside the widget without calling SetChecked.
    checkBox:HookScript("OnClick", UpdateAccentBorder)
    hooksecurefunc(checkBox, "SetChecked", UpdateAccentBorder)
    UpdateAccentBorder(checkBox)
end

--- Skins a dropdown, i.e. the difficulty selection, as a flat box with a border, a
--- hover and the house arrow. The frame of the dropdown is larger than the artwork it
--- draws, so the button that opens the menu is stretched over the area the artwork
--- covered and skinned in its place, which both puts the box where the artwork was
--- and makes all of it clickable instead of only the arrow.
local function SkinDropDown(S, dropDown)
    local button = dropDown.Button
    if not button then return end
    S.FadeRegions(dropDown)
    button:ClearAllPoints()
    button:SetPoint("TOPLEFT", dropDown, "TOPLEFT", DROPDOWN_INSET_LEFT, -DROPDOWN_INSET_TOP)
    button:SetPoint("BOTTOMRIGHT", dropDown, "BOTTOMRIGHT", -DROPDOWN_INSET_RIGHT, DROPDOWN_INSET_BOTTOM)
    -- The text belongs to the dropdown rather than to the button, so it needs the same
    -- frame level and a layer above the fill of the button to stay visible.
    button:SetFrameLevel(dropDown:GetFrameLevel())
    S.Dropdown(button)

    local text = dropDown.Text
    if text then
        text:SetDrawLayer("OVERLAY")
        text:ClearAllPoints()
        text:SetPoint("LEFT", button, "LEFT", DROPDOWN_TEXT_INSET, 0)
        text:SetPoint("RIGHT", button, "RIGHT", -DROPDOWN_ARROW_ROOM, 0)
        text:SetJustifyH("LEFT")
        S.Font(text)
        S.White(text)
    end
    dropDowns[dropDown] = true
end

--- Moves the popup menu of a skinned dropdown below its box, as the offsets the menu
--- is registered with compensate for the insets of the artwork the skin removes.
--- Menus of other widgets are left where they are.
local function AnchorPopupMenu(popup)
    local _, relativeTo = popup:GetPoint(1)
    if not (relativeTo and dropDowns[relativeTo]) then return end
    popup:ClearAllPoints()
    popup:SetPoint("TOPRIGHT", relativeTo.Button, "BOTTOMRIGHT", 0, -MENU_GAP)
end

--- Skins the popup menu opened by the dropdowns. Runs after every open.
local function SkinPopupMenu(S, popup)
    S.Panel(popup)
    -- The frame template draws its border through a backdrop, which the panel does
    -- not cover, and PopupMenu_Initialize recolors it on every open.
    if popup.SetBackdropColor then popup:SetBackdropColor(0, 0, 0, 0) end
    if popup.SetBackdropBorderColor then popup:SetBackdropBorderColor(0, 0, 0, 0) end

    local r, g, b = S.GetAccentColor()
    for _, button in ipairs(popup.Buttons or {}) do
        S.Font(button.Text)
        S.White(button.Text)
        if button.HighlightTexture then
            button.HighlightTexture:SetColorTexture(r, g, b, MENU_HIGHLIGHT_ALPHA)
        end
    end
end

--- Applies the theme font at the size used for text boxes.
local function ApplyTextBoxFont(S, editBox)
    local fontPath, fontFlag = S.GetFont()
    editBox:SetFont(fontPath, C.FONTSIZE_TEXTBOX, fontFlag)
end

local function SkinEditBox(S, editBox)
    S.EditBox(editBox)
    S.Font(editBox)
    ApplyTextBoxFont(S, editBox)
    table.insert(textBoxes, editBox)
    if editBox.Instructions then S.Font(editBox.Instructions) end
    -- InputBoxTemplate has no text inset of its own.
    editBox:SetTextInsets(TEXT_INSET, 0, 0, 0)
end

--- Skins an InputScrollFrameTemplate, i.e. the advanced filter expression box.
local function SkinInputScrollFrame(S, scrollFrame)
    S.Panel(scrollFrame, { inset = true })
    local editBox = scrollFrame.EditBox
    if editBox then
        S.Font(editBox)
        if editBox.Instructions then S.Font(editBox.Instructions) end
    end
    if scrollFrame.ScrollBar then S.ScrollBar(scrollFrame.ScrollBar) end
end

-------------------------------------------------------------------------------
--  Panels
-------------------------------------------------------------------------------

--- Walks a panel and skins every widget it recognizes, dispatching on the type of
--- each child, or on its key where the type does not identify the widget.
local function SkinWidgets(S, frame, depth)
    if depth > 6 then return end

    for i = 1, select("#", frame:GetRegions()) do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("FontString") then S.Font(region) end
    end

    for i = 1, select("#", frame:GetChildren()) do
        local child = select(i, frame:GetChildren())
        -- The dropdown of a filter row is a plain frame and has to be dispatched on
        -- its key rather than on its type.
        if child and child == frame.DropDown then
            SkinDropDown(S, child)
        elseif child then
            local widgetType = child:GetObjectType()
            if widgetType == "CheckButton" then
                SkinCheckBox(S, child)
            elseif widgetType == "EditBox" then
                SkinEditBox(S, child)
            elseif widgetType == "ScrollFrame" then
                SkinInputScrollFrame(S, child)
            elseif widgetType == "Button" then
                if child.Label and child.Bg then SkinTextButton(S, child) end
            else
                SkinWidgets(S, child, depth + 1)
            end
        end
    end
end

local function SkinPanels(S, dialog)
    local skinned = {}
    for _, panel in pairs(dialog.panels) do
        -- The same panel is registered under several ids.
        if not skinned[panel] then
            skinned[panel] = true
            SkinWidgets(S, panel, 0)
        end
    end
end

-------------------------------------------------------------------------------
--  Dialog
-------------------------------------------------------------------------------

--- Replaces the arrow of the minimize or maximize button of the dialog with the glyph
--- passed in. Only the artwork changes, the button keeps its scripts and its behavior.
local function SkinMaxMinButton(S, button, atlas)
    if not button then return end
    -- A missing atlas would leave the button empty, so it keeps its arrow instead.
    if not (C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(atlas)) then return end
    S.FadeRegions(button)
    for _, getter in ipairs({
        "GetNormalTexture", "GetPushedTexture", "GetHighlightTexture", "GetDisabledTexture",
    }) do
        local texture = button[getter] and button[getter](button)
        if texture then texture:SetAlpha(0) end
    end
    local glyph = button:CreateTexture(nil, "OVERLAY")
    glyph:SetAtlas(atlas, false)
    glyph:SetSize(GLYPH_SIZE, GLYPH_SIZE)
    glyph:SetPoint("CENTER", GLYPH_OFFSET_X, 0)
    glyph:SetDesaturated(true)
    glyph:SetVertexColor(1, 1, 1, GLYPH_ALPHA)
    button:HookScript("OnEnter", function () glyph:SetVertexColor(1, 1, 1, 1) end)
    button:HookScript("OnLeave", function () glyph:SetVertexColor(1, 1, 1, GLYPH_ALPHA) end)
end

local function SkinDialog(S, dialog)
    S.Shell(dialog, { bottomBar = FOOTER_HEIGHT })
    if dialog.NineSlice then S.FadeNineSlice(dialog.NineSlice) end
    -- PortraitFrameTemplate keeps the portrait in a child frame.
    if dialog.PortraitContainer and dialog.PortraitContainer.portrait then
        dialog.PortraitContainer.portrait:SetAlpha(0)
    end

    local title = dialog.TitleContainer and dialog.TitleContainer.TitleText
    if title then
        S.Font(title)
        S.White(title)
    end
    if dialog.CloseButton then S.CloseButton(dialog.CloseButton) end

    -- The buttons that collapse and expand the dialog get the minus and the plus. Only
    -- the one matching the current state is shown, so both of them are skinned.
    local maxMinFrame = dialog.MaximizeMinimizeFrame
    if maxMinFrame then
        SkinMaxMinButton(S, maxMinFrame.MinimizeButton, COLLAPSE_ATLAS)
        SkinMaxMinButton(S, maxMinFrame.MaximizeButton, EXPAND_ATLAS)
    end

    -- Icon buttons keep their glyph and lose the rest of their artwork.
    S.Button(dialog.ResetButton, { "Icon" })
    S.Button(dialog.SettingsButton, { "Icon" })
    S.Button(dialog.RefreshButton)
    S.StateButtonLabel(dialog.RefreshButton)
end

-------------------------------------------------------------------------------
--  Registration
-------------------------------------------------------------------------------

local function ApplySkin(S)
    local dialog = PGF.Dialog
    if not dialog then return end
    PGF.Logger:Debug("EllesmereUI:ApplySkin("..S.GetStyle()..")")
    SkinDialog(S, dialog)
    SkinPanels(S, dialog)
    -- Skins the popup menu after every open, as it is created on demand.
    if PGF.PopupMenu_Initialize then
        hooksecurefunc(PGF, "PopupMenu_Initialize", function ()
            local popup = PGF.PopupMenu_GetFrame and PGF.PopupMenu_GetFrame()
            if popup then
                SkinPopupMenu(S, popup)
                AnchorPopupMenu(popup)
            end
        end)
    end
    -- Reapplies the parts of the skin taken from the theme getters.
    S.OnLooksChanged(function()
        for _, editBox in ipairs(textBoxes) do ApplyTextBoxFont(S, editBox) end
        for _, checkBox in ipairs(checkBoxes) do
            PaintAccentMark(S, checkBox)
            UpdateAccentBorder(checkBox)
        end
    end)
    -- Resizes the accent ring and block after a change of UI scale or resolution.
    local scaleFrame = CreateFrame("Frame", "PremadeGroupsFilterEllesmereUIScaleFrame")
    scaleFrame:RegisterEvent("UI_SCALE_CHANGED")
    scaleFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
    scaleFrame:SetScript("OnEvent", function ()
        for _, checkBox in ipairs(checkBoxes) do LayoutAccentMark(checkBox) end
    end)
end

local function RegisterSkin()
    if not (EllesmereUI and EllesmereUI.RegisterSkin) then return false end
    EllesmereUI.RegisterSkin(PGFAddonName, ApplySkin)
    return true
end

if not RegisterSkin() then
    -- Retries on every addon load until EllesmereUI is found, and stops looking at
    -- PLAYER_LOGIN.
    local frame = CreateFrame("Frame", "PremadeGroupsFilterEllesmereUIFrame")
    frame:RegisterEvent("ADDON_LOADED")
    frame:RegisterEvent("PLAYER_LOGIN")
    frame:SetScript("OnEvent", function (self, event)
        if RegisterSkin() or event == "PLAYER_LOGIN" then
            self:UnregisterAllEvents()
            self:SetScript("OnEvent", nil)
        end
    end)
end
