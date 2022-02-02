-- Overwrite C_LFGList.GetPlaystyleString with a custom implementation because the original function is
-- hardware protected, causing an error when a group tooltip is shown as we modify the search result list.
-- Original code from https://github.com/ChrisKader/LFMPlus/blob/36bca68720c724bf26cdf739614d99589edb8f77/core.lua#L38
-- but sligthly modified.
C_LFGList.GetPlaystyleString = function(playstyle, activityInfo)
    if not ( activityInfo and playstyle and playstyle ~= 0
            and C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown ) then
        return nil
    end
    local globalStringPrefix
    if activityInfo.isMythicPlusActivity then
        globalStringPrefix = "GROUP_FINDER_PVE_PLAYSTYLE"
    elseif activityInfo.isRatedPvpActivity then
        globalStringPrefix = "GROUP_FINDER_PVP_PLAYSTYLE"
    elseif activityInfo.isCurrentRaidActivity then
        globalStringPrefix = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
    elseif activityInfo.isMythicActivity then
        globalStringPrefix = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
    end
    return globalStringPrefix and _G[globalStringPrefix .. tostring(playstyle)] or nil
end

-- By overwriting C_LFGList.GetPlaystyleString, we taint the code writing the tooltip (which does not matter),
-- and also code related to the dropdows where you can select the playstyle. The only relevant protected function
-- here is C_LFGList.SetEntryTitle, which is only called from LFGListEntryCreation_SetTitleFromActivityInfo.
LFGListEntryCreation_SetTitleFromActivityInfo = function(_) end
