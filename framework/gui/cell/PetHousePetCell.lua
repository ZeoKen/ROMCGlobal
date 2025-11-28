autoImport("BaseCell")
PetHousePetCell = class("PetHousePetCell", BaseCell)

function PetHousePetCell:Init()
  self.pos = self:FindGO("content")
  self.icon = self:FindComponent("PetHead", UISprite)
  self.level = self:FindComponent("Lvl", UILabel)
  self.friendlyLvl = self:FindComponent("FriendlyLvl", UILabel)
  self.friendly = self:FindGO("Friendly")
  self.tagLab = self:FindComponent("TagLab", UILabel)
  self.eatFlag = self:FindGO("EatFlag")
  self.eatFlagLab = self:FindComponent("EatFlagLab", UILabel)
  self.eatFlagLab.text = ZhString.PetHouseView_Feed
  PetHousePetCell.super.Init(self)
  self:AddCellClickEvent()
end

function PetHousePetCell:SetData(data)
  if data then
    self.pos:SetActive(true)
    self.data = data
    self.guid = data.guid
    IconManager:SetFaceIcon(data:GetHeadIcon(), self.icon)
    self.level.text = string.format(ZhString.PetAdventure_Lv, data.lv)
    self.friendlyLvl.text = data.friendlv
    self:Show(self.level)
    self.eatFlag:SetActive(data.isEat == 1)
  else
    self.pos:SetActive(false)
  end
end
