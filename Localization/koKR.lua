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

if GetLocale() ~= "koKR" then return end

L["button.ok"] = "OK"
L["error.syntax"] = "|cffff0000필터 표현에 구문 오류|r\n\n이것은 당신의 필터 표현이 올바르게 만들어 지지 않은 걸 의미합니다, 예. 괄호를 빠뜨리거나 'tanks==1' 대신 'tanks=1'이라고 쓴 경우입니다.\n\n자세한 오류 메시지:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000필터 표현에 의미 오류|r\n\n이것은 당신의 필터 표현이 구문은 맞지만, 변수 이름의 철자가 틀린 것 같습니다, 예. tanks 대신 tansk라고 쓴 경우입니다.\n\n자세한 오류 메시지:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000필터 표현에 의미 오류|r\n\n'name', 'comment' 및 'findnumber' 키워드는 더 이상 지원되지 않습니다. 고급 필터 표현식에서 필터를 제거하거나 재설정 버튼을 누르십시오.\n\nBattle for Azeroth Prepatch 로 시작한이 값은 이제 블리자드에 의해 보호되며 더 이상 애드온에서 읽을 수 없습니다.\n\n그룹 목록 위에있는 기본 검색 창을 사용하여 그룹 이름을 필터링하십시오.\n\n자세한 오류 메시지:\n|cffaaaaaa%s|r"

L["dialog.reset"] = "초기화"
L["dialog.refresh"] = "검색"
L["dialog.expl.simple"] = "체크박스를 활성화하고 최소 및/또는 최대를 입력 후 검색을 클릭하세요."
L["dialog.expl.state"] = "파티에 포함되어야 함:"
L["dialog.expl.min"] = "최소"
L["dialog.expl.max"] = "최대"
L["dialog.expl.advanced"] = "위의 옵션이 너무 제한적인 경우, 고급 표현 요청을 시도해보세요."
L["dialog.normal"] = "일반"
L["dialog.heroic"] = "영웅"
L["dialog.mythic"] = "신화"
L["dialog.mythicplus"] = "신화+"
L["dialog.to"] = "~"
L["dialog.difficulty"] = "난이도 .........................."
L["dialog.members"]    = "구성원 .........................."
L["dialog.tanks"]      = "방어 전담 ......................."
L["dialog.heals"]      = "치유 전담 ......................."
L["dialog.dps"]        = "공격 전담 ......................."
L["dialog.ilvl"]       = "아이템 레벨 ....................."
L["dialog.noilvl"] = "또는 아이템 레벨 미지정"
L["dialog.defeated"] = "우두머리 처치 (공격대만)"
L["dialog.usepgf.tooltip"] = "Premade Groups Filter 활성화 또는 비활성화"
L["dialog.tooltip.title"] = "고급 필터 표현"
L["dialog.tooltip.variable"] = "변수"
L["dialog.tooltip.description"] = "설명"
L["dialog.tooltip.op.logic"] = "논리 연산자"
L["dialog.tooltip.op.number"] = "숫자 연산자"
L["dialog.tooltip.op.string"] = "문자열 연산자"
L["dialog.tooltip.op.func"] = "함수"
L["dialog.tooltip.example"] = "예제"
L["dialog.tooltip.ilvl"] = "최소 아이템 레벨"
L["dialog.tooltip.myilvl"] = "내 아이템 레벨"
L["dialog.tooltip.hlvl"] = "최소 명예 레벨"
L["dialog.tooltip.defeated"] = "처치한 공격대 우두머리의 숫자"
L["dialog.tooltip.members"] = "구성원의 숫자"
L["dialog.tooltip.tanks"] = "방어 전담의 숫자"
L["dialog.tooltip.heals"] = "치유 전담의 숫자"
L["dialog.tooltip.dps"] = "공격 전담의 숫자"
L["dialog.tooltip.partyfit"] = "내 그룹 역할을위한 장소가 있습니다"
L["dialog.tooltip.classes"] = "특정 직업의 숫자"
L["dialog.tooltip.age"] = "파티의 생성 시간 (분 단위)"
L["dialog.tooltip.voice"] = "음성 대화 사용"
L["dialog.tooltip.myrealm"] = "같은 서버의 파티/공격대장"
L["dialog.tooltip.noid"] = "귀속되지 않은 인스턴스"
L["dialog.tooltip.matchingid"] = "그 단체는 나 같은 지도자들을 죽였어"
L["dialog.tooltip.seewebsite"] = "웹 사이트를 참조하십시오"
L["dialog.tooltip.difficulty"] = "난이도"
L["dialog.tooltip.raids"] = "특정 공격대만 선택"
L["dialog.tooltip.dungeons"] = "특정 던전 선택"
L["dialog.tooltip.arena"] = "특정 투기장 유형 선택"
L["dialog.tooltip.ex.parentheses"] = "(voice or not voice)"
L["dialog.tooltip.ex.not"] = "not myrealm"
L["dialog.tooltip.ex.and"] = "heroic and hfc"
L["dialog.tooltip.ex.or"] = "normal or heroic"
L["dialog.tooltip.ex.eq"] = "dps == 3"
L["dialog.tooltip.ex.neq"] = "members ~= 0"
L["dialog.tooltip.ex.lt"] = "hlvl >= 5"
L["dialog.tooltip.ex.find"] = "not name:find(\"wts\")"
L["dialog.tooltip.ex.match"] = "name:match(\"+(%d)\")==\"5\""
