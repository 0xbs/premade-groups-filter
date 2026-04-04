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

local PGFAddonName, PGF = ...
local L = PGF.L
local C = PGF.C

-- Panel ID
-- cX  see C.CATEGORY_ID
-- f0  Default
-- f1  Recommended    -- raids
-- f2  NotRecommended -- raids
-- f4  PvE            -- custom
-- f8  PvP            -- custom

local PGFDialog = CreateFrame("Frame", "PremadeGroupsFilterDialog", PVEFrame, "PremadeGroupsFilterDialogTemplate")

function PGFDialog:InitRestrictionOverlay()
    if not C_RestrictedActions or not C_RestrictedActions.IsAddOnRestrictionActive then return end
    local overlay = CreateFrame("Frame", nil, self, "BackdropTemplate")
    overlay:SetPoint("LEFT")
    overlay:SetPoint("TOP", 0, -20)
    overlay:SetPoint("RIGHT")
    overlay:SetPoint("BOTTOM", 0, 25)
    overlay:SetFrameLevel(self:GetFrameLevel() + 10)
    overlay:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        --edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    overlay:SetBackdropColor(0, 0, 0, 1)
    overlay:EnableMouse(true) -- block clicks to controls behind

    local text = overlay:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetPoint("CENTER", 0, 0)
    text:SetPoint("LEFT", 20, 0)
    text:SetPoint("RIGHT", -20, 0)
    text:SetJustifyH("CENTER")
    text:SetText(L["dialog.restriction.text"])

    local icon = overlay:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
    icon:SetSize(36, 36)
    icon:SetPoint("BOTTOM", text, "TOP", 0, 14)

    local button = CreateFrame("Button", nil, overlay, "MagicButtonTemplate")
    button:SetSize(160, 22)
    button:SetPoint("TOP", text, "BOTTOM", 0, -14)
    button:SetText(L["dialog.restriction.ok"])
    button:SetScript("OnClick", function()
        PGF.AcknowledgeRestriction()
        overlay:Hide()
        PGF.FilterSearchResults()
    end)

    overlay:Hide()
    self.RestrictionOverlay = overlay
end

function PGFDialog:UpdateRestrictionOverlay()
    if not self.RestrictionOverlay then return end
    if PGF.IsRestricted() then
        self.RestrictionOverlay:Show()
    else
        self.RestrictionOverlay:Hide()
    end
end

local function HasPGFTaint()
    if not LFGListFrame then return false end
    local secure, source = issecurevariable("LFGListFrame")
    if not secure and source == PGFAddonName then return true end
    local checks = {
        { LFGListFrame.SearchPanel, "results" },
        { LFGListFrame.SearchPanel, "totalResults" },
        { LFGListFrame, "ApplicationViewer" },
        { LFGListFrame.ApplicationViewer, "EntryName" },
        { LFGListFrame, "declines" },
        { LFGListApplicationDialog, "activityID" },
    }
    for _, check in ipairs(checks) do
        local secure, source = issecurevariable(check[1], check[2])
        if not secure and source == PGFAddonName then return true end
    end
    return false
end

local taintNotification
local taintNotificationDismissed = false

local function CreateTaintNotification()
    local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    frame:SetSize(320, 100)
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -16)
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.9)
    frame:SetBackdropBorderColor(1, 0.82, 0, 1)
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:EnableMouse(true)

    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 2, 2)
    closeButton:SetScript("OnClick", function()
        taintNotificationDismissed = true
        frame:Hide()
    end)

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
    icon:SetSize(28, 28)
    icon:SetPoint("TOPLEFT", 10, -10)

    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, 0)
    text:SetPoint("RIGHT", closeButton, "LEFT", -4, 0)
    text:SetJustifyH("LEFT")
    text:SetText(L["dialog.taint.text"])

    local reloadButton = CreateFrame("Button", nil, frame, "MagicButtonTemplate")
    reloadButton:SetSize(120, 22)
    reloadButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 10)
    reloadButton:SetText(L["dialog.taint.reload"])
    reloadButton:SetScript("OnClick", function() ReloadUI() end)

    -- adjust height based on text
    frame:SetScript("OnShow", function(self)
        local height = 10 + math.max(icon:GetHeight(), text:GetStringHeight()) + 10 + reloadButton:GetHeight() + 16
        self:SetHeight(height)
    end)

    frame:Hide()
    return frame
end

function PGFDialog:CheckTaintAndNotify()
    if not C_RestrictedActions or not C_RestrictedActions.IsAddOnRestrictionActive then return end
    local restricted = C_RestrictedActions.IsAddOnRestrictionActive(Enum.AddOnRestrictionType.Map)
    local shouldShow = restricted and HasPGFTaint() and not taintNotificationDismissed
    if shouldShow then
        if not taintNotification then
            taintNotification = CreateTaintNotification()
        end
        taintNotification:Show()
    elseif taintNotification and taintNotification:IsShown() then
        taintNotification:Hide()
    end
end

