Raiduku.LootWindow = Raiduku:DrawLootWindow()
Raiduku.LootMode = Raiduku.Constants.LOOT_MODE_ROLL
Raiduku.RollLootST = Raiduku.RollLootST or {}
Raiduku.Players = {}
Raiduku.SoftResList = {}
Raiduku.LootItemTypes = {
    ["Weapon"] = 2,
    ["Armor"] = 4,
    ["Recipe"] = 9,
    ["Miscellaneous"] = 15
}
Raiduku.LootItemSpecials = {
    [32385] = true,
    [34845] = true
}
Raiduku.LootItemIgnoreList = {
    -- Badge of Justice
    [29434] = true,
    -- Legendaries from TK
    [30316] = true,
    [30313] = true,
    [30318] = true,
    [30319] = true,
    [30320] = true,
    [30312] = true,
    [30311] = true,
    [30317] = true
}
Raiduku.LootItemResources = {
    -- LK Phase 2 Runed Orb
    [45087] = true,
    -- BC Phase 3 Epic Gems
    [32227] = true,
    [32231] = true,
    [32229] = true,
    [32230] = true,
    [32249] = true,
    [32228] = true,
    -- Mark of the Illidari
    [32897] = true,
    -- Heart of Darkness
    [32428] = true,
    -- Sunmote
    [34664] = true
}

--[[
    Local functions
--]]

local function resetAll()
    Raiduku.Players = {}
    Raiduku.SoftResList = {}
    Raiduku.RollLootST:ClearSelection()
    Raiduku.RollLootST:SetData({}, true)
    Raiduku.RollLootST:Hide()
    Raiduku.LootWindow.title:SetText(nil)
    Raiduku.LootWindow.image:SetNormalTexture("")
    Raiduku.LootWindow.image:SetPushedTexture("")
    Raiduku.LootWindow.startButton:Show()
    Raiduku.LootWindow.laterButton:Show()
    Raiduku.LootWindow.rollsButton:Hide()
    Raiduku.LootWindow.winnerButton:Hide()
    Raiduku.LootWindow.recycleButton:Hide()
    Raiduku.LootWindow:Hide()
end

local function startNextLootInBags()
    Raiduku:NewTimer(0.2, function()
        if Raiduku:GetTableSize(Raiduku.LootsInBags) > 0 then
            local itemLink = next(Raiduku.LootsInBags)
            SendChatMessage(itemLink, Raiduku:GetWarningChatType(), nil, nil)
        end
    end)
end

local function startNextLootOnBoss()
    Raiduku:NewTimer(0.2, function()
        if Raiduku:GetTableSize(Raiduku.LootsOnBoss) > 0 then
            local itemLink = next(Raiduku.LootsOnBoss)
            SendChatMessage(itemLink, Raiduku:GetWarningChatType(), nil, nil)
        end
    end)
end

local function startNextLoot(onBoss, inBags)
    if onBoss and Raiduku:GetTableSize(Raiduku.LootsOnBoss) > 0 then
        Raiduku.Players = {}
        Raiduku.RollLootST:ClearSelection()
        Raiduku.RollLootST:SetData({}, true)
        startNextLootOnBoss()
    elseif inBags and Raiduku:GetTableSize(Raiduku.LootsInBags) > 0 then
        Raiduku.Players = {}
        Raiduku.RollLootST:ClearSelection()
        Raiduku.RollLootST:SetData({}, true)
        startNextLootInBags()
    else
        resetAll()
    end
    Raiduku.RollLootST:ClearSelection()
    Raiduku.RollLootST:SetData({}, true)
    Raiduku.LootLinked = nil
end

local function updateIcon(itemId)
    local itemIcon = GetItemIcon(itemId)
    Raiduku.LootWindow.image:SetNormalTexture(itemIcon)
    Raiduku.LootWindow.image:SetPushedTexture(itemIcon)
    Raiduku.LootWindow.image:SetScript("OnEnter", function()
        local itemLink = select(2, GetItemInfo(itemId))
        GameTooltip:SetOwner(Raiduku.LootWindow, "ANCHOR_CURSOR")
        GameTooltip:SetHyperlink(itemLink)
        GameTooltip:Show()
    end)
    Raiduku.LootWindow.image:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

