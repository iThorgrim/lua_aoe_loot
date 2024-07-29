controller = {}

controller.OnLootFrameOpen = (event, packet, player) ->
    aoe_loot_active = player\GetGroup! and false or true
    if aoe_loot_active
        lootable_creature = controller.GetLootableCreatures player
        controller.SetCreatureLoot player, lootable_creature
RegisterPacketEvent 0x15D, 5, controller.OnLootFrameOpen

controller.GetLootableCreatures = (player) ->
    creatures_in_range = player\GetCreaturesInRange 50, 0, 0, 2
    lootable_creatures = [creature for creature in *creatures_in_range when creature\IsDead! and creature\HasFlag 0x0006 + 0x0049, 0x0001]
    return lootable_creatures

controller.SetCreatureLoot = (player, creatures) ->
    actual_creature = player\GetSelection!\ToCreature!
    actual_loot = actual_creature\GetLoot!

    for _, creature in pairs creatures
        if creature != actual_creature and creature\GetLootRecipient! == player
            loot = creature\GetLoot!
            creature_already_looted = loot\IsLooted!
            unless creature_already_looted
                items = loot\GetItems!
                for _, loot_data in pairs items
                    unless loot_data.is_looted
                        actual_loot\AddItem loot_data.id, loot_data.count, loot_data.count, 100.0, 0, loot_data.needs_quest
                
                actual_loot\SetMoney actual_loot\GetMoney! + loot\GetMoney!
                loot\Clear!
                loot\SetUnlootedCount 0
                loot\SetMoney 0
                creature\RemoveFlag 0x0006 + 0x0049, 0x0001

    actual_loot\SetUnlootedCount #actual_loot\GetItems!
