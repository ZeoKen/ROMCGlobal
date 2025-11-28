autoImport("WrapListCtrl")
autoImport("GemCell")
autoImport("GemFunctionPage")
GemSculptView = class("GemSculptView", BaseView)
GemSculptView.ViewType = UIViewType.NormalLayer
local tickManager
local costLabelColor = LuaColor.New(0.37254901960784315, 0.37254901960784315, 0.37254901960784315, 1)

function GemSculptView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:AddEvents()
  self:InitLeft()
  self:InitRight()
  self:RegistShowGeneralHelpByHelpID(GemFunctionHelpId[GemFunctionState.Sculpt], self:FindGO("HelpButton"))
end

function GemSculptView:AddEvents()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.CloseSelf)
end

local skipAnimTipOffset = {90, -75}

function GemSculptView:InitRight()
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite)
  self:AddButtonEvent("SkipBtn", function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.GemFunction, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipAnimTipOffset)
  end)
  self.effectContainer = self:FindGO("EffectContainer")
  self.mainLabel = self:FindComponent("MainLabel", UILabel)
  self.sculptCtrl = self:FindGO("SculptCtrl")
  self.gemLabel = self:FindComponent("GemLabel", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol", self.sculptCtrl)
  self.chooseSymbol:SetActive(false)
  self.needGemSps = {}
  local needGemGO
  for i = 1, 3 do
    needGemGO = self:FindGO("NeedGem" .. i)
    self.needGemSps[i] = self:FindComponent("IconSprite", UISprite, needGemGO)
    self:AddClickEvent(needGemGO, function()
      self:OnClickNeedGem(i)
    end)
  end
  local targetCellGO = self:FindGO("TargetCell")
  self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GemCell"), targetCellGO)
  self.targetCell = GemCell.new(targetCellGO)
  self.targetCell:SetData()
  self.targetCell:SetShowBagSlot(true)
  self.targetCell:SetShowNewTag(false)
  self.targetCell:SetShowEmbeddedTip(false)
  self.targetCell:AddEventListener(MouseEvent.MouseClick, self.OnClickTargetCell, self)
  self.costGO = self:FindGO("Cost")
  self.costSprite = self:FindComponent("Sprite", UISprite, self.costGO)
  self.costLabel = self:FindComponent("CostLabel", UILabel, self.costGO)
  local sculptBtn = self:FindGO("SculptBtn")
  self:AddClickEvent(sculptBtn, function()
    self:TrySculpt()
  end)
  self.sculptBtnBgSp = sculptBtn:GetComponent(UISprite)
  self.sculptBtnLabel = self:FindComponent("Label", UILabel, sculptBtn)
end

function GemSculptView:InitLeft()
  self.leftGO = self:FindGO("Left")
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self:AddButtonEvent("CloseLeftBtn", function()
    self.leftGO:SetActive(false)
  end)
  local updateList = function()
    self:UpdateList()
  end
  self:TryInitFilterPopOfView("SkillClassFilterPop", updateList, GemSkillQualityFilter, GemSkillQualityFilterData)
  self:TryInitFilterPopOfView("SkillProfessionFilterPop", updateList, GemSkillProfessionFilter, GemSkillProfessionFilterData)
  GemProxy.TryAddFavoriteFilterToFilterPop(self.SkillClassFilterPop)
  GemProxy.TryRemoveBannedProfessionsFromFilter(self.SkillProfessionFilterPop)
  self.itemContainer = self:FindGO("ItemContainer", self.leftGO)
  self.listCtrl = WrapListCtrl.new(self.itemContainer, GemCell, "GemCell", WrapListCtrl_Dir.Vertical, 5, 102, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickListCell, self)
  self.listCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressListCell, self)
  self.listCells = self.listCtrl:GetCells()
  self.leftGO:SetActive(false)
end

