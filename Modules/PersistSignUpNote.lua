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

-- The patched function equals the original `LFGListApplicationDialog_Show` except commented code.
-- Working with a PreClick-Handler and manipulating self.activityID did not work reliably.
local patchedFunc = function(self, resultID)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID);
    --if ( searchResultInfo.activityIDs[1] ~= self.activityID ) then
    --	C_LFGList.ClearApplicationTextFields();
    --end

    self.resultID = resultID;
    self.activityID = searchResultInfo.activityIDs[1];
    LFGListApplicationDialog_UpdateRoles(self);
    StaticPopupSpecial_Show(self);
end

function PGF.InitPersistSignUpNote()
    if not PremadeGroupsFilterSettings.persistSignUpNote then return end

    LFGListApplicationDialog_Show = patchedFunc
end
