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

if GetLocale() ~= "esES" then return end

L["button.ok"] = "OK"
L["error.syntax"] = "|cffff0000Error en la sintaxis de la expresión avanzada|r\n\nEsto significa que no se ha construido de la manera correcta, por ejemplo, se te olvido poner un paréntesis o escribiste 'tanks=1' en vez de 'tanks==1'.\n\nError detallado:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Error Semántico en la expresión|r\n\nEsto signuifica que la sintaxis es correcta, pero lo mas seguro es que hayas escrito las variables mal, por ejemplo, tansk en vez de tanks.\n\nError detallado:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Error Semántico en la expresión|r\n\nLas palabras clave 'name', 'comment' und 'findnumber' ya no están soportadas. Por favor, elimínalos de tu expresión de filtro avanzada o presiona el botón de reinicio.\n\nComenzando con el Battle for Azeroth Prepatch, esos valores ahora están protegidos por Blizzard y ya no pueden ser leídos por ningún addon.\n\nUtilice la barra de búsqueda predeterminada situada encima de la lista de grupos para filtrar los nombres de los grupos.\n\nError detallado:\n|cffaaaaaa%s|r"

L["dialog.reset"] = "Resetear"
L["dialog.refresh"] = "Buscar"
L["dialog.expl.simple"] = "Active la checkbox, escriba el mínimo y/o máximo y haga click en Buscar."
L["dialog.expl.state"] = "El grupo debe tener:"
L["dialog.expl.min"] = "min"
L["dialog.expl.max"] = "max"
L["dialog.expl.advanced"] = "Si las opciones de arriba están muy limitadas, prueba una expresiones avanzadas en la querry."
L["dialog.normal"] = "normal"
L["dialog.heroic"] = "heroico"
L["dialog.mythic"] = "mítico"
L["dialog.mythicplus"] = "mítico+"
L["dialog.to"] = "a"
L["dialog.difficulty"] = "Dificultad ......................"
L["dialog.members"]    = "Miembros ........................"
L["dialog.tanks"]      = "Tanques ........................."
L["dialog.heals"]      = "Heals ..........................."
L["dialog.dps"]        = "DPS ............................."
L["dialog.ilvl"]       = "Item Level ......................"
L["dialog.noilvl"] = "o sin Item Level especificado"
L["dialog.defeated"] = "Bosses muertos (solo banda)"
L["dialog.usepgf.tooltip"] = "Activa o desactiva Premade Groups Filter"
L["dialog.tooltip.title"] = "Expresiones de filtros avanzadas"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Descripción"
L["dialog.tooltip.op.logic"] = "Operaciones lógicas"
L["dialog.tooltip.op.number"] = "Operadores numéricos"
L["dialog.tooltip.op.string"] = "Operadores de texto"
L["dialog.tooltip.op.func"] = "Funciones"
L["dialog.tooltip.example"] = "Ejemplo"
L["dialog.tooltip.ilvl"] = "Item level requerido"
L["dialog.tooltip.hlvl"] = "Nivel de honor requerido"
L["dialog.tooltip.defeated"] = "número de bosses de raid muertos"
L["dialog.tooltip.members"] = "número de miembros"
L["dialog.tooltip.tanks"] = "número de tanques"
L["dialog.tooltip.heals"] = "número de healers"
L["dialog.tooltip.dps"] = "número de DPSs"
L["dialog.tooltip.classes"] = "número de clases específicas"
L["dialog.tooltip.age"] = "edad del grupo en minutos"
L["dialog.tooltip.voice"] = "tiene chat de voz"
L["dialog.tooltip.myrealm"] = "El Líder es de mi reino"
L["dialog.tooltip.noid"] = "instancias donde no tengo ID"
L["dialog.tooltip.matchingid"] = "grupos con los mismos bosses metros"
L["dialog.tooltip.seewebsite"] = "mirar website"
L["dialog.tooltip.difficulty"] = "dificultad"
L["dialog.tooltip.raids"] = "seleccionar solo raid específica"
L["dialog.tooltip.dungeons"] = "seleccionar mazmorra específica"
L["dialog.tooltip.arena"] = "seleccionar tipo de arena específico"
L["dialog.tooltip.ex.parentheses"] = "(voice or not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
