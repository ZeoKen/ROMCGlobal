autoImport("LotteryResultShareCell")
LotteryRaidResultShareView = class("LotteryRaidResultShareView", ContainerView)
LotteryRaidResultShareView.ViewType = UIViewType.ShareLayer
local GetLocalPosition = LuaGameObject.GetLocalPosition

function LotteryRaidResultShareView:Init()
  self:FindObjs()
  self:InitShow()
  local close = self:FindGO("CloseButton", pfb)
  self:AddClickEvent(close, function()
    GameFacade.Instance:sendNotification(XDEUIEvent.LotteryAnimationEnd)
    self:CloseSelf()
  end)
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
  local share_globalchannel = self:FindGO("share_globalchannel")
  if share_globalchannel then
    self:AddClickEvent(share_globalchannel, function()
      self:ShareToGlobalChannel()
    end)
    share_globalchannel:SetActive(false)
    self.snsPlatform.WorldChat = share_globalchannel
  end
  local off = 0
  for i = 1, #GameConfig.Share.Sns_platform do
    if self.snsPlatform[GameConfig.Share.Sns_platform[i]] then
      self.snsPlatform[GameConfig.Share.Sns_platform[i]]:SetActive(true)
      self.snsPlatform[GameConfig.Share.Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-390 + off * 75, 0, 0)
      off = off + 1
    end
  end
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
end

function LotteryRaidResultShareView:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
end

function LotteryRaidResultShareView:InitShow()
  local viewData = self.viewdata.viewdata
  local data = viewData.list
  if data then
    self.itemList = {}
    for i = 1, #data do
      self.itemList[#self.itemList + 1] = data[i]:Clone()
    end
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
    local grid = self:FindGO("Grid"):GetComponent(UIGrid)
    self.itemCtl = UIGridListCtrl.new(grid, LotteryResultShareCell, "LotteryResultShareCell")
    self.itemCtl:ResetDatas(self.itemList)
    local itemCells = self.itemCtl:GetCells()
    local safetyItemId = viewData.safety_itemid
    for i = 1, #itemCells do
      local itemData = itemCells[i].data
      local isFashion = itemData ~= nil and itemData.staticData ~= nil and itemData.staticData.id == safetyItemId
      self:SetNormal(self.effectContainer, isFashion, GetLocalPosition(itemCells[i].trans))
    end
  end
end

local effectName

function LotteryRaidResultShareView:SetNormal(parent, isFashion, x, y, z)
  self.effect1 = self:PlayUIEffect(EffectMap.UI.Egg10BoomB, parent, true)
  self.effect1:ResetLocalPositionXYZ(x, y, z)
  effectName = isFashion and EffectMap.UI.ShareEgg10DritO or EffectMap.UI.Egg10DritB
  self.effect2 = self:PlayUIEffect(effectName, parent)
  self.effect2:ResetLocalPositionXYZ(x, y, z)
end

function LotteryRaidResultShareView:ShareToGlobalChannel()
  local sharedata = {}
  sharedata.type = ESHAREMSGTYPE.ESHARE_LOTTERY_TEN
  sharedata.share_items = ReusableTable.CreateArray()
  for i = 1, #self.itemList do
    sharedata.share_items[i] = NetConfig.PBC and {} or ChatCmd_pb.ShareItemData()
    sharedata.share_items[i].guid = self.itemList[i].id
    sharedata.share_items[i].itemid = self.itemList[i].staticData.id
    sharedata.share_items[i].count = self.itemList[i].num
  end
  ServiceChatCmdProxy.Instance:CallShareMsgCmd(sharedata)
  ReusableTable.DestroyAndClearArray(sharedata.share_items)
  MsgManager.ShowMsgByIDTable(43187)
  self:CloseSelf()
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function LotteryRaidResultShareView:SharePicture(platform_type, content_title, content_body)
  helplog("LotteryRaidResultShareView SharePicture", platform_type)
  local weekReward = MyselfProxy.Instance:GetAccVarValueByType(Var_pb.EACCVARTYPE_SHARE_WEEK_REWARD) or 0
  if weekReward == 0 then
    ServiceChatCmdProxy.Instance:CallShareSuccessNofityCmd()
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
      xdlog("no texture")
    end
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    helplog("StarView Share path", path)
    if not BranchMgr.IsChina() then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      if platform_type ~= "fb" then
        xdlog("startSharePicture", platform_type .. " share")
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
      xdlog("startSharePicture", "fb share image")
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
