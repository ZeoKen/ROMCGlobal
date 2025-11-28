autoImport("GeneralShareView")
OldPlayerShareView = class("OldPlayerShareView", GeneralShareView)
OldPlayerShareView.ViewType = UIViewType.PopUpLayer

function OldPlayerShareView:Init()
  OldPlayerShareView.super.Init(self)
end

function OldPlayerShareView:InitShow()
  local title = self:FindGO("Title"):GetComponent(UILabel)
  title.text = string.format(ZhString.OldPlayer_Code, self.viewdata.viewdata.InviteCode)
  local invitation = GameConfig.Invitation[self.viewdata.viewdata.inviteID]
  if invitation ~= nil then
    local activityName = self:FindGO("ActivityName"):GetComponent(UILabel)
    activityName.text = invitation.ShareActivityName
    local activityInfo = self:FindGO("ActivityInfo"):GetComponent(UILabel)
    activityInfo.text = invitation.ShareActivityInfo
    local textureBg = self:FindGO("Texture"):GetComponent(UISprite)
    local height = activityInfo.printedSize.y
    textureBg.height = height + 30
  end
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.CloseButton = self:FindGO("CloseButton")
  local rologo = self:FindGO("ROLogo")
  local texName = invitation.logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  local qrcode = self:FindGO("QRCode"):GetComponent(UITexture)
  local qrCodeTexName = invitation.QRCode
  if qrCodeTexName ~= nil then
    logoTex.width = 238
    logoTex.height = 210
    qrcode.width = 170
    qrcode.height = 170
    qrcode.gameObject:SetActive(true)
    PictureManager.Instance:SetPlayerRefluxTexture(qrCodeTexName, qrcode)
  else
    rologo.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(350, -143, 0)
    logoTex.width = 178
    logoTex.height = 140
    qrcode.gameObject:SetActive(false)
  end
end

function OldPlayerShareView:FindObj()
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
  for i = 1, #GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform do
    self.snsPlatform[GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform[i]]:SetActive(true)
    self.snsPlatform[GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-585 + (i - 1) * 70, -310, 0)
  end
  self.copyBtn = self:FindGO("CopyBtn")
  self:AddClickEvent(self.copyBtn, function()
    local result = ApplicationInfo.CopyToSystemClipboard(self.viewdata.viewdata.InviteCode)
    if result then
      MsgManager.ShowMsgByID(40580)
    end
  end)
  self.bgTexture = self:FindGO("Bg"):GetComponent(UITexture)
  PictureManager.ReFitFullScreen(self.bgTexture, 1)
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function OldPlayerShareView:SharePicture(platform_type, content_title, content_body)
  helplog("OldPlayerShareView SharePicture", platform_type)
  if ReturnActivityProxy.Instance.userReturnInviteData.got_share_reward ~= nil and ReturnActivityProxy.Instance.userReturnInviteData.got_share_reward then
  else
    ServiceActivityCmdProxy.Instance:CallUserReturnShareAwardCmd()
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.CloseButton:SetActive(false)
  self.copyBtn:SetActive(false)
  for i = 1, #GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform do
    self.snsPlatform[GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform[i]]:SetActive(false)
  end
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.CloseButton:SetActive(true)
    self.copyBtn:SetActive(true)
    for i = 1, #GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform do
      self.snsPlatform[GameConfig.Invitation[self.viewdata.viewdata.inviteID].Sns_platform[i]]:SetActive(true)
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
  self:TrackEvent(platform_type)
end

local dataTable = {}
local event_name = "#Invitation_Sns_Tap"
local charid_key = "#charid"
local server_key = "#Server"
local platform_key = "#Platform"

function OldPlayerShareView:TrackEvent(platform_type)
  local charid = Game.Myself.data.id
  local serverData = FunctionLogin.Me():getCurServerData()
  local server = serverData and serverData.name or ""
  local platform = ""
  if platform_type == E_PlatformType.QQ then
    platform = "QQ"
  elseif platform_type == E_PlatformType.Wechat then
    platform = "Wechat"
  elseif platform_type == E_PlatformType.WechatMoments then
    platform = "WechatMoments"
  elseif platform_type == E_PlatformType.Sina then
    platform = "Sina"
  end
  TableUtility.TableClear(dataTable)
  dataTable[charid_key] = charid
  dataTable[server_key] = server
  dataTable[platform_key] = platform
  local json = json.encode(dataTable)
  FunctionTyrantdb.Instance:trackEvent(event_name, json)
end
