PackageEquipShareView = class("PackageEquipShareView", BaseView)
autoImport("PhotographResultPanel")
autoImport("MyselfEquipItemShareCell")
PackageEquipShareView.ViewType = UIViewType.ShareLayer
PackageEquipShareView.ShareType = {
  NormalShare = 1,
  SkadaShare = 2,
  RaidResultShare = 3
}

function PackageEquipShareView:Init()
  self:initView()
  self:initData()
end

function PackageEquipShareView:initView()
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
    self:Log("click weibo")
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
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function PackageEquipShareView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function PackageEquipShareView:ShareToGlobalChannel()
end

function PackageEquipShareView:OnEnter()
  self:SetData(self.viewdata.viewdata)
end

function PackageEquipShareView:SetData(data)
  self.data = data
  self:InitEquipCtl()
  self:UpdateEquipItems()
  self:UpdateRoleTexture()
end

function PackageEquipShareView:InitEquipCtl()
  local equipGrid = self:GetEquipGrid()
  if equipGrid.transform.childCount > 0 then
    for i = equipGrid.transform.childCount - 1, 0, -1 do
      local go = equipGrid.transform:GetChild(i)
      if go and go ~= self.chooseSymbol then
        GameObject.DestroyImmediate(go.gameObject)
      end
    end
  end
  self.roleEquips = {}
  local profession = MyselfProxy.Instance:GetMyProfession()
  local canEquipCar = Table_Class[profession].Type == 6 or PackageEquip_ShowCar_Class[profession] ~= nil
  for i = 1, 14 do
    if i ~= 14 or canEquipCar then
      local obj
      obj = self:LoadPreferb("cell/RoleEquipItemShareCell", equipGrid)
      obj.name = "RoleEquipItemShareCell" .. i
      self.roleEquips[i] = MyselfEquipItemShareCell.new(obj, i)
    end
  end
  equipGrid:Reposition()
  self:InitViceEquipSwitch()
  self.viceEquipList = {}
  self.viceEquipGrid = self:FindComponent("ViceEquipGrid", UIGrid)
  for _, site in pairs(BagProxy.ViceFoldedEquipConfig) do
    local obj = self:LoadPreferb("cell/RoleEquipItemShareCell", self.viceEquipGrid)
    obj.name = "ViewRoleEquipItemShareCell" .. site
    self.viceEquipList[site] = MyselfEquipItemShareCell.new(obj, site, nil, false, true)
  end
  self:Hide(self.viceEquipGrid)
  self.roleTexture = self:FindComponent("RoleTexture", UITexture)
end

function PackageEquipShareView:InitViceEquipSwitch()
  local spriteName = "bag_page_equipment_btn_icon"
  self.switchRoot = self:FindGO("ViceEquipSwitch")
  self.tog1 = self:FindGO("Tog1", self.switchRoot)
  self.tog1Bg = self:FindGO("SpriteBg", self.tog1)
  self.tog1Icon = self.tog1:GetComponent(UISprite)
  IconManager:SetUIIcon(spriteName .. 1, self.tog1Icon)
  self:AddClickEvent(self.tog1, function()
    self.isViceEquip = false
    self:OnEquipTabChange()
  end)
  self.tog2 = self:FindGO("Tog2", self.switchRoot)
  self.tog2Bg = self:FindGO("SpriteBg", self.tog2)
  self.tog2Icon = self.tog2:GetComponent(UISprite)
  IconManager:SetUIIcon(spriteName .. 2, self.tog2Icon)
  self:AddClickEvent(self.tog2, function()
    self.isViceEquip = true
    self:OnEquipTabChange()
  end)
end

function PackageEquipShareView:OnEquipTabChange()
  if self.isViceEquip then
    self:Show(self.viceEquipGrid)
    self:Hide(self.equipGrid)
    self:Hide(self.tog1Bg)
    self:Show(self.tog2Bg)
    self:UpdateViceEquipItems()
    self.viceEquipGrid:Reposition()
  else
    self:Show(self.equipGrid)
    self:Hide(self.viceEquipGrid)
    self:Show(self.tog1Bg)
    self:Hide(self.tog2Bg)
    self:UpdateEquipItems()
  end
end

function PackageEquipShareView:GetEquipGrid()
  if self.equipGrid ~= nil then
    return self.equipGrid
  end
  self.equipGrid = self:FindComponent("EquipGrid", UIGrid)
  
  function self.equipGrid.onReposition()
    if not self.equipGrid then
      return
    end
    local childCount = self.equipGrid.transform.childCount
    if childCount == 13 then
      local cell13 = self.equipGrid.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(216, -488)
      end
    elseif childCount == 14 then
      local cell13 = self.equipGrid.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(144, -488)
      end
      local cell14 = self.equipGrid.transform:GetChild(13)
      if cell14 then
        cell14.transform.localPosition = LuaGeometry.GetTempVector3(288, -488)
      end
    end
  end
  
  return self.equipGrid
