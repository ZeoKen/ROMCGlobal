InteractSnowballNpc = class("InteractSnowballNpc", InteractNpc)

function InteractSnowballNpc.Create(data, id)
  local args = InteractBase.GetArgs(data, id)
  return ReusableObject.Create(InteractSnowballNpc, false, args)
end

function InteractSnowballNpc:Update(time, deltaTime)
  if self.myselfCharid ~= nil then
    if time < self.nextUpdateTime then
      return self.isInTrigger
    end
    self.nextUpdateTime = time + 1
    local npc = self:GetNpc()
    self.isInTrigger = npc ~= nil and self:CheckPosition(npc)
    return self.isInTrigger
  end
  if Game.InteractNpcManager:IsMyselfOnNpc() then
    return false
  end
  return InteractSnowballNpc.super.Update(self, time, deltaTime)
end

function InteractSnowballNpc:RequestGetOn(cpid, charid)
  if charid == Game.Myself.data.id then
    self.myselfCharid = charid
  end
end

function InteractSnowballNpc:RequestGetOff(charid)
  if charid == self.myselfCharid then
    self.myselfCharid = nil
    local npc = self:GetNpc()
    local isInTrigger = npc ~= nil and self:CheckPosition(npc)
    GameFacade.Instance:sendNotification(InteractNpcEvent.MyselfTriggerChange, isInTrigger)
  end
end

function InteractSnowballNpc:TryNotifyGetOn()
  if self.myselfCharid ~= nil then
    ServiceInteractCmdProxy.Instance:CallCancelMountInterCmd(self.id)
  else
    ServiceInteractCmdProxy.Instance:CallConfirmMountInterCmd(self.id)
  end
  return true
end

function InteractSnowballNpc:TryNotifyGetOff()
  return false
end

function InteractSnowballNpc:IsNotifyChange()
  return true
end

function InteractSnowballNpc:ShouldChangeMyselfOnOff()
  return true
end

function InteractSnowballNpc:DoDeconstruct(asArray)
  self.myselfCharid = nil
  InteractSnowballNpc.super.DoDeconstruct(self, asArray)
end
