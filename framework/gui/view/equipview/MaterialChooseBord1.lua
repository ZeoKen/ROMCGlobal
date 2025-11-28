autoImport("MaterialChooseCell1")
MaterialChooseBord1 = class("MaterialChooseBord1", CoreView)
MaterialChooseBord1.PrefabPath = "part/MaterialChooseBord1"
MaterialChooseBord1.Event = {
  ChooseItem = "MaterialChooseBord1_Event_ChooseItem",
  CountChooseChange = "MaterialChooseBord1_Event_CountChooseChange"
}
local itemTipOffset = {216, -290}

function MaterialChooseBord1:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb(self.PrefabPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self.getDataFunc = getDataFunc
  self:InitBord()
end

function MaterialChooseBord1:InitBord()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
  self.title = self:FindComponent("Title", UILabel)
  self.noneTip = self:FindGO("NoneTip")
  self.noneTip_Label = self:FindComponent("Label", UILabel, self.noneTip)
  self.chooseCtl = WrapListCtrl.new(self:FindGO("ChooseGrid"), MaterialChooseCell1, "MaterialChooseCell1", nil, 1, 0, true)
  self.chooseCtl:AddEventListener(MaterialChooseCell1.Event.ClickItemIcon, self.ClickItemIcon, self)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.chooseCtl:AddEventListener(MaterialChooseCell1.Event.CountChooseChange, self.HandleOnCountChooseChange, self)
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
end

function MaterialChooseBord1:SetItemTipInValid()
  self.itemTipInvalid = true
end

function MaterialChooseBord1:ClickItemIcon(cellctl)
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
    self:ShowItemTip(self.tipData, go, nil, itemTipOffset)
  else
    self:ShowItemTip()
    self.clickId = 0
  end
end

function MaterialChooseBord1:HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  self:PassEvent(MaterialChooseBord1.Event.ChooseItem, data)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end

function MaterialChooseBord1:HandleOnCountChooseChange(cellCtl)
  self:PassEvent(MaterialChooseBord1.Event.CountChooseChange, cellCtl)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, cellCtl.data)
  end
end

function MaterialChooseBord1:ResetDatas(datas, resetPos)
  self.datas = datas
  self:ResetCtrl(datas, resetPos)
end

function MaterialChooseBord1:ResetCtrl(datas, resetPos)
  if resetPos then
    self.chooseCtl:ResetPosition()
  end
  self.chooseCtl:ResetDatas(datas)
  self.noneTip:SetActive(#datas == 0)
end

function MaterialChooseBord1:UpdateChooseInfo(datas)
  if not datas and self.getDataFunc then
    datas = self.getDataFunc()
  end
  datas = datas or {}
  self:ResetDatas(datas)
end

function MaterialChooseBord1:Show(updateInfo, chooseCall, chooseCallParam)
  if updateInfo then
    self:UpdateChooseInfo()
  end
  self.gameObject:SetActive(true)
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end

function MaterialChooseBord1:Hide()
  TipManager.CloseTip()
  self.gameObject:SetActive(false)
  self:ResetDatas(_EmptyTable)
  self.chooseCall = nil
  self.chooseCallParam = nil
end

function MaterialChooseBord1:ActiveSelf()
  return self.gameObject.activeSelf
end

function MaterialChooseBord1:SetBordTitle(text)
  self.title.text = text
end

function MaterialChooseBord1:SetNoneTip(text)
  self.noneTip_Label.text = text
end

function MaterialChooseBord1:SetChooseReference(reference)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseReference(reference)
  end
  if reference then
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

function MaterialChooseBord1:SetChooseCount(count)
  self.chooseCount = count
  if self.data and self.data.__isclone then
    self.data.chooseCount = count
  end
  self:UpdateCountChoose()
end

function MaterialChooseBord1:UpdateCountChoose()
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:UpdateCountChoose()
  end
end

function MaterialChooseBord1:SetUseItemNum(b)
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetUseItemNum(b)
  end
end

function MaterialChooseBord1:SetValidEvent(validEvent, validParam, validMsgId)
  self.validEvent = validEvent
  self.validParam = validParam
  local cells = self.chooseCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetValidEvent(validEvent, validParam, validMsgId)
  end
end

function MaterialChooseBord1:__OnViewDestroy()
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end

MaterialChooseBord1_CombineSize = class("MaterialChooseBord1_CombineSize", MaterialChooseBord1)
MaterialChooseBord1_CombineSize.PrefabPath = "part/MaterialChooseBord1_CombineSize"
