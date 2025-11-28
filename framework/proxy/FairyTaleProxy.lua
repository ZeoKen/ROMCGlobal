autoImport("FairyTaleRaidRankData")
FairyTaleProxy = class("FairyTaleProxy", pm.Proxy)
FairyTaleProxy.Instance = nil
FairyTaleProxy.NAME = "FairyTaleProxy"

function FairyTaleProxy:ctor(proxyName, data)
  self.proxyName = proxyName or FairyTaleProxy.NAME
  self.data = data
  if FairyTaleProxy.Instance == nil then
    FairyTaleProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function FairyTaleProxy:Init()
  self.rankInfo = {}
  self.rankDataOutOfDate = 0
end

function FairyTaleProxy:UpdateRankInfo(data)
  local datas = data.datas
  for i = 1, #datas do
    local serverData = datas[i]
    local info = FairyTaleRaidRankData.new(serverData)
    self.rankInfo[#self.rankInfo + 1] = info
  end
  self.rankDataOutOfDate = ServerTime.CurServerTime()
end

function FairyTaleProxy:GetRankInfo()
  return self.rankInfo
end

function FairyTaleProxy:GetRankInfoSearchResult(keyword)
  local result = {}
  keyword = string.lower(keyword)
  for i = 1, #self.rankInfo do
    local info = self.rankInfo[i]
    if info.name and string.find(string.lower(info.name), keyword) then
      result[#result + 1] = info
    end
  end
  return result
end

function FairyTaleProxy:QueryRankInfo()
  if ServerTime.CurServerTime() - self.rankDataOutOfDate > 30000 then
    TableUtility.ArrayClear(self.rankInfo)
    ServiceSceneUser3Proxy.Instance:CallFairyTaleRankQueryCmd()
    return true
  end
end

function FairyTaleProxy:UpdateRewardInfo(rewardCount)
  self.rewardCount = rewardCount or 0
end

function FairyTaleProxy:GetRewardCount()
  return self.rewardCount or 0
end
