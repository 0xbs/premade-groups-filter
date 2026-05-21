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

PGF.pendingAutoAcceptInvite = false
PGF.autoAcceptInviteClickConsumed = false

local function TryAcceptInviteDialog()
    if not PremadeGroupsFilterSettings.autoAcceptInvite then return false end
    if not PGF.pendingAutoAcceptInvite then return false end
    if not LFGListInviteDialog or not LFGListInviteDialog:IsShown() then return false end
    if LFGListInviteDialog.informational then return false end
    local acceptButton = LFGListInviteDialog.AcceptButton
    if acceptButton and acceptButton:IsShown() and acceptButton:IsEnabled() then
        acceptButton:Click()
        PGF.pendingAutoAcceptInvite = false
        return true
    end
    return false
end

function PGF.TryAutoAcceptInviteOnClick()
    return TryAcceptInviteDialog()
end

--- @param resultID number search result / application id
--- @param newStatus string e.g. "invited"
--- @param oldStatus string e.g. "applied"
function PGF.OnAutoAcceptApplicationStatusUpdated(resultID, newStatus, oldStatus, kstringGroupName)
    if not PremadeGroupsFilterSettings.autoAcceptInvite then return end
    if newStatus ~= "invited" or oldStatus ~= "applied" then return end
    PGF.pendingAutoAcceptInvite = true
end

-- Accept may require a hardware event; also try on list click (see .toc load order)
hooksecurefunc("LFGListSearchEntry_OnClick", function(self, button)
    if button == "RightButton" then return end
    if PGF.TryAutoAcceptInviteOnClick() then
        PGF.autoAcceptInviteClickConsumed = true
    end
end)
