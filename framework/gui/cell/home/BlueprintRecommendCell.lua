autoImport("HomeRecommendCell")
BlueprintRecommendCell = class("BlueprintRecommendCell", HomeRecommendCell)
local HotPosX, LikePosX = -126, -27
local PhotoFrameMap = {
  [HomeCmd_pb.EHOUSETYPE_PRIVATE] = "home_blueprint_bg_s",
  [HomeCmd_pb.EHOUSETYPE_SNOW] = "home_blueprint_bg_01"
}
local _, SnowNameColor = ColorUtil.TryParseHexString("5975c0")

function BlueprintRecommendCell:FindObjs()
  BlueprintRecommendCell.super.FindObjs(self)
  self.likeIcon = self:FindGO("LikeIcon")
  self.likeBtn = self:FindGO("LikeBtn")
  self:AddClickEvent(self.likeBtn, function()
    self:OnLikeBtnClick()
  end)
  self.likeNum = self:FindComponent("Like", UILabel)
  self.hotGO = self:FindGO("HotSp")
  self.furnitureNum = self:FindComponent("FurnitureNum", UILabel)
  self.collectionBg = self:FindGO("CollectionBg")
  self:AddClickEvent(self.collectionBg, function()
    self:OnCollectionClick()
  end)
  self.collection = self:FindGO("Collection")
  self.violationIcon = self:FindGO("ViolationIcon")
  self.inUseGO = self:FindGO("InUse")
  self.deleteBtn = self:FindGO("DeleteBtn")
  self:AddClickEvent(self.deleteBtn, function()
    self:OnDeleteBtnClick()
  end)
  self:AddCellClickEvent()
end

function BlueprintRecommendCell:SetData(data)
  local prev = self.data
  if prev and prev.isOfficial and prev.bpName and self.photoTex then
    PictureManager.Instance:UnLoadHomeBluePrint(prev.bpName, self.photoTex)
  end
  self.data = data
  if data then
    self.frameBg.spriteName = PhotoFrameMap[data.houseType] or ""
    local homeName = data.homeName
    self.name.text = homeName
    self.name.color = data.houseType == HomeCmd_pb.EHOUSETYPE_SNOW and SnowNameColor or ColorUtil.NGUIWhite
    self.nameScrollCtrl:Start(true, true)
    local showHot = not data.isOfficial and 0 < (data.hot or 0)
    self.hotGO:SetActive(showHot)
    self.hotLabel.text = data.hot or 0
    local isViolation = not data.isOfficial and data.isViolation == true
    local isCollection = data.cellMode == "collection"
    local showLike = not isViolation and not isCollection
    self.likeBtn:SetActive(showLike)
    self.likeNum.gameObject:SetActive(showLike)
    if showLike then
      self.likeNum.text = data.likeNum
      local likePosX = showHot and LikePosX or HotPosX
      local likePos = self.likeBtn.transform.localPosition
      self.likeBtn.transform.localPosition = Vector3(likePosX, likePos.y, likePos.z)
    end
    self.likeIcon:SetActive(showLike and data.isLike or false)
    self.collection:SetActive(data.isCollection)
    if self.violationIcon then
      self.violationIcon:SetActive(isViolation)
    end
    local isCollectionOrMy = isCollection or data.cellMode == "my"
    local isMy = data.cellMode == "my"
    self.deleteBtn:SetActive(isMy)
    self.collectionBg:SetActive(not isMy)
    local isInUse = isCollectionOrMy and not data.isOfficial and HomeBlueprintProxy.Instance:IsCurrentDisplayingItem(data)
    self.isInUse = isInUse
    if self.inUseGO then
      self.inUseGO:SetActive(isInUse)
    end
    if self.furnitureNum then
      if data.isOfficial then
        data:RefreshOfficialFurnitureProgress()
      end
      local have = data.haveFurnitureNum or 0
      local total = data.totalFurnitureNum or 0
      self.furnitureNum.text = string.format(ZhString.HomeBluePrint_FurnitureNumFormat, have, total)
    end
    self:GetPhoto()
  end
end

function BlueprintRecommendCell:GetPhoto()
  if not self.data then
    return
  end
  if self.data.isOfficial and self.data.bpName and self.photoTex then
    PictureManager.Instance:SetHomeBluePrint(self.data.bpName, self.photoTex)
    return
  end
  local photoId = self.data.photoId
  local urlPath = self.data:GetPhotoUrl()
  local timeStamp = self.data.timeStamp
  local photoKey = self.data:GetPhotoKey()
  FunctionPhotoStorage.Me():GetHomePhoto(FunctionPhotoStorage.PhotoType.HomeBlueprint, photoId, timeStamp, true, urlPath, photoKey, nil, nil, photoKey)
end

function BlueprintRecommendCell:OnCellDestroy()
  if self.data and self.data.isOfficial and self.data.bpName and self.photoTex then
    PictureManager.Instance:UnLoadHomeBluePrint(self.data.bpName, self.photoTex)
  end
  BlueprintRecommendCell.super.OnCellDestroy(self)
end

function BlueprintRecommendCell:OnDeleteBtnClick()
  if not self.data then
    return
  end
  MsgManager.ConfirmMsgByID(43677, function()
    if self.isInUse then
      self:Notify(HomeBuildingSceneBPControl.ExitBluePrint)
      HomeBlueprintProxy.Instance:SetCurDisplayingItem(nil)
    end
    local data = self:ParsePrintActionParam()
    ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(HomeCmd_pb.EPRINTACTION_DELETE, data)
  end)
end

function BlueprintRecommendCell:OnLikeBtnClick()
  if not self.data then
    return
  end
  local curIsLike = self.data.isLike
  local data = self:ParsePrintActionParam()
  local action = curIsLike and HomeCmd_pb.EPRINTACTION_UNPRAISE or HomeCmd_pb.EPRINTACTION_PRAISE
  redlog("[OnLikeBtnClick]id=" .. data.id, "etyp=" .. data.etype, "is_offical=" .. tostring(data.is_offical))
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(action, data)
end

function BlueprintRecommendCell:OnCollectionClick()
  if not self.data then
    return
  end
  local curIsCollection = self.data.isCollection
  if not curIsCollection then
    local collectionNum = HomeBlueprintProxy.Instance:GetCollectionNum()
    local maxCollectNum = GameConfig.HomeBlueprint and GameConfig.HomeBlueprint.Limit and GameConfig.HomeBlueprint.Limit.MaxCollect or 20
    if collectionNum >= maxCollectNum then
      MsgManager.ShowMsgByID(43678)
      return
    end
  end
  local data = self:ParsePrintActionParam()
  local action = curIsCollection and HomeCmd_pb.EPRINTACTION_COLLECT_OUT or HomeCmd_pb.EPRINTACTION_COLLECT_IN
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(action, data)
end

function BlueprintRecommendCell:ParsePrintActionParam()
  if not self.data then
    return
  end
  local data = {}
  data.id = self.data.photoId
  data.etype = self.data.houseType
  data.is_offical = self.data.isOfficial
  data.accid = self.data.accId
  return data
end
