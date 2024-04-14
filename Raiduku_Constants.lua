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
    -- Fragment of Deathwing's Jaw Cluster for Fangs of the Father (safety)
    [78352] = true,
    -- Shadowy Gem Cluster for Fangs of the Father (safety)
    [77951] = true,
    -- Elementium Gem Cluster for Fangs of the Father (safety)
    [77952] = true,
    -- Heart of Flame for Dragonwrath, Tarecgosa's Rest (safety)
    [69848] = true,
    -- Seething Cinder for Dragonwrath, Tarecgosa's Rest (safety)
    [69815] = true,
    -- Eternal Ember for Dragonwrath, Tarecgosa's Rest (safety)
    [71141] = true,
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

Raiduku.LootItemDuplicatable = {
    -- ToC Tokens
    [47242] = true,
    [47557] = true,
    [47558] = true,
    [47559] = true,
    -- Ulduar Tokens
    [45632] = true,
    [45633] = true,
    [45634] = true,
    [45638] = true,
    [45639] = true,
    [45640] = true,
    [45641] = true,
    [45642] = true,
    [45643] = true,
    [45653] = true,
    [45654] = true,
    [45655] = true,
    [45656] = true,
    [45657] = true,
    [45658] = true,
    -- Ulduar Trashs
    [45541] = true,
    [45549] = true,
    [45547] = true,
    [45548] = true,
    [45543] = true,
    [45544] = true,
    [45542] = true,
    [45540] = true,
    [45539] = true,
    [45538] = true,
    [45605] = true,
    -- Ulduar Other
    [45607] = true,
    [45620] = true,
    [45612] = true,
    [45613] = true,
    [45670] = true,
    -- Naxxramas Tokens
    [40625] = true,
    [40626] = true,
    [40627] = true,
    [40631] = true,
    [40632] = true,
    [40633] = true,
    [40634] = true,
    [40635] = true,
    [40636] = true,
    [40637] = true,
    [40638] = true,
    [40639] = true,
    -- Naxxramas Trashs
    [40410] = true,
    [40409] = true,
    [40414] = true,
    [40412] = true,
    [40408] = true,
    [40407] = true,
    [40406] = true,
    -- Naxxramas Other
    [39718] = true,
    [39717] = true,
    [40071] = true,
    [40065] = true,
    [40069] = true,
    [40064] = true,
    [40080] = true,
    [40075] = true,
    [40107] = true,
    [40074] = true,
    [39714] = true,
    [40208] = true,
    [39716] = true,
    [39730] = true,
    [39733] = true,
    [40256] = true,
    [40258] = true,
    [40255] = true,
    [40257] = true,
    [39760] = true,
    [39768] = true,
    [40250] = true,
    [40251] = true,
    [40252] = true,
    [40253] = true,
    [40254] = true,
    [40602] = true,
    [40193] = true,
    [40185] = true,
    [40188] = true,
    [40191] = true,
    [40205] = true,
    [40209] = true,
    [40203] = true,
    [40204] = true,
    [40206] = true,
    [40247] = true,
    [40242] = true,
    [40239] = true,
    [40326] = true,
    [40319] = true,
    [40332] = true,
    [40350] = true,
    [40343] = true,
    [40346] = true,
    [40260] = true,
    [40270] = true,
    [40259] = true,
    [40265] = true,
    [40289] = true,
    [40281] = true,
    [40280] = true,
    [40303] = true,
    [40296] = true,
    [40302] = true,
    [40297] = true
}