function PGFDialog:OnLoad()
    PGF.Logger:Debug("PGFDialog:OnLoad")
    self.minimizedHeight = 220
    self.maximizedHeight = PVEFrame:GetHeight()
    self.panels = {}
    self.activeId = nil
    self.activeState = nil
    self.activePanel = nil

    self:SetScript("OnShow", self.OnShow)
    self:SetScript("OnHide", self.OnHide)
    self:SetScript("OnMouseDown", self.OnMouseDown)
    self:SetScript("OnMouseUp", self.OnMouseUp)

    self:SetTitle(L["addon.name.long"])
    if PGF.SupportsDragonflightUI() then
        self:SetBorder("ButtonFrameTemplateNoPortraitMinimizable")
        self:SetPortraitShown(false)
        self.MaximizeMinimizeFrame:SetOnMaximizedCallback(function () self:OnMaximize() end)
        self.MaximizeMinimizeFrame:SetOnMinimizedCallback(function () self:OnMinimize() end)
    end

    self.ResetButton:SetScript("OnClick", function () self:OnResetButtonClick() end)
    self.ResetButton:SetScript("OnEnter", function (self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["dialog.reset"], nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    self.ResetButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    self.SettingsButton:SetScript("OnClick", function () PGF.OpenSettings() end)
    self.SettingsButton:SetScript("OnEnter", function (self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["dialog.settings"], nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    self.SettingsButton:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    self.RefreshButton:SetText(L["dialog.refresh"])
    self.RefreshButton:SetScript("OnClick", function () self:OnRefreshButtonClick() end)

    self:InitRestrictionOverlay()

    if C_EventUtils and C_EventUtils.IsEventValid and C_EventUtils.IsEventValid("ADDON_RESTRICTION_STATE_CHANGED") then
        self:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
    end
    self:SetScript("OnEvent", self.OnEvent)
end

function PGFDialog:OnEvent(event, ...)
    if event == "ADDON_RESTRICTION_STATE_CHANGED" then
        -- The event only fires with state "Activating", so defer execution to next frame
        C_Timer.After(0, function()
            self:UpdateRestrictionOverlay()
            self:CheckTaintAndNotify()
        end)
    end
end

function PGFDialog:OnShow()
    PGF.Logger:Debug("PGFDialog:OnShow")
    if not PremadeGroupsFilterSettings.dialogMovable then
        self:ResetPosition()
    end
    if self.activePanel and self.activePanel.OnShow then
        self.activePanel:OnShow()
    end
    self:UpdateRestrictionOverlay()
end

function PGFDialog:OnHide()
    PGF.Logger:Debug("PGFDialog:OnHide")
    if self.activePanel and self.activePanel.OnHide then
        self.activePanel:OnHide()
    end
end

function PGFDialog:OnMouseDown(button)
    if not PremadeGroupsFilterSettings.dialogMovable then return end
    self:StartMoving()
end

function PGFDialog:OnMouseUp(button)
    if not PremadeGroupsFilterSettings.dialogMovable then return end
    self:StopMovingOrSizing()
    if button == "RightButton" then
        self:ResetPosition()
    end
end

function PGFDialog:OnMaximize()
    PGF.Logger:Debug("PGFDialog:OnMaximize")
    self.activeState.minimized = false
    self:SetHeight(self.maximizedHeight)
    self:SwitchToPanel()
end

function PGFDialog:OnMinimize()
    PGF.Logger:Debug("PGFDialog:OnMinimize")
    self.activeState.minimized = true
    self:SetHeight(self.minimizedHeight)
    self:SwitchToPanel()
end

function PGFDialog:MaximizeMinimize()
    if self.activeState.minimized then
        self.MaximizeMinimizeFrame.isMinimized = true
        self.MaximizeMinimizeFrame:SetMaximizedLook() -- button should show maximize icon
        self:SetHeight(self.minimizedHeight)
    else
        self.MaximizeMinimizeFrame.isMinimized = false
        self.MaximizeMinimizeFrame:SetMinimizedLook() -- button should show minimize icon
        self:SetHeight(self.maximizedHeight)
    end
end

function PGFDialog:OnResetButtonClick()
    PGF.Logger:Debug("PGFDialog:OnResetButtonClick")
    PGF.StaticPopup_Show("PGF_CONFIRM_RESET")
end

function PGFDialog:OnRefreshButtonClick()
    PGF.Logger:Debug("PGFDialog:OnRefreshButtonClick")
    self:Refresh()
end

function PGFDialog:Refresh()
    LFGListSearchPanel_DoSearch(LFGListFrame.SearchPanel)
end

function PGFDialog:Reset()
    PGF.Logger:Debug("PGFDialog:Reset")
    self.activePanel:OnReset()
end

function PGFDialog:UpdateExpression(expression, sorting)
    PGF.Logger:Debug("PGFDialog:SetExpressionFromMacro")
    self.activePanel:OnUpdateExpression(expression, sorting)
end

function PGFDialog:Toggle()
    PGF.Logger:Debug("PGFDialog:Toggle")
    local isSearchPanelVisible = PVEFrame:IsVisible()
            and LFGListFrame.activePanel == LFGListFrame.SearchPanel
            and LFGListFrame.SearchPanel:IsVisible()
    if isSearchPanelVisible and self.activeState and self.activeState.enabled then
        self:Show()
    else
        self:Hide()
    end
end

function PGFDialog:UpdateCategory(categoryID, filters, baseFilters)
    PGF.Logger:Debug("PGFDialog:UpdateCategory(".. categoryID ..", "..filters..", "..baseFilters..")")
    local allFilters = bit.bor(baseFilters, filters);
    local id = "c"..categoryID.."f"..allFilters
    self.activeId = id
    self.activeState = self:GetState(id)
    if PGF.SupportsDragonflightUI() then
        self:MaximizeMinimize()
    end
    self:SwitchToPanel()
end

function PGFDialog:SwitchToPanel()
    local panel = self.activeState.minimized
            and self.panels.mini          -- if minimized, use mini panel
            or self.panels[self.activeId] -- if maximized, use panel for current category
            or self.panels.role           -- if no panel for current category, use role panel
    PGF.Logger:Debug("PGFDialog:SwitchToPanel("..panel.name..")")
    self.activeState[panel.name] = self.activeState[panel.name] or {} -- initialize panel state
    if self.activePanel then self.activePanel:Hide() end
    self.activePanel = panel
    self.activePanel:Init(self.activeState[panel.name])
    if self.activePanel.GetDesiredDialogWidth then
        local desiredWidth = self.activePanel:GetDesiredDialogWidth()
        self:SetWidth(desiredWidth)
    elseif PGF.SupportsDragonflightUI() then
        self:SetWidth(300)
    else
        self:SetWidth(310)
    end
    if not PGF.SupportsDragonflightUI() then
        self.activePanel:ClearAllPoints()
        self.activePanel:SetPoint("TOPLEFT", 5, -20)
        self.activePanel:SetPoint("BOTTOMRIGHT", 0, 35)
    end
    self.activePanel:Show()
end

function PGFDialog:GetState(id)
    if PremadeGroupsFilterState[id] == nil then
        PremadeGroupsFilterState[id] = {}
        if self.panels[id] then -- if there is a special panel registered for this id, enable it on first run
            PremadeGroupsFilterState[id].enabled = true
        end
    end
    return PremadeGroupsFilterState[id]
end

function PGFDialog:GetEnabled()
    return self.activeState and self.activeState.enabled or false
end

function PGFDialog:SetEnabled(enabled)
    self.activeState.enabled = enabled
    self:Toggle()
    self:OnFilterExpressionChanged(true)
end

function PGFDialog:OnFilterExpressionChanged(shouldRefresh)
    PGF.Logger:Debug("PGFDialog:OnFilterExpressionChanged")
    if shouldRefresh then
        self:Refresh()
    end
    PGF.FilterSearchResults()
end

function PGFDialog:GetFilterExpression()
    PGF.Logger:Debug("PGFDialog:GetFilterExpression")
    if not self.activePanel then return nil end
    return self.activePanel:GetFilterExpression()
end

function PGFDialog:GetSortingExpression()
    if not self.activePanel then return nil end
    return self.activePanel:GetSortingExpression()
end

function PGFDialog:ResetPosition()
    PGF.Logger:Debug("PGFDialog:ResetPosition")
    self:ClearAllPoints()
    if PGF.SupportsDragonflightUI() then
        self:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT")
    else
        self:SetPoint("TOPLEFT", PVEFrame, "TOPRIGHT", -5, 0)
    end
end

function PGFDialog:RegisterPanel(id, panel)
    PGF.Logger:Debug("PGFDialog:RegisterPanel("..id..")")
    self.panels[id] = panel
end

local pvpButtonsHooked = false
hooksecurefunc("LFGListSearchPanel_SetCategory", function(self, categoryID, filters, baseFilters)
    PGFDialog:UpdateCategory(categoryID, filters, baseFilters)
end)
hooksecurefunc("LFGListFrame_SetActivePanel", function () PGFDialog:Toggle() end)
hooksecurefunc("PVEFrame_ShowFrame", function (sidePanelName, selection)
    -- PVPUIFrame is loaded dynamically and not available on startup
    if sidePanelName == "PVPUIFrame" and PVPQueueFrame_ShowFrame and not pvpButtonsHooked then
        hooksecurefunc("PVPQueueFrame_ShowFrame", function () PGFDialog:Toggle() end)
        pvpButtonsHooked = true
    end
    PGFDialog:Toggle()
end)
hooksecurefunc("GroupFinderFrame_ShowGroupFrame", function () PGFDialog:Toggle() end)
PVEFrame:HookScript("OnShow", function () PGFDialog:Toggle() end)
PVEFrame:HookScript("OnHide", function () PGFDialog:Toggle() end)

PGFDialog:OnLoad()
PGF.Dialog = PGFDialog
