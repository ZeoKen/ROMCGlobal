autoImport("GemSecretLandItemCell")
local _BtnSpName = {"com_btn_2", "com_btn_13"}
local _LabColor = LuaColor.New(0.28627450980392155, 0.48627450980392156, 0.7607843137254902, 1)
local _TxtBgColor = LuaColor.New(0.28627450980392155, 0.48627450980392156, 0.7607843137254902, 1)
local isSecretLandSortOrderDescending = true
local rotate180Func = function(angle)
  if not angle.z then
    return
  end
  angle.z = (angle.z + 180) % 360
end
local _TexName = "Rune_normal-matrix_fuse"
local _BlurTexName = "Rune_normal-matrix_fuse2"
local _tempV3 = LuaVector3()
local _tempV31 = LuaVector3()
local _Ratio = GameConfig.Gem and GameConfig.Gem.SecretLandGemExpItem and GameConfig.Gem.SecretLandGemExpItem.Ratio or 1
local _ExpCostItemID = GameConfig.Gem and GameConfig.Gem.SecretLandGemExpItem and GameConfig.Gem.SecretLandGemExpItem.ItemID or 8280
SecretLandGemOptionalPage = class("SecretLandGemOptionalPage", SubView)
SecretLandGemOptionalPage.Mode = {
  UpExp = SceneItem_pb.ESECRETLANDGEMCMD_UPEXP,
  UpMaxLv = SceneItem_pb.ESECRETLANDGEMCMD_UPMAXLV
}

function SecretLandGemOptionalPage:OnEnter()
  SecretLandGemOptionalPage.super.OnEnter(self)
end

function SecretLandGemOptionalPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  PictureManager.Instance:UnLoadUI(_TexName, self.tex)
  PictureManager.Instance:UnLoadUI(_BlurTexName, self.blurTexture)
  SecretLandGemOptionalPage.super.OnExit(self)
end

function SecretLandGemOptionalPage:OnDeactivate()
  TimeTickManager.Me():ClearTick(self)
  self.resultSuccess:SetActive(false)
end

