ScenerytDetailPanel = class("ScenerytDetailPanel", ContainerView)
ScenerytDetailPanel.ViewType = UIViewType.PopUpLayer
autoImport("PermissionUtil")

function ScenerytDetailPanel:Init()
  self:initView()
  self:initData()
  self:AddEventListener()
  self:AddViewEvts()
end

function ScenerytDetailPanel:AddViewEvts()
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(MySceneryPictureManager.MySceneryOriginPhotoDownloadProgressCallback, self.photoProgressCallback)
end

function ScenerytDetailPanel:photoCompleteCallback(note)
  local data = note.body
  if self.index == data.index then
    self:completeCallback(data.byte)
    self:setPhotoFrameDecorateActive(true)
    self:UpdatePhotoFrameAnchors()
  end
end

function ScenerytDetailPanel:photoProgressCallback(note)
  local data = note.body
  if self.index == data.index then
    self:progressCallback(data.progress)
  end
end

function ScenerytDetailPanel:initData()
  self.scenicSpotData = self.viewdata.scenicSpotData
  self.PhotoData = PhotoData.new(self.scenicSpotData, PhotoDataProxy.PhotoType.SceneryPhotoType)
  self.index = self.scenicSpotData.staticId
  self.adventureValue.text = self.scenicSpotData:getAdventureValue()
  local icon = self:FindGO("icon"):GetComponent(UISprite)
  self.canbeShare = false
  local bg = self:FindGO("background"):GetComponent(UISprite)
  self:initDefaultTextureSize()
  self:setPhotoFrameDecorateActive(false)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self:getPhoto()
  end, self)
end

function ScenerytDetailPanel:initView()
  self.photo = self:FindGO("photo"):GetComponent(UITexture)
  self.adventureValue = self:FindGO("adventureValue"):GetComponent(UILabel)
  self.noneTxIcon = self:FindGO("noneTxIcon"):GetComponent(UISprite)
  self.progress = self:FindGO("loadProgress"):GetComponent(UILabel)
  self:Hide(self.progress.gameObject)
  self.confirmBtn = self:FindGO("confirmBtn")
  self.background = self:FindGO("background")
  self.buttomBtns = self:FindGO("buttom_Btns")
  self.decorate = self:FindGO("decorate")
  self.comfirmBtn = self:FindGO("Anchor_CompareBtn")
  self.backgroundAnchor = self:FindGO("background"):GetComponent(UISprite)
  self.backgroundIconAnchor = self:FindGO("GameObject"):GetComponent(UIWidget)
  self.buttomBtnAnchor = self:FindGO("buttom_Btns"):GetComponent(UIWidget)
  self.boli1Anchor = self:FindGO("boli1"):GetComponent(UISprite)
  self.boli2Anchor = self:FindGO("boli2"):GetComponent(UISprite)
  self.comfirmBtnAnchor = self:FindGO("Anchor_CompareBtn"):GetComponent(UIWidget)
  self.shareBtn = self:FindGO("shareBtn")
  self.closeShare = self:FindGO("closeShare")
  self:AddClickEvent(self.closeShare, function()
    self:Hide(self.goUIViewSocialShare)
  end)
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
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:ROOShare()
end

function ScenerytDetailPanel:ROOShare()
  if BranchMgr.IsChina() then
    return
  end
  local sp = self.goButtonQQ:GetComponent(UISprite)
  IconManager:SetUIIcon("Facebook", sp)
  sp = self.goButtonWechat:GetComponent(UISprite)
  IconManager:SetUIIcon("Twitter", sp)
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

function ScenerytDetailPanel:initDefaultTextureSize()
  self.originWith = self.photo.width
  self.originHeight = self.photo.height
end

function ScenerytDetailPanel:setTexture(texture)
  local orginRatio = self.originWith / self.originHeight
  local textureRatio = texture.width / texture.height
  local wRatio = math.min(orginRatio, textureRatio) == orginRatio
  local height = self.originHeight
  local width = self.originWith
  if wRatio then
    height = self.originWith / textureRatio
  else
    width = self.originHeight * textureRatio
  end
  Object.DestroyImmediate(self.photo.mainTexture)
  self.photo.width = width
  self.photo.height = height
  self.photo.mainTexture = texture
  self.texture = texture
