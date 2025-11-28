PhotoStandShareView = class("PhotoStandShareView", BaseView)
PhotoStandShareView.ViewType = UIViewType.ShareLayer

function PhotoStandShareView:Init()
  self:initView()
  self:initData()
end

function PhotoStandShareView:initView()
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.ShareDescription = self:FindComponent("ShareDescription", UILabel)
  self.photoTex = self:FindComponent("photoTex", UITexture)
  local myName = self:FindGO("myName"):GetComponent(UILabel)
  myName.text = Game.Myself.data.name
  local serverName = self:FindGO("ServerName"):GetComponent(UILabel)
  local curServer = FunctionLogin.Me():getCurServerData()
  local serverID = curServer and curServer.name or 1
  serverName.text = serverID
  if BranchMgr.IsJapan() then
    myName.gameObject:SetActive(false)
    serverName.gameObject:SetActive(false)
    local bg_name = self:FindGO("bg_name")
    if bg_name then
      bg_name:SetActive(false)
    end
  end
  local close = self:FindGO("CloseButton", pfb)
  self:AddClickEvent(close, function()
    self:CloseSelf()
  end)
  local rewardTips = self:FindGO("WeekRewardTips")
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", rewardTips):GetComponent(UISprite)
  local data = ItemData.new("FirstRewardIcon", GameConfig.Share.ShareReward[1])
  IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", rewardTips):GetComponent(UILabel)
  FirstRewardCountLbl.text = "x" .. GameConfig.Share.ShareReward[2]
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 1 then
    rewardTips:SetActive(false)
  else
    rewardTips:SetActive(true)
  end
  local rologo = self:FindGO("Logo")
  local texName = GameConfig.Share.Logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  self.snsPlatform = {}
  local qq = self:FindGO("share_qq")
  self:AddClickEvent(qq, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.QQ) then
      self:SharePicture(E_PlatformType.QQ, "", "")
    else
      MsgManager.ShowMsgByIDTable(562)
    end
  end)
  qq:SetActive(false)
  self.snsPlatform.QQ = qq
  local wechat = self:FindGO("share_wechat")
  self:AddClickEvent(wechat, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.Wechat) then
      self:SharePicture(E_PlatformType.Wechat, "", "")
    else
      MsgManager.ShowMsgByIDTable(561)
    end
  end)
  wechat:SetActive(false)
  self.snsPlatform.Wechat = wechat
  local sina = self:FindGO("share_weibo")
  self:AddClickEvent(sina, function()
    if SocialShare.Instance:IsClientValid(E_PlatformType.Sina) then
      self:SharePicture(E_PlatformType.Sina, "RO", "RO")
    else
      MsgManager.ShowMsgByIDTable(563)
    end
  end)
  sina:SetActive(false)
  self.snsPlatform.Sina = sina
  local share_globalchannel = self:FindGO("share_globalchannel")
  if share_globalchannel then
    self:AddClickEvent(share_globalchannel, function()
      self:ShareToGlobalChannel()
    end)
    share_globalchannel:SetActive(false)
    self.snsPlatform.WorldChat = share_globalchannel
  end
  local fb = self:FindGO("share_fb")
  self:AddClickEvent(fb, function()
    self:SharePicture("fb", "RO", "RO")
  end)
  fb:SetActive(false)
  self.snsPlatform.Facebook = fb
  local twitter = self:FindGO("share_twitter")
  self:AddClickEvent(twitter, function()
    self:SharePicture("twitter", "RO", "RO")
  end)
  twitter:SetActive(false)
  self.snsPlatform.Twitter = twitter
  local line = self:FindGO("share_line")
  self:AddClickEvent(line, function()
    self:SharePicture("line", "RO", "RO")
  end)
  line:SetActive(false)
  self.snsPlatform.line = line
  local off = 0
  for i = 1, #GameConfig.Share.Sns_platform do
    if self.snsPlatform[GameConfig.Share.Sns_platform[i]] then
      self.snsPlatform[GameConfig.Share.Sns_platform[i]]:SetActive(true)
      self.snsPlatform[GameConfig.Share.Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-390 + off * 75, 0, 0)
      off = off + 1
    end
  end
  self.snsPlatform.WorldChat:SetActive(false)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function PhotoStandShareView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function PhotoStandShareView:ShareToGlobalChannel()
  local sharedata = {}
  sharedata.type = ESHAREMSGTYPE.ESHARE_ENCHANT
  sharedata.share_items = ReusableTable.CreateArray()
  sharedata.share_items[1] = NetConfig.PBC and {} or ChatCmd_pb.ShareItemData()
  sharedata.share_items[1].guid = self.viewdata.viewdata.itemdata.id
  sharedata.share_items[1].itemid = self.viewdata.viewdata.itemdata.staticData.id
  sharedata.share_items[1].count = self.viewdata.viewdata.itemdata.num
  ServiceChatCmdProxy.Instance:CallShareMsgCmd(sharedata)
  ReusableTable.DestroyAndClearArray(sharedata.share_items)
  self:sendNotification(ShareNewEvent.HideWeekShraeTip, self)
  MsgManager.ShowMsgByIDTable(43187)
  self:CloseSelf()
end

function PhotoStandShareView:OnEnter()
  self:SetData(self.viewdata.viewdata)
end

function PhotoStandShareView:SetData(data)
  self.photoTex.mainTexture = data
  PictureManager.ReFitManualHeight(self.photoTex)
end

function PhotoStandShareView:GetGameObjects()
end

function PhotoStandShareView:RegisterButtonClickEvent()
end

function PhotoStandShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function PhotoStandShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function PhotoStandShareView:OnExit()
  self.photoTex = nil
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function PhotoStandShareView:SharePicture(platform_type, content_title, content_body)
  helplog("PhotoStandShareView SharePicture", platform_type)
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 0 then
    ServiceChatCmdProxy.Instance:CallShareSuccessNofityCmd()
    self:sendNotification(ShareNewEvent.HideWeekShraeTip, self)
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.CloseButton = self:FindGO("CloseButton")
  self.CloseButton:SetActive(false)
  self.SharePanel = self:FindGO("SharePanel")
  if self.SharePanel then
    self.SharePanel:SetActive(false)
  end
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.CloseButton:SetActive(true)
    if self.SharePanel then
      self.SharePanel:SetActive(true)
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
