autoImport("EquipChooseCell")
EquipChooseBord = class("EquipChooseBord", CoreView)
EquipChooseBord.CellControl = EquipChooseCell
EquipChooseBord.PfbPath = "part/EquipChooseBord"
EquipChooseBord.CellPfbName = "EquipChooseCell"
EquipChooseBord.ChooseItem = "EquipChooseBord_ChooseItem"
EquipChooseBord.ChildNum = 1
EquipChooseBord.ChildInterver = 0
local itemTipOffset = {216, -290}

function EquipChooseBord:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb(self.PfbPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.getDataFunc = getDataFunc
  self:InitBord()
end

function EquipChooseBord:InitBord()
  self:InitDepth()
  self.title = self:FindComponent("Title", UILabel)
  self.noneTip = self:FindComponent("NoneTip", UILabel)
  self.chooseCtl = WrapListCtrl.new(self:FindGO("ChooseGrid"), self.CellControl, self.CellPfbName, nil, self.ChildNum, self.ChildInterver, true)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self)
  self.closeBtn = self:FindGO("CloseButton")
  if self.closeBtn then
    self:AddClickEvent(self.closeBtn, function()
      self:Hide()
    end)
  end
  self.needSetCheckValidFuncOnShow = true
  self.tipData = {
    funcConfig = {},
    callback = function()
      self.clickId = 0
    end,
    ignoreBounds = {}
  }
  self.textForAll = ZhString.Card_All
  self.filterPop = self:FindComponent("FilterPop", UIPopupList)
  if self.filterPop then
    self.filterPop.gameObject:SetActive(false)
  end
end

function EquipChooseBord:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function EquipChooseBord:SetItemTipInValid()
  self.itemTipInvalid = true
end

function EquipChooseBord:ClickItemIcon(cellctl)
  if self.itemTipInvalid then
    return
  end
  local data = cellctl and cellctl.data
  local go = cellctl and cellctl.itemIcon
  local newClickId = data and data.id or 0
  if self.clickId ~= newClickId then
    self.clickId = newClickId
    self.tipData.itemdata = data
    self.tipData.ignoreBounds[1] = go
    self:ShowItemTip(self.tipData, go:GetComponent(UIWidget), nil, itemTipOffset)
  else
    self:ShowItemTip()
    self.clickId = 0
  end
end

function EquipChooseBord:HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  self:SetChoose(data)
  self:PassEvent(EquipChooseBord.ChooseItem, data)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end

function EquipChooseBord:SetChoose(data)
  local newChooseId = data and data.id or 0
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
  end
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseId(self.chooseId)
  end
end

function EquipChooseBord:ResetDatas(datas, resetPos)
  self.datas = datas
  self:ResetCtrl(datas, resetPos)
  self:_OnFilterPopChange(resetPos)
end

function EquipChooseBord:ResetCtrl(datas, resetPos)
  if resetPos then
    self.chooseCtl:ResetPosition()
  end
  self.chooseCtl:ResetDatas(datas)
  self.noneTip.gameObject:SetActive(#datas == 0)
end

function EquipChooseBord:UpdateChooseInfo(datas)
  if not datas and self.getDataFunc then
    datas = self.getDataFunc()
  end
  datas = datas or {}
  self:ResetDatas(datas)
end

function EquipChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip, cellName)
  if updateInfo then
    self:UpdateChooseInfo()
    if cellName then
      self:SetChooseCellBtnName(cellName)
    end
  end
  self.gameObject:SetActive(true)
  if self.needSetCheckValidFuncOnShow then
    self:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
  end
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end

function EquipChooseBord:Hide()
  TipManager.CloseTip()
  self.gameObject:SetActive(false)
  self:ResetDatas(_EmptyTable)
  self.chooseCall = nil
  self.chooseCallParam = nil
  self.checkFunc = nil
  self.checkTip = nil
end

function EquipChooseBord:ActiveSelf()
  return self.gameObject.activeSelf
end

function EquipChooseBord:SetBordTitle(text)
  self.title.text = text
end

function EquipChooseBord:SetChooseCellBtnName(zhstring)
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChooseButtonText(zhstring)
  end
end

function EquipChooseBord:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
  end
end

function EquipChooseBord:SetNoneTip(text)
  self.noneTip.text = text
end

local defaultDataTypeGetter = function(data)
  return data and data.staticData and data.staticData.Type
end

function EquipChooseBord:SetFilterPopData(data, dataTypeGetter)
  if not self.filterPop then
    return
  end
  local flag = data ~= nil and 0 < #data
  self.filterPop.gameObject:SetActive(flag)
  if flag then
    self.filterPop:Clear()
    self.filterPop:AddItem(self.textForAll)
    for i = 1, #data do
      self.filterPop:AddItem(data[i].name, data[i].types)
    end
    self.filterPop.value = self.textForAll
    EventDelegate.Add(self.filterPop.onChange, function()
      self:_OnFilterPopChange(true)
    end)
  end
end

