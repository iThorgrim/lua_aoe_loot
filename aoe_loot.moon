controller = {}

controller.OnLootFrameOpen = (event, packet, player) ->
    aoe_loot_active = player\GetData("AOE_LOOT_STATUS") or false
    if aoe_loot_active
        selection = player\GetSelection!
        return nil unless selection
        return nil unless selection\GetTypeId! == 3

        creature = selection\ToCreature!
        return nil unless creature
        return nil unless creature\IsDead!

        lootable_creature = controller.GetLootableCreatures player
        controller.SetCreatureLoot player, creature, lootable_creature
RegisterPacketEvent 0x15D, 5, controller.OnLootFrameOpen

controller.GetLootableCreatures = (player) ->
    creatures_in_range = player\GetCreaturesInRange 50, 0, 0, 2
    lootable_creatures = [creature for creature in *creatures_in_range when creature\IsDead! and creature\HasFlag 0x0006 + 0x0049, 0x0001]
    return lootable_creatures

controller.SetCreatureLoot = (player, creature, lootable_creatures) ->
    actual_loot = creature\GetLoot!
    nbr_loot = #actual_loot\GetItems!
    loot_mode = creature\GetLootMode!

    for _, corpse in pairs lootable_creatures
        if corpse != creature and corpse\GetLootRecipient! == player
            loot = corpse\GetLoot!
            creature_already_looted = loot\IsLooted!
            unless creature_already_looted
                for _, loot_data in pairs loot\GetItems!
                    if (not loot_data.is_looted) and (GetGUIDLow(loot_data.roll_winner_guid) == 0)
                        nbr_loot += 1 unless actual_loot\HasItem(loot_data.id)
                        loot\RemoveItem loot_data.id
                        actual_loot\AddItem loot_data.id, 100.0, loot_data.needs_quest, loot_mode, 0, loot_data.count, loot_data.count
                        actual_loot\UpdateItemIndex!

                actual_loot\SetMoney actual_loot\GetMoney! + loot\GetMoney!
                items = loot\GetItems!
                if #items == 0
                    loot\Clear!
                    loot\SetUnlootedCount 0
                    corpse\AllLootRemoved!
                    corpse\RemoveFlag 0x0006 + 0x0049, 0x0001
                else
                    loot\SetUnlootedCount #items

                loot\SetMoney 0

    actual_loot\SetUnlootedCount nbr_loot