function SecretLandGemOptionalPage:Init()
  self:ReLoadPerferb("view/SecretLandGemOptionalPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:FindObjs()
  self:AddViewEvts()
  self:InitShow()
end

function SecretLandGemOptionalPage:AddViewEvts()
  self:AddDispatcherEvt(ItemEvent.ItemUpdate, self.HandItemUpdate)
  self:AddDispatcherEvt(MyselfEvent.ZenyChange, self.HandItemUpdate)
  self:AddDispatcherEvt(ServiceEvent.ItemSecretLandGemCmd, self.UpdateResult)
  self:AddDispatcherEvt(ItemEvent.GemUpdate, self.HandleUpdateGem)
end

function SecretLandGemOptionalPage:UpdateByType(color)
  self.color = color or self.color
  local data = GemProxy.Instance:GetSecretLandGem(self.color, isSecretLandSortOrderDescending)
  if data then
    self.listCtrl:ResetDatas(data, true)
    if 0 < #data then
      self:OnClickCell(self.listCells[1])
    else
      self:SetEmpty(true)
    end
  end
end

function SecretLandGemOptionalPage:InitShow()
  self.color = nil
  self:UpdateByType()
end

function SecretLandGemOptionalPage:SetEmpty(empty)
  if empty then
    self.mode = nil
    self:Show(self.emptyRoot)
    self:Hide(self.exp_Tab)
    self:Hide(self.upMax_Tab)
    self:Hide(self.exp_Root)
    self:Hide(self.upMax_Root)
    self:Hide(self.btn)
    self:Hide(self.isMaxLab)
    self:Hide(self.lvlab)
    self:Hide(self.itemContainer)
    self:Hide(self.costRoot)
    self:Hide(self.resetBtn)
  else
    self:Hide(self.emptyRoot)
    self:Show(self.exp_Tab)
    self:Show(self.upMax_Tab)
    self:Show(self.btn)
    self:Show(self.lvlab)
    self:Show(self.itemContainer)
    self:Show(self.costRoot)
    self:Show(self.resetBtn)
  end
end

function SecretLandGemOptionalPage:OnClickCell(cell)
  self:InitRight(cell.data)
  local listCells = self.listCells
  for i = 1, #listCells do
    listCells[i]:SetChoose(cell.data.id)
  end
end

function SecretLandGemOptionalPage:OnLongPressCell(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing and cellCtl then
    self:ShowGemTip(cellCtl.gameObject, cellCtl.data:GetItemData())
    self.isClickOnListCtrlDisabled = true
  end
end

function SecretLandGemOptionalPage:ShowGemTip(cellGO, data)
  local tip = GemSecretLandItemCell.ShowGemTip(cellGO, data, self.normalStick)
  if not tip then
    return
  end
  tip:AddIgnoreBounds(self.itemContainer)
end

function SecretLandGemOptionalPage:ChangeLocalEulerAnglesOfTrans(transform, func)
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalEulerAngles(transform))
  func(tempV3)
  transform.localEulerAngles = tempV3
end

function SecretLandGemOptionalPage:FindObjs()
  self.helpBtn = self:FindGO("HelpBtn", self.trans.gameObject)
  TipsView.Me():TryShowGeneralHelpByHelpId(GameConfig.Gem.SecretLandGemHelpID, self.helpBtn)
  self.leftRoot = self:FindGO("LeftRoot")
  self.pressTipLab = self:FindComponent("PressTip", UILabel, self.leftRoot)
  self.pressTipLab.text = ZhString.Gem_SecretLand_OptionalView_LongPressTip
  self:TryInitFilterPopOfView("FilterPop", function(value)
    self:UpdateByType(value)
  end, GemSecretLandFilter, GemSecretLandFilterData)
  self.secretLandSortOrderTrans = self:FindGO("SortOrder", self.rightRoot).transform
  isSecretLandSortOrderDescending = true
  self.lvSortBtn = self:FindGO("SecretLandLvSort", self.leftRoot)
  self:AddClickEvent(self.lvSortBtn, function()
    isSecretLandSortOrderDescending = not isSecretLandSortOrderDescending
    self:ChangeLocalEulerAnglesOfTrans(self.secretLandSortOrderTrans, rotate180Func)
    self:UpdateByType()
  end)
  self.selectBordContainer = self:FindGO("ItemContainer", self.leftRoot)
  self.listCtrl = WrapListCtrl.new(self.selectBordContainer, GemSecretLandItemCell, "GemSecretLandItemCell", WrapListCtrl_Dir.Vertical, 5, 100, true)
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.listCtrl:AddEventListener(MouseEvent.LongPress, self.OnLongPressCell, self)
  self.listCells = self.listCtrl:GetCells()
  self.rightRoot = self:FindGO("RightRoot")
  self.tex = self:FindComponent("Texture", UITexture, self.rightRoot)
  self.blurTexture = self:FindComponent("BlurTexture", UITexture)
  PictureManager.Instance:SetUI(_BlurTexName, self.blurTexture)
  PictureManager.Instance:SetUI(_TexName, self.tex)
  self.lvlab = self:FindComponent("Lv", UILabel, self.rightRoot)
  self.itemContainer = self:FindGO("ItemContainer", self.rightRoot)
  self.itemName = self:FindComponent("Name", UILabel, self.itemContainer)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.itemCell = ItemCell.new(obj)
  self.itemCell:HideNum()
  self.resultLab = self:FindComponent("ResultLab", UILabel, self.rightRoot)
  self.successArrow = self:FindGO("SuccessArrow", self.resultLab.gameObject)
  self:Hide(self.resultLab)
  self.isMaxLab = self:FindComponent("MaxLab", UILabel)
  self.isMaxLab.text = ZhString.Gem_SecretLand_OptionalView_IsMax
  self.exp_Tab = self:FindComponent("ExpTab", UISprite, self.rightRoot)
  self:AddClickEvent(self.exp_Tab.gameObject, function()
    self:OnClickTab(SecretLandGemOptionalPage.Mode.UpExp)
  end)
  self.exp_TabLab = self:FindComponent("Label", UILabel, self.exp_Tab.gameObject)
  self.exp_TabLab.text = ZhString.Gem_SecretLand_OptionalView_UpExp
  self.exp_Root = self:FindGO("ExpRoot", self.rightRoot)
  self.expSlider = self:FindComponent("ExpSlider", UISlider, self.exp_Root)
  self.expAddSlider = self:FindComponent("ExpAddSlider", UISlider, self.exp_Root)
  self.exp_curLv = self:FindComponent("Exp_CurLv", UILabel, self.exp_Root)
  self.exp_curExp = self:FindComponent("Exp_CurExp", UILabel, self.exp_Root)
  self.exp_addExp = self:FindComponent("Exp_AddExp", UILabel, self.exp_Root)
  self.exp_Max = self:FindComponent("Exp_Max", UILabel, self.exp_Root)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "TipLabelCell")
  self.exp_costRoot = self:FindGO("CostRoot", self.exp_Root)
  self.exp_CostIcon = self:FindComponent("Exp_CostIcon", UISprite, self.exp_costRoot)
  self:AddClickEvent(self.exp_CostIcon.gameObject, function()
    self:OnClickCostItem(_ExpCostItemID, self.exp_CostIcon)
  end)
  self.exp_CostNum = self:FindComponent("Exp_CostNum", UILabel, self.exp_costRoot)
  self.exp_CostLab = self:FindComponent("Label", UILabel, self.exp_costRoot)
  self.expPlusBtn = self:FindComponent("Exp_CostPlus", UISprite, self.exp_costRoot)
  self:AddPressEvent(self.expPlusBtn.gameObject, function(g, b)
    self:OnClickExpPlus(b)
  end)
  self.expMinusBtn = self:FindComponent("Exp_CostMinus", UISprite, self.exp_costRoot)
  self:AddPressEvent(self.expMinusBtn.gameObject, function(g, b)
    self:OnClickExpMinus(b)
  end)
  self.countInput = self:FindGO("Exp_CostNum"):GetComponent(UIInput)
  EventDelegate.Set(self.countInput.onChange, function()
    self:InputOnChange()
  end)
  EventDelegate.Set(self.countInput.onSubmit, function()
    self:InputOnSubmit()
  end)
  self.exp_CostLab.text = ZhString.Gem_SecretLand_OptionalView_Cost
  self.upMax_Tab = self:FindComponent("UpMaxTab", UISprite, self.rightRoot)
  self:AddClickEvent(self.upMax_Tab.gameObject, function()
    self:OnClickTab(SecretLandGemOptionalPage.Mode.UpMaxLv)
  end)
  self.upMax_TabLab = self:FindComponent("Label", UILabel, self.upMax_Tab.gameObject)
  self.upMax_TabLab.text = ZhString.Gem_SecretLand_OptionalView_UpMax
  self.upMax_Root = self:FindGO("UpMaxRoot", self.rightRoot)
  self.upIsMax = self:FindComponent("IsMax", UILabel, self.rightRoot)
  self.upIsMaxSp1 = self:FindComponent("Sprite (2)", UISprite, self.upIsMax.gameObject)
  self.upIsMaxSp2 = self:FindComponent("Sprite (3)", UISprite, self.upIsMax.gameObject)
  self.upIsMax.text = ZhString.Gem_SecretLand_OptionalView_UpMax_IsMax
  self.upIsMaxSp1:ResetAndUpdateAnchors()
  self.upIsMaxSp2:ResetAndUpdateAnchors()
  self.emptyRoot = self:FindGO("EmptyRoot")
  self.emptyLab = self:FindComponent("EmptyLab", UILabel, self.emptyRoot)
  self.emptyLab.text = ZhString.Gem_SecretLand_OptionalView_IsEmpty
  self.selectLab = self:FindComponent("SelectLab", UILabel, self.emptyRoot)
  self.selectLab.text = ZhString.Gem_SecretLand_OptionalView_Select
  self.upMax_curMax = self:FindComponent("UpMaxCurMax", UILabel, self.upMax_Root)
  self.upMax_targetMax = self:FindComponent("UpMaxTargetMax", UILabel, self.upMax_curMax.gameObject)
  self.upMax_Rate = self:FindComponent("Rate", UILabel, self.upMax_Root)
  if self.upMax_Rate then
    self:Hide(self.upMax_Rate)
  end
  self.btn = self:FindComponent("Btn", UISprite)
  self:AddClickEvent(self.btn.gameObject, function(go)
    self:OnClickBtn()
  end)
  self.resetBtn = self:FindGO("ResetBtn")
  self:AddClickEvent(self.resetBtn, function(go)
    self:OnClickResetBtn()
  end)
  self.btnLab = self:FindComponent("Label", UILabel, self.btn.gameObject)
  self.btnLab.text = ZhString.Gem_SecretLand_OptionalView_Btn
  self.upMax_costRoot = self:FindGO("CostRoot", self.upMax_Root)
  self.upMax_CostLab = self:FindComponent("Label", UILabel, self.upMax_costRoot)
  self.upMax_CostLab.text = ZhString.Gem_SecretLand_OptionalView_Cost
  self.upMax_CostIcon1 = self:FindComponent("UpMax_CostIcon1", UISprite, self.upMax_costRoot)
  self.upMax_CostNum1 = self:FindComponent("UpMax_CostNum1", UILabel, self.upMax_CostIcon1.gameObject)
  self.upMax_CostIcon2 = self:FindComponent("UpMax_CostIcon2", UISprite, self.upMax_costRoot)
  self.upMax_CostNum2 = self:FindComponent("UpMax_CostNum2", UILabel, self.upMax_CostIcon2.gameObject)
  self.costRoot = self:FindGO("CostRoot", self.rightRoot)
  self.costIcon = self:FindComponent("CostIcon", UISprite, self.costRoot)
  self.costNum = self:FindComponent("Num", UILabel, self.costIcon.gameObject)
  self:AddClickEvent(self.costIcon.gameObject, function()
    self:OnClickCostItem(self.curCostID, self.costIcon)
  end)
  self.costIcon2 = self:FindComponent("CostIcon2", UISprite, self.costRoot)
  self.costNum2 = self:FindComponent("Num", UILabel, self.costIcon2.gameObject)
  self:AddClickEvent(self.costIcon2.gameObject, function()
    self:OnClickCostItem(self.curCostID2, self.costIcon)
  end)
  self.resultSuccess = self:FindGO("Successful", self.rightRoot)