local function displaySoftResInfo()
    SendChatMessage("{rt2} SoftRes {rt2}", Raiduku:GetChatType(), nil, nil)
    local raiders = {}
    for i = 1, GetNumGroupMembers() do
        local raiderName = GetRaidRosterInfo(i)
        raiders[raiderName] = true
    end
    for _, player in ipairs(Raiduku.SoftResList) do
        if raiders[player.name] then
            SendChatMessage(player.name, Raiduku:GetChatType(), nil, nil)
            Raiduku:AddOrUpdatePlayer(player.name, player.class, 1)
        end
    end
    Raiduku:UpdatePlusRollResults()
end

local function getLootLinkedData()
    if Raiduku.LootsOnBoss[Raiduku.LootLinked] and #Raiduku.LootsOnBoss[Raiduku.LootLinked] > 0 then
        return Raiduku.LootsOnBoss[Raiduku.LootLinked]
    end
    if Raiduku.LootsInBags[Raiduku.LootLinked] and #Raiduku.LootsInBags[Raiduku.LootLinked] > 0 then
        return Raiduku.LootsInBags[Raiduku.LootLinked]
    end
    return {}
end

local function lootLinkedHandler(...)
    Raiduku:DebugLoots()
    local text, name = ...
    local itemId = text:match("|Hitem:(%d+):")
    local playerName = UnitName("player")
    name = strsplit("-", name)
    if name == playerName and itemId and not (text:find("GG") or text:find("{rt%d}")) then
        local _, itemLink, itemRarity = GetItemInfo(itemId)
        local itemBindType = select(14, GetItemInfo(itemId))
        if itemRarity >= 3 and Raiduku.LootItemIgnoreList[tonumber(itemId)] == nil then
            Raiduku.LootLinked = itemLink
            -- after a reload or getting disconnected we might lose the info of items in bags
            -- so if an item linked is not found in any list, we add it to loots in bags
            if not Raiduku.LootsOnBoss[Raiduku.LootLinked] and not Raiduku.LootsInBags[Raiduku.LootLinked] then
                Raiduku.LootsInBags[Raiduku.LootLinked] = {}
            end
            local prios = Raiduku.db.profile.prios
            itemId = tonumber(itemId)
            updateIcon(itemId)
            Raiduku.LootWindow.startButton:Hide()
            Raiduku.LootWindow.laterButton:Hide()
            Raiduku.LootWindow.rollsButton:Disable()
            Raiduku.LootWindow.winnerButton:Disable()
            Raiduku.LootWindow.rollsButton:Show()
            Raiduku.LootWindow.winnerButton:Show()
            Raiduku.LootWindow.recycleButton:Show()
            Raiduku.SoftResList = Raiduku:GetSoftResList(itemId)
            if itemBindType == Raiduku.ItemBindType.BIND_WHEN_EQUIPPED then
                Raiduku.LootWindow.title:SetText("(BoE) " .. Raiduku.LootLinked)
            else
                Raiduku.LootWindow.title:SetText(Raiduku.LootLinked)
            end
            local tableData = getLootLinkedData()
            if tableData then
                Raiduku.RollLootST:SetSelection(1)
                Raiduku.RollLootST:SetData(tableData, true)
                for _, player in next, tableData do
                    local _, plus = strmatch(player[3], "|cFF00(%a+)+(%d+)|r")
                    table.insert(Raiduku.Players, {
                        name = player[1],
                        class = player[2],
                        plus = player[3],
                        roll = player[4],
                        numLooted = Raiduku:GetNumAlreadyLooted(name),
                    })
                end
                Raiduku.LootWindow.winnerButton:Enable()
            else
                Raiduku.Players = {}
            end
            Raiduku.RollLootST:Show()
            if prios[itemId] then
                local prioList = {}
                local raiders = {}
                for i = 1, GetNumGroupMembers() do
                    local raiderName = GetRaidRosterInfo(i)
                    raiders[raiderName] = true
                end
                if Raiduku.db.profile.enableSoftPrio then
                    SendChatMessage("{rt2} Soft Prios {rt2}", Raiduku:GetChatType(), nil, nil)
                    local prioNames = {}
                    for _, prio in ipairs(prios[itemId]) do
                        if prio.name and raiders[prio.name] then
                            tinsert(prioNames, prio.name)
                            Raiduku:AddOrUpdatePlayer(prio.name, prio.class, 1)
                            Raiduku:UpdatePlusRollResults()
                        end
                    end
                    if #prioNames > 0 then
                        Raiduku.LootMode = Raiduku.Constants.LOOT_MODE_SOFTPRIO
                        SendChatMessage(table.concat(prioNames, ", "), Raiduku:GetChatType(), nil, nil)
                        -- TODO make sure prios and pluses are saved
                    end
                else
                    local prioTableData = {}
                    for _, prio in ipairs(prios[itemId]) do
                        if prio.name and raiders[prio.name] then
                            local prioOrder = prio.order == 1 and "|cFF00FF00" .. prio.order .. "|r" or prio.order
                            tinsert(prioList, prio.order .. ": " .. prio.name)
                            tinsert(prioTableData,
                                { prio.name, prioOrder, "+1", nil, Raiduku:GetNumAlreadyLooted(prio.name) })
                        end
                    end
                    if #prioList > 0 then
                        Raiduku.LootMode = Raiduku.Constants.LOOT_MODE_PRIO
                        Raiduku.RollLootST:SetSelection(1)
                        Raiduku.RollLootST:SetData(prioTableData, true)
                        Raiduku.LootWindow.winnerButton:SetEnabled(true)
                        SendChatMessage("{rt2} Prios {rt2}", Raiduku:GetChatType(), nil, nil)
                        for _, prio in ipairs(prioList) do
                            SendChatMessage(prio, Raiduku:GetChatType(), nil, nil)
                        end
                    else
                        Raiduku.SoftResList = Raiduku:GetSoftResList(itemId)
                        if #Raiduku.SoftResList > 0 then
                            displaySoftResInfo()
                        end
                    end
                end
            elseif #Raiduku.SoftResList > 0 then
                Raiduku.LootMode = Raiduku.Constants.LOOT_MODE_SOFTRES
                displaySoftResInfo()
            else
                Raiduku.LootMode = Raiduku.Constants.LOOT_MODE_ROLL
            end
            Raiduku.LootWindow:Show()
        end
    end
