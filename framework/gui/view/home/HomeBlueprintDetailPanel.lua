HomeBlueprintDetailPanel = class("HomeBlueprintDetailPanel", ContainerView)
HomeBlueprintDetailPanel.ViewType = UIViewType.PopUpLayer
HomeBlueprintDetailPanel.picNameName = "RO_Blueprint"
autoImport("HomeBluePrintView")
autoImport("PersonalPicturePanel")
autoImport("PermissionUtil")
HomeBlueprintDetailPanel.BrotherView = HomeBluePrintView
autoImport("PostcardTargetSelectPopup")
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "EnterHomeRoom"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail",
  "EnterHomeRoom"
}
local CollectIconColor = LuaColor.New(0.9568627450980393, 0.592156862745098, 0.07058823529411765, 1)
local UncollectIconColor = LuaColor.New(0.06274509803921569, 0.34509803921568627, 0.6078431372549019, 1)

function HomeBlueprintDetailPanel:Init()
  local vd = self.viewdata and self.viewdata.viewdata
  if vd and vd.printItem then
    self.printItem = vd.printItem
    self.blueprintData = HomeBlueprintProxy.Instance:GetQueryPrintItemData(self.printItem)
    if self.blueprintData then
      self.printItem = nil
    end
  else
    self.blueprintData = vd
  end
  self.tipData = {}
  self:FindObjs()
  self:AddListenEvts()
  if self.printItem and not self.blueprintData then
    HomeBlueprintProxy.Instance:QueryPrintItem(self.printItem)
  end
end

function HomeBlueprintDetailPanel:FindObjs()
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    if FunctionPlayerTip.Me():CurPlayerTip() then
      FunctionPlayerTip.Me():CloseTip()
      return
    end
    if self.noClose then
      return
    end
    self:CloseSelf()
  end)
  self.photoTex = self:FindComponent("PhotoTex", UITexture)
  self.originWidth = self.photoTex.width
  self.originHeight = self.photoTex.height
  self.progress = self:FindComponent("Progress", UILabel)
  self.progress.gameObject:SetActive(false)
  self.headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.headContainer)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(4)
  self:AddClickEvent(self.headIcon.clickObj.gameObject, function()
    self:OnHeadIconClick()
  end)
  self.careerBg = self:FindGO("CareerBg")
  self.profession = self:FindComponent("ProfessionIcon", UISprite)
  self.colorIcon = self:FindComponent("Color", UISprite)
  self.hotGO = self:FindGO("HotSp")
  self.hotLabel = self:FindComponent("Hot", UILabel)
  self.likeBtn = self:FindGO("LikeBtn")
  self:AddClickEvent(self.likeBtn, function()
    self:OnLikeBtnClick()
  end)
  self.likeNum = self:FindComponent("LikeNum", UILabel)
  self.likeIcon = self:FindGO("LikeIcon")
  local collectBtnGO = self:FindGO("collectBtn")
  self.collectBtn = collectBtnGO:GetComponent(UIMultiSprite)
  self.collectIcon = self:FindComponent("collectIcon", UISprite, collectBtnGO)
  self:AddClickEvent(collectBtnGO, function()
    self:OnCollectBtnClick()
  end)
  self.shareToChatBtn = self:FindGO("shareToChatBtn")
  self:AddClickEvent(self.shareToChatBtn, function()
    self:OnShareToChatBtnClick()
  end)
  self.shareBtn = self:FindGO("shareBtn")
  self:AddClickEvent(self.shareBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    if not BranchMgr.IsChina() and not BranchMgr.IsJapan() then
      self:sharePicture("fb", "", "")
      return
    end
    self:Show(self.goUIViewSocialShare)
  end)
  self.confirmBtn = self:FindGO("confirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    if self.noClose then
      return
    end
    self:savePicture()
  end)
  self.saveToAlbumBtn = self:FindGO("saveToAlbumBtn")
  self:AddClickEvent(self.saveToAlbumBtn, function()
    if self.toUploadIndex ~= nil then
      MsgManager.ShowMsgByIDTable(991)
    else
      self:saveToPhotoAlbum()
    end
  end)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:ROOShare()
  self.background = self:FindGO("background")
  self.backgroundAnchor = self.background:GetComponent(UISprite)
  self.anchorBtn = self:FindGO("buttom_Btn")
  self.anchorBtnWidget = self.anchorBtn:GetComponent(UIWidget)
  self.backgroundButtonIcon = self:FindGO("GameObject")
  self.backgroundButtonIconAnchor = self.backgroundButtonIcon:GetComponent(UIWidget)
