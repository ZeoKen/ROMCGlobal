FloatAwardView = class("FloatAwardView", BaseView)
autoImport("EffectShowDataWraper")
FloatAwardView.ViewType = UIViewType.Show3D2DLayer
FloatAwardView.ShowType = {
  ModelType = 1,
  CardType = 2,
  IconType = 3,
  ItemType = 4
}
FloatAwardView.EffectPath = {
  EffectType_1 = "Public/Effect/UI/13itemShine",
  EffectType_2 = "Public/Effect/UI/itemShine_SSR"
}
FloatAwardView.EffectFromType = {
  AwardType = 1,
  GMType = 2,
  RefineType = 3
}
FloatAwardView.TimeTickType = {CheckAnim = 1, ShowIconOneByOne = 2}
local tempVector3 = LuaVector3.Zero()
local tempVector3_rotation = LuaVector3.Zero()
local tempVector3_scale = LuaVector3.Zero()
local tempQuaternion = LuaQuaternion.Identity()

function FloatAwardView:Init()
  if FloatAwardView.Instance == nil then
    FloatAwardView.Instance = self
  end
  self:initView()
  self:addViewListener()
  self:initData()
end

function FloatAwardView:initView()
  self.effectContainer = self:FindGO("EffectContainer"):GetComponent(ChangeRqByTex)
  self.propertyContainer = self:FindGO("propertyContainer")
  self:Hide(self.propertyContainer)
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.propertyContainer.transform))
  tempVector3[3] = -200
  self.propertyContainer.transform.localPosition = tempVector3
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.itemNameCt = self:FindGO("itemNameCt")
  self.intoPackBtn = self:FindGO("intoPackBtn")
  self.intoPackLabel = self:FindGO("intoPackLabel"):GetComponent(UILabel)
  self.intoPackRichLabel = self:FindGO("intoPackRichLabel")
  self.equipBtn = self:FindGO("equipBtn")
  self.equipLabel = self:FindComponent("Label", UILabel, self.equipBtn)
  self.modelShow = self:FindGO("modelShow")
  self.shareBtnCt = self:FindGO("shareBtnCt")
  self.skipBtn = self:FindGO("skipBtn")
  self.nameBg = self:FindGO("nameBg")
  self.haveCountBack = self:FindGO("HaveCountBack")
  self.haveCount = self:FindComponent("HaveCount", UILabel)
  self.lotteryLimit = self:FindGO("LotteryLimit"):GetComponent(UILabel)
  self.lotteryLimitBg = self:FindGO("Bg1", self.lotteryLimit.gameObject):GetComponent(UISprite)
  self.closeWhenClickOtherPlaceTip = self:FindGO("CloseWhenClickOtherPlaceTip")
  self.modelTexture = self:FindComponent("modelTexture", UITexture)
  self:Hide(self.nameBg)
  self:AddClickEvent(self.shareBtnCt, function()
    self:Log("shareBtnCt AddClickEvent")
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    local data = self.currentShowData:clone()
    if data.itemData and data.itemData.staticData and self.checkIsKFCAct(data.itemData.staticData.id) then
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.KFCActivityShowView,
        viewdata = data.itemData.staticData.id
      })
      return
    end
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShareAwardView,
      viewdata = data
    })
  end)
  self:AddClickEvent(self.skipBtn, function()
    self:Log("skipBtn AddClickEvent")
    self:CloseSelf()
  end)
  self.isHideAllBtn = false
  self.closeWhenClickOtherPlace = false
  self.quickCloseAnimation = false
  self:AddButtonEvent("BgClick", function(go)
    if self.isHideAllBtn or self.closeWhenClickOtherPlace then
      self:CloseSelf()
    end
  end)
  self.share = self:FindGO("ShareButton")
  self:AddClickEvent(self.share, function()
    if self.currentShowData and self.currentShowData.itemData then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.FloatAwardShareView,
        viewdata = {
          data = self.currentShowData.itemData,
          argumentTable = self.curArgumentTable
        }
      })
    end
  end)
  self:Hide(self.share)
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
end

function FloatAwardView:IsShowNameBg(isShow)
  self.isShowN = isShow
  if isShow then
    self:Show(self.nameBg)
  else
    self:Hide(self.nameBg)
  end
