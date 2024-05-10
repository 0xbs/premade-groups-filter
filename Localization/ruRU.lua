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

if GetLocale() ~= "ruRU" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000Синтаксическая ошибка в выражении фильтра|r\n\nЭто означает, что Ваше выражение фильтра построено неправильно, например, не хватает парантезы или Вы написали 'tanks=1' вместо 'tanks==1'.\n\nПодробное сообщение об ошибке:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000Семантическая ошибка в выражении фильтра|r\n\nЭто означает, что Ваше выражение фильтра имеет правильный синтаксис, но Вы, скорее всего, неправильно написали имя переменной, например, 'tansk' вместо 'tanks'.\n\nПодробное сообщение об ошибке:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000Семантическая ошибка в выражении фильтра|r\n\nКлючевые слова 'name', 'comment' и 'findnumber' больше не поддерживаются. Удалите их из расширенного выражения фильтра или нажмите кнопку сброса.\n\nНачиная с препатча BFA, эти значения теперь защищены Blizzard и больше не могут быть прочитаны никаким аддоном.\n\nИспользуйте панель поиска по умолчанию над списком групп для фильтрации имен групп.\n\nТехническое сообщение об ошибке:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: Не будет применяться исправление для ошибки 'Interface action failed because of an AddOn', потому что, похоже, у Вас нет полностью защищенной учетной записи, и Вы не можете создавать заранее собранные группы. См. FAQ по аддону для получения дополнительной информации и способов решения этой проблемы."
L["message.settingsupgraded"] = "Premade Groups Filter: Настройки перенесены в версию %s"

L["dialog.reset"] = "Сброс"
L["dialog.reset.confirm"] = "Действительно сбросить все поля?"
L["dialog.refresh"] = "Поиск"
L["dialog.expl.simple"] = "Выберите условия, внесите данные мин/макс, нажмите Поиск"
L["dialog.expl.state"] = "Группы должны содержать:"
L["dialog.expl.min"] = "Мин."
L["dialog.expl.max"] = "Макс."
L["dialog.expl.advanced"] = "Если предыдущих опций недостаточно, используйте ДСФ."
L["dialog.normal"] = "обычный"
L["dialog.heroic"] = "героический"
L["dialog.mythic"] = "эпохальный"
L["dialog.mythicplus"] = "эпохальный+"
L["dialog.to"] = "-"
L["dialog.difficulty"] = "Сложность"
L["dialog.members"]    = "Участники"
L["dialog.tanks"]      = "Танк"
L["dialog.heals"]      = "Лекарь"
L["dialog.dps"]        = "Боец"
L["dialog.mprating"]   = "М+ рейтинг"
L["dialog.pvprating"]  = "PvP рейтинг"
L["dialog.defeated"]   = "Боссы убиты (для рейда)"
L["dialog.sorting"] = "Сортировка"
L["dialog.usepgf.tooltip"] = "Включить/отключить Premade Groups Filter"
L["dialog.usepgf.usage"] = "Чтобы получить максимальное количество релевантных результатов, используйте поисковую строку вместе с PGF, так как количество результатов, возвращаемых сервером, ограничено."
L["dialog.usepgf.results.server"] = "Группы, отправленные сервером: |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "Группы, скрытые PGF: |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "Отображаемые группы: |cffffffff%d|r"
L["dialog.tooltip.title"] = "ДСФ: Дополнительная Система Фильтров"
L["dialog.tooltip.variable"] = "Фильтр"
L["dialog.tooltip.description"] = "Описание"
L["dialog.tooltip.op.logic"] = "Логический синтаксис"
L["dialog.tooltip.op.number"] = "Числовые условия"
L["dialog.tooltip.op.string"] = "Строковые операторы"
L["dialog.tooltip.op.func"] = "Функции"
L["dialog.tooltip.example"] = "Примеры"
L["dialog.tooltip.ilvl"] = "заданный уровень предметов"
L["dialog.tooltip.myilvl"] = "мой уровень предмета"
L["dialog.tooltip.hlvl"] = "заданный уровень доблести"
L["dialog.tooltip.pvprating"] = "PvP рейтинг лидера группы"
L["dialog.tooltip.mprating"] = "M+ рейтинг лидера группы"
L["dialog.tooltip.defeated"] = "кол-во побежденных рейдовых боссов"
L["dialog.tooltip.members"] = "число участников"
L["dialog.tooltip.tanks"] = "число танков"
L["dialog.tooltip.heals"] = "число лекарей"
L["dialog.tooltip.dps"] = "число бойцов"
L["dialog.tooltip.partyfit"] = "есть места для ролей моей группы"
L["dialog.tooltip.classes"] = "число определенного класса"
L["dialog.tooltip.age"] = "время поиска в минутах"
L["dialog.tooltip.voice"] = "наличие голосового чата"
L["dialog.tooltip.myrealm"] = "РЛ с моего сервера"
L["dialog.tooltip.noid"] = "подземелья/рейды, в которых нет сохранения"
L["dialog.tooltip.matchingid"] = "группы с похожим сохранением"
L["dialog.tooltip.seewebsite"] = "посмотреть в интернете"
L["dialog.tooltip.difficulty"] = "сложность"
L["dialog.tooltip.raids"] = "поиск по названию рейда"
L["dialog.tooltip.dungeons"] = "поиск по названию подземелья"
L["dialog.tooltip.timewalking"] = "выберите подземелье для путешествий во времени"
L["dialog.tooltip.arena"] = "поиск по арене 2*2 3*3"
L["dialog.tooltip.warmode"] = "режим войны включен"
L["dialog.copy.url.keywords"] = "Нажмите CTRL+C, чтобы скопировать ссылку для просмотра ключевых слов."
L["dialog.filters.group"] = "Группа"
L["dialog.filters.dungeons"] = "Подземелья"
L["dialog.filters.advanced"] = "Расширенное выражение фильтра"
L["dialog.partyfit"] = "Подходящая группа"
L["dialog.partyfit.tooltip"] = "Показывать только те группы, в которых еще есть слоты для всех ролей членов Вашей группы. Также работает, если Вы один."
L["dialog.notdeclined"] = "Отклоненные группы"
L["dialog.notdeclined.tooltip"] = "Скрыть группы, в которых Вам отказали. По-прежнему показывает группы, в которых время ожидания Вашей заявки истекло."
L["dialog.blfit"] = "Кровожадность / Героизм"
L["dialog.blfit.tooltip"] = "Если ни у кого в Вашей группе нет Кровожадности / Героизма, то показывать только те группы, у которых уже есть Кровожадность / Героизм, иначе после присоединения к ним все еще есть свободный слот для бойца или целителя. Также работает, если Вы один."
L["dialog.brfit"] = "Воскрешение в бою"
L["dialog.brfit.tooltip"] = "Если ни у кого в Вашей группе нет Воскрешения в бою, то показывать только те группы, у которых уже есть Воскрешение в бою, иначе после присоединения к ним все еще есть свободный слот. Также работает, если Вы один."
L["dialog.matchingid"] = "Соответствующий ID подземелья"
L["dialog.matchingid.tooltip"] = "Показывать только те группы, у которых такая же блокировка подземелья, как и у Вас. Всегда показывать все группы, в которых у Вас вообще нет блокировки."

