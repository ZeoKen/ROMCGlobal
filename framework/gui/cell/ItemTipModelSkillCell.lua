local BaseCell = autoImport("BaseCell")
ItemTipModelSkillCell = class("ItemTipModelSkillCell", BaseCell)
autoImport("ProfessionSkillCDCell")
local esource = 50

function ItemTipModelSkillCell:Init()
  self.skillname = self:FindComponent("skillname", UILabel)
  self.skilldesc = self:FindComponent("skilldesc", UILabel)
  self.skillcd = self:FindComponent("skillcd", UILabel)
  self.cellSelect = self:FindGO("cellSelect")
  self.lineB = Game.GameObjectUtil:DeepFindChild(self.gameObject, "lineB"):GetComponent(UISprite)
  local go = self:LoadPreferb("cell/ProfessionSkillCell", self:FindGO("ProfessionSkillCellPos"), true)
  self.skillcdCell = ProfessionSkillCDCell.new(go)
end

function ItemTipModelSkillCell:SetData(data)
  self.id = data[1]
  local stored = data[2]
  local skillStaticInfo = Table_Skill and Table_Skill[self.id]
  self.skillname.text = skillStaticInfo.NameZh
  self.skilldesc.text = SkillTip:GetDesc(skillStaticInfo)
  self.skillcd.text = ZhString.AdventurePanel_UseEffectSkill_CanUse
  local skilldata = SkillProxy.Instance:GetLearnedSkillWithSameSort(self.id)
  self.skillcdCell:SetData({
    nil,
    skillStaticInfo.id,
    skilldata,
    stored,
    self.skillcd
  })
  self:HideLine(false)
end

function ItemTipModelSkillCell:HideLine(istrue)
  self.lineB.alpha = istrue and 0.00392156862745098 or 1
end

function ItemTipModelSkillCell:SetSelect(isTrue)
  self.cellSelect:SetActive(isTrue)
end

function ItemTipModelSkillCell:OnRemove()
  if self.skillcdCell and self.skillcdCell.OnRemove then
    self.skillcdCell:OnRemove()
  end
end