end

function SecretLandGemOptionalPage:OnClickCostItem(id, icon)
  local callback = function()
    self:CancelCost()
  end
  local sdata = {
    itemdata = ItemData.new("costid", id),
    funcConfig = {},
    callback = callback,
    ignoreBounds = {
      icon.gameObject
    }
  }
  TipManager.Instance:ShowItemFloatTip(sdata, icon, NGUIUtil.AnchorSide.Left, {-200, 0})
end

function SecretLandGemOptionalPage:CancelCost()
  self:ShowItemTip()
end

function SecretLandGemOptionalPage:UpdateCount(change)
  if tonumber(self.countInput.value) == nil then
    self.countInput.value = self.curExpCostNum
  end
  local count = tonumber(self.countInput.value) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.maxPlusNum then
    self.countChangeRate = 1
    return
  end
  self:UpdateTotalPrice(count)
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
end

function SecretLandGemOptionalPage:OnClickExpPlus(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 1001)
  else
    TimeTickManager.Me():ClearTick(self, 1001)
  end
end

function SecretLandGemOptionalPage:OnClickExpMinus(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 1002)
  else
    TimeTickManager.Me():ClearTick(self, 1002)
  end
end

function SecretLandGemOptionalPage:InputOnChange()
  local count = tonumber(self.countInput.value)
  if count == nil then
    return
  end
  if self.maxPlusNum == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(1)
    self:SetCountSubtract(0.5)
  elseif count >= self.maxPlusNum then
    count = self.maxPlusNum
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
  self:UpdateTotalPrice(count)
