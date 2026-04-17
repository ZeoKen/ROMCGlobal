NFollowOwnerNpc = reusableClass("NFollowOwnerNpc", NNpc)

function NFollowOwnerNpc:ctor()
  NFollowOwnerNpc.super.ctor(self, AI_CreatureFlyFollow)
end

function NFollowOwnerNpc:GetCreatureType()
  return Creature_Type.Npc
end

function NFollowOwnerNpc:Init(serverData, reinit)
  NFollowOwnerNpc.super.Init(self, serverData, reinit)
  self:InitAI()
end

function NFollowOwnerNpc:InitAssetRole()
  NFollowOwnerNpc.super.InitAssetRole(self)
  self.assetRole:SetColliderEnable(false)
end

function NFollowOwnerNpc:InitAI()
  self:SetPauseAI(false)
  self.ai:FlyFollow()
end

function NFollowOwnerNpc:SetPauseAI(isTrue)
  if isTrue then
    if not self.ai.idleAIManager:IsPausing() then
      self.ai.idleAIManager:Pause()
    end
  elseif self.ai.idleAIManager:IsPausing() then
    self.ai.idleAIManager:Resume()
  end
end

function NFollowOwnerNpc:DoConstruct(asArray, serverData)
  NFollowOwnerNpc.super.DoConstruct(self, asArray, serverData)
end

function NFollowOwnerNpc:SetMaster(masterCreature)
  self.masterCreature = masterCreature
  if self.masterCreature ~= nil then
    self:SetWeakData("CreatureFollowTarget", self.masterCreature)
  else
    self:SetPauseAI(true)
  end
  if self.assetRole ~= nil and self.masterCreature ~= nil then
    local targetDis = 1
    if self.data and self.data.staticData then
      local followData = Table_NPCFollow[self.data.staticData.id]
      if followData and followData.FollowDistance_Start then
        targetDis = followData.FollowDistance_Start
      end
    end
    local pos = self.masterCreature:GetPosition()
    local dir = self.masterCreature:GetAngleY()
    local rad = math.rad(dir)
    local offsetX = targetDis * math.sin(rad)
    local offsetZ = targetDis * math.cos(rad)
    pos[1] = pos[1] + offsetX
    pos[3] = pos[3] + offsetZ
    self.assetRole:SetPosition(pos)
  end
end
