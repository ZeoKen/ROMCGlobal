FloatAwardShareView = class("FloatAwardShareView", ContainerView)
autoImport("EffectShowDataWraper")
FloatAwardShareView.ViewType = UIViewType.ShareLayer
FloatAwardShareView.ShowType = {
  ModelType = 1,
  CardType = 2,
  IconType = 3,
  ItemType = 4
}
FloatAwardShareView.EffectPath = {
  EffectType_1 = "Public/Effect/UI/13itemShine_03"
}
FloatAwardShareView.EffectFromType = {
  AwardType = 1,
  GMType = 2,
  RefineType = 3
}
FloatAwardShareView.TimeTickType = {CheckAnim = 1, ShowIconOneByOne = 2}
local tempVector3 = LuaVector3.Zero()
local tempVector3_rotation = LuaVector3.Zero()
local tempVector3_scale = LuaVector3.Zero()
local tempQuaternion = LuaQuaternion.Identity()

function FloatAwardShareView:Init()
  self:initView()
  self:addViewListener()
  self:initData()
end

function FloatAwardShareView:initView()
  self.effectContainer = self:FindGO("EffectContainer"):GetComponent(ChangeRqByTex)
  self.propertyContainer = self:FindGO("propertyContainer")
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.propertyContainer.transform))
  tempVector3[3] = -200
  self.propertyContainer.transform.localPosition = tempVector3
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.itemNameCt = self:FindGO("itemNameCt")
  self.modelShow = self:FindGO("modelShow")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.nameBg = self:FindGO("nameBg")
  self.haveCountBack = self:FindGO("HaveCountBack")
  self.haveCount = self:FindComponent("HaveCount", UILabel)
  self.modelTexture = self:FindComponent("modelTexture", UITexture)
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
  self:Hide(self.nameBg)
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
  self.isHideAllBtn = false
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip, self)
end

function FloatAwardShareView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function FloatAwardShareView:ShareToGlobalChannel()
  local sharedata = {}
  sharedata.type = ESHAREMSGTYPE.ESHARE_SPEC_ITEM_GET
  sharedata.share_items = ReusableTable.CreateArray()
  sharedata.share_items[1] = NetConfig.PBC and {} or ChatCmd_pb.ShareItemData()
  sharedata.share_items[1].guid = self.viewdata.viewdata.data.id
  sharedata.share_items[1].itemid = self.viewdata.viewdata.data.staticData.id
  sharedata.share_items[1].count = self.viewdata.viewdata.data.num
  ServiceChatCmdProxy.Instance:CallShareMsgCmd(sharedata)
  ReusableTable.DestroyAndClearArray(sharedata.share_items)
  self:sendNotification(ShareNewEvent.HideWeekShraeTip, self)
  MsgManager.ShowMsgByIDTable(43187)
  self:CloseSelf()
end

function FloatAwardShareView:IsShowNameBg(isShow)
  self.isShowN = isShow
  if isShow then
    self:Show(self.nameBg)
  else
    self:Hide(self.nameBg)
  end
end

function FloatAwardShareView:addViewListener()
end

function FloatAwardShareView:initData()
  self.currentShowType = nil
  self.currentEffectPath = nil
  self.animator = nil
  self.isShowIng = false
  self.showListWithType = {}
  self.effectGo = nil
  self.currentShowData = nil
  self.animEndName = "model3"
  self.animStartName = "model1"
  self.animIdleName = "model2"
  self.isAnimChanging = false
  self.isShowIngIconAnim = false
  self.currentProfession = MyselfProxy.Instance:GetMyProfession()
  self.showTypeList = {}
  self.items = {}
  self.disableMsg = false
  for k, v in pairs(FloatAwardShareView.ShowType) do
    table.insert(self.showTypeList, v)
    self.showListWithType[v] = {}
  end
  table.sort(self.showTypeList, function(l, r)
    return l < r
  end)
  self:addItemDataToShow(self.viewdata.viewdata.data, self.viewdata.viewdata.argumentTable)
  self:checkStart()
  self.gameObject:SetActive(true)
end

function FloatAwardShareView:checkIsPlayIngStartOrEndAnim()
  if self.animator then
    local animState = self.animator:GetCurrentAnimatorStateInfo(0)
    local complete = animState.normalizedTime >= 1
    local isPlaying = animState:IsName(self.animEndName) or animState:IsName(self.animStartName)
    if not complete and isPlaying or self.isShowIngIconAnim then
      return true
    end
  end
end

