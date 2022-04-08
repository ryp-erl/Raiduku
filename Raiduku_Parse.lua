Raiduku.TMB = Raiduku.TMB or {}
Raiduku.SoftRes = Raiduku.SoftRes or {}

function Raiduku.TMB:ParsePrios(csvData)
    if not csvData then
        return false, nil, nil
    end
    local valid, prios, numPrios = Raiduku.TMB:ParseTooltipsExport(csvData)
    if valid then
        return valid, prios, numPrios
    else
        return Raiduku.TMB:ParsePriosExport(csvData)
    end
end

function Raiduku.TMB:ParsePriosExport(csvData)
    local header =
        "type,raid_group_name,member_name,character_name,character_class,character_is_alt,character_inactive_at,character_note,sort_order,item_name,item_id,is_offspec,note,received_at,import_id,item_note,item_prio_note,item_tier,item_tier_label,created_at,updated_at"
    local prios = {}
    local num = 1
    local numPrios = 0
    for line in csvData:gmatch("([^\n]*)\n?") do
        line = line:trim()
        if num == 1 and line ~= header then
            return false, nil, nil
        end
        if num > 1 and line ~= header then
            local type, name, class = select(1, strsplit(",", line)), select(4, strsplit(",", line)),
                select(5, strsplit(",", line))
            local order, itemId, receivedAt = select(9, strsplit(",", line)), select(11, strsplit(",", line)),
                select(14, strsplit(",", line))
            if type == "prio" and #receivedAt == 0 then
                itemId = tonumber(itemId)
                order = tonumber(order)
                if prios[itemId] == nil then
                    prios[itemId] = {}
                end
                tinsert(prios[itemId], {
                    name = name,
                    class = class:upper(),
                    order = order
                })
                numPrios = numPrios + 1
            end
        end
        num = num + 1
    end
    -- Reorder per prio
    for itemId, _ in pairs(prios) do
        table.sort(prios[itemId], function(left, right)
            return left.order < right.order
        end)
    end
    return true, prios, numPrios
end

function Raiduku.TMB:ParseTooltipsExport(csvData)
    local header =
        "type,character_name,character_class,character_is_alt,character_inactive_at,character_note,sort_order,item_id,is_offspec,received_at,item_prio_note,item_tier_label"
    local prios = {}
    local num = 1
    local numPrios = 0
    for line in csvData:gmatch("([^\n]*)\n?") do
        line = line:trim()
        if num == 1 and line ~= header then
            return false, nil, nil
        end
        if num > 1 and line ~= header then
            -- FIXME don't parse comma between quotes (public note could contain quotes)
            local type, name, class = strsplit(",", line)
            local order, itemId, receivedAt = select(7, strsplit(",", line)), select(8, strsplit(",", line)),
                select(10, strsplit(",", line))
            if type == "prio" and (receivedAt == nil or #receivedAt == 0) then
                itemId = tonumber(itemId)
                order = tonumber(order)
                if prios[itemId] == nil then
                    prios[itemId] = {}
                end
                tinsert(prios[itemId], {
                    name = name,
                    class = class:upper(),
                    order = order
                })
                numPrios = numPrios + 1
            end
        end
        num = num + 1
    end
    -- Reorder per prio
    for itemId, _ in pairs(prios) do
        table.sort(prios[itemId], function(left, right)
            return left.order < right.order
        end)
    end
    return true, prios, numPrios
end

function Raiduku.SoftRes:Parse(csvData)
    if not csvData then
        return false, nil, nil
    end
    local valid, softres, numSoftres = Raiduku.SoftRes:ParseWeakAuraExport(csvData)
    if valid then
        return valid, softres, numSoftres
    else
        return Raiduku.SoftRes:ParseCsvExport(csvData)
    end
end

function Raiduku.SoftRes:ParseCsvExport(csvData)
    local header = "Item,ItemId,From,Name,Class,Spec,Note,Plus,Date"
    local softres = {}
    local num = 1
    local numSoftres = 0
    for line in csvData:gmatch("([^\n]*)\n?") do
        line = line:trim()
        if num == 1 and line ~= header then
            return false, nil, nil
        end
        if num > 1 and line ~= header then
            local itemId, name, plus, class = select(2, strsplit(",", line)), select(4, strsplit(",", line)),
                select(8, strsplit(",", line)), select(5, strsplit(",", line))
            itemId = tonumber(itemId)
            if itemId ~= nil then
                if softres[itemId] == nil then
                    softres[itemId] = {}
                end
                tinsert(softres[itemId], {
                    name = name,
                    class = class,
                    plus = plus
                })
                numSoftres = numSoftres + 1
            end
        end
        num = num + 1
    end
    return true, softres, numSoftres
end

function Raiduku.SoftRes:ParseWeakAuraExport(csvData)
    local header = "ItemId,Name,Class,Note,Plus"
    local softres = {}
    local num = 1
    local numSoftres = 0
    for line in csvData:gmatch("([^\n]*)\n?") do
        line = line:trim()
        if num == 1 and line ~= header then
            return false, nil, nil
        end
        if num > 1 and line ~= header then
            local itemId, name, plus, class = select(1, strsplit(",", line)), select(2, strsplit(",", line)),
                select(5, strsplit(",", line)), select(3, strsplit(",", line))
            itemId = tonumber(itemId)
            if itemId ~= nil then
                if softres[itemId] == nil then
                    softres[itemId] = {}
                end
                tinsert(softres[itemId], {
                    name = name,
                    class = class,
                    plus = plus
                })
                numSoftres = numSoftres + 1
            end
        end
        num = num + 1
    end
    return true, softres, numSoftres
end