end

local function chatMsgLootHandler(...)
    local loot, receiver = select(1, ...), select(5, ...)
    local itemId = loot:match("|Hitem:(%d+):")
    if itemId then
        local _, itemLink, itemQuality, _, _, itemType = GetItemInfo(itemId)
        if itemQuality >= 3 and (Raiduku.LootItemTypes[itemType] or Raiduku.LootItemSpecials[tonumber(itemId)]) and
            Raiduku.LootItemIgnoreList[tonumber(itemId)] == nil then
            local alreadySaved = false
            for _, loots in next, Raiduku.db.profile.loot do
                for _, row in next, loots do
                    local name, _, curItemId = strsplit(",", row)
                    if receiver == name and itemId == curItemId then
                        alreadySaved = true
                    end
                end
            end
            if not alreadySaved then
                local dialog = StaticPopup_Show("RDK_CONFIRM_SAVE_FOR_TMB", itemLink, receiver)
                if (dialog) then
                    dialog.data = loot
                    dialog.data2 = receiver
                end
            end
        end
    end
end

local function playerRollHandler(...)
    local text = ...
    local itemLink = Raiduku.LootsOnBoss and next(Raiduku.LootsOnBoss) or
        Raiduku.LootsInBags and next(Raiduku.LootsInBags)
    if itemLink and text:find("(1-100)") then
        local roll = tonumber(text:match("(%d+)"))
        local playerName = strsplit(" ", text)
        for _, player in ipairs(Raiduku.Players) do
            if player.name == playerName and player.roll == nil then
                player.roll = roll
            end
        end
        if Raiduku.LootMode ~= Raiduku.Constants.LOOT_MODE_PRIO then
            Raiduku:UpdatePlusRollResults()
        end
    end
end

