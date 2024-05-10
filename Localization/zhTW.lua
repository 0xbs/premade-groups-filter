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

if GetLocale() ~= "zhTW" then return end

L["addon.name.short"] = "過濾選項"
L["addon.name.long"] = "預組隊伍過濾"

L["error.syntax"] = "|cffff0000過濾語法錯誤|r\n\n表示過濾語法不正確，例如缺少過濾條件、變數或運算符號，或是寫成 'tanks=1' 而不是 'tanks==1'。\n\n詳細錯誤訊息：\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000過濾語法的語意錯誤|r\n\n表示過濾語法正確，但是很可能變數寫錯字，例如寫成 tansk 而不是 tanks。\n\n詳細錯誤訊息：\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000過濾語法的語意錯誤|r\n\n不再支持關鍵字 'name'，'comment' 和 'findnumber'。 請從高級過濾器表達方式中刪除他們或者點擊重置按鈕。 \n\n從爭霸艾澤拉斯開始，這些都受到暴雪的保護，任何插件都無法讀取。 \n\n使用列表上方的確認搜索欄過濾隊伍副本名稱。\n\n詳細錯誤訊息：\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "預組隊伍過濾: 不會修復“接口操作因AddOn而失敗”錯誤，因為您似乎沒有完全安全的帳戶，否則無法創建預製隊伍。請參閱插件常見問題解答以獲取更多信息以及如何解決此問題。"
L["message.settingsupgraded"] = "預組隊伍過濾: 設置遷移到版本 %s"

L["dialog.reset"] = "重置"
L["dialog.reset.confirm"] = "重置所有字段？"
L["dialog.refresh"] = "搜尋"
L["dialog.expl.simple"] = "勾選選項，輸入最大值和(或)最小值，然後按下搜尋。"
L["dialog.expl.state"] = "隊伍必須包含："
L["dialog.expl.min"] = "最小"
L["dialog.expl.max"] = "最大"
L["dialog.expl.advanced"] = "如果上方的選項不夠用，可以使用進階語法來查詢。"
L["dialog.normal"] = "普通"
L["dialog.heroic"] = "英雄"
L["dialog.mythic"] = "傳奇"
L["dialog.mythicplus"] = "傳奇+"
L["dialog.to"] = "～"
L["dialog.difficulty"] = "難度 ............................"
L["dialog.members"]    = "成員人數 ........................"
L["dialog.tanks"]      = "坦克 ............................"
L["dialog.heals"]      = "治療 ............................"
L["dialog.dps"]        = "輸出 ............................"
L["dialog.mprating"]   = "鑰石評分 ........................"
L["dialog.pvprating"]  = "PVP評級評分 ....................."
L["dialog.defeated"]   = "已擊殺首領(團隊)"
L["dialog.sorting"] = "排序"
L["dialog.usepgf.tooltip"] = "啟用或停用預組隊伍過濾。"
L["dialog.usepgf.usage"] = "為了獲得最大數量的相關結果，請將搜索框與PGF一起使用，因為伺服器返回的結果數量有限。"
L["dialog.usepgf.results.server"] = "伺服器發送的隊伍: |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "被PGF隱藏的隊伍: |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "顯示的隊伍: |cffffffff%d|r"
L["dialog.tooltip.title"] = "進階過濾語法"
L["dialog.tooltip.variable"] = "變數"
L["dialog.tooltip.description"] = "說明"
L["dialog.tooltip.op.logic"] = "邏輯運算符號"
L["dialog.tooltip.op.number"] = "數字運算符號"
L["dialog.tooltip.op.string"] = "文字運算符號"
L["dialog.tooltip.op.func"] = "函數"
L["dialog.tooltip.example"] = "範例"
L["dialog.tooltip.ilvl"] = "需要的裝備等級"
L["dialog.tooltip.myilvl"] = "我的物品等級"
L["dialog.tooltip.hlvl"] = "需要的榮譽等級"
L["dialog.tooltip.pvprating"] = "隊長的PvP評分"
L["dialog.tooltip.mprating"] = "隊長鑰石評分"
L["dialog.tooltip.defeated"] = "已擊殺的首領數量"
L["dialog.tooltip.members"] = "成員人數"
L["dialog.tooltip.tanks"] = "坦克人數"
L["dialog.tooltip.heals"] = "治療人數"
L["dialog.tooltip.dps"] = "傷害輸出人數"
L["dialog.tooltip.partyfit"] = "我的角色職責有空位"
L["dialog.tooltip.classes"] = "指定的職業人數"
L["dialog.tooltip.age"] = "幾分鐘前建立的"
L["dialog.tooltip.voice"] = "有語音"
L["dialog.tooltip.myrealm"] = "隊長和我是同一個伺服器群組"
L["dialog.tooltip.noid"] = "我還沒有進度的副本"
L["dialog.tooltip.matchingid"] = "擊殺過的首領與我相同"
L["dialog.tooltip.seewebsite"] = "請看官方網站"
L["dialog.tooltip.difficulty"] = "難度"
L["dialog.tooltip.raids"] = "選擇指定的團隊"
L["dialog.tooltip.dungeons"] = "選擇指定的地城"
L["dialog.tooltip.timewalking"] = "選擇時空漫遊地下城"
L["dialog.tooltip.arena"] = "選擇指定的競技場類型"
L["dialog.tooltip.warmode"] = "已開啟戰爭模式"
L["dialog.copy.url.keywords"] = "按 CTRL+C 將鏈接複製到關鍵字列表"
L["dialog.filters.group"] = "隊伍"
L["dialog.filters.dungeons"] = "地下城"
L["dialog.filters.advanced"] = "進階過濾表達式"
L["dialog.partyfit"] = "隊伍適配"
L["dialog.partyfit.tooltip"] = "僅顯示仍然有你全部隊伍成員角色職責空位的隊伍。也同時作用在你只有一人時。"
L["dialog.notdeclined"] = "沒被拒絕"
L["dialog.notdeclined.tooltip"] = "隱藏拒絕您的隊伍。 仍然顯示您的申請時限內的隊伍。"
L["dialog.blfit"] = "嗜血/英勇適配"
L["dialog.blfit.tooltip"] = "如果您的隊伍中沒有人有嗜血/英勇，只顯示已經具有嗜血/英勇的隊伍，或者加入後，仍然有一個DPS或奶媽的空位。也同時作用在你只有一人時。"
L["dialog.brfit"] = "戰副適配"
L["dialog.brfit.tooltip"] = "如果您的隊伍中沒有人有戰鬥復活，只顯示已經有戰鬥復活的隊伍，或者加入後，仍然有一個開放的空位。也同時作用在你只有一人時。"
L["dialog.matchingid"] = "匹配ID"
L["dialog.matchingid.tooltip"] = "僅顯示具有與您自己完全相同的副本鎖定ID的團隊。總是顯示所有團隊如果根本沒有鎖定的ID。"

