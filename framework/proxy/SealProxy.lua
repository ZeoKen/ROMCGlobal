SealProxy = class("SealProxy", pm.Proxy)
SealProxy.Instance = nil
SealProxy.NAME = "SealProxy"
autoImport("SealData")
local normalCost = {
  {5600, 8},
  {5601, 8},
  {5602, 8},
  {5603, 8},
  {5604, 10},
  {5605, 10},
  {5606, 10}
}

function SealProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SealProxy.NAME
  if SealProxy.Instance == nil then
    SealProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:InitSeal()
end

function SealProxy:InitSeal()
  self.sealDataMap = {}
  self.nowAcceptSeal = nil
  self.nowSealPos = LuaVector3()
  self.nowSealTasks = {}
  self.forbidQuickFinish = {}
end

function SealProxy:SetNowSealTasks(serverlist)
  TableUtility.ArrayClear(self.nowSealTasks)
  for i = 1, #serverlist do
    table.insert(self.nowSealTasks, serverlist[i])
  end
end

function SealProxy:SetNowAcceptSeal(sealId, sealPos)
  self:ResetAcceptSealInfo()
  self.nowAcceptSeal = sealId
  if sealPos == nil then
    LuaVector3.Better_Set(self.nowSealPos, 0, 0, 0)
  else
    LuaVector3.Better_Set(self.nowSealPos, sealPos.x / 1000, sealPos.y / 1000, sealPos.z / 1000)
  end
end

function SealProxy:ResetAcceptSealInfo()
  self.nowAcceptSeal = 0
  LuaVector3.Better_Set(self.nowSealPos, 0, 0, 0)
  self.speed = 0
  self.curvalue = 0
  self.maxvalue = 1
end

function SealProxy:SetSealTimer(data)
  if data then
    self.speed = data.speed
    self.curvalue = data.curvalue
    self.maxvalue = data.maxvalue
    self.stoptime = data.stoptime
    self.maxtime = data.maxtime
  end
end

function SealProxy:ResetSealData()
  self.sealDataMap = {}
end

function SealProxy:SetSealData(datas)
  for i = 1, #datas do
    local data = datas[i]
    if data then
      local sealData = self.sealDataMap[data.mapid]
      if not sealData then
        sealData = SealData.new(data)
        self.sealDataMap[data.mapid] = sealData
      else
        sealData:SetData(data)
      end
    end
  end
end

function SealProxy:UpdateSeals(newdatas, deldatas)
  self:SetSealData(newdatas)
  for i = 1, #deldatas do
    local tempDel = deldatas[i]
    local catchData = self.sealDataMap[tempDel.mapid]
    if catchData then
      catchData:DeleteSealItem(tempDel.items)
    end
  end
end

function SealProxy:CheckQuickFinishValid()
  if FunctionUnLockFunc.Me():CheckCanOpen(33) then
    if GameConfig.Servant.SealGeneration then
      return false
    end
    local needLv = GameConfig.Seal.quickFinishRoleLv or 80
    if needLv <= MyselfProxy.Instance:RoleLevel() and SealProxy.GetSealVarValue() < GameConfig.Seal.maxSealNum then
      return true
    end
  end
  return false
end

function SealProxy:GetSealData(mapid)
  return self.sealDataMap[mapid]
end

function SealProxy:GetSealItem(mapid, sealid)
  local sealData = self.sealDataMap[mapid]
  if sealData then
    return sealData.itemMap[sealid]
  end
end

function SealProxy.GetCostByMapID(mapid)
  local cfg = GameConfig.Seal.quickfinish_cost
  for i = 1, #cfg do
    if cfg[i][2] == mapid then
      return cfg[i][1], 1
    end
  end
end

function SealProxy.GetSealVarValue()
  local var = MyselfProxy.Instance:getVarByType(Var_pb.EVARTYPE_SEAL)
  local donetimes = var and var.value
  donetimes = donetimes or 0
  return donetimes
end

function SealProxy.GetQuickCost(mapid)
  if not GameConfig.Seal or not GameConfig.Seal.quickfinish_cost_high then
    redlog("裂隙快速完成GameConfig.Seal.quickfinish_cost_high配置未传")
    return 0
  end
  if not GameConfig.Seal.quickfinish_cost_high[mapid] then
    return 0
  end
  return GameConfig.Seal.quickfinish_cost_high[mapid][2]
end

function SealProxy:GetSealingItem()
  for mapid, sealData in pairs(self.sealDataMap) do
    for sealid, sealItem in pairs(sealData.itemMap) do
      if sealItem.issealing then
        return sealItem
      end
    end
  end
end

function SealProxy:SetQuickFinishForbid(serverlist)
  TableUtility.TableClear(self.forbidQuickFinish)
  redlog("serverlist", #serverlist)
  for i = 1, #serverlist do
    local single = serverlist[i]
    local data = {}
    data.raidID = single.configid
    data.enable = single.passflag
    redlog("SetQuickFinishForbid", single.configid, single.passflag)
    self.forbidQuickFinish[data.raidID] = data
  end
end

function SealProxy:GetQuickFinishForbid(raidID)
  if self.forbidQuickFinish and self.forbidQuickFinish[raidID] then
    return self.forbidQuickFinish[raidID].enable
  end
  return false
end