end

function FloatAwardView:addViewListener()
  self:AddClickEvent(self.intoPackBtn, function()
    if self.quickCloseAnimation then
      if self.currentShowData and self.currentShowData.leftBtnCallback then
        self.currentShowData.leftBtnCallback()
      end
      self:HandleEffectEnd()
      self.isProcessEffectEnd = false
    elseif not self.isProcessEffectEnd then
      self:showEffectEnd()
      if self.currentShowData and self.currentShowData.leftBtnCallback then
        self.currentShowData.leftBtnCallback()
      end
    end
    GameFacade.Instance:sendNotification(XDEUIEvent.LotteryAnimationEnd)
  end)
  self:AddClickEvent(self.equipBtn, function()
    if not self.isProcessEffectEnd then
      self:showEffectEnd()
      if self.currentShowData and self.currentShowData.rightBtnCallback then
        self.currentShowData.rightBtnCallback()
        return
      end
      local itemData = self.currentShowData.itemData
      if itemData == nil or itemData.id == nil or itemData.id == 0 then
      elseif self.currentShowData.leftBtnText then
      else
        FunctionItemFunc.CallEquipEvt(itemData)
      end
    end
  end)
  self:AddListenEvt(ShareNewEvent.HideWeekShraeTip, self.OnHideWeekShareTip)
end

function FloatAwardView:OnHideWeekShareTip()
  local rewardTips = self:FindGO("WeekRewardTips")
  if rewardTips then
    rewardTips:SetActive(false)
  end
end

function FloatAwardView:initData()
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
  for k, v in pairs(FloatAwardView.ShowType) do
    table.insert(self.showTypeList, v)
    self.showListWithType[v] = {}
  end
  table.sort(self.showTypeList, function(l, r)
    return l < r
  end)
  self.noShareFunction = not FloatAwardView.ShareFunctionIsOpen()
  self.lotteryLimit.text = ""
end

function FloatAwardView.ShareFunctionIsOpen()
  local socialShareConfig = AppBundleConfig.GetSocialShareInfo()
  if socialShareConfig == nil then
    return false
  end
  if BackwardCompatibilityUtil.CompatibilityMode(BackwardCompatibilityUtil.V9) then
    return false
  end
  return true
end

function FloatAwardView:checkIsPlayIngStartOrEndAnim()
  if self.animator then
    local animState = self.animator:GetCurrentAnimatorStateInfo(0)
    local complete = animState.normalizedTime >= 1
    local isPlaying = animState:IsName(self.animEndName) or animState:IsName(self.animStartName)
    if not complete and isPlaying or self.isShowIngIconAnim then
      return true
    end
  end
end

function FloatAwardView.checkEffectType(itemData)
  if itemData.staticData then
    if BagProxy.CheckIs3DTypeItem(itemData.staticData.Type) then
      return FloatAwardView.ShowType.ModelType
    elseif BagProxy.CheckIsCardTypeItem(itemData.staticData.Type) then
      return FloatAwardView.ShowType.CardType
    else
      return FloatAwardView.ShowType.ItemType
    end
  end
  return FloatAwardView.ShowType.IconType
end

function FloatAwardView.checkIsKFCAct(id)
  local tb = GameConfig.KFCItems or {}
  return nil ~= tb[id]
end

function FloatAwardView.checkIfCanEquip(itemData)
  local bRet = false
  if itemData and itemData.staticData then
    if QuickUseProxy.Instance:ContainsEquip(itemData) then
      bRet = true
    end
    if QuickUseProxy.Instance:ContainsFashion(itemData.staticData.id) then
      bRet = true
    end
  end
  return bRet
end

function FloatAwardView.ShowRefineShareView(itemData)
  local showType = FloatAwardView.checkEffectType(itemData)
  if showType and FloatAwardView.ShareFunctionIsOpen() then
    local showData = EffectShowDataWraper.new(itemData, nil, FloatAwardView.ShowType.ItemType, FloatAwardView.EffectFromType.RefineType)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShareAwardView,
      viewdata = showData
    })
  end
end

function FloatAwardView.ShowRefineShareViewNew(itemData)
  local showType = FloatAwardView.checkEffectType(itemData)
  local showData = EffectShowDataWraper.new(itemData, nil, FloatAwardView.ShowType.ItemType, FloatAwardView.EffectFromType.RefineType)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RefineShareView,
    viewdata = showData
  })
