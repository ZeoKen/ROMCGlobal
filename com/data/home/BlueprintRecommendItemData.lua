autoImport("HomeBluePrintData")
BlueprintRecommendItemData = class("BlueprintRecommendItemData")

function BlueprintRecommendItemData:ctor(serverData, homeType, index, serverPath)
  self.photoId = serverData.id
  self.houseType = homeType
  self.index = index
  self.accId = serverData.accid
  self.charId = serverData.charid
  self.mapID = serverData.mapID
  self.serverPath = serverPath
  self.timeStamp = ServerTime.CurServerTime() // 1000
  self.userName = serverData.user_name
  self.homeName = not StringUtil.IsEmpty(serverData.home_name) and serverData.home_name or homeType == HomeCmd_pb.EHOUSETYPE_SNOW and ZhString.HomeMainView_TabSnow or ""
  self.hot = serverData.visit_count or 0
  self.likeNum = serverData.like_num or 0
  self.isLike = serverData.is_like or false
  self.isCollection = serverData.is_collection or false
  self.isViolation = serverData.is_violation or false
  self.isOfficial = false
  self.totalFurnitureNum = 0
  self.haveFurnitureNum = 0
end

function BlueprintRecommendItemData:SetFurnitureProgress(bluePrintData)
  if not bluePrintData or not bluePrintData.inited then
    return
  end
  self.totalFurnitureNum = bluePrintData.totalFurnitureNum or 0
  self.haveFurnitureNum = bluePrintData.haveFurnitureNum or 0
  self._bpData = bluePrintData
end

function BlueprintRecommendItemData.CreateFromOfficial(staticRow, houseType, index)
  if not staticRow then
    return nil
  end
  local o = {
    isOfficial = true,
    houseType = houseType,
    index = index,
    photoId = staticRow.id,
    name = staticRow.NameZh,
    bpName = staticRow.BPName,
    mapID = staticRow.MapID,
    homeName = staticRow.NameZh,
    userName = "",
    accId = nil,
    charId = nil,
    serverPath = nil,
    timeStamp = 0,
    hot = 0,
    likeNum = 0,
    isLike = false,
    isCollection = false,
    totalFurnitureNum = 0,
    haveFurnitureNum = 0,
    _officialBpData = nil
  }
  local ok, bp = pcall(function()
    return HomeBluePrintData.new(staticRow.id)
  end)
  if ok and bp and bp.inited then
    o._officialBpData = bp
    o.totalFurnitureNum = bp.totalFurnitureNum or 0
    o.haveFurnitureNum = bp.haveFurnitureNum or 0
  end
  setmetatable(o, {
    __index = BlueprintRecommendItemData
  })
  return o
end

function BlueprintRecommendItemData:RefreshOfficialFurnitureProgress()
  if not self.isOfficial then
    return
  end
  local bp = self._officialBpData
  if not bp or not bp.inited then
    return
  end
  bp:RefreshBagNum()
  self.totalFurnitureNum = bp.totalFurnitureNum or 0
  self.haveFurnitureNum = bp.haveFurnitureNum or 0
end

function BlueprintRecommendItemData:GetPhotoUrl()
  if self.isOfficial then
    return ""
  end
  if not self.serverPath or not self.accId then
    return ""
  end
  return string.format("%s%s", self.serverPath, self.accId)
end

function BlueprintRecommendItemData:GetPhotoKey()
  return string.format("%s_%s_%s", tostring(self.accId or 0), tostring(self.houseType or 0), tostring(self.photoId or 0))
end
