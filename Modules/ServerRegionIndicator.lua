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

-- Server Region Indicator Module
-- NOTE: This feature is ONLY active for NA (US) region servers
-- It does NOT affect EU, CN, KR, or TW regions
-- The module safely disables itself on non-NA regions to prevent any issues

local PGF = select(2, ...)

-- DEBUG: Set to true to always show region indicators for testing
local DEBUG_ALWAYS_SHOW_INDICATOR = false

-- Store region indicator frames for each search entry
PGF.regionIndicators = {}

-- Check if we're on NA region (includes US, Brazil, LATAM, Oceanic)
-- Region IDs from GetCurrentRegion():
--   1 = US/NA (Americas)
--   2 = Korea
--   3 = Europe
--   4 = Taiwan
--   5 = China
local function IsNARegion()
    local region = GetCurrentRegion()
    return region == 1  -- Only enable for Americas region
end

-- Early exit if not on NA region to prevent any issues
if not IsNARegion() then
    -- Feature disabled for non-NA regions
    function PGF.AddRegionIndicator(self, searchResultInfo)
        -- Do nothing for non-NA regions
    end
    return  -- Exit the module
end

-- Region configuration: servers, icons, and tooltips
-- WARNING: This addon ONLY works on NA (region ID 1) servers!
-- Adding regions here won't enable the addon for EU/CN/KR/TW players
-- To support other regions, modify IsNARegion() function above
local regionConfig = {
    ["BRAZIL"] = {
        icon = "animachannel-icon-nightfae-map",  -- Night Fae icon
        tooltipTitle = "Brazilian Server",
        tooltipColor = {0, 1, 0},  -- Green
        servers = {
            ["Azralon"] = true,
            ["Gallywix"] = true,
            ["Goldrinn"] = true,
            ["Nemesis"] = true,
            ["Tol Barad"] = true,
        }
    },
    ["LATAM"] = {
        icon = "EmberCourt-32x32",  -- Fire/ember icon
        tooltipTitle = "Latin American Server",
        tooltipColor = {1, 0.55, 0},  -- Orange
        servers = {
            ["Drakkari"] = true,
            ["Quel'Thalas"] = true,
            ["Ragnaros"] = true,
        }
    },
    ["OCE"] = {
        icon = "Fishing-Hole",  -- Ocean theme
        tooltipTitle = "Oceanic Server",
        tooltipColor = {0, 0.75, 1},  -- Light blue
        servers = {
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
    },
    ["USA"] = {
        icon = "AzeriteReady",  -- Star/azerite icon
        tooltipTitle = "North American Server",
        tooltipColor = {0.2, 0.4, 0.8},  -- Blue
        servers = {}  -- Default for all other NA servers
    }
}

-- Function to detect player's own server region
local function GetPlayerServerRegion()
    local playerRealm = GetRealmName()

    -- Check each region's server list
    for region, config in pairs(regionConfig) do
        if config.servers[playerRealm] then
            return region
        end
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
    local realm = GetRealmFromLeaderName(leaderName)
    if realm then
        -- Check each region's server list
        for region, config in pairs(regionConfig) do
            if config.servers[realm] then
                return region
            end
        end
    end

    -- If we can't determine realm or it's not in special lists, it's USA/NA
    return "USA"
end

-- Function to get or create region indicator frame
function PGF.GetOrCreateRegionIndicator(parent)
    local frame = PGF.regionIndicators[parent]
    if not frame then
        frame = CreateFrame("Frame", nil, parent, nil)
        frame:Hide()
        frame:SetFrameStrata("HIGH")
        frame:SetSize(20, 20)

        -- Create icon texture
        frame.Icon = frame:CreateTexture(nil, "ARTWORK")
        frame.Icon:SetSize(20, 20)
        frame.Icon:SetPoint("CENTER")

        -- Create tooltip region
        frame:SetScript("OnEnter", function(self)
            local config = regionConfig[self.region]
            if config then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                local r, g, b = unpack(config.tooltipColor)
                GameTooltip:SetText(config.tooltipTitle, r, g, b)
                GameTooltip:AddLine("Leader is from a " .. string.lower(config.tooltipTitle), 1, 1, 1, true)
                GameTooltip:AddLine("Different ping/latency expected", 1, 0.8, 0.8, true)
                if self.realm then
                    GameTooltip:AddLine("Realm: " .. self.realm, 0.8, 0.8, 0.8, true)
                end
                GameTooltip:Show()
            end
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

    -- Get icon from config
    local config = regionConfig[region]
    if not config or not config.icon then
        return -- Unknown region or no icon configured
    end

    frame.region = region
    frame.realm = GetRealmFromLeaderName(searchResultInfo.leaderName) or 
                  (region == "USA" and "USA Realm" or "Same Realm")

    -- Show the frame
    frame:Show()

    -- Always get or create the rating frame to ensure consistent anchoring
    local ratingFrame = PGF.GetOrCreateRatingInfoFrame(self)

    -- Always anchor to the left of where the rating frame is/will be
    -- This ensures consistent positioning regardless of load order
    frame:ClearAllPoints()
    frame:SetPoint("RIGHT", ratingFrame, "LEFT", -2, 0)

    frame.Icon:SetAtlas(config.icon)

    -- Apply delisted styling if needed (no color tinting)
    if searchResultInfo.isDelisted then
        frame.Icon:SetDesaturated(true)
        frame.Icon:SetAlpha(0.5)
    else
        frame.Icon:SetDesaturated(false)
        frame.Icon:SetAlpha(1)
    end
end
