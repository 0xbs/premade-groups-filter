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

if GetLocale() ~= "deDE" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Syntaxfehler im Filterausdruck|r\n\nDas bedeutet, dass dein Filterausdruck nicht korrekt aufgebaut ist, z.B. fehlt eine schließende Klammer oder du hast 'tanks=1' statt 'tanks==1' geschrieben.\n\nTechnische Fehlermeldung:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Semantischer Fehler im Filterausdruck|r\n\nDas bedeutet, dass dein Filterausdruck syntaktisch korrekt ist, aber du dich vermutlich beim Namen einer Variable vertippt hast, z.B. tansk statt tanks.\n\nTechnische Fehlermeldung:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Semantischer Fehler im Filterausdruck|r\n\nDie Filterausdrücke 'name', 'comment' und 'findnumber' werden nicht mehr unterstützt. Bitte entferne sie aus deinem Filterausdruck oder drücke die Zurücksetzen-Schaltfläche.\n\nAb dem Battle for Azeroth Prepatch sind diese Werte durch Blizzard geschützt und können von keinem Addon mehr ausgewertet werden.\n\nBenutze das Standardsuchfeld oberhalb der Gruppenauflistung, um nach Gruppenname zu filtern.\n\nTechnische Fehlermeldung:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: Der Fehler 'Interface-Aktion auf Grund eines Addons fehlgeschlagen' wird nicht automatisch behoben, da du anscheinend keinen vollständig gesicherten Account hast und ansonsten keine organisierten Gruppen erstellen kannst. Siehe Addon-FAQ für weitere Informationen und wie man dieses Problem behebt."
L["message.settingsupgraded"] = "Premade Groups Filter: Einstellungen auf Version %s migriert"

L["dialog.reset"] = "Zurücksetzen"
L["dialog.reset.confirm"] = "Wirklich alle Felder zurücksetzen?"
L["dialog.refresh"] = "Suchen"
L["dialog.expl.simple"] = "Anhaken, Minimum und/oder Maximum eingeben und auf Suchen klicken."
L["dialog.expl.state"] = "Gruppe soll enthalten:"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Versucht es mit einem erweiterten Filter- ausdruck für noch mehr Möglichkeiten:"
L["dialog.normal"] = "normal"
L["dialog.heroic"] = "heroisch"
L["dialog.mythic"] = "mythisch"
L["dialog.mythicplus"] = "mythisch+"
L["dialog.to"] = "–"
L["dialog.difficulty"] = "Schwierigkeit ..........................."
L["dialog.members"]    = "Mitglieder .............................."
L["dialog.tanks"]      = "Tanks ..................................."
L["dialog.heals"]      = "Heiler .................................."
L["dialog.dps"]        = "DDs ....................................."
L["dialog.mprating"]   = "M+ Wertung"
L["dialog.pvprating"]  = "PVP Wertung ............................."
L["dialog.defeated"]   = "Besiegte Raid-Bosse"
L["dialog.sorting"] = "Sortierung"
L["dialog.usepgf.tooltip"] = "Premade Groups Filter aktivieren oder deaktivieren."
L["dialog.usepgf.usage"] = "Um maximale viele relevante Ergebnisse zu erhalten, benutzt das Suchfeld zusammen mit PGF, da die Anzahl vom Server zurückgegebener Ergebnisse begrenzt ist."
L["dialog.usepgf.results.server"] = "Vom Server gesendete Gruppen: |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "Durch PGF ausgeblendete Gruppen: |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "Angezeigte Gruppen: |cffffffff%d|r"
L["dialog.tooltip.title"] = "Erweiterte Filterausdrücke"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Beschreibung"
L["dialog.tooltip.op.logic"] = "Logische Operatoren"
L["dialog.tooltip.op.number"] = "Arithmetische Operatoren"
L["dialog.tooltip.op.string"] = "Operatoren auf Zeichenketten"
L["dialog.tooltip.op.func"] = "Funktionen"
L["dialog.tooltip.example"] = "Beispiel"
L["dialog.tooltip.ilvl"] = "benötigte Gegenstandsstufe"
L["dialog.tooltip.myilvl"] = "meine Gegenstandsstufe"
L["dialog.tooltip.hlvl"] = "benötigte Ehrenstufe"
L["dialog.tooltip.pvprating"] = "PvP-Wertung des Gruppenanführers"
L["dialog.tooltip.mprating"] = "Mythisch+ Wertung des Gruppenanführers"
L["dialog.tooltip.defeated"] = "Anzahl an besiegten Raidbossen"
L["dialog.tooltip.members"] = "Anzahl an Mitgliedern"
L["dialog.tooltip.tanks"] = "Anzahl an Tanks"
L["dialog.tooltip.heals"] = "Anzahl an Heilern"
L["dialog.tooltip.dps"] = "Anzahl an DDs"
L["dialog.tooltip.partyfit"] = "hat Platz für die Rollen meiner Gruppe"
L["dialog.tooltip.classes"] = "Anzahl an bestimmter Klasse"
L["dialog.tooltip.age"] = "Alter der Gruppe in Minuten"
L["dialog.tooltip.voice"] = "hat Sprachchat"
L["dialog.tooltip.myrealm"] = "Gruppenanführer von meinem Realm"
L["dialog.tooltip.noid"] = "Instanzen auf die ich keine ID habe"
L["dialog.tooltip.matchingid"] = "Gruppen mit gleicher ID wie eigene"
L["dialog.tooltip.seewebsite"] = "siehe Website"
L["dialog.tooltip.difficulty"] = "Schwierigkeitsgrad"
L["dialog.tooltip.raids"] = "auf Raids filtern"
L["dialog.tooltip.dungeons"] = "auf Dungeons filtern"
L["dialog.tooltip.timewalking"] = "auf Timewalking filtern"
L["dialog.tooltip.arena"] = "auf Arenatyp filtern"
L["dialog.tooltip.warmode"] = "Kriegsmodus aktiviert"
L["dialog.copy.url.keywords"] = "Drückt STRG+C, um den Link zur Liste der Schlüsselwörter zu kopieren"
L["dialog.filters.group"] = "Gruppe"
L["dialog.filters.dungeons"] = "Dungeons"
L["dialog.filters.advanced"] = "Erweiterter Filterausdruck"
L["dialog.partyfit"] = "Passende Gruppen"
L["dialog.partyfit.tooltip"] = "Zeige nur Gruppen, die noch Platz für die Rollen eurer Gruppe haben. Funktioniert auch allein."
L["dialog.notdeclined"] = "Nicht abgelehnt"
L["dialog.notdeclined.tooltip"] = "Verstecke Gruppen, die euch abgelehnt haben. Gruppen mit abgelaufener Bewerbung werden weiterhin angezeigt."
L["dialog.blfit"] = "Kampfrausch"
L["dialog.blfit.tooltip"] = "Falls in eurer Gruppe niemand Kampfrausch/Heldentum zur Verfügung stellt, zeige nur Gruppen in denen bereits eine Klasse mit Kampfrausch/Heldentum vorhanden ist oder in denen nach Beitritt noch ein DD-Platz frei ist. Funktioniert auch allein."
L["dialog.brfit"] = "Battle Res"
L["dialog.brfit.tooltip"] = "Falls in eurer Gruppe niemand einen Battle Rezz zur Verfügung stellt, zeige nur Gruppen in denen bereits eine Klasse mit Battle Rezz vorhanden ist oder in denen nach Beitritt noch ein Platz frei ist. Funktioniert auch allein."
L["dialog.matchingid"] = "Passende ID"
L["dialog.matchingid.tooltip"] = "Zeige nur Gruppen mit exakt der gleichen Instanz-ID wir Ihr selbst, die also die genau gleichen Gegner besiegt haben. Zeigt immer alle Gruppen an, in denen Ihr überhaupt keine ID habt."

