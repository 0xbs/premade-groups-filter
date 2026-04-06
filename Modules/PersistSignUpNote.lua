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

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

-- Before the SignUp dialog opens, set activityID to match the selected result's
-- activity so that LFGListApplicationDialog_Show skips ClearApplicationTextFields.
-- Using PreClick + hooksecurefunc avoids overwriting the global function.
LFGListFrame.SearchPanel.SignUpButton:HookScript("PreClick", function()
    if not PremadeGroupsFilterSettings.persistSignUpNote then return end
    local selectedResult = LFGListFrame.SearchPanel.selectedResult
    if selectedResult then
        local searchResultInfo = C_LFGList.GetSearchResultInfo(selectedResult)
        if searchResultInfo then
            LFGListApplicationDialog.activityID = searchResultInfo.activityIDs[1]
        end
    end
end)
