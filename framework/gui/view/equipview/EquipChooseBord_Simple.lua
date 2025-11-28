autoImport("EquipChooseBord")
autoImport("EquipChooseCell_Simple")
EquipChooseBord_Simple = class("EquipChooseBord_Simple", EquipChooseBord)
EquipChooseBord_Simple.CellControl = EquipChooseCell_Simple
EquipChooseBord_Simple.PfbPath = "part/EquipChooseBord"
EquipChooseBord_Simple.CellPfbName = "EquipChooseCell_Simple"
EquipChooseBord_Simple.ChildNum = 5
EquipChooseBord_Simple.ChildInterver = 100

function EquipChooseBord_Simple:InitBord()
  EquipChooseBord_Simple.super.InitBord(self)
  local chooseGrid = self:FindGO("ChooseGrid"):GetComponent(UIWrapContent)
  if chooseGrid then
    chooseGrid.itemSize = 100
  end
end

function EquipChooseBord_Simple:HandleClickItem(cellctl)
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

function EquipChooseBord_Simple:SetCountLimit(count)
  self.countLimit = count
end

function EquipChooseBord_Simple:ClickItemIcon(cellctl)
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
