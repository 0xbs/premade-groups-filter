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

local PGF = select(2, ...)
local L = PGF.L
local C = PGF.C

-- DEBUG: Set to true to always show region indicators for testing
local DEBUG_ALWAYS_SHOW_INDICATOR = false

-- Store region indicator frames for each search entry
PGF.regionIndicators = {}

-- Latin American servers (comprehensive list)
local latinAmericanServers = {
    -- Brazil servers
    ["Azralon"] = true,
    ["Nemesis"] = true,
    ["Goldrinn"] = true,
    ["Tol Barad"] = true,
    ["Gallywix"] = true,

    -- Latin America servers
    ["Ragnaros"] = true,
    ["Quel'Thalas"] = true,  -- Note: There's also a US Quel'Thalas
    ["Drakkari"] = true,
}

-- Oceanic servers
local oceanicServers = {
    ["Aman'Thul"] = true,
    ["Barthilas"] = true,
    ["Caelestrasz"] = true,
    ["Dath'Remar"] = true,
    ["Dreadmaul"] = true,
    ["Frostmourne"] = true,
    ["Gundrak"] = true,
    ["Jubei'Thos"] = true,
    ["Khaz'goroth"] = true,
    ["Nagrand"] = true,
    ["Saurfang"] = true,
    ["Thaurissan"] = true,
}

-- Function to detect player's own server region
local function GetPlayerServerRegion()
    local playerRealm = GetRealmName()

    -- Check if player is on a Latin American server
    if latinAmericanServers[playerRealm] then
        return "LATAM"
    end

    -- Check if player is on an Oceanic server
    if oceanicServers[playerRealm] then
        return "OCE"
    end

    -- Default to USA/NA
    return "USA"
end

-- Cache player's region (only needs to be checked once)
local playerRegion = nil

-- Function to extract realm from leader name
local function GetRealmFromLeaderName(leaderName)
    if not leaderName or leaderName == "" then
        return nil
    end

    -- Leader name format is "Name-Realm" or just "Name" if same realm
    local dashPos = leaderName:find("-")
    if dashPos then
        return leaderName:sub(dashPos + 1)
    end

    -- If no dash, they're on the same realm as us
    return nil  -- Return nil for same-realm since we don't need to check it
end

-- Function to detect server region
local function DetectServerRegion(leaderName)
    -- First try PremadeRegions if available
    if PremadeRegions and PremadeRegions.GetRegion then
        local region = PremadeRegions.GetRegion(leaderName)
        if region == "la" or region == "bzl" or region == "mex" then
            return "LATAM"
        elseif region == "oce" then
            return "OCE"
        end
    end

    -- Fallback to our own detection
    local realm = GetRealmFromLeaderName(leaderName)
    if realm then
        if latinAmericanServers[realm] then
            return "LATAM"
        elseif oceanicServers[realm] then
            return "OCE"
        end
    end

    -- If we can't determine realm or it's not in special lists, it's USA/NA
    return "USA"
end

-- Function to get or create region indicator frame (modeled after RatingInfo)
function PGF.GetOrCreateRegionIndicator(parent)
    local frame = PGF.regionIndicators[parent]
    if not frame then
        frame = CreateFrame("Frame", nil, parent, nil)
        frame:Hide()
        frame:SetFrameStrata("HIGH")
        frame:SetSize(20, 20)  -- Smaller size for icon only

        -- Create icon texture
        frame.Icon = frame:CreateTexture(nil, "ARTWORK")
        frame.Icon:SetSize(20, 20)
        frame.Icon:SetPoint("CENTER")

        -- Create tooltip region
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.region == "LATAM" then
                GameTooltip:SetText("Latin American Server", 1, 0.55, 0)
                GameTooltip:AddLine("Leader is from a Latin American realm", 1, 1, 1, true)
                GameTooltip:AddLine("Different ping/latency expected", 1, 0.8, 0.8, true)
                if self.realm then
                    GameTooltip:AddLine("Realm: " .. self.realm, 0.8, 0.8, 0.8, true)
                end
            elseif self.region == "OCE" then
                GameTooltip:SetText("Oceanic Server", 0, 0.75, 1)
                GameTooltip:AddLine("Leader is from an Oceanic realm", 1, 1, 1, true)
                GameTooltip:AddLine("Different ping/latency expected", 1, 0.8, 0.8, true)
                if self.realm then
                    GameTooltip:AddLine("Realm: " .. self.realm, 0.8, 0.8, 0.8, true)
                end
            elseif self.region == "USA" then
                GameTooltip:SetText("North American Server", 0.2, 0.4, 0.8)
                GameTooltip:AddLine("Leader is from a US/NA realm", 1, 1, 1, true)
                GameTooltip:AddLine("Different ping/latency may apply", 1, 0.8, 0.8, true)
                if self.realm then
                    GameTooltip:AddLine("Realm: " .. self.realm, 0.8, 0.8, 0.8, true)
                end
            end
            GameTooltip:Show()
        end)

        frame:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        PGF.regionIndicators[parent] = frame
    end
    return frame
