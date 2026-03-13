ActivityConfigHelper = class("ActivityConfigHelper")

function ActivityConfigHelper.GetActPersonalConfig(act_id)
  local config = Table_ActivityNew and Table_ActivityNew[act_id] and Table_ActivityNew[act_id] or Table_ActPersonalTimer[act_id]
  return config
end