end

function FloatAwardView.checkEffectPath(argumentTable, itemData)
  if nil == argumentTable or nil == argumentTable.effectPath then
    if LotteryProxy.IsSSR(itemData) or itemData and itemData.cardInfo and (itemData.cardInfo.CardType == 3 or itemData.cardInfo.ComposeCardType == 3) then
      return FloatAwardView.EffectPath.EffectType_2
    end
    return FloatAwardView.EffectPath.EffectType_1
  end
  return argumentTable.effectPath
end

function FloatAwardView.getInstance()
  if FloatAwardView.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FloatAwardView
    })
  end
  return FloatAwardView.Instance
end

function FloatAwardView:checkStartAnim()
  if not self:checkIsPlayIngStartOrEndAnim() then
    TimeTickManager.Me():ClearTick(self, FloatAwardView.TimeTickType.CheckAnim)
    self:changeBtnState()
  else
  end
end

function FloatAwardView.addItemDataToShow(data, argumentTable)
  local instance = FloatAwardView.getInstance()
  instance.curArgumentTable = argumentTable
  local showType = FloatAwardView.checkEffectType(data)
  if showType then
    local effectPath = FloatAwardView.checkEffectPath(argumentTable, data)
    local showData = EffectShowDataWraper.new(data, effectPath, showType, FloatAwardView.EffectFromType.AwardType, argumentTable)
    showType = showData.showType
    table.insert(instance.showListWithType[showType], showData)
  else
    LogUtility.Warning("error!!! incorrect item type!")
  end
end

function FloatAwardView.addItemDatasToShow(datas, argumentTable)
  local instance = FloatAwardView.getInstance()
  for i = 1, #datas do
    local single = datas[i]
    local params = {}
    params[1] = single.staticData.id
    params[2] = single.num or 1
    if single.num == nil or single.num == 0 then
      FloatAwardView.addItemDataToShow(single, argumentTable)
      instance.items[#instance.items + 1] = {
        single.staticData.id,
        1
      }
    else
      instance.items[#instance.items + 1] = {
        single.staticData.id,
        single.num
      }
      FloatAwardView.addItemDataToShow(single, argumentTable)
    end
  end
  if argumentTable then
    instance.disableMsg = argumentTable.disableMsg
    instance.onExitCallback = argumentTable.onExitCallback
    instance.isHideAllBtn = argumentTable.isHideAllBtn
    instance.closeWhenClickOtherPlace = argumentTable.closeWhenClickOtherPlace
    instance.quickCloseAnimation = argumentTable.quickCloseAnimation
  end
  instance:checkStart()
end

function FloatAwardView.gmAddItemDataToShow(data)
  local instance = FloatAwardView.getInstance()
  local showType = FloatAwardView.ShowType.IconType
  local effectPath = FloatAwardView.checkEffectPath()
  local tb = TableUtil.unserialize(data.data)
  if tb then
    local showData = EffectShowDataWraper.new(data, effectPath, showType, FloatAwardView.EffectFromType.GMType)
    table.insert(instance.showListWithType[showType], showData)
  end
end

function FloatAwardView.gmAddItemDatasToShow(list)
  for i = 1, #list do
    local single = list[i]
    FloatAwardView.gmAddItemDataToShow(single)
  end
  local instance = FloatAwardView.getInstance()
  instance:checkStart()
end

