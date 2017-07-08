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

if GetLocale() ~= "deDE" then return end

L["button.ok"] = "OK"
L["error.syntax"] = "|cffff0000Syntaxfehler im Filterausdruck|r\n\nDas bedeutet, dass dein Filterausdruck nicht korrekt aufgebaut ist, z.B. fehlt eine schließende Klammer oder du hast 'tanks=1' statt 'tanks==1' geschrieben.\n\nDetaillierte Fehlermeldung:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Semantischer Fehler Im Filterausdruck|r\n\nDas bedeutet, dass dein Filterausdruck syntaktisch korrekt ist, aber du dich vermutlich beim Namen einer Variable vertippt hast, z.B. tansk statt tanks.\n\nDetaillierte Fehlermeldung:\n|cffaaaaaa%s|r"

L["dialog.reset"] = "Zurücksetzen"
L["dialog.refresh"] = "Suchen"
L["dialog.expl.simple"] = "Anhaken, Minimum und/oder Maximum eingeben und auf Suchen klicken."
L["dialog.expl.state"] = "Gruppe soll enthalten:"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Versuch es mit einem erweiterten Filter- ausdruck für noch mehr Möglichkeiten:"
L["dialog.normal"] = "normal"
L["dialog.heroic"] = "heroisch"
L["dialog.mythic"] = "mythisch"
L["dialog.mythicplus"] = "mythisch+"
L["dialog.to"] = "bis"
L["dialog.difficulty"] = "Schwierigkeit ......................"
L["dialog.members"]    = "Mitglieder ........................."
L["dialog.tanks"]      = "Tanks ..........................."
L["dialog.heals"]      = "Heiler ..........................."
L["dialog.dps"]        = "DDs ............................."
L["dialog.ilvl"]       = "Gegenstandsstufe ......................"
L["dialog.noilvl"] = "oder GS nicht festgelegt"
L["dialog.defeated"] = "besiegte Bosse\n(nur Raids)"
L["dialog.usepgf.tooltip"] = "Premade Groups Filter aktivieren oder deaktivieren"
L["dialog.tooltip.title"] = "Erweiterte Filterausdrücke"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Beschreibung"
L["dialog.tooltip.op.logic"] = "Logische Operatoren"
L["dialog.tooltip.op.number"] = "Arithmetische Operatoren"
L["dialog.tooltip.op.string"] = "Operatoren auf Zeichenketten"
L["dialog.tooltip.op.func"] = "Funktionen"
L["dialog.tooltip.findnumber"] = "filtert auf Zahlen in Beschreibungen"
L["dialog.tooltip.example"] = "Beispiel"
L["dialog.tooltip.name"] = "Name (großer weißer Text)"
L["dialog.tooltip.comment"] = "Kommentar (grauer Text)"
L["dialog.tooltip.ilvl"] = "benötigte Gegenstandsstufe"
L["dialog.tooltip.hlvl"] = "benötigte Ehrenstufe"
L["dialog.tooltip.defeated"] = "Anzahl an besiegten Raidbossen"
L["dialog.tooltip.members"] = "Anzahl an Mitgliedern"
L["dialog.tooltip.tanks"] = "Anzahl an Tanks"
L["dialog.tooltip.heals"] = "Anzahl an Heilern"
L["dialog.tooltip.dps"] = "Anzahl an DDs"
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
L["dialog.tooltip.arena"] = "auf Arenatyp filtern"
L["dialog.tooltip.ex.parentheses"] = "(voice or not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
