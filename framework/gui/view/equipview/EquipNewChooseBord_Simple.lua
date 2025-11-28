autoImport("EquipNewChooseBord")
autoImport("EquipChooseBord")
autoImport("BagItemNewCell")
autoImport("EquipChooseCell_Simple")
EquipNewChooseBord_Simple = class("EquipNewChooseBord_Simple", EquipNewChooseBord)
EquipNewChooseBord_Simple.CellControl = EquipChooseCell_Simple
EquipNewChooseBord_Simple.PfbPath = "part/EquipNewChooseBord"
EquipNewChooseBord_Simple.CellPfbName = "EquipChooseCell_Simple"
EquipNewChooseBord_Simple.ChildNum = 6
EquipNewChooseBord_Simple.ChildInterver = 90

function EquipNewChooseBord_Simple:InitBord()
  EquipNewChooseBord_Simple.super.InitBord(self)
  local chooseGrid = self:FindGO("ChooseGrid"):GetComponent(UIWrapContent)
  chooseGrid.itemSize = 90
end

function EquipNewChooseBord_Simple:HandleClickItem(cellctl)
  if self:IsTweenPlaying() then
    return
  end
  if self.nextClickValidTime and self.nextClickValidTime > ServerTime.CurServerTime() / 1000 then
    return
  end
  self.nextLongPressValidTime = ServerTime.CurServerTime() / 1000 + 0.5
  local data = cellctl and cellctl.data
  self:SetChoose(data)
  local tempData = {itemData = data}
  self:PassEvent(EquipChooseBord.ChooseItem, tempData)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end

function EquipNewChooseBord_Simple:SetCountLimit(count)
  self.countLimit = count
end

function EquipNewChooseBord_Simple:ClickItemIcon(cellctl)
  if self.itemTipInvalid then
    return
  end
  if self.nextLongPressValidTime and self.nextLongPressValidTime > ServerTime.CurServerTime() / 1000 then
    return
  end
  self.nextClickValidTime = ServerTime.CurServerTime() / 1000 + 0.5
  local data = cellctl and cellctl.data
  local go = cellctl and cellctl.itemIcon
  local newClickId = data and data.id or 0
  if self.clickId ~= newClickId then
    self.clickId = newClickId
    self.tipData.itemdata = data
    self.tipData.ignoreBounds[1] = go
    if BagProxy.CheckEquipIsClean(data) then
      self.tipData.customFuncConfig = {
        name = ZhString.EquipRecover_DeCompose,
        needCountChoose = true,
        customCount = self.countLimit or 50,
        callback = function(id, count)
          local tempdata = {itemData = data, count = count}
          self:PassEvent(EquipChooseBord.ChooseItem, tempdata)
        end
      }
    else
      self.tipData.customFuncConfig = nil
    end
    self:ShowItemTip(self.tipData, go:GetComponent(UIWidget), nil, itemTipOffset)
  else
    self:ShowItemTip()
    self.clickId = 0
  end
  self:UpdateItemIconChoose()
end