end

function PackageEquipShareView:UpdateEquipItems()
  local equipdata = BagProxy.Instance.roleEquip.siteMap
  for i = 1, ItemUtil.EquipMaxIndex() do
    if self.roleEquips[i] then
      self:Log("UpdateEquipItems:", i)
      self.roleEquips[i]:SetData(equipdata[i])
    end
  end
end

function PackageEquipShareView:UpdateViceEquipItems()
  for site, cell in pairs(self.viceEquipList) do
    if site <= 6 then
      local bagData = BagProxy.Instance.shadowBagData
      cell:SetData(bagData.siteMap[site])
    elseif BagProxy.ActifactSite[site] then
      local bagData = BagProxy.Instance.roleEquip
      cell:SetData(bagData.siteMap[site])
    elseif site == ItemUtil.EquipExtractionOffense or site == ItemUtil.EquipExtractionDefense then
      local data = AttrExtractionProxy.Instance:GetActiveItemDataByEquipPos(site)
      cell:SetData(data)
    end
  end
end

local partIndex = Asset_Role.PartIndex
local maskBitIndex = {
  [partIndex.Face] = 0,
  [partIndex.Hair] = 1,
  [partIndex.Mouth] = 2,
  [partIndex.Eye] = 3,
  [partIndex.Head] = 4
}
local helpSet = function(parts, index, dataValue, usedebug)
  if parts == nil or index == nil then
    return false
  end
  local bodyID = parts[partIndex.Body]
  local maskBit = maskBitIndex[index]
  if nil ~= maskBit and bodyID and 0 < bodyID then
    local display = Game.Config_BodyDisplay[bodyID]
    if display and 0 ~= BitUtil.band(display, maskBit) then
      dataValue = 0
    end
  end
  if parts[index] == dataValue then
    return false
  end
  parts[index] = dataValue
  return true
end

function PackageEquipShareView:UpdateRoleTexture()
  self.parts = Asset_Role.CreatePartArray()
  local dirty = 0
  local partIndexEx = Asset_Role.PartIndexEx
  local class
  class = MyselfProxy.Instance:GetMyProfession()
  local userdata = Game.Myself.data.userdata
  if helpSet(self.parts, partIndex.Body, userdata:Get(UDEnum.BODY) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Hair, userdata:Get(UDEnum.HAIR) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.LeftWeapon, userdata:Get(UDEnum.LEFTHAND) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.RightWeapon, userdata:Get(UDEnum.RIGHTHAND) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Head, userdata:Get(UDEnum.HEAD) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Wing, userdata:Get(UDEnum.BACK) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Face, userdata:Get(UDEnum.FACE) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Tail, userdata:Get(UDEnum.TAIL) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Eye, userdata:Get(UDEnum.EYE) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Mount, 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndex.Mouth, userdata:Get(UDEnum.MOUTH) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndexEx.Gender, userdata:Get(UDEnum.SEX) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndexEx.HairColorIndex, userdata:Get(UDEnum.HAIRCOLOR) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndexEx.EyeColorIndex, userdata:Get(UDEnum.EYECOLOR) or 0) then
    dirty = dirty + 1
  end
  if helpSet(self.parts, partIndexEx.BodyColorIndex, userdata:Get(UDEnum.CLOTHCOLOR) or 0) then
    dirty = dirty + 1
  end
  UIModelUtil.Instance:ResetTexture(self.roleTexture)
  local suffixMap = class and Table_Class[class] and Table_Class[class].ActionSuffixMap
  self.modelCameraConfig = UIModelCameraTrans.ShareNew
  UIModelUtil.Instance:ChangeBGMeshRenderer("mall_twistedegg_bg_bottom", self.roleTexture)
  UIModelUtil.Instance:SetRoleModelTexture(self.roleTexture, self.parts, self.modelCameraConfig, nil, nil, nil, nil, function(rolePart)
    if rolePart == nil or rolePart.complete == nil then
      printRed("error! 没有该道具模型")
    else
      local pss = rolePart.complete.gameObject:GetComponentsInChildren(ParticleSystem)
      for i = 1, #pss do
        pss[i].gameObject:SetActive(false)
      end
    end
  end)
  if Screen.height >= 1000 then
    local cell = UIModelUtil.Instance:GetUIModelCell(self.roleTexture)
    cell:ForceSetRT(true, self.roleTexture.width * 1.5, self.roleTexture.height * 1.5)
  end
end

function PackageEquipShareView:GetGameObjects()
end

function PackageEquipShareView:RegisterButtonClickEvent()
end

function PackageEquipShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function PackageEquipShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function PackageEquipShareView:OnExit()
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function PackageEquipShareView:SharePicture(platform_type, content_title, content_body)
  helplog("PackageEquipShareView SharePicture", platform_type)
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
