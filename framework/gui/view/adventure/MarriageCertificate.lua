MarriageCertificate = class("MarriageCertificate", ContainerView)
autoImport("Charactor")
autoImport("PicutureWallSyncPanel")
MarriageCertificate.ViewType = UIViewType.PopUpLayer
local tempVector3 = LuaVector3.Zero()
MarriageCertificate.BgTextureName = "marry_bg_bottom1"
MarriageCertificate.ProcessTextureName = "marry_bg_process"

function MarriageCertificate:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
end

function MarriageCertificate:AddViewEvts()
  self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadCompleteCallback, self.photoCompleteCallback)
  self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadProgressCallback, self.photoProgressCallback)
  self:AddListenEvt(WeddingWallPicManager.WeddingPicDownloadErrorCallback, self.photoErrorCallback)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCurPhoto)
end

function MarriageCertificate:ShowRedTip(note)
  local size = note.body
  if 0 < size then
    self:Show(self.redTip)
    self:ShowMsgAnim(note.body)
  else
    self:Hide(self.redTip)
  end
end

function MarriageCertificate:PhotoCmdFrameActionPhotoCmd(note)
end

function MarriageCertificate:UpdateCurPhoto(note)
  self:getPhoto()
end

function MarriageCertificate:changePhotoSize()
  local frameData = Table_ScenePhotoFrame[self.frameId]
  local dir = 0
  if frameData then
    dir = frameData.Dir
  end
  if dir == 1 then
    self.photo.width = 400
    self.photo.height = 600
  end
end

function MarriageCertificate:photoCompleteCallback(note)
  local data = note.body
  local id = data.id
  local index = data.index
  Game.WeddingWallPicManager:log("MarriageCertificate:photoCompleteCallback1", id, self.weddingData.id, self.weddingData.photoidx)
  if self.weddingData and id == self.weddingData.id and index == self.weddingData.photoidx then
    self:completeCallback(data.byte)
  end
end

function MarriageCertificate:photoProgressCallback(note)
  local data = note.body
  local id = data.id
  local index = data.index
  Game.WeddingWallPicManager:log("MarriageCertificate:photoCompleteCallback1", id, self.weddingData.id, self.weddingData.photoidx)
  if self.weddingData and id == self.weddingData.id and index == self.weddingData.photoidx then
    self:progressCallback(data.progress)
  end
end

function MarriageCertificate:photoErrorCallback(note)
  helplog("photoErrorCallback")
end

function MarriageCertificate:initData()
  self.data = self.viewdata.viewdata
  self.weddingData = self.data.weddingData or {}
  self:initDefaultTextureSize()
  self:initScreenShotData()
  if self.weddingData and self.weddingData.photoidx ~= 0 then
    self.loadReady = false
  else
    self:changePhotoSize()
  end
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    self:getPhoto()
  end, self)
  self:UpdateHead()
  local str = "%Y.%m.%d  %H:%M"
  str = os.date(str, self.weddingData.weddingtime)
  self.marriageTime.text = str
end

