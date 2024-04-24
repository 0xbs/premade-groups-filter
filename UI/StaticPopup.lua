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

PGF.StaticPopupDialogs = {
    -- Params:
    --   string text          message text
    --   float  textWidth     width of text, default is 290
    --   string button1..4    text of button 1..4
    --   bool   hideOnEscape  hide popup if TOGGLEGAMEMENU (ESC) key is pressed
    --   bool   hasEditBox    show an edit box
    --   string editBoxText   text inside edit box
    --   bool   focusEditBox  select all text and focus edit box
    --   float  editBoxWidth  width of edit box, default is 130
    -- Events:
    --   OnShow(self)
    --   OnHide(self)
    --   OnAccept(self)
    --   OnCancel(self)
    --   OnButton1..4(self)

    ["PGF_CONFIRM_RESET"] = {
        text = L["dialog.reset.confirm"],
        button1 = OKAY,
        button2 = CANCEL,
        OnAccept = function (self) PGF.Dialog:Reset() end,
        hideOnEscape = true,
    },
    ["PGF_COPY_URL_KEYWORDS"] = {
        text = L["dialog.copy.url.keywords"],
        textWidth = 360,
        button2 = CLOSE,
        hasEditBox = true,
        focusEditBox = true,
        editBoxText = "https://github.com/0xbs/premade-groups-filter/wiki/Keywords",
        editBoxWidth = 360,
        hideOnEscape = true,
    },
    ["PGF_ERROR_EXPRESSION"] = {
        text = "%s",
        textWidth = 360,
        button1 = OKAY,
        hideOnEscape = true,
    }
}

local PGFStaticPopup = CreateFrame("Frame", "PremadeGroupsFilterStaticPopup", UIParent, "PremadeGroupsFilterStaticPopupTemplate")

function PGFStaticPopup:OnLoad()
    self.which = nil
    self.text_arg1 = ""
    self.text_arg2 = ""
    self:SetPoint("TOP", 0, -135)
end

function PGFStaticPopup:GetButtons()
    return { self.Button1, self.Button2, self.Button3, self.Button4 }
end

function PGFStaticPopup:OnButtonClick(index)
    local info = PGF.StaticPopupDialogs[self.which]
    if not info then return end

    local noop = function() end
    local func = noop
    if index == 1 then
        func = info.OnAccept or info.OnButton1 or noop
    elseif index == 2 then
        func = info.OnCancel or info.OnButton2 or noop
    elseif index == 3 then
        func = info.OnButton3 or noop
    elseif index == 4 then
        func = info.OnButton4 or noop
    end

    if func then
        func(self)
    end
    self:Hide()
end

