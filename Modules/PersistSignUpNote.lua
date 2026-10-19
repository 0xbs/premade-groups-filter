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

-- Taint fix (12.1 ADDON_ACTION_FORBIDDEN spam, cf. issue #412):
--
-- The previous implementation replaced the Blizzard global function
-- LFGListApplicationDialog_Show with a patched copy:
--
--     LFGListApplicationDialog_Show = patchedFunc
--
-- Overwriting a Blizzard global means that every later call of this function
-- by Blizzard code runs with execution tainted by "PremadeGroupsFilter".
-- Under the new 12.1 addon restrictions this can turn into
-- ADDON_ACTION_FORBIDDEN errors blamed on the addon.
--
-- This version keeps the exact same behavior (the sign-up note is preserved
-- even when applying to a group of a different activity) without replacing
-- any Blizzard global:
--   * the note text is snapshotted when the sign-up dialog is hidden
--     (secure OnHide hook, read-only access)
--   * the original Blizzard LFGListApplicationDialog_Show runs untouched
--   * a secure hooksecurefunc then restores the snapshotted note into the
--     edit box, undoing Blizzard's C_LFGList.ClearApplicationTextFields()

local persistedNote
local hooksInstalled = false

local function GetNoteEditBox(dialog)
    if not dialog then return nil end
    if LFGListApplicationDialogDescription and LFGListApplicationDialogDescription.EditBox then
        return LFGListApplicationDialogDescription.EditBox
    end
    if dialog.EditBox then
        return dialog.EditBox
    end
    return _G["LFGListApplicationDialogEditBox"]
end

local function OnDialogHidden(dialog)
    if not PremadeGroupsFilterSettings.persistSignUpNote then return end
    local editBox = GetNoteEditBox(dialog)
    if editBox then
        persistedNote = editBox:GetText()
    end
end

local function OnDialogShown(dialog)
    if not PremadeGroupsFilterSettings.persistSignUpNote then return end
    if not persistedNote or persistedNote == "" then return end
    local editBox = GetNoteEditBox(dialog)
    if editBox then
        editBox:SetText(persistedNote)
    end
end

local function InstallHooks()
    if hooksInstalled then return end
    -- The dialog and its functions are provided by the Blizzard_LFGList
    -- addon; if it is not loaded yet, retry on ADDON_LOADED.
    if type(LFGListApplicationDialog_Show) ~= "function" then return end
    if not LFGListApplicationDialog then return end

    hooksInstalled = true
    hooksecurefunc("LFGListApplicationDialog_Show", OnDialogShown)
    LFGListApplicationDialog:HookScript("OnHide", OnDialogHidden)
end

function PGF.InitPersistSignUpNote()
    InstallHooks()

    -- Blizzard_LFGList may load after PLAYER_LOGIN: hook as soon as available.
    if not hooksInstalled then
        local loader = CreateFrame("Frame")
        loader:RegisterEvent("ADDON_LOADED")
        loader:SetScript("OnEvent", function(self, event, addon)
            if addon == "Blizzard_LFGList" then
                InstallHooks()
                if hooksInstalled then
                    self:UnregisterEvent("ADDON_LOADED")
                end
            end
        end)
    end
end
