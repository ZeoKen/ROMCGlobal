FloatAwardChatShareView = class("FloatAwardChatShareView", ContainerView)
autoImport("EffectShowDataWraper")
FloatAwardChatShareView.ViewType = UIViewType.ShareLayer
FloatAwardChatShareView.ShowType = {
  ModelType = 1,
  CardType = 2,
  IconType = 3,
  ItemType = 4
}
FloatAwardChatShareView.EffectPath = {
  EffectType_1 = "Public/Effect/UI/13itemShine_03"
}
FloatAwardChatShareView.EffectFromType = {
  AwardType = 1,
  GMType = 2,
  RefineType = 3
}
FloatAwardChatShareView.TimeTickType = {CheckAnim = 1, ShowIconOneByOne = 2}
local tempVector3 = LuaVector3.Zero()
local tempVector3_rotation = LuaVector3.Zero()
local tempVector3_scale = LuaVector3.Zero()
local tempQuaternion = LuaQuaternion.Identity()

function FloatAwardChatShareView:Init()
  self:initView()
  self:addViewListener()
  self:initData()
end

function FloatAwardChatShareView:initView()
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
  myName.text = self.viewdata.viewdata.name
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
  local rologo = self:FindGO("Logo")
  local texName = GameConfig.Share.Logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  self:AddButtonEvent("BgClick", function(go)
    self:CloseSelf()
  end)
  self.isHideAllBtn = false
end

function FloatAwardChatShareView:IsShowNameBg(isShow)
  self.isShowN = isShow
  if isShow then
    self:Show(self.nameBg)
  else
    self:Hide(self.nameBg)
  end
end

function FloatAwardChatShareView:addViewListener()
end

function FloatAwardChatShareView:initData()
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
  for k, v in pairs(FloatAwardChatShareView.ShowType) do
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

function FloatAwardChatShareView:checkIsPlayIngStartOrEndAnim()
  if self.animator then
    local animState = self.animator:GetCurrentAnimatorStateInfo(0)
    local complete = animState.normalizedTime >= 1
    local isPlaying = animState:IsName(self.animEndName) or animState:IsName(self.animStartName)
    if not complete and isPlaying or self.isShowIngIconAnim then
      return true
    end
  end
end

function FloatAwardChatShareView:checkEffectType(itemData)
  if itemData.staticData then
    if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
      return FloatAwardChatShareView.ShowType.ModelType
    elseif BagProxy.CheckIsCardTypeItem(itemData.staticData.Type) then
      return FloatAwardChatShareView.ShowType.CardType
    else
      return FloatAwardChatShareView.ShowType.ItemType
    end
  end
  return FloatAwardChatShareView.ShowType.IconType
end

function FloatAwardChatShareView.checkEffectPath(argumentTable)
  if nil == argumentTable or nil == argumentTable.effectPath then
    return FloatAwardChatShareView.EffectPath.EffectType_1
  end
  return argumentTable.effectPath
end

function FloatAwardChatShareView:checkStartAnim()
  if not self:checkIsPlayIngStartOrEndAnim() then
    TimeTickManager.Me():ClearTick(self, FloatAwardChatShareView.TimeTickType.CheckAnim)
    self:changeBtnState()
  else
  end
end

function FloatAwardChatShareView:IsRaritySSR(itemid)
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

function FloatAwardChatShareView:addItemDataToShow(data, argumentTable)
  local showType = self:checkEffectType(data)
  if showType then
    local effectPath = FloatAwardChatShareView.checkEffectPath(argumentTable)
    if self:IsRaritySSR(data.staticData.id) then
      effectPath = ResourcePathHelper.EffectUI(EffectMap.UI.ShareItemShine_SSR)
    end
    local showData = EffectShowDataWraper.new(data, effectPath, showType, FloatAwardChatShareView.EffectFromType.AwardType, argumentTable)
    showType = showData.showType
    table.insert(self.showListWithType[showType], showData)
  else
    LogUtility.Warning("error!!! incorrect item type!")
  end
end

function FloatAwardChatShareView:showEffectEnd()
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

function FloatAwardChatShareView:HandleEffectEnd()
  self:startShow()
end

function FloatAwardChatShareView:checkStart()
  if not self.isShowIng then
    self:startShow()
  end
end

function FloatAwardChatShareView:isShowSkipBtn()
  local num = 0
  for i = 1, #self.showTypeList do
    local single = self.showTypeList[i]
    num = num + #self.showListWithType[single]
  end
  return 0 < num
end

function FloatAwardChatShareView:startShow()
  printRed("startShow")
  local showType = self:nextShowType()
  if showType then
    self:PlayUISound(AudioMap.Maps.FunctionOpen)
    self.isShowIng = true
    local showData = self.showListWithType[showType][1]
    if showType == FloatAwardChatShareView.ShowType.ModelType then
      self:showModelEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardChatShareView.ShowType.CardType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardChatShareView.ShowType.IconType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardChatShareView.ShowType.ItemType then
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

function FloatAwardChatShareView:changeShowMode(showData)
  local type = showData.showType
  local effectFromType = showData.effectFromType
  if effectFromType == FloatAwardChatShareView.EffectFromType.AwardType then
    if type == FloatAwardChatShareView.ShowType.ModelType then
      self:Show(self.modelShow)
    elseif type == FloatAwardChatShareView.ShowType.CardType then
      self:Hide(self.modelShow)
    end
  elseif effectFromType == FloatAwardChatShareView.EffectFromType.GMType then
    self.modelShow:SetActive(false)
  end
  self:Hide(self.shareBtnCt)
end

function FloatAwardChatShareView:changeBtnState()
  local effectFromType = self.currentShowData.effectFromType
  if effectFromType == FloatAwardChatShareView.EffectFromType.AwardType then
  else
  end
end

function FloatAwardChatShareView:nextShowType()
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

function FloatAwardChatShareView:showCardEffect(showData)
end

function FloatAwardChatShareView:showIconEffect(showData)
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

function FloatAwardChatShareView:showModelEffect(showData)
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

function FloatAwardChatShareView.OnModelCreate(rolePart, self)
  if rolePart then
    local pss = rolePart.gameObject:GetComponentsInChildren(ParticleSystem)
    for i = 1, #pss do
      pss[i].gameObject:SetActive(false)
    end
  end
end

function FloatAwardChatShareView:initEffectModel(effectPath)
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

function FloatAwardChatShareView:OnExit()
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
  FloatAwardChatShareView.super.OnExit(self)
end

function FloatAwardChatShareView:handleEffectStart()
end

function FloatAwardChatShareView:ShowHaveCount(count)
  self.haveCountBack:SetActive(true)
  self.haveCount.text = string.format(ZhString.FloatAwardView_Have, count)
end

function FloatAwardChatShareView:HideHaveCount()
  self.haveCountBack:SetActive(false)
end
