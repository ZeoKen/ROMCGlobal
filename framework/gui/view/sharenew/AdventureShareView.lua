AdventureShareView = class("AdventureShareView", BaseView)
autoImport("PhotographResultPanel")
autoImport("AdventureCollectionAchShowCell")
autoImport("AdventureAttrCell")
AdventureShareView.ViewType = UIViewType.ShareLayer
AdventureShareView.ShareType = {
  NormalShare = 1,
  SkadaShare = 2,
  RaidResultShare = 3
}

function AdventureShareView:Init()
  self:initView()
  self:initData()
end

function AdventureShareView:initView()
  self.secondContent = self:FindGO("secondContent")
  local collectionShowGrid = self:FindComponent("adventureProgressGrid", UIGrid)
  self.collectionShowGrid = UIGridListCtrl.new(collectionShowGrid, AdventureCollectionAchShowCell, "AdventureCollectionAchShowShareCell")
  self.adventurePropCt = self:FindGO("AdventurePropCt")
  grid = self:FindComponent("Grid", UIGrid, self.adventurePropCt)
  self.adventurePropGrid = UIGridListCtrl.new(grid, AdventureAttrCell, "AdventureAttrShareCell")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
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
  local _myName = self:FindGO("_myName"):GetComponent(UILabel)
  _myName.text = Game.Myself.data.name
  local _serverName = self:FindGO("_ServerName"):GetComponent(UILabel)
  _serverName.text = serverID
  if BranchMgr.IsJapan() then
    _myName.gameObject:SetActive(false)
    _serverName.gameObject:SetActive(false)
  end
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
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:UpdateHead()
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function AdventureShareView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function AdventureShareView:ShareToGlobalChannel()
end

function AdventureShareView:setCollectionAchievement()
  local list = ReusableTable.CreateArray()
  for key, bgData in pairs(AdventureDataProxy.Instance.bagMap) do
    if bgData.tableData then
      if bgData.tableData.Position == 1 or bgData.tableData.Position == 3 or key == SceneManual_pb.EMANUALTYPE_MOUNT then
        table.insert(list, bgData)
      end
    else
      LogUtility.Error("error table data ")
    end
  end
  table.insert(list, {
    type = SceneManual_pb.EMANUALTYPE_FOOD
  })
  table.sort(list, function(l, r)
    local lTable = Table_ItemTypeAdventureLog[l.type]
    local rTable = Table_ItemTypeAdventureLog[r.type]
    local lOrder = lTable.Order or 0
    local rOrder = rTable.Order or 0
    return lOrder < rOrder
  end)
  self.collectionShowGrid:ResetDatas(list)
  ReusableTable.DestroyAndClearArray(list)
end

function AdventureShareView:showPropView()
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.adventurePropCt.transform)
  self.adventurePropCt.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
  local props = AdventureDataProxy.Instance:GetAllAdventureProp()
  local propSize = #props
  if propSize == 0 then
    self:Hide(self.adventurePropCt)
  else
    local filter = {}
    local filterAttr = GameConfig.Share.AdventureRoleData
    for i = 1, #filterAttr do
      for p = 1, propSize do
        if props[p].prop.VarName == filterAttr[i] then
          filter[#filter + 1] = props[p]
          break
        end
      end
    end
    if 0 < #filter then
      self.adventurePropGrid:ResetDatas(filter)
      self:Show(self.adventurePropCt)
    else
      self:Hide(self.adventurePropCt)
    end
  end
end

function AdventureShareView:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end

function AdventureShareView:OnEnter()
  self:SetData(self.viewdata.viewdata)
end

function AdventureShareView:SetData(data)
  self.data = data
  self:showPropView()
  self:setCollectionAchievement()
end

function AdventureShareView:GetGameObjects()
end

function AdventureShareView:RegisterButtonClickEvent()
end

function AdventureShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function AdventureShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function AdventureShareView:OnExit()
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function AdventureShareView:SharePicture(platform_type, content_title, content_body)
  helplog("AdventureShareView SharePicture", platform_type)
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