L["settings.dialogMovable.title"] = "Dialog verschiebbar"
L["settings.dialogMovable.tooltip"] = "Ermöglicht das Verschieben des Dialogs mit der Maus. Rechtsklick setzt die Position zurück."
L["settings.classNamesInTooltip.title"] = "Klassennamen im Tooltip"
L["settings.classNamesInTooltip.tooltip"] = "Zeigt eine Liste von Klassen nach Rolle im Tooltip einer organisierten Gruppe an."
L["settings.coloredGroupTexts.title"] = "Farbiger Gruppenname"
L["settings.coloredGroupTexts.tooltip"] = "Färbt Gruppennamen grün wenn die Gruppe neu ist und rot wenn Ihr schon einmal abgelehnt wurdet. Färbt die Aktivität rot, wenn Ihr dieser Instanz bereits zugewiesen seid."
L["settings.classBar.title"] = "Balken in Klassenfarbe"
L["settings.classBar.tooltip"] = "Zeigt einen kleinen Balken in Klassenfarbe unter den Rollen bei organisierten Dungeongruppen."
L["settings.classCircle.title"] = "Kreis in Klassenfarbe"
L["settings.classCircle.tooltip"] = "Hinterlegt die Rollen mit einem Kreis in Klassenfarbe bei organisierten Dungeongruppen."
L["settings.leaderCrown.title"] = "Gruppenanführer anzeigen"
L["settings.leaderCrown.tooltip"] = "Zeigt eine kleine Krone über der Rolle des Gruppenanführer bei organisierten Dungeongruppen."
L["settings.ratingInfo.title"] = "Wertung des Gruppenanführers"
L["settings.ratingInfo.tooltip"] = "Zeigt die Mythisch+ oder PvP-Wertung des Gruppenanführers bei organisierten Gruppen."
L["settings.oneClickSignUp.title"] = "Ein-Klick Anmelden"
L["settings.oneClickSignUp.tooltip"] = "Meldet euch direkt für eine Gruppe an, indem Ihr darauf klickt, anstatt sie zuerst auszuwählen und dann auf Anmelden zu klicken."
L["settings.persistSignUpNote.title"] = "Anmelde-Notiz beibehalten"
L["settings.persistSignUpNote.tooltip"] = "Behält die „Notiz für den Gruppenanführer“ bei der Anmeldung bei verschiedenen Gruppen bei. Standardmäßig wird die Notiz gelöscht, wenn eine neue Gruppe ausgewählt wird."
L["settings.signupOnEnter.title"] = "Anmelden mit Eingabetaste"
L["settings.signupOnEnter.tooltip"] = "Fokussiert automatisch das Textfeld „Notiz für den Gruppenanführer“, wenn Ihr euch für eine neue Gruppe anmeldet, und bestätigt eure Anmeldung, indem Ihr die Eingabetaste drückt."
L["settings.skipSignUpDialog.title"] = "Anmelde-Dialog überspringen"
L["settings.skipSignUpDialog.tooltip"] = "Überspringt die Abfrage der Rolle und Notiz falls möglich und meldet euch sofort bei der Gruppe an. Haltet die Umschalttaste gedrückt, um den Dialog immer anzuzeigen."
L["settings.coloredApplications.title"] = "Farbige Anmeldungen"
L["settings.coloredApplications.tooltip"] = "Zeigt einen roten Hintergrund bei laufenden Anmeldungen für Mythisch+ Gruppen, wenn die Gruppe keinen Platz mehr für Eure Rolle hat."
