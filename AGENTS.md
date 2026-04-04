# Premade Groups Filter

## Project Overview

Premade Groups Filter is a World of Warcraft addon that enhances the LFG (Looking For Group)
Premade Groups interface by allowing advanced filtering of search results. It supports both
UI-based filtering and powerful Lua expression-based filtering.

## Development Notes

### WoW UI FrameXML
The WoW FrameXML source code should be available in `../WoWUI`, i.e. `LFGList.lua`
can be found in `../WoWUI/AddOns/Blizzard_GroupFinder/Mainline/LFGList.lua`.

If not, request the user to check it out or try an online copy:
* BigWigMods: https://github.com/BigWigsMods/WoWUI
* Townlong Yak: https://www.townlong-yak.com/framexml/live

### WoW API Documentation
The WoW API Documentation can be found in `../WoWUI/AddOns/Blizzard_APIDocumentationGenerated/*`

### WoW Tables
If you need to check the content of WoW tables, you can download and search it
from https://wago.tools/db2/{name}/csv where {name} is the table name. Notable tables:
GroupFinderActivity, GroupFinderActivityGrp, GroupFinderCategory, Map, MapChallengeMode,
MythicPlusSeason, MythicPlusSeasonRewardLevels, MythicPlusSeasonTrackedAffix

### Localization
When creating new translations, always translate them into all locales in ./Localization.

Make sure to use WoW-specific language and spell names,
e.g. in German, players are usually addressed with the polite form "Ihr".

If you need to check for a specific wording, you can download and search GlobalStrings.lua
from https://www.townlong-yak.com/framexml/live/Helix/GlobalStrings.lua/{locale}/get
where {locale} is one of BR, CN, DE, ES, FR, IT, KR, MX, RU, TW (or empty for EN).

### Loading Order
The file loading order is defined in `PremadeGroupsFilter.toc`
and in `PremadeGroupsFilter_Mists.toc` for the Classic version.

### Architecture
Try to keep the architecture free of cycles (files should reference each other).
