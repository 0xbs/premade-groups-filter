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

if GetLocale() ~= "esES" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Error en la sintaxis de la expresión avanzada|r\n\nEsto significa que no se ha construido de la manera correcta, por ejemplo, se te olvido poner un paréntesis o escribiste 'tanks=1' en vez de 'tanks==1'.\n\nError detallado:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Error Semántico en la expresión|r\n\nEsto signuifica que la sintaxis es correcta, pero lo mas seguro es que hayas escrito las variables mal, por ejemplo, tansk en vez de tanks.\n\nError detallado:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Error Semántico en la expresión|r\n\nLas palabras clave 'name', 'comment' und 'findnumber' ya no están soportadas. Por favor, elimínalos de tu expresión de filtro avanzada o presiona el botón de reinicio.\n\nComenzando con el Battle for Azeroth Prepatch, esos valores ahora están protegidos por Blizzard y ya no pueden ser leídos por ningún addon.\n\nUtilice la barra de búsqueda predeterminada situada encima de la lista de grupos para filtrar los nombres de los grupos.\n\nError detallado:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: Will not apply fix for 'Interface action failed because of an AddOn' errors because you don't seem to have a fully secured account and otherwise can't create premade groups. See addon FAQ for more information and how to fix this issue."
L["message.settingsupgraded"] = "Premade Groups Filter: Configuración migrada a la versión %s"

L["dialog.reset"] = "Restablecer"
L["dialog.reset.confirm"] = "¿Realmente restablecer todos los campos?"
L["dialog.refresh"] = "Buscar"
L["dialog.expl.simple"] = "Marca alguna opción, introduce mínimo y/o máximo y pulsa en Buscar."
L["dialog.expl.state"] = "El grupo debe tener:"
L["dialog.expl.min"] = "mín."
L["dialog.expl.max"] = "máx."
L["dialog.expl.advanced"] = "Si las opciones anteriores son demasiado limitadas, prueba con una consulta con expresiones avanzadas."
L["dialog.normal"] = "normal"
L["dialog.heroic"] = "heroico"
L["dialog.mythic"] = "mítico"
L["dialog.mythicplus"] = "mítico+"
L["dialog.to"] = "a"
L["dialog.difficulty"] = "Dificultad ........................."
L["dialog.members"]    = "Miembros ..........................."
L["dialog.tanks"]      = "Tanques ............................"
L["dialog.heals"]      = "Heals .............................."
L["dialog.dps"]        = "DPS ................................"
L["dialog.mprating"]   = "Cal. M+"
L["dialog.pvprating"]  = "Calificación JcJ ..................."
L["dialog.defeated"]   = "Bosses de raid muertos"
L["dialog.sorting"] = "Ordenación"
L["dialog.usepgf.tooltip"] = "Activa o desactiva Premade Groups Filter"
L["dialog.tooltip.title"] = "Expresiones de filtros avanzados"
L["dialog.tooltip.variable"] = "Variable"
L["dialog.tooltip.description"] = "Descripción"
L["dialog.tooltip.op.logic"] = "Operaciones lógicas"
L["dialog.tooltip.op.number"] = "Operadores numéricos"
L["dialog.tooltip.op.string"] = "Operadores de texto"
L["dialog.tooltip.op.func"] = "Funciones"
L["dialog.tooltip.example"] = "Ejemplo"
L["dialog.tooltip.ilvl"] = "Item level requerido"
L["dialog.tooltip.myilvl"] = "mi nivel de objeto"
L["dialog.tooltip.hlvl"] = "Nivel de honor requerido"
L["dialog.tooltip.pvprating"] = "Calificación JcJ del líder del grupo"
L["dialog.tooltip.mprating"] = "Calificación Mythic+ del líder del grupo"
L["dialog.tooltip.defeated"] = "número de bosses de raid derrotados"
L["dialog.tooltip.members"] = "número de miembros"
L["dialog.tooltip.tanks"] = "número de tanques"
L["dialog.tooltip.heals"] = "número de healers"
L["dialog.tooltip.dps"] = "número de DPS"
L["dialog.tooltip.partyfit"] = "tiene sitio para los roles de mi grupo"
L["dialog.tooltip.classes"] = "número de clases específicas"
L["dialog.tooltip.age"] = "antigüedad del grupo en minutos"
L["dialog.tooltip.voice"] = "tiene chat de voz"
L["dialog.tooltip.myrealm"] = "El líder es de mi reino"
L["dialog.tooltip.noid"] = "instancias donde no tengo ID"
L["dialog.tooltip.matchingid"] = "grupos con los mismos bosses derrotados"
L["dialog.tooltip.seewebsite"] = "ver web"
L["dialog.tooltip.difficulty"] = "dificultad"
L["dialog.tooltip.raids"] = "seleccionar solo raid específica"
L["dialog.tooltip.dungeons"] = "seleccionar mazmorra específica"
L["dialog.tooltip.timewalking"] = "seleccionar mazmorra de timewalking"
L["dialog.tooltip.arena"] = "seleccionar tipo de arena específica"
L["dialog.tooltip.warmode"] = "warmode enabled"
L["dialog.copy.url.keywords"] = "Presione CTRL+C para copiar el enlace a la lista de palabras clave"
L["dialog.filters.group"] = "Group"
L["dialog.filters.dungeons"] = "Dungeons"
L["dialog.filters.advanced"] = "Advanced Filter Expression"
L["dialog.partyfit"] = "Party Fit"
L["dialog.partyfit.tooltip"] = "Show only groups that still have slots for all your party members roles. Also works if you are alone."
L["dialog.notdeclined"] = "Not Declined"
L["dialog.notdeclined.tooltip"] = "Hide groups that declined you. Still shows groups where your application timed out."
L["dialog.blfit"] = "Bloodlust Fit"
L["dialog.blfit.tooltip"] = "If nobody in your group has bloodlust/heroism, show only groups that already have bloodlust/heroism, or after joining, there is still an open dps or healer slot. Also works if you are alone."
L["dialog.brfit"] = "Battle Res Fit"
L["dialog.brfit.tooltip"] = "If nobody in your group has a battle rezz, show only groups that already have a battle rezz, or after joining, there is still an open slot. Also works if you are alone."
L["dialog.matchingid"] = "Matching ID"
L["dialog.matchingid.tooltip"] = "Show only groups that have the exact same instance lockout than yourself. Always shows all groups where you not have lockout at all."

