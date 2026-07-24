HomeBluePrintSavePopup = class("HomeBluePrintSavePopup", ContainerView)
HomeBluePrintSavePopup.ViewType = UIViewType.PopUpLayer
local BlueprintReviewLayer = Game.ELayer.PhotographPanel
GameConfig.System.blueprintname_max = GameConfig.System.blueprintname_max or 8
GameConfig.System.blueprintname_min = GameConfig.System.blueprintname_min or 1

function HomeBluePrintSavePopup:Init()
  self:FindObjs()
  self:AddListenEvts()
end

function HomeBluePrintSavePopup:AddListenEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.OnPrintUpdateHomeCmd)
end

function HomeBluePrintSavePopup:FindObjs()
  self.nameInput = self:FindComponent("NameInput", UIInput)
  local saveBtn = self:FindGO("SaveBtn")
  self:AddClickEvent(saveBtn, function()
    self:OnSaveBtnClick()
  end)
  local cancelBtn = self:FindGO("CancelBtn")
  self:AddClickEvent(cancelBtn, function()
    self:CloseSelf()
  end)
  local editBtn = self:FindGO("EditBtn")
  self:AddClickEvent(editBtn, function()
    self.nameInput.isSelected = not self.nameInput.isSelected
  end)
  self.photoTex = self:FindComponent("PhotoTex", UITexture)
  self.nameInput.characterLimit = GameConfig.System.blueprintname_max * 3
  self:AddSelectEvent(self.nameInput, function(go, state)
    if state then
      return
    end
    self:ValidateName()
  end)
end

function HomeBluePrintSavePopup:OnEnter()
  HomeBluePrintSavePopup.super.OnEnter(self)
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(HomeCmd_pb.EPRINTACTION_QUERY_SELF)
  local vd = self.viewdata and self.viewdata.viewdata
  local tex = vd and vd.captureTexture
  if tex and self.photoTex then
    self.photoTex.mainTexture = tex
  end
  if self.nameInput then
    self.nameInput.value = ZhString.HomeBluePrint_SaveDefaultNamePrefix
  end
end

function HomeBluePrintSavePopup:OnExit()
  self:ClearPhoto()
end

function HomeBluePrintSavePopup:ClearPhoto()
  local oldTexture = self.photoTex.mainTexture
  if oldTexture ~= nil then
    Object.DestroyImmediate(oldTexture)
  end
  self.photoTex.mainTexture = nil
end

function HomeBluePrintSavePopup:GetCurrentHouseType()
  local cur = HomeProxy.Instance:GetCurHouseData()
  if cur and cur.houseType and cur.houseType ~= 0 then
    return cur.houseType
  end
  if HomeManager.Me():IsSnowRealmMap(Game.MapManager:GetMapID()) then
    return HomeCmd_pb.EHOUSETYPE_SNOW
  end
  return HomeCmd_pb.EHOUSETYPE_PRIVATE
end

function HomeBluePrintSavePopup:GetCurrentHouseAccId()
  local cur = HomeProxy.Instance:GetCurHouseData()
  return cur and cur.accid
end

function HomeBluePrintSavePopup:GenNextBlueprintId(houseType)
  local myList = HomeBlueprintProxy.Instance:GetMyList()
  local maxBase = 0
  for i = 1, #myList do
    local id = myList[i].photoId
    if id then
      local base = math.floor(id / 10)
      if maxBase < base then
        maxBase = base
      end
    end
  end
  return (maxBase + 1) * 10 + houseType
end

