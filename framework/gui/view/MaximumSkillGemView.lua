local ComparerFunc = function(l, r)
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
local ClickDisablePredicate = function(cell, self)
  if cell:CheckDataIsNilOrEmpty() then
    return true
  end
  if GemProxy.Instance:IsEmbedded(cell.data.id) then
    return true
  end
  if cell.data.gemSkillData:IsFull() then
    return true
  end
end
local check_bag = GameConfig.PackageMaterialCheck.gem_bag
local skipAnimTipOffset = {90, -75}
local EffectName = EffectMap.UI.GemViewSynthetic
local costID, costNum, costIcon
local costFormat = "%d/%d"
local costColor = {white = "555B6E", red = "de2b2b"}
local maximumSkillQualityTogs = GemProxy.MaximumSkillQualityTogs
autoImport("GemCell")
autoImport("MaximumSkillGemAttr")
MaximumSkillGemView = class("MaximumSkillGemView", ContainerView)
MaximumSkillGemView.ViewType = UIViewType.NormalLayer

function MaximumSkillGemView:Init()
  self:InitData()
  self:FindObj()
  self:AddUIEvent()
  self:AddEvent()
end

function MaximumSkillGemView:InitData()
  local cost = GemProxy.GetMaximumSkillCost()
  costID, costNum, costIcon = cost[1], cost[2], Table_Item[cost[1]].Icon
  GemProxy.Instance:InitSkillProfessionFilter()
  self.curSkillProfessionFilterPopData = {}
  self.costItemData = ItemData.new("costid", costID)
  self:_InitProfessionFilter()
  self:_InitQualityFilter()
end

function MaximumSkillGemView:_InitProfessionFilter()
  self.professionTipStick = self:FindComponent("FunctionProfessionTipStick", UIWidget)
  self.curProfessionFilterLab = self:FindComponent("FunctionCurProfessionFilterLab", UILabel)
  self:AddClickEvent(self.curProfessionFilterLab.gameObject, function()
    TipManager.Instance:SetGemProfessionTip(NewGemSkillProfessionData, self.professionTipStick)
  end)
end

function MaximumSkillGemView:_InitQualityFilter()
  self.curSkillClassFilterPopData = maximumSkillQualityTogs.AllTab.key
  local qualityTabRoot = self:FindGO("FunctionSkillQualityTabRoot")
  self:Show(qualityTabRoot)
  for togName, tableData in pairs(maximumSkillQualityTogs) do
    self[togName] = self:FindGO(togName, qualityTabRoot)
    self[togName .. "lab1"] = self:FindComponent("Label1", UILabel, self[togName])
    self[togName .. "lab1"].text = tableData.value
    self[togName .. "lab2"] = self:FindComponent("Label2", UILabel, self[togName])
    self[togName .. "lab2"].text = tableData.value
    self:AddClickEvent(self[togName], function()
      local key = maximumSkillQualityTogs[togName].key
      if self.curSkillClassFilterPopData == key then
        return
      end
      self.curSkillClassFilterPopData = key
      self:UpdateGemList()
    end)
  end
end

function MaximumSkillGemView:FindObj()
  local titleLab = self:FindComponent("TitleLabel", UILabel)
  titleLab.text = ZhString.MaximumSkillGemView_Title
  local leftRoot = self:FindGO("LeftRoot")
  local pressTip = self:FindComponent("PressTip", UILabel, leftRoot)
  pressTip.text = ZhString.Gem_SecretLand_OptionalView_LongPressTip
  self.normalStick = self:FindComponent("NormalStick", UIWidget, leftRoot)
  self.container = self:FindGO("GemContainer", leftRoot)
  self.gemCtrl = WrapListCtrl.new(self.container, GemCell, "GemCell", nil, 5, 100, true)
  self.gemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.gemCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressCell, self)
  self.gemCtrl:AddEventListener(ItemEvent.GemDelete, self.OnClickCell, self)
  self.gemCells = self.gemCtrl:GetCells()
  self.rightRoot = self:FindGO("RightRoot")
  self.effectContainer = self:FindGO("EffectContainer", self.rightRoot)
  self:InitUIEffect()
  self:InitTargetGemCell()
  self.infoRoot = self:FindGO("InfoRoot", self.rightRoot)
  self.skipBtnSp = self:FindComponent("SkipBtn", UISprite, self.rightRoot)
  local costRoot = self:FindGO("CostRoot", self.infoRoot)
  self.gemNameLab = self:FindComponent("GemNameLab", UILabel, self.infoRoot)
  local fixed_desc_Lab = self:FindComponent("FixedDescLab", UILabel, self.infoRoot)
  fixed_desc_Lab.text = ZhString.MaximumSkillGemView_AttrDesc
  self.btnGo = self:FindGO("BtnGo", self.infoRoot)
  local btn_text = self:FindComponent("Label", UILabel, self.btnGo)
  btn_text.text = ZhString.MaximumSkillGemView_Btn
  self.costLab = self:FindComponent("CostLab", UILabel, costRoot)
  local fixed_cost_Lab = self:FindComponent("FixedCostLab", UILabel, costRoot)
  fixed_cost_Lab.text = ZhString.MaximumSkillGemView_Cost
  self.costIcon = self:FindComponent("CostIcon", UISprite, costRoot)
  IconManager:SetItemIcon(costIcon, self.costIcon)
  local attrTable = self:FindComponent("Table", UITable, self.infoRoot)
  self.attriCtl = UIGridListCtrl.new(attrTable, MaximumSkillGemAttr, "MaximumSkillGemAttr")
  self.emptyLab = self:FindComponent("EmptyLab", UILabel, self.rightRoot)
  self.emptyLab.text = ZhString.MaximumSkillGemView_Empty
  local lab = self:FindComponent("Label", UILabel, self.emptyLab.gameObject)
  lab.text = ZhString.MaximumSkillGemView_Empty_Choose