function EquipChooseBord:_OnFilterPopChange(resetPos)
  if not self.filterPop then
    return
  end
  if not self.datas or not next(self.datas) then
    return
  end
  local d = self.filterPop.data
  if d then
    local filteredData, arrayFindIndex, arrayPushBack = ReusableTable.CreateArray(), TableUtility.ArrayFindIndex, TableUtility.ArrayPushBack
    if not dataTypeGetter then
      dataTypeGetter = defaultDataTypeGetter
    end
    for i = 1, #self.datas do
      if arrayFindIndex(d, dataTypeGetter(self.datas[i])) > 0 then
        arrayPushBack(filteredData, self.datas[i])
      end
    end
    self:ResetCtrl(filteredData, resetPos)
    ReusableTable.DestroyAndClearArray(filteredData)
  else
    self:ResetCtrl(self.datas, resetPos)
  end
end

function EquipChooseBord:__OnViewDestroy()
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end

function EquipChooseBord:UpdateItemIconChoose()
  local cells = self.chooseCtl and self.chooseCtl:GetCells()
  if cells and 0 < #cells then
    for _, cell in pairs(cells) do
      cell:SetItemIconChooseId(self.clickId)
    end
  end
end

function EquipChooseBord:SetTypeLabelTextGetter(getter)
  local cells = self.chooseCtl and self.chooseCtl:GetCells()
  if cells and 0 < #cells then
    for _, cell in pairs(cells) do
      cell:SetTypeLabelTextGetter(getter)
    end
  end
end

function EquipChooseBord:ActiveFilterPop(b)
  if not self.filterPop then
    return
  end
  self.filterPop.gameObject:SetActive(b)
end

function EquipChooseBord:ActiveCloseButton(b)
  if self.closeBtn then
    self.closeBtn:SetActive(b)
  end
end

autoImport("EquipCountChooseCell")
EquipCountChooseBord = class("EquipCountChooseBord", EquipChooseBord)
EquipCountChooseBord.CellControl = EquipCountChooseCell

function EquipCountChooseBord:InitBord()
  EquipCountChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
end

function EquipCountChooseBord:OnCountChooseChange(cellCtl)
  local checkValid = true
  if self.countChangeCall and cellCtl.data then
    checkValid = self.countChangeCall(cellCtl)
  end
  if checkValid then
    self:PassEvent(EquipChooseCellEvent.CountChooseChange, cellCtl)
  else
    self:PassEvent(EquipChooseCellEvent.CountChooseCheck, cellCtl)
  end
end

function EquipCountChooseBord:SetChooseReference(reference, refreshData)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseReference(reference)
  end
  if refreshData then
    local datas = self.chooseCtl:GetDatas()
    if datas then
      for i = 1, #datas do
        for j = 1, #datas[i] do
          datas[i][j].chooseCount = 0
          for k, v in pairs(reference) do
            if v.id == datas[i][j].id then
              datas[i][j].chooseCount = v.num
            end
          end
        end
      end
    end
  end
end

function EquipCountChooseBord:SetUseItemNum(b)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetUseItemNum(b)
  end
end

function EquipCountChooseBord:SetCellPlusValid(b)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:ActivePlusButton(b)
  end
end

function EquipCountChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip, countChangeFunc)
  EquipCountChooseBord.super.Show(self, updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip)
  self.countChangeCall = countChangeFunc
end

function EquipCountChooseBord:Hide()
  EquipCountChooseBord.super.Hide(self)
  self.countChangeCall = nil
end

EquipMultiChooseBord = class("EquipMultiChooseBord", EquipChooseBord)
EquipMultiChooseBord.CellControl = EquipMultiChooseCell

function EquipMultiChooseBord:InitBord()
  EquipMultiChooseBord.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickCancel, self.ClickCancel, self)
end

function EquipMultiChooseBord:ClickCancel(cellCtl)
  self:PassEvent(EquipChooseCellEvent.ClickCancel, cellCtl and cellCtl.data)
end

function EquipMultiChooseBord:SetChoose(data)
end

function EquipMultiChooseBord:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(reference)
  end
end

EquipChooseBord_CombineSize = class("EquipChooseBord_CombineSize", EquipChooseBord)
EquipChooseBord_CombineSize.PfbPath = "part/EquipChooseBord_CombineSize"
EquipMultiChooseBord_CombineSize = class("EquipMultiChooseBord_CombineSize", EquipChooseBord_CombineSize)
EquipMultiChooseBord_CombineSize.CellControl = EquipMultiChooseCell

function EquipMultiChooseBord_CombineSize:InitBord()
  EquipMultiChooseBord_CombineSize.super.InitBord(self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickCancel, self.ClickCancel, self)
end

function EquipMultiChooseBord_CombineSize:ClickCancel(cellCtl)
  self:PassEvent(EquipChooseCellEvent.ClickCancel, cellCtl and cellCtl.data)
end

function EquipMultiChooseBord_CombineSize:SetChoose(data)
end

function EquipMultiChooseBord_CombineSize:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(reference)
  end
end
