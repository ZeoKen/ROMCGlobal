ColorFillingShareView = class("ColorFillingShareView", BaseView)
ColorFillingShareView.ViewType = UIViewType.ShareLayer
local bgName = "Disney_Comics_bg_show"
local sharePicName = "/Disney_ColorFilling"
local picExt = ".jpg"

function ColorFillingShareView:Init()
  self.comicId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.comicId
  if not self.comicId then
    self:CloseSelf()
    return
  end
  self:InitView()
end

function ColorFillingShareView:InitView()
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.bg = self:FindComponent("bg", UITexture)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.shareTipLabel = self:FindComponent("shareTip", UILabel)
  local nameNode = self:FindGO("name")
  self.userNameLabel = self:FindComponent("text", UILabel, nameNode)
  local levelNode = self:FindGO("level")
  self.userLevelLabel = self:FindComponent("text", UILabel, levelNode)
  local professionNode = self:FindGO("profession")
  self.userProfessionLabel = self:FindComponent("text", UILabel, professionNode)
  self.guildNode = self:FindGO("guild")
  self.userGuildLabel = self:FindComponent("text", UILabel, self.guildNode)
  self.completeTimeNode = self:FindGO("completeTime")
  self.completeTimeLabel = self:FindComponent("text", UILabel, self.completeTimeNode)
  self.shareNode = self:FindGO("share")
  self.closeButton = self:FindGO("closeButton")
  self.shareQQBtn = self:FindGO("shareQQBtn")
  self.shareWeiBoBtn = self:FindGO("shareWeiBoBtn")
  self.shareWeChatBtn = self:FindGO("shareWeChatBtn")
  self.shareBtn = self:FindGO("share_icon")
  self.uiViewSocialShare = self:FindGO("UIViewSocialShare")
  self.shareFbBtn = self:FindGO("fb", self.uiViewSocialShare)
  self.shareTwitterBtn = self:FindGO("twitter", self.uiViewSocialShare)
  self.shareLineBtn = self:FindGO("line", self.uiViewSocialShare)
  self.closeShareBtn = self:FindGO("closeShare", self.uiViewSocialShare)
  for i = 0, 3 do
    self["pic" .. i] = self:FindGO("pic" .. i)
  end
  self:AddClickEvent(self.closeButton, function()
    self:CloseSelf()
  end)
  if BranchMgr.IsChina() then
    self.shareQQBtn:SetActive(true)
    self.shareWeChatBtn:SetActive(true)
    self.shareWeiBoBtn:SetActive(true)
    self:AddClickEvent(self.shareQQBtn, function()
      if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
        self:Share(E_PlatformType.QQ)
      else
        MsgManager.ShowMsgByIDTable(562)
      end
    end)
    self:AddClickEvent(self.shareWeiBoBtn, function()
      if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
        self:Share(E_PlatformType.Sina)
      else
        MsgManager.ShowMsgByIDTable(563)
      end
    end)
    self:AddClickEvent(self.shareWeChatBtn, function()
      if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
        self:Share(E_PlatformType.Wechat)
      else
        MsgManager.ShowMsgByIDTable(561)
      end
    end)
  else
    self.shareQQBtn:SetActive(false)
    self.shareWeChatBtn:SetActive(false)
    self.shareWeiBoBtn:SetActive(false)
    self:AddClickEvent(self.shareBtn, function()
      if BranchMgr.IsJapan() then
        self.uiViewSocialShare:SetActive(true)
      else
        self.uiViewSocialShare:SetActive(false)
        self:Share("fb")
      end
    end)
    self:AddClickEvent(self.shareFbBtn, function()
      self:Share("fb")
    end)
    self:AddClickEvent(self.shareTwitterBtn, function()
      self:Share("twitter")
    end)
    self:AddClickEvent(self.shareLineBtn, function()
      self:Share("line")
    end)
    self:AddClickEvent(self.closeShareBtn, function()
      self.uiViewSocialShare:SetActive(false)
    end)
    local sp = self.shareFbBtn:GetComponent(UISprite)
    IconManager:SetUIIcon("Facebook", sp)
    sp = self.shareTwitterBtn:GetComponent(UISprite)
    IconManager:SetUIIcon("Twitter", sp)
    sp = self.shareLineBtn:GetComponent(UISprite)
    IconManager:SetUIIcon("line", sp)
  end
