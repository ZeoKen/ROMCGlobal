local baseCell = autoImport("BaseCell")
HireCatSkillCell = class("HireCatSkillCell", baseCell)

function HireCatSkillCell:Init()
  self:initView()
end

function HireCatSkillCell:initView()
  self.skillIcon = self:FindComponent("SkillIcon", UISprite)
  self.skillName = self:FindComponent("SkillName", UILabel)
  self.skillLv = self:FindComponent("Lv", UILabel)
  self.lockFlag = self:FindGO("LockFlag")
  self:SetEvent(self.skillIcon.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function HireCatSkillCell:SetData(value)
  self.skillID = nil
  self.data = value
  if not value then
    self.gameObject:SetActive(false)
    return
  end
  if nil == value.locked then
    local data = Table_Skill[value.id]
    if not data then
      redlog("佣兵猫技能ID未在Skill表中找到，错误ID： ", value.id)
      return
    end
    IconManager:SetSkillIcon(data.Icon, self.skillIcon)
    self.skillName.gameObject:SetActive(true)
    self.skillName.text = data.NameZh
    self.lockFlag:SetActive(false)
    self.skillLv.gameObject:SetActive(false)
    self:SetScale(1)
    self.skillID = value.id
    self.locked = false
    self.gameObject:SetActive(true)
  else
    self.skillName.gameObject:SetActive(false)
    local data = Table_Skill[value.id]
    if not data then
      redlog("佣兵猫技能ID未在Skill表中找到，错误ID： ", value.id)
      return
    end
    IconManager:SetSkillIcon(data.Icon, self.skillIcon)
    self.skillIcon.alpha = value.locked and 0.5 or 1
    self.lockFlag:SetActive(value.locked)
    self.skillLv.gameObject:SetActive(not value.locked)
    self.skillLv.text = "Lv." .. Table_Skill[value.id].Level
    self:SetScale(1.3)
    self.skillID = value.id
    self.locked = value.locked
    self.gameObject:SetActive(true)
  end
end

function HireCatSkillCell:IsSelf(gameObject)
  return gameObject == self.skillIcon.gameObject
end

local scale = LuaVector3.One()

function HireCatSkillCell:SetScale(size)
  if not Slua.IsNull(self.gameObject) and self.skillIcon then
    LuaVector3.Better_Set(scale, 1, 1, 1)
    LuaVector3.Mul(scale, size)
    self.skillIcon.gameObject.transform.localScale = scale
  end
end

function HireCatSkillCell:GetSkillItemData()
  if not self.skillID then
    return
  end
  if not self.skillItemData then
    self.skillItemData = SkillItemData.new(self.skillID)
  end
  if self.skillItemData.id ~= self.skillID then
    self.skillItemData:Reset(self.skillID)
  end
  self.skillItemData:SetLearned(not self.locked)
  self.skillItemData:SetNotMyselfSkill(true)
  return self.skillItemData
end
