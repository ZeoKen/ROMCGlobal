IdleAI_PlayShowCombo = class("IdleAI_PlayShowCombo")
local PlayShowIntervalRange = {13, 20}

function IdleAI_PlayShowCombo:ctor(comboList)
  self.playShowStartTime = 0
  self.priority = 1
  self.comboList = {}
end

function IdleAI_PlayShowCombo:Clear(idleElapsed, time, deltaTime, creature)
  TableUtility.ArrayCLear(self.comboList)
end

function IdleAI_PlayShowCombo:Prepare(idleElapsed, time, deltaTime, creature)
  if not creature:IsDressed() then
    return false
  end
  if nil ~= creature.data and creature.data:NoPlayShow() then
    return false
  end
  local playingIdle = creature.assetRole:IsPlayingAction(Asset_Role.ActionName.Idle)
  if 0 < self.playShowStartTime then
    if not playingIdle then
      self.playShowStartTime = 0
      return false
    end
    return time >= self.playShowStartTime
  end
  if playingIdle then
    self.playShowStartTime = time + RandomUtil.Range(PlayShowIntervalRange[1], PlayShowIntervalRange[2])
  end
  return false
end

function IdleAI_PlayShowCombo:Start(idleElapsed, time, deltaTime, creature)
  creature:Client_PlayAction(creature:GetPlayShowAction())
end

function IdleAI_PlayShowCombo:End(idleElapsed, time, deltaTime, creature)
  self.playShowStartTime = 0
end

function IdleAI_PlayShowCombo:Update(idleElapsed, time, deltaTime, creature)
  return false
end