function FloatAwardView.gmAddAchievementDatasToShow(data)
  local items = data.items
  if items and 0 < #items then
    local showCount = 0
    for i = 1, #items do
      local single = items[i]
      if single.finishtime and 0 < single.finishtime and not single.reward_get then
        local achievementConfig = Table_Achievement[single.id]
        if achievementConfig then
          local showAttrTip = achievementConfig and achievementConfig.ShowAttrGetTip
          if showAttrTip then
            local tb = {
              type = "achievement",
              id = single.id
            }
            local argumentTable = {}
            local rewardAttr = achievementConfig.RewardAttr
            local attrName
            for name, value in pairs(rewardAttr) do
              attrName = name
              local iconConfig = GameConfig.AchievementAttrReward and GameConfig.AchievementAttrReward[attrName]
              if iconConfig then
                tb.icon = iconConfig.icon
                tb.scale = iconConfig.scale or 1
                if iconConfig.sound then
                  argumentTable.audioEffect = iconConfig.sound
                end
              end
              break
            end
            local attrDes = achievementConfig.AttrDes
            if attrDes ~= "" then
              tb.text = attrDes
            end
            local tempData = {
              data = Serialize(tb),
              type = EffectShowDataWraper.IconType.ui
            }
            local instance = FloatAwardView.getInstance()
            local showType = FloatAwardView.ShowType.IconType
            local effectPath = FloatAwardView.checkEffectPath()
            local showData = EffectShowDataWraper.new(tempData, effectPath, showType, FloatAwardView.EffectFromType.GMType, argumentTable)
            table.insert(instance.showListWithType[showType], showData)
            showCount = showCount + 1
          end
        end
      end
    end
    if 0 < showCount then
      local instance = FloatAwardView.getInstance()
      instance:checkStart()
    end
  end
end

function FloatAwardView:showEffectEnd()
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

function FloatAwardView:HandleEffectEnd()
  self:startShow()
end

function FloatAwardView:checkStart()
  if not self.isShowIng then
    self:startShow()
  end
end

function FloatAwardView:isShowSkipBtn()
  local num = 0
  for i = 1, #self.showTypeList do
    local single = self.showTypeList[i]
    num = num + #self.showListWithType[single]
  end
  return 0 < num
end

function FloatAwardView:startShow()
  printRed("startShow")
  local showType = self:nextShowType()
  if showType then
    self.isShowIng = true
    local showData = self.showListWithType[showType][1]
    local audioEffect = showData.audioEffect
    if audioEffect then
      self:PlayUISound(audioEffect)
    else
      self:PlayUISound(AudioMap.Maps.FunctionOpen)
    end
    if showType == FloatAwardView.ShowType.ModelType then
      self:showModelEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardView.ShowType.CardType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardView.ShowType.IconType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    elseif showType == FloatAwardView.ShowType.ItemType then
      self:showIconEffect(showData)
      table.remove(self.showListWithType[showType], 1)
    end
    self:changeShowMode(showData)
    if self.isHideAllBtn then
      self:Hide(self.skipBtn)
      self:Hide(self.intoPackBtn)
      self:Hide(self.equipBtn)
      self:Hide(self.shareBtnCt)
    elseif self:isShowSkipBtn() then
      self:Show(self.skipBtn)
    else
      self:Hide(self.skipBtn)
    end
    if self.closeWhenClickOtherPlace ~= nil then
      self.closeWhenClickOtherPlaceTip:SetActive(self.closeWhenClickOtherPlace)
    end
  else
    self:CloseSelf()
  end
end

function FloatAwardView:changeShowMode(showData)
  local type = showData.showType
  local canEquip = FloatAwardView.checkIfCanEquip(showData.itemData)
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.intoPackBtn.transform))
  local effectFromType = showData.effectFromType
  if effectFromType == FloatAwardView.EffectFromType.AwardType then
    self.equipLabel.text = ZhString.FloatAwardView_Equip
    self.intoPackBtn:SetActive(true)
    if showData.leftBtnText then
      self.intoPackLabel.text = showData.leftBtnText
    elseif showData.leftBtnRichText then
      self.intoPackLabel.text = ""
      local sl = SpriteLabel.new(self.intoPackRichLabel, nil, 36, 36, true)
      sl:SetText(showData.leftBtnRichText, true)
    else
      self.intoPackLabel.text = ZhString.FloatAwardView_IntoPackage
    end
    if showData.hideEquipBtn then
      self:Hide(self.equipBtn)
      tempVector3[1] = 0
      self.intoPackBtn.transform.localPosition = tempVector3
    elseif showData.rightBtnText then
      self:Show(self.equipBtn)
      tempVector3[1] = -134
      self.intoPackBtn.transform.localPosition = tempVector3
      self.equipLabel.text = showData.rightBtnText
    elseif canEquip then
      self:Show(self.equipBtn)
      tempVector3[1] = -134
      self.intoPackBtn.transform.localPosition = tempVector3
    else
      self:Hide(self.equipBtn)
      tempVector3[1] = 0
      self.intoPackBtn.transform.localPosition = tempVector3
    end
    if type == FloatAwardView.ShowType.ModelType then
      self:Show(self.modelShow)
    elseif type == FloatAwardView.ShowType.CardType then
      self:Hide(self.modelShow)
    end
  elseif effectFromType == FloatAwardView.EffectFromType.GMType then
    self.intoPackLabel.text = ZhString.FloatAwardView_Confirm
    self:Hide(self.equipBtn)
    tempVector3[1] = 0
    self.intoPackBtn.transform.localPosition = tempVector3
    self.modelShow:SetActive(false)
  end
  if showData:canBeShared() and not self.noShareFunction then
    self:Show(self.shareBtnCt)
  else
    self:Hide(self.shareBtnCt)
  end
