autoImport("SimplePlayer")
autoImport("NCreature")
autoImport("NCreatureWithPropUserdata")
autoImport("NNpc")
autoImport("NStageNpc")
autoImport("NPlayer")
autoImport("NMyselfPlayer")
autoImport("NPet")
autoImport("NPartner")
autoImport("NHandNpc")
autoImport("NExpressNpc")
autoImport("NFollowNpc")
autoImport("LogicManager_Creature_Userdata")
autoImport("LogicManager_Npc_Userdata")
autoImport("LogicManager_Player_Userdata")
autoImport("LogicManager_Myself_Userdata")
autoImport("LogicManager_Creature_Props")
autoImport("LogicManager_Player_Props")
autoImport("LogicManager_Myself_Props")
autoImport("LogicManager_Npc_Props")
autoImport("LogicManager_RoleDress")
autoImport("LogicManager_HandInHand")
autoImport("LogicManager_Hatred")
autoImport("LogicManager_Pet_Props")
autoImport("LogicManager_MapCell")
autoImport("LogicManager_NpcTriggerAnim")
LogicManager_Creature = class("LogicManager_Creature")

function LogicManager_Creature:ctor()
  self.npcUserDataManager = LogicManager_Npc_Userdata.new()
  self.playerUserDataManager = LogicManager_Player_Userdata.new()
  self.myselfUserDataManager = LogicManager_Myself_Userdata.new()
  self.npcPropsManager = LogicManager_Npc_Props.new()
  self.petPropsManager = LogicManager_Pet_Props.new()
  self.playerPropsManager = LogicManager_Player_Props.new()
  self.myselfPropsManager = LogicManager_Myself_Props.new()
  self.roleDressManager = LogicManager_RoleDress.new()
  self.handInHandManager = LogicManager_HandInHand.new()
  self.hatredManager = LogicManager_Hatred.new()
  self.mapCellManager = LogicManager_MapCell.new()
  self.npcTriggerManager = LogicManager_NpcTriggerAnim.new()
  Game.LogicManager_Npc_Userdata = self.npcUserDataManager
  Game.LogicManager_Player_Userdata = self.playerUserDataManager
  Game.LogicManager_Player_Props = self.playerPropsManager
  Game.LogicManager_Myself_Props = self.myselfPropsManager
  Game.LogicManager_Npc_Props = self.npcPropsManager
  Game.LogicManager_Pet_Props = self.petPropsManager
  Game.LogicManager_Myself_Userdata = self.myselfUserDataManager
  Game.LogicManager_RoleDress = self.roleDressManager
  Game.LogicManager_HandInHand = self.handInHandManager
  Game.LogicManager_Hatred = self.hatredManager
  Game.LogicManager_NpcTriggerAnim = self.npcTriggerManager
  self:SetSceneNpcProxy(NSceneNpcProxy.Instance)
  self:SetSceneUserProxy(NSceneUserProxy.Instance)
  self:SetScenePetProxy(NScenePetProxy.Instance)
  self.updateNumber = 0
  Game.LogicManager_MapCell = self.mapCellManager
end

function LogicManager_Creature:SetSceneNpcProxy(sceneNpcs)
  if sceneNpcs then
    self.sceneNpcs = sceneNpcs
  end
end

function LogicManager_Creature:SetSceneUserProxy(scenePlayers)
  if scenePlayers then
    self.scenePlayers = scenePlayers
  end
end

function LogicManager_Creature:SetScenePetProxy(scenePets)
  if scenePets then
    self.scenePets = scenePets
  end
end

function LogicManager_Creature:Update(time, deltaTime)
  self.updateNumber = self.updateNumber + 1
  self:UpdateNpc(time, deltaTime)
  self:UpdatePets(time, deltaTime)
  self:UpdatePlayer(time, deltaTime)
  self:UpdateMyself(time, deltaTime)
  self.roleDressManager:Update(time, deltaTime)
  self.hatredManager:Update(time, deltaTime)
  self.npcTriggerManager:Update(time, deltaTime)
end

function LogicManager_Creature:LateUpdate(time, deltaTime)
  self.handInHandManager:LateUpdate(time, deltaTime)
  self.mapCellManager:LateUpdate(time, deltaTime)
end

