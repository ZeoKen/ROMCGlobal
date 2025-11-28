InteractLocalVisit = class("InteractLocalVisit", InteractLocalSimple)
InteractLocalVisit.noInteractGroup = true
local tickMgr = TimeTickManager.Me()

function InteractLocalVisit.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractLocalVisit, false, args)
end

function InteractLocalVisit:DoConstruct(asArray, data)
  InteractLocalVisit.super.DoConstruct(self, asArray, data)
  self.interactState = false
  local inRaid = Game.MapManager:IsRaidMode()
  if not inRaid then
    self.isEnable = true
  else
    self.isEnable = false
  end
end

function InteractLocalVisit:DoDeconstruct(asArray)
  InteractLocalVisit.super.DoDeconstruct(self, asArray)
  self.isEnable = nil
  self.interactState = nil
  tickMgr:ClearTick(self)
end

function InteractLocalVisit:SetEnable(enable)
  self.isEnable = enable
end

function InteractLocalVisit:UpdateEnable()
  if FunctionBatteryCannon.Me():GetSkillConfig(self.staticData.id) then
    self.isEnable = true
  end
end

function InteractLocalVisit:Update(time, deltaTime)
  if not self.isEnable then
    self:UpdateEnable()
    if not self.isEnable then
      return false
    end
  end
  return InteractLocalVisit.super.Update(self, time, deltaTime)
end

function InteractLocalVisit:CheckPosition(npc)
  if self:IsInVisit() then
    return true
  end
  return InteractLocalVisit.super.CheckPosition(self, npc)
end

function InteractLocalVisit:IsInVisit()
  return self.interactState == true
end

function InteractLocalVisit:RequestGetOffAll()
  self:DoEndVisit()
end

function InteractLocalVisit:StartInteract()
  self:DoVisit()
end

function InteractLocalVisit:OnVisitEnd()
  InteractLocalManager.Me():EndInteract()
end

function InteractLocalVisit:SetVisible(v)
  local npc = self:GetNpc()
  if npc then
    npc:SetVisible(v, LayerChangeReason.HidingSkill)
  end
end

function InteractLocalVisit:DoVisit()
  if self:IsInVisit() then
    return
  end
  local npc = self:GetNpc()
  if npc then
    local npcFunction = npc.data.staticData.NpcFunction
    npcFunction = npcFunction and npcFunction[1] and npcFunction[1].type
    if npcFunction then
      local staticData = Table_NpcFunction[npcFunction]
      if staticData and FunctionNpcFunc.Me():CheckFuncState(staticData.NameEn, npc, staticData, nil) == NpcFuncState.Active then
        self.interactState = true
        ServiceInteractCmdProxy.Instance:CallConfirmMountInterCmd(self.id)
        FunctionNpcFunc.Me():DoNpcFunc(staticData, npc, nil, {
          {
            func = function()
              tickMgr:CreateOnceDelayTick(500, self.DoEndVisit, self)
            end,
            nil,
            npc = npc
          }
        })
      end
    end
  end
end

function InteractLocalVisit:DoEndVisit()
  if not self:IsInVisit() then
    return
  end
  ServiceInteractCmdProxy.Instance:CallCancelMountInterCmd(self.id)
  FunctionBatteryCannon.Me():Shutdown()
  self.interactState = false
  self:OnVisitEnd()
end

function InteractLocalVisit:GetInteractPrompt()
  return ZhString.InteractLocal_Simple
end
