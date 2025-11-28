autoImport("GeneralShareView")
OldPlayerShareOverSeaView = class("OldPlayerShareOverSeaView", GeneralShareView)
OldPlayerShareOverSeaView.ViewType = UIViewType.PopUpLayer

function OldPlayerShareOverSeaView:Init()
  OldPlayerShareOverSeaView.super.Init(self)
end

function OldPlayerShareOverSeaView:InitShow()
  local title = self:FindGO("Title"):GetComponent(UILabel)
  title.text = self.viewdata.viewdata.InviteCode
  local invitation = GameConfig.RecommendAct[self.viewdata.viewdata.inviteID]
  if invitation ~= nil then
    local activityName = self:FindGO("ActivityName"):GetComponent(UILabel)
    activityName.text = invitation.ShareActivityName
    local activityInfo = self:FindGO("ActivityInfo"):GetComponent(UILabel)
    activityInfo.text = invitation.ShareActivityInfo
  end
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.CloseButton = self:FindGO("CloseButton")
end

function OldPlayerShareOverSeaView:FindObj()
  self.snsPlatform = {}
  local qq = self:FindGO("QQ")
  self:AddClickEvent(qq, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
      self:SharePicture(E_PlatformType.QQ, "", "")
    else
      MsgManager.ShowMsgByIDTable(562)
    end
  end)
  qq:SetActive(false)
  self.snsPlatform.QQ = qq
  local wechat = self:FindGO("Wechat")
  self:AddClickEvent(wechat, function()
    self:SharePicture(E_PlatformType.Wechat, "", "")
    if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
      self:SharePicture(E_PlatformType.Wechat, "", "")
    else
      MsgManager.ShowMsgByIDTable(561)
    end
  end)
  wechat:SetActive(false)
  self.snsPlatform.Wechat = wechat
  local wechatMoments = self:FindGO("WechatMoments")
  self:AddClickEvent(wechatMoments, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.WechatMoments) then
      self:SharePicture(E_PlatformType.WechatMoments, "", "")
    else
      MsgManager.ShowMsgByIDTable(561)
    end
  end)
  wechatMoments:SetActive(false)
  self.snsPlatform.WechatMoments = wechatMoments
  local sina = self:FindGO("Sina")
  self:AddClickEvent(sina, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
      self:SharePicture(E_PlatformType.Sina, "", "")
    else
      MsgManager.ShowMsgByIDTable(563)
    end
  end)
  sina:SetActive(false)
  self.snsPlatform.Sina = sina
  local facebook = self:FindGO("Facebook")
  self:AddClickEvent(facebook, function()
    self:SharePicture("fb", "", "")
  end)
  facebook:SetActive(false)
  self.snsPlatform.Facebook = facebook
  local twitter = self:FindGO("Twitter")
  self:AddClickEvent(twitter, function()
    self:SharePicture("twitter", "", "")
  end)
  twitter:SetActive(false)
  self.snsPlatform.Twitter = twitter
  local line = self:FindGO("line")
  self:AddClickEvent(line, function()
    self:SharePicture("line", "", "")
  end)
  line:SetActive(false)
  self.snsPlatform.line = line
  if GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform then
    for i = 1, #GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform do
      self.snsPlatform[GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform[i]]:SetActive(true)
      self.snsPlatform[GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-585 + (i - 1) * 70, -310, 0)
    end
  end
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function OldPlayerShareOverSeaView:SharePicture(platform_type, content_title, content_body)
  helplog("OldPlayerShareOverSeaView SharePicture", platform_type)
  if ReturnActivityProxy.Instance.GetActivityState(10001) == EAWARDSTATE.EAWARD_STATE_PROHIBIT then
    ServiceActivityCmdProxy.Instance:CallUserInviteAwardCmd({10001}, ReturnActivityProxy.Instance.recommendactData.id)
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.CloseButton:SetActive(false)
  for i = 1, #GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform do
    self.snsPlatform[GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform[i]]:SetActive(false)
  end
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.CloseButton:SetActive(true)
    for i = 1, #GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform do
      self.snsPlatform[GameConfig.RecommendAct[self.viewdata.viewdata.inviteID].Sns_platform[i]]:SetActive(true)
    end
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    if self.texture ~= nil then
      texture = self.texture
    else
      xdlog("没有获得 texture")
    end
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    helplog("StarView Share path", path)
    if not BranchMgr.IsChina() then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      if platform_type ~= "fb" then
        xdlog("startSharePicture", platform_type .. "分享")
        if platform_type == "twitter" then
          content_title = OverseaHostHelper.TWITTER_MSG
        end
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
      overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
        redlog("msg" .. msg)
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
      helplog("StarView Share success")
      ROFileUtils.FileDelete(path)
      if platform_type == E_PlatformType.Sina then
        MsgManager.ShowMsgByIDTable(566)
      end
    end, function(failCode, failMsg)
      helplog("StarView Share failure")
      ROFileUtils.FileDelete(path)
      local errorMessage = failMsg or "error"
      if failCode ~= nil then
        errorMessage = failCode .. ", " .. errorMessage
      end
      MsgManager.ShowMsg("", errorMessage, 0)
    end, function()
      helplog("StarView Share cancel")
      ROFileUtils.FileDelete(path)
    end)
  end, gmCm, ui)
end
