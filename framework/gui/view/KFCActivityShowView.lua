KFCActivityShowView = class("KFCActivityShowView", BaseView)
autoImport("PhotographResultPanel")
KFCActivityShowView.ViewType = UIViewType.ShareLayer

function KFCActivityShowView:Init()
  self:initView()
  self:initData()
end

function KFCActivityShowView:initView()
  self.cornerCt = self:FindGO("cornerCt")
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self:Hide(self.cornerCt)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
end

function KFCActivityShowView:GetGameObjects()
  self.goUIViewSocialShare = self:FindGO("UIViewSocialShare", self.gameObject)
  self.goButtonWechatMoments = self:FindGO("WechatMoments", self.goUIViewSocialShare)
  self.goButtonWechat = self:FindGO("Wechat", self.goUIViewSocialShare)
  self.goButtonQQ = self:FindGO("QQ", self.goUIViewSocialShare)
  self.goButtonSina = self:FindGO("Sina", self.goUIViewSocialShare)
  self.bgTexture = self:FindGO("bgTexture"):GetComponent("UITexture")
  self.fullScreenShareImg = self:FindGO("FullScreenShareImg"):GetComponent("UITexture")
  self:Hide(self.fullScreenShareImg)
end

function KFCActivityShowView:RegisterButtonClickEvent()
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

function KFCActivityShowView:OnClickForButtonWechatMoments()
  if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
    self:sharePicture(E_PlatformType.WechatMoments, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function KFCActivityShowView:OnClickForButtonWechat()
  if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
    self:sharePicture(E_PlatformType.Wechat, "", "")
  else
    MsgManager.ShowMsgByIDTable(561)
  end
end

function KFCActivityShowView:OnClickForButtonQQ()
  if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
    self:sharePicture(E_PlatformType.QQ, "", "")
  else
    MsgManager.ShowMsgByIDTable(562)
  end
end

function KFCActivityShowView:OnClickForButtonSina()
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

function KFCActivityShowView:sharePicture(platform_type, content_title, content_body)
  local picName = PhotographResultPanel.picNameName .. tostring(os.time())
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
  if not FileDirectoryHandler.ExistDirectory(path) then
    FileDirectoryHandler.CreateDirectory(path)
  end
  path = path .. ".jpg"
  self:Log("KFCActivityShowView sharePicture pic path:", path)
  self:SavePic(self.fullScreenShareImg.mainTexture, path, platform_type, content_title, content_body)
end

function KFCActivityShowView:SavePic(tex, path, platform_type, content_title, content_body)
  local bytes = ImageConversion.EncodeToJPG(tex)
  FileDirectoryHandler.WriteFile(path, bytes, function(x)
    helplog("KFCActivityShowView SavePic WriteFile path: ", path)
    self:DoSharePicture(path, content_title, content_body, platform_type)
  end)
end

function KFCActivityShowView:DoSharePicture(path, content_title, content_body, platform_type)
  SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
    self:Log("SocialShare.Instance:Share success")
    ROFileUtils.FileDelete(path)
    if platform_type == E_PlatformType.Sina then
      MsgManager.ShowMsgByIDTable(566)
    end
    ServiceNUserProxy.Instance:CallKFCShareUserCmd(self.staticId)
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

function KFCActivityShowView:initData()
  local staticId = self.viewdata and self.viewdata.viewdata
  self.staticId = staticId
  if staticId then
    local texName = GameConfig.KFCItems[staticId]
    if texName then
      PictureManager.Instance:SetUI(texName, self.bgTexture)
      PictureManager.Instance:SetUI(texName, self.fullScreenShareImg)
    end
  end
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function KFCActivityShowView:OnExit()
  if self.data then
    self.data:Exit()
  end
  PictureManager.Instance:UnLoadUI()
end
