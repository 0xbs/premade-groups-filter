-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2015 Elotheon-Arthas-EU
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
    AddDoubleWhiteUsingKey("hlvl")
    AddDoubleWhiteUsingKey("defeated")
    AddDoubleWhiteUsingKey("members")
    AddDoubleWhiteUsingKey("tanks")
    AddDoubleWhiteUsingKey("heals")
    AddDoubleWhiteUsingKey("dps")
    AddDoubleWhiteUsingKey("age")
    AddDoubleWhiteUsingKey("voice")
    PGF.GameTooltip_AddDoubleWhite("autoinv", LFG_LIST_TOOLTIP_AUTO_ACCEPT)
    AddDoubleWhiteUsingKey("myrealm")
    AddDoubleWhiteUsingKey("noid")
    AddDoubleWhiteUsingKey("matchingid")
    PGF.GameTooltip_AddWhite("bossesmatching/bossesahead/bossesbehind — " .. L["dialog.tooltip.seewebsite"])
    PGF.GameTooltip_AddDoubleWhite("priests/warriors/...", L["dialog.tooltip.classes"])
    PGF.GameTooltip_AddDoubleWhite("normal/heroic", L["dialog.tooltip.difficulty"])
    PGF.GameTooltip_AddWhite("mythic/mythicplus")
    PGF.GameTooltip_AddDoubleWhite("uldir/daz/cru/ete/tep", L["dialog.tooltip.raids"])
    PGF.GameTooltip_AddDoubleWhite("ad/fh/kr/sob/sots", L["dialog.tooltip.dungeons"])
    PGF.GameTooltip_AddWhite("td/tml/tosl/tur/wm/opm")
    PGF.GameTooltip_AddDoubleWhite("arena2v2/arena3v3", L["dialog.tooltip.arena"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.logic"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("()", L["dialog.tooltip.ex.parentheses"])
    PGF.GameTooltip_AddDoubleWhite("not", L["dialog.tooltip.ex.not"])
    PGF.GameTooltip_AddDoubleWhite("and", L["dialog.tooltip.ex.and"])
    PGF.GameTooltip_AddDoubleWhite("or", L["dialog.tooltip.ex.or"])
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(L["dialog.tooltip.op.number"], L["dialog.tooltip.example"])
    PGF.GameTooltip_AddDoubleWhite("==", L["dialog.tooltip.ex.eq"])
    PGF.GameTooltip_AddDoubleWhite("~=", L["dialog.tooltip.ex.neq"])
    PGF.GameTooltip_AddDoubleWhite("<,>,<=,>=", L["dialog.tooltip.ex.lt"])
    GameTooltip:Show()
end

function PGF.Dialog_InfoButton_OnLeave(self, motion)
    GameTooltip:Hide()
end
