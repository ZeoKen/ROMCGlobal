MonsterInfoProxy = class("MonsterInfoProxy", pm.Proxy)
MonsterInfoProxy.Instance = nil
MonsterInfoProxy.NAME = "MonsterInfoProxy"

function MonsterInfoProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MonsterInfoProxy.NAME
  if MonsterInfoProxy.Instance == nil then
    MonsterInfoProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function MonsterInfoProxy:Init()
  self.curWeekMonsterInfo = {}
  self.nextWeekMonsterInfo = {}
end

function MonsterInfoProxy:RecvMonsterBatchInfo(data)
  local curMonsterIds = data.curmonsterids
  local nextMonsterIds = data.nextmonsterids
  if curMonsterIds and 0 < #curMonsterIds then
    for i = 1, #curMonsterIds do
      local id = curMonsterIds[i]
      self.curWeekMonsterInfo[#self.curWeekMonsterInfo + 1] = id
    end
  end
  if nextMonsterIds and 0 < #nextMonsterIds then
    for i = 1, #nextMonsterIds do
      local id = nextMonsterIds[i]
      self.nextWeekMonsterInfo[#self.nextWeekMonsterInfo + 1] = id
    end
  end
end

function MonsterInfoProxy:GetCurMonsterBatchInfo()
  if self.curWeekMonsterInfo and #self.curWeekMonsterInfo > 0 then
    return self.curWeekMonsterInfo
  end
end

function MonsterInfoProxy:GetNextMonsterBatchInfo()
  if self.nextWeekMonsterInfo and #self.nextWeekMonsterInfo > 0 then
    return self.nextWeekMonsterInfo
  end
end