function GemSculptView:OnEnter()
  GemSculptView.super.OnEnter(self)
  self:SetItemToSculpt()
  if not self.backEffect then
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.effectContainer, false, function(obj, args, assetEffect)
      self.backEffect = assetEffect
      self.backEffect:ResetAction("ronghe_1", 0, true)
    end)
  end
end

function GemSculptView:OnExit()
  tickManager:ClearTick(self)
  GemSculptView.super.OnExit(self)
end

function GemSculptView:OnClickTargetCell(cellCtl)
  self.leftGO:SetActive(true)
end

function GemSculptView:OnClickListCell(cellCtl)
  if self.isSculpting then
    return
  end
  if self.isClickOnListCtrlDisabled then
    self.isClickOnListCtrlDisabled = nil
    return
  end
  if cellCtl:CheckDataIsNilOrEmpty() then
    return
  end
  local data = cellCtl and cellCtl.data
  for _, cell in pairs(self.listCells) do
    cell:SetChoose(data and data.id or 0)
  end
  self:SetItemToSculpt(data)
  cellCtl:TryClearNewTag()
  TipManager.CloseTip()
end

function GemSculptView:OnLongPressListCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data)
    self.isClickOnListCtrlDisabled = true
  end
end

function GemSculptView:OnClickNeedGem(index)
  self:UpdateSelected(index)
end

function GemSculptView:OnItemUpdate()
  self:UpdateCost()
end

function GemSculptView:OnGemUpdate()
  TipManager.CloseTip()
  self:UpdateList(true)
  if self.targetCell.data then
    local guid = self.targetCell.data.id
    local newTarget = BagProxy.Instance:GetItemByGuid(guid, SceneItem_pb.EPACKTYPE_GEM_SKILL)
    self:SetItemToSculpt(newTarget)
  end
end

function GemSculptView:SetItemToSculpt(data)
  self.mainLabel.gameObject:SetActive(data == nil)
  self.sculptCtrl:SetActive(data ~= nil)
  self:SetSculptBtnActive(data ~= nil)
  self.targetCell:SetData(data)
  if not data then
    return
  end
  self.gemLabel.text = data.staticData.NameZh
  if not GemProxy.CheckContainsGemSkillData(data) then
    LogUtility.Error("Cannot find GemSkillData while updating item to sculpt")
    return
  end
  local needGem, pos = data.gemSkillData.needAttributeGemTypes
  local tempArr = ReusableTable.CreateArray()
  TableUtility.ArrayShallowCopy(tempArr, needGem)
  local isSculpted = GemProxy.CheckSkillDataIsSculpted(data.gemSkillData)
  if isSculpted then
    local sculptData = data.gemSkillData:GetSculptData()
    if next(sculptData) then
      pos = sculptData[1].pos
      tempArr[pos] = 0
    end
  end
  for i = 1, #self.needGemSps do
    self.needGemSps[i].spriteName = GemProxy.SculptNeedGemSpriteNames[tempArr[i]]
    self.needGemSps[i]:MakePixelPerfect()
  end
  self.costConfig = GameConfig.Gem.CarveCost[1]
  self.costGO:SetActive(not isSculpted)
  self:UpdateCost()
  self.sculptBtnLabel.text = isSculpted and ZhString.Gem_ResetSculpt or ZhString.Gem_Sculpt
  ReusableTable.DestroyAndClearArray(tempArr)
end

local comparer = function(l, r)
  local comp1 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsFavorite)
  if comp1 ~= nil then
    return comp1
  end
  local comp2 = GemProxy.PredicateComparer(l, r, GemProxy.CheckIsEmbedded)
  if comp2 ~= nil then
    return comp2
  end
  return GemProxy.BasicComparer(l, r)
end

function GemSculptView:UpdateList(noResetPos)
  if not self.leftGO.activeInHierarchy then
    return
  end
  local gems = GemProxy.GetSkillItemDataByFilterDatasOfView(self)
  table.sort(gems, comparer)
  self.listCtrl:ResetDatas(gems, not noResetPos)
end

