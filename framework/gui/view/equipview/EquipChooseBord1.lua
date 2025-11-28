autoImport("EquipChooseCell1")
EquipChooseBord1 = class("EquipChooseBord1", CoreView)
EquipChooseBord1.CellControl = EquipChooseCell1
EquipChooseBord1.PfbPath = "part/EquipChooseBord1"
EquipChooseBord1.CellPfbName = "EquipChooseCell1"
EquipChooseBord1.ChooseItem = "EquipChooseBord1_ChooseItem"
EquipChooseBord1.ChildNum = 1
EquipChooseBord1.ChildInterver = 0

function EquipChooseBord1:ctor(parent, getDataFunc)
  self.textForAll = ZhString.Card_All
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb(self.PfbPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.getDataFunc = getDataFunc
  self:InitBord()
end

function EquipChooseBord1:InitBord()
  self:InitDepth()
  self.title = self:FindComponent("Title", UILabel)
  self.noneTip = self:FindGO("NoneTip")
  self.noneTip_Label = self:FindComponent("Label", UILabel, self.noneTip)
  self.chooseCtl = WrapListCtrl.new(self:FindGO("ChooseGrid"), self.CellControl, self.CellPfbName, nil, self.ChildNum, self.ChildInterver, true)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.chooseCtl:AddEventListener(EquipChooseCell1Event.ClickItemIcon, self.ClickItemIcon, self)
  self.closeBtn = self:FindGO("CloseButton")
  if self.closeBtn then
    self:AddClickEvent(self.closeBtn, function()
      self:Hide()
    end)
  end
  self.tipData = {
    funcConfig = {},
    callback = function()
      self.clickId = 0
    end,
    ignoreBounds = {}
  }
  self.filterPop = self:FindComponent("FilterPop", UIPopupList)
  if self.filterPop then
    self.filterPop.gameObject:SetActive(false)
  end
end

function EquipChooseBord1:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function EquipChooseBord1:SetItemTipInValid()
  self.itemTipInvalid = true
end

local ItemTipOffset = {216, -290}

function EquipChooseBord1:ClickItemIcon(cellctl)
  if self.itemTipInvalid then
    return
  end
  local data = cellctl and cellctl.data
  local go = cellctl and cellctl.icon
  local newClickId = data and data.id or 0
  if self.clickId ~= newClickId then
    self.clickId = newClickId
    self.tipData.itemdata = data
    self.tipData.ignoreBounds[1] = go
    self:ShowItemTip(self.tipData, go, nil, ItemTipOffset)
  else
    self:ShowItemTip()
    self.clickId = 0
  end
end

function EquipChooseBord1:HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  self:PassEvent(EquipChooseBord1.ChooseItem, data)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end

function EquipChooseBord1:ResetDatas(datas, resetPos)
  self.datas = datas
  self:ResetCtrl(datas, resetPos)
  self:_OnFilterPopChange(resetPos)
end

function EquipChooseBord1:ResetCtrl(datas, resetPos)
  if resetPos then
    self.chooseCtl:ResetPosition()
  end
  self.chooseCtl:ResetDatas(datas)
  self.chooseCtl:GetCells()
  self.noneTip:SetActive(#datas == 0)
end

function EquipChooseBord1:UpdateChooseInfo(datas)
  if not datas and self.getDataFunc then
    datas = self.getDataFunc()
  end
  datas = datas or {}
  self:ResetDatas(datas)
end

function EquipChooseBord1:Show(updateInfo, chooseCall, chooseCallParam)
  if updateInfo then
    self:UpdateChooseInfo()
  end
  self.gameObject:SetActive(true)
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end

function EquipChooseBord1:Hide()
  TipManager.CloseTip()
  self.gameObject:SetActive(false)
  self:ResetDatas(_EmptyTable)
  self.chooseCall = nil
  self.chooseCallParam = nil
end

function EquipChooseBord1:ActiveSelf()
  return self.gameObject.activeSelf
end

function EquipChooseBord1:SetBordTitle(text)
  self.title.text = text
end

function EquipChooseBord1:SetNoneTip(text)
  self.noneTip_Label.text = text
end

local defaultDataTypeGetter = function(data)
  return data and data.staticData and data.staticData.Type
end

function EquipChooseBord1:SetFilterPopData(data, dataTypeGetter)
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

function EquipChooseBord1:_OnFilterPopChange(resetPos)
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

function EquipChooseBord1:SetValidEvent(validEvent, validParam, validMsgId)
  self.validEvent = validEvent
  self.validParam = validParam
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetValidEvent(validEvent, validParam, validMsgId)
  end
end

function EquipChooseBord1:HideItemInValid()
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:HideItemInValid()
  end
end

function EquipChooseBord1:__OnViewDestroy()
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end

EquipChooseBord1_CombineSize = class("EquipChooseBord1_CombineSize", EquipChooseBord1)
EquipChooseBord1_CombineSize.PfbPath = "part/EquipChooseBord_CombineSize"