end

function SecretLandGemOptionalPage:UpdateTotalPrice(count)
  self.curExpCostNum = count
  self:UpdateExpChange()
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  self:CalcUpLv()
end

function SecretLandGemOptionalPage:CalcUpLv()
  local addValue = self.curExpCostNum * _Ratio
  local totalExp = self.data.exp + self.curExpCostNum * _Ratio
  local nextLv = self.data.nextLv
  if not nextLv then
    return
  end
  local maxlv = GemProxy.Instance.maxSecretLandLv
  local lv
  local totalNeedExp = 0
  for i = nextLv, maxlv do
    totalNeedExp = totalNeedExp + Table_SecretLandGemLvUp[i].NeedExp
    if totalExp < totalNeedExp then
      lv = i
      break
    end
  end
  if not lv then
    self.exp_curLv.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Lv_NewAdd, maxlv)
    local max_exp = Table_SecretLandGemLvUp[maxlv].NeedExp
    self.exp_curExp.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Cur_Exp, max_exp, max_exp)
    self.expSlider.value = 1
    self.data:SetChangedContextDatas(maxlv)
    self.attriCtl:ResetDatas(self.data.changedContextDatas, true)
  elseif lv == nextLv then
    self.exp_curLv.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Lv, self.data.lv)
    self.exp_curExp.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Cur_Exp, totalExp, self.data.lvUpConfig.NeedExp)
    self.expSlider.value = self.data.exp / self.data.lvUpConfig.NeedExp
    self.attriCtl:ResetDatas(self.data.contextDatas, true)
  elseif nextLv < lv then
    local total = Table_SecretLandGemLvUp[lv].NeedExp
    local exp = totalExp - (totalNeedExp - total)
    self.exp_curExp.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Cur_Exp, exp, total)
    self.expAddSlider.value = exp / total
    self.expSlider.value = 0
    self.exp_curLv.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Lv_NewAdd, lv - 1)
    self.data:SetChangedContextDatas(lv - 1)
    self.attriCtl:ResetDatas(self.data.changedContextDatas, true)
  end
