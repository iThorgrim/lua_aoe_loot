local AOELootCreatureCheck = { }
local AOELoot = { }
AOELootCreatureCheck.IsValidLootTarget = function(target)
  if not (target) then
    return false
  end
  if not (target:IsDead()) then
    return false
  end
  if not (target:GetTypeId() == 3) then
    return false
  end
  return true
end
AOELootCreatureCheck.IsValidLootCreature = function(player, target, creature)
  if not (creature:GetGUID() ~= target) then
    return false
  end
  if not (player:IsWithinDist(creature, LootDistance)) then
    return false
  end
  if not (creature:IsDead()) then
    return false
  end
  if not (creature:HasFlag(0x0006 + 0x0049, 0x0001)) then
    return false
  end
  local loot = creature:GetLoot()
  return loot:HasItemFor(player)
end
AOELootCreatureCheck.GetCreaturesInRange = function(player, target)
  local creatures = player:GetCreaturesInRange(LootDistance, 0, 1, 2)
  if not (#creatures > 0) then
    return false
  end
  local aoe_loot_view = { }
  for _, creature in pairs(creatures) do
    local has_player_item = AOELootCreatureCheck.IsValidLootCreature(player, target, creature)
    if has_player_item then
      table.insert(aoe_loot_view, creature:GetGUID())
    end
  end
  return #aoe_loot_view > 0 and aoe_loot_view or false
end
AOELoot.OnLootOpen = function(event, packet, player)
  local aoe_loot_active = player:GetData("AOE_LOOT_STATUS") or false
  if not (aoe_loot_active) then
    local target = player:GetSelection()
    if not (AOELootCreatureCheck.IsValidLootTarget(target)) then
      return 
    end
    target = target:ToCreature()
    local aoe_loot_view = AOELootCreatureCheck.GetCreaturesInRange(player, target)
    if not (aoe_loot_view) then
      return 
    end
    for _, creature in pairs(aoe_loot_view) do
      if AOELootCreatureCheck.IsValidLootCreature(player, target, creature) then
        AOELoot.ProcessLootTransfer(player, target, creature)
      end
    end
  end
end
AOELoot.ProcessClearCreature = function(creature)
  local loot = creature:GetLoot()
  if not (loot) then
    return 
  end
  local loot_items = loot:GetItems()
  if not (loot_items) then
    return 
  end
  if #loot_items == 0 then
    loot:Clear()
    loot:SetUnlootedCount(0)
    creature:AllLootRemoved()
    return creature:RemoveFlag(0x0006 + 0x0049, 0x0001)
  else
    return loot:SetUnlootedCount(#loot_items)
  end
end
AOELoot.ProcessLootTransfer = function(player, target, creature)
  local target_loot = target:GetLoot()
  local creature_loot = creature:GetLoot()
  if not (target_loot or creature_loot) then
    return 
  end
  if creature_loot:IsLooted() or target_loot:IsLooted() then
    return false
  end
  local target_loot_mode = target:GetLootMode()
  local target_loot_count = #target_loot:GetItems()
  for _, loot_item in pairs(creature_loot:GetItems()) do
    if (not loot_item.is_looted) and (GetGUIDLow(loot_item.roll_winner_guid) == 0) then
      if not (target_loot:HasItem(loot_item.id)) then
        target_loot_count = target_loot_count + 1
      end
      target_loot:AddItem(loot_item.id, 100.0, loot_item.needs_quest, loot_mode, 0, loot_item.count, loot_item.count)
      target_loot:UpdateItemIndex()
      creature_loot:RemoveItem(loot_item.id)
    end
    AOELoot.ProcessClearCreature(creature)
  end
  target_loot:SetMoney(target_loot:GetMoney() + creature_loot:GetMoney())
  creature_loot:SetMoney(0)
  return target_loot:SetUnlootedCount(target_loot_count)
end
RegisterPacketEvent(0x15D, 5, AOELoot.OnLootOpen)