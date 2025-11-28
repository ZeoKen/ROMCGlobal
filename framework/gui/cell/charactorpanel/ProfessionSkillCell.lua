local baseCell = autoImport("BaseCell")
ProfessionSkillCell = class("ProfessionSkillCell", baseCell)

function ProfessionSkillCell:Init()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.cdMask = Game.GameObjectUtil:DeepFindChild(self.gameObject, "CDMask"):GetComponent(UISprite)
  self.bg = self:FindGO("bg"):GetComponent(UIMultiSprite)
  self:AddCellClickEvent()
end

function ProfessionSkillCell:SetData(obj)
  if obj then
    local profession = obj[1]
    local skill = obj[2]
    self.data = skill
    local professionData = Table_Class[profession]
    local professionType = professionData and professionData.Type or MyselfProxy.Instance:GetMyProfessionType()
    local skillData = Table_Skill[skill]
    if skillData then
      if profession then
        IconManager:SetSkillIconByProfess(skillData.Icon, self.icon, professionType, true)
      else
        IconManager:SetSkillIcon(skillData.Icon, self.icon)
      end
      self.icon:MakePixelPerfect()
      if skillData.SkillType == "Passive" then
        self.bg.CurrentState = 0
        self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      else
        self.bg.CurrentState = 1
        self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.85, 0.85, 0.85)
      end
      self:Show(self.icon.gameObject)
    else
      self.icon.spriteName = nil
      errorLog("can't find skillData in table Skill,Skill id:", obj)
    end
  end
end

function ProfessionSkillCell:RefreshCD(f)
  self.cdMask.fillAmount = f
end