local Pet_CheckDirtyDatas = LogicManager_Pet_Props.CheckDirtyDatas
local NU_CheckDirtyDatas = LogicManager_Npc_Userdata.CheckDirtyDatas
local NP_CheckDirtyDatas = LogicManager_Npc_Props.CheckDirtyDatas
local PP_CheckDirtyDatas = LogicManager_Player_Props.CheckDirtyDatas
local PU_CheckDirtyDatas = LogicManager_Player_Userdata.CheckDirtyDatas
local Player_Update = NPlayer.Update
local NNpc_StaticUpdate = NNpc.StaticUpdate
local NExpressNpc_StaticUpdate = NExpressNpc.StaticUpdate
local NeedUpdators = {
  [CreatureUpdateFrequency.Every1Frame] = function(updateNumber)
    return true, false
  end,
  [CreatureUpdateFrequency.Every2Frame1] = function(updateNumber)
    if updateNumber % 2 == 0 then
      return true, false
    else
      return false, true
    end
  end,
  [CreatureUpdateFrequency.Every2Frame2] = function(updateNumber)
    if updateNumber % 2 == 1 then
      return true, false
    else
      return false, true
    end
  end,
  [CreatureUpdateFrequency.Every3Frame1] = function(updateNumber)
    if updateNumber % 4 == 0 then
      return true, false
    else
      return false, false
    end
  end,
  [CreatureUpdateFrequency.Every3Frame2] = function(updateNumber)
    if updateNumber % 4 == 1 then
      return true, false
    else
      return false, false
    end
  end,
  [CreatureUpdateFrequency.Every3Frame3] = function(updateNumber)
    if updateNumber % 4 == 2 then
      return true, false
    else
      return false, false
    end
  end,
  [CreatureUpdateFrequency.Every3Frame4] = function(updateNumber)
    if updateNumber % 4 == 3 then
      return true, false
    else
      return false, false
    end
  end
}

function LogicManager_Creature:UpdateNpc(time, deltaTime)
  local userDataManager = self.npcUserDataManager
  local npcPropsManager = self.npcPropsManager
  local updateNumber = self.updateNumber
  local needUpdate1, needUpdate2
  for _, v in pairs(self.sceneNpcs.userMap) do
    if v and v.data then
      v.updateDeltaTime = v.updateDeltaTime + deltaTime
      needUpdate1, needUpdate2 = NeedUpdators[v.updateFrequency](updateNumber)
      if needUpdate1 then
        NU_CheckDirtyDatas(userDataManager, v)
        NP_CheckDirtyDatas(npcPropsManager, v)
        v:Update(time, v:PopDeltaTime())
      elseif needUpdate2 then
        v:ForceUpdateTransform(time, v:PopDeltaTime())
      end
    end
  end
  for _, v in pairs(self.sceneNpcs.clientUserMap) do
    if v and v.data then
      v.updateDeltaTime = v.updateDeltaTime + deltaTime
      needUpdate1, needUpdate2 = NeedUpdators[v.updateFrequency](updateNumber)
      if needUpdate1 then
        NU_CheckDirtyDatas(userDataManager, v)
        NP_CheckDirtyDatas(npcPropsManager, v)
        v:Update(time, v:PopDeltaTime())
      elseif needUpdate2 then
        v:ForceUpdateTransform(time, v:PopDeltaTime())
      end
    end
  end
  NNpc_StaticUpdate(time, deltaTime)
  NExpressNpc_StaticUpdate(time, deltaTime)
end

function LogicManager_Creature:UpdatePets(time, deltaTime)
  local userDataManager = self.npcUserDataManager
  local petPropsManager = self.petPropsManager
  local updateNumber = self.updateNumber
  local needUpdate1, needUpdate2
  for _, v in pairs(self.scenePets.userMap) do
    v.updateDeltaTime = v.updateDeltaTime + deltaTime
    needUpdate1, needUpdate2 = NeedUpdators[v.updateFrequency](updateNumber)
    if needUpdate1 then
      NU_CheckDirtyDatas(userDataManager, v)
      Pet_CheckDirtyDatas(petPropsManager, v)
      v:Update(time, v:PopDeltaTime())
    elseif needUpdate2 then
      v:ForceUpdateTransform(time, v:PopDeltaTime())
    end
  end
end

function LogicManager_Creature:UpdatePlayer(time, deltaTime)
  local userDataManager = self.playerUserDataManager
  local playerPropsManager = self.playerPropsManager
  local updateNumber = self.updateNumber
  local needUpdate1, needUpdate2
  for _, v in pairs(self.scenePlayers.userMap) do
    v.updateDeltaTime = v.updateDeltaTime + deltaTime
    needUpdate1, needUpdate2 = NeedUpdators[v.updateFrequency](updateNumber)
    if needUpdate1 then
      if not v:CanForbidLogic() then
        PU_CheckDirtyDatas(userDataManager, v)
      end
      PP_CheckDirtyDatas(playerPropsManager, v)
      Player_Update(v, time, v:PopDeltaTime())
    elseif needUpdate2 then
      v:ForceUpdateTransform(time, v:PopDeltaTime())
    end
  end
  NPlayer.StaticUpdate(time, deltaTime)
end

function LogicManager_Creature:UpdateMyself(time, deltaTime)
  local userDataManager = self.myselfUserDataManager
  local myselfPropsManager = self.myselfPropsManager
  local myself = Game.Myself
  if myself then
    userDataManager:CheckDirtyDatas(myself)
    myselfPropsManager:CheckDirtyDatas(myself)
    myself:Update(time, deltaTime)
  end
end
