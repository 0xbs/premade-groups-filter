-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2025 Bernhard Saumweber
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

PremadeGroupsFilterTextButtonMixin = {}

function PremadeGroupsFilterTextButtonMixin:OnLoad()
    print("mixin OnLoad")
    self.Label:SetText(self.title or "")
end

function PremadeGroupsFilterTextButtonMixin:OnShow()
    print("mixin OnShow")
    self.Label:SetText(self.title or "")
end

function PremadeGroupsFilterTextButtonMixin:Init(title, tooltip)
    self.title = title
    self.tooltip = tooltip
    self.Label:SetText(self.title)
end

function PremadeGroupsFilterTextButtonMixin:OnEnter()
    self.Label:SetTextColor(WHITE_FONT_COLOR:GetRGB())
    if self.tooltip then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.tooltip, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end
end

function PremadeGroupsFilterTextButtonMixin:OnLeave()
    self.Label:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
    self.Label:ClearAllPoints()
    self.Label:SetPoint("CENTER", 0, 0)
    GameTooltip:Hide()
end

function PremadeGroupsFilterTextButtonMixin:OnMouseDown()
    self.Label:ClearAllPoints()
    self.Label:SetPoint("CENTER", 0, -1)
end

function PremadeGroupsFilterTextButtonMixin:OnMouseUp()
    self.Label:ClearAllPoints()
    self.Label:SetPoint("CENTER", 0, 0)
end