function MarriageCertificate:initView()
  self.photo = self:FindComponent("photo", UITexture)
  self.progress = self:FindComponent("loadProgress", UILabel)
  self:Hide(self.progress.gameObject)
  self.portrait_1 = self:FindGO("portrait_1")
  self.portrait_2 = self:FindGO("portrait_2")
  self.coupleName1 = self:FindComponent("coupleName1", UILabel)
  self.coupleName2 = self:FindComponent("coupleName2", UILabel)
  self.marriageTime = self:FindComponent("marriageTime", UILabel)
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self.shareBtn = self:FindGO("shareBtn")
  self:AddClickEvent(self.shareBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    if BranchMgr.IsChina() or BranchMgr.IsJapan() then
      self:Show(self.goUIViewSocialShare)
    else
      self:sharePicture("Facebook", "", "")
    end
  end)
  self.defPhoto = self:FindGO("defPhoto")
  self.defPhotoTx = self:FindComponent("defPhoto", UITexture)
  self.bgTx1 = self:FindComponent("Texture_1", UITexture)
  self.bgTx2 = self:FindComponent("Texture_2", UITexture)
  PictureManager.Instance:SetWedding(MarriageCertificate.ProcessTextureName, self.bgTx1)
  PictureManager.Instance:SetWedding(MarriageCertificate.ProcessTextureName, self.bgTx2)
  local shareLabel = self:FindComponent("shareLabel", UILabel)
  shareLabel.text = ZhString.WeddingPictureShareLabel
  self:AddButtonEvent("innerBg", function()
    PhotoDataProxy.Instance:setCurCertificateData(self.data)
    PicutureWallSyncPanel.ViewType = UIViewType.Lv4PopUpLayer
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PicutureWallSyncPanel,
      viewdata = {
        frameId = 0,
        from = PicutureWallSyncPanel.PictureSyncFrom.WeddingCertificate
      }
    })
  end)
  self.closeShare = self:FindGO("closeShare")
  self:AddClickEvent(self.closeShare, function()
    self:Hide(self.goUIViewSocialShare)
  end)
  if FloatAwardView.ShareFunctionIsOpen() then
    self:Show(self.shareBtn)
  else
    self:Hide(self.shareBtn)
  end
  self:ROOShare()
end

function MarriageCertificate:ROOShare()
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
    self:sharePicture("Facebook", "", "")
  end)
  local lbl = self:FindGO("Label", self.goButtonWechatMoments):GetComponent(UILabel)
  lbl.text = "LINE"
  lbl = self:FindGO("Label", self.goButtonWechat):GetComponent(UILabel)
  lbl.text = "Twitter"
  lbl = self:FindGO("Label", self.goButtonQQ):GetComponent(UILabel)
  lbl.text = "Facebook"
end

function MarriageCertificate:UpdateHead()
  if not self.targetCell1 then
    local headCellObj = self:FindGO("portrait_2")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = tempVector3
    self.targetCell1 = PlayerFaceCell.new(self.headCellObj)
    self.targetCell1:HideHpMp()
    self.targetCell1:HideLevel()
  end
  local infoData = WeddingProxy.Instance:GetWeddingInfo()
  if infoData then
    local id = infoData:GetPartnerGuid()
    local coupleData = WeddingProxy.Instance:GetPortraitInfo(id)
    local headData = HeadImageData.new()
    headData:TransByWeddingCharData(coupleData)
    self.coupleName2.text = coupleData.name
    self.targetCell1:SetData(headData)
  else
    helplog("没找到你老婆的头像数据")
  end
  if not self.targetCell2 then
    local headCellObj = self:FindGO("portrait_1")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = tempVector3
    self.targetCell2 = PlayerFaceCell.new(self.headCellObj)
    self.targetCell2:HideHpMp()
    self.targetCell2:HideLevel()
  end
  self.coupleName1.text = Game.Myself.data:GetName()
  headData = HeadImageData.new()
  headData:TransByMyself()
  headData.job = nil
  self.targetCell2:SetData(headData)
end

function MarriageCertificate:initDefaultTextureSize()
  self.originWith = self.photo.width
  self.originHeight = self.photo.height
end

function MarriageCertificate:setTexture(texture)
  local orginRatio = self.originWith / self.originHeight
  local textureRatio = 0
  textureRatio = texture.width / texture.height
  local wRatio = math.min(orginRatio, textureRatio) == orginRatio
  local height = self.originHeight
  local width = self.originWith
  if wRatio then
    height = self.originWith / textureRatio
  else
    width = self.originHeight * textureRatio
  end
  self.photo.width = width
  self.photo.height = height
  Object.DestroyImmediate(self.photo.mainTexture)
  self.photo.mainTexture = texture
end

function MarriageCertificate:getPhoto()
  if self.weddingData and self.weddingData.photoidx and self.weddingData.photoidx ~= 0 then
    helplog("getPhoto:", tostring(self.weddingData.photoidx), tostring(self.weddingData.photoidx))
    Game.WeddingWallPicManager:GetWeddingPicture(self.weddingData.photoidx, self.weddingData.phototime)
    PictureManager.Instance:UnLoadWedding(MarriageCertificate.BgTextureName, self.defPhotoTx)
    self:Hide(self.defPhoto)
  else
    self:Show(self.defPhoto)
    PictureManager.Instance:SetWedding(MarriageCertificate.BgTextureName, self.defPhotoTx)
  end
