local L = LibStub("AceLocale-3.0"):NewLocale("Raiduku", "enUS", true)

-- New features
L["new-feature-autolootandstart"] =
"|cffffe600New feature|r: You can now auto-loot and auto-start loot attribution from bags. Go to |cffffe600/rdk config|r to enable this feature."

-- Commands
L["cmd-configure-desc"] = "Customize the addon settings"
L["cmd-export-desc"] = "Export loot attributions as CSV for |cff1eff00thatsmybis.com|r"
L["cmd-prios-desc"] = "Import loot priorities as CSV from |cff1eff00thatsmybis.com|r"
L["cmd-softres-desc"] = "Import loot softres as CSV from |cff1eff00softres.it|r"
L["toggle-debug-desc"] = "Toggle debug mode"

-- Infos
L["export-data-reminder"] = "You can export loot data for |cff1eff00thatsmybis.com|r using |cffffe600/rdk export|r"
L["saved-for-tmb"] = "Saved for |cff1eff00thatsmybis.com|r that %s received %s for the %s"
L["waiting-for-roll"] = "|cffffffffwaiting for roll...|r"
L["loot-method-is"] = "Loot method is |cff00ddff%s|r"
L["not-in-charge"] = "Loot method is |cff00ddff%s|r but you are |cffffe600not in charge of the loot|r"
L["loot-helper-is"] = "Loot helper is |cff33ff00%s|r"
L["recycler-is"] = "Recycler is |cffff8000%s|r"
L["recycler-is-now"] = "Recycler is now |cffff8000%s|r"
L["change-recycler"] = "The recycler is |cffff8000%s|r. Do you want to change it?"
L["to-change-recycler-run"] = "To change the recycler, run |cffffe600/rdk config|r"
L["cannot-award-to"] = "|cffff0000Cannot award loot to|r %s"
L["prios-saved"] = "prios |cff33ff00saved|r"
L["softres-saved"] = "softres |cff33ff00saved|r"
L["prios-found"] = "prios |cff33ff00found|r"
L["softres-found"] = "softres |cff33ff00found|r"
L["prios-invalid-import"] =
"|cffff0000Invalid import|r: first line is not a valid or supported header from |cff1eff00thatsmybis.com|r"
L["softres-invalid-import"] =
"|cffff0000Invalid import|r: first line is not a valid or supported header from |cff1eff00softres.it|r"
L["loot-later"] = "{rt6} Loot Attribution Later {rt6}"
L["x-come-trade-on-me"] = "%s ==> TRADE on me"
L["x-will-recycle-x"] = "%s will recycle %s"
L["removed-x-from-prios-for-x"] = "Removed %s from your imported prios for %s"
L["trade-back-loot-history"] = "%s gave you back %s. How do you want to update loot history?"
L["removed-data-from-x-dates"] = "Removed data from the following dates: %s"

-- Labels
L["configuration"] = "Configuration"
L["prios-paste-and-override"] = "Paste and override prios:"
L["softres-paste-and-override"] = "Paste and override prios:"
L["prios-import"] = "Import prios from |cff1eff00thatsmybis.com|r"
L["softres-import"] = "Import softres from |cff1eff00softres.it|r"
L["copy-following-data"] = "Copy the following data:"
L["managing-loots"] = "Managing loots"
L["open-recycler-popup-reminder"] = "Display popup reminder to update recycler"
L["choose-dates"] = "Choose one or multiple dates:"
L["choose-recycler"] = "Choose a recycler for unwanted loots (non-BoE):"
L["auto-award-common"] = "Auto-award |cff1eff00Common|r"
L["auto-award-rare"] = "Auto-award |cff0070ddRare|r"
L["import-and-override"] = "Import and override"
L["remove-all"] = "Remove all"
L["delete-selected-dates"] = "Delete selected dates"
L["x-dates-selected"] = "%s date(s) selected"
L["activate-soft-prio"] = "Activate a soft-prio mode (use prios from TMB as softres)"
L["reverse-roll-order"] = "Reverse roll order (1 becomes the strongest)"
L["auto-loot-and-start"] = "Auto-loot items and start attribution from bags"

-- Buttons
L["now"] = "Now"
L["later"] = "Later"
L["ask-for-rolls"] = "Ask for rolls"
L["award-loot"] = "Award loot"
L["recycle-loot"] = "Recycle loot"
L["award-prio"] = "Award prio"
L["award-softres"] = "Award softres"
L["remove-record"] = "Remove record"
L["remove-last-player"] = "Remove last player"
L["change-award-ownership-to-me"] = "Change award ownership to me"

-- Wording
L["yes"] = "Yes"
L["no"] = "No"
L["main-spec"] = "main spec"
L["off-spec"] = "off spec"
L["auto-awarding"] = "Auto-awarding"
L["enabled"] = "enabled"
L["disabled"] = "disabled"
L["auto-win"] = "|cFF00FF00(Auto-win)|r"
L["auto-pass"] = "|cff9C9C9C(Auto-pass)|r"

-- Table Columns
L["player"] = "Player"
L["prio"] = "Prio"
L["spec"] = "Spec"
L["roll"] = "Roll"
L["looted"] = "Looted"
