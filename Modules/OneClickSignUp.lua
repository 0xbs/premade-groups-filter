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

hooksecurefunc("LFGListSearchEntry_OnClick", function (self, button)
    if not PremadeGroupsFilterSettings.oneClickSignUp then return end

    local panel = LFGListFrame.SearchPanel
    if button ~= "RightButton" and LFGListSearchPanelUtil_CanSelectResult(self.resultID) and panel.SignUpButton:IsEnabled() then
        if panel.selectedResult ~= self.resultID then
            LFGListSearchPanel_SelectResult(panel, self.resultID)
        end
        LFGListSearchPanel_SignUp(panel)
    end
end)

-- need to hook the show event directly as we might have overwritten LFGListApplicationDialog_Show
LFGListApplicationDialog:HookScript("OnShow", function(self)
    if not PremadeGroupsFilterSettings.skipSignUpDialog then return end

    if self.SignUpButton:IsEnabled() and not IsShiftKeyDown() then
        self.SignUpButton:Click()
    end
end)
