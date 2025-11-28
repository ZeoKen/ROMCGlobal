autoImport("EquipMfrChooseCombineItemCell")
EquipMfrChooseBord = class("EquipMfrChooseBord", CoreView)
EquipMfrChooseBord.CellControl = EquipMfrChooseCombineItemCell
EquipMfrChooseBord.PfbPath = "part/EquipMfrChooseBord"
EquipMfrChooseBord.CellPfbName = "EquipMfrChooseCombineItemCell"
EquipMfrChooseBord.ChooseItem = "EquipMfrChooseBord_ChooseItem"
local itemTipOffset = {216, -290}

function EquipMfrChooseBord:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb(self.PfbPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.getDataFunc = getDataFunc
  if not getDataFunc then
    function self.getDataFunc()
      return EquipMakeProxy.Instance:GetClassifiedFilteredMakeItemDatas(self.filterPop and self.filterPop.data, self.isSelfProfession)
    end
  end
  self:InitBord()
end

function EquipMfrChooseBord:InitBord()
  self:InitDepth()
  self.title = self:FindComponent("Title", UILabel)
  self.noneTip = self:FindComponent("NoneTip", UILabel)
  if not self.equipList then
    local container = self:FindGO("EquipWrap")
    local wrapConfig = {
      wrapObj = container,
      pfbNum = 10,
      cellName = self.CellPfbName,
      control = self.CellControl
    }
    self.equipList = WrapCellHelper.new(wrapConfig)
    self.equipList:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
    self.equipList:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.ClickItemIcon, self)
    self.equipList:AddEventListener(EquipMfrChooseCombineItemCell.ClickArrow, self.OnClickArrow, self)
  end
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
  self.selfProfession = self:FindGO("SelfProfession"):GetComponent(UIToggle)
  EventDelegate.Add(self.selfProfession.onChange, function()
    if self.isSelfProfession ~= self.selfProfession.value then
      self.isSelfProfession = self.selfProfession.value
      self:UpdateChooseInfo(nil, true)
    end
  end)
end

function EquipMfrChooseBord:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function EquipMfrChooseBord:SetToggleSelfProfession(value)
  if self.isSelfProfession == value and self.selfProfession.value == value then
    return
  end
  self.selfProfession.value = value
end

function EquipMfrChooseBord:SetItemTipInValid()
  self.itemTipInvalid = true
end

function EquipMfrChooseBord:OnClickArrow(tab)
  self:UpdateChooseInfo()
end

function EquipMfrChooseBord:ClickItemIcon(cellctl)
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

function EquipMfrChooseBord:HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  self:SetChoose(data)
  self:PassEvent(EquipMfrChooseBord.ChooseItem, data)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end

function EquipMfrChooseBord:SetChoose(data)
  local newChooseId = 0
  if data then
    if type(data) == "table" then
      newChooseId = data.composeId
    else
      newChooseId = data
    end
  end
  if self.chooseId ~= newChooseId then
    self.chooseId = newChooseId
  end
  local cells = self.equipList:GetCellCtls()
  for _, cell in pairs(cells) do
    cell:SetChooseId(self.chooseId)
  end
end

function EquipMfrChooseBord:ResetDatas(datas, resetPos)
  self.datas = datas
  self:ResetCtrl(datas, resetPos)
end

function EquipMfrChooseBord:ResetCtrl(datas, resetPos)
  if resetPos then
    self.equipList:ResetPosition()
  end
  self.equipList:ResetDatas(datas)
  self.noneTip.gameObject:SetActive(#datas == 0)
end

function EquipMfrChooseBord:UpdateChooseInfo(datas, resetPos)
  if not datas and self.getDataFunc then
    datas = self.getDataFunc(self)
  end
  datas = datas or {}
  self:ResetDatas(datas, resetPos)
end

function EquipMfrChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip)
  if updateInfo then
    self:UpdateChooseInfo()
  end
  self.gameObject:SetActive(true)
  if self.needSetCheckValidFuncOnShow then
    self:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
  end
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end

function EquipMfrChooseBord:Hide()
  TipManager.CloseTip()
  self.gameObject:SetActive(false)
  self:ResetDatas(_EmptyTable)
  self.chooseCall = nil
  self.chooseCallParam = nil
  self.checkFunc = nil
  self.checkTip = nil
end

function EquipMfrChooseBord:ActiveSelf()
  return self.gameObject.activeSelf
end

function EquipMfrChooseBord:SetBordTitle(text)
  self.title.text = text
end

function EquipMfrChooseBord:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip, needShowInvalidItemTip)
end

function EquipMfrChooseBord:SetNoneTip(text)
  self.noneTip.text = text
end

function EquipMfrChooseBord:SetFilterPopData(data, dataTypeGetter)
  if not self.filterPop then
    return
  end
  local flag = data ~= nil and 0 < #data
  self.filterPop.gameObject:SetActive(flag)
  if flag then
    local step2List, step1List, ancientList = AdventureDataProxy.Instance:GetCommonEquip(nil, nil, true)
    local equip_list = {
      [1] = {},
      [2] = {},
      [3] = {}
    }
    for _, v in pairs(step1List) do
      table.insert(equip_list[1], v.staticId)
    end
    for _, v in pairs(step2List) do
      table.insert(equip_list[2], v.staticId)
    end
    for _, v in pairs(ancientList) do
      table.insert(equip_list[3], v.staticId)
    end
    self.filterPop:Clear()
    self.filterPop:AddItem(self.textForAll)
    for i = 1, #data do
      self.filterPop:AddItem(data[i].name, {
        tab = i,
        list = data[i].list and equip_list[data[i].list]
      })
    end
    self.filterPop.value = self.textForAll
    EventDelegate.Add(self.filterPop.onChange, function()
      self:_OnFilterPopChange(true)
    end)
  end
end

function EquipMfrChooseBord:_OnFilterPopChange(resetPos)
  if not self.filterPop then
    return
  end
  self:UpdateChooseInfo(nil, resetPos)
end

function EquipMfrChooseBord:__OnViewDestroy()
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end
