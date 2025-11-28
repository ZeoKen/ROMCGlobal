local BaseCell = autoImport("BaseCell")
BokiEquipItem = class("BokiEquipItem", BaseCell)

function BokiEquipItem:Init()
  self.icon = self:FindComponent("Icon", UISprite)
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.empty = self:FindGO("Empty")
  self.choosen = self:FindGO("Choosen")
  self.add = self:FindGO("Add")
  self:AddClickEvent(self.add, function()
    local itemdata = BagProxy.Instance:GetItemByStaticID(self.data.itemId)
    itemdata = itemdata or BagProxy.Instance:GetItemByStaticID(self.data.itemId, 7)
    if itemdata then
      ServiceItemProxy.Instance:CallItemUse(itemdata)
    end
  end)
  self:AddCellClickEvent()
end

function BokiEquipItem:SetData(data)
  self.data = data
  self.empty.gameObject:SetActive(nil == data)
  self.icon.gameObject:SetActive(nil ~= data)
  self.lv.gameObject:SetActive(nil ~= data)
  self:UpdateChoose()
  if data then
    local staticData = Table_Item[data.itemId]
    local cellName = staticData and staticData.Icon or ""
    IconManager:SetItemIcon(cellName, self.icon)
    self.icon:MakePixelPerfect()
    self.name.text = staticData and staticData.NameZh
    if data.unlock then
      self:Show(self.lv)
      self.lv.text = data.level .. "/" .. data.maxLv
      ColorUtil.WhiteUIWidget(self.icon)
      self.add:SetActive(false)
    else
      self:Hide(self.lv)
      ColorUtil.ShaderGrayUIWidget(self.icon)
      self.add:SetActive(0 < BagProxy.Instance:GetItemNumByStaticID(data.itemId, GameConfig.BoKiConfig.CheckPackage))
    end
  end
end

function BokiEquipItem:SetChoose(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function BokiEquipItem:UpdateChoose()
  if self.data and self.chooseId and self.data.pos == self.chooseId then
    self.choosen:SetActive(true)
  else
    self.choosen:SetActive(false)
  end
end