end

function FloatAwardView:changeBtnState()
  local canEquip = FloatAwardView.checkIfCanEquip(self.currentShowData.itemData)
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.intoPackBtn.transform))
  local effectFromType = self.currentShowData.effectFromType
  if effectFromType == FloatAwardView.EffectFromType.AwardType then
    self.intoPackBtn:SetActive(true)
    if canEquip and not self.currentShowData.hideEquipBtn then
      self.equipBtn:SetActive(true)
      tempVector3[1] = -134
      self.intoPackBtn.transform.localPosition = tempVector3
    else
      self.equipBtn:SetActive(false)
      tempVector3[1] = 0
      self.intoPackBtn.transform.localPosition = tempVector3
    end
  else
    tempVector3[1] = 0
    self.intoPackBtn.transform.localPosition = tempVector3
  end
end

function FloatAwardView:nextShowType()
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

function FloatAwardView:showCardEffect(showData)
end

function FloatAwardView:showIconEffect(showData)
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

function FloatAwardView:showModelEffect(showData)
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

function FloatAwardView.OnModelCreate(rolePart, self)
  if rolePart then
    local pss = rolePart.gameObject:GetComponentsInChildren(ParticleSystem)
    for i = 1, #pss do
      pss[i].gameObject:SetActive(false)
    end
  end
end

function FloatAwardView:initEffectModel(effectPath)
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

function FloatAwardView:OnEnter()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    LotteryProxy.Instance:HandleEscRecvinfo()
    self:CloseSelf()
  end)
  FloatAwardView.super.OnEnter(self)
end

function FloatAwardView:OnExit()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
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
  FloatAwardView.Instance = nil
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
  self.closeWhenClickOtherPlace = false
  self.quickCloseAnimation = false
  FloatAwardView.super.OnExit(self)
end

function FloatAwardView:handleEffectStart()
end

function FloatAwardView.showHaveCount(count)
  FloatAwardView.getInstance():ShowHaveCount(count)
end

function FloatAwardView:ShowHaveCount(count)
  self.haveCountBack:SetActive(true)
  self.haveCount.text = string.format(ZhString.FloatAwardView_Have, count)
end

function FloatAwardView.showLotteryLimit(lotteryType)
  FloatAwardView.getInstance():ShowLotteryLimit(lotteryType)
end

function FloatAwardView:ShowLotteryLimit(lotteryType)
  local sb = LuaStringBuilder.CreateAsTable()
  local data = LotteryProxy.Instance:GetInfo(lotteryType)
  if data ~= nil and data.maxCount ~= 0 then
    sb:Append(string.format(ZhString.Lottery_TodayLimit, data.todayCount, data.maxCount))
  end
  local isShow = 0 < #sb.content
  if self.lotteryLimit and self.lotteryLimitBg then
    self.lotteryLimit.gameObject:SetActive(isShow)
    if isShow then
      self.lotteryLimit.text = sb:ToString()
      self.lotteryLimitBg.width = self.lotteryLimit.localSize.x + 70
    end
  end
  sb:Destroy()
end

function FloatAwardView.hideHaveCount()
  FloatAwardView.getInstance():HideHaveCount()
end

function FloatAwardView:HideHaveCount()
  self.haveCountBack:SetActive(false)
end

function FloatAwardView:ForceNewShare()
  local instance = FloatAwardView.getInstance()
  instance:Hide(instance.shareBtnCt)
  instance:Show(instance.share)
end
