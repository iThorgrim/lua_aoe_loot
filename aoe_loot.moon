AOELootCreatureCheck = {}
AOELoot = {}

AOELootCreatureCheck.IsValidLootTarget = (target) ->
    return false unless target
    return false unless target\IsDead!
    return false unless target\GetTypeId! == 3

    return true

AOELootCreatureCheck.IsValidLootCreature = (player, target, creature) ->
    return false unless creature\GetGUID! != target
    return false unless player\IsWithinDist creature, LootDistance
    return false unless creature\IsDead!
    return false unless creature\HasFlag 0x0006 + 0x0049, 0x0001

    loot = creature\GetLoot!

    loot\HasItemFor player

AOELootCreatureCheck.GetCreaturesInRange = (player, target) ->
    creatures = player\GetCreaturesInRange LootDistance, 0, 1, 2
    return false unless #creatures > 0

    aoe_loot_view = {}
    for _, creature in pairs(creatures)
        has_player_item = AOELootCreatureCheck.IsValidLootCreature player, target, creature
        if has_player_item
            table.insert aoe_loot_view, creature\GetGUID!
    
    #aoe_loot_view > 0 and aoe_loot_view or false

AOELoot.OnLootOpen = (event, packet, player) ->
    aoe_loot_active = player\GetData("AOE_LOOT_STATUS") or false
    return unless aoe_loot_active
        target = player\GetSelection!
        return unless AOELootCreatureCheck.IsValidLootTarget target

        target = target\ToCreature!
        aoe_loot_view = AOELootCreatureCheck.GetCreaturesInRange player, target
        return unless aoe_loot_view

        for _, creature in pairs aoe_loot_view
            if AOELootCreatureCheck.IsValidLootCreature player, target, creature
                AOELoot.ProcessLootTransfer player, target, creature

AOELoot.ProcessClearCreature = (creature) ->
    loot = creature\GetLoot!
    return unless loot
    
    loot_items = loot\GetItems!
    return unless loot_items

    if #loot_items == 0
        loot\Clear!
        loot\SetUnlootedCount 0
        creature\AllLootRemoved!
        creature\RemoveFlag 0x0006 + 0x0049, 0x0001
    else
        loot\SetUnlootedCount #loot_items

AOELoot.ProcessLootTransfer = (player, target, creature) ->
    target_loot = target\GetLoot!
    creature_loot = creature\GetLoot!
    return unless target_loot or creature_loot

    if creature_loot\IsLooted! or target_loot\IsLooted!
        return false
    
    target_loot_mode = target\GetLootMode!
    target_loot_count = #target_loot\GetItems!
    for _, loot_item in pairs creature_loot\GetItems!
        if (not loot_item.is_looted) and (GetGUIDLow(loot_item.roll_winner_guid) == 0)
            target_loot_count += 1 unless target_loot\HasItem(loot_item.id)
            target_loot\AddItem loot_item.id, 100.0, loot_item.needs_quest, loot_mode, 0, loot_item.count, loot_item.count
            target_loot\UpdateItemIndex!

            creature_loot\RemoveItem loot_item.id
        AOELoot.ProcessClearCreature creature
    
    target_loot\SetMoney target_loot\GetMoney! + creature_loot\GetMoney!
    creature_loot\SetMoney 0
    target_loot\SetUnlootedCount target_loot_count

RegisterPacketEvent 0x15D, 5, AOELoot.OnLootOpen