function HomeBluePrintSavePopup:UploadBlueprintCheckPhoto(item, snowHomeIdx)
  local houseType = item.etype
  local reviewPoses = HomePictureManager.Me():GetCapturePoses(true, snowHomeIdx)
  HomeManager.Me():SetAllFurnituresLayer(BlueprintReviewLayer, snowHomeIdx)
  HomePictureManager.Me():CaptureAndUploadReviewAtPoses(reviewPoses, FunctionPhotoStorage.PhotoType.BlueprintCheck, item.id, function(index, success, errorMsg, photoId, timestamp)
    redlog("[HomeBluePrintSavePopup] upload blueprint check photo index=" .. tostring(index), "success=" .. tostring(success), "errorMsg=" .. tostring(errorMsg), "photoId=" .. tostring(photoId), "timestamp=" .. tostring(timestamp))
  end, function(allSuccess)
    HomeManager.Me():ResetFurnitureLayers()
    redlog("[HomeBluePrintSavePopup] upload blueprint check photo all finish allSuccess=", tostring(allSuccess))
    if allSuccess then
      ServiceHomeCmdProxy.Instance:CallReqHomeCheckHomeCmd(houseType)
      MsgManager.ShowMsgByID(43675)
    end
  end, nil, BlueprintReviewLayer)
end

function HomeBluePrintSavePopup:ValidateName()
  local name = self.nameInput.value
  local defaultName = ZhString.HomeBluePrint_SaveDefaultNamePrefix
  if name == "" then
    self.nameInput.value = defaultName
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.blueprintname_min then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.blueprintname_max
    })
    self.nameInput.value = defaultName
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, GameConfig.MaskWord.BlueprintName) then
    MsgManager.ShowMsgByIDTable(2604)
    self.nameInput.value = ""
    return
  end
  if length > GameConfig.System.blueprintname_max then
    self.nameInput.value = StringUtil.getTextByIndex(name, 1, GameConfig.System.blueprintname_max)
  end
end

function HomeBluePrintSavePopup:OnSaveBtnClick()
  local myBpNum = HomeBlueprintProxy.Instance:GetMyBlueprintNum()
  local myMaxNum = GameConfig.HomeBlueprint and GameConfig.HomeBlueprint.Limit and GameConfig.HomeBlueprint.Limit.MaxMyBlueprint or 6
  if myBpNum >= myMaxNum then
    MsgManager.ShowMsgByID(43676)
    return
  end
  self:ValidateName()
  local name = self.nameInput.value
  if name == "" then
    return
  end
  local houseType = self:GetCurrentHouseType()
  redlog("[HomeBluePrintSavePopup:OnSaveBtnClick]id=", tostring(self:GenNextBlueprintId(houseType)))
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(HomeCmd_pb.EPRINTACTION_SAVE, {
    accid = self:GetCurrentHouseAccId(),
    id = self:GenNextBlueprintId(houseType),
    datas = {
      {
        data = HomeCmd_pb.EPRINTDATA_NAME,
        sdata = name
      }
    }
  })
end

function HomeBluePrintSavePopup:OnPrintUpdateHomeCmd(note)
  redlog("[HomeBluePrintSavePopup:OnPrintUpdateHomeCmd]")
  local data = note and note.body
  redlog("[HomeBluePrintSavePopup:OnPrintUpdateHomeCmd]action=", data.action)
  if not data or data.action ~= HomeCmd_pb.EPRINTACTION_SAVE then
    return
  end
  local item = data.items and data.items[1]
  if not item then
    return
  end
  local snowHomeIdx
  if item.etype == HomeCmd_pb.EHOUSETYPE_SNOW then
    snowHomeIdx = HomeManager.Me():GetCurHomeIdx()
  end
  local vd = self.viewdata and self.viewdata.viewdata
  local tex = vd and vd.captureTexture
  if tex then
    FunctionPhotoStorage.Me():SaveHomePhoto(FunctionPhotoStorage.PhotoType.HomeBlueprint, tex, item.id, ServerTime.CurServerTime() // 1000, nil, nil, function(success, errMsg)
      if success then
        redlog("[HomeBluePrintSavePopup] upload blueprint photo success, id=", tostring(item.id))
        self:UploadBlueprintCheckPhoto(item, snowHomeIdx)
      else
        LogUtility.Error("[HomeBluePrintSavePopup] upload blueprint photo failed: " .. tostring(errMsg))
      end
    end)
  end
  self:CloseSelf()
end