end

function HomeBlueprintDetailPanel:AddListenEvts()
  self:AddListenEvt(ServiceEvent.ChatCmdQueryUserInfoChatCmd, self.HandleQueryUserInfo)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryPrintItem, self.HandleQueryPrintItem)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadProgress, self.OnPhotoDownloadProgress)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadFinish, self.OnPhotoDownloadFinish)
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.OnSocialDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.OnSocialDataUpdate)
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.OnPrintUpdateHomeCmd)
  self:AddListenEvt(ServiceEvent.ChatCmdChatRetCmd, self.RecvChatRetCmd)
  self:AddListenEvt(ServiceEvent.PhotoCmdPhotoUpdateNtf, self.PhotoCmdPhotoUpdateNtf)
end

function HomeBlueprintDetailPanel:PhotoCmdPhotoUpdateNtf(note)
  local data = note.body
  if data.opttype == PhotoCmd_pb.EPHOTOOPTTYPE_REPLACE or data.opttype == PhotoCmd_pb.EPHOTOOPTTYPE_ADD then
    self.noClose = false
    self:startUploadPhoto(data.photo.index, data.photo.time)
  end
end

function HomeBlueprintDetailPanel:OnSocialDataUpdate()
  if self.targetSelectPopup then
    self.targetSelectPopup:TryUpdateFriendList()
  end
end

function HomeBlueprintDetailPanel:OnEnter()
  HomeBlueprintDetailPanel.super.OnEnter(self)
  self:RefreshBlueprintData()
end

function HomeBlueprintDetailPanel:RefreshBlueprintData()
  local data = self.blueprintData
  if not data then
    return
  end
  if data.isOfficial then
    self:OnEnterOfficial(data)
  else
    self:OnEnterNonOfficial(data)
  end
  self:RefreshCollectState()
  self:QueryBlueprintUserInfo()
end

function HomeBlueprintDetailPanel:QueryBlueprintUserInfo()
  if self.blueprintData and not self.blueprintData.isOfficial then
    local charId = self.blueprintData.charId
    if self.hasQueryBlueprintUserInfo and self.queryBlueprintUserInfoCharId == charId then
      return
    end
    self.hasQueryBlueprintUserInfo = true
    self.queryBlueprintUserInfoCharId = charId
    ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(charId, nil, ChatCmd_pb.EUSERINFOTYPE_HOME)
  end
end

function HomeBlueprintDetailPanel:OnEnterOfficial(data)
  if data.bpName and self.photoTex then
    PictureManager.Instance:SetHomeBluePrint(data.bpName, self.photoTex)
  end
  self.hotGO:SetActive(false)
  self.shareToChatBtn:SetActive(false)
  self.shareBtn:SetActive(false)
  self.headContainer:SetActive(false)
  self.careerBg:SetActive(false)
  self.likeNum.text = data.likeNum or 0
  self.likeIcon:SetActive(data.isLike == true)
end

function HomeBlueprintDetailPanel:OnEnterNonOfficial(data)
  local photoId = data.photoId
  local urlPath = data:GetPhotoUrl()
  if not photoId or not urlPath then
    LogUtility.Error("[HomeBlueprintDetailPanel] Missing photoId or urlPath")
    return
  end
  local photoKey = data:GetPhotoKey()
  FunctionPhotoStorage.Me():GetHomePhoto(FunctionPhotoStorage.PhotoType.HomeBlueprint, photoId, data.timeStamp or 0, false, urlPath, photoKey, nil, nil, photoKey)
  self.hotGO:SetActive(0 < (data.hot or 0))
  self.hotLabel.text = data.hot or 0
  local isViolation = data.isViolation == true
  self.likeBtn:SetActive(not isViolation)
  self.likeNum.gameObject:SetActive(not isViolation)
  self.likeIcon:SetActive(not isViolation and data.isLike)
  if isViolation then
    self.shareBtn:SetActive(false)
    self.shareToChatBtn:SetActive(false)
  end
  if not isViolation then
    self.likeNum.text = data.likeNum
  end
