PlayerSingView = class("PlayerSingView", SubView)
autoImport("PlayerSingViewCell")

function PlayerSingView:Init()
  self:AddViewEvents()
end

function PlayerSingView:AddViewEvents()
  EventManager.Me():AddEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillFreeCastBegin, self.HandleStartProcess, self)
  EventManager.Me():AddEventListener(SkillEvent.SkillFreeCastEnd, self.HandleStopProcess, self)
  EventManager.Me():AddEventListener(StealthGameEvent.Skill_CastStart, self.HandleHeartLockSkillStart, self)
  EventManager.Me():AddEventListener(StealthGameEvent.Skill_CastEnd, self.HandleStopProcess, self)
  EventManager.Me():AddEventListener(StealthGameEvent.Break_Skill, self.HandleStopProcess, self)
end

function PlayerSingView:OnExit()
  EventManager.Me():RemoveEventListener(SkillEvent.SkillCastBegin, self.HandleStartProcess, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillCastEnd, self.HandleStopProcess, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillFreeCastBegin, self.HandleStartProcess, self)
  EventManager.Me():RemoveEventListener(SkillEvent.SkillFreeCastEnd, self.HandleStopProcess, self)
  EventManager.Me():RemoveEventListener(StealthGameEvent.Skill_CastStart, self.HandleHeartLockSkillStart, self)
  EventManager.Me():RemoveEventListener(StealthGameEvent.Skill_CastEnd, self.HandleStopProcess, self)
  EventManager.Me():RemoveEventListener(StealthGameEvent.Break_Skill, self.HandleStopProcess, self)
end

function PlayerSingView:HandleStartProcess(note)
  local creature = note.data
  if not creature then
    return
  end
  local skill = creature.skill
  if not skill then
    return
  end
  if skill:CheckChant(creature) or skill:IsGuideCast() then
    return
  end
  local id = creature.data.id
  local castTime = skill:GetCastTime(creature) or 0
  if 0 < castTime then
    local singCell = self:getSingViewCell(id)
    if not singCell then
      local creature = SceneCreatureProxy.FindCreature(id)
      local sceneUI = creature and creature:GetSceneUI() or nil
      if sceneUI then
        singCell = sceneUI.roleTopUI:createOrGetTopSingUI()
      end
    end
    if singCell then
      if 0 < creature:GetChantSkillTime() then
        singCell:SetSyncData(creature)
      else
        singCell:SetData(creature)
      end
    end
  end
end

function PlayerSingView:getSingViewCell(id)
  local creature = SceneCreatureProxy.FindCreature(id)
  local sceneUI = creature and creature:GetSceneUI() or nil
  if sceneUI then
    return sceneUI.roleTopUI.topSingUI
  end
end

function PlayerSingView:HandleStopProcess(note)
  local creature = note.data
  if not creature then
    return
  end
  if creature.data then
    local id = creature.data.id
    local singCell = self:getSingViewCell(id)
    if singCell then
      singCell:delayProcess()
    end
  end
end

function PlayerSingView:HandleHeartLockSkillStart(note)
  if not note then
    return
  end
  local creature = note.creature
  if not creature then
    return
  end
  local skill = note.skill
  if not skill then
    return
  end
  local id = creature.data.id
  local castTime = skill:GetCastInfo(creature)
  if castTime and 0 < castTime then
    local singCell = self:getSingViewCell(id)
    if not singCell then
      local sceneUI = creature and creature:GetSceneUI() or nil
      if sceneUI then
        singCell = sceneUI.roleTopUI:createOrGetTopSingUI()
      end
    end
    if singCell then
      singCell:SetHeartLockData(creature, castTime)
    end
  end
end