end

function MaximumSkillGemView:InitTargetGemCell()
  self.targetCellRoot = self:FindGO("TargetCell", self.rightRoot)
  local cell = self:FindGO("GemCell", self.targetCellRoot)
  if not cell then
    self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("GemCell"), self.targetCellRoot)
  end
  self.targetCell = GemCell.new(self.targetCellRoot)
  self.targetCell:SetData()
  self.targetCell:SetShowBagSlot(true)
  self.targetCell:SetShowNewTag(false)
  self.targetCell:SetShowEmbeddedTip(true)
end

function MaximumSkillGemView:UpdateGemList(noResetPos)
  for _, cell in pairs(self.gemCells) do
    cell:SetClickDisablePredicate(ClickDisablePredicate, self)
  end
  local gems = GemProxy.GetSkillItemDataByFilterDatasOfView(self)
  table.sort(gems, ComparerFunc)
  self.gemCtrl:ResetDatas(gems, not noResetPos)
  self:UpdateBySelectGem()
end

function MaximumSkillGemView:OnGemUpdate()
  if not self.selectGemData then
    return
  end
  local data = BagProxy.Instance.skillGemBagData:GetItemByGuid(self.selectGemData.id)
  if data then
    self.selectGemCell:SetData(data)
    self.selectGemData = data
    if self.success then
      self:HandleSuccess()
    end
  end
end

function MaximumSkillGemView:UpdateAttr()
  if not self.selectGemData then
    return
  end
  local descArray = self.selectGemData.gemSkillData:GetEffectDescArray(true, true)
  self.attriCtl:ResetDatas(descArray)
  self.attriCtl:ResetPosition()
end

function MaximumSkillGemView:OnClickCell(cellCtl)
  if self.isWorking then
    return
  end
  if self.success then
    return
  end
  if cellCtl:CheckDataIsNilOrEmpty() then
    return
  end
  TipManager.CloseTip()
  local data = cellCtl and cellCtl.data
  if self.selectGemData and self.selectGemData.id == data.id then
    self:ClearSelectGem()
  else
    self:ClearChoose()
    self.selectGemCell = cellCtl
    self.selectGemCell:SetChoose(data.id)
    self.selectGemCell:ForceShowDeleteIcon()
    self.selectGemData = data
    self:UpdateBySelectGem()
  end
end

function MaximumSkillGemView:ClearChoose()
  if self.selectGemCell then
    self.selectGemCell:SetChoose(nil)
    self.selectGemCell:ForceHideDeleteIcon()
  end
end

function MaximumSkillGemView:ClearSelectGem()
  self:ClearChoose()
  self.selectGemCell = nil
  self.selectGemData = nil
  self:UpdateBySelectGem()
end

function MaximumSkillGemView:OnLongPressCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data)
  end
end

function MaximumSkillGemView:ShowGemTip(cellGO, data)
  local tip = GemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.container)
end

function MaximumSkillGemView:UpdateBySelectGem()
  local isEmpty = self.selectGemData == nil
  self.emptyLab.gameObject:SetActive(isEmpty)
  self.infoRoot:SetActive(not isEmpty)
  self.targetCellRoot.gameObject:SetActive(not isEmpty)
  if not isEmpty then
    self.targetCell:SetData(self.selectGemData)
    self.targetCell:ForceShowDeleteIcon()
    self:AddClickEvent(self.targetCell.deleteGO, function()
      self:OnClickCell(self.targetCell)
    end)
    self.gemNameLab.text = self.selectGemData.staticData.NameZh
    self:UpdateCost()
    self:UpdateAttr()
  end
