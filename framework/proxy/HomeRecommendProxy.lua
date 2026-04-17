autoImport("HomeRecommendItemData")
HomeRecommendProxy = class("HomeRecommendProxy", pm.Proxy)
HomeRecommendProxy.Instance = nil
HomeRecommendProxy.NAME = "HomeRecommendProxy"

function HomeRecommendProxy:ctor(proxyName, data)
  self.proxyName = proxyName or HomeRecommendProxy.NAME
  if HomeRecommendProxy.Instance == nil then
    HomeRecommendProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function HomeRecommendProxy:Init()
  self.recommendListByType = {}
end

function HomeRecommendProxy:UpdateRecommendList(data)
  if not data then
    return
  end
  local homeType = data.type
  local serverPath = data.cdn_path
  redlog("UpdateRecommendList homeType = " .. tostring(homeType), " serverPath = " .. tostring(serverPath))
  local list = self.recommendListByType[homeType]
  if not list then
    list = {}
    self.recommendListByType[homeType] = list
  end
  TableUtility.ArrayClear(list)
  local serverDatas = data.datas
  if not serverDatas then
    return
  end
  for i = 1, #serverDatas do
    local serverData = serverDatas[i]
    local data = HomeRecommendItemData.new(serverData, homeType, i, serverPath)
    list[#list + 1] = data
  end
end

function HomeRecommendProxy:GetRecommendList(homeType)
  if not homeType then
    return {}
  end
  return self.recommendListByType[homeType] or {}
end
