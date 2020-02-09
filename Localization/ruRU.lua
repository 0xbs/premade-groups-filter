-------------------------------------------------------------------------------
-- Premade Groups Filter
-------------------------------------------------------------------------------
-- Copyright (C) 2020 Elotheon-Arthas-EU
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

if GetLocale() ~= "ruRU" then return end

L["button.ok"] = "OK"
L["error.syntax"] = "|cffff0000Syntax error in filter expression|r\n\nThis means your filter expression is not built in the right way, e.g. there is a paranthesis missing or you wrote 'tanks=1' instead of 'tanks==1'.\n\nDetailed error message:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Semantic error in filter expression|r\n\nThis means your filter expression has correct syntax, but you most likely mispelled the name of a variable, e.g. tansk instead of tanks.\n\nDetailed error message:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Семантическая ошибка в выражении фильтра|r\n\nКлючевые слова 'name', 'comment' и 'findnumber' больше не поддерживаются. Удалите их из расширенного выражения фильтра или нажмите кнопку сброса.\n\nНачиная с Battle for Azeroth Prepatch, эти ценности теперь защищены Blizzard и больше не могут быть прочитаны никаким аддоном.\n\nИспользуйте панель поиска по умолчанию над списком групп для фильтрации имен групп.\n\nТехническое сообщение об ошибке:\n|cffaaaaaa%s|r"

L["dialog.reset"] = "Сброс"
L["dialog.refresh"] = "Поиск"
L["dialog.expl.simple"] = "Выберите условия, внесите данные мин/макс, нажмите Поиск"
L["dialog.expl.state"] = "Группы должны содержать:"
L["dialog.expl.min"] = "Мин"
L["dialog.expl.max"] = "Макс"
L["dialog.expl.advanced"] = "Если предыдущих опций не достаточно, используйте ДСФ."
L["dialog.normal"] = "обычный"
L["dialog.heroic"] = "героический"
L["dialog.mythic"] = "эпохальный"
L["dialog.mythicplus"] = "эпохальный+"
L["dialog.to"] = "-"
L["dialog.difficulty"] = "Сложность                          "
L["dialog.members"]    = "Участники                          "
L["dialog.tanks"]      = "Танк                               "
L["dialog.heals"]      = "Лекарь                             "
L["dialog.dps"]        = "Боец                               "
L["dialog.ilvl"]       = "Ур.предметов                       "
L["dialog.noilvl"] = "Игнорировать выбранные уровни"
L["dialog.defeated"] = "Боссы убиты (для рейда)"
L["dialog.usepgf.tooltip"] = "Включить/Отключить Premade Groups Filter"
L["dialog.tooltip.title"] = "ДСФ: Дополнительная Система Фильтров"
L["dialog.tooltip.variable"] = "Фильтр"
L["dialog.tooltip.description"] = "Значение"
L["dialog.tooltip.op.logic"] = "Логический синтаксис"
L["dialog.tooltip.op.number"] = "Числовые условия"
L["dialog.tooltip.op.string"] = "String Operators"
L["dialog.tooltip.op.func"] = "Functions"
L["dialog.tooltip.example"] = "ПРИМЕРЫ"
L["dialog.tooltip.ilvl"] = "заданный уровень предметов"
L["dialog.tooltip.myilvl"] = "мой уровень предмета"
L["dialog.tooltip.hlvl"] = "заданный уровень доблести"
L["dialog.tooltip.defeated"] = "кол-во побежденных рейдовых боссов"
L["dialog.tooltip.members"] = "число участников"
L["dialog.tooltip.tanks"] = "число таков"
L["dialog.tooltip.heals"] = "число лекарей"
L["dialog.tooltip.dps"] = "число бойцов"
L["dialog.tooltip.partyfit"] = "есть места для ролей моей группы"
L["dialog.tooltip.classes"] = "число определенного класса"
L["dialog.tooltip.age"] = "время поиска в минутах"
L["dialog.tooltip.voice"] = "наличие голосового чата"
L["dialog.tooltip.myrealm"] = "РЛ с моего сервера"
L["dialog.tooltip.noid"] = "подземелья/рейды в которых нет сохранения"
L["dialog.tooltip.matchingid"] = "группы с похожим сохранением"
L["dialog.tooltip.seewebsite"] = "посмотреть в интернете"
L["dialog.tooltip.difficulty"] = "сложность"
L["dialog.tooltip.raids"] = "поиск по названию рейда"
L["dialog.tooltip.dungeons"] = "поиск по названию подземелья"
L["dialog.tooltip.arena"] = "поиск по арене 2*2 3*3"
L["dialog.tooltip.ex.parentheses"] = "(voice) или (not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "name:find(\"статик\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