end

function HomeBlueprintDetailPanel:OnExit()
  local data = self.blueprintData
  if data and data.isOfficial and data.bpName and self.photoTex then
    PictureManager.Instance:UnLoadHomeBluePrint(data.bpName, self.photoTex)
  end
  HomeBlueprintDetailPanel.super.OnExit(self)
end

function HomeBlueprintDetailPanel:OnPhotoDownloadProgress(note)
  local data = note and note.body
  if not data then
    return
  end
  if data.type ~= FunctionPhotoStorage.PhotoType.HomeBlueprint or data.isThumb then
    return
  end
  local itemData = self.blueprintData
  if not itemData then
    return
  end
  if data.index ~= itemData.photoId or itemData:GetPhotoKey() ~= data.customParam then
    return
  end
  self:UpdateProgress(data.progress)
end

function HomeBlueprintDetailPanel:OnPhotoDownloadFinish(note)
  local data = note and note.body
  if not data then
    return
  end
  if data.type ~= FunctionPhotoStorage.PhotoType.HomeBlueprint or data.isThumb then
    return
  end
  local itemData = self.blueprintData
  if not itemData then
    return
  end
  if data.index ~= itemData.photoId or itemData:GetPhotoKey() ~= data.customParam then
    return
  end
  if data.byte then
    if self.progress then
      self.progress.gameObject:SetActive(false)
    end
    self:SetPhoto(data.byte)
  else
    LogUtility.Error(string.format("[HomeBlueprintDetailPanel] Download failed: %s", tostring(data.error)))
  end
end

function HomeBlueprintDetailPanel:UpdateProgress(progress)
  self.progress.gameObject:SetActive(true)
  progress = progress or 0
  if 1 < progress then
    progress = 1
  end
  if progress < 0 then
    progress = 0
  end
  local percent = NumberUtility.RoundToInt(progress * 100)
  self.progress.text = percent .. "%"
end

function HomeBlueprintDetailPanel:SetPhoto(bytes)
  if not bytes then
    return
  end
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self.canbeShare = true
    self:SetTexture(texture)
  else
    Object.DestroyImmediate(texture)
  end
end

function HomeBlueprintDetailPanel:SetTexture(texture)
  if not texture then
    return
  end
  local originWidth = self.originWidth or self.photoTex.width
  local originHeight = self.originHeight or self.photoTex.height
  local originRatio = originWidth / originHeight
  local textureRatio = texture.width / texture.height
  local useWidthRatio = math.min(originRatio, textureRatio) == originRatio
  local width = originWidth
  local height = originHeight
  if useWidthRatio then
    height = originWidth / textureRatio
  else
    width = originHeight * textureRatio
  end
  Object.DestroyImmediate(self.photoTex.mainTexture)
  self.photoTex.width = width
  self.photoTex.height = height
  self.photoTex.mainTexture = texture
  self:updatePhotoFrameAnchors()
end

function HomeBlueprintDetailPanel:updatePhotoFrameAnchors()
  if self.backgroundAnchor then
    self.backgroundAnchor:UpdateAnchors()
  end
  if self.anchorBtnWidget then
    self.anchorBtnWidget:UpdateAnchors()
  end
  if self.backgroundButtonIconAnchor then
    self.backgroundButtonIconAnchor:UpdateAnchors()
  end
end

