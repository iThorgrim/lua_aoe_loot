-- Require the Server Message Handler
require "SMH"

config =
  Prefix: "AOELoot"
  Functions: {[1]: "OnStatusChange"}

OnStatusChange = (player, status) ->
  player\SetData "AOE_LOOT_STATUS", status[1] and true or false

RegisterClientRequests config
