TipManager = class("TipManager")
autoImport("BubbleTip")
autoImport("ItemFloatTip")
autoImport("ItemScoreTip")
autoImport("MonsterScoreTip")
autoImport("NpcScoreTip")
autoImport("MonthScoreTip")
autoImport("CollectScoreTip")
autoImport("PetScoreTip")
autoImport("CollectGroupScoreTip")
autoImport("AdventureEquipComposeTip")
autoImport("NormalTip")
autoImport("ItemFormulaTip")
autoImport("RecommendPetTip")
autoImport("AstrolabeTipView")
autoImport("HireCatTip")
autoImport("TitlePropTip")
autoImport("TitleTip")
autoImport("FoodRecipeTip")
autoImport("SkipAnimationTip")
autoImport("ToggleEditConfirmTip")
autoImport("EquipChooseTip")
autoImport("PetFashionChooseTip")
autoImport("SkillTip")
autoImport("SkillTip_Func")
autoImport("PetSkillTip")
autoImport("TutorFindTip")
autoImport("PreQuestTip")
autoImport("GvgQuestScoreTip")
autoImport("GvgFinalFightTip")
autoImport("HRefineAddEffectTip")
autoImport("TaskQuestTip")
autoImport("GuildBuildingTip")
autoImport("ExchangeGoodsTip")
autoImport("PetAdventureSpeicidTip")
autoImport("PetAdventureEffTip")
autoImport("PropTypeTip")
autoImport("PetAdventureHeadTip")
autoImport("EatFoodInfoTip")
autoImport("FeedPetTip")
autoImport("TabNameTip")
autoImport("PropTipHelp")
autoImport("ServerPopupListTip")
autoImport("GemItemFloatTip")
autoImport("BigMapQuestTip")
autoImport("MainViewMapSettingPage")
autoImport("TechTreeSandExchangeTip")
autoImport("RewardListLargeTip")
autoImport("BindWalletTip")
autoImport("WarbandMemberTip")
autoImport("SealAreaTip")
autoImport("QuestRepairTip")
autoImport("EvidenceDetailTip")
autoImport("TeamMemberTip")
autoImport("TopicTip")
autoImport("GuildDateBattleDateTip")
autoImport("MixShopTip")
autoImport("LotterySafetyTip")
autoImport("DayLoginRewardTip")
autoImport("ShopChangeCostTip")
autoImport("GemProfessionTip")
autoImport("PlayerGuidTip")
autoImport("FlexibleNormalTip")
autoImport("SinglePropTypeTip")
autoImport("NewPropTypeTip")
autoImport("AdventureAppendTip")
autoImport("BalanceModeSkillTip")
autoImport("AstralDestinyGraphPointTip")
autoImport("RoguelikeSkillRemoveTip")
TipManager.Instance = nil

function TipManager:ctor()
  self:Init()
  TipManager.Instance = self
end

function TipManager:Init()
  self.bubbleTips = {}
end

