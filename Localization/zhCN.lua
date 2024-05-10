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

if GetLocale() ~= "zhCN" then return end

L["addon.name.short"] = "过滤选项"
L["addon.name.long"] = "预创建队伍过滤"

L["error.syntax"] = "|cffff0000过滤语法错误|r\n\n表示过滤语法不正确，例如缺少过滤条件、变量或运算符号，或是写成 'tanks=1' 格式而不是 'tanks==1'。\n\n详细错误信息：\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000过滤语法的语义错误|r\n\n表示过滤语法正确，但是很可能变量名错误，例如写成 tansk 而不是 tanks。\n\n详细错误信息：\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000过滤语法的语义错误|r\n\n不再支持关键字 'name'，'comment' 和 'findnumber'。 请从高级过滤器表达方式中删除他们或者点击重置按钮。\n\n从争霸艾泽拉斯开始，这些都受到暴雪的保护，任何插件都无法读取。\n\n使用列表上方的确认搜索栏过滤队伍副本名称。\n\n详细错误信息：\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "预创建队伍过滤: 不会修复“接口操作因AddOn而失败”错误，因为您似乎没有完全安全的帐户，否则无法创建预制队伍。请参阅插件常见问题解答以获取更多信息以及如何解决此问题。"
L["message.settingsupgraded"] = "预创建队伍过滤: 设置迁移到版本 %s"

L["dialog.reset"] = "重置"
L["dialog.reset.confirm"] = "重置所有字段？"
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
L["dialog.difficulty"] = "难度 .............................."
L["dialog.members"]    = "队伍人数 .........................."
L["dialog.tanks"]      = "坦克 .............................."
L["dialog.heals"]      = "治疗 .............................."
L["dialog.dps"]        = "输出 .............................."
L["dialog.mprating"]   = "钥石评分 .........................."
L["dialog.pvprating"]  = "PVP评级评分 ......................."
L["dialog.defeated"]   = "已击败首领"
L["dialog.sorting"] = "排序"
L["dialog.usepgf.tooltip"] = "启用或停用预创建队伍过滤。"
L["dialog.usepgf.usage"] = "为了获得最大数量的相关结果，请将搜索框与PGF一起使用，因为服务器返回的结果数量有限。"
L["dialog.usepgf.results.server"] = "服务器的队伍: |cffffffff%d|r"
L["dialog.usepgf.results.removed"] = "PGF隐藏的队伍: |cffffffff%d|r"
L["dialog.usepgf.results.displayed"] = "显示的队伍: |cffffffff%d|r"
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
L["dialog.tooltip.pvprating"] = "队长PvP评分"
L["dialog.tooltip.mprating"] = "队长钥石评分"
L["dialog.tooltip.defeated"] = "已击杀的首领数量"
L["dialog.tooltip.members"] = "成员人数"
L["dialog.tooltip.tanks"] = "坦克人数"
L["dialog.tooltip.heals"] = "治疗人数"
L["dialog.tooltip.dps"] = "伤害输出人数"
L["dialog.tooltip.partyfit"] = "团队中我角色的职责有空位"
L["dialog.tooltip.classes"] = "指定职业的人数"
L["dialog.tooltip.age"] = "几分钟前建立的"
L["dialog.tooltip.voice"] = "有无语音"
L["dialog.tooltip.myrealm"] = "队长和我在同一个服务器"
L["dialog.tooltip.noid"] = "我还没有击杀进度的副本"
L["dialog.tooltip.matchingid"] = "该团队击杀首领与我相同"
L["dialog.tooltip.seewebsite"] = "详见官网"
L["dialog.tooltip.difficulty"] = "难度"
L["dialog.tooltip.raids"] = "选择指定的团队副本"
L["dialog.tooltip.dungeons"] = "选择指定的地下城"
L["dialog.tooltip.timewalking"] = "选择时空漫游地下城"
L["dialog.tooltip.arena"] = "选择指定的竞技场类型"
L["dialog.tooltip.warmode"] = "战争模式队伍"
L["dialog.copy.url.keywords"] = "按 CTRL+C 将链接复制到关键字列表"
L["dialog.filters.group"] = "常规筛选项"
L["dialog.filters.dungeons"] = "大秘境副本过滤"
L["dialog.filters.advanced"] = "高级过滤语法"
L["dialog.partyfit"] = "组队申请"
L["dialog.partyfit.tooltip"] = "如果你和朋友想组队申请队伍，请勾选此项。会自动为你过滤出有足够空位的队伍。当然，您独自申请队伍时，亦可保持勾选，无任何影响。"
L["dialog.blfit"] = "嗜血/英勇 筛选"
L["dialog.blfit.tooltip"] = "如果你的队伍中没人拥有嗜血/英勇，则勾选后将帮你过滤出已有嗜血/英勇的队伍；或者你加入后，仍有空位的队伍。当然，您独自申请队伍时，本项仍然适用。"
L["dialog.brfit"] = "战复筛选"
L["dialog.brfit.tooltip"] = "如果你的队伍中没人拥有战复技能，则勾选后将帮你过滤出已有战复能力的队伍；或者你加入后，仍有空位的队伍。当然，您独自申请队伍时，本项仍然适用。"
L["dialog.matchingid"] = "副本进度匹配"
L["dialog.matchingid.tooltip"] = "仅显示和您的副本进度完全匹配的团队。当然，如果您本周还没有击杀任何Boss，则会显示出所有的在建团队。"

