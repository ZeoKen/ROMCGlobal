autoImport("DisneyRankShowData")
ManorPartnerProxy = class("v", pm.Proxy)
ManorPartnerProxy.Instance = nil
ManorPartnerProxy.NAME = "ManorPartnerProxy"

function ManorPartnerProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ManorPartnerProxy.NAME
  if ManorPartnerProxy.Instance == nil then
    ManorPartnerProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ManorPartnerProxy:Init()
  self.partnerList = {}
  self.partnerComposeList = {}
  self:InitPartnerComposeList()
end

function ManorPartnerProxy:RecvPartnerInfoManorCmd(partenrInfos)
  for i = 1, #partenrInfos do
    local partnerInfo = partenrInfos[i]
    local data = {}
    data.id = partnerInfo.id
    data.favor = partnerInfo.favor
    data.maxFavor = partnerInfo.maxfavor
    if partnerInfo.composes and #partnerInfo.composes > 0 then
      local composeData = {}
      for j = 1, #partnerInfo.composes do
        table.insert(composeData, partnerInfo.composes[j])
      end
      data.composes = composeData
    end
    local tempStoryList = {}
    for j = 1, #partnerInfo.stories do
      local single = partnerInfo.stories[j]
      table.insert(tempStoryList, {
        id = single.id,
        read = single.read
      })
    end
    data.stories = tempStoryList
    self.partnerList[partnerInfo.id] = data
  end
end

function ManorPartnerProxy:GetPartnerList()
  if self.partnerList then
    return self.partnerList
  end
end

function ManorPartnerProxy:GetPartnerInfo(id)
  if self.partnerList and self.partnerList[id] then
    return self.partnerList[id]
  end
end

function ManorPartnerProxy:GetAllUnlockedComposesAttr()
  local result = {}
  self:_ForEachUnlockedCompose(function(composeData, arr)
    local effectId = composeData.Effects and composeData.Effects[1]
    TableUtility.ArrayPushBack(arr, {
      Name = composeData.ComposeName,
      attrNameEn = Table_AssetEffect[effectId].Desc,
      type = 2
    })
  end, result)
  return result
end

function ManorPartnerProxy:GetAllUnlockedEffectIdsOfComposes()
  local result = {}
  self:_ForEachUnlockedCompose(function(composeData, arr)
    TableUtility.ArrayPushBack(arr, composeData.Effects and composeData.Effects[1])
  end, result)
  return result
end

local unlockedComposes = {}

function ManorPartnerProxy:_ForEachUnlockedCompose(action, ...)
  TableUtility.TableClear(unlockedComposes)
  local composes, composeData
  for _, v in pairs(self.partnerList) do
    composes = v.composes
    if composes then
      for i = 1, #composes do
        if not unlockedComposes[composes[i]] then
          unlockedComposes[composes[i]] = true
        end
      end
    end
  end
  for k, _ in pairs(unlockedComposes) do
    composeData = Table_ManorPartnerCompose[k]
    if composeData then
      action(composeData, ...)
    end
  end
end

function ManorPartnerProxy:InitPartnerComposeList()
  if not Table_ManorPartnerCompose then
    return
  end
  for i = 1, #Table_ManorPartnerCompose do
    local single = Table_ManorPartnerCompose[i]
    local partners = single.Partners
    for j = 1, #partners do
      local partnerId = partners[j]
      if not self.partnerComposeList[partnerId] then
        self.partnerComposeList[partnerId] = {}
      end
      if not self.partnerComposeList[partnerId][i] then
        self.partnerComposeList[partnerId][i] = 1
      end
    end
  end
end

function ManorPartnerProxy:GetPartnerCompose(partnerId)
  if self.partnerComposeList[partnerId] then
    return self.partnerComposeList[partnerId]
  end
end
