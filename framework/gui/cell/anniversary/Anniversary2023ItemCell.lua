autoImport("ItemCell")
Anniversary2023ItemCell = class("Anniversary2023ItemCell", ItemCell)
local tipOffset = {-200, 0}

function Anniversary2023ItemCell:Init()
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self:AddClickEvent(self.gameObject, function()
    local itemData = self.cellData and self.cellData.itemData
    if itemData then
      self.tipData.itemdata = itemData
      self:ShowItemTip(self.tipData, self.itemContainerWidget, NGUIUtil.AnchorSide.Left, tipOffset)
    end
  end)
  self.itemContainerGO = self:FindGO("ItemContainer")
  self.itemContainerWidget = self.itemContainerGO:GetComponent(UIWidget)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  Anniversary2023ItemCell.super.Init(self)
  self:HideNum(true)
  self.itemNumGO = self:FindGO("ItemNum")
  self.itemNum = self:FindComponent("Num", UILabel, self.itemNumGO)
  self.ownedGO = self:FindGO("Owned")
end

function Anniversary2023ItemCell:SetData(data)
  self.cellData = data
  if data then
    if data.owned then
      self.ownedGO:SetActive(true)
      self.itemContainerWidget.alpha = 0.8
    else
      self.ownedGO:SetActive(false)
      self.itemContainerWidget.alpha = 1
    end
    if data.itemNum and data.itemNum > 0 then
      self.itemNumGO:SetActive(true)
      self.itemNum.text = "x" .. data.itemNum
    else
      self.itemNumGO:SetActive(false)
    end
    Anniversary2023ItemCell.super.SetData(self, data.itemData)
    self:HideBgSp()
  end
end
