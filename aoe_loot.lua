local controller = { }
controller.OnLootFrameOpen = function(event, packet, player)
  local aoe_loot_active = true
  if aoe_loot_active then
    local selection = player:GetSelection()
    if not (selection) then
      return nil
    end
    if not (selection:GetTypeId() == 3) then
      return nil
    end
    local creature = selection:ToCreature()
    if not (creature) then
      return nil
    end
    local lootable_creature = controller.GetLootableCreatures(player)
    return controller.SetCreatureLoot(player, creature, lootable_creature)
  end
end
RegisterPacketEvent(0x15D, 5, controller.OnLootFrameOpen)
controller.GetLootableCreatures = function(player)
  local creatures_in_range = player:GetCreaturesInRange(50, 0, 0, 2)
  local lootable_creatures
  do
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #creatures_in_range do
      local creature = creatures_in_range[_index_0]
      if creature:IsDead() and creature:HasFlag(0x0006 + 0x0049, 0x0001) then
        _accum_0[_len_0] = creature
        _len_0 = _len_0 + 1
      end
    end
    lootable_creatures = _accum_0
  end
  return lootable_creatures
end
controller.SetCreatureLoot = function(player, creature, lootable_creatures)
  local actual_loot = creature:GetLoot()
  local nbr_loot = #actual_loot:GetItems()
  local loot_mode = creature:GetLootMode()
  for _, corpse in pairs(lootable_creatures) do
    if corpse ~= creature and corpse:GetLootRecipient() == player then
      local loot = corpse:GetLoot()
      local creature_already_looted = loot:IsLooted()
      if not (creature_already_looted) then
        for _, loot_data in pairs(loot:GetItems()) do
          if (not loot_data.is_looted) and (GetGUIDLow(loot_data.roll_winner_guid) == 0) then
            if not (actual_loot:HasItem(loot_data.id)) then
              nbr_loot = nbr_loot + 1
            end
            loot:RemoveItem(loot_data.id)
            actual_loot:AddItem(loot_data.id, 100.0, loot_data.needs_quest, loot_mode, 0, loot_data.count, loot_data.count)
            actual_loot:UpdateItemIndex()
          end
        end
        actual_loot:SetMoney(actual_loot:GetMoney() + loot:GetMoney())
        local items = loot:GetItems()
        if #items == 0 then
          loot:Clear()
          loot:SetUnlootedCount(0)
          corpse:RemoveFlag(0x0006 + 0x0049, 0x0001)
        else
          loot:SetUnlootedCount(#items)
        end
        loot:SetMoney(0)
      end
    end
  end
  return actual_loot:SetUnlootedCount(nbr_loot)
end