end

function SecretLandGemOptionalPage:InputOnSubmit()
  local count = tonumber(self.countInput.value)
  if count == nil then
    self.countInput.value = self.curExpCostNum
  else
    self:UpdateTotalPrice(count)
  end
end

function SecretLandGemOptionalPage:SetCountPlus(alpha)
  if self.expPlusBtn.color.a ~= alpha then
    self:SetSpritAlpha(self.expPlusBtn, alpha)
  end
end

function SecretLandGemOptionalPage:SetCountSubtract(alpha)
  if self.expMinusBtn.color.a ~= alpha then
    self:SetSpritAlpha(self.expMinusBtn, alpha)
  end
end

function SecretLandGemOptionalPage:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function SecretLandGemOptionalPage:UpdateExpChange()
  if not self.curExpCostNum then
    return
  end
  self.exp_CostNum.text = self.curExpCostNum
  self.expUpAddExp = self.curExpCostNum * _Ratio
  self.exp_addExp.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Add_Exp, self.expUpAddExp)
  self:UpdateExpAddSlider()
end

local _TabConfig = {
  Yellow = {
    "B36B24",
    "recharge_btn_1"
  },
  Blue = {
    "84A4D5",
    "recharge_btn_3"
  }
}

function SecretLandGemOptionalPage:OnClickTab(mode)
  if mode == self.mode then
    return
  end
  if not self.data then
    return
  end
  if not self.data.unlock then
    return
  end
  self.mode = mode
  if mode == SecretLandGemOptionalPage.Mode.UpExp then
    self:UpdateTotalPrice(1)
    self.expMinusBtn.alpha = 0.5
    self:_SetTab(self.exp_Tab, self.exp_TabLab, _TabConfig.Yellow)
    self:_SetTab(self.upMax_Tab, self.upMax_TabLab, _TabConfig.Blue)
    self:Show(self.exp_Root)
    self:Hide(self.upMax_Root)
    self:UpdateExpRoot()
  else
    self:_SetTab(self.exp_Tab, self.exp_TabLab, _TabConfig.Blue)
    self:_SetTab(self.upMax_Tab, self.upMax_TabLab, _TabConfig.Yellow)
    self:Hide(self.exp_Root)
    self:Show(self.upMax_Root)
    self:UpdateUpMaxRoot()
  end
  self:SetBtnState()
end

function SecretLandGemOptionalPage:UpdateExpAddSlider()
  if not self.data then
    return
  end
  local config = GemProxy.Instance:GetStaticLvUp(self.data.lv + 1)
  if not config then
    return
  end
  if self.data.exp == 0 and self.expUpAddExp == 1 then
    self.expAddSlider.value = 0
  else
    self.expAddSlider.value = (self.data.exp + self.expUpAddExp) / config.NeedExp
  end
