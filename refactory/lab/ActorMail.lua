local Tag_Post = 1
local Tag_Get = 2
local Tag_Response = 3
local Post_Normal = 11
local Post_Interrupt = 12
local Get_Normal = 21
local Response_Completed = 31
local Response_Interrupted = 32
ActorMail = class("ActorMail", ReusableObject_RefCount)
if not ActorMail.ActorMail_Inited then
  ActorMail.PoolSize = 500
  ActorMail.ActorMail_Inited = true
end
local CreateArgs = {}
local CreateMail_ = function(tag, subTag, fromAddr, toAddr, method, content, session)
  CreateArgs[1] = tag
  CreateArgs[2] = subTag
  CreateArgs[3] = fromAddr
  CreateArgs[4] = toAddr
  CreateArgs[5] = method
  CreateArgs[6] = content
  CreateArgs[7] = session
  return ReusableObject.Create(ActorMail, true, CreateArgs)
end

function ActorMail.CreateMail_Post(fromAddr, toAddr, method, content)
  return CreateMail_(Tag_Post, Post_Normal, fromAddr, toAddr, method, content)
end

function ActorMail.CreateMail_Post_Interrupt(fromAddr, toAddr, method, content, session)
  return CreateMail_(Tag_Post, Post_Interrupt, fromAddr, toAddr, method, content, session)
end

function ActorMail.CreateMail_Get(fromAddr, toAddr, method, content, session)
  return CreateMail_(Tag_Get, Get_Normal, fromAddr, toAddr, method, content, session)
end

function ActorMail.CreateMail_Response(fromAddr, toAddr, method, content, session)
  return CreateMail_(Tag_Response, Response_Completed, fromAddr, toAddr, method, content, session)
end

function ActorMail.CreateMail_Response_Interrupted(fromAddr, toAddr, method, content, session)
  return CreateMail_(Tag_Response, Response_Interrupted, fromAddr, toAddr, method, content, session)
end

function ActorMail.ComparePostSignalMail(lhs, rhs)
  return lhs.subTag - rhs.subTag
end

function ActorMail.ComparePostSignalMail_LessThan(lhs, rhs)
  return 0 > ActorMail.ComparePostSignalMail(lhs, rhs)
end

function ActorMail:ctor()
  ActorMail.super.ctor(self)
  self.content = {}
end

function ActorMail:DoConstruct(asArray, args)
  self:Set(args[1], args[2], args[3], args[4], args[5], args[6])
end

function ActorMail:DoDeconstruct(asArray)
  self:Set()
  self:SetSendTimeStamp(nil)
  self.timeout = nil
  self.useUnscaledTime = nil
end

function ActorMail:SetContent_(newContent)
  local content = self.content
  if nil ~= newContent then
    for k, v in pairs(newContent) do
      content[k] = v
    end
  else
    for k, _ in pairs(content) do
      content[k] = nil
    end
  end
end

function ActorMail:Set(tag, subTag, fromAddr, toAddr, method, content, session)
  self.tag = tag
  self.subTag = subTag
  self.fromAddr = fromAddr
  self.toAddr = toAddr
  self.method = method
  self:SetContent_(content)
  self.session = session
end

function ActorMail:SetSendTimeStamp(timeStamp)
  if nil ~= self.sendTimeStamp then
    self.sendTimeStamp:RefRelease()
  end
  self.sendTimeStamp = sendTimeStamp
  if nil ~= self.sendTimeStamp then
    self.sendTimeStamp:RefRetain()
  end
end

function ActorMail:GetSendTimeStamp()
  return self.sendTimeStamp
end

function ActorMail:SetTimeout(seconds, useUnscaledTime)
  self.timeout = seconds
  self.useUnscaledTime = useUnscaledTime
end

function ActorMail:HasTimeout()
  return nil ~= self.timeout or self.timeout > 0
end

function ActorMail:GetTimeout()
  return self.timeout, self.useUnscaledTime
end

function ActorMail:GetTimeoutTime()
  if not self:HasTimeout() then
    return 0
  end
  if self.useUnscaledTime then
    return self.sendTimeStamp.unscaledTime + self.timeout, self.useUnscaledTime
  else
    return self.sendTimeStamp.time + self.timeout, self.useUnscaledTime
  end
end

function ActorMail:IsTimeout(timeStamp)
  if not self:HasTimeout() then
    return false
  end
  if self.useUnscaledTime then
    return self.sendTimeStamp.unscaledTime + self.timeout > timeStamp.unscaledTime
  else
    return self.sendTimeStamp.time + self.timeout > timeStamp.time
  end
end

function ActorMail:GetFromAddress()
  return self.fromAddr
end

function ActorMail:GetToAddress()
  return self.fromAddr
end

function ActorMail:GetMethod()
  return self.method
end

function ActorMail:GetContent()
  return self.content
end

function ActorMail:GetSession()
  return self.session
end

function ActorMail:IsTagPost()
  return Tag_Post == self.tag
end

function ActorMail:IsTagGet()
  return Tag_Get == self.tag
end

function ActorMail:IsTagResponse()
  return Tag_Response == self.tag
end

function ActorMail:IsPostNormal()
  return Post_Normal == self.subTag
end

function ActorMail:IsPostInterrupt()
  return Post_Interrupt == self.subTag
end

function ActorMail:IsResponseCompleted()
  return Response_Completed == self.subTag
end

function ActorMail:IsResponseInterrupted()
  return Response_Interrupted == self.subTag
end