function FloatAwardShareView:checkEffectType(itemData)
  if itemData.staticData then
    if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
      return FloatAwardShareView.ShowType.ModelType
    elseif BagProxy.CheckIsCardTypeItem(itemData.staticData.Type) then
      return FloatAwardShareView.ShowType.CardType
    else
      return FloatAwardShareView.ShowType.ItemType
    end
  end
  return FloatAwardShareView.ShowType.IconType
end

function FloatAwardShareView.checkEffectPath(argumentTable)
  if nil == argumentTable or nil == argumentTable.effectPath then
    return FloatAwardShareView.EffectPath.EffectType_1
  end
  return argumentTable.effectPath
end

function FloatAwardShareView:checkStartAnim()
  if not self:checkIsPlayIngStartOrEndAnim() then
    TimeTickManager.Me():ClearTick(self, FloatAwardShareView.TimeTickType.CheckAnim)
    self:changeBtnState()
  else
  end
end

function FloatAwardShareView:IsRaritySSR(itemid)
  local data = Table_Item[itemid]
  if data ~= nil then
    if data.Type == 501 then
      return true
    end
    if data.Quality >= 5 then
      return true
    end
  end
  return false
end

function FloatAwardShareView:addItemDataToShow(data, argumentTable)
  local showType = self:checkEffectType(data)
  if showType then
    local effectPath = FloatAwardShareView.checkEffectPath(argumentTable)
    if self:IsRaritySSR(data.staticData.id) then
      effectPath = ResourcePathHelper.EffectUI(EffectMap.UI.ShareItemShine_SSR)
    end
    local showData = EffectShowDataWraper.new(data, effectPath, showType, FloatAwardShareView.EffectFromType.AwardType, argumentTable)
    showType = showData.showType
    table.insert(self.showListWithType[showType], showData)
  else
    LogUtility.Warning("error!!! incorrect item type!")
  end
end

function FloatAwardShareView:showEffectEnd()
  self.isProcessEffectEnd = true
  if self.animator and self.isShowIng then
    self.animator:Play(self.animEndName, -1, 0)
    self.checkAnimTimerId = TimeTickManager.Me():CreateTick(0, 16, function()
      if self.animator then
        local animState = self.animator:GetCurrentAnimatorStateInfo(0)
        local complete = animState.normalizedTime >= 1
        local isPlaying = animState:IsName(self.animEndName)
        if complete and isPlaying then
          if self.checkAnimTimerId then
            TimeTickManager.Me():ClearTick(self)
            self.checkAnimTimerId = nil
          end
          self.checkAnimTimerId = nil
          self:HandleEffectEnd()
          self.isProcessEffectEnd = false
        end
      elseif self.checkAnimTimerId then
        TimeTickManager.Me():ClearTick(self)
        self.checkAnimTimerId = nil
      end
    end, self)
  else
    self:HandleEffectEnd()
    self.isProcessEffectEnd = false
  end
end

function FloatAwardShareView:HandleEffectEnd()
  self:startShow()
end

function FloatAwardShareView:checkStart()
  if not self.isShowIng then
    self:startShow()
  end
end

function FloatAwardShareView:isShowSkipBtn()
  local num = 0
  for i = 1, #self.showTypeList do
    local single = self.showTypeList[i]
    num = num + #self.showListWithType[single]
  end
  return 0 < num
end

function FloatAwardShareView:startShow()
  printRed("startShow")
  local showType = self:nextShowType()
  if showType then
    self:PlayUISound(AudioMap.Maps.FunctionOpen)
    self.isShowIng = true
    local showData = self.showListWithType[showType][1]
    if showType == FloatAwardShareView.ShowType.ModelType then
      self:showModelEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardShareView.ShowType.CardType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardShareView.ShowType.IconType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardShareView.ShowType.ItemType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    end
    self:changeShowMode(showData)
    if self.isHideAllBtn then
      self:Hide(self.skipBtn)
      self:Hide(self.shareBtnCt)
    elseif self:isShowSkipBtn() then
      self:Show(self.skipBtn)
    else
      self:Hide(self.skipBtn)
    end
  else
    self:CloseSelf()
  end
end

function FloatAwardShareView:changeShowMode(showData)
  local type = showData.showType
  local effectFromType = showData.effectFromType
  if effectFromType == FloatAwardShareView.EffectFromType.AwardType then
    if type == FloatAwardShareView.ShowType.ModelType then
      self:Show(self.modelShow)
    elseif type == FloatAwardShareView.ShowType.CardType then
      self:Hide(self.modelShow)
    end
  elseif effectFromType == FloatAwardShareView.EffectFromType.GMType then
    self.modelShow:SetActive(false)
  end
  self:Hide(self.shareBtnCt)
