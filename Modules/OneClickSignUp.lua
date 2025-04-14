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

--local MAX_LFG_LIST_APPLICATIONS = 0 -- for testing

local function GetOldestApplicationResultID()
    local oldestResultID = 0
    local oldestAppDuration = 999 -- duration is max 300 seconds
    local apps = C_LFGList.GetApplications()
    for i = 1, #apps do
        local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(apps[i])
        if appStatus == "applied" and not pendingStatus and appDuration < oldestAppDuration then
            oldestResultID = apps[i]
            oldestAppDuration = appDuration
        end
    end
    return oldestResultID
end

--- Determine if we can and should cancel one of the pending application, i.e.
--- if we are at max application and we are hovering a group that we can apply to.
local function ShouldCancelApplication(resultID)
    local numApplications, numActiveApplications = C_LFGList.GetNumApplications()
    if numActiveApplications >= MAX_LFG_LIST_APPLICATIONS then
        local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID)
        local isApplication = appStatus ~= "none" or pendingStatus
        local searchResultInfo = PGF.GetSearchResultInfo(resultID)
        return not isApplication and searchResultInfo and not searchResultInfo.isDelisted
    end
    return false
end

PGF.clickToCancelFrames = {}

hooksecurefunc("LFGListSearchEntry_OnEnter", function (self)
    if not PremadeGroupsFilterSettings.cancelOldestApp then return end

    local clickToCancelFrame = PGF.clickToCancelFrames[self]
    if clickToCancelFrame == nil then
        local frame = CreateFrame("Frame", nil, self, nil)
        frame:Hide()
        frame:SetFrameStrata("HIGH")
        frame:SetFrameLevel(10)
        frame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 3, 0)
        frame:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -3, 0)
        frame:SetHeight(18)
        frame.Background = frame:CreateTexture("$parentBackground", "BACKGROUND")
        frame.Background:SetAllPoints()
        frame.Background:SetColorTexture(0.4, 0.1, 0.1, 0.8)
        frame.Title = frame:CreateFontString("$parentTitle", "ARTWORK", "GameFontHighlight")
        frame.Title:SetPoint("CENTER")
        frame.Title:SetText(L["dialog.cancelOldestApp"])
        PGF.clickToCancelFrames[self] = frame
        clickToCancelFrame = frame
    end

    if ShouldCancelApplication(self.resultID) then
        clickToCancelFrame:Show()
    end
end)

hooksecurefunc("LFGListSearchEntry_OnLeave", function (self)
    if not PremadeGroupsFilterSettings.cancelOldestApp then return end

    local clickToCancelFrame = PGF.clickToCancelFrames[self]
    if clickToCancelFrame ~= nil then
        clickToCancelFrame:Hide()
    end
end)

hooksecurefunc("LFGListSearchEntry_OnClick", function (self, button)
    local panel = LFGListFrame.SearchPanel

    if PremadeGroupsFilterSettings.cancelOldestApp and button ~= "RightButton" then
        -- if we already have max applications pending, cancel oldest application before signing up
        if ShouldCancelApplication(self.resultID) then
            local oldestResultID = GetOldestApplicationResultID()
            if oldestResultID > 0 then
                PGF.Logger:Debug("Canceling application "..oldestResultID)
                C_LFGList.CancelApplication(oldestResultID) -- required hardware event
                LFGListSearchPanel_UpdateButtonStatus(panel)
                return -- we cannot apply right now because we already used our hardware event for cancelation
            end
        end
    end

    if PremadeGroupsFilterSettings.oneClickSignUp and button ~= "RightButton"
            and LFGListSearchPanelUtil_CanSelectResult(self.resultID) and panel.SignUpButton:IsEnabled() then
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
