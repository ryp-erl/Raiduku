Raiduku = Raiduku or LibStub("AceAddon-3.0"):NewAddon("Raiduku", "AceConsole-3.0", "AceEvent-3.0")
Raiduku.L = Raiduku.L or LibStub("AceLocale-3.0"):GetLocale("Raiduku")
Raiduku.AceGUI = Raiduku.AceGUI or LibStub("AceGUI-3.0")
Raiduku.ST = Raiduku.ST or LibStub("ScrollingTable");

Raiduku.name = "Raiduku"
Raiduku.version = "2.0.0+wotlkc"

Raiduku.Constants = Raiduku.Constants or {
    ["LOOT_MODE_ROLL"] = 1,
    ["LOOT_MODE_PRIO"] = 2,
    ["LOOT_MODE_SOFTPRIO"] = 3,
    ["LOOT_MODE_SOFTRES"] = 4,
}
Raiduku.ItemBindType = Raiduku.ItemBindType or {
    ["BIND_WHEN_PICKED_UP"] = 1,
    ["BIND_WHEN_EQUIPPED"] = 2,
}

--[[
    Initializing the addon using Ace3.
    It includes options, commands, saved variables and basic events to register to.
--]]

Raiduku.defaults = {
    profile = {
        loot = {},
        prios = {},
        softres = {},
        lastImport = {},
        lastRecycler = nil,
        autoAwardCommon = true,
        autoAwardRare = true,
        recyclerReminder = false,
        reverseRollOrder = false,
        enableSoftPrios = false,
        interface = {}
    }
}

Raiduku.options = {
    name = "Raiduku",
    handler = Raiduku,
    type = "group",
    args = {
        config = {
            type = "execute",
            name = "Configuration",
            desc = Raiduku.L["cmd-configure-desc"],
            func = "DrawConfigurationWindow"
        },
        export = {
            type = "execute",
            name = "Export",
            desc = Raiduku.L["cmd-export-desc"],
            func = "DrawExportWindow"
        },
        prios = {
            type = "execute",
            name = "Prios",
            desc = Raiduku.L["cmd-prios-desc"],
            func = "ImportPrios"
        },
        softres = {
            type = "execute",
            name = "SoftRes",
            desc = Raiduku.L["cmd-softres-desc"],
            func = "ImportSoftRes"
        }
    }
}