local function playerPlusHandler(...)
    if Raiduku.LootMode == Raiduku.Constants.LOOT_MODE_ROLL or
        Raiduku.LootMode == Raiduku.Constants.LOOT_MODE_SOFTPRIO then
        local text, player = ...
        local guid = select(12, ...)
        local _, class = GetPlayerInfoByGUID(guid)
        local name = Raiduku:GetPlayerName(player)
        local plus = tonumber(text:match("+%d"))
        local loots = Raiduku.LootsOnBoss or Raiduku.LootsInBags or nil
        if loots and plus then
            Raiduku:AddOrUpdatePlayer(name, class, plus)
            Raiduku:UpdatePlusRollResults()
        end
    end
end

local function lootOpenedHandler()
    local loots = {}
    for i = 1, GetNumLootItems() do
        if (LootSlotHasItem(i)) then
            local itemLink = GetLootSlotLink(i)
            if itemLink then
                local rarityFromConfig = Raiduku.db.profile.autoAwardRare and 4 or 3
                local itemRarity = select(3, GetItemInfo(itemLink))
                local itemId = itemLink:match("|Hitem:(%d+):")
                if itemRarity >= rarityFromConfig and Raiduku.LootItemIgnoreList[tonumber(itemId)] == nil
                    and Raiduku.LootItemResources[tonumber(itemId)] == nil then
                    tinsert(loots, itemLink)
                end
                if Raiduku.LootItemResources[tonumber(itemId)] then
                    Raiduku:Print(Raiduku.L["auto-awarding"] .. " " .. itemLink)
                    Raiduku:AutoAwardToSelf(i)
                end
                if itemRarity == 2 and Raiduku.db.profile.autoAwardCommon then
                    Raiduku:Print(Raiduku.L["auto-awarding"] .. " " .. itemLink)
                    Raiduku:AutoAwardToRecycler(i)
                end
                if itemRarity == 3 and Raiduku.db.profile.autoAwardRare then
                    Raiduku:Print(Raiduku.L["auto-awarding"] .. " " .. itemLink)
                    Raiduku:AutoAwardToRecycler(i)
                end
            end
        end
    end
    if #loots > 0 then
        Raiduku:SaveLootsOnBoss(loots)
        Raiduku.LootWindow:Show()
    end
end

--[[
    Loot Window scripts
--]]

Raiduku.LootWindow.closeButton:SetScript("OnClick", function()
    resetAll()
end)

Raiduku.LootWindow.startButton:SetScript("OnClick", function(self)
    self:Hide()
    Raiduku.LootWindow.laterButton:Hide()
    if Raiduku:GetTableSize(Raiduku.LootsOnBoss) > 0 then
        Raiduku.RollLootST:Show()
        startNextLootOnBoss()
    end
end)

Raiduku.LootWindow.laterButton:SetScript("OnClick", function()
    SendChatMessage(Raiduku.L["loot-later"], Raiduku:GetWarningChatType(), nil, nil)
    local i = 1
    for itemLink in next, Raiduku.LootsOnBoss do
        Raiduku.LootLinked = itemLink
        SendChatMessage("{rt1} " .. itemLink, Raiduku:GetChatType(), nil, nil)
        Raiduku:Award(Raiduku:GetLootIndex(itemLink), UnitName("player"))
        Raiduku.LootsInBags[itemLink] = {}
        Raiduku.LootsOnBoss[itemLink] = nil
        i = i + 1
    end
    Raiduku.RollLootST:ClearSelection()
    Raiduku.RollLootST:SetData({}, true)
    Raiduku.RollLootST:Hide()
    Raiduku.LootWindow:Hide()
    -- startNextLootInBags()
end)

