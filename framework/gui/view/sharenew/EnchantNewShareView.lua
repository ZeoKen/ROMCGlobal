EnchantNewShareView = class("EnchantNewShareView", BaseView)
autoImport("PhotographResultPanel")
EnchantNewShareView.ViewType = UIViewType.ShareLayer

function EnchantNewShareView:Init()
  self:initView()
  self:initData()
end

function EnchantNewShareView:initView()
  self.objHolder = self:FindGO("objHolder")
  self.itemName = self:FindComponent("itemName", UILabel)
  self.Title = self:FindComponent("Title", UILabel)
  self.Container = self:FindGO("Container")
  self:InitItemCell(self.objHolder)
  self.objBgCt = self:FindGO("objBgCt")
  self.refineBg = self:FindGO("refineBg", self.objBgCt)
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.ShareDescription = self:FindComponent("ShareDescription", UILabel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.gridPosX = LuaGameObject.GetLocalPosition(self.gridTrans)
  self.attrGOs, self.attrNames, self.attrValues, self.attrMaxTips = {}, {}, {}, {}
  local go
  for i = 1, 3 do
    go = self:FindGO("Attr" .. i)
    self.attrGOs[i] = go
    self.attrNames[i] = self:FindComponent("AttrName", UILabel, go)
    self.attrValues[i] = self:FindComponent("AttrValue", UILabel, go)
    self.attrMaxTips[i] = self:FindGO("MaxTip", go)
  end
  self.combineAttr = self:FindGO("CombineAttr")
  self.combineAttrName = self:FindComponent("CombineAttrName", UILabel)
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
  local title = self:FindGO("Title")
  if title then
    local lbl = title:GetComponent(UILabel)
    lbl.text = GameConfig.Share.Sharetitle[ESHAREMSGTYPE.ESHARE_ENCHANT]
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
      self.snsPlatform[GameConfig.Share.Sns_platform[i]].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-390 + off * 75, 0, 0)
      off = off + 1
    end
  end
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function EnchantNewShareView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function EnchantNewShareView:ShareToGlobalChannel()
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
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

function EnchantNewShareView:FormatBufferStr(bufferId)
  local str = ItemUtil.getBufferDescById(bufferId)
  local result = ""
  local bufferStrs = string.split(str, "\n")
  for m = 1, #bufferStrs do
    local buffData = Table_Buffer[bufferId]
    local buffStr = ""
    if buffData then
      buffStr = string.format("{bufficon=%s} ", buffData.BuffIcon)
    end
    result = result .. buffStr .. bufferStrs[m] .. "\n"
  end
  if result ~= "" then
    result = string.sub(result, 1, -2)
  end
  return result
end

local valueColorStr = "[c][ffc64a]%s[-][/c]"
local maxColorStr = "[c][ff6a6a]%s[-][/c]"

function EnchantNewShareView:setItemProperty(data)
  local label = ""
  if data and data.equipInfo and data.equipInfo.randomEffect then
    for k, v in pairs(data.equipInfo.randomEffect) do
      local sData = Table_EquipEffect[k]
      local tAttrType, attrType = type(sData.AttrType)
      if tAttrType == "string" then
        attrType = sData.AttrType
      elseif tAttrType == "table" then
        attrType = tostring(sData.AttrType[1])
      end
      local attrConfig = Game.Config_PropName[attrType]
      local value = math.abs(v)
      local randAttr = Table_EquipEffect_t.AttrRate[sData.AttrRate]
      local isMax = false
      if randAttr and v == randAttr[#randAttr][1] then
        isMax = true
      end
      label = label .. string.format(OverSea.LangManager.Instance():GetLangByKey(sData.Dsc), string.format(valueColorStr, attrConfig.IsPercent == 1 and value * 100 .. "%" or value))
      if isMax then
        label = label .. string.format(maxColorStr, "  (MAX)")
      end
      label = label .. "\n"
    end
    self.ShareDescription.alignment = 0
  end
  if label ~= "" then
    self.ShareDescription.text = label
  else
    self.ShareDescription.text = ""
  end
end

function EnchantNewShareView:OnEnter()
  self:SetData(self.viewdata.viewdata)
  local parent = self.Container.transform
  local effectPath = ResourcePathHelper.EffectCommon("EnchantNewShareView")
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
  self.itemCell:SetData(self.viewdata.viewdata.itemdata)
end

function EnchantNewShareView:SetData(data)
  self.data = data
  self:Show(self.Container)
  self.itemName.text = data.itemdata.staticData.NameZh
  self:Show(self.objBgCt)
  self:Show(self.refineBg)
  local flag = data ~= nil and data.enchantAttrList ~= nil and #data.enchantAttrList > 0
  self.gameObject:SetActive(flag)
  self.index = flag and data.index or nil
  if flag then
    self:UpdateAttrs(data.enchantAttrList)
    self:UpdateCombine(data.combineEffectList, data.quench)
  end
end

function EnchantNewShareView:InitItemCell(container)
  if not container then
    return
  end
  local cellObj = self:LoadPreferb("cell/ItemNewCell", container)
  if not cellObj then
    return
  end
  local cellTrans = cellObj.transform
  cellTrans:SetParent(container.transform, true)
  cellTrans.localPosition = LuaGeometry.Const_V3_zero
  cellTrans.localScale = LuaGeometry.GetTempVector3(1.3, 1.3, 1.3)
  self.itemCell = ItemNewCell.new(cellObj)
  self.itemCell:HideNum()
end

function EnchantNewShareView:GetGameObjects()
end

function EnchantNewShareView:RegisterButtonClickEvent()
end

function EnchantNewShareView:UpdateAttrs(attrs)
  local data, quality, indicator
  for i = 1, #self.attrGOs do
    data = attrs and attrs[i]
    self.attrGOs[i]:SetActive(data ~= nil)
    if data then
      self.attrNames[i].text = data.name
      self.attrValues[i].text = string.format(data.propVO.isPercent and "+%s%%" or "+%s", data.value)
      self.attrMaxTips[i]:SetActive(data.isMax)
    end
  end
end

function EnchantNewShareView:UpdateCombine(combineEffs, quench)
  local hasCombine, buffData = false
  if combineEffs then
    for i = 1, #combineEffs do
      buffData = combineEffs[i] and combineEffs[i].buffData
      if buffData then
        hasCombine = true
        local buffDesc = ItemUtil.GetBuffDesc(buffData.BuffDesc, quench)
        self.combineAttrName.text = combineEffs[i].isWork and string.format("%s:%s", buffData.BuffName, buffDesc) or string.format("%s:%s(%s)", buffData.BuffName, buffDesc, combineEffs[i].WorkTip)
      end
    end
  end
  self.gridTrans.localPosition = LuaGeometry.GetTempVector3(self.gridPosX, hasCombine and 52 or 41)
  self.grid.cellHeight = hasCombine and 31 or 42
  self.grid:Reposition()
  self.combineAttr:SetActive(hasCombine)
end

function EnchantNewShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function EnchantNewShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function EnchantNewShareView:OnExit()
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function EnchantNewShareView:SharePicture(platform_type, content_title, content_body)
  if ApplicationInfo.IsRunOnWindowns() then
    MsgManager.ShowMsgByID(43486)
    return
  end
  helplog("EnchantNewShareView SharePicture", platform_type)
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
