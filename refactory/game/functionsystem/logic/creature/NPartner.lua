NPartner = reusableClass("NPartner", NCreature)
NPartner.PoolSize = 5
local State = {Sleep = 1, Wake = 2}
NPartnerMap = {}
local IDFixError = 1000000
local PartnerID = 0
local AllocatePartnerID = function()
  PartnerID = (PartnerID + 1) % IDFixError
  return PartnerID
end
local MyMaster = "MyMaster"

function NPartner:ctor(aiClass)
  NPartner.super.ctor(self, AI_CreatureFlyFollow)
  self.skill = ServerSkill.new()
  self.sceneui = nil
end

function NPartner:GetCreatureType()
  return Creature_Type.Pet
end

function NPartner:InitAssetRole()
  NPartner.super.InitAssetRole(self)
  local assetRole = self.assetRole
  assetRole:SetGUID(0)
  assetRole:SetName("Partner")
  assetRole:SetClickPriority(0)
  assetRole:SetInvisible(false)
  assetRole:SetShadowEnable(false)
  assetRole:SetColliderEnable(false)
  assetRole:SetWeaponDisplay(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetRenderEnable(true)
  assetRole:SetActionSpeed(1)
end

function NPartner:InitLogicTransform(serverX, serverY, serverZ, dir, scale, moveSpeed, rotateSpeed, scaleSpeed)
  self.logicTransform:SetMoveSpeed(CreatureData:ReturnMoveSpeedWithFactor(moveSpeed))
  self.logicTransform:SetRotateSpeed(CreatureData:ReturnRotateSpeedWithFactor(rotateSpeed))
  self.logicTransform:SetScaleSpeed(CreatureData:ReturnScaleSpeedWithFactor(scaleSpeed))
  if scale then
    self:Server_SetScaleCmd(scale, true)
  end
  if dir then
    self:Server_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, dir)
  end
  if self:IsFollowTypeOn() then
    self:Logic_PlaceXYZTo(serverX / 1000, serverY / 1000, serverZ / 1000)
  else
    self:Logic_NavMeshPlaceXYZTo(serverX / 1000, serverY / 1000, serverZ / 1000)
  end
end

function NPartner:Init(npcID)
  self:InitAssetRole()
  self:InitLogicTransform(0, 0, 0, nil, nil)
  self:UpdateScale()
  self:InitAI()
end

function NPartner:SetDressEnable(v)
  if v ~= self.dressEnable then
    self.dressEnable = v
    self:ReDress()
    if self.partner then
      self.partner:SetDressEnable(v)
    end
  end
end

function NPartner:IsDressEnable()
  return self.dressEnable
end

function NPartner:GetDressParts()
  if self.npcConfig and self.dressEnable then
    return NSceneNpcProxy.Instance:GetOrCreatePartsFromStaticData(self.npcConfig), true
  end
  return NSceneNpcProxy.Instance:GetNpcEmptyParts(), true
end

function NPartner:ResetID(npcID)
  if self.npcID ~= npcID then
    self.npcID = npcID
    self.npcConfig = Table_Monster[npcID] or Table_Npc[npcID]
    self:ReDress(self:GetDressParts())
    self.data:ResetID(npcID)
    self:UpdateScale()
  end
end

function NPartner:UpdateScale()
  local npcID = self.npcID
  local scale = 1
  local npcData = Table_Npc[npcID]
  if npcData then
    scale = npcData.Scale or 1
  end
  self:Server_SetScaleCmd(scale, true)
end

local CreatureFollowTarget = "CreatureFollowTarget"

function NPartner:SetMaster(master)
  self:SetWeakData(CreatureFollowTarget, master)
  local p = master:GetPosition()
  if p then
    self:SetPos(master)
  end
  self.data.ownerID = master.data.id
  self:SetDressEnable(master:IsDressEnable())
  local parterid = self.npcConfig.PartnerID
  if parterid ~= nil then
    self:SetPartner(parterid)
  end
  if self.sceneui then
    self.sceneui:CopyMaskFromOther(master.sceneui)
  end
end