end

function MarriageCertificate:progressCallback(progress)
  self:Show(self.progress.gameObject)
  progress = 1 <= progress and 1 or progress
  local value = progress * 100
  value = math.floor(value)
  self.progress.text = value .. "%"
end

function MarriageCertificate:completeCallback(bytes)
  self:Hide(self.progress.gameObject)
  if bytes then
    local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
    local bRet = ImageConversion.LoadImage(texture, bytes)
    if bRet then
      self.loadReady = true
      self:setTexture(texture)
    else
      Object.DestroyImmediate(texture)
    end
  end
end

function MarriageCertificate:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
end

function MarriageCertificate:RegisterButtonClickEvent()
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

function MarriageCertificate:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function MarriageCertificate:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    self:sharePicture(E_PlatformType.Wechat, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function MarriageCertificate:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function MarriageCertificate:OnClickForButtonSina()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
    local contentBody = GameConfig.PhotographResultPanel_ShareDescription
    if contentBody == nil or #contentBody <= 0 then
      contentBody = "RO"
    end
    self:sharePicture(E_PlatformType.Sina, "", contentBody)
  else
    MsgManager.ShowMsgByIDTable(563)
  end
end

function MarriageCertificate:startSharePicture(texture, platform_type, content_title, content_body)
  local picName = "Ro_" .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
  ScreenShot.SaveJPG(texture, path, 100)
  path = path .. ".jpg"
  self:Log("MarriageCertificate sharePicture pic path:", path)
  if not BranchMgr.IsChina() then
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    if platform_type ~= "Facebook" then
      overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          Debug.Log("success")
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
        end
      end)
      return
    end
    xdlog("startSharePicture", "fb 分享图片")
    overseasManager:ShareImg(path, content_title, "", content_body, function(msg)
      ROFileUtils.FileDelete(path)
      if msg == "1" then
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
      else
        MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
      end
    end)
    return
  end
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    self:Log("SocialShare.Instance:Share success")
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
  end, function(failCode, failMsg)
    self:Log("SocialShare.Instance:Share failure")
    ROFileUtils.FileDelete(path)
    local errorMessage = failMsg or "error"
    if failCode ~= nil then
      errorMessage = failCode .. ", " .. errorMessage
    end
    MsgManager.ShowMsg("", errorMessage, 0)
  end, function()
    self:Log("SocialShare.Instance:Share cancel")
    ROFileUtils.FileDelete(path)
  end)
end

function MarriageCertificate:sharePicture(platform_type, content_title, content_body)
  self:startCaptureScreen(platform_type, content_title, content_body)
end

function MarriageCertificate:startCaptureScreen(platform_type, content_title, content_body)
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self:changeUIState(true)
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:changeUIState(false)
    self:startSharePicture(texture, platform_type, content_title, content_body)
  end, ui)
end

function MarriageCertificate:changeUIState(isStart)
  if isStart then
    if BranchMgr.IsChina() or BranchMgr.IsJapan() then
      self:Hide(self.goUIViewSocialShare)
    end
    self:Hide(self.closeBtn)
    self:Hide(self.shareBtn)
  else
    if BranchMgr.IsChina() or BranchMgr.IsJapan() then
      self:Show(self.goUIViewSocialShare)
    end
    self:Show(self.shareBtn)
    self:Show(self.closeBtn)
  end
end

function MarriageCertificate:initScreenShotData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function MarriageCertificate:OnExit()
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnLoadWedding(MarriageCertificate.BgTextureName, self.defPhotoTx)
  PictureManager.Instance:UnLoadWedding(MarriageCertificate.ProcessTextureName, self.bgTx1)
  PictureManager.Instance:UnLoadWedding(MarriageCertificate.ProcessTextureName, self.bgTx2)
  Object.DestroyImmediate(self.photo.mainTexture)
end
