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

function PGF.GetPvPScoreRarityColorByTier(tier)
    local r, g, b = GetItemQualityColor(C.PVP_TIER_MAP[tier].quality)
    return { r = r, g = g, b = b }
end

PGF.ratingInfoFrames = {}
function PGF.GetOrCreateRatingInfoFrame(self)
    -- creating frames each time will soon flood the UI with frames, so we create them once for each search result frame
    -- we store our frame in our own table to avoid any taint of the search result frame
    local frame = PGF.ratingInfoFrames[self]
    if frame == nil then
        frame = CreateFrame("Frame", nil, self, nil)
        frame:Hide()
        frame:SetFrameStrata("HIGH")
        frame:SetSize(35, 30)
        frame:SetPoint("TOP", 0, -4)

        frame.Rating = frame:CreateFontString("$parentRating", "ARTWORK", "GameFontNormalSmall")
        frame.Rating:SetSize(35, 15)
        frame.Rating:SetPoint("TOP")
        frame.Rating:SetJustifyH("RIGHT")
        frame.Rating:SetTextColor(1, 1, 1)

        frame.ExtraText = frame:CreateFontString("$parentExtraText", "ARTWORK", "GameFontNormalSmall")
        frame.ExtraText:SetSize(35, 15)
        frame.ExtraText:SetPoint("BOTTOM")
        frame.ExtraText:SetJustifyH("RIGHT")
        frame.ExtraText:SetTextColor(1, 1, 1)

        PGF.ratingInfoFrames[self] = frame
    end
    return frame
end

function PGF.AddRatingInfo(self, searchResultInfo)
    local frame = PGF.GetOrCreateRatingInfoFrame(self)
    local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)

    -- reset
    frame:Hide()
    self.Name:SetWidth(176)
    self.ActivityName:SetWidth(176)

    if not PremadeGroupsFilterSettings.ratingInfo then
        return -- stop if feature disabled
    end

    local _, appStatus, pendingStatus = C_LFGList.GetApplicationInfo(self.resultID)
    if appStatus ~= "none" or pendingStatus then
        return -- stop if already applied/invited/timedout/declined/declined_full/declined_delisted
    end

    local rightPos = -130
    local rating = 0
    local ratingColor = { r = 1.0, g = 1.0, b = 1.0 }
    local extraText = ""
    local extraTextColor = { r = 1.0, g = 1.0, b = 1.0 }
    if activityInfo.isMythicPlusActivity then
        rightPos = -115
        rating = searchResultInfo.leaderOverallDungeonScore or 0
        ratingColor = C_ChallengeMode.GetDungeonScoreRarityColor(rating) or ratingColor
        if searchResultInfo.leaderDungeonScoreInfo and searchResultInfo.leaderDungeonScoreInfo.bestRunLevel > 0 then
            extraText = "+" .. searchResultInfo.leaderDungeonScoreInfo.bestRunLevel
            if not searchResultInfo.leaderDungeonScoreInfo.finishedSuccess then
                extraTextColor = { r = 0.6, g = 0.6, b = 0.6 }
            end
        end
    end
    if activityInfo.isRatedPvpActivity then
        rightPos = activityInfo.categoryID == C.CATEGORY_ID.ARENA and -80 or -130
        if searchResultInfo.leaderPvpRatingInfo then
            rating = searchResultInfo.leaderPvpRatingInfo.rating or 0
            ratingColor = PGF.GetPvPScoreRarityColorByTier(searchResultInfo.leaderPvpRatingInfo.tier or 0) or ratingColor
        end
    end

    if rating == 0 then
        return -- stop if no rating
    end

    local textWidth = 312 - 10 - 35 + rightPos
    if searchResultInfo.voiceChat and searchResultInfo.voiceChat ~= "" then
        textWidth = textWidth - 20
    end

    local rColor = searchResultInfo.isDelisted and LFG_LIST_DELISTED_FONT_COLOR or ratingColor
    local eColor = searchResultInfo.isDelisted and LFG_LIST_DELISTED_FONT_COLOR or extraTextColor

    self.Name:SetWidth(textWidth)
    self.ActivityName:SetWidth(textWidth)
    frame:Show()
    frame:SetPoint("RIGHT", rightPos, 0)
    frame.Rating:SetText(rating)
    frame.Rating:SetTextColor(rColor.r, rColor.g, rColor.b)
    frame.ExtraText:SetText(extraText)
    frame.ExtraText:SetTextColor(eColor.r, eColor.g, eColor.b)
end