end

function ColorFillingShareView:OnEnter()
  self:InitData()
  self:InitPic()
end

function ColorFillingShareView:OnExit()
  PictureManager.Instance:UnloadColorFillingTexture(bgName, self.bg)
end

function ColorFillingShareView:InitData()
  PictureManager.Instance:SetColorFillingTexture(bgName, self.bg)
  self.bg:MakePixelPerfect()
  PictureManager.ReFitFullScreen(self.bg)
  self.titleLabel.text = GameConfig.ColorFilling and GameConfig.ColorFilling.comicName and GameConfig.ColorFilling.comicName[self.comicId] or ""
  self.shareTipLabel.text = GameConfig.ColorFilling and GameConfig.ColorFilling.shareTip and GameConfig.ColorFilling.shareTip or ""
  local myself = Game.Myself
  self.userNameLabel.text = myself.data:GetName()
  self.userLevelLabel.text = MyselfProxy.Instance:RoleLevel()
  self.userProfessionLabel.text = MyselfProxy.Instance:GetMyProfessionName()
  local guildData = myself.data:GetGuildData()
  if guildData then
    self.userGuildLabel.text = guildData.name
  else
    self.guildNode:SetActive(false)
    self.completeTimeNode.transform.localPosition = self.guildNode.transform.localPosition
  end
  local str = os.date("%Y.%m.%d", ServerTime.CurServerTime() / 1000)
  self.completeTimeLabel.text = str
end

function ColorFillingShareView:InitPic()
  local pics = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.pics
  if pics then
    for i = 0, 3 do
      local go = pics[i + 1]
      local pic = self["pic" .. i]
      go.transform:SetParent(pic.transform, false)
      go.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
      local goWidget = go:GetComponent(UIWidget)
      local picWidget = pic:GetComponent(UIWidget)
      local ratio = picWidget.width / goWidget.width
      local scale = LuaGeometry.GetTempVector3(1, 1, 1)
      scale.x = ratio
      scale.y = ratio
      go.transform.localScale = scale
    end
  end
end

function ColorFillingShareView:Share(platform)
  local camera = NGUIUtil:GetCameraByLayername("UI")
  self:SetUIVisible(false)
  self.screenShotHelper:GetScreenShot(function(texture)
    self:SetUIVisible(true)
    self:OnGetScreenShotFinish(texture, "", "", platform)
  end, camera)
end

function ColorFillingShareView:SetUIVisible(isVisible)
  self.closeButton:SetActive(isVisible)
  self.shareNode:SetActive(isVisible)
end

function ColorFillingShareView:OnGetScreenShotFinish(texture, title, content, platform)
  local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. sharePicName
  ScreenShot.SaveJPG(texture, path, 100)
  path = path .. picExt
  local successFunc = function(msg)
    ROFileUtils.FileDelete(path)
    redlog("share success!")
  end
  local failFunc = function(errorCode, msg)
    ROFileUtils.FileDelete(path)
    redlog("share failed, errorCode = ", errorCode)
  end
  local cancelFunc = function()
    ROFileUtils.FileDelete(path)
  end
  ServiceItemProxy.Instance:CallColoringShareItemCmd(self.comicId)
  if BranchMgr.IsChina() then
    SocialShare.Instance:ShareImage(path, title, content, platform, successFunc, failFunc, cancelFunc)
  else
    local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
    if platform ~= "fb" then
      overseasManager:ShareImgWithChannel(path, title, OverseaHostHelper.Share_URL, content, platform, function(msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          Debug.Log("success")
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
        end
      end)
    else
      overseasManager:ShareImg(path, title, OverseaHostHelper.Share_URL, content, function(msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
        end
      end)
    end
  end
end