function TipManager:ShowItemFloatTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(ItemFloatTip, data, side, stick, offset, "ItemFloatTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowItemFloatTipWAbsPos(data, absPos)
  TipsView.Me():ShowStickTipWAbsPos(ItemFloatTip, data, "ItemFloatTip", absPos)
  return TipsView.Me().currentTip
end

function TipManager:ShowGemItemTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.Right
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(GemItemFloatTip, data, side, stick, offset, "ItemFloatTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowSkipAnimationTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  local _TipsView = TipsView.Me()
  _TipsView:ShowStickTip(SkipAnimationTip, data, side, stick, offset, "SkipAnimationTip")
  return _TipsView.currentTip
end

function TipManager:ShowTutorFindTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  local _TipsView = TipsView.Me()
  _TipsView:ShowStickTip(TutorFindTip, data, side, stick, offset, "TutorFindTip")
  return _TipsView.currentTip
end

function TipManager:ShowFormulaTip(itemData, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  if self.formularTip ~= nil then
    self.formularTip:CloseSelf()
  end
  local path = ResourcePathHelper.UICell("ItemFormulaTip")
  local obj = Game.AssetManager_UI:CreateAsset(path, TipsView.Me().gameObject)
  self.formularTip = ItemFormulaTip.new(obj)
  self.formularTip:SetData(itemData)
  local pos = NGUIUtil.GetAnchorPoint(nil, stick, side, offset)
  self.formularTip:SetPos(pos)
  return self.formularTip
end

function TipManager:ShowRecommendTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(RecommendPetTip, data, side, stick, offset, "RecommendPetTip")
  local recommendPetTip = TipsView.Me().currentTip
  return recommendPetTip
end

function TipManager:ShowTitlePropTip(propdata, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(TitlePropTip, propdata, side, stick, offset, "TitlePropTip")
end

function TipManager:ShowTitleTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(TitleTip, data, side, stick, offset, "TitleTip")
  local titleTip = TipsView.Me().currentTip
  return titleTip
end

function TipManager:ShowGuildBuildingTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(GuildBuildingTip, data, side, stick, offset, "GuildBuildingTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:HideExchangeGoodsTip()
  local currentTipType = TipsView.Me().currentTipType
  if currentTipType == ExchangeGoodsTip then
    TipsView.Me():HideCurrent()
  end
end

function TipManager:ShowExchangeGoodsTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(ExchangeGoodsTip, data, side, stick, offset, "ExchangeGoodsTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowWarbandMemberTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(WarbandMemberTip, data, side, stick, offset, "WarbandMemberTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowTeamMemberTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(TeamMemberTip, data, side, stick, offset, "TeamMemberTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowFeedPetTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(FeedPetTip, data, side, stick, offset, "FeedPetTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowPetSpeicMonsterTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(PetAdventureSpeicidTip, data, side, stick, offset, "PetAdventureSpeicidTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:HidePetSpecTip()
  local currentTipType = TipsView.Me().currentTipType
  if currentTipType == PetAdventureSpeicidTip then
    TipsView.Me():HideCurrent()
  end
end

function TipManager:ShowPetAdventureEffDetail(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(PetAdventureEffTip, data, side, stick, offset, "PetAdventureEffTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:HidePetEffTip()
  local currentTipType = TipsView.Me().currentTipType
  if currentTipType == PetAdventureEffTip then
    TipsView.Me():HideCurrent()
  end
end

function TipManager:HideTitleTip()
  local currentTipType = TipsView.Me().currentTipType
  if currentTipType == TitleTip then
    TipsView.Me():HideCurrent()
  end
end

function TipManager:ShowAstrobeTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(AstrolabeTipView, data, side, stick, offset, "AstrolabeTipView")
  return TipsView.Me().currentTip
end

function TipManager:ShowCompItemTip(data, compdatas, funcConfig, stick, side, offset, callback)
  local sdata = {
    itemdata = data,
    funcConfig = funcConfig,
    compdata1 = compdatas[1],
    compdata2 = compdatas[2],
    callback = callback
  }
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(ItemFloatTip, sdata, side, stick, offset, "ItemFloatTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowCatTipById(id, stick, side, offset)
  local sData = Table_MercenaryCat[id]
  local tempData = {staticData = sData}
  return self:ShowCatTip(tempData, stick, side, offset)
end

function TipManager:ShowCatTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(HireCatTip, data, side, stick, offset, "HireCatTip")
  local hireCatTip = TipsView.Me().currentTip
  hireCatTip:AddAutoCloseEvent()
  if not Slua.IsNull(stick) then
    hireCatTip:AddIgnoreBounds(stick)
  end
  return hireCatTip
end

function TipManager:HideCatTip()
  local currentTipType = TipsView.Me().currentTipType
  if currentTipType == HireCatTip then
    TipsView.Me():HideCurrent()
  end
end

function TipManager:DestroyChildren(obj)
  local objNil = Game.GameObjectUtil:ObjectIsNULL(obj)
  if not objNil then
    local childCount = obj.transform.childCount
    if 0 < childCount then
      for i = 0, childCount - 1 do
        GameObject.DestroyImmediate(obj.transform:GetChild(i).gameObject)
      end
    end
  end
  return not objNil
end

function TipManager:ShowPicMakeTip(data)
  TipsView.Me():ShowStickTip(data)
end

function TipManager:ShowBubbleTipById(id, stick, side, offset, closecallback, activeCloseButton)
  local cathchTip = self.bubbleTips[id]
  if cathchTip then
    self:CloseBubbleTip(id)
  end
  local bubbleData = Table_BubbleID[id]
  if bubbleData and bubbleData.Offset then
    offset = offset or {}
    offset[1] = offset[1] or 0
    offset[2] = offset[2] or 0
    offset[1] = offset[1] + (bubbleData.Offset[1] or 0)
    offset[2] = offset[2] + (bubbleData.Offset[2] or 0)
  end
  self.bubbleTips[id] = BubbleTip.new("BubbleTip", stick, side, offset)
  local data = {bubbleid = id, closecallback = closecallback}
  self.bubbleTips[id]:SetData(data)
  self.bubbleTips[id]:OnEnter()
  if activeCloseButton == false then
    self.bubbleTips[id]:ActiveCloseButton(activeCloseButton)
  end
  return self.bubbleTips[id]
end

function TipManager:ShowBindWalletTip(data, stick, side, offset)
  TipsView.Me():HideCurrent()
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(BindWalletTip, data, side, stick, offset, "BindWalletTip")
  return TipsView.Me().currentTip
end

function TipManager:CloseBubbleTip(bubbleid)
  if bubbleid then
    if self.bubbleTips[bubbleid] then
      self.bubbleTips[bubbleid]:OnExit()
      self.bubbleTips[bubbleid] = nil
    end
  else
    for _, tip in pairs(self.bubbleTips) do
      tip:OnExit()
    end
    self.bubbleTips = {}
  end
end

function TipManager:SetBubbleTipActive(bubbleId, state)
  local bubbleTip = self.bubbleTips[bubbleId]
  if bubbleTip then
    bubbleTip:SetActive(state)
  end
end

function TipManager:CloseItemTip()
  self:CloseTipByClassType(ItemFloatTip)
  self:CloseTipByClassType(GemItemFloatTip)
end

function TipManager:ShowNormalTip(text, stick, side, offset, closecallback, ignoreBounds)
  self:CloseNormalTip()
  self.normalTip = NormalTip.new("NormalTip", stick, side, offset)
  self.normalTip:SetData(text)
  self.normalTip:OnEnter()
  if ignoreBounds then
    for _, obj in pairs(ignoreBounds) do
      self.normalTip:AddIgnoreBounds(obj)
    end
  end
  return self.normalTip
end

function TipManager:CloseNormalTip()
  if self.normalTip then
    self.normalTip:OnExit()
    self.normalTip:DestroySelf()
    self.normalTip = nil
  end
end

function TipManager:ShowEatFoodInfoTip(text, textTime, stick, side, offset, closecallback, ignoreBounds)
  self:CloseEatFoodInfoTip()
  self.eatFoodInfoTip = EatFoodInfoTip.new("EatFoodInfoTip", stick, side, offset)
  self.eatFoodInfoTip:SetData(text, textTime)
  self.eatFoodInfoTip:OnEnter()
  if ignoreBounds then
    for _, obj in pairs(ignoreBounds) do
      self.eatFoodInfoTip:AddIgnoreBounds(obj)
    end
  end
  return self.eatFoodInfoTip
end

function TipManager:CloseEatFoodInfoTip()
  if self.eatFoodInfoTip then
    self.eatFoodInfoTip:OnExit()
    self.eatFoodInfoTip:DestroySelf()
    self.eatFoodInfoTip = nil
  end
end

function TipManager:ShowRewardListTip(data, stick, side, offset)
  self:CloseTip()
  TipsView.Me():ShowStickTip(RewardListTip, data, side, stick, offset, "RewardListTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowRewardListLargeTip(data, stick, side, offset)
  self:CloseTip()
  TipsView.Me():ShowStickTip(RewardListLargeTip, data, side, stick, offset, "RewardListLargeTip")
  return TipsView.Me().currentTip
end

function TipManager:CloseTip()
  TipsView.Me():HideCurrent()
end

function TipManager:CloseTipByClassType(cls)
  if TipsView.Me().currentTipType == cls then
    TipsView.Me():HideCurrent()
  end
end

function TipManager:ShowFoodRecipeTip(recipeData, stick, side, offset)
  self:CloseTip()
  TipsView.Me():ShowStickTip(FoodRecipeTip, recipeData, side, stick, offset, "FoodRecipeTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowToggleEditConfirmTip(text, value, closecall, stick, side, offset)
  self:CloseTip()
  local data = {
    text = text,
    value = value,
    closecall = closecall
  }
  TipsView.Me():ShowStickTip(ToggleEditConfirmTip, data, side, stick, offset, "ToggleEditConfirmTip")
end

function TipManager:ShowEquipChooseTip(datas, stick, offset, closecall, closeCallParam)
  self:CloseTip()
  TipsView.Me():ShowStickTip(EquipChooseTip, datas, side, stick, offset, "EquipChooseTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowPetFashionChooseTip(datas, stick, side, offset, closecall, closeCallParam)
  self:CloseTip()
  TipsView.Me():ShowStickTip(PetFashionChooseTip, datas, side, stick, offset, "PetFashionChooseTip")
  local tip = TipsView.Me().currentTip
  tip:SetCloseCall(closecall, closeCallParam)
  return tip
end

function TipManager:ShowSkillStickTip(data, stick, side, offset, viewType)
  viewType = viewType or SkillTip
  TipsView.Me():ShowStickTip(viewType, {data = data}, side, stick, offset, "SkillTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowPetSkillTip(data, stick, side, offset)
  return self:ShowSkillStickTip(data, stick, side, offset, PetSkillTip)
end

function TipManager:ShowBalanceModeSkillTip(data, stick, side, offset)
  return self:ShowSkillStickTip(data, stick, side, offset, BalanceModeSkillTip)
end

function TipManager:ShowTaskQuestTip(stick, side, offset)
  TipsView.Me():ShowStickTip(TaskQuestTip, nil, side, stick, offset)
end

function TipManager:ShowGvgQuestScoreTip(stick, side, offset)
  TipsView.Me():ShowStickTip(GvgQuestScoreTip, nil, side, stick, offset)
end

function TipManager:ShowGvgFinalFightTip(stick, side, offset)
  TipsView.Me():ShowStickTip(GvgFinalFightTip, nil, side, stick, offset)
end

function TipManager:ShowPreQuestTip(preDatas, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(PreQuestTip, preDatas, side, stick, offset, "PreQuestTip")
  local titleTip = TipsView.Me().currentTip
  return titleTip
end

function TipManager:ShowPropTypeTip(preDatas, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(PropTypeTip, preDatas, side, stick, offset, "PropTypeTip")
  local titleTip = TipsView.Me().currentTip
  return titleTip
end

function TipManager:ShowGuildDateBattleTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(GuildDateBattleDateTip, data, side, stick, offset, "GuildDateBattleDateTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowGuildDateBattleClockTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(GuildDateBattleDateTip, data, side, stick, offset, "GuildDateBattleClockTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowGuildDateBattleModeTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(GuildDateBattleDateTip, data, side, stick, offset, "GuildDateBattleModeTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowSinglePropTypeTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(SinglePropTypeTip, data, side, stick, offset, "SinglePropTypeTip")
  local titleTip = TipsView.Me().currentTip
  return titleTip
end

function TipManager:ShowNewPropTypeTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(NewPropTypeTip, data, side, stick, offset, "NewPropTypeTip")
  local titleTip = TipsView.Me().currentTip
  return titleTip
end

function TipManager:ShowPetAdventureHeadTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(PetAdventureHeadTip, data, side, stick, offset, "PetAdventureHeadTip")
  local tip = TipsView.Me().currentTip
  return tip
end

function TipManager:ShowHRefineAddEffectTip(stick, side, offset)
  TipsView.Me():ShowStickTip(HRefineAddEffectTip, nil, side, stick, offset, "HRefineAddEffectTip")
end

function TipManager:ShowTabNameTip(data, stick, side, offset)
  self:CloseTabNameTip()
  TipsView.Me():ShowStickTip(TabNameTip, data, side, stick, offset, "TabNameTip")
  return TipsView.Me().currentTip
end

local horizontalTipOffset = {-30, 0}

function TipManager:TryShowHorizontalTabNameTip(tabName, stick, side, offset)
  local fadeInDirection, fadeOutDirection
  if side == NGUIUtil.AnchorSide.Left then
    fadeInDirection = TNTFadeDirEnum.LEFT
    fadeOutDirection = TNTFadeDirEnum.RIGHT
  elseif side == NGUIUtil.AnchorSide.Right then
    fadeInDirection = TNTFadeDirEnum.RIGHT
    fadeOutDirection = TNTFadeDirEnum.LEFT
  else
    return nil
  end
  offset = offset or horizontalTipOffset
  if not GameConfig.SystemForbid.TabNameTipHorizontal then
    return self:ShowTabNameTip({
      tabName = tabName,
      fadeInDirection = fadeInDirection,
      fadeOutDirection = fadeOutDirection
    }, stick, side, offset)
  end
  return nil
end

local verticalTipOffset = {122, -58}

function TipManager:TryShowVerticalTabNameTip(tabName, stick, side, offset)
  local fadeInDirection, fadeOutDirection
  if side == NGUIUtil.AnchorSide.Bottom then
    fadeInDirection = TNTFadeDirEnum.DOWN
    fadeOutDirection = TNTFadeDirEnum.UP
  elseif side == NGUIUtil.AnchorSide.Top then
    fadeInDirection = TNTFadeDirEnum.UP
    fadeOutDirection = TNTFadeDirEnum.DOWN
  else
    return nil
  end
  offset = offset or verticalTipOffset
  self:CloseTabNameTip()
  if not GameConfig.SystemForbid.TabNameTipVertical then
    TipsView.Me():ShowStickTip(TabNameTip, {
      tabName = tabName,
      fadeInDirection = fadeInDirection,
      fadeOutDirection = fadeOutDirection
    }, side, stick, offset, "TabNameTipVertical")
  end
  return TipsView.Me().currentTip
end

local comodoBuildingSendNameTipOffset = {0, -25}

function TipManager:TryShowVerticalComodoBuildingSendNameTip(id, stick, fadeInDistance)
  local data = Table_Npc[id] or Table_Monster[id]
  if not data then
    return
  end
  self:CloseTabNameTip()
  TipsView.Me():ShowStickTip(TabNameTip, {
    tabName = data.NameZh,
    fadeInDirection = TNTFadeDirEnum.DOWN,
    fadeOutDirection = TNTFadeDirEnum.UP,
    fadeInDistance = fadeInDistance or 20
  }, NGUIUtil.AnchorSide.Bottom, stick, comodoBuildingSendNameTipOffset, "ComodoBuildingSendNameTip")
  return TipsView.Me().currentTip
end

function TipManager:TryShowAllDirComodoBuildingSendNameTip(tabName, stick, side, offset, prefabName)
  prefabName = prefabName or "TabNameTipVertical"
  local fadeInDirection, fadeOutDirection
  if side == NGUIUtil.AnchorSide.Bottom then
    fadeInDirection = TNTFadeDirEnum.DOWN
    fadeOutDirection = TNTFadeDirEnum.UP
    offset = offset or horizontalTipOffset
  elseif side == NGUIUtil.AnchorSide.Top then
    fadeInDirection = TNTFadeDirEnum.UP
    fadeOutDirection = TNTFadeDirEnum.DOWN
    offset = offset or horizontalTipOffset
  elseif side == NGUIUtil.AnchorSide.Left then
    fadeInDirection = TNTFadeDirEnum.LEFT
    fadeOutDirection = TNTFadeDirEnum.RIGHT
    offset = offset or verticalTipOffset
  elseif side == NGUIUtil.AnchorSide.Right then
    fadeInDirection = TNTFadeDirEnum.RIGHT
    fadeOutDirection = TNTFadeDirEnum.LEFT
    offset = offset or verticalTipOffset
  else
    return nil
  end
  self:CloseTabNameTip()
  TipsView.Me():ShowStickTip(TabNameTip, {
    tabName = tabName,
    fadeInDirection = fadeInDirection,
    fadeOutDirection = fadeOutDirection
  }, side, stick, offset, prefabName)
  return TipsView.Me().currentTip
end

function TipManager:CloseTabNameTip()
  self:CloseTipByClassType(TabNameTip)
end

function TipManager:CloseTabNameTipWithFadeOut()
  if TipsView.Me().currentTipType == TabNameTip then
    TipsView.Me().currentTip:TryFadeOut()
  end
end

function TipManager:ShowPropHelpTip(stick, side, offset)
  TipsView.Me():ShowStickTip(PropTipHelp, nil, side, stick, offset)
end

function TipManager:ShowAstrolabeContraceTip(data, stick, side, offset)
  if AstrolabeView_ContrastTip == nil then
    autoImport("AstrolabeView_ContrastTip")
  end
  TipsView.Me():ShowStickTip(AstrolabeView_ContrastTip, data, side, stick, offset, "AstrolabeView_ContrastTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowServerPopupList(stick, side, offset)
  TipsView.Me():ShowStickTip(ServerPopupListTip, nil, side, stick, offset)
end

function TipManager:ShowSandExchangeTip(stick, side, offset)
  side = side or NGUIUtil.AnchorSide.Right
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(TechTreeSandExchangeTip, nil, side, stick, offset, "TechTreeSandExchangeTip")
  return TipsView.Me().currentTip
end

function TipManager:ShowSealAreaTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(SealAreaTip, data, side, stick, offset)
end

function TipManager:ShowTopicTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(TopicTip, data, side, stick, offset)
end

function TipManager:ShowMixShopTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(MixShopTip, data, side, stick, offset)
end

function TipManager:ShowQuestRepairTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(QuestRepairTip, data, side, stick, offset)
end

function TipManager:ShowEvidenceDetailTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(EvidenceDetailTip, data, side, stick, offset)
end

function TipManager:SetLotterySafetyTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.Right
  TipsView.Me():ShowStickTip(LotterySafetyTip, data, side, stick, offset)
end

function TipManager:SetDayLoginRewardTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(DayLoginRewardTip, data, side, stick, offset)
end

function TipManager:SetShopChangeCostTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(ShopChangeCostTip, data, side, stick, offset)
  return TipsView.Me().currentTip
end

function TipManager:SetGemProfessionTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(GemProfessionTip, data, side, stick, offset)
end

function TipManager:SetPlayerGuidTip(data, stick, side, offset, prefabName)
  TipsView.Me():ShowStickTip(PlayerGuidTip, data, side, stick, offset, prefabName)
end

function TipManager:ShowFlexibleNormalTip(data, stick, side, offset, contentPivot)
  TipsView.Me():ShowStickTip(FlexibleNormalTip, data, side, stick, offset)
  local tip = TipsView.Me().currentTip
  if contentPivot and tip then
    tip:SetContentPivot(contentPivot)
  end
  return TipsView.Me().currentTip
end

function TipManager:ShowAddventureAppendTip(data, stick, side, offset)
  TipsView.Me():ShowStickTip(AdventureAppendTip, data, side, stick, offset)
  return TipsView.Me().currentTip
end

function TipManager:ShowAstralDestinyGraphPointTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(AstralDestinyGraphPointTip, data, side, stick, offset, "AstralDestinyGraphPointTip")
  return TipsView.Me().currentTip
end

function TipManager:CloseAstralDestinyGraphPointTip()
  TipsView.Me():HideCurrent()
end

function TipManager:ShowRoguelikeSkillRemoveTip(data, stick, side, offset)
  side = side or NGUIUtil.AnchorSide.TopRight
  offset = offset or {0, 0}
  TipsView.Me():ShowStickTip(RoguelikeSkillRemoveTip, data, side, stick, offset, "RoguelikeSkillRemoveTip")
  return TipsView.Me().currentTip
end
