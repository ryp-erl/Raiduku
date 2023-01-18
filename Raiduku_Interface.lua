Raiduku.db = Raiduku.db or LibStub("AceDB-3.0"):New("RaidukuLootDB", Raiduku.defaults, true)
Raiduku.RollLootST = Raiduku.RollLootST or {}

function Raiduku:DrawLootWindow()
    local defaultPoint = unpack(Raiduku.db.profile.interface.RaidukuLootWindow or { "CENTER", 0, 0 })
    local RaidukuFrameUI = CreateFrame("Frame", "RaidukuLootWindow", UIParent)
    RaidukuFrameUI:SetPoint(defaultPoint)
    RaidukuFrameUI:SetSize(400, 380)
    RaidukuFrameUI:SetMovable(true)
    RaidukuFrameUI:EnableMouse(true)
    RaidukuFrameUI:RegisterForDrag("LeftButton")
    RaidukuFrameUI:Hide()

    RaidukuFrameUI:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    RaidukuFrameUI:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    RaidukuFrameUI:SetScript("OnHide", function(self)
        local point, _, _, offsetX, offsetY = self:GetPoint()
        Raiduku.db.profile.interface[self:GetName()] = Raiduku.db.profile.interface[self:GetName()] or {}
        Raiduku.db.profile.interface[self:GetName()].point = point
        Raiduku.db.profile.interface[self:GetName()].offsetX = offsetX
        Raiduku.db.profile.interface[self:GetName()].offsetY = offsetY
    end)

    RaidukuFrameUI.texture = RaidukuFrameUI:CreateTexture()
    RaidukuFrameUI.texture:SetAllPoints(RaidukuFrameUI)
    RaidukuFrameUI.texture:SetColorTexture(0, 0, 0, 0.7)

    RaidukuFrameUI.image = CreateFrame("Button", nil, RaidukuFrameUI)
    RaidukuFrameUI.image:SetWidth(32)
    RaidukuFrameUI.image:SetHeight(32)
    RaidukuFrameUI.image:SetPoint("TOPLEFT", 10, -10)

    RaidukuFrameUI.title = RaidukuFrameUI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    RaidukuFrameUI.title:SetPoint("TOPLEFT", 50, -20)

    local columns = {
        {
            name = Raiduku.L["player"],
            width = 120,
            align = "LEFT",
        },
        {
            name = Raiduku.L["prio"],
            width = 60,
            align = "CENTER",
        },
        {
            name = Raiduku.L["spec"],
            width = 60,
            align = "CENTER",
        },
        {
            name = Raiduku.L["roll"],
            width = 30,
            align = "CENTER",
        },
        {
            name = Raiduku.L["looted"],
            width = 60,
            align = "CENTER",
        },
    };

    Raiduku.RollLootST = Raiduku.ST:CreateST(columns, nil, nil, nil, RaidukuFrameUI);
    Raiduku.RollLootST.frame:SetPoint("TOPLEFT", 19, -80)
    Raiduku.RollLootST:EnableSelection(true)
    Raiduku.RollLootST:SetDefaultHighlight(1.0, 0.9, 0, 0.2)
    Raiduku.RollLootST:ClearSelection()
    Raiduku.RollLootST:Hide()

    local nowLaterBtnWidth = math.max(#Raiduku.L["now"], #Raiduku.L["later"]) * 10

    RaidukuFrameUI.startButton = CreateFrame("Button", "StartButton", RaidukuFrameUI, "UIPanelButtonTemplate")
    RaidukuFrameUI.startButton:SetSize(nowLaterBtnWidth, 30)
    RaidukuFrameUI.startButton:SetText(Raiduku.L["now"])
    RaidukuFrameUI.startButton:SetPoint("CENTER", 0, 15)

    RaidukuFrameUI.laterButton = CreateFrame("Button", "LaterButton", RaidukuFrameUI, "UIPanelButtonTemplate")
    RaidukuFrameUI.laterButton:SetSize(nowLaterBtnWidth, 30)
    RaidukuFrameUI.laterButton:SetText(Raiduku.L["later"])
    RaidukuFrameUI.laterButton:SetPoint("CENTER", 0, -15)

    RaidukuFrameUI.closeButton = CreateFrame("Button", "CloseButton", RaidukuFrameUI, "UIPanelButtonTemplate")
    RaidukuFrameUI.closeButton:SetSize(20, 20)
    RaidukuFrameUI.closeButton:SetText("x")
    RaidukuFrameUI.closeButton:SetPoint("TOPRIGHT", -5, -5)

    RaidukuFrameUI.rollsButton = CreateFrame("Button", "RollsButton", RaidukuFrameUI, "UIPanelButtonTemplate")
    RaidukuFrameUI.rollsButton:SetSize(100, 35)
    RaidukuFrameUI.rollsButton:SetText(Raiduku.L["ask-for-rolls"])
    RaidukuFrameUI.rollsButton:SetPoint("BOTTOM", -50, 60)
    RaidukuFrameUI.rollsButton:Disable()
    RaidukuFrameUI.rollsButton:Hide()

    RaidukuFrameUI.winnerButton = CreateFrame("Button", "WinnerButton", RaidukuFrameUI, "UIPanelButtonTemplate")
    RaidukuFrameUI.winnerButton:SetSize(100, 35)
    RaidukuFrameUI.winnerButton:SetText(Raiduku.L["award-loot"])
    RaidukuFrameUI.winnerButton:SetPoint("BOTTOM", 50, 60)
    RaidukuFrameUI.winnerButton:Disable()
    RaidukuFrameUI.winnerButton:Hide()

    RaidukuFrameUI.recycleButton = CreateFrame("Button", "RecycleButton", RaidukuFrameUI, "UIPanelButtonTemplate")
    RaidukuFrameUI.recycleButton:SetSize(100, 35)
    RaidukuFrameUI.recycleButton:SetText(Raiduku.L["recycle-loot"])
    RaidukuFrameUI.recycleButton:SetPoint("BOTTOM", 0, 20)
    RaidukuFrameUI.recycleButton:Hide()

    return RaidukuFrameUI
end

function Raiduku:DrawConfigurationWindow()
    local frame = Raiduku.AceGUI:Create("Frame")
    frame:SetTitle(Raiduku.L["configuration"])
    frame:SetStatusText(self.name .. " - " .. self.version)
    frame:SetCallback("OnClose", function(widget)
        Raiduku.AceGUI:Release(widget)
    end)
    frame:SetLayout("Fill")

    local scrollcontainer = Raiduku.AceGUI:Create("SimpleGroup")
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true)
    scrollcontainer:SetLayout("Fill")

    frame:AddChild(scrollcontainer)

    local scroll = Raiduku.AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    scrollcontainer:AddChild(scroll)

    local recyclingLootsLabel = Raiduku.AceGUI:Create("Label")
    recyclingLootsLabel:SetText(Raiduku.L["managing-loots"])
    recyclingLootsLabel:SetFontObject(GameFontNormalLarge)
    recyclingLootsLabel:SetRelativeWidth(1.0)
    scroll:AddChild(recyclingLootsLabel)

    local raiders = self:GetRaiders()
    local defaultRecyclerValue = 1
    for index, name in ipairs(raiders) do
        if name == Raiduku.recycler then
            defaultRecyclerValue = index
            break
        end
    end

    local recyclerChoice = Raiduku.AceGUI:Create("Dropdown")
    recyclerChoice:SetRelativeWidth(1)
    recyclerChoice:SetLabel(Raiduku.L["choose-recycler"])
    recyclerChoice:SetList(self:GetRaiders())
    recyclerChoice:SetValue(defaultRecyclerValue)
    recyclerChoice:SetDisabled(#self:GetRaiders() == 0)
    recyclerChoice:SetCallback("OnValueChanged", function()
        local recycler = Raiduku:GetRaiders()[recyclerChoice:GetValue()]
        Raiduku.recycler = recycler
        Raiduku.db.profile.lastRecycler = recycler
        self:Print(Raiduku.L["recycler-is-now"]:format(Raiduku.recycler))
    end)
    scroll:AddChild(recyclerChoice)

    local autoAwardCommonCheckbox = Raiduku.AceGUI:Create("CheckBox")
    autoAwardCommonCheckbox:SetRelativeWidth(0.3)
    autoAwardCommonCheckbox:SetLabel(Raiduku.L["auto-award-common"])
    autoAwardCommonCheckbox:SetValue(Raiduku.db.profile.autoAwardCommon)
    autoAwardCommonCheckbox:SetType("checkbox")
    autoAwardCommonCheckbox:SetCallback("OnValueChanged", function()
        Raiduku.db.profile.autoAwardCommon = autoAwardCommonCheckbox:GetValue()
    end)
    scroll:AddChild(autoAwardCommonCheckbox)

    local autoAwardRareCheckbox = Raiduku.AceGUI:Create("CheckBox")
    autoAwardRareCheckbox:SetRelativeWidth(0.3)
    autoAwardRareCheckbox:SetLabel(Raiduku.L["auto-award-rare"])
    autoAwardRareCheckbox:SetValue(Raiduku.db.profile.autoAwardRare)
    autoAwardRareCheckbox:SetType("checkbox")
    autoAwardRareCheckbox:SetCallback("OnValueChanged", function()
        Raiduku.db.profile.autoAwardRare = autoAwardRareCheckbox:GetValue()
    end)
    scroll:AddChild(autoAwardRareCheckbox)

    local recyclerPopupCheckbox = Raiduku.AceGUI:Create("CheckBox")
    recyclerPopupCheckbox:SetRelativeWidth(1)
    recyclerPopupCheckbox:SetLabel(Raiduku.L["open-recycler-popup-reminder"])
    recyclerPopupCheckbox:SetValue(Raiduku.db.profile.recyclerReminder)
    recyclerPopupCheckbox:SetType("checkbox")
    recyclerPopupCheckbox:SetCallback("OnValueChanged", function()
        Raiduku.db.profile.recyclerReminder = recyclerPopupCheckbox:GetValue()
    end)
    scroll:AddChild(recyclerPopupCheckbox)

    local reverseRollOrderCheckbox = Raiduku.AceGUI:Create("CheckBox")
    reverseRollOrderCheckbox:SetRelativeWidth(1)
    reverseRollOrderCheckbox:SetLabel(Raiduku.L["reverse-roll-order"])
    reverseRollOrderCheckbox:SetValue(Raiduku.db.profile.reverseRollOrder)
    reverseRollOrderCheckbox:SetType("checkbox")
    reverseRollOrderCheckbox:SetCallback("OnValueChanged", function()
        Raiduku.db.profile.reverseRollOrder = reverseRollOrderCheckbox:GetValue()
    end)
    scroll:AddChild(reverseRollOrderCheckbox)

    local softPrioCheckbox = Raiduku.AceGUI:Create("CheckBox")
    softPrioCheckbox:SetRelativeWidth(1)
    softPrioCheckbox:SetLabel(Raiduku.L["activate-soft-prio"])
    softPrioCheckbox:SetValue(Raiduku.db.profile.enableSoftPrio)
    softPrioCheckbox:SetType("checkbox")
    softPrioCheckbox:SetCallback("OnValueChanged", function()
        Raiduku.db.profile.enableSoftPrio = softPrioCheckbox:GetValue()
    end)
    scroll:AddChild(softPrioCheckbox)
end

function Raiduku:DrawExportWindow()
    local frame = Raiduku.AceGUI:Create("Frame")
    local status = Raiduku.name .. " - " .. Raiduku.version

    frame:SetStatusText(status)
    frame:SetTitle("Export Data")
    frame:SetStatusText(self.name .. " - " .. self.version)
    frame:SetCallback("OnClose", function(widget)
        Raiduku.AceGUI:Release(widget)
    end)
    frame:SetLayout("Fill")

    local scrollcontainer = Raiduku.AceGUI:Create("SimpleGroup")
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true)
    scrollcontainer:SetLayout("Fill")

    frame:AddChild(scrollcontainer)

    local scroll = Raiduku.AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    scrollcontainer:AddChild(scroll)

    local editbox = Raiduku.AceGUI:Create("MultiLineEditBox")
    editbox:SetRelativeWidth(1.0)
    editbox:SetLabel(Raiduku.L["copy-following-data"])
    editbox:DisableButton(true)
    editbox:SetHeight(300)

    local dates = {}
    for date, _ in pairs(self.db.profile.loot) do
        if strmatch(date, "(%d+)-(%d+)-(%d+)") then
            tinsert(dates, date)
        end
    end

    table.sort(dates, function(left, right)
        return left > right
    end)

    local export = "character,date,itemID,itemName,note\n"
    editbox:SetText(export)

    local dropdown = Raiduku.AceGUI:Create("Dropdown")
    dropdown:SetRelativeWidth(1.0)
    dropdown:SetMultiselect(true)
    dropdown:SetLabel(Raiduku.L["choose-dates"])
    dropdown:SetList(dates)
    dropdown:SetValue(0)
    dropdown:SetCallback("OnValueChanged", function()
        export = "character,date,itemID,itemName,note\n"
        local selectedDates = {}
        for _, widget in dropdown.pullout:IterateItems() do
            if widget.type == "Dropdown-Item-Toggle" then
                if widget:GetValue() then
                    local date = widget:GetText()
                    tinsert(selectedDates, date)
                    self.db.profile.loot[date] = self.db.profile.loot[date] or {}
                    for _, row in next, self.db.profile.loot[date] do
                        export = export .. row .. "\n"
                    end
                end
            end
        end

        if #selectedDates > 0 then
            status = Raiduku.name .. " - " .. Raiduku.version .. " :: |cffffffff" ..
                Raiduku.L["x-dates-selected"]:format(#selectedDates) .. "|r"
        end

        editbox:SetText(export)
        frame:SetStatusText(status)
    end)

    local buttonsContainer = Raiduku.AceGUI:Create("SimpleGroup")
    buttonsContainer:SetFullWidth(true)
    buttonsContainer:SetLayout("Flow")

    local deleteDataButton = Raiduku.AceGUI:Create("Button")
    deleteDataButton:SetText(Raiduku.L["delete-selected-dates"])

    deleteDataButton:SetCallback("OnClick", function()
        local selectedDates = {}
        for _, widget in dropdown.pullout:IterateItems() do
            if widget.type == "Dropdown-Item-Toggle" then
                if widget:GetValue() then
                    local date = widget:GetText()
                    tinsert(selectedDates, date)
                    self.db.profile.loot[date] = nil
                end
            end
        end

        if #selectedDates > 0 then
            local refreshDates = {}
            for date, _ in pairs(self.db.profile.loot) do
                tinsert(refreshDates, date)
            end

            table.sort(refreshDates, function(left, right)
                return left > right
            end)

            dropdown:SetList(refreshDates)
            dropdown:SetValue(0)
            editbox:SetText("character,date,itemID,itemName,note\n")

            status = Raiduku.name .. " - " .. Raiduku.version
            frame:SetStatusText(status)

            Raiduku:Print(Raiduku.L["removed-data-from-x-dates"]:format(table.concat(selectedDates, ", ")))
        end
    end)

    buttonsContainer:AddChild(deleteDataButton)

    scroll:AddChild(dropdown)
    scroll:AddChild(editbox)
    scroll:AddChild(buttonsContainer)
end

--[[
    Reusable frames
--]]

function Raiduku:DrawImportBox(...)
    local title, boxLabel, invalidText, foundItemsText, lastImport, parseFunc = ...
    local frame = Raiduku.AceGUI:Create("Frame")
    local status = self.name .. " - " .. self.version
    if lastImport then
        status = status .. " :: |cffffffff" .. lastImport .. "|r"
    end
    frame:SetTitle(title)
    frame:SetStatusText(status)
    frame:SetCallback("OnClose", function(widget)
        Raiduku.AceGUI:Release(widget)
    end)
    frame:SetLayout("Fill")

    local scrollcontainer = Raiduku.AceGUI:Create("SimpleGroup")
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true)
    scrollcontainer:SetLayout("Fill")

    frame:AddChild(scrollcontainer)

    local scroll = Raiduku.AceGUI:Create("ScrollFrame")
    scroll:SetLayout("Flow")
    scrollcontainer:AddChild(scroll)

    local infoPastedText = Raiduku.AceGUI:Create("Label")
    infoPastedText:SetFullWidth(true)

    local importBox = Raiduku.AceGUI:Create("MultiLineEditBox")
    importBox:SetRelativeWidth(1.0)
    importBox:SetLabel(boxLabel)
    importBox:SetNumLines(20)
    importBox:DisableButton(true)
    -- Fix lag generated by pasting large amount of text
    -- https://github.com/WeakAuras/WeakAuras2/blob/main/WeakAurasOptions/OptionsFrames/ImportExport.lua#L68
    importBox.editBox:SetMaxBytes(1)
    local textBuffer, i, lastPaste = {}, 0, 0
    local function clearBuffer(self)
        self:SetScript('OnUpdate', nil)
        local pasted = strtrim(table.concat(textBuffer))
        importBox.editBox:ClearFocus();
        importBox.pasted = pasted
        if (#pasted > 20) then
            importBox.editBox:SetMaxBytes(2500);
            importBox.editBox:SetText(strsub(pasted, 1, 2500));
        end
        if #importBox.editBox:GetText() > 0 then
            importBox.button:Enable()
        else
            importBox.button:Disable()
        end
        local valid, _, numItems = parseFunc(self, importBox.pasted)
        if not valid then
            infoPastedText:SetText(invalidText)
        else
            infoPastedText:SetText(numItems .. " " .. foundItemsText)
        end
    end

    importBox.editBox:SetScript('OnChar', function(self, c)
        if lastPaste ~= GetTime() then
            textBuffer, i, lastPaste = {}, 0, GetTime()
            self:SetScript('OnUpdate', clearBuffer)
        end
        i = i + 1
        textBuffer[i] = c
    end)
    scroll:AddChild(importBox)

    local buttonsContainer = Raiduku.AceGUI:Create("SimpleGroup")
    buttonsContainer:SetFullWidth(true)
    buttonsContainer:SetLayout("Flow")

    local importButton = Raiduku.AceGUI:Create("Button")
    importButton:SetText(Raiduku.L["import-and-override"])
    buttonsContainer:AddChild(importButton)

    local removeAllButton = Raiduku.AceGUI:Create("Button")
    removeAllButton:SetText(Raiduku.L["remove-all"])
    buttonsContainer:AddChild(removeAllButton)

    scroll:AddChild(buttonsContainer)
    scroll:AddChild(infoPastedText)

    return frame, importBox, importButton, removeAllButton
end

--[[
    Static popups
--]]

StaticPopupDialogs["RDK_CONFIRM_SAVE_FOR_TMB"] = {
    text = Raiduku.L["confirm-manual-award-save-for-tmb"],
    button1 = Raiduku.L["yes"],
    button2 = Raiduku.L["no"],
    OnAccept = function(_, data, data2)
        Raiduku:SaveLootForTMB(data, {
            name = data2
        })
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

StaticPopupDialogs["RDK_CONFIRM_RECYCLER"] = {
    text = Raiduku.L["change-recycler"],
    button1 = Raiduku.L["yes"],
    button2 = Raiduku.L["no"],
    OnAccept = function()
        Raiduku:DrawConfigurationWindow()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3
}

StaticPopupDialogs["RDK_TRADE_BACK_LOOT"] = {
    text = Raiduku.L["trade-back-loot-history"],
    button1 = Raiduku.L["remove-record"],
    button2 = Raiduku.L["change-award-ownership-to-me"],
    OnAccept = function(self)
        tremove(self.db.profile.loot[self.data.date], self.data.rowIndex)
    end,
    OnCancel = function(self)
        tremove(self.db.profile.loot[self.data.date], self.data.rowIndex)
        tinsert(self.db.profile.loot[self.data.date], self.data.newRow)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = false,
    preferredIndex = 3
}
