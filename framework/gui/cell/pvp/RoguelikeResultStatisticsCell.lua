RoguelikeResultStatisticsCell = class("RoguelikeResultStatisticsCell", CoreView)

function RoguelikeResultStatisticsCell:ctor(obj)
  RoguelikeResultStatisticsCell.super.ctor(self, obj)
  self:FindObjs()
end

function RoguelikeResultStatisticsCell:FindObjs()
  self.profession = self:FindGO("profession")
  self.professionBg = self:FindComponent("Color", UISprite, self.profession)
  self.professionSp = self:FindComponent("Icon", UISprite, self.profession)
  self.name = self:FindComponent("name", UILabel)
  self.damage = self:FindComponent("damage", UILabel)
  self.bedamage = self:FindComponent("bedamage", UILabel)
  self.heal = self:FindComponent("heal", UILabel)
  self.dienum = self:FindComponent("dienum", UILabel)
end

function RoguelikeResultStatisticsCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  local proData = data and data.profession and Table_Class[data.profession]
  self.profession:SetActive(proData and IconManager:SetNewProfessionIcon(proData.icon, self.professionSp) or false)
  if proData then
    self.professionBg.color = ColorUtil[string.format("CareerIconBg%s", proData.Type)] or ColorUtil.CareerIconBg0
  end
  self.name.text = data.name
  self.damage.text = data.damage
  self.bedamage.text = data.bedamage
  self.heal.text = data.heal
  self.dienum.text = data.dienum
end