end

function SecretLandGemOptionalPage:HandItemUpdate()
  self.costNum.text = BagProxy.Instance:GetItemNumByStaticID(self.curCostID)
  self.costNum2.text = BagProxy.Instance:GetItemNumByStaticID(self.curCostID2)
  self:UpdateExpRoot()
  self:UpdateUpMaxRoot()
  self:SetBtnState()
end

function SecretLandGemOptionalPage:UpdateExpRoot()
  self:Hide(self.costIcon2)
  if self.mode ~= SecretLandGemOptionalPage.Mode.UpExp then
    return
  end
  if not self.data then
    return
  end
  self.attriCtl:ResetDatas(self.data.contextDatas, true)
  local exp_cost_icon = Table_Item[_ExpCostItemID].Icon
  IconManager:SetItemIcon(exp_cost_icon, self.exp_CostIcon)
  self.curCostID = _ExpCostItemID
  IconManager:SetItemIcon(exp_cost_icon, self.costIcon)
  self.costNum.text = BagProxy.Instance:GetItemNumByStaticID(self.curCostID)
  if self.data:IsMaxLv() and self.data:IsMax() then
    local maxlv = GemProxy.Instance.maxSecretLandLv
    self.exp_curLv.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Lv, maxlv)
    local max_exp = Table_SecretLandGemLvUp[maxlv].NeedExp
    self.exp_curExp.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Cur_Exp, max_exp, max_exp)
    self.expSlider.value = 1
    self:Hide(self.exp_addExp)
    self:Show(self.exp_Max)
    self:Hide(self.exp_costRoot)
    self:Hide(self.btn)
    return
  end
  self:Show(self.btn)
  self:Show(self.exp_addExp)
  self:Show(self.exp_costRoot)
  self:Hide(self.exp_Max)
  self.exp_curLv.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Lv, self.data.lv)
  self.exp_curExp.text = self.data.exp
  local config = GemProxy.Instance:GetStaticLvUp(self.data.lv + 1)
  if config then
    self.exp_curExp.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpExp_Cur_Exp, self.data.exp, config.NeedExp)
  end
  self.maxPlusNum = BagProxy.Instance:GetItemNumByStaticID(_ExpCostItemID)
  self.overflowNum = self.data.totalExp - self.data.exp
  self.expSlider.value = self.data.exp / config.NeedExp
  self:UpdateExpAddSlider()
end

local _textBlackColor = LuaColor.New(0.3333333333333333, 0.3568627450980392, 0.43137254901960786, 1)