function HomeBlueprintDetailPanel:HandleQueryUserInfo(note)
  local data = note.body
  if not data then
    return
  end
  local info = data.info
  if not info then
    return
  end
  info.guid = info.charid
  local playerData = PlayerData.CreateAsTable(info)
  self.playerData = playerData
  local datas = info.datas
  if datas then
    for i = 1, #datas do
      local celldata = datas[i]
      if celldata ~= nil then
        self.playerData.userdata:SetByID(celldata.type, celldata.value, celldata.data)
      end
    end
  end
  self:UpdateHeadIcon()
end

function HomeBlueprintDetailPanel:HandleQueryPrintItem(note)
  if not self.printItem then
    return
  end
  local itemData = HomeBlueprintProxy.Instance:GetQueryPrintItemData(self.printItem)
  redlog("HomeBlueprintDetailPanel:HandleQueryPrintItem", tostring(itemData))
  if not itemData then
    return
  end
  self.blueprintData = itemData
  self.printItem = nil
  self:RefreshBlueprintData()
end

function HomeBlueprintDetailPanel:UpdateHeadIcon()
  if not self.playerData then
    return
  end
  local headImageData = HeadImageData.new()
  headImageData:TransByPlayerData(self.playerData)
  local profession = headImageData.profession
  local config = Table_Class[profession]
  if config then
    IconManager:SetNewProfessionIcon(config.icon, self.profession)
    local colorKey = "CareerIconBg" .. config.Type
    self.colorIcon.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
  end
  local iconData = headImageData.iconData
  if iconData.type == HeadImageIconType.Avatar then
    self.headIcon:SetData(iconData)
  elseif iconData.type == HeadImageIconType.Simple then
    self.headIcon:SetSimpleIcon(iconData.icon, iconData.frameType)
    self.headIcon:SetPortraitFrame(iconData.portraitframe)
  end
end

function HomeBlueprintDetailPanel:OnHeadIconClick()
  if not self.playerData then
    return
  end
  FunctionPlayerTip.Me():CloseTip()
  local player = PlayerTipData.new()
  player:SetByPlayerData(self.playerData)
  TableUtility.TableClear(self.tipData)
  self.tipData.playerData = player
  self.tipData.funckeys = FriendProxy.Instance:IsFriend(self.playerData.id) and playerTipFunc_Friend or playerTipFunc
  local tip = FunctionPlayerTip.Me():GetPlayerTip(self.headIcon.clickObj, NGUIUtil.AnchorSide.Top, {0, 100}, self.tipData)
  if tip then
    tip.closecomp.callBack = nil
  end
end

function HomeBlueprintDetailPanel:ParsePrintActionParam()
  local data = self.blueprintData
  if not data or not data.photoId then
    return nil
  end
  return {
    id = data.photoId,
    etype = data.houseType,
    is_offical = data.isOfficial,
    accid = data.accId
  }
end

function HomeBlueprintDetailPanel:RefreshCollectState()
  local data = self.blueprintData
  local isCollection = data and data.isCollection == true
  if self.collectBtn then
    self.collectBtn.CurrentState = isCollection and 1 or 0
  end
  if self.collectIcon then
    self.collectIcon.color = isCollection and CollectIconColor or UncollectIconColor
  end
end

function HomeBlueprintDetailPanel:UpdateCollectStateByPrintUpdate(data)
  local itemData = self.blueprintData
  if not (itemData and data) or not data.items then
    return
  end
  local action = data.action
  local isCollection
  if action == HomeCmd_pb.EPRINTACTION_COLLECT_IN then
    isCollection = true
  elseif action == HomeCmd_pb.EPRINTACTION_COLLECT_OUT then
    isCollection = false
  else
    return
  end
  local proxy = HomeBlueprintProxy.Instance
  for i = 1, #data.items do
    local serverData = proxy:_ParsePrintItemServerData(data.items[i])
    if serverData and serverData.id and proxy:_IsSamePrintItem(itemData, serverData.id, serverData) then
      itemData.isCollection = isCollection
      return
    end
  end
end

function HomeBlueprintDetailPanel:OnPrintUpdateHomeCmd(note)
  local data = note and note.body
  if not data then
    return
  end
  local action = data.action
  if action == HomeCmd_pb.EPRINTACTION_COLLECT_IN or action == HomeCmd_pb.EPRINTACTION_COLLECT_OUT then
    self:UpdateCollectStateByPrintUpdate(data)
    self:RefreshCollectState()
  end
