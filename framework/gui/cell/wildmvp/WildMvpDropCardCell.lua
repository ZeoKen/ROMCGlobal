local BaseCell = autoImport("BaseCell")
WildMvpDropCardCell = class("WildMvpDropCardCell", BaseCell)
autoImport("ItemCardCell")

function WildMvpDropCardCell:Init()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.refreshSymbol = self:FindGO("RefreshSymbol"):GetComponent(UIMultiSprite)
  local obj = self:LoadPreferb("cell/ItemCardCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.cardCell = ItemCardCell.new(obj)
  self:AddCellClickEvent()
end

function WildMvpDropCardCell:SetData(data)
  self.data = data
  local itemData = ItemData.new("CardItem", self.data)
  self.cardCell:SetData(itemData)
  if self.indexInList == 1 then
    self.refreshSymbol.gameObject:SetActive(true)
    self.refreshSymbol.CurrentState = 0
  elseif self.indexInList == 2 then
    self.refreshSymbol.gameObject:SetActive(true)
    self.refreshSymbol.CurrentState = 1
  else
    self.refreshSymbol.gameObject:SetActive(false)
  end
end
