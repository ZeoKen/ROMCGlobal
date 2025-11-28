CardUpgradeShareView = class("CardUpgradeShareView", BaseView)
CardUpgradeShareView.ViewType = UIViewType.ShareLayer
local Logo1Name = "reflux_bg_logo7"
local Logo2Name = "share_meizi"
local Logo3Name = "reflux_bg_bottem_04"

function CardUpgradeShareView:Init()
  self:FindObjs()
end

function CardUpgradeShareView:FindObjs()
  local bg = self:FindComponent("BG", UISprite)
  self:RefitFullScreenWidgetSize(bg)
  self.CloseButton = self:FindGO("CloseButton")
  self.SharePanel = self:FindGO("SharePanel")
  self.logo1 = self:FindComponent("Logo1", UITexture)
  self.logo2 = self:FindComponent("Logo2", UITexture)
  self.logo3 = self:FindComponent("Logo3", UITexture)
  self.cardTex = self:FindComponent("CardTex", UITexture)
  self.loading = self:FindGO("Loading")
  self.levelLabel = self:FindComponent("Level", UILabel)
  self.cardNameLabel = self:FindComponent("CardName", UILabel)
  self.snsPlatform = {}
  local qq = self:FindGO("share_qq")
  self:AddClickEvent(qq, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
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
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
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
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
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
      self.snsPlatform[GameConfig.Share.Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-570 + off * 75, 0, 0)
      off = off + 1
    end
  end
end

function CardUpgradeShareView:OnEnter()
  PictureManager.Instance:SetPlayerRefluxTexture(Logo1Name, self.logo1)
  PictureManager.Instance:SetUI(Logo2Name, self.logo2)
  PictureManager.Instance:SetPlayerRefluxTexture(Logo3Name, self.logo3)
  local cfg = Table_Card[self.viewdata.viewdata.itemData.staticData.id]
  if cfg then
    self.cardNameLabel.text = cfg.Name
    local cardLv = self.viewdata.viewdata.itemData.cardLv or 0
    self.levelLabel.text = string.format(ZhString.CardUpgarde_UpgradeLevel, cardLv)
    self:SetTargetCard()
  end
end

function CardUpgradeShareView:OnExit()
  PictureManager.Instance:UnloadPlayerRefluxTexture(Logo1Name, self.logo1)
  PictureManager.Instance:UnLoadUI(Logo2Name, self.logo2)
  PictureManager.Instance:UnloadPlayerRefluxTexture(Logo3Name, self.logo3)
end

local LoadingName = "card_loading"

function CardUpgradeShareView:SetTargetCard()
  local itemData = self.viewdata.viewdata.itemData
  if not itemData then
    return
  end
  local cardInfo = itemData.cardInfo
  if not cardInfo then
    return
  end
  if self.cardInfoName ~= nil and self.cardInfoName ~= cardInfo.Picture then
    PictureManager.Instance:UnLoadCard(self.cardInfoName, self.cardTex)
    self.cardInfoName = nil
  end
  local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
  local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. cardInfo.Picture))
  if self.assetname ~= nil and self.assetname ~= assetname then
    _AssetLoadEventDispatcher:RemoveEventListener(self.assetname, CardUpgradeShareView.LoadPicComplete, self)
  end
  self.assetname = assetname
  if assetname ~= nil then
    _AssetLoadEventDispatcher:AddEventListener(assetname, CardUpgradeShareView.LoadPicComplete, self)
    self.cardInfoName = LoadingName
  else
    self.cardInfoName = cardInfo.Picture
  end
  PictureManager.Instance:SetCard(self.cardInfoName, self.cardTex)
  self.loading:SetActive(assetname ~= nil)
end

function CardUpgradeShareView:LoadPicComplete(args)
  if args.success then
    self.loading:SetActive(false)
    if self.viewdata.viewdata.itemData and self.viewdata.viewdata.itemData.cardInfo then
      self.cardInfoName = self.viewdata.viewdata.itemData.cardInfo.Picture
      PictureManager.Instance:SetCard(self.cardInfoName, self.cardTex)
    end
  end
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function CardUpgradeShareView:SharePicture(platform_type, content_title, content_body)
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  helplog("CardUpgradeShareView SharePicture", platform_type)
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 0 then
    ServiceChatCmdProxy.Instance:CallShareSuccessNofityCmd()
  end
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.CloseButton:SetActive(false)
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

function CardUpgradeShareView:ShareToGlobalChannel()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  local sharedata = {}
  sharedata.type = ESHAREMSGTYPE.ESHARE_CARD
  sharedata.share_items = ReusableTable.CreateArray()
  sharedata.share_items[1] = NetConfig.PBC and {} or ChatCmd_pb.ShareItemData()
  sharedata.share_items[1].guid = self.viewdata.viewdata.itemData.id
  sharedata.share_items[1].itemid = self.viewdata.viewdata.itemData.staticData.id
  sharedata.share_items[1].count = self.viewdata.viewdata.itemData.num
  ServiceChatCmdProxy.Instance:CallShareMsgCmd(sharedata)
  ReusableTable.DestroyAndClearArray(sharedata.share_items)
  MsgManager.ShowMsgByIDTable(43187)
  self:CloseSelf()
end
