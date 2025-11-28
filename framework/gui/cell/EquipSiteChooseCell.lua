autoImport("ItemCell")
local BaseCell = autoImport("BaseCell")
EquipSiteChooseCell = class("EquipSiteChooseCell", BaseCell)

function EquipSiteChooseCell:Init()
  self.itemCell = ItemCell.new(self.gameObject)
  self.nameLab = self.itemCell.nameLab
  self.symbol = self:FindGO("Symbol"):GetComponent(UISprite)
  self.strengLv_Fake = self:FindGO("StrengLv_Fake"):GetComponent(UILabel)
  self.chooseButton = self:FindGO("ChooseButton")
  if self.chooseButton then
    self.chooseButtonLabel = self:FindComponent("Label", UILabel, self.chooseButton)
    self:AddClickEvent(self.chooseButton, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  end
  self.desc = self:FindGO("Desc"):GetComponent(UILabel)
end

function EquipSiteChooseCell:SetData(data)
  self.data = data
  local itemdata = data.itemdata
  local site = data.site
  if itemdata then
    self.itemCell:SetData(itemdata)
    self.symbol.gameObject:SetActive(false)
    self.desc.text = string.format(ZhString.EquipStrength_CurEquip, itemdata:GetName())
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
    self.strengLv_Fake.text = data.lv or ""
    self.desc.text = string.format(ZhString.EquipStrength_CurEquip, ZhString.EquipStrength_EmptyEquip)
  end
  self.nameLab.text = GameConfig.EquipPosName and GameConfig.EquipPosName[data.site]
  if site == 1 then
    self:AddOrRemoveGuideId(self.chooseButton, 1003)
  else
    self:AddOrRemoveGuideId()
  end
end
