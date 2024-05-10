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

if GetLocale() ~= "koKR" then return end

L["addon.name.short"] = "PGF"
L["addon.name.long"] = "Premade Groups Filter"

L["error.syntax"] = "|cffff0000필터 표현에 구문 오류|r\n\n이것은 당신의 필터 표현이 올바르게 만들어 지지 않은 걸 의미합니다, 예. 괄호를 빠뜨리거나 'tanks==1' 대신 'tanks=1'이라고 쓴 경우입니다.\n\n자세한 오류 메시지:\n|cffaaaaaa%s|r"
L["error.semantic"] = "|cffff0000필터 표현에 의미 오류|r\n\n이것은 당신의 필터 표현이 구문은 맞지만, 변수 이름의 철자가 틀린 것 같습니다, 예. tanks 대신 tansk라고 쓴 경우입니다.\n\n자세한 오류 메시지:\n|cffaaaaaa%s|r"
L["error.semantic.protected"] = "|cffff0000필터 표현에 의미 오류|r\n\n'name', 'comment' 및 'findnumber' 키워드는 더 이상 지원되지 않습니다. 고급 필터 표현식에서 필터를 제거하거나 재설정 버튼을 누르십시오.\n\nBattle for Azeroth Prepatch 로 시작한이 값은 이제 블리자드에 의해 보호되며 더 이상 애드온에서 읽을 수 없습니다.\n\n그룹 목록 위에있는 기본 검색 창을 사용하여 그룹 이름을 필터링하십시오.\n\n자세한 오류 메시지:\n|cffaaaaaa%s|r"
L["message.noplaystylefix"] = "Premade Groups Filter: Will not apply fix for 'Interface action failed because of an AddOn' errors because you don't seem to have a fully secured account and otherwise can't create premade groups. See addon FAQ for more information and how to fix this issue."
L["message.settingsupgraded"] = "Premade Groups Filter: 버전 %s로 마이그레이션된 설정"

L["dialog.reset"] = "초기화"
L["dialog.reset.confirm"] = "모든 필드를 재설정하시겠습니까?"
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
L["dialog.difficulty"] = "난이도 .............................."
L["dialog.members"]    = "구성원 .............................."
L["dialog.tanks"]      = "방어 전담 ..........................."
L["dialog.heals"]      = "치유 전담 ..........................."
L["dialog.dps"]        = "공격 전담 ..........................."
L["dialog.mprating"]   = "M+ rating"
L["dialog.pvprating"]  = "PVP rating ........................"
L["dialog.defeated"]   = "우두머리 처치 (공격대만)"
L["dialog.sorting"] = "정렬"
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
L["dialog.tooltip.pvprating"] = "그룹 리더의 PvP 등급"
L["dialog.tooltip.mprating"] = "그룹 리더의 신화 플러스 등급"
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
L["dialog.tooltip.timewalking"] = "시간 걷기 던전 선택"
L["dialog.tooltip.arena"] = "특정 투기장 유형 선택"
L["dialog.tooltip.warmode"] = "warmode enabled"
L["dialog.copy.url.keywords"] = "Ctrl+C를 눌러 키워드 목록에 대한 링크 복사"
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

L["settings.dialogMovable.title"] = "대화 상자 이동 가능"
L["settings.dialogMovable.tooltip"] = "마우스로 대화 상자를 이동할 수 있습니다. 마우스 오른쪽 버튼을 클릭하면 위치가 재설정됩니다."
L["settings.classNamesInTooltip.title"] = "툴팁의 클래스 이름"
L["settings.classNamesInTooltip.tooltip"] = "미리 만들어진 그룹의 툴팁에 역할별 클래스 목록을 표시합니다."
L["settings.coloredGroupTexts.title"] = "유색 그룹 이름 및 활동"
L["settings.coloredGroupTexts.tooltip"] = "그룹이 새 그룹이면 녹색으로 그룹 이름을 표시하고 이전에 거부된 적이 있으면 빨간색으로 그룹 이름을 표시합니다. 해당 인스턴스에 잠금이 있는 경우 활동 이름을 빨간색으로 표시합니다."
L["settings.classBar.title"] = "클래스 색상의 바"
L["settings.classBar.tooltip"] = "미리 만들어진 던전 그룹 목록에서 각 역할 아래에 클래스 색상의 작은 막대를 표시합니다."
L["settings.classCircle.title"] = "클래스 색상의 원"
L["settings.classCircle.tooltip"] = "미리 만들어진 던전 그룹 목록에서 각 역할의 배경에 클래스 색상의 원을 표시합니다."
L["settings.leaderCrown.title"] = "그룹 리더 표시"
L["settings.leaderCrown.tooltip"] = "미리 만들어진 던전 그룹 목록에서 그룹 리더의 역할 위에 작은 왕관을 표시합니다."
L["settings.ratingInfo.title"] = "그룹 리더 등급"
L["settings.ratingInfo.tooltip"] = "미리 만들어진 그룹 목록에서 그룹 리더의 Mythic+ 또는 PvP 등급을 표시합니다."
L["settings.oneClickSignUp.title"] = "원 클릭 가입"
L["settings.oneClickSignUp.tooltip"] = "먼저 그룹을 선택한 다음 가입을 클릭하는 대신 클릭하여 직접 그룹에 가입합니다."
L["settings.persistSignUpNote.title"] = "계속 가입 메모"
L["settings.persistSignUpNote.tooltip"] = "다른 그룹에 가입할 때 '그룹 리더에게 메모'를 유지합니다. 기본적으로 새 그룹을 선택하면 메모가 삭제됩니다."
L["settings.signupOnEnter.title"] = "엔터키로 회원가입"
L["settings.signupOnEnter.tooltip"] = "새 그룹에 가입할 때 '그룹 리더 참고 사항' 텍스트 상자에 자동으로 초점을 맞추고 엔터 키를 눌러 신청을 확인합니다."
L["settings.skipSignUpDialog.title"] = "가입 대화상자 건너뛰기"
L["settings.skipSignUpDialog.tooltip"] = "가능한 경우 역할/메모 프롬프트를 건너뛰고 즉시 그룹에 가입하십시오. 항상 대화 상자를 표시하려면 Shift 키를 누르십시오."