end

-- Function to add region indicator to search entry
function PGF.AddRegionIndicator(self, searchResultInfo)
    -- Initialize player region on first use
    if playerRegion == nil then
        playerRegion = GetPlayerServerRegion()
    end

    local frame = PGF.GetOrCreateRegionIndicator(self)
    local activityInfo = searchResultInfo and C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)

    -- Reset
    frame:Hide()
    self.hasRegionIndicator = false

    -- Only show region indicators for M+ activities
    if not activityInfo or not activityInfo.isMythicPlusActivity then
        return -- only show for M+ dungeons
    end

    -- Check if we should show indicators
    if not searchResultInfo or not searchResultInfo.leaderName then
        return
    end

    local appStatus, isApplication, isDeclined = PGF.GetAppStatus(self.resultID, searchResultInfo)
    if isApplication or isDeclined then
        return -- stop if special status
    end

    local region = DetectServerRegion(searchResultInfo.leaderName)

    -- Only show indicator if the group is from a different region than the player
    -- (unless debug mode is enabled)
    if not DEBUG_ALWAYS_SHOW_INDICATOR and region == playerRegion then
        return -- Same region as player, don't show indicator
    end

    -- Store that we're showing a region indicator
    self.hasRegionIndicator = true
    
    -- We'll anchor relative to the rating if it exists, or DataDisplay if not
    -- This will be set up after we know if there's a rating

    -- Set icon based on region
    local iconAtlas = nil

    if region == "LATAM" then
        -- Fire/ember icon for Latin America (hot climate)
        iconAtlas = "EmberCourt-32x32"
        frame.region = "LATAM"
        frame.realm = GetRealmFromLeaderName(searchResultInfo.leaderName) or "Same Realm"
    elseif region == "OCE" then
        -- Fishing hole for Oceanic (ocean/water theme)
        iconAtlas = "Fishing-Hole"
        frame.region = "OCE"
        frame.realm = GetRealmFromLeaderName(searchResultInfo.leaderName) or "Same Realm"
    elseif region == "USA" then
        -- Azerite/star icon for USA
        iconAtlas = "AzeriteReady"
        frame.region = "USA"
        frame.realm = GetRealmFromLeaderName(searchResultInfo.leaderName) or "USA Realm"
    else
        -- Unknown region, don't show
        return
    end

    -- Show the frame
    frame:Show()
    
    -- Always get or create the rating frame to ensure consistent anchoring
    local ratingFrame = PGF.GetOrCreateRatingInfoFrame(self)
    
    -- Always anchor to the left of where the rating frame is/will be
    -- This ensures consistent positioning regardless of load order
    frame:ClearAllPoints()
    frame:SetPoint("RIGHT", ratingFrame, "LEFT", -2, 0)
    
    frame.Icon:SetAtlas(iconAtlas)

    -- Apply delisted styling if needed (no color tinting)
    if searchResultInfo.isDelisted then
        frame.Icon:SetDesaturated(true)
        frame.Icon:SetAlpha(0.5)
    else
        frame.Icon:SetDesaturated(false)
        frame.Icon:SetAlpha(1)
    end
end

-- No longer need the hook since we're called from Main.lua
