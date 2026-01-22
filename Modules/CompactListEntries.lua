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

local templateHeight = 0
local function desiredHeight()
    if not templateHeight or templateHeight == 0 then
        local info = C_XMLUtil.GetTemplateInfo("LFGListSearchEntryTemplate")
        if info and info.height and info.height > 0 then
            templateHeight = info.height
        else
            templateHeight = 54 -- hardcoded fallback
        end
    end

    -- 12.0.0 added a third line with the playstyle and increased the entry height from 36 to 54
    -- (see LFGListSearchEntryTemplate in LFGList.xml)
    return PremadeGroupsFilterSettings.compactListEntries and 36 or templateHeight
end

function PGF.CompactListEntries_UpdateListScrollBox()
    local scrollBox = LFGListFrame.SearchPanel.ScrollBox
    local view = scrollBox:GetView()
    --view:SetElementExtentCalculator(nil) -- currently not used, allows to have elements with different heights
    -- ScrollBoxListView usually automatically fetches the height from the XML template using C_XMLUtil.GetTemplateInfo.
    -- Since we do not want to and probably also cannot change the template, we manually set the correct value here.
    view:SetElementExtent(desiredHeight())
    scrollBox:FullUpdate()
end

function PGF.CompactListEntries_UpdateListEntry(self)
    self.Playstyle:SetShown(not PremadeGroupsFilterSettings.compactListEntries)
    self:SetHeight(desiredHeight())
end

hooksecurefunc("LFGListSearchEntry_Update", PGF.CompactListEntries_UpdateListEntry)
PVEFrame:HookScript("OnShow", function () PGF.CompactListEntries_UpdateListScrollBox() end)