L["settings.dialogMovable.title"] = "可移动的对话框"
L["settings.dialogMovable.tooltip"] = "允许您使用鼠标移动对话框。右键单击重置位置。"
L["settings.classNamesInTooltip.title"] = "工具提示中的分类"
L["settings.classNamesInTooltip.tooltip"] = "在预创建队伍的工具提示中按角色职责显示分类列表。"
L["settings.coloredGroupTexts.title"] = "彩色队伍名称和活动"
L["settings.coloredGroupTexts.tooltip"] = "如果队伍是新的，则以绿色显示队伍名称，如果您之前被拒绝，则以红色显示。 如果您对该队伍进行了锁定，则以红色显示活动名称。"
L["settings.classBar.title"] = "职业颜色栏"
L["settings.classBar.tooltip"] = "在预创建队伍列表内的每个玩家角色下方显示一个职业颜色栏"
L["settings.classCircle.title"] = "职业颜色圆圈"
L["settings.classCircle.tooltip"] = "在预创建队伍列表内每个玩家角色背景上显示一个职业颜色圆圈"
L["settings.leaderCrown.title"] = "显示队长标记"
L["settings.leaderCrown.tooltip"] = "在预创建队伍列表中队长角色上方显示一个小皇冠。"
L["settings.ratingInfo.title"] = "队长评分"
L["settings.ratingInfo.tooltip"] = "在预创建队伍列表中显示队长的钥石或PvP评级评分"
L["settings.oneClickSignUp.title"] = "一键申请"
L["settings.oneClickSignUp.tooltip"] = "通过单击直接申请一个队伍，而不是先选择它，然后单击申请。"
L["settings.persistSignUpNote.title"] = "保存申请留言"
L["settings.persistSignUpNote.tooltip"] = "在申请不同的队伍时保存“给队长留言”。默认情况下，选择新队伍时会删除留言。"
L["settings.signupOnEnter.title"] = "使用回车键申请"
L["settings.signupOnEnter.tooltip"] = "申请新队伍时自动添加“给队长留言”文本框，并按回车键确认您的申请。"
L["settings.skipSignUpDialog.title"] = "跳过申请窗口"
L["settings.skipSignUpDialog.tooltip"] = "如果可能，跳过职责选择/给队长留言并立即申请到该组。 按住 shift 以始终显示申请窗口。"
L["settings.coloredApplications.title"] = "彩色申请"
L["settings.coloredApplications.tooltip"] = "在史诗+队伍的待处理申请上显示红色背景，如果该队伍没有剩余的位置供您的角色使用。"