end

function ScenerytDetailPanel:AddEventListener()
  self:AddClickEvent(self.confirmBtn, function(go)
    if self.texture then
      local result = PermissionUtil.Access_SavePicToMediaStorage()
      if result then
        local picName = "RO_" .. tostring(os.time())
        local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
        ScreenShot.SaveJPG(self.texture, path, 100)
        FunctionSaveToDCIM.Me():TrySavePicToDCIM(path .. ".jpg")
      end
    end
    self:CloseSelf()
  end)
  self:AddButtonEvent("closeBtn", function(go)
    self:CloseSelf()
  end)
end

function ScenerytDetailPanel:setPhotoFrameDecorateActive(bool)
  self.background.gameObject:SetActive(bool)
  self.buttomBtns.gameObject:SetActive(bool)
  self.decorate.gameObject:SetActive(bool)
end

function ScenerytDetailPanel:UpdatePhotoFrameAnchors()
  self.backgroundAnchor:UpdateAnchors()
  self.backgroundIconAnchor:UpdateAnchors()
  self.buttomBtnAnchor:UpdateAnchors()
  self.boli1Anchor:UpdateAnchors()
  self.boli2Anchor:UpdateAnchors()
  self.comfirmBtnAnchor:UpdateAnchors()
end

function ScenerytDetailPanel:getPhoto()
  local tBytes = ScenicSpotPhotoNew.Ins():TryGetThumbnailFromLocal_Share(self.index, self.PhotoData.time)
  if tBytes then
    self:completeCallback(tBytes, true)
  end
  MySceneryPictureManager.Instance():tryGetMySceneryOriginImage(self.PhotoData.roleId, self.index, self.PhotoData.time)
end

function ScenerytDetailPanel:sharePicture(platform_type, content_title, content_body)
  if self.canbeShare then
    local path = ScenicSpotPhotoNew.Ins():GetLocalAbsolutePath_Share(self.index, true)
    self:Log("sharePicture pic path:", path)
    if path then
      if not BranchMgr.IsChina() then
        local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
        if platform_type ~= "fb" then
          overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
            redlog("msg" .. msg)
            ROFileUtils.FileDelete(path)
            if msg == "1" then
              Debug.Log("success")
            else
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
        if platform_type == E_PlatformType.Sina then
          MsgManager.ShowMsgByIDTable(566)
        end
      end, function(failCode, failMsg)
        self:Log("SocialShare.Instance:Share failure")
        local errorMessage = failMsg or "error"
        if failCode ~= nil then
          errorMessage = failCode .. ", " .. errorMessage
        end
        MsgManager.ShowMsg("", errorMessage, 0)
      end, function()
        self:Log("SocialShare.Instance:Share cancel")
      end)
    else
      MsgManager.FloatMsg(nil, ZhString.ShareAwardView_EmptyPath)
    end
    return true
  end
  return false
end

function ScenerytDetailPanel:progressCallback(progress)
  self:Show(self.progress.gameObject)
  progress = 1 <= progress and 1 or progress
  local value = progress * 100
  value = math.floor(value)
  self.progress.text = value .. "%"
end

function ScenerytDetailPanel:completeCallback(bytes, thumbnail)
  if not thumbnail then
    self:Hide(self.progress.gameObject)
  end
  self.isThumbnail = thumbnail
  if bytes then
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      self.canbeShare = not thumbnail
      self:setTexture(texture)
    else
      Object.DestroyImmediate(texture)
    end
  end
end

function ScenerytDetailPanel:OnExit()
  TimeTickManager.Me():ClearTick(self)
  Object.DestroyImmediate(self.photo.mainTexture)
end

function ScenerytDetailPanel:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  local enable = FloatAwardView.ShareFunctionIsOpen()
  if not enable then
    self:Hide(self.shareBtn)
  end
end

function ScenerytDetailPanel:RegisterButtonClickEvent()
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

function ScenerytDetailPanel:OnClickForButtonWechatMoments()
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

function ScenerytDetailPanel:OnClickForButtonWechat()
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

function ScenerytDetailPanel:OnClickForButtonQQ()
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

function ScenerytDetailPanel:OnClickForButtonSina()
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
