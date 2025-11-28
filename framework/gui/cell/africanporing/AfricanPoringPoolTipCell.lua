autoImport("ItemCell")
AfricanPoringPoolTipCell = class("AfricanPoringPoolTipCell", ItemCell)

function AfricanPoringPoolTipCell:Init()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
  self.itemContainerGO = self:FindGO("ItemContainer")
  self.itemContainerWidget = self.itemContainerGO:GetComponent(UIWidget)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  AfricanPoringPoolTipCell.super.Init(self)
  self:HideNum(true)
  self.itemNumGO = self:FindGO("ItemNum")
  self.itemNum = self:FindComponent("Num", UILabel, self.itemNumGO)
  self.ownedGO = self:FindGO("Owned")
end

function AfricanPoringPoolTipCell:SetData(data)
  self.cellData = data
  if data then
    if data:IsOwned() then
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
    local itemData = data:GetItemData()
    AfricanPoringPoolTipCell.super.SetData(self, itemData)
    self:HideBgSp()
  end
end
