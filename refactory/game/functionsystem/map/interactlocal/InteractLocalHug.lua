InteractLocalHug = class("InteractLocalHug", InteractLocalSimple)
local tickMgr = TimeTickManager.Me()

function InteractLocalHug.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractLocalHug, false, args)
end

function InteractLocalHug:DoConstruct(asArray, data)
  InteractLocalHug.super.DoConstruct(self, asArray, data)
  self.interactState = false
end

function InteractLocalHug:DoDeconstruct(asArray)
  InteractLocalHug.super.DoDeconstruct(self, asArray)
  self.interactState = nil
  self.actionInstanceId = nil
  self.placeSlot = nil
  self.lastPos = nil
end

function InteractLocalHug:CheckPosition(npc)
  if self:IsHug() then
    return true
  end
  return InteractLocalHug.super.CheckPosition(self, npc)
end

function InteractLocalHug:IsHug()
  return self.interactState == true
end

function InteractLocalHug:RequestGetOffAll()
  self:DoPutDown()
end

function InteractLocalHug:StartInteract()
  if not self.interactState then
    self:DoHug()
    tickMgr:CreateOnceDelayTick(1000, self.OnInteractPlotEnd, self)
  else
    self:DoPutDown()
    if self.groupAction and self.groupAction.off_act then
    else
      tickMgr:CreateOnceDelayTick(1000, self.OnInteractPlotEnd, self)
    end
  end
end

function InteractLocalHug:OnInteractPlotEnd()
  self.actionInstanceId = nil
  InteractLocalManager.Me():EndInteract()
end

function InteractLocalHug:GetPos()
  local npc = self:GetNpc()
  if npc then
    return npc:GetPosition()
  end
end

function InteractLocalHug:SetPos(p)
  local npc = self:GetNpc()
  if npc then
    npc:Client_PlaceTo(p, false)
  end
end

function InteractLocalHug:SetDir(d)
  local npc = self:GetNpc()
  if npc then
    npc:Client_SetDirCmd(AI_CMD_SetAngleY.Mode.SetAngleY, d, true)
  end
end

function InteractLocalHug:SetVisible(v)
  local npc = self:GetNpc()
  if npc then
    npc:SetVisible(v, LayerChangeReason.HidingSkill)
  end
end

function InteractLocalHug:GetIdInGroup()
  return self.id % 100
end

function InteractLocalHug:DoHug()
  if self:IsHug() then
    return
  end
  InteractLocalManager.Me():OnInteractLocalHugBreakOther()
  Game.Myself:Client_AddHugRole(self.staticData.id, nil, nil, nil, self.groupConfig.hugScale or 0.5)
  self:SetVisible(false)
  self.placeSlot = nil
  self.interactState = true
  if not self.lastPos then
    self.lastPos = self:GetPos()
  end
end

function InteractLocalHug:DoPutDown()
  if not self:IsHug() then
    return
  end
  Game.Myself:Client_RemoveHugRole()
  local myPos = Game.Myself:GetPosition()
  local slot, pos, dir = self.interactGroup:TryMatchBestSlot(myPos)
  if 0 < slot then
    self.placeSlot = slot
    if dir then
      self:SetDir(dir)
    end
    self:SetPos(pos)
  else
    self.placeSlot = nil
    if self.interactGroup:CheckSafeInBoundPos(myPos) then
      self:SetPos(myPos)
    else
      local initialPos = self.interactGroup:GetInitialPos()
      self:SetPos(initialPos)
    end
  end
  self:SetVisible(true)
  self.interactState = false
end

function InteractLocalHug:GetPlaceSlot()
  return self.placeSlot
end

function InteractLocalHug:GetInteractPrompt()
  if self:IsHug() then
    return ZhString.InteractLocal_HugOff
  else
    return ZhString.InteractLocal_HugOn
  end
end

InteractLocalCollectHug = class("InteractLocalCollectHug", InteractLocalHug)
InteractLocalCollectHug.noInteractGroup = true

function InteractLocalCollectHug:DoHug()
  if self:IsHug() then
    return
  end
  InteractLocalManager.Me():OnInteractLocalHugBreakOther()
  self.interactState = true
  local npc = self:GetNpc()
  if npc then
    ServiceQuestProxy.Instance:CallVisitNpcUserCmd(npc.data.id)
  end
end

function InteractLocalCollectHug:DoPutDown()
  if not self:IsHug() then
    return
  end
  ServiceActivityCmdProxy.Instance:CallPutGoodsCmd(self.serverHoldPet, self.serverHoldPetBuff)
  self.serverHoldPet = nil
  self.interactState = false
end

function InteractLocalCollectHug:SetServerHoldPet(buffid, npcid)
  self.serverHoldPetBuff = buffid
  self.serverHoldPet = npcid
end

function InteractLocalCollectHug:GetInteractPrompt()
  if self:IsHug() then
    return ZhString.InteractLocal_HugOff
  else
    return ZhString.InteractLocal_CollectHugOn
  end
end
