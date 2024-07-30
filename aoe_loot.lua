local controller = { }
controller.OnLootFrameOpen = function(event, packet, player)
  local aoe_loot_active = true
  if aoe_loot_active then
    local lootable_creature = controller.GetLootableCreatures(player)
    return controller.SetCreatureLoot(player, lootable_creature)
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
controller.SetCreatureLoot = function(player, creatures)
  local actual_creature = player:GetSelection():ToCreature()
  local actual_loot = actual_creature:GetLoot()
  for _, creature in pairs(creatures) do
    if creature ~= actual_creature and creature:GetLootRecipient() == player then
      local loot = creature:GetLoot()
      local creature_already_looted = loot:IsLooted()
      if not (creature_already_looted) then
        local items = loot:GetItems()
        for _, loot_data in pairs(items) do
          if not loot_data.is_looted and (loot_data.roll_winner_guid == 0 or not loot_data.roll_winner_guid) then
            actual_loot:AddItem(loot_data.id, loot_data.count, loot_data.count, 100.0, 0, loot_data.needs_quest)
          end
        end
        actual_loot:SetMoney(actual_loot:GetMoney() + loot:GetMoney())
        if #items == 0 then
          loot:Clear()
          loot:SetUnlootedCount(0)
          creature:RemoveFlag(0x0006 + 0x0049, 0x0001)
        else
          loot:SetUnlootedCount(#items)
        end
        loot:SetMoney(0)
      end
    end
  end
  return actual_loot:SetUnlootedCount(#actual_loot:GetItems())
end
