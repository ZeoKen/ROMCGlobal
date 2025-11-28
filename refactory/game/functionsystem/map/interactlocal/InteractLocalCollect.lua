InteractLocalCollect = class("InteractLocalCollect", InteractLocalSimple)
InteractLocalCollect.noInteractGroup = true
local tickMgr = TimeTickManager.Me()

function InteractLocalCollect.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractLocalCollect, false, args)
end

function InteractLocalCollect:DoConstruct(asArray, data)
  InteractLocalCollect.super.DoConstruct(self, asArray, data)
  self.interactState = false
end

function InteractLocalCollect:DoDeconstruct(asArray)
  InteractLocalCollect.super.DoDeconstruct(self, asArray)
  self.interactState = nil
end

function InteractLocalCollect:Update(time, deltaTime)
  return InteractLocalCollect.super.Update(self, time, deltaTime)
end

function InteractLocalCollect:CheckPosition(npc)
  if self:IsInVisit() then
    return true
  end
  return InteractLocalCollect.super.CheckPosition(self, npc)
end

function InteractLocalCollect:IsInVisit()
  return self.interactState == true
end

function InteractLocalCollect:RequestGetOffAll()
  self:DoEndVisit()
end

function InteractLocalCollect:StartInteract()
  self:DoVisit()
end

function InteractLocalCollect:OnVisitEnd()
  InteractLocalManager.Me():EndInteract()
end

function InteractLocalCollect:DoVisit()
  if self:IsInVisit() then
    return
  end
  local npc = self:GetNpc()
  if npc then
    self.interactState = true
    ServiceQuestProxy.Instance:CallVisitNpcUserCmd(npc.data.id)
  end
end

function InteractLocalCollect:DoEndVisit()
  if not self:IsInVisit() then
    return
  end
  self.interactState = false
  self:OnVisitEnd()
end

function InteractLocalCollect:GetInteractPrompt()
  return self.staticData and self.staticData.Param.prompt
end

function InteractLocalCollect:GetInteractIcon()
  return self.staticData and self.staticData.Param.icon
end
