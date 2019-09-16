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

if GetLocale() ~= "zhCN" then return end

L["button.ok"] = "确定"
L["error.syntax"] = "|cffff0000过滤语法错误|r\n\n表示过滤语法不正确，例如缺少过滤条件、变量或运算符号，或是写成 'tanks=1' 格式而不是 'tanks==1'。\n\n详细错误信息：\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000过滤语法的语义错误|r\n\n表示过滤语法正确，但是很可能变量名错误，例如写成 tansk 而不是 tanks。\n\n详细错误信息：\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000过滤语法的语义错误|r\n\n不再支持关键字 'name'，'comment' 和 'findnumber'。 請從高級過濾器表達式中刪除它們或按重置按鈕。\n\n從戰鬥艾澤拉斯準備開始，這些價值現在受到暴雪的保護，任何插件都無法讀取。\n\n使用組列表上方的默認搜索欄過濾組名稱。\n\n詳細錯誤訊息：\n|cffaaaaaa%s|r"

L["dialog.reset"] = "重置"
L["dialog.refresh"] = "搜索"
L["dialog.expl.simple"] = "勾选选项，输入最大值和(或)最小值，然后点击搜索按钮。"
L["dialog.expl.state"] = "队伍必须包含："
L["dialog.expl.min"] = "最小"
L["dialog.expl.max"] = "最大"
L["dialog.expl.advanced"] = "如果上方的选项不够用，可以使用高级语法来查询。"
L["dialog.normal"] = "普通"
L["dialog.heroic"] = "英雄"
L["dialog.mythic"] = "史诗"
L["dialog.mythicplus"] = "史诗+"
L["dialog.to"] = "～"
L["dialog.difficulty"] = "难度 ............................"
L["dialog.members"]    = "队伍人数 ........................"
L["dialog.tanks"]      = "坦克 ............................"
L["dialog.heals"]      = "治疗 ............................"
L["dialog.dps"]        = "输出 ............................"
L["dialog.ilvl"]       = "装备等级 ........................"
L["dialog.noilvl"] = "或不指定裝等"
L["dialog.defeated"] = "已击杀首领(仅限团队)"
L["dialog.usepgf.tooltip"] = "启用或停用预创建队伍过滤"
L["dialog.tooltip.title"] = "高级过滤语法"
L["dialog.tooltip.variable"] = "变量"
L["dialog.tooltip.description"] = "说明"
L["dialog.tooltip.op.logic"] = "逻辑运算符号"
L["dialog.tooltip.op.number"] = "数字运算符号"
L["dialog.tooltip.op.string"] = "文字运算符号"
L["dialog.tooltip.op.func"] = "函数"
L["dialog.tooltip.example"] = "例子"
L["dialog.tooltip.ilvl"] = "需要的装备等级"
L["dialog.tooltip.myilvl"] = "我的物品等级"
L["dialog.tooltip.hlvl"] = "需要的荣誉等级"
L["dialog.tooltip.defeated"] = "已击杀的首领数量"
L["dialog.tooltip.members"] = "成员人数"
L["dialog.tooltip.tanks"] = "坦克人数"
L["dialog.tooltip.heals"] = "治疗人数"
L["dialog.tooltip.dps"] = "伤害输出人数"
L["dialog.tooltip.partyfit"] = "我的团队角色有一席之地"
L["dialog.tooltip.classes"] = "指定职业的人数"
L["dialog.tooltip.age"] = "几分钟前建立的"
L["dialog.tooltip.voice"] = "有无语音"
L["dialog.tooltip.myrealm"] = "队长和我在同一个服务器"
L["dialog.tooltip.noid"] = "我还没有击杀进度的副本"
L["dialog.tooltip.matchingid"] = "该团队击杀首领与我相同"
L["dialog.tooltip.seewebsite"] = "详见网页"
L["dialog.tooltip.difficulty"] = "难度"
L["dialog.tooltip.raids"] = "选择指定的团队副本"
L["dialog.tooltip.dungeons"] = "选择指定的地下城"
L["dialog.tooltip.arena"] = "选择指定的竞技场类型"
L["dialog.tooltip.ex.parentheses"] = "（voice or not voice）"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""

L["PGF"] = "过滤选项"
L["Premade Groups Filter"] = "预创建队伍过滤"