function Raiduku:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("RaidukuLootDB", Raiduku.defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("Raiduku", Raiduku.options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Raiduku", "Raiduku")
    self:RegisterChatCommand("Raiduku", "ChatCommand")
    self:RegisterChatCommand("rdk", "ChatCommand")

    Raiduku.recycler = UnitName("player")

    if Raiduku.db.profile.lastRecycler ~= nil then
        local raiders = Raiduku:GetRaiders()
        for index, name in ipairs(raiders) do
            if name == Raiduku.db.profile.lastRecycler then
                Raiduku.recycler = Raiduku:GetRaiders()[index]
                break
            end
        end
    end
    Raiduku.db.profile.loot.linked = nil
    Raiduku.db.profile.loot.onBoss = {}
    Raiduku.db.profile.loot.inBags = {}
    Raiduku.db.profile.loot.toTrade = {}

    -- Raiduku.db.profile.loot.linked = Raiduku.db.profile.loot.linked or nil
    -- Raiduku.db.profile.loot.onBoss = Raiduku.db.profile.loot.onBoss or {}
    -- Raiduku.db.profile.loot.inBags = Raiduku.db.profile.loot.inBags or {}
    -- Raiduku.db.profile.loot.toTrade = Raiduku.db.profile.loot.toTrade or {}

    Raiduku.LootLinked = Raiduku.db.profile.loot.linked
    Raiduku.LootsOnBoss = Raiduku.db.profile.loot.onBoss
    Raiduku.LootsInBags = Raiduku.db.profile.loot.inBags
    Raiduku.LootsToTrade = Raiduku.db.profile.loot.toTrade

    local attributedItems = {}
    local currentDate = self:GetCurrentDate()
    if Raiduku.db.profile.loot[currentDate] then
        for _, csvRow in next, Raiduku.db.profile.loot[currentDate] do
            local name = select(1, strsplit(",", csvRow))
            local itemId = select(3, strsplit(",", csvRow))
            local itemLink = select(2, GetItemInfo(itemId))
            if name ~= UnitName("player") then
                attributedItems[itemLink] = true
            end
        end
    end
    local yesterdayDate = Raiduku:GetYesterdayDate()
    if Raiduku.db.profile.loot[yesterdayDate] then
        for _, csvRow in next, Raiduku.db.profile.loot[yesterdayDate] do
            local name = select(1, strsplit(",", csvRow))
            local itemId = select(3, strsplit(",", csvRow))
            local itemLink = select(2, GetItemInfo(itemId))
            if name ~= UnitName("player") then
                attributedItems[itemLink] = true
            end
        end
    end

    local tradeableItems = Raiduku:GetTradeableItems()
    for itemLink in next, tradeableItems do
        if attributedItems[itemLink] then
            Raiduku.LootsToTrade[itemLink] = {}
        else
            if not Raiduku.LootsInBags[itemLink] then
                Raiduku.LootsInBags[itemLink] = {}
            end
        end
    end

    Raiduku:DebugLoots()
end

function Raiduku:OnEnable()
    self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
    self:RegisterEvent("UPDATE_INSTANCE_INFO")
    self:UpdateMainLooter()
    self:UpdateInstanceInfo()
end

function Raiduku:OnDisable()
end

--[[
    Events
--]]

function Raiduku:PARTY_LOOT_METHOD_CHANGED()
    self:UpdateMainLooter()
end

function Raiduku:UPDATE_INSTANCE_INFO()
    local wasInDungeon = Raiduku.isInDungeon
    self:UpdateInstanceInfo()
    if wasInDungeon and not Raiduku.isInDungeon then
        self:Print(Raiduku.L["export-data-reminder"])
    end
end

--[[
    Commands
--]]

function Raiduku:ChatCommand(input)
    LibStub("AceConfigCmd-3.0").HandleCommand(Raiduku, "rdk", "Raiduku", input)
end

function Raiduku:ImportPrios()
    local frame, importBox, importButton, removeAllButton = Raiduku:DrawImportBox(Raiduku.L["prios-import"],
        Raiduku.L["prios-paste-and-override"], Raiduku.L["prios-invalid-import"], Raiduku.L["prios-found"],
        self.db.profile.lastImport.prios, Raiduku.TMB.ParsePrios)
    if self.db.profile.lastImport.prios then
        local status = self.name .. " - " .. self.version
        status = status .. " :: |cffffffff" .. self.db.profile.lastImport.prios .. "|r :: |cff33ff00" ..
            Raiduku:GetNumPrios() .. " prios|r"
        frame:SetStatusText(status)
        if Raiduku:GetNumPrios() == 0 then
            removeAllButton:SetDisabled(true)
        else
            removeAllButton:SetDisabled(false)
        end
    end
    importButton:SetCallback("OnClick", function()
        local valid, prios, numPrios = Raiduku.TMB:ParsePrios(importBox.pasted)
        if not valid then
            self:Print(Raiduku.L["prios-invalid-import"])
        else
            self.db.profile.prios = prios
            self.db.profile.lastImport.prios = self:GetCurrentDateTime()
            local status = self.name .. " - " .. self.version
            status = status .. " :: |cffffffff" .. self.db.profile.lastImport.prios .. "|r :: |cff33ff00" ..
                Raiduku:GetNumPrios() .. " prios|r"
            frame:SetStatusText(status)
            if Raiduku:GetNumPrios() == 0 then
                removeAllButton:SetDisabled(true)
            else
                removeAllButton:SetDisabled(false)
            end
            self:Print(numPrios .. " " .. Raiduku.L["prios-saved"])
        end
    end)
    removeAllButton:SetCallback("OnClick", function()
        self.db.profile.prios = {}
        importBox:SetText("")
        importBox.pasted = nil
        local status = self.name .. " - " .. self.version
        status = status .. " :: |cffffffff" .. self.db.profile.lastImport.prios .. "|r :: |cff33ff00" ..
            Raiduku:GetNumPrios() .. " prios|r"
        frame:SetStatusText(status)
        removeAllButton:SetDisabled(true)
    end)
end

function Raiduku:ImportSoftRes()
    local frame, importBox, importButton, removeAllButton = Raiduku:DrawImportBox(Raiduku.L["softres-import"],
        Raiduku.L["softres-paste-and-override"], Raiduku.L["softres-invalid-import"], Raiduku.L["softres-found"],
        self.db.profile.lastImport.softres, Raiduku.SoftRes.Parse)
    if self.db.profile.lastImport.softres then
        local status = self.name .. " - " .. self.version
        status = status .. " :: |cffffffff" .. self.db.profile.lastImport.softres .. "|r :: |cff33ff00" ..
            Raiduku:GetNumSoftRes() .. " softres|r"
        frame:SetStatusText(status)
        if Raiduku:GetNumSoftRes() == 0 then
            removeAllButton:SetDisabled(true)
        else
            removeAllButton:SetDisabled(false)
        end
    end
    importButton:SetCallback("OnClick", function()
        local valid, softres, numSoftres = Raiduku.SoftRes:Parse(importBox.pasted)
        if not valid then
            self:Print(Raiduku.L["softres-invalid-import"])
        else
            self.db.profile.softres = softres
            self.db.profile.lastImport.softres = self:GetCurrentDateTime()
            local status = self.name .. " - " .. self.version
            status = status .. " :: |cffffffff" .. self.db.profile.lastImport.softres .. "|r :: |cff33ff00" ..
                Raiduku:GetNumSoftRes() .. " softres|r"
            frame:SetStatusText(status)
            if Raiduku:GetNumSoftRes() == 0 then
                removeAllButton:SetDisabled(true)
            else
                removeAllButton:SetDisabled(false)
            end
            self:Print(numSoftres .. " " .. Raiduku.L["softres-saved"])
        end
    end)
    removeAllButton:SetCallback("OnClick", function()
        self.db.profile.softres = {}
        importBox:SetText("")
        importBox.pasted = nil
        local status = self.name .. " - " .. self.version
        status = status .. " :: |cffffffff" .. self.db.profile.lastImport.softres .. "|r :: |cff33ff00" ..
            Raiduku:GetNumSoftRes() .. " softres|r"
        frame:SetStatusText(status)
        removeAllButton:SetDisabled(true)
    end)
end

--[[
    Core functions
--]]

function Raiduku:UpdateInstanceInfo()
    local type = select(2, GetInstanceInfo())
    Raiduku.isInDungeon = type == "party" or type == "raid"
end

function Raiduku:UpdateMainLooter()
    local method, mainLooter = GetLootMethod()
    Raiduku.isML = 0 == mainLooter
    if Raiduku.isML and method == "master" then
        self:RegisterEvent("CHAT_MSG_RAID")
        self:RegisterEvent("CHAT_MSG_RAID_LEADER")
        self:RegisterEvent("CHAT_MSG_RAID_WARNING")
        self:RegisterEvent("CHAT_MSG_PARTY")
        self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
        self:RegisterEvent("CHAT_MSG_SYSTEM")
        self:RegisterEvent("CHAT_MSG_LOOT")
        self:RegisterEvent("LOOT_OPENED")
        self:RegisterEvent("LOOT_CLOSED")
        self:RegisterEvent("TRADE_SHOW")
        self:Print(Raiduku.L["loot-method-is"]:format(method))
        self:Print(Raiduku.L["loot-helper-is"]:format("|cff33ff00" .. Raiduku.L["enabled"] .. "|r"))
        self:Print(Raiduku.L["recycler-is"]:format(Raiduku.recycler))
        self:Print(Raiduku.L["to-change-recycler-run"])
        if Raiduku.db.profile.recyclerReminder then
            StaticPopup_Show("RDK_CONFIRM_RECYCLER", Raiduku.recycler)
        end
    else
        self:UnregisterEvent("CHAT_MSG_RAID")
        self:UnregisterEvent("CHAT_MSG_RAID_LEADER")
        self:UnregisterEvent("CHAT_MSG_RAID_WARNING")
        self:RegisterEvent("CHAT_MSG_PARTY")
        self:RegisterEvent("CHAT_MSG_PARTY_LEADER")
        self:UnregisterEvent("CHAT_MSG_SYSTEM")
        self:RegisterEvent("CHAT_MSG_LOOT")
        self:UnregisterEvent("LOOT_OPENED")
        self:UnregisterEvent("LOOT_CLOSED")
        self:RegisterEvent("TRADE_SHOW")
        if method == "master" then
            self:Print(Raiduku.L["not-in-charge"]:format(method))
        else
            self:Print(Raiduku.L["loot-method-is"]:format(method))
        end
        self:Print(Raiduku.L["loot-helper-is"]:format("|cffff0000" .. Raiduku.L["disabled"] .. "|r"))
    end
end

function Raiduku:GetNumPrios()
    local numPrios = 0
    for itemId, _ in pairs(self.db.profile.prios) do
        for _, _ in pairs(self.db.profile.prios[itemId]) do
            numPrios = numPrios + 1
        end
    end
    return numPrios
end

function Raiduku:GetNumSoftRes()
    local numSoftRes = 0
    for itemId, _ in pairs(self.db.profile.softres) do
        for _, _ in pairs(self.db.profile.softres[itemId]) do
            numSoftRes = numSoftRes + 1
        end
    end
    return numSoftRes
end

function Raiduku:GetTableSize(table)
    local count = 0
    for _ in next, table do
        count = count + 1
    end
    return count
end

function Raiduku:GetCurrentDate()
    return date("%F")
end

function Raiduku:GetYesterdayDate()
    return date("%F", time() - 24 * 60 * 60)
end

function Raiduku:GetCurrentDateTime()
    local now = C_DateAndTime.GetCurrentCalendarTime()
    return date("%F") .. format(" %02d:%02d", now.hour, now.minute)
end

function Raiduku:GetColorByClass(class)
    for engClass, classColor in pairs(RAID_CLASS_COLORS) do
        if engClass:upper() == class:upper() then
            return classColor.colorStr:sub(3):upper()
        end
    end
    return "ffffff"
end

function Raiduku:GetRaiders()
    local raiders = {}
    for i = 1, GetNumGroupMembers() do
        local name, online = select(1, GetRaidRosterInfo(i)), select(8, GetRaidRosterInfo(i))
        if online then
            tinsert(raiders, name)
        end
    end
    return raiders
end

function Raiduku:GetPlayerName(playerFullName)
    local realmSeparatorPosition = string.find(playerFullName, "-")
    return string.sub(playerFullName, 0, realmSeparatorPosition - 1)
end

function Raiduku:GetContainerNumSlots(bagId)
    local getContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)
    return getContainerNumSlots(bagId)
end

function Raiduku:GetContainerItemInfo(bagId, slotId)
    local getContainerItemInfo = GetContainerItemInfo or (C_Container and C_Container.GetContainerItemInfo)
    return getContainerItemInfo(bagId, slotId)
end

function Raiduku:UseContainerItem(containerIndex, slotIndex, unitToken, reagentBankOpen)
    local useContainerItem = UseContainerItem or (C_Container and C_Container.UseContainerItem)
    return useContainerItem(containerIndex, slotIndex, unitToken, reagentBankOpen)
end

function Raiduku:GetContainerPosition(itemId)
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, Raiduku:GetContainerNumSlots(bag) do
            local currentItemId = select(10, Raiduku:GetContainerItemInfo(bag, slot))
            if currentItemId == tonumber(itemId) then
                return bag, slot
            end
        end
    end
    return nil, nil
end

function Raiduku:GetBagItemIds()
    local itemIds = {}
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, Raiduku:GetContainerNumSlots(bag) do
            local itemId = select(10, Raiduku:GetContainerItemInfo(bag, slot))
            if itemId then
                itemIds[itemId] = true
            end
        end
    end
    return itemIds
end

function Raiduku:HasItemInBags(itemId)
    local bagId, slot = Raiduku:GetContainerPosition(itemId)
    return bagId ~= nil and slot ~= nil
end

function Raiduku:GetGroupUnitType()
    return IsInRaid() and "raid" or "party"
end

function Raiduku:GetChatType()
    return IsInRaid() and "RAID" or "PARTY"
end

function Raiduku:GetWarningChatType()
    if not IsInRaid() then
        return "PARTY"
    else
        local rank = select(2, GetRaidRosterInfo(1))
        return rank > 0 and "RAID_WARNING" or "RAID"
    end
end

function Raiduku:NewTimer(seconds, callback)
    return C_Timer.NewTimer(seconds, callback) or C_Timer.NewTicker(seconds, callback, 1)
end

function Raiduku:IsTradeable(item)
    local itemId = tonumber(item)
    local itemLink = nil
    if itemId then
        itemLink = select(2, GetItemInfo(item))
    else
        itemLink = item
    end
    if itemLink then
        local tradeableItems = Raiduku:GetTradeableItems()
        return tradeableItems[itemLink]
    end
end

function Raiduku:GetTradeableItems()
    local tradeableItems = {}
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, Raiduku:GetContainerNumSlots(bag) do
            local _, itemLink, remainingTime = Raiduku:GetRemainingTime(bag, slot)
            if itemLink and remainingTime then
                tradeableItems[itemLink] = true
            end
        end
    end
    return tradeableItems
end

-- From VoraciousGhost Weak Aura: https://wago.io/TradeableLootTimers
-- Updated to work with Phase 2 API Changes
function Raiduku:GetRemainingTime(bagID, slot)
    local tooltip_name = "Raiduku_Tooltip_Scanner_" .. bagID .. "_" .. slot
    local tip = _G[tooltip_name]
    if not tip then
        tip = CreateFrame("GameTooltip", tooltip_name, nil, "GameTooltipTemplate")
        tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local time_formats = {
        [INT_SPELL_DURATION_HOURS] = 60 * 60,
        [INT_SPELL_DURATION_MIN] = 60,
        [INT_SPELL_DURATION_SEC] = 1
    }

    local time_lookup = {}
    for pattern, coefficient in pairs(time_formats) do
        local prefix = ""
        pattern = pattern:gsub("%%d(%s?)", function(s)
            prefix = "(%d+)" .. s
            return ""
        end)

        pattern = pattern:gsub("|4", ""):gsub("[:;]", " ")

        for s in pattern:gmatch("(%S+)") do
            time_lookup[prefix .. s] = coefficient
        end
    end

    local needle = BIND_TRADE_TIME_REMAINING:gsub("%%s", ".*")
    local containerInfo = Raiduku:GetContainerItemInfo(bagID, slot)
    if containerInfo then
        local icon, quality, itemLink = containerInfo.iconFileID, containerInfo.quality, containerInfo.hyperlink
        if quality and quality >= 3 then
            tip:ClearLines()
            tip:SetBagItem(bagID, slot)
            local text
            for i = tip:NumLines(), 1, -1 do
                local left = _G[tooltip_name .. "TextLeft" .. i]
                if left then
                    text = left:GetText() or ""
                    if text:find(needle) then
                        break
                    else
                        text = nil
                    end
                end
            end
            if text then
                local r = 0
                for pattern, coefficient in pairs(time_lookup) do
                    local n = text:match(pattern)
                    if n then
                        r = r + n * coefficient
                    end
                end
                return icon, itemLink, r
            end
        end
    end
end
