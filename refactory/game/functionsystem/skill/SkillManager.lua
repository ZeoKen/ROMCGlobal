autoImport("SkillClickUseManager")
autoImport("SkillOptionManager")
autoImport("SkillDynamicManager")
autoImport("SkillComboManager")
SkillManager = class("SkillManager")

function SkillManager:ctor()
  self.skillClickUseManager = SkillClickUseManager.new()
  self.skillOptionManager = SkillOptionManager.new()
  self.skillDynamicManager = SkillDynamicManager.new()
  self.skillComboManager = SkillComboManager.new()
  Game.SkillClickUseManager = self.skillClickUseManager
  Game.SkillOptionManager = self.skillOptionManager
  Game.SkillDynamicManager = self.skillDynamicManager
  Game.SkillComboManager = self.skillComboManager
  FunctionSkill.Me()
  self.skillClickUseManager:Launch()
end

function SkillManager:Update(time, deltaTime)
  self.skillClickUseManager:Update(time, deltaTime)
end