Raiduku.LootWindow.recycleButton:SetScript("OnClick", function()
    local onBoss = Raiduku.LootsOnBoss[Raiduku.LootLinked] and true
    local inBags = Raiduku.LootsInBags[Raiduku.LootLinked] and true
    local itemLink = Raiduku.LootLinked
    local itemBindType = select(14, GetItemInfo(itemLink))
    if itemLink then
        if itemBindType == Raiduku.ItemBindType.BIND_WHEN_EQUIPPED then
            SendChatMessage("{rt4} (BoE) " .. itemLink .. " ==> " .. UnitName("player"), Raiduku:GetChatType(), nil, nil)
            Raiduku:Award(Raiduku:GetLootIndex(itemLink), UnitName("player"))
        else
            SendChatMessage("{rt7} " .. Raiduku.L["x-will-recycle-x"]:format(Raiduku.recycler, itemLink),
                Raiduku:GetChatType(), nil, nil)
            Raiduku:Award(Raiduku:GetLootIndex(itemLink), Raiduku.recycler)
        end
    end
    startNextLoot(onBoss, inBags)
end)

Raiduku.LootWindow.rollsButton:SetScript("OnClick", function()
    local playerNames = Raiduku:GetMissingRollPlayerNames()
    local message = "{rt3} /roll {rt3} " .. table.concat(playerNames, ", ")
    SendChatMessage(message, Raiduku:GetWarningChatType(), nil, nil)
end)

Raiduku.LootWindow.winnerButton:SetScript("OnClick", function()
    local selectedPlayer = Raiduku.RollLootST:GetRow(Raiduku.RollLootST:GetSelection())
    local itemLink = Raiduku.LootLinked
    local onBoss = Raiduku.LootsOnBoss[Raiduku.LootLinked] and true
    local inBags = Raiduku.LootsInBags[Raiduku.LootLinked] and true
    local winner = {
        ["name"] = selectedPlayer[1],
        ["prio"] = selectedPlayer[2],
        ["plus"] = tonumber(string.match(selectedPlayer[3], "+(%d)")),
        ["roll"] = selectedPlayer[4]
    };
    local message = "{rt1} GG "

    message = message .. winner.name .. " [+" .. winner.plus .. "]"

    if winner["roll"] then
        message = message .. " (" .. winner.roll .. ")"
    end

    message = message .. " {rt1} " .. itemLink

    SendChatMessage(message, Raiduku:GetChatType(), nil, nil)

    if itemLink then
        Raiduku:SaveLootForTMB(itemLink, winner)
        Raiduku:Award(Raiduku:GetLootIndex(itemLink), winner.name)
    end

    startNextLoot(onBoss, inBags)
end)

--[[
    Module functions
--]]

function Raiduku:DebugLoots()
    if Raiduku.LootLinked then
        print("-- Loot linked --")
        print(Raiduku.LootLinked)
    end
    if Raiduku.LootsOnBoss then
        print("-- Loots on boss --")
        for item, players in next, Raiduku.LootsOnBoss do
            print(item)
            for _, player in next, players do
                print(player[0])
            end
        end
    end
    if Raiduku.LootsInBags then
        print("-- Loots in bags --")
        for item, players in next, Raiduku.LootsInBags do
            print(item)
            for _, player in next, players do
                print(player[0])
            end
        end
    end
    if Raiduku.LootsToTrade then
        print("-- Loots to trade --")
        for _, item in next, Raiduku.LootsToTrade do
            print(item)
        end
    end
end

function Raiduku:SaveLootsOnBoss(itemLinks)
    if not Raiduku.LootsOnBoss or Raiduku:GetTableSize(Raiduku.LootsOnBoss) == 0 then
        for _, itemLink in next, itemLinks do
            Raiduku.LootsOnBoss[itemLink] = {}
        end
    end
end

function Raiduku:GetLootIndex(itemLink)
    for i = 1, GetNumLootItems() do
        if (LootSlotHasItem(i)) then
            local lootItemLink = GetLootSlotLink(i)
            if lootItemLink == itemLink then
                return i
            end
        end
    end
end

function Raiduku:IsToTrade(itemId)
    local itemLink = select(2, GetItemInfo(itemId))
    for _, lootToTrade in next, Raiduku.LootsToTrade do
        if itemLink == lootToTrade then
            return true
        end
    end
    return false
end

