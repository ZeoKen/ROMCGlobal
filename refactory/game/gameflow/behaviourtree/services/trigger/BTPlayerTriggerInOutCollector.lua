BTPlayerTriggerInOutCollector = class("BTPlayerTriggerInOutCollector", BTService)
BTPlayerTriggerInOutCollector.TypeName = "PlayerTriggerInOutCollector"
BTDefine.RegisterService(BTPlayerTriggerInOutCollector.TypeName, BTPlayerTriggerInOutCollector)
local StatNames = {
  LastInGuids = 1001,
  FirstInGuids = 1002,
  FirstOutGuids = 1003
}
BTPlayerTriggerInOutCollector.StatNames = StatNames
BTDefine.RegisterBlackBoardOption(BTPlayerTriggerInOutCollector.TypeName, StatNames)
local TableClear = TableUtility.TableClear
local ArrayClear = TableUtility.ArrayClear

function BTPlayerTriggerInOutCollector:ctor(config)
  BTPlayerTriggerInOutCollector.super.ctor(self, config)
  self.preServiceName = config.preServiceName
  self.bbKey = config.bbKey
  self.stats = {
    [StatNames.LastInGuids] = {},
    [StatNames.FirstInGuids] = {},
    [StatNames.FirstOutGuids] = {}
  }
end

function BTPlayerTriggerInOutCollector:Dispose()
end

function BTPlayerTriggerInOutCollector:Exec(time, deltaTime, context)
  if not context then
    return 1
  end
  local bb = context.blackboard
  if not bb then
    return 1
  end
  if not self.preServiceName or not self.bbKey then
    return 1
  end
  local preServiceStats = bb[self.preServiceName]
  if not preServiceStats then
    return 1
  end
  local dirty = false
  local curInGuids = preServiceStats[self.bbKey]
  local lastInGuids = self.stats[StatNames.LastInGuids]
  local firstInGuids = self.stats[StatNames.FirstInGuids]
  local firstOutGuids = self.stats[StatNames.FirstOutGuids]
  TableClear(firstInGuids)
  for k, v in pairs(curInGuids) do
    if not lastInGuids[k] then
      firstInGuids[k] = v
      dirty = true
    end
  end
  TableClear(firstOutGuids)
  for k, v in pairs(lastInGuids) do
    if not curInGuids[k] then
      firstOutGuids[k] = v
      dirty = true
    end
  end
  TableClear(lastInGuids)
  for k, v in pairs(curInGuids) do
    lastInGuids[k] = v
  end
  bb[self.name] = self.stats
  if dirty then
    bb:SetKeyDirty(self.name, dirty)
  end
  return 0
end
