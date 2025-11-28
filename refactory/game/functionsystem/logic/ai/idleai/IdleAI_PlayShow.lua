IdleAI_PlayShow = class("IdleAI_PlayShow")
local PlayShowIntervalRange = {175, 185}

function IdleAI_PlayShow:ctor()
  self.playShowStartTime = 0
  self.priority = 1
end

function IdleAI_PlayShow:Clear(idleElapsed, time, deltaTime, creature)
end

function IdleAI_PlayShow:Prepare(idleElapsed, time, deltaTime, creature)
  if not creature:IsDressed() then
    return false
  end
  if creature:IsPlayShowForbidden() then
    return false
  end
  if creature.data:GetDownID() ~= 0 then
    return false
  end
  if nil ~= creature.data and creature.data:NoPlayShow() then
    return false
  end
  local assetRole = creature.assetRole
  if assetRole:MountDisplaying() then
    return false
  end
  local playingIdle = assetRole:IsPlayingAction(Asset_Role.ActionName.Idle)
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

function IdleAI_PlayShow:Start(idleElapsed, time, deltaTime, creature)
  creature:Client_PlayAction(creature:GetPlayShowAction())
end

function IdleAI_PlayShow:End(idleElapsed, time, deltaTime, creature)
  self.playShowStartTime = 0
end

function IdleAI_PlayShow:Update(idleElapsed, time, deltaTime, creature)
  return false
end