end

function HomeBlueprintDetailPanel:OnCollectBtnClick()
  local data = self.blueprintData
  if not data then
    return
  end
  local param = self:ParsePrintActionParam()
  if not param then
    return
  end
  if not data.isCollection then
    local collectionNum = HomeBlueprintProxy.Instance:GetCollectionNum()
    local maxCollectNum = GameConfig.HomeBlueprint and GameConfig.HomeBlueprint.Limit and GameConfig.HomeBlueprint.Limit.MaxCollect or 20
    if collectionNum >= maxCollectNum then
      MsgManager.ShowMsgByID(43678)
      return
    end
  end
  local action = data.isCollection and HomeCmd_pb.EPRINTACTION_COLLECT_OUT or HomeCmd_pb.EPRINTACTION_COLLECT_IN
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(action, param)
end

function HomeBlueprintDetailPanel:OnShareToChatBtnClick()
  if not self.blueprintData then
    return
  end
  if not self.targetSelectPopup then
    self.targetSelectPopup = self:AddSubView("PostcardTargetSelectPopup", PostcardTargetSelectPopup)
  end
  self.targetSelectPopup:Show()
  self.targetSelectPopup:UpdateOnSelectTab()
end

function HomeBlueprintDetailPanel:Sender_SetTarget(data)
  if not data or not self.blueprintData then
    return
  end
  local bp = self.blueprintData
  local linkText = string.format(ZhString.HomeBluePrint_ShareChatText, bp.userName, bp.homeName)
  local printItem = ChatRoomProxy.Instance:BuildBlueprintPrintItem(bp)
  ServiceChatCmdProxy.Instance:CallChatCmd(ChatChannelEnum.Private, linkText, data.guid, nil, nil, nil, nil, nil, nil, nil, printItem)
end

function HomeBlueprintDetailPanel:RecvChatRetCmd(note)
  local data = note and note.body
  local printItem = data and data:GetPrintItem()
  local blueprintId = self.blueprintData and self.blueprintData.photoId
  if blueprintId and blueprintId ~= 0 and printItem and printItem.id == blueprintId then
    MsgManager.ShowMsgByIDTable(43187)
  end
end

function HomeBlueprintDetailPanel:saveToPhotoAlbum()
  local isFull = PhotoDataProxy.Instance:isPhotoAlbumFull()
  local isOutOfBounds = PhotoDataProxy.Instance:isPhotoAlbumOutofbounds()
  if isOutOfBounds then
    MsgManager.ShowMsgByIDTable(994)
  elseif isFull then
    local func = function(index)
      ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REPLACE, index, 0, Game.MapManager:GetMapID())
      self.toUploadIndex = index
      self.noClose = true
      MsgManager.ShowMsgByIDTable(991)
    end
    PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
    local viewdata = {
      ShowMode = PersonalPicturePanel.ShowMode.ReplaceMode,
      callback = func
    }
    MsgManager.ShowMsgByIDTable(994)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PersonalPicturePanel,
      viewdata = viewdata
    })
  else
    MsgManager.ShowMsgByIDTable(991)
    self.toUploadIndex = PhotoDataProxy.Instance:getEmptyCellIndex()
    ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_ADD, self.toUploadIndex, 0, Game.MapManager:GetMapID())
    self.noClose = true
  end
end

function HomeBlueprintDetailPanel:startUploadPhoto(index, time)
  PersonalPictureManager.Instance():saveToPhotoAlbum(self.photoTex.mainTexture, index, time)
end

