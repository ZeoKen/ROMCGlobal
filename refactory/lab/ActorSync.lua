local Assert_ = function(condition, msg)
  return assert(condition, msg)
end
ActorSync = class("ActorSync", ReusableObject)
if not ActorSync.ActorSync_Inited then
  ActorSync.PoolSize = 500
  ActorSync.ActorSync_Inited = true
end
local Status_Idle = 1
local Status_Bussy = 2

function ActorSync:ctor()
  ActorSync.super.ctor(self)
end

function ActorSync:SetMethodMap_(methodMap)
  self.methodMap = methodMap
end

function ActorSync:DoConstruct(asArray, addr)
  self.addr = addr
  self.status = Status_Idle
end

function ActorSync:DoDeconstruct(asArray)
end

function ActorSync:GetAddress()
  return self.addr
end

function ActorSync:SendMail(mail)
  Assert_(Status_Idle == self.status, "ActorSync do not support reentry")
  self.status = Status_Bussy
  local response, err = DoLogic_(mail:GetMethod(), mail:GetContent(), mail:GetSendTimeStamp())
  return false, response, err
end

function ActorSync:Get_(addr, method, content)
  local mail = ActorMail.CreateMail_Get(self.addr, addr, method, content)
  local suspended, response, err = ActorDispatcher.SendMail(mail)
  Assert_(not suspended, "ActorSync can not [Get] response from ActorAsync")
  ActorMail.DestroyMail(mail)
  return response, err
end

function ActorSync:Post_(addr, method, content)
  local mail = ActorMail.CreateMail_Post(self.addr, addr, method, content)
  local suspended, _, err = ActorDispatcher.SendMail(mail)
  if not suspended then
    ActorMail.DestroyMail(mail)
  end
  return err
end

function ActorSync:DoLogic_(method, content, sendTimeStamp)
  self.methodMap[method](self, content, sendTimeStamp)
end
