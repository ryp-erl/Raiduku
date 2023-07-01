Raiduku.LootModes = Raiduku.LootModes or {
    ["LOOT_MODE_ROLL"] = 1,
    ["LOOT_MODE_PRIO"] = 2,
    ["LOOT_MODE_SOFTPRIO"] = 3,
    ["LOOT_MODE_SOFTRES"] = 4,
}

Raiduku.ItemBindType = Raiduku.ItemBindType or {
    ["BIND_WHEN_PICKED_UP"] = 1,
    ["BIND_WHEN_EQUIPPED"] = 2,
}

Raiduku.LootItemTypes = {
    ["Weapon"] = 2,
    ["Armor"] = 4,
    ["Recipe"] = 9,
    ["Miscellaneous"] = 15
}

Raiduku.LootItemSpecials = {
    [32385] = true,
    [34845] = true,
    [43345] = true,
    [49294] = true,
    [49295] = true,
    [43346] = true,
    [49644] = true,
    [49643] = true,
}

Raiduku.LootItemIgnoreList = {
    -- Shadowfrost Shard (safety)
    [50274] = true,
    -- Fragment of Val'anyr (safety)
    [45038] = true,
    -- Abyss Crystal
    [34057] = true,
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
    -- LK Phase 3 Crusader Orb
    [47556] = true,
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
