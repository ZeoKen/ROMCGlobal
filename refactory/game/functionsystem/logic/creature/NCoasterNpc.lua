NCoasterNpc = reusableClass("NCoasterNpc", NNpc)

function NCoasterNpc:ctor(aiClass)
  NCoasterNpc.super.ctor(self, aiClass)
  self.isCoasterNpc = true
end

function NCoasterNpc:GetCreatureType()
  return Creature_Type.Npc
end

function NCoasterNpc:Init(serverData, reinit)
  NCoasterNpc.super.Init(self, serverData, reinit)
  self.isCoasterNpc = true
  self.coasterMoveProvider = nil
  self.mountedPlayerID = nil
  self.isDirMoving = false
end

function NCoasterNpc:InitAssetRole()
  NCoasterNpc.super.InitAssetRole(self)
  if self.assetRole ~= nil then
    self.assetRole:SetColliderEnable(false)
  end
end

function NCoasterNpc:Client_CoasterMove(coasterMoveProvider, ignoreNavMesh, customMoveActionName)
  self.coasterMoveProvider = coasterMoveProvider
  self.ai:PushCommand(FactoryAICMD.GetCoasterMoveCmd(coasterMoveProvider, ignoreNavMesh, customMoveActionName), self)
end

function NCoasterNpc:Client_CoasterMoveEnd(customIdleAction)
  self.ai:PushCommand(FactoryAICMD.GetCoasterMoveEndCmd(customIdleAction), self)
end

function NCoasterNpc:GetCoasterMoveProvider()
  return self.coasterMoveProvider
end

function NCoasterNpc:DoDeconstruct(asArray)
  if self.mountedPlayerID ~= nil then
    local player = NSceneUserProxy.Instance:Find(self.mountedPlayerID)
    if player ~= nil then
      player:SetParent(nil)
      player:ClearBeHolded()
      player.remoteCoasterNpc = nil
    end
    self.mountedPlayerID = nil
  end
  self.coasterMoveProvider = nil
  self.isCoasterNpc = nil
  NCoasterNpc.super.DoDeconstruct(self, asArray)
end
