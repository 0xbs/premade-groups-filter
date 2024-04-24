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

function PGF.GameTooltip_AddWhite(left)
    GameTooltip:AddLine(left, 255, 255, 255)
end

function PGF.GameTooltip_AddDoubleWhite(left, right)
    GameTooltip:AddDoubleLine(left, right, 255, 255, 255, 255, 255, 255)
end

function PGF.Dialog_InfoButton_OnEnter(self, motion)
    local AddDoubleWhiteUsingKey = function (key)
        PGF.GameTooltip_AddDoubleWhite(key, L["dialog.tooltip." .. key]) end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(L["dialog.tooltip.title"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.variable"], L["dialog.tooltip.description"])
    AddDoubleWhiteUsingKey("ilvl")
    AddDoubleWhiteUsingKey("myilvl")
    if PGF.IsRetail() then
        AddDoubleWhiteUsingKey("hlvl")
        AddDoubleWhiteUsingKey("pvprating")
        AddDoubleWhiteUsingKey("mprating")
    end
    AddDoubleWhiteUsingKey("defeated")
    AddDoubleWhiteUsingKey("members")
    AddDoubleWhiteUsingKey("tanks")
    AddDoubleWhiteUsingKey("heals")
    AddDoubleWhiteUsingKey("dps")
    if PGF.IsRetail() then
        AddDoubleWhiteUsingKey("partyfit")
        AddDoubleWhiteUsingKey("warmode")
        PGF.GameTooltip_AddDoubleWhite("autoinv", LFG_LIST_TOOLTIP_AUTO_ACCEPT)
    end
    AddDoubleWhiteUsingKey("age")
    AddDoubleWhiteUsingKey("voice")
    AddDoubleWhiteUsingKey("myrealm")
    AddDoubleWhiteUsingKey("noid")
    AddDoubleWhiteUsingKey("matchingid")
    PGF.GameTooltip_AddWhite("boss/bossesmatching/... — " .. L["dialog.tooltip.seewebsite"])
    PGF.GameTooltip_AddDoubleWhite("priests/warriors/...", L["dialog.tooltip.classes"])
    if PGF.IsRetail() then
        PGF.GameTooltip_AddDoubleWhite("voti/sfo/sod/cn/...", L["dialog.tooltip.raids"])
        PGF.GameTooltip_AddDoubleWhite("aa/av/bh/hoi/uld", L["dialog.tooltip.dungeons"])
        PGF.GameTooltip_AddWhite("no/nelt/rlp/fh/undr/nl/vp")
        PGF.GameTooltip_AddDoubleWhite("cos/votw/nl/dht/eoa/brh", L["dialog.tooltip.timewalking"])
        PGF.GameTooltip_AddDoubleWhite("arena2v2/arena3v3", L["dialog.tooltip.arena"])
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.logic"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("()", "(voice or not voice)")
    PGF.GameTooltip_AddDoubleWhite("not", "not myrealm")
    PGF.GameTooltip_AddDoubleWhite("and", "heroic and hfc")
    PGF.GameTooltip_AddDoubleWhite("or", "normal or heroic")
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.number"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("==", "dps == 3")
    PGF.GameTooltip_AddDoubleWhite("~=", "members ~= 0")
    PGF.GameTooltip_AddDoubleWhite("<,>,<=,>=", "hlvl >= 5")
    GameTooltip:Show()
end

function PGF.Dialog_InfoButton_OnLeave(self, motion)
    GameTooltip:Hide()
end

function PGF.Dialog_InfoButton_OnClick(self, button, down)
    PGF.StaticPopup_Show("PGF_COPY_URL_KEYWORDS")
end