function Raiduku:GetNumAlreadyLooted(playerName)
    local currentDate = self:GetCurrentDate()
    local historyTable = Raiduku.db.profile.loot[currentDate]
    local count = 0
    if historyTable then
        for _, csvRow in next, historyTable do
            local name, note = select(1, strsplit(",", csvRow)), select(5, strsplit(",", csvRow))
            if playerName == name and note ~= "OS" then
                count = count + 1
            end
        end
    end
    local yesterdayDate = date("%F", time() - 24 * 60 * 60)
    if Raiduku.db.profile.loot[yesterdayDate] then
        for _, csvRow in next, Raiduku.db.profile.loot[yesterdayDate] do
            local name, note = select(1, strsplit(",", csvRow)), select(5, strsplit(",", csvRow))
            if playerName == name and note ~= "OS" then
                count = count + 1
            end
        end
    end
    return count
end

function Raiduku:AddOrUpdatePlayer(name, class, plus)
    local playerIndex = nil
    for index, player in ipairs(self.Players) do
        if player.name == name then
            playerIndex = index
            break
        end
    end
    if playerIndex then
        self.Players[playerIndex].plus = plus
    else
        table.insert(self.Players, {
            name = name,
            class = class,
            plus = plus,
            roll = nil,
            numLooted = Raiduku:GetNumAlreadyLooted(name),
        })
    end
end

function Raiduku:AutoAwardToRecycler(lootIndex)
    local playerNotFound = true
    for raiderId = 1, GetNumGroupMembers() do
        local raider = GetMasterLootCandidate(lootIndex, raiderId)
        if raider and raider == Raiduku.recycler then
            GiveMasterLoot(lootIndex, raiderId);
            playerNotFound = false
        end
    end
    if playerNotFound then
        self:Print(self.L["cannot-award-to"]:format(Raiduku.recycler))
        StaticPopup_Show("RDK_CONFIRM_RECYCLER", Raiduku.recycler)
    end
end

function Raiduku:AutoAwardToSelf(lootIndex)
    local playerNotFound = true
    for raiderId = 1, GetNumGroupMembers() do
        local raider = GetMasterLootCandidate(lootIndex, raiderId)
        if raider and raider == UnitName("player") then
            GiveMasterLoot(lootIndex, raiderId);
            playerNotFound = false
        end
    end
    if playerNotFound then
        self:Print(self.L["cannot-award-to"]:format(Raiduku.recycler))
        StaticPopup_Show("RDK_CONFIRM_RECYCLER", Raiduku.recycler)
    end
end

function Raiduku:Award(lootIndex, playerName)
    local playerNotFound = true
    local itemLink = Raiduku.LootLinked
    local itemId = tonumber(itemLink:match("|Hitem:(%d+):"))
    if lootIndex then
        for raiderId = 1, GetNumGroupMembers() do
            local raider = GetMasterLootCandidate(lootIndex, raiderId)
            if raider and raider == playerName then
                GiveMasterLoot(lootIndex, raiderId);
                playerNotFound = false
                break
            end
        end
        if playerNotFound then
            self:Print(self.L["cannot-award-to"]:format(playerName))
            GiveMasterLoot(lootIndex, 1);
            if Raiduku:HasItemInBags(itemId) and playerName ~= UnitName("player") then
                SendChatMessage(Raiduku.L["x-come-trade-on-me"]:format(playerName), Raiduku:GetChatType(), nil, nil)
                tinsert(Raiduku.LootsToTrade, itemLink)
                Raiduku.LootsInBags[itemLink] = nil
            end
        end
        Raiduku.LootsOnBoss[itemLink] = nil
    else
        self:Print(self.L["cannot-award-to"]:format(playerName))
        if Raiduku.LootsInBags[itemLink] and Raiduku:HasItemInBags(itemId) then
            if playerName ~= UnitName("player") then
                SendChatMessage(Raiduku.L["x-come-trade-on-me"]:format(playerName), Raiduku:GetChatType(), nil, nil)
                tinsert(Raiduku.LootsToTrade, itemLink)
            end
            Raiduku.LootsInBags[itemLink] = nil
        end
    end

    if Raiduku.LootMode == Raiduku.Constants.LOOT_MODE_SOFTRES then
        local softres = Raiduku.db.profile.softres
        if softres[itemId] then
            for index, resPlayer in next, softres[itemId] do
                if playerName == resPlayer.name then
                    tremove(softres[itemId], index)
                    break
                end
            end
        end
    elseif Raiduku.LootMode == Raiduku.Constants.LOOT_MODE_PRIO then
        local prios = Raiduku.db.profile.prios
        for index, prioPlayer in next, prios[itemId] do
            if playerName == prioPlayer.name then
                tremove(prios[itemId], index)
                self:Print(Raiduku.L["removed-x-from-prios-for-x"]:format(playerName, itemLink))
            end
        end
    end
