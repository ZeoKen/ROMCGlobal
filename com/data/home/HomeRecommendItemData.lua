HomeRecommendItemData = class("HomeRecommendItemData")

function HomeRecommendItemData:ctor(serverData, homeType, index, serverPath)
  self.photoId = homeType
  self.index = index
  self.accId = serverData.accid
  self.charId = serverData.charid
  self.serverPath = serverPath
  self.timeStamp = ServerTime.CurServerTime() // 1000
  self.userName = serverData.user_name
  self.homeName = not StringUtil.IsEmpty(serverData.home_name) and serverData.home_name or homeType == HomeCmd_pb.EHOUSETYPE_SNOW and ZhString.HomeMainView_TabSnow or ""
  self.hot = serverData.visit_count
  redlog("HomeRecommendItemData:ctor accId = " .. tostring(self.accId), "charId = " .. tostring(self.charId), "userName = " .. tostring(self.userName), "homeName = " .. tostring(self.homeName))
end

function HomeRecommendItemData:GetPhotoUrl()
  return string.format("%s%s", self.serverPath, self.accId)
end
