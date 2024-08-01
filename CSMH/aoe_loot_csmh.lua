require("SMH")
local config = {
  Prefix = "AOELoot",
  Functions = {
    [1] = "OnStatusChange"
  }
}
local OnStatusChange
OnStatusChange = function(player, status)
  return player:SetData("AOE_LOOT_STATUS", status[1] and true or false)
end
return RegisterClientRequests(config)
