# Checklist for new content

## General

- [ ] Check for Blizzard API changes
  - https://github.com/Stanzilla/WoWUIBugs/wiki/
  - https://wowpedia.fandom.com/wiki/Patch_10.0.0/API_changes
  - https://github.com/tomrus88/BlizzardInterfaceCode
  - https://www.townlong-yak.com/framexml/live

- [ ] Bump TOC and version: [PremadeGroupsFilter.toc#L1-L3](https://github.com/0xbs/premade-groups-filter/blob/622fd4d726eef720c35603aa7ef5ed15cf0d7355/PremadeGroupsFilter.toc#L1-L3)
  - Also see e.g. [DBM-Core](https://github.com/DeadlyBossMods/DBM-Unified/blob/master/DBM-Core/DBM-Core.toc#L1)

- [ ] Update copyright year in all files

## New dungeons and raids

- [ ] Add new keywords and remove obsolete keywords: [Main.lua#L515](https://github.com/0xbs/premade-groups-filter/blob/622fd4d726eef720c35603aa7ef5ed15cf0d7355/Main.lua#L515)
  - https://wow.tools/dbc/?dbc=groupfinderactivity

- [ ] Add difficulty mapping: [Difficulty.lua#L278-L285](https://github.com/0xbs/premade-groups-filter/blob/622fd4d726eef720c35603aa7ef5ed15cf0d7355/Modules/Difficulty.lua#L278-L285)

- [ ] Add/update expansion filter: [Main.lua#L519-L522](https://github.com/0xbs/premade-groups-filter/blob/622fd4d726eef720c35603aa7ef5ed15cf0d7355/Main.lua#L519-L522)

- [ ] Update mapping of mapID to activityID for Mythic Plus dungeons: [PlayerInfo.lua#L30-L42](https://github.com/0xbs/premade-groups-filter/blob/622fd4d726eef720c35603aa7ef5ed15cf0d7355/Modules/PlayerInfo.lua#L30-L42)
  - https://wow.tools/dbc/?dbc=mapchallengemode

- [ ] Update code related to FixGetPlaystyleString
  1. Check if the fix is still relevant.
  2. Update activity ID of mythic plus dungeon to test against: [FixGetPlaystyleString.lua#L49](https://github.com/0xbs/premade-groups-filter/blob/ce3da3c7832ea92b78d51fe324d729e7f58606a7/FixGetPlaystyleString.lua#L49)

- [ ] Update info tooltip

- [ ] Add Raider.IO synonyms: [Main.lua#L546-L556](https://github.com/0xbs/premade-groups-filter/blob/622fd4d726eef720c35603aa7ef5ed15cf0d7355/Main.lua#L546-L556)