end

function FloatAwardShareView:changeBtnState()
  local effectFromType = self.currentShowData.effectFromType
  if effectFromType == FloatAwardShareView.EffectFromType.AwardType then
  else
  end
end

function FloatAwardShareView:nextShowType()
  if self.currentShowType and #self.showListWithType[self.currentShowType] > 1 then
    return self.currentShowType
  else
    for i = 1, #self.showTypeList do
      local single = self.showTypeList[i]
      if #self.showListWithType[single] > 0 then
        return single
      end
    end
  end
end

function FloatAwardShareView:showCardEffect(showData)
end

function FloatAwardShareView:showIconEffect(showData)
  if self.currentShowData then
    self.currentShowData:Exit()
  end
  local effectPath = showData.effectPath
  local showType = showData.showType
  self:initEffectModel(effectPath)
  local effectIcon = self:FindGO("icon", self:FindGO("13itemShine"))
  showData:getModelObj(effectIcon)
  self.itemName.text = showData.dataName
  self.currentEffectPath = effectPath
  self.currentShowType = showType
  self.currentShowData = showData
  self.animator:Play(self.animStartName, -1, 0)
  self.isShowIngIconAnim = true
end

function FloatAwardShareView:showModelEffect(showData)
  if self.currentShowData then
    self.currentShowData:Exit()
  end
  self:initEffectModel(showData.effectPath)
  if showData.itemData.equipInfo then
    local itemModelName = showData.itemData.equipInfo.equipData.Model
    local modelConfig = ModelShowConfig[itemModelName]
    LuaVector3.Better_Set(tempVector3, 0, 0, 0)
    LuaQuaternion.Better_Set(tempQuaternion, 0, 0, 0, 0)
    LuaVector3.Better_Set(tempVector3_scale, 1, 1, 1)
    if modelConfig then
      local position = modelConfig.localPosition
      LuaVector3.Better_Set(tempVector3, position[1], position[2], position[3])
      local rotation = modelConfig.localRotation
      LuaQuaternion.Better_Set(tempQuaternion, rotation[1], rotation[2], rotation[3], rotation[4])
      local scale = modelConfig.localScale
      LuaVector3.Better_Set(tempVector3_scale, scale[1], scale[2], scale[3])
    elseif showData.itemData:IsMount() then
      LuaVector3.Better_Set(tempVector3, 0, 0, 0)
      LuaQuaternion.Better_SetEulerAngles(tempQuaternion, tempVector3)
      LuaVector3.Better_Set(tempVector3, 0, -0.17, 0)
      LuaVector3.Better_Set(tempVector3_scale, 0.3, 0.3, 0.3)
    else
      printRed("can't find " .. itemModelName .. " ` ModelShowConfig")
      LuaVector3.Better_Set(tempVector3, 0, 0, 0)
      LuaQuaternion.Better_SetEulerAngles(tempQuaternion, tempVector3)
      LuaVector3.Better_Set(tempVector3_scale, 1, 1, 1)
    end
    local sid = showData.itemData.staticData.id
    local partIndex = ItemUtil.getItemRolePartIndex(sid)
    UIModelUtil.Instance:SetRolePartModelTexture(self.modelTexture, partIndex, sid, nil, function(rolePart, self, assetRolePart)
      self.itemModel = assetRolePart
      UIModelUtil.Instance:SetCellTransparent(self.modelTexture)
      if self.itemModel == nil then
        printRed("error! 没有该道具模型")
      else
        local pss = rolePart.gameObject:GetComponentsInChildren(ParticleSystem)
        for i = 1, #pss do
          pss[i].gameObject:SetActive(false)
        end
        self.itemModel:ResetLocalPosition(tempVector3)
        LuaQuaternion.Better_GetEulerAngles(tempQuaternion, tempVector3_rotation)
        self.itemModel:ResetLocalEulerAngles(tempVector3_rotation)
        self.itemModel:ResetLocalScale(tempVector3_scale)
        local container = UIModelUtil.Instance:GetContainerObj(self.modelTexture)
        if container then
          container.transform.localPosition = LuaGeometry.GetTempVector3()
          container.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
          local tr = container.gameObject:GetComponent(TweenRotation)
          if not tr then
            tr = container.gameObject:AddComponent(TweenRotation)
            tr.from = LuaGeometry.GetTempVector3(0, -180, 0)
            tr.to = LuaGeometry.GetTempVector3(0, 180, 0)
            tr.duration = 5
            tr.style = 1
          end
        end
      end
      local name = showData.dataName
      self.Show(self.itemNameCt)
      self.itemName.text = name
      local property = showData.itemData.equipInfo:BasePropStr()
      if not property or property == "" then
        local buff = showData.itemData.equipInfo.equipData.UniqueEffect.buff
        buff = buff and buff[1] or nil
        if buff then
          buff = Table_Buffer[buff]
          if buff and buff.Dsc == "" then
            goto lbl_127
          end
        end
      else
      end
      ::lbl_127::
      self.animator:Play(self.animStartName, -1, 0)
      self.currentShowType = showData.showType
      self.currentShowData = showData
      self.currentEffectPath = showData.effectPath
    end, self)
  else
    printRed("equipInfo is nil!!!")
  end