L["settings.dialogMovable.title"] = "Перемещаемый диалог"
L["settings.dialogMovable.tooltip"] = "Позволяет перемещать диалог с помощью мыши. ПКМ - сбрасывает положение."
L["settings.classNamesInTooltip.title"] = "Названия классов в подсказке"
L["settings.classNamesInTooltip.tooltip"] = "Показывает список классов по ролям во всплывающей подсказке готовой группы."
L["settings.coloredGroupTexts.title"] = "Цветное название группы"
L["settings.coloredGroupTexts.tooltip"] = "Отображает название группы зеленым цветом, если группа новая, и красным цветом, если Вы ранее были отклонены. Отображает название активности красным цветом, если у Вас есть блокировка для этого подземелья."
L["settings.classBar.title"] = "Полоса цвета класса"
L["settings.classBar.tooltip"] = "Показывает небольшую полосу цвета класса под каждой ролью в списке готовых групп подземелий."
L["settings.classCircle.title"] = "Кружок цвета класса"
L["settings.classCircle.tooltip"] = "Показывает круг цвета класса на фоне каждой роли в списке готовых групп подземелий."
L["settings.leaderCrown.title"] = "Лидер группы"
L["settings.leaderCrown.tooltip"] = "Показывает маленькую корону над ролью лидера группы в списке готовых групп подземелий."
L["settings.ratingInfo.title"] = "Рейтинг лидера группы"
L["settings.ratingInfo.tooltip"] = "Показывает М+ или PvP-рейтинг лидера группы в готовом списке групп."
L["settings.oneClickSignUp.title"] = "Подписаться в один клик"
L["settings.oneClickSignUp.tooltip"] = "Подписаться в группу напрямую, нажав на нее, вместо того, чтобы сначала выбрать ее, а затем нажать «Подписаться»."
L["settings.persistSignUpNote.title"] = "Сохранить заметку о подписке"
L["settings.persistSignUpNote.tooltip"] = "Сохраняет «заметку лидеру группы» при регистрации на разные группы. По умолчанию заметка удаляется при выборе новой группы."
L["settings.signupOnEnter.title"] = "Подписаться с помощью Enter"
L["settings.signupOnEnter.tooltip"] = "Автоматически выделить текстовое поле «заметка лидеру группы» при регистрации в новой группе и подтвердить свою заявку нажатием Enter."
L["settings.skipSignUpDialog.title"] = "Пропустить диалог регистрации"
L["settings.skipSignUpDialog.tooltip"] = "По возможности пропустить подсказку о роли и примечании и сразу зарегистрироваться в группе. Удерживайте Shift, чтобы всегда показывать диалог."
L["settings.coloredApplications.title"] = "Цветная заявка"
L["settings.coloredApplications.tooltip"] = "Показывает красный фон в заявках на участие в группах M+, если в группе не осталось мест для Вашей роли."