L["settings.dialogMovable.title"] = "可移動的對話框"
L["settings.dialogMovable.tooltip"] = "允許您使用鼠標移動對話框。 右鍵單擊重置位置。"
L["settings.classNamesInTooltip.title"] = "工具提示中的職業名稱"
L["settings.classNamesInTooltip.tooltip"] = "在預組隊伍的工具提示中按角色顯示職業列表。"
L["settings.coloredGroupTexts.title"] = "彩色隊伍名稱"
L["settings.coloredGroupTexts.tooltip"] = "如果隊伍是新的，則以綠色顯示隊伍名稱，如果您之前被拒絕，則以紅色顯示。如果您對該隊伍進行了鎖定，則以紅色顯示活動名稱。"
L["settings.classBar.title"] = "職業顏色條"
L["settings.classBar.tooltip"] = "在預組隊伍列表內的每個玩家角色下方顯示一個職業顏色條"
L["settings.classCircle.title"] = "職業顏色圓圈"
L["settings.classCircle.tooltip"] = "在預組隊伍列表內每個玩家角色背景上顯示一個職業顏色圓圈"
L["settings.leaderCrown.title"] = "顯示隊長標記"
L["settings.leaderCrown.tooltip"] = "在預組地城列表中隊長角色上方顯示一個小皇冠。"
L["settings.ratingInfo.title"] = "隊長評分"
L["settings.ratingInfo.tooltip"] = "在預組列表中顯示隊長的鑰石或PvP評級評分"
L["settings.oneClickSignUp.title"] = "一鍵報名"
L["settings.oneClickSignUp.tooltip"] = "通過單擊直接報名一個隊伍，而不是先選擇以後，然後才單擊報名。"
L["settings.persistSignUpNote.title"] = "存留報名註記"
L["settings.persistSignUpNote.tooltip"] = "在報名不同的隊伍時存留“給隊長的註記”。 預設情況下選擇新隊伍時註記會被刪除。"
L["settings.signupOnEnter.title"] = "使用Enter報名"
L["settings.signupOnEnter.tooltip"] = "報名新隊伍時自動聚焦“給隊長的註記”文字編輯框，並按Enter鍵確認您的申請。"
L["settings.skipSignUpDialog.title"] = "跳過報名對話框"
L["settings.skipSignUpDialog.tooltip"] = "如果可能，跳過角色類型/註記提示並立即報名該隊伍。 按下Shift以始終顯示對話框。"
L["settings.coloredApplications.title"] = "著色申請"
L["settings.coloredApplications.tooltip"] = "如果該隊伍沒有您的角色職責空位，則在傳奇+隊伍的待處理報名申請上顯示紅色背景。"
