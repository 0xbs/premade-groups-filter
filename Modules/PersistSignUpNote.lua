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

local didApplyPatch = false
local originalFunc = LFGListApplicationDialog_Show
local patchedFunc = function(self, resultID)
    if resultID then
        local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID);
        --if ( searchResultInfo.activityID ~= self.activityID ) then
        --    C_LFGList.ClearApplicationTextFields();
        --end

        self.resultID = resultID;
        self.activityID = searchResultInfo.activityID;
    end
    LFGListApplicationDialog_UpdateRoles(self);
    StaticPopupSpecial_Show(self);
end

function PGF.PersistSignUpNote()
    if PremadeGroupsFilterSettings.persistSignUpNote then
        -- overwrite function with patched func missing the call to ClearApplicationTextFields
        LFGListApplicationDialog_Show = patchedFunc
        didApplyPatch = true
    elseif didApplyPatch then
        -- restore previously overwritten function
        LFGListApplicationDialog_Show = originalFunc
    end
end
