autoImport("SkillTip")
local baseCell = autoImport("BaseCell")
DMCellForSkill = class("DMCellForSkill", baseCell)

function DMCellForSkill:Init()
  self:FindObjs()
end

function DMCellForSkill:FindObjs()
  self.Icon = self:FindGO("Icon", self.gameObject)
  self.Title1 = self:FindGO("Title1", self.gameObject)
  self.Desc1 = self:FindGO("Desc1", self.gameObject)
  self.BG = self:FindGO("BG", self.gameObject)
  self.Icon_UISprite = self.Icon:GetComponent(UISprite)
  self.Title1_UILabel = self.Title1:GetComponent(UILabel)
  self.Desc1_UILabel = self.Desc1:GetComponent(UILabel)
  self.BGBase = self:FindGO("BGBase", self.gameObject)
  self.Frame = self:FindGO("Frame", self.gameObject)
end

function DMCellForSkill:SetChoose(isChoose)
end

function DMCellForSkill:SetData(id)
  local skillData = Table_Skill[id]
  if skillData then
    IconManager:SetSkillIcon(skillData.Icon, self.Icon_UISprite)
    self.Title1_UILabel.text = skillData.NameZh
    local skillDesc = SkillTip:GetDesc(skillData)
    if skillDesc then
      self.Desc1_UILabel.text = skillDesc
      if self.Desc1_UILabel.printedSize.y > 44 then
        self.BGBase.gameObject:SetActive(false)
      else
        self.BGBase.gameObject:SetActive(true)
      end
    end
  end
  self.Frame.gameObject:SetActive(false)
end

function DMCellForSkill:SetDataForServant(id)
  local skillData = Table_Monster[id]
  if skillData then
    IconManager:SetNpcMonsterIconByID(id, self.Icon_UISprite)
    self.Title1_UILabel.text = skillData.NameZh
    self.Desc1_UILabel.text = skillData.Desc
  end
  self.BGBase.gameObject:SetActive(false)
  self.BG.gameObject:SetActive(false)
  self.Frame.gameObject:SetActive(true)
end