function HomeBlueprintDetailPanel:savePicture()
  local result = PermissionUtil.Access_SavePicToMediaStorage()
  if result and self.photoTex and self.photoTex.mainTexture then
    local picName = HomeBlueprintDetailPanel.picNameName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
    ScreenShot.SaveJPG(self.photoTex.mainTexture, path, 100)
    path = path .. ".jpg"
    if BranchMgr.IsJapan() and RuntimePlatform.IPhonePlayer == Application.platform then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      overseasManager:SetSavePhotoCallback(function(msg)
        ROFileUtils.FileDelete(path)
        if msg ~= "1" then
          MsgManager.FloatMsg("", OverseaHostHelper.SAVE_FAILED)
        end
      end)
    end
    FunctionSaveToDCIM.Me():TrySavePicToDCIM(path)
    self:CloseSelf()
  end
end

function HomeBlueprintDetailPanel:sharePicture(platform_type, content_title, content_body)
  if not self.canbeShare then
    return false
  end
  if not self.photoTex or not self.photoTex.mainTexture then
    MsgManager.FloatMsg(nil, ZhString.ShareAwardView_EmptyPath)
    return false
  end
  local picName = HomeBlueprintDetailPanel.picNameName .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
  ScreenShot.SaveJPG(self.photoTex.mainTexture, path, 100)
  path = path .. ".jpg"
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
  end, function(failCode, failMsg)
    ROFileUtils.FileDelete(path)
    local errorMessage = failMsg or "error"
    if failCode ~= nil then
      errorMessage = failCode .. ", " .. errorMessage
    end
    MsgManager.ShowMsg("", errorMessage, 0)
  end, function()
    ROFileUtils.FileDelete(path)
  end)
  return true
end

function HomeBlueprintDetailPanel:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local goCloseShareButton = self:FindGO("closeShare", self.goUIViewSocialShare)
  self:AddClickEvent(goCloseShareButton, function()
    self:Hide(self.goUIViewSocialShare)
  end)
  local enable = FloatAwardView.ShareFunctionIsOpen()
  if not enable then
    self:Hide(self.shareBtn)
  end
end

function HomeBlueprintDetailPanel:RegisterButtonClickEvent()
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:OnClickForButtonWechatMoments()
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:OnClickForButtonWechat()
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:OnClickForButtonQQ()
  end)
  self:AddClickEvent(self.goButtonSina, function()
    self:OnClickForButtonSina()
  end)
end

function HomeBlueprintDetailPanel:ROOShare()
  if BranchMgr.IsChina() then
    return
  end
  local sp = self.goButtonQQ:GetComponent(UISprite)
  IconManager:SetUIIcon("Facebook", sp)
  sp = self.goButtonWechat:GetComponent(UISprite)
  IconManager:SetUIIcon("Twitter", sp)
  if BranchMgr.IsJapan() then
    self:Hide(self.goButtonWechat)
  end
  sp = self.goButtonWechatMoments:GetComponent(UISprite)
  IconManager:SetUIIcon("line", sp)
  GameObject.Destroy(self.goButtonSina)
  self:AddClickEvent(self.goButtonWechatMoments, function()
    self:sharePicture("line", "", "")
  end)
  self:AddClickEvent(self.goButtonWechat, function()
    self:sharePicture("twitter", OverseaHostHelper.TWITTER_MSG, "")
  end)
  self:AddClickEvent(self.goButtonQQ, function()
    self:sharePicture("fb", "", "")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
end

function HomeBlueprintDetailPanel:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    local result = self:sharePicture(E_PlatformType.WechatMoments, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function HomeBlueprintDetailPanel:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    local result = self:sharePicture(E_PlatformType.Wechat, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function HomeBlueprintDetailPanel:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    local result = self:sharePicture(E_PlatformType.QQ, "", "")
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function HomeBlueprintDetailPanel:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    local result = self:sharePicture(E_PlatformType.Sina, "", contentBody)
    if result then
      self:CloseSelf()
    else
      MsgManager.ShowMsgByID(559)
    end
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end

function HomeBlueprintDetailPanel:OnLikeBtnClick()
  local data = self.blueprintData
  if not data then
    return
  end
  local param = self:ParsePrintActionParam()
  if not param then
    return
  end
  local action = data.isLike and HomeCmd_pb.EPRINTACTION_UNPRAISE or HomeCmd_pb.EPRINTACTION_PRAISE
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(action, param)
end
