InteractMountNpc = class("InteractMountNpc", InteractNpc)
local LayerChangeReasonInteractNpc = LayerChangeReason.InteractNpc
local PUIVisibleReasonInteractNpc = PUIVisibleReason.InteractNpc

function InteractMountNpc.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractMountNpc, false, args)
end

function InteractMountNpc:DoConstruct(asArray, data)
  InteractMountNpc.super:DoConstruct(asArray, data)
end

function InteractMountNpc:ctor()
  InteractMountNpc.super.ctor(self)
end

function InteractMountNpc:Update(time, deltaTime)
  return InteractMountNpc.super:Update(time, deltaTime)
end

function InteractMountNpc:RequestGetOn(cpid, charid)
  if self.getOnState == self.GetOnState.Wait then
    self.waitCpMap[cpid] = charid
    self:GetOn(cpid, charid)
  end
end

function InteractMountNpc:RequestGetOff(charid)
  if self.getOnState == self.GetOnState.Wait then
    for k, v in pairs(self.waitCpMap) do
      if v == charid then
        self.waitCpMap[k] = nil
        return self:GetOff(charid)
      end
    end
  end
end

function InteractMountNpc:GetOn(cpid, charid)
  if self.cpMap[cpid] == charid then
    return
  end
  local npc = self:GetNpc()
  if npc == nil then
    return
  end
  local cpTransform = self:GetCP(npc, cpid)
  if cpTransform == nil then
    return
  end
  local creature = self:GetCreature(charid)
  if creature == nil then
    return
  end
  self.cpCount = self.cpCount + 1
  self.cpMap[cpid] = charid
  creature:SetParent(cpTransform)
  creature:Logic_SetAngleY(0)
  local assetRole = creature.assetRole
  assetRole:SetShadowEnable(false)
  assetRole:SetMountDisplay(false)
  assetRole:SetWingDisplay(false)
  assetRole:SetTailDisplay(false)
  creature:SetPeakEffectVisible(false, LayerChangeReasonInteractNpc)
  local FunctionPlayerUI = FunctionPlayerUI.Me()
  FunctionPlayerUI:MaskBloodBar(creature, PUIVisibleReasonInteractNpc)
  FunctionPlayerUI:MaskNameHonorFactionType(creature, PUIVisibleReasonInteractNpc)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(false, LayerChangeReasonInteractNpc)
  end
  local actionID = self.staticData.MountInfo[cpid]
  if actionID ~= nil then
    local actionInfo = Table_ActionAnime[actionID]
    if actionInfo == nil then
      return
    end
    self:PlayOnAction(creature, actionInfo.Name)
  end
end

function InteractMountNpc:GetOff(charid)
  for k, v in pairs(self.cpMap) do
    if v == charid then
      self.cpMap[k] = nil
      self.cpCount = self.cpCount - 1
      break
    end
  end
  local creature = self:GetCreature(charid)
  if creature == nil then
    return false
  end
  creature:SetParent(nil, true)
  creature:Logic_NavMeshPlaceTo(creature:GetPosition())
  local assetRole = creature.assetRole
  assetRole:SetShadowEnable(true)
  assetRole:SetMountDisplay(true)
  assetRole:SetWingDisplay(true)
  assetRole:SetTailDisplay(true)
  creature:SetPeakEffectVisible(true, LayerChangeReasonInteractNpc)
  local FunctionPlayerUI = FunctionPlayerUI.Me()
  FunctionPlayerUI:UnMaskBloodBar(creature, PUIVisibleReasonInteractNpc)
  FunctionPlayerUI:UnMaskNameHonorFactionType(creature, PUIVisibleReasonInteractNpc)
  local partner = creature.partner
  if partner ~= nil then
    partner:SetVisible(true, LayerChangeReasonInteractNpc)
  end
  creature:Logic_PlayAction_Idle()
  return true
end

function InteractMountNpc:TryNotifyGetOn()
  if self:IsFull() then
    MsgManager.ShowMsgByID(28000)
    return false
  end
  return true
end

function InteractMountNpc:TryNotifyGetOff()
  return true
end

function InteractMountNpc:CheckPosition(npc)
  return false
end

function InteractMountNpc:GetNpc()
  local tempTargets = {}
  tempTargets[1] = Game.PlotStoryManager:GetNpcRoleByCombinekey(self.id)
  return tempTargets[1]
end

function InteractMountNpc:GetCP(npc, cpid)
  return npc.assetRole:GetCP(cpid)
end

function InteractMountNpc:IsNotifyChange()
  return true
end