function NPartner:SetPos(master, serverPos)
  if self:IsFollowTypeOn() then
    self:FollowOn(master)
    return
  end
  if serverPos then
    self:Client_PlaceXYZTo(serverPos.x, serverPos.y, serverPos.z, 1000, true)
  else
    local p = master:GetPosition()
    if p then
      if self:IsFollowTypeWalkFollow() then
        local pos = p - LuaQuaternion.Euler(0, 0, 0) * LuaVector3.back * self.data:GetInnerRange()
        self:Logic_NavMeshPlaceTo(pos)
        self:LookAt(p)
        return
      end
      self:Client_PlaceTo(p, true)
    end
  end
end

function NPartner:Logic_PlayAction_Move(customMoveActionName)
  local name = customMoveActionName or self:GetMoveAction()
  local moveActionScale = 1
  local staticData = self.npcConfig
  if nil ~= staticData and nil ~= staticData.MoveSpdRate then
    moveActionScale = staticData.MoveSpdRate
  end
  local actionSpeed = moveActionScale * 1
  self.assetRole:PlayAction_Simple(name, nil, actionSpeed)
  return true
end

function NPartner:SetState(state)
  self.state = state
end

function NPartner:GetIdleAction()
  if self.state == State.Wake then
    return Asset_Role.ActionName.AttackIdle
  end
  return NPartner.super.GetIdleAction(self)
end

function NPartner:InitAI()
  self:SetPauseAI(false)
  if self:IsFollowTypeOn() then
    self:Logic_LockRotation(true)
    return
  end
  if self:IsFollowTypeWalkFollow() then
    self.ai:WalkFollow()
    return
  end
  self.ai:FlyFollow()
end

function NPartner:SetPauseAI(isTrue)
  if isTrue then
    if not self.ai.idleAIManager:IsPausing() then
      self.ai.idleAIManager:Pause()
    end
  elseif self.ai.idleAIManager:IsPausing() then
    self.ai.idleAIManager:Resume()
  end
end

function NPartner:IsFollowTypeOn()
  return self.data:GetFollowType() == PartnerData.FollowType.On
end

function NPartner:IsFollowTypeWalkFollow()
  return self.data:GetFollowType() == PartnerData.FollowType.WalkFollow
end

function NPartner:OnMasterPartCreated(master, part)
  if part == Asset_Role.PartIndex.Body then
    self:FollowOn(master)
  end
end

function NPartner:FollowOn(master)
  if not self:IsFollowTypeOn() then
    return
  end
  local followEP = self.data:GetFollowEP()
  local parent = master.assetRole:GetEPOrRoot(followEP)
  local assetRole = self.assetRole
  assetRole:SetParent(parent)
  assetRole:SetPosition(LuaGeometry.Const_V3_zero)
  assetRole:SetEulerAngles(LuaGeometry.Const_V3_zero)
end

function NPartner:IsDead()
  return false
end

function NPartner:DoConstruct(asArray, npcID)
  local data = PartnerData.CreateAsTable(npcID)
  NPartner.super.DoConstruct(self, asArray, data)
  data.id = AllocatePartnerID()
  NPartnerMap[data.id] = self
  self.state = nil
  self.dressEnable = false
  self.npcConfig = Table_Monster[npcID] or Table_Npc[npcID]
  self:CreateWeakData()
  self.npcID = npcID
  self:Init(npcID)
  self.sceneui = Creature_SceneUI.CreateAsTable(self)
end

function NPartner:DoDeconstruct(asArray)
  NPartnerMap[self.data.id] = nil
  NPartner.super.DoDeconstruct(self, asArray)
  if self.sceneui then
    self.sceneui:Destroy()
    self.sceneui = nil
  end
  self.assetRole:Destroy()
  self.assetRole = nil
  self.state = nil
  self.dressEnable = nil
  self.npcConfig = nil
  self.npcID = nil
end

function NPartner:IsMyPet()
  return self.data.ownerID == Game.Myself.data.id
end

function NPartner:GetSceneUI()
  return self.sceneui
end

function NPartner:GetOwner()
  return self.data.ownerID
end