end

function Raiduku:GetSoftResList(itemId)
    local softres = Raiduku.db.profile.softres
    local sotfresList = {}
    if softres[itemId] then
        local raiders = {}
        for i = 1, GetNumGroupMembers() do
            local raiderName = GetRaidRosterInfo(i)
            raiders[raiderName] = true
        end
        for _, resPlayer in next, softres[itemId] do
            if raiders[resPlayer.name] then
                tinsert(sotfresList, {
                    name = resPlayer.name,
                    class = resPlayer.class,
                    plus = resPlayer.plus,
                    roll = nil,
                    loots = {}
                })
            end
        end
    end
    return sotfresList
end

function Raiduku:GetHighestPlus()
    local highest = nil
    for _, player in ipairs(self.Players) do
        if player.plus and highest == nil then
            highest = player.plus
        elseif player.plus and highest and highest > player.plus then
            highest = player.plus
        end
    end
    return highest
end

function Raiduku:GetHighestPlusPlayers()
    local highestPlus = self:GetHighestPlus()
    local highestPlusPlayers = {}
    for _, player in ipairs(Raiduku.Players) do
        if player.plus == highestPlus then
            table.insert(highestPlusPlayers, player)
        end
    end
    return highestPlusPlayers, highestPlus
end

function Raiduku:GetWinner()
    local winner = nil
    local highestPlusPlayers, highestPlus = self:GetHighestPlusPlayers()
    local highestRoll = Raiduku.db.profile.reverseRollOrder and 100 or 0
    if #highestPlusPlayers == 1 then
        return highestPlusPlayers[1]
    end
    for _, player in ipairs(self.Players) do
        if player.plus == highestPlus then
            if Raiduku.db.profile.reverseRollOrder then
                if player.roll and highestRoll > player.roll then
                    highestRoll = player.roll
                    winner = player
                end
            else
                if player.roll and highestRoll < player.roll then
                    highestRoll = player.roll
                    winner = player
                end
            end
        end
    end
    return winner
end

function Raiduku:GetMissingRollPlayerNames()
    local highestPlusPlayers, highestPlus = self:GetHighestPlusPlayers()
    local players = {}
    if #highestPlusPlayers == 1 then
        return players
    end
    for _, player in ipairs(self.Players) do
        if player.plus == highestPlus and player.roll == nil then
            tinsert(players, player.name)
        end
    end
    return players
end

function Raiduku:SaveLootForTMB(loot, winner)
    local currentDate = self:GetCurrentDate()
    local itemId = loot:match("|Hitem:(%d+):")
    local itemName, itemLink = GetItemInfo(itemId)
    local note = winner.plus and winner.plus > 1 and "OS" or ""
    local csvRow = strjoin(",", winner.name, self:GetCurrentDate(), itemId, itemName, note)
    self.db.profile.loot[currentDate] = self.db.profile.loot[currentDate] or {}
    local alreadySaved = false
    for _, loots in next, self.db.profile.loot do
        for _, row in next, loots do
            if row == csvRow then
                alreadySaved = true
            end
        end
    end
    if not alreadySaved then
        tinsert(self.db.profile.loot[currentDate], csvRow)
        local spec = note == "OS" and self.L["off-spec"] or self.L["main-spec"]
        C_Timer.NewTimer(0.2, function()
            self:Print(self.L["saved-for-tmb"]:format(winner.name, itemLink, spec))
        end)
    end
end

