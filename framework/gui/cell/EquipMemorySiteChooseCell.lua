autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
EquipMemorySiteChooseCell = class("EquipMemorySiteChooseCell", BaseCell)

function EquipMemorySiteChooseCell:Init()
  self.itemCell = ItemCell.new(self.gameObject)
  self.nameLab = self.itemCell.nameLab
  self.symbol = self:FindGO("Symbol"):GetComponent(UISprite)
  self.strengLv_Fake = self:FindGO("StrengLv_Fake"):GetComponent(UILabel)
  self.strengLv_Fake.text = ""
  self.chooseButton = self:FindGO("ChooseButton")
  if self.chooseButton then
    self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
    self:AddClickEvent(self.chooseButton, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  end
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
  local itemGO = self:FindGO("Item")
  self:AddClickEvent(itemGO, function()
    self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
  end)
  self:AddClickEvent(self.symbol.gameObject, function()
    self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
  end)
end

function EquipMemorySiteChooseCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  else
    self.gameObject:SetActive(true)
  end
  self.data = data
  local itemdata = data.itemdata
  local equipItemData = data.equipedItemData
  local site = data.site
  if equipItemData then
    self.itemCell:SetData(equipItemData)
    self.symbol.gameObject:SetActive(false)
    if itemdata then
      self.desc.text = ItemUtil.GetMemoryTag(itemdata)
    else
      self.desc.text = string.format(ZhString.EquipStrength_CurEquip, ZhString.EquipMemory_NoEquipMemory)
    end
  else
    self.itemCell:SetData()
    self.symbol.gameObject:SetActive(true)
    local spriteName
    if site == 5 or site == 6 then
      spriteName = "bag_equip_6"
    else
      spriteName = "bag_equip_" .. site
    end
    IconManager:SetUIIcon(spriteName, self.symbol)
    self.symbol:MakePixelPerfect()
    if itemdata then
      self.desc.text = string.format(ZhString.EquipMemory_CurEquipNoEffect, ItemUtil.GetMemoryTag(itemdata))
    else
      self.desc.text = string.format(ZhString.EquipStrength_CurEquip, ZhString.EquipMemory_NoEquipMemory)
    end
  end
  self.nameLab.text = GameConfig.EquipPosName and GameConfig.EquipPosName[data.site]
end