function SecretLandGemOptionalPage:UpdateUpMaxRoot()
  if not self.data then
    return
  end
  if self.mode == SecretLandGemOptionalPage.Mode.UpExp then
    return
  end
  local maxLvUpConfig = self.data.maxLvUpConfig
  if maxLvUpConfig and maxLvUpConfig.BreakMaxLvCost and #maxLvUpConfig.BreakMaxLvCost > 0 then
    self:Show(self.upMax_costRoot)
    local multiCost = #maxLvUpConfig.BreakMaxLvCost > 1
    local breakMaxLvCost = maxLvUpConfig.BreakMaxLvCost
    local cost_id1 = breakMaxLvCost[1][1]
    local _icon = Table_Item[cost_id1].Icon
    IconManager:SetItemIcon(_icon, self.upMax_CostIcon1)
    local size = cost_id1 == GameConfig.MoneyId.Zeny and 40 or 45
    self.upMax_CostIcon1.width, self.upMax_CostIcon1.height = size, size
    self:AddClickEvent(self.upMax_CostIcon1.gameObject, function()
      self:OnClickCostItem(cost_id1, self.upMax_CostIcon1)
    end)
    local own = BagProxy.Instance:GetItemNumByStaticID(cost_id1)
    local needNum = breakMaxLvCost[1][2]
    self.upMax_CostNum1.text = needNum
    self.upMax_CostNum1.color = own >= needNum and _textBlackColor or ColorUtil.Red
    self.curCostID = cost_id1
    IconManager:SetItemIcon(_icon, self.costIcon)
    self.costNum.text = own
    if multiCost then
      LuaVector3.Better_Set(_tempV3, -46, -15, 0)
      LuaVector3.Better_Set(_tempV31, -70, -14, 0)
      self:Show(self.upMax_CostIcon2)
      local cost_id2 = breakMaxLvCost[2][1]
      local costIcon2 = Table_Item[cost_id2].Icon
      IconManager:SetItemIcon(costIcon2, self.upMax_CostIcon2)
      local size = cost_id2 == GameConfig.MoneyId.Zeny and 40 or 45
      self.upMax_CostIcon2.width, self.upMax_CostIcon2.height = size, size
      local needNum2 = breakMaxLvCost[2][2]
      local own2 = BagProxy.Instance:GetItemNumByStaticID(cost_id2)
      self.upMax_CostNum2.text = needNum2
      self.upMax_CostNum2.color = needNum2 < own2 and _textBlackColor or ColorUtil.Red
      self:Show(self.costIcon2)
      IconManager:SetItemIcon(costIcon2, self.costIcon2)
      self.curCostID2 = cost_id2
      self.costNum2.text = own2
      self:AddClickEvent(self.upMax_CostIcon2.gameObject, function()
        self:OnClickCostItem(cost_id2, self.upMax_CostIcon2)
      end)
    else
      self:Hide(self.costIcon2)
      LuaVector3.Better_Set(_tempV3, 60, -15, 0)
      LuaVector3.Better_Set(_tempV31, -5, -14, 0)
      self:Hide(self.upMax_CostIcon2)
    end
    self.upMax_CostIcon1.gameObject.transform.localPosition = _tempV3
    self.upMax_CostLab.gameObject.transform.localPosition = _tempV31
  else
    self:Hide(self.upMax_costRoot)
  end
  if self:UpdateMax() then
    return
  end
  local maxLv = self.data.maxLv
  self.upMax_curMax.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpMax_CurMax, maxLv)
  self.upMax_targetMax.text = string.format(ZhString.Gem_SecretLand_OptionalView_UpMax_TargetMax, maxLv + 1)
end

function SecretLandGemOptionalPage:_SetTab(sp, lab, tab_Config, root)
  sp.spriteName = tab_Config[2]
  local _, c = ColorUtil.TryParseHexString(tab_Config[1])
  lab.color = c
end

function SecretLandGemOptionalPage:UpdateMax()
  if not self.data then
    return
  end
  local isMaxLv = self.data:IsMaxLv()
  if isMaxLv then
    self:Show(self.upIsMax)
    self:Hide(self.upMax_curMax)
  else
    self:Hide(self.upIsMax)
    self:Show(self.upMax_curMax)
  end
  self.isMaxLab.gameObject:SetActive(self.data:IsMax() and isMaxLv)
  return isMaxLv
end

function SecretLandGemOptionalPage:InitRight(data)
  if not data then
    self:SetEmpty(true)
    return
  end
  local itemdata = data:GetItemData()
  self.itemName.text = data:GetName()
  if not data.unlock then
    self.itemCell:SetData(itemdata)
    self:SetEmpty(true)
    return
  end
  self.mode = nil
  self.data = data
  self:SetEmpty(false)
  self.lvlab.text = string.format(ZhString.Gem_SecretLand_OptionalView_Lv, data.lv, data.maxLv)
  self.itemCell:SetData(itemdata)
  self.itemCell:ActiveNewTag(false)
  self:UpdateMax()
  self:OnClickTab(SecretLandGemOptionalPage.Mode.UpExp)
  self:SetBtnState()
end

function SecretLandGemOptionalPage:SetBtnState()
  if not self.data then
    return
  end
  local valid = false
  if self.mode == SecretLandGemOptionalPage.Mode.UpExp then
    valid = self.data:CanUpExp()
  elseif self.mode == SecretLandGemOptionalPage.Mode.UpMaxLv then
    valid = self.data:CanUpMax()
  end
  if valid then
    self.btn.spriteName = _BtnSpName[1]
    self.btnLab.effectStyle = UILabel.Effect.Outline
  else
    self.btn.spriteName = _BtnSpName[2]
    self.btnLab.effectStyle = UILabel.Effect.None
  end
  self.valid = valid