function PGFStaticPopup:Setup()
    local info = PGF.StaticPopupDialogs[self.which]
    if not info then return end
    info.textWidth = info.textWidth or 290
    info.editBoxWidth = info.editBoxWidth or 130

    self.maxWidthSoFar = 0
    self.maxHeightSoFar = 0

    self.Text:Show()
    self.Text:SetFormattedText(info.text, self.text_arg1, self.text_arg2)
    self.Text:SetWidth(info.textWidth)

    self.EditBox:Hide()
    if info.hasEditBox then
        self.EditBox:Show()
        self.EditBox:SetText("")
        self.EditBox:SetWidth(info.editBoxWidth)
        self.EditBox:ClearAllPoints()
        self.EditBox:SetPoint("BOTTOM", 0, 29 + 16)
        if info.editBoxText then
            self.EditBox:SetText(info.editBoxText)
        end
        if info.focusEditBox then
            self.EditBox:SetFocus()
            self.EditBox:HighlightText(0)
        end
        if info.hideOnEscape then
            self.EditBox:SetScript("OnEscapePressed", function (editBox) self:Hide() end)
        end
    end

    local buttons = self:GetButtons()
    for index, button in ipairs_reverse(buttons) do
        button:SetText(info["button"..index])
        button:Hide()
        button:SetWidth(1)
        button:ClearAllPoints()
        button:SetScript("OnClick", function (button, buttonName, down) self:OnButtonClick(index) end)

        if not info["button"..index] then
            table.remove(buttons, index)
        end
    end
    self.numButtons = #buttons

    local buttonTextMargin = 20
    local minButtonWidth = 120
    local maxButtonWidth = minButtonWidth
    for index, button in ipairs(buttons) do
        local buttonWidth = button:GetTextWidth() + buttonTextMargin
        maxButtonWidth = math.max(maxButtonWidth, buttonWidth)
    end

    local function InitButton(button, index)
        button:Enable()
        button:Show()
    end

    self:Resize()

    local buttonPadding = 10
    local totalButtonPadding = (#buttons - 1) * buttonPadding
    local totalButtonWidth = #buttons * maxButtonWidth
    local totalWidth
    local uncondensedTotalWidth = totalButtonWidth + totalButtonPadding
    if uncondensedTotalWidth < self:GetWidth() then
        for index, button in ipairs(buttons) do
            button:SetWidth(maxButtonWidth)
            InitButton(button, index)
        end
        totalWidth = uncondensedTotalWidth
    else
        totalWidth = totalButtonPadding
        for index, button in ipairs(buttons) do
            local buttonWidth = math.max(minButtonWidth, button:GetTextWidth()) + buttonTextMargin
            button:SetWidth(buttonWidth)
            totalWidth = totalWidth + buttonWidth
            InitButton(button, index)
        end
    end

    if #buttons > 0 then
        local offset = totalWidth / 2
        buttons[1]:SetPoint("BOTTOMLEFT", self, "BOTTOM", -offset, 16)
        for index = 2, #buttons do
            buttons[index]:SetPoint("BOTTOMLEFT", buttons[index-1], "BOTTOMRIGHT", buttonPadding, 0)
        end
    end

    self:Resize()
end

function PGFStaticPopup:OnShow()
    local info = PGF.StaticPopupDialogs[self.which]
    if info and info.OnShow then
        info.OnShow(self)
    end
end

function PGFStaticPopup:OnHide()
    local info = PGF.StaticPopupDialogs[self.which]
    if info and info.OnHide then
        info.OnHide(self)
    end
end

function PGFStaticPopup:Resize()
    local info = PGF.StaticPopupDialogs[self.which]
    if not info then return end

    -- width
    local width = 320
    if info.hasEditBox then
        if info.editBoxWidth > info.textWidth then
            if info.editBoxWidth > 260 then
                width = width + (info.editBoxWidth - 260)
            end
        else
            if info.textWidth > 260 then
                width = width + (info.textWidth - 260)
            end
        end
    else
        if info.textWidth > 260 then
            width = width + (info.textWidth - 260)
        end
    end

    local buttons = self:GetButtons()
    local buttonMinWidth = 60
    for index, button in ipairs(buttons) do
        if button:IsShown() then
            buttonMinWidth = buttonMinWidth + button:GetWidth()
        end
    end
    width = max(width, buttonMinWidth)

    if width > self.maxWidthSoFar then
        self:SetWidth(width)
        self.maxWidthSoFar = width
    end

    -- height
    local height = 32 + self.Text:GetHeight() + 2
    height = height + 6 + self.Button1:GetHeight()
    if info.hasEditBox then
        height = height + 8 + self.EditBox:GetHeight()
    end
    if height > self.maxHeightSoFar then
        self:SetHeight(height)
        self.maxHeightSoFar = height
    end
end

function PGFStaticPopup:OnEscapePressed()
    local info = PGF.StaticPopupDialogs[self.which]
    if self:IsShown() and info and info.hideOnEscape then
        if info.OnCancel then
            info.OnCancel(self)
        end
        self:Hide()
    end
end

PGFStaticPopup:SetScript("OnShow", PGFStaticPopup.OnShow)
PGFStaticPopup:SetScript("OnHide", PGFStaticPopup.OnHide)
PGFStaticPopup:OnLoad()

function PGF.StaticPopup_Show(which, text_arg1, text_arg2)
    PGFStaticPopup.which = which
    PGFStaticPopup.text_arg1 = text_arg1
    PGFStaticPopup.text_arg2 = text_arg2
    PGFStaticPopup:Setup()
    PGFStaticPopup:Show()
end

-- Not as good as the original function which will stop propagating the event if a StaticPopup is open
-- but as good as we can do without rewriting the ToggleGameMenu function.
-- We could register the OnKeyDown event, but this will capture and disable all keys including any movement.
hooksecurefunc("ToggleGameMenu", function() PGFStaticPopup:OnEscapePressed() end)