function Raiduku:UpdatePlusRollResults()
    local missingRollPlayerNames = self:GetMissingRollPlayerNames()
    local winner = self:GetWinner()
    if #missingRollPlayerNames > 0 then
        self.LootWindow.rollsButton:SetEnabled(true)
    else
        self.LootWindow.rollsButton:Disable()
        if winner then
            self.LootWindow.winnerButton:SetEnabled(true)
        end
    end

    -- Sort player by plus, then roll
    table.sort(self.Players, function(left, right)
        local leftRoll = tonumber(left.roll) or 0
        local rightRoll = tonumber(right.roll) or 0
        local leftPlus = tonumber(left.plus) or 0
        local rightPlus = tonumber(right.plus) or 0
        if Raiduku.db.profile.reverseRollOrder then
            if leftPlus == rightPlus then
                return leftRoll < rightRoll
            end
            return leftPlus > rightPlus
        end
        if leftPlus == rightPlus then
            return leftRoll > rightRoll
        end
        return leftPlus < rightPlus
    end)

    local tableData = {}
    Raiduku.RollLootST:SetData(tableData, true)

    for _, player in ipairs(self.Players) do
        local playerName = player.name
        local playerPlus = "+" .. player.plus
        if tonumber(player.plus) == 1 then
            playerPlus = "|cFF00FF00+" .. player.plus .. "|r"
        elseif tonumber(player.plus) == 2 then
            playerPlus = "|cFF00D9FF+" .. player.plus .. "|r"
        end
        tinsert(tableData, { playerName, nil, playerPlus, player.roll, player.numLooted })
    end
    Raiduku.RollLootST:SetSelection(1)
    Raiduku.RollLootST:SetData(tableData, true)
    if Raiduku.LootsOnBoss[Raiduku.LootLinked] then
        Raiduku.LootsOnBoss[Raiduku.LootLinked] = tableData
    elseif Raiduku.LootsInBags[Raiduku.LootLinked] then
        Raiduku.LootsInBags[Raiduku.LootLinked] = tableData
    end
end

--[[
    Events
--]]

function Raiduku:LootHandlerWrapper(callback, ...)
    local method = GetLootMethod()
    if Raiduku.isML and method == "master" then
        callback(...)
    end
end

function Raiduku:CHAT_MSG_RAID(event, ...)
    Raiduku:LootHandlerWrapper(lootLinkedHandler, ...)
    Raiduku:LootHandlerWrapper(playerPlusHandler, ...)
end

function Raiduku:CHAT_MSG_RAID_LEADER(event, ...)
    Raiduku:LootHandlerWrapper(lootLinkedHandler, ...)
    Raiduku:LootHandlerWrapper(playerPlusHandler, ...)
end

function Raiduku:CHAT_MSG_RAID_WARNING(event, ...)
    Raiduku:LootHandlerWrapper(lootLinkedHandler, ...)
end

function Raiduku:CHAT_MSG_PARTY(event, ...)
    Raiduku:LootHandlerWrapper(lootLinkedHandler, ...)
    Raiduku:LootHandlerWrapper(playerPlusHandler, ...)
end

function Raiduku:CHAT_MSG_PARTY_LEADER(event, ...)
    Raiduku:LootHandlerWrapper(lootLinkedHandler, ...)
    Raiduku:LootHandlerWrapper(playerPlusHandler, ...)
end

function Raiduku:CHAT_MSG_SYSTEM(event, ...)
    Raiduku:LootHandlerWrapper(playerRollHandler, ...)
end

function Raiduku:CHAT_MSG_LOOT(event, ...)
    Raiduku:LootHandlerWrapper(chatMsgLootHandler, ...)
end

function Raiduku:LOOT_OPENED(event, ...)
    Raiduku:LootHandlerWrapper(lootOpenedHandler)
end

function Raiduku:LOOT_CLOSED(event, ...)
    Raiduku:LootHandlerWrapper(resetAll)
end

function Raiduku:TRADE_SHOW(event, ...)
    local tradeTargetName = _G.TradeFrameRecipientNameText:GetText()
    for _, loots in next, self.db.profile.loot do
        for _, row in next, loots do
            local name, _, itemId = strsplit(",", row)
            if name == tradeTargetName then
                if Raiduku:HasItemInBags(itemId) and Raiduku:IsToTrade(itemId) then
                    local bag, slot = Raiduku:GetContainerPosition(itemId)
                    Raiduku:UseContainerItem(bag, slot);
                end
            end
        end
    end
end