end

function SecretLandGemOptionalPage:OnClickResetBtn()
  local data = self.data
  if not data then
    return
  end
  if data.lv <= 1 then
    MsgManager.ShowMsgByID(43583)
    return
  end
  if GemProxy.Instance:CheckSecretLandIsEmbedded(data:GetPos()) then
    MsgManager.ShowMsgByID(43580)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ResetSecretLandGemPopUp,
    viewdata = data
  })
end

function SecretLandGemOptionalPage:OnClickBtn()
  if not self.data then
    return
  end
  if not self.mode then
    return
  end
  if self.data:IsMaxLv() and self.mode == SecretLandGemOptionalPage.Mode.UpMaxLv then
    return
  end
  if StringUtil.IsEmpty(self.data.guid) then
    return
  end
  if not self.valid then
    MsgManager.ShowMsgByID(8)
    return
  end
  local jumpCall = function()
    self:OnClickTab(SecretLandGemOptionalPage.Mode.UpMaxLv)
  end
  if self.mode == SecretLandGemOptionalPage.Mode.UpExp and self.expUpAddExp > self.overflowNum then
    if self.data:IsMaxLv() then
      ServiceItemProxy.Instance:CallSecretLandGemCmd(self.mode, self.data.guid, self.overflowNum)
    else
      MsgManager.ConfirmMsgByID(43448, function()
        jumpCall()
      end)
    end
    return
  end
  ServiceItemProxy.Instance:CallSecretLandGemCmd(self.mode, self.data.guid, self.expUpAddExp)
end

local result_color = {success = "DABE69", failed = "879FC0"}

function SecretLandGemOptionalPage:UpdateResult(note)
  local data = note.body
  local is_success = data.success
  local type = data.type
  if nil == is_success then
    return
  end
  if type == SceneItem_pb.ESECRETLANDGEMCMD_RESET then
    local msg_str = is_success and ZhString.Gem_SecretLand_OptionalView_Success_Reset or ZhString.Gem_SecretLand_OptionalView_Failed_Reset
    MsgManager.FloatMsg(nil, msg_str)
    return
  end
  local color = is_success and result_color.success or result_color.failed
  local _, color = ColorUtil.TryParseHexString(color)
  if is_success then
    self.resultLab.text = ZhString.Gem_SecretLand_OptionalView_Success
    self.resultLab.color = color
    self:Show(self.successArrow)
    self:HandleUpdateGem()
    local effectName = self.mode == SecretLandGemOptionalPage.Mode.UpExp and EffectMap.UI.EquipUpgrade_Success or EffectMap.UI.ForgingSuccess_Old
    self:PlayUIEffect(effectName, self.itemContainer, true)
    self:PlayAlphaTween()
  else
    self.resultLab.text = ZhString.Gem_SecretLand_OptionalView_Failed
    self.resultLab.color = color
    self:Hide(self.successArrow)
  end
end

function SecretLandGemOptionalPage:HandleUpdateGem()
  if not self.data then
    return
  end
  local data = GemProxy.Instance:GetSecretLandGem(self.color, isSecretLandSortOrderDescending)
  if data then
    self.listCtrl:ResetDatas(data)
  end
  self.data = GemProxy.Instance:GetSecretLand(self.data.id)
  local own = BagProxy.Instance:GetItemNumByStaticID(_ExpCostItemID)
  if own < self.curExpCostNum then
    self:UpdateTotalPrice(own)
  end
  self.lvlab.text = string.format(ZhString.Gem_SecretLand_OptionalView_Lv, self.data.lv, self.data.maxLv)
  self:UpdateMax()
  self:UpdateExpRoot()
  self:UpdateUpMaxRoot()
  self:SetBtnState()
end

function SecretLandGemOptionalPage:PlayAlphaTween()
  self.alphaTween = self.resultSuccess:GetComponent(TweenAlpha)
  TimeTickManager.Me():ClearTick(self, 1003)
  self.resultSuccess:SetActive(true)
  self.alphaTween:PlayForward()
  TimeTickManager.Me():CreateOnceDelayTick(2000, function(self)
    self.alphaTween:PlayReverse()
  end, self, 1003)
end