L["settings.dialogMovable.title"] = "Diálogo móvil"
L["settings.dialogMovable.tooltip"] = "Le permite mover el cuadro de diálogo con el mouse. El clic derecho restablece la posición."
L["settings.classNamesInTooltip.title"] = "Nombres de clases en tooltip"
L["settings.classNamesInTooltip.tooltip"] = "Muestra una lista de clases por función en la información sobre herramientas de un grupo prefabricado."
L["settings.coloredGroupTexts.title"] = "Nombre del grupo coloreado"
L["settings.coloredGroupTexts.tooltip"] = "Muestra el nombre del grupo en verde si el grupo es nuevo y en rojo si ha sido rechazado anteriormente. Muestra el nombre de la actividad en rojo si tiene un bloqueo en esa instancia."
L["settings.classBar.title"] = "Barra en color de clase"
L["settings.classBar.tooltip"] = "Muestra una pequeña barra en el color de la clase debajo de cada función en la lista de grupos de mazmorras prefabricadas."
L["settings.classCircle.title"] = "Círculo en color de clase"
L["settings.classCircle.tooltip"] = "Muestra un círculo del color de la clase en el fondo de cada función en la lista de grupos de mazmorras prefabricadas."
L["settings.leaderCrown.title"] = "Mostrar líder de grupo"
L["settings.leaderCrown.tooltip"] = "Muestra una pequeña corona sobre el rol del líder del grupo en la lista de grupos de la mazmorra prefabricada."
L["settings.ratingInfo.title"] = "Calificación de líder de grupo"
L["settings.ratingInfo.tooltip"] = "Muestra la calificación Mythic+ o PvP del líder del grupo en la lista de grupos prefabricada."
L["settings.oneClickSignUp.title"] = "Registrarse en un clic"
L["settings.oneClickSignUp.tooltip"] = "Regístrese en un grupo directamente haciendo clic en él, en lugar de seleccionarlo primero y luego hacer clic en registrarse."
L["settings.persistSignUpNote.title"] = "Nota de registro persistente"
L["settings.persistSignUpNote.tooltip"] = "Persiste la 'nota al líder del grupo' al apuntarse a diferentes grupos. De forma predeterminada, la nota se elimina cuando se selecciona un nuevo grupo."
L["settings.signupOnEnter.title"] = "Registrate con enter"
L["settings.signupOnEnter.tooltip"] = "Enfoca automáticamente el cuadro de texto 'nota para el líder del grupo' cuando te registres en un nuevo grupo y confirma tu solicitud presionando enter."
L["settings.skipSignUpDialog.title"] = "Saltar el diálogo de registro"
L["settings.skipSignUpDialog.tooltip"] = "Omita el mensaje de rol y nota si es posible e inscríbase inmediatamente en el grupo. Mantenga presionada la tecla Mayús para mostrar siempre el cuadro de diálogo."