end

function MaximumSkillGemView:UpdateCost()
  local own = BagProxy.Instance:GetItemNumByStaticID(costID, check_bag)
  local c = own >= costNum and costColor.white or costColor.red
  local _, color = ColorUtil.TryParseHexString(c)
  self.costLab.text = string.format(costFormat, costNum, own)
  self.costLab.color = color
end

function MaximumSkillGemView:AddUIEvent()
  self:AddClickEvent(self.btnGo, function(go)
    self:OnClickBtn()
  end)
  self:AddClickEvent(self.costIcon.gameObject, function(go)
    self:ClickCostIcon()
  end)
  self:AddClickEvent(self.skipBtnSp.gameObject, function()
    TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.MaximumSkillGem, self.skipBtnSp, NGUIUtil.AnchorSide.Right, skipAnimTipOffset)
  end)
end

function MaximumSkillGemView:OnClickBtn()
  if self.isWorking then
    return
  end
  if not self.selectGemData then
    return
  end
  if BagProxy.Instance:GetItemNumByStaticID(costID, check_bag) < costNum then
    MsgManager.ShowMsgByID(25444, Table_Item[costID].NameZh)
    return
  end
  MsgManager.ConfirmMsgByID(36019, function()
    FunctionSecurity.Me():NormalOperation(function(self)
      self:TryPlayEffectThenCall(function(self)
        ServiceItemProxy.Instance:CallFullGemSkill(self.selectGemData.id)
      end)
    end, self)
  end)
end

function MaximumSkillGemView:InitUIEffect()
  self:PlayUIEffect(EffectName, self.effectContainer, false, function(obj, args, assetEffect)
    self.backEffect = assetEffect
    self.backEffect:ResetAction("ronghe_1", 0, true)
  end)
end

function MaximumSkillGemView:TryPlayEffectThenCall(func)
  self.isWorking = true
  local delayedTime = 1000
  if LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.MaximumSkillGem) then
    func(self)
  else
    self:PlayUISound(AudioMap.UI.Gem)
    if self.foreEffect then
      self.foreEffect:Stop()
    end
    local actionName = "ronghe_2"
    self:PlayUIEffect(EffectName, self.effectContainer, true, function(obj, args, assetEffect)
      self.foreEffect = assetEffect
      self.foreEffect:ResetAction(actionName, 0, true)
    end)
    if self.backEffect then
      self.backEffect:ResetAction(actionName, 0, true)
    end
    delayedTime = 4000
    TimeTickManager.Me():CreateOnceDelayTick(delayedTime, func, self, 1)
  end
  TimeTickManager.Me():CreateOnceDelayTick(delayedTime + 800, self.RestoreAfterAction, self, 2)
end

function MaximumSkillGemView:RestoreAfterAction()
  self.isWorking = nil
end

function MaximumSkillGemView:ClickCostIcon()
  local callback = function()
    self:CancelChooseReward()
  end
  local sdata = {
    itemdata = self.costItemData,
    funcConfig = {},
    callback = callback,
    ignoreBounds = {}
  }
  TipManager.Instance:ShowItemFloatTip(sdata, self.costIcon, NGUIUtil.AnchorSide.Left, {-250, 0})
end

function MaximumSkillGemView:CancelChooseReward()
  self:ShowItemTip()
end

function MaximumSkillGemView:OnProfessionChanged()
  self.curSkillProfessionFilterPopData = GemProxy.Instance:GetCurNewProfessionFilterData()
  local curProfressionName = GemProxy.Instance:GetCurProfressionName()
  self.curProfessionFilterLab.text = curProfressionName
  self:UpdateGemList()
end

function MaximumSkillGemView:AddEvent()
  self:AddListenEvt(ItemEvent.GemUpdate, self.OnGemUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateCost)
  self:AddListenEvt(ServiceEvent.ItemFullGemSkill, self.HandleResult)
  self:AddListenEvt(GemEvent.ProfessionChanged, self.OnProfessionChanged)
end

function MaximumSkillGemView:HandleResult(note)
  local success = note.body.success
  self.success = success
end

function MaximumSkillGemView:HandleSuccess()
  TipManager.CloseTip()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemResultView,
    viewdata = {
      data = {
        self.selectGemData
      }
    }
  })
  self:ClearSelectGem()
  self.success = nil
end

function MaximumSkillGemView:OnEnter()
  MaximumSkillGemView.super.OnEnter(self)
  self.curSkillProfessionFilterPopData = GemProxy.Instance:GetCurNewProfessionFilterData()
  self:UpdateGemList()
end

function MaximumSkillGemView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  MaximumSkillGemView.super.OnExit(self)
end
