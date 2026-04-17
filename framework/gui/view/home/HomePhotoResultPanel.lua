HomePhotoResultPanel = class("HomePhotoResultPanel", ContainerView)
HomePhotoResultPanel.ViewType = UIViewType.PopUpLayer
HomePhotoResultPanel.picNameName = "RO_Picture"
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}

function HomePhotoResultPanel:Init()
  self.recommendItemData = self.viewdata and self.viewdata.viewdata
  self.tipData = {}
  self:FindObjs()
  self:AddListenEvts()
  if self.recommendItemData then
    ServiceChatCmdProxy.Instance:CallQueryUserInfoChatCmd(self.recommendItemData.charId, nil, ChatCmd_pb.EUSERINFOTYPE_HOME)
  end
end

function HomePhotoResultPanel:FindObjs()
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    if FunctionPlayerTip.Me():CurPlayerTip() then
      FunctionPlayerTip.Me():CloseTip()
      return
    end
    self:CloseSelf()
  end)
  self.photoTex = self:FindComponent("PhotoTex", UITexture)
  self.originWidth = self.photoTex.width
  self.originHeight = self.photoTex.height
  self.progress = self:FindComponent("Progress", UILabel)
  self.progress.gameObject:SetActive(false)
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon:SetScale(0.6)
  self.headIcon:SetMinDepth(4)
  self:AddClickEvent(self.headIcon.clickObj.gameObject, function()
    self:OnHeadIconClick()
  end)
  self.careerBg = self:FindGO("CareerBg")
  self.profession = self:FindComponent("ProfessionIcon", UISprite)
  self.colorIcon = self:FindComponent("Color", UISprite)
  self.hotLabel = self:FindComponent("Hot", UILabel)
  self.confirmBtn = self:FindGO("confirmBtn")
  self:AddClickEvent(self.confirmBtn, function(go)
    self:savePicture()
    self:CloseSelf()
  end)
  self.saveToAlbumBtn = self:FindGO("saveToAlbumBtn")
  self:AddClickEvent(self.saveToAlbumBtn, function()
    if self.toUploadIndex ~= nil then
      MsgManager.ShowMsgByIDTable(991)
    else
      self:saveToPhotoAlbum()
    end
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
  self.gotoBtn = self:FindGO("gotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    if not self.recommendItemData then
      return
    end
    local houseType = self.recommendItemData.photoId
    redlog("HomePhotoResultPanel:OnClickGotoBtn houseType = " .. tostring(houseType), "accId = " .. tostring(self.recommendItemData.accId), "charId = " .. tostring(self.recommendItemData.charId))
    ServiceHomeCmdProxy.Instance:CallEnterHomeCmd(self.recommendItemData.accId, self.recommendItemData.charId, houseType)
    self:sendNotification(HomeEvent.GotoHome)
    self:CloseSelf()
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

function HomePhotoResultPanel:AddListenEvts()
  self:AddListenEvt(ServiceEvent.ChatCmdQueryUserInfoChatCmd, self.HandleQueryUserInfo)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadProgress, self.OnPhotoDownloadProgress)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadFinish, self.OnPhotoDownloadFinish)
end

function HomePhotoResultPanel:OnEnter()
  local data = self.recommendItemData
  if not data then
    return
  end
  local photoType = FunctionPhotoStorage.PhotoType.HomeRecommend
  local photoId = data.photoId
  local timeStamp = data.timeStamp or 0
  local urlPath = data:GetPhotoUrl()
  if not photoId or not urlPath then
    LogUtility.Error("[HomePhotoResultPanel] Missing photoId or urlPath")
    return
  end
  FunctionPhotoStorage.Me():GetHomePhoto(photoType, photoId, timeStamp, false, urlPath, data.index, nil, nil, data.index)
  self.hotLabel.text = data.hot
end

function HomePhotoResultPanel:OnPhotoDownloadProgress(note)
  local data = note and note.body
  if not data then
    return
  end
  if data.type ~= FunctionPhotoStorage.PhotoType.HomeRecommend or data.isThumb then
    return
  end
  local itemData = self.recommendItemData
  if not itemData then
    return
  end
  if data.index ~= itemData.photoId or data.customParam ~= itemData.index then
    return
  end
  self:UpdateProgress(data.progress)
end