function GemSculptView:UpdateSelected(index)
  self.selectedSculpt = index
  self.chooseSymbol:SetActive(index ~= nil and 0 < index)
  if self.chooseSymbol.activeSelf then
    self.chooseSymbol.transform.position = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(self.needGemSps[index].transform))
  end
end

function GemSculptView:UpdateCost()
  if not self.costGO.activeInHierarchy then
    return
  end
  local costStaticId, costNum = self.costConfig[1], self.costConfig[2]
  IconManager:SetItemIcon(Table_Item[costStaticId].Icon, self.costSprite)
  local realNum = BagProxy.Instance:GetItemNumByStaticID(costStaticId) or 0
  self.costLabel.text = string.format(ZhString.Gem_CountLabelFormat, realNum, costNum)
  self.costLabel.color = costNum > realNum and ColorUtil.Red or costLabelColor
end

function GemSculptView:TrySculpt()
  if not self.isSculptBtnActive then
    return
  end
  local itemData = self.targetCell.data
  if not itemData then
    MsgManager.FloatMsg(nil, ZhString.Gem_SculptNoTargetCellTip)
    return
  end
  local skillData = itemData.gemSkillData
  if not skillData or not next(skillData) then
    LogUtility.Error("Cannot sculpt gem while skillData is nil")
    return
  end
  if GemProxy.CheckSkillDataIsSculpted(skillData) then
    local sculptData = skillData:GetSculptData()
    MsgManager.ConfirmMsgByID(36009, function()
      if GemProxy.CheckIsFavorite(itemData) then
        MsgManager.FloatMsg(nil, ZhString.Gem_ResetSculptIsFavoriteTip)
        return
      end
      GemProxy.CallSculpt(itemData.id, sculptData[1].type, sculptData[1].pos, true)
    end)
    return
  end
  if not self.selectedSculpt then
    MsgManager.FloatMsg(nil, ZhString.Gem_SculptNoSelectedSculptTip)
    return
  end
  local realNum = BagProxy.Instance:GetItemNumByStaticID(self.costConfig[1]) or 0
  if realNum < self.costConfig[2] then
    MsgManager.ShowMsgByID(3554, Table_Item[self.costConfig[1]].NameZh)
    return
  end
  if GemProxy.CheckIsFavorite(itemData) then
    MsgManager.FloatMsg(nil, ZhString.Gem_SculptIsFavoriteTip)
    return
  end
  local selectedType = skillData.needAttributeGemTypes[self.selectedSculpt]
  MsgManager.ConfirmMsgByID(36010, function()
    FunctionSecurity.Me():NormalOperation(function(self)
      self:TryPlayEffectThenCall(function(self)
        GemProxy.CallSculpt(itemData.id, selectedType, self.selectedSculpt)
      end)
    end, self)
  end, nil, nil, ZhString["Gem_SkillDescNeedGemType" .. selectedType])
end

function GemSculptView:TryPlayEffectThenCall(func)
  self.isSculpting = true
  self:SetSculptBtnActive(false)
  local delayedTime = 1000
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.GemFunction) then
    func(self)
  else
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    local actionName = "ronghe_2"
    self:PlayUIEffect(EffectMap.UI.GemViewSynthetic, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction(actionName, 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    tickManager:CreateOnceDelayTick(delayedTime, func, self, 1)
  end
  tickManager:CreateOnceDelayTick(delayedTime, self.RestoreAfterSculpt, self, 2)
end

function GemSculptView:RestoreAfterSculpt()
  self:SetSculptBtnActive(true)
  self.isSculpting = nil
end

function GemSculptView:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.itemContainer)
end

function GemSculptView:SetSculptBtnActive(isActive)
  isActive = isActive and true or false
  self.isSculptBtnActive = isActive
  self.sculptBtnBgSp.spriteName = isActive and "com_btn_1" or "com_btn_13"
  self.sculptBtnLabel.effectColor = isActive and ColorUtil.ButtonLabelBlue or ColorUtil.NGUIGray
end