end

function FloatAwardShareView.OnModelCreate(rolePart, self)
  if rolePart then
    local pss = rolePart.gameObject:GetComponentsInChildren(ParticleSystem)
    for i = 1, #pss do
      pss[i].gameObject:SetActive(false)
    end
  end
end

function FloatAwardShareView:initEffectModel(effectPath)
  if self.currentEffectPath ~= effectPath and self.effectGo then
    Game.GOLuaPoolManager:AddToUIPool(self.currentEffectPath, self.effectGo)
    self.effectGo = nil
  end
  if not self.effectGo then
    self.effectGo = Game.AssetManager_UI:CreateAsset(effectPath, self.gameObject)
    self.effectContainer:AddChild(self.effectGo)
    LuaVector3.Better_Set(tempVector3, 1, 1, 1)
    self.effectGo.transform.localScale = tempVector3
    LuaVector3.Better_Set(tempVector3, 0, 0, 0)
    self.effectGo.transform.localRotation = tempVector3
    self.effectGo.transform.localPosition = tempVector3
    self.animator = self.effectGo:GetComponent(Animator)
    if self.animator then
      self.animator:Play(self.animIdleName, -1, 0)
    end
  end
end

function FloatAwardShareView:OnExit()
  if self.currentShowData then
    if MountLotteryProxy.Instance.isNewRound then
      GameFacade.Instance:sendNotification(MountLotteryEvent.NewRound)
    elseif MountLotteryProxy.Instance.showGift and not MountLotteryProxy.Instance.isFinished then
      GameFacade.Instance:sendNotification(MountLotteryEvent.FinishRound)
    elseif MountLotteryProxy.Instance:CheckFinishAll() then
      GameFacade.Instance:sendNotification(MountLotteryEvent.EndAll)
    elseif MountLotteryProxy.Instance:CheckBackTocards() then
      GameFacade.Instance:sendNotification(MountLotteryEvent.BackToCards)
    end
    self.currentShowData:Exit()
  end
  if self.onExitCallback then
    self.onExitCallback()
  end
  self.currentShowType = nil
  self.currentShowData = nil
  self.currentEffectPath = nil
  self.isShowIngIconAnim = false
  self.isShowIng = false
  if self.checkAnimTimerId then
    TimeTickManager.Me():ClearTick(self)
    self.checkAnimTimerId = nil
  end
  TimeTickManager.Me():ClearTick(self)
  self.checkAnimTimerId = nil
  self.animator = nil
  self.effectGo = nil
  local id = Game.Myself.data.id
  if self.disableMsg then
    return
  end
  if self.items and #self.items > 0 then
    for i = 1, #self.items do
      local single = self.items[i]
      MsgManager.ShowMsgByIDTable(11, single, id)
    end
  end
  self.haveCountBack:SetActive(false)
  self.modelTexture = nil
  self.isHideAllBtn = false
  FloatAwardShareView.super.OnExit(self)
end

function FloatAwardShareView:handleEffectStart()
end

function FloatAwardShareView:ShowHaveCount(count)
  self.haveCountBack:SetActive(true)
  self.haveCount.text = string.format(ZhString.FloatAwardView_Have, count)
end

function FloatAwardShareView:HideHaveCount()
  self.haveCountBack:SetActive(false)
end

local screenShotWidth = -1
local screenShotHeight = 1080
local textureFormat = TextureFormat.RGB24
local texDepth = 24
local antiAliasing = ScreenShot.AntiAliasing.None
local shotName = "RO_ShareTemp"

function FloatAwardShareView:SharePicture(platform_type, content_title, content_body)
  helplog("FloatAwardShareView SharePicture", platform_type)
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
