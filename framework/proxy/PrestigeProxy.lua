autoImport("PrestigeData")
PrestigeProxy = class("PrestigeProxy", pm.Proxy)
PrestigeProxy.Instance = nil
PrestigeProxy.NAME = "PrestigeProxy"
PrestigeProxy.PrestigeType = {Camp = 1, Personal = 2}

function PrestigeProxy:ctor(proxyName, data)
  self.proxyName = proxyName or PrestigeProxy.NAME
  if PrestigeProxy.Instance == nil then
    PrestigeProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:PreprocessPrestige()
end

function PrestigeProxy:RecvPrestigeNtfUserCmd(serverdata)
  if serverdata.datas then
    local len = #serverdata.datas
    for i = 1, len do
      local single = serverdata.datas[i]
      local localData = self.prestigeMap[single.campid]
      if localData then
        localData:UpdateData(single)
      else
        redlog(string.format("Error: Cannot find prestige static data: %s from Table_Prestige but received from server", tostring(single.campid)))
      end
    end
  else
    redlog("serverdata.datas is nil")
  end
end

function PrestigeProxy:PreprocessPrestige()
  if self.prestigeMap then
    TableUtility.TableClear(self.prestigeMap)
  else
    self.prestigeMap = {}
  end
  for k, v in pairs(Table_Prestige) do
    self.prestigeMap[v.id] = PrestigeData.new(v)
  end
  local prestigeData
  for id, expData in pairs(Table_PrestigeValue) do
    prestigeData = self.prestigeMap[expData.PreID]
    if prestigeData then
      prestigeData:SetLevelExpStaticData(expData.Level, expData)
    end
  end
  for k, v in pairs(Table_PrestigeItem) do
    prestigeData = self.prestigeMap[v.PreID]
    if prestigeData then
      local single = {}
      single.itemid = v.ItemID
      if v.AddPre then
        for i, addValue in pairs(v.AddPre) do
          if i == v.PreID then
            prestigeData:SetGiftItems(v.ItemID, addValue)
          end
        end
      end
    end
  end
end

function PrestigeProxy:GetPrestigeDataByNPC(npcid)
  local prestigeNpcData = Table_PrestigeNpc[npcid]
  return prestigeNpcData and self.prestigeMap[prestigeNpcData.PrestigeID]
end

function PrestigeProxy:GetPrestigeDataByCampID(campid)
  return self.prestigeMap[campid]
end

function PrestigeProxy:IsPrestigeGraduate(campid)
  local prestigeData = self:GetPrestigeDataByCampID(campid)
  if not prestigeData then
    LogUtility.Error("Cannot Find Prestige Data!")
    return false
  end
  return prestigeData:IsGraduate()
end