function HomePhotoResultPanel:OnPhotoDownloadFinish(note)
  local data = note and note.body
  if not data then
    return
  end
  if data.type ~= FunctionPhotoStorage.PhotoType.HomeRecommend or data.isThumb then
    return
  end
  local itemData = self.recommendItemData
  if not itemData then
    return
  end
  if data.index ~= itemData.photoId or data.customParam ~= itemData.index then
    return
  end
  if data.byte then
    if self.progress then
      self.progress.gameObject:SetActive(false)
    end
    self:SetPhoto(data.byte)
  else
    LogUtility.Error(string.format("[HomePhotoResultPanel] Download failed: %s", tostring(data.error)))
  end
end

function HomePhotoResultPanel:UpdateProgress(progress)
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

function HomePhotoResultPanel:SetPhoto(bytes)
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

function HomePhotoResultPanel:SetTexture(texture)
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

function HomePhotoResultPanel:updatePhotoFrameAnchors()
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

function HomePhotoResultPanel:HandleQueryUserInfo(note)
  redlog("HomePhotoResultPanel:HandleQueryUserInfo")
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
  redlog("HomePhotoResultPanel:HandleQueryUserInfo playerData.id = " .. tostring(playerData.id), "playerData.name = " .. tostring(playerData.name))
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

function HomePhotoResultPanel:UpdateHeadIcon()
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
  self.headIcon:SetData(headImageData.iconData)
end

function HomePhotoResultPanel:OnHeadIconClick()
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

function HomePhotoResultPanel:saveToPhotoAlbum()
  local isFull = PhotoDataProxy.Instance:isPhotoAlbumFull()
  local isOutOfBounds = PhotoDataProxy.Instance:isPhotoAlbumOutofbounds()
  if isOutOfBounds then
    MsgManager.ShowMsgByIDTable(994)
  elseif isFull then
    local func = function(index)
      local anglez = self.anglez or 0
      local mapId = self.currentMapID or Game.MapManager:GetMapID()
      ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_REPLACE, index, anglez, mapId)
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
    local anglez = self.anglez or 0
    local mapId = self.currentMapID or Game.MapManager:GetMapID()
    ServicePhotoCmdProxy.Instance:CallPhotoOptCmd(PhotoCmd_pb.EPHOTOOPTTYPE_ADD, self.toUploadIndex, anglez, mapId)
    self.noClose = true
  end
end

function HomePhotoResultPanel:savePicture()
  local result = PermissionUtil.Access_SavePicToMediaStorage()
  if result and self.photoTex and self.photoTex.mainTexture then
    local picName = HomePhotoResultPanel.picNameName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
    ScreenShot.SaveJPG(self.photoTex.mainTexture, path, 100)
    path = path .. ".jpg"
    if BranchMgr.IsJapan() and RuntimePlatform.IPhonePlayer == Application.platform then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      overseasManager:SetSavePhotoCallback(function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg ~= "1" then
          MsgManager.FloatMsg("", OverseaHostHelper.SAVE_FAILED)
        end
      end)
    end
    FunctionSaveToDCIM.Me():TrySavePicToDCIM(path)
  end
end

function HomePhotoResultPanel:sharePicture(platform_type, content_title, content_body)
  if not self.canbeShare then
    return false
  end
  if not self.photoTex or not self.photoTex.mainTexture then
    MsgManager.FloatMsg(nil, ZhString.ShareAwardView_EmptyPath)
    return false
  end
  local picName = HomePhotoResultPanel.picNameName .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
  ScreenShot.SaveJPG(self.photoTex.mainTexture, path, 100)
  path = path .. ".jpg"
  self:Log("sharePicture pic path:", path)
  if not BranchMgr.IsChina() then
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    if platform_type ~= "fb" then
      overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg ~= "1" then
          MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
        end
      end)
      return true
    end
    xdlog("startSharePicture", "fb 分享图片")
    overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
      redlog("msg" .. msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
      end
    end)
    return true
  end
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    self:Log("SocialShare.Instance:Share success")
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
    self:Log("SocialShare.Instance:Share failure", errorMessage)
    MsgManager.ShowMsg("", errorMessage, 0)
  end, function()
    self:Log("SocialShare.Instance:Share cancel")
    ROFileUtils.FileDelete(path)
  end)
  return true
end

function HomePhotoResultPanel:GetGameObjects()
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

function HomePhotoResultPanel:RegisterButtonClickEvent()
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

function HomePhotoResultPanel:ROOShare()
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

function HomePhotoResultPanel:OnClickForButtonWechatMoments()
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

function HomePhotoResultPanel:OnClickForButtonWechat()
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

function HomePhotoResultPanel:OnClickForButtonQQ()
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

function HomePhotoResultPanel:OnClickForButtonSina()
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
