local Assert_ = function(condition, msg)
  return assert(condition, msg)
end
local Coroutine_Create_ = function(proc)
  return coroutine.create(proc)
end
local Coroutine_Resume_ = function(co, args)
  return coroutine.resume(co, args)
end
local Coroutine_Yield_ = function(args)
  return coroutine.yield(args)
end
local Queue_IsEmpty_ = function(queue)
  return 0 == #queue
end
local Queue_Push_ = function(queue, obj)
  queue[#queue + 1] = obj
end
local Queue_Pop_ = function(queue)
  local obj = queue[1]
  table.remove(queue, 1)
  return obj
end
ActorAsync = class("ActorAsync", ReusableObject)
if not ActorAsync.ActorAsync_Inited then
  ActorAsync.PoolSize = 500
  ActorAsync.ActorAsync_Inited = true
end
local Status_Idle = 1
local Status_Bussy = 2
local nextSession_ = 1
local AllocSession_ = function(fromAddr, toAddr, method, content)
  local session = nextSession_
  nextSession_ = nextSession_ + 1
  return session
end
local IsSessionValid_ = function(session)
  return nil ~= session and 0 < session
end

function ActorAsync:ctor()
  ActorAsync.super.ctor(self)
  self.mailbox = {}
  self.discardMailbox = {}
end

function ActorSync:SetMethodMap_(methodMap)
  self.methodMap = methodMap
end

function ActorAsync:DoConstruct(asArray, addr)
  self.addr = addr
  self.status = Status_Idle
  self.postSignalMail = nil
  self.responseMail = nil
  self.currentSession = nil
  self.co = Coroutine_Create_(ActorAsync.Proc)
  Coroutine_Resume_(self.co, self)
end

function ActorAsync:DoDeconstruct(asArray)
  if nil ~= self.postSignalMail then
    self.postSignalMail:RefRelease()
    self.postSignalMail = nil
  end
  if nil ~= self.responseMail then
    self.responseMail:RefRelease()
    self.responseMail = nil
  end
  self:DiscardAllMails_(self.mailbox)
  self:DiscardAllMails_(self.discardMailbox)
  self:ClearCurrentSession_()
  Coroutine_Resume_(self.co, nil)
  Assert_(self.coExited, "coroutine not exit")
  self.co = nil
end

function ActorAsync:GetAddress()
  return self.addr
end

function ActorAsync:IsIdle()
  return Status_Idle == self.status
end

function ActorAsync:IsBussy()
  return Status_Bussy == self.status
end

function ActorAsync:SendMail(mail)
  if mail:IsTagResponse() then
    if self:SetResponseMail_(mail) then
      return true, nil, ActorError.OK
    else
      return false, nil, ActorError.BeDiscarded
    end
  elseif not mail:IsPostNormal() then
    if self:SetPostSignalMail_(mail) then
      return true, nil, ActorError.OK
    else
      return false, nil, ActorError.BeDiscarded
    end
  elseif self:PushMail_(mail) then
    return true, nil, ActorError.OK
  else
    return false, nil, ActorError.BeDiscarded
  end
end

function ActorAsync:HandleResponseMail()
  self:DiscardAllMails_(self.discardMailbox)
  if self:IsBussy() then
    Coroutine_Resume_(self.co, self.responseMail)
  end
  self.responseMail:RefRelease()
  self.responseMail = nil
end

function ActorAsync:HandlePostSignalMail()
  if self:IsBussy() then
    Coroutine_Resume_(self.co, awakeMail)
  end
  self.postSignalMail:RefRelease()
  self.postSignalMail = nil
end

function ActorAsync:HandleOneMail(timeStamp)
  if self:IsBussy() then
    if nil ~= self.currentSessionMail and self.currentSessionMail:IsTimeout(timeStamp) then
      Coroutine_Resume_(self.co, self.currentSessionMail)
    end
    return 0 < #self.mailbox
  end
  local onemail = self:PreHandleMailbox_(self.mailbox)
  if nil == onemail then
    return false
  end
  Coroutine_Resume_(self.co, onemail)
  onemail:RefRelease()
  return 0 < #self.mailbox
end

function ActorAsync:DiscardAllMails_(mailbox)
  local mailCount = #mailbox
  if 0 < mailCount then
    for i = mailCount, 1, -1 do
      local mail = mailbox[i]
      mailbox[i] = nil
      if mail:IsTagGet() then
        self:Response_Interrupted_(mail:GetFromAddress(), mail:GetMethod(), nil, mail:GetSession())
      end
      mail:RefRelease()
    end
  end
end

function ActorAsync:PreDiscardAllMails_()
  if 0 == #self.discardMailbox then
    local temp = self.discardMailbox
    self.discardMailbox = self.mailbox
    self.mailbox = temp
  else
    local mailbox = self.mailbox
    local discardMailbox = self.discardMailbox
    for i = #mailbox, 1, -1 do
      Queue_Push_(discardMailbox, mailbox[i])
      mailbox[i] = nil
    end
  end
end

function ActorAsync:SetResponseMail_(mail)
  if not self:CheckCurrentSession_(mail:GetSession()) then
    return false
  end
  Assert_(nil == self.responseMail, "responseMail is not nil")
  self.responseMail = mail
  mail:RefRetain()
  ActorDispatcher.RegisterActor_Response(self)
  return true
end

function ActorAsync:SetPostSignalMail_(mail)
  if mail:IsPostInterrupt() then
    if IsSessionValid_(mail:GetSession()) then
      if not self:CheckCurrentSession_(mail:GetSession()) then
        return false
      end
    else
      self:PreDiscardAllMails_()
    end
  end
  if self:IsBussy() then
    if nil ~= self.postSignalMail then
      self.postSignalMail:RefRelease()
    end
    self.postSignalMail = mail
    mail:RefRetain()
    ActorDispatcher.RegisterActor_PostSignal(self)
    return true
  end
  return false
end

function ActorAsync:PushMail_(mail)
  Queue_Push_(self.mailbox, mail)
  mail:RefRetain()
  ActorDispatcher.RegisterActor_Mail(self)
  return true
end

function ActorAsync:SetStatus_Idle_()
  self.status = Status_Idle
end

function ActorAsync:SetStatus_Bussy_()
  self.status = Status_Bussy
end

function ActorAsync:SetCurrentSession_(newSession, mail)
  self.currentSession = newSession
  self.currentSessionMail = mail
  if nil ~= mail then
    mail:RefRetain()
  end
end

function ActorAsync:ClearCurrentSession_()
  self.currentSession = 0
  local mail = self.currentSessionMail
  self.currentSessionMail = nil
  if nil ~= mail then
    mail:RefRelease()
  end
end

function ActorAsync:CheckCurrentSession_(session)
  return self.currentSession == session
end

function ActorAsync:SetCoroutineExited_(exited)
  self.coExited = exited
end

function ActorAsync:Get_(addr, method, content, timeoutSeconds, useUnscaledTime)
  local session = AllocSession_(self.addr, addr, method, content)
  local mail = ActorMail.CreateMail_Get(self.addr, addr, method, content, session)
  local suspended, response, err = ActorDispatcher.SendMail(mail)
  if suspended then
    mail:SetTimeout(timeoutSeconds, useUnscaledTime)
    self:SetCurrentSession_(session, mail)
    mail:RefRelease()
    local awakeMail = Coroutine_Yield_(suspended, response, err)
    if nil == awakeMail then
      return response, ActorError.Exit
    else
      local timeout = awakeMail == self.currentSessionMail
      self:ClearCurrentSession_()
      if timeout then
        err = ActorError.Timeout
        self:Post_Interrupt_(addr, method, content, session)
      elseif awakeMail:IsResponseCompleted() then
        response = awakeMail:GetContent()
      elseif awakeMail:IsResponseInterrupted() then
        err = ActorError.BeInterrupted
      elseif awakeMail:IsPostInterrupt() then
        err = ActorError.BeInterrupted
        self:Post_Interrupt_(addr, method, content, session)
      else
        Assert_(false, "this awake mail is not supported")
      end
    end
  else
    mail:RefRelease()
  end
  return response, err
end

function ActorAsync:Post_(addr, method, content)
  local mail = ActorMail.CreateMail_Post(self.addr, addr, method, content)
  local _, _, err = ActorDispatcher.SendMail(mail)
  mail:RefRelease()
  return err
end

function ActorAsync:Post_Interrupt_(addr, method, content, session)
  local mail = ActorMail.CreateMail_Post_Interrupt(self.addr, addr, method, content, session)
  local _, _, err = ActorDispatcher.SendMail(mail)
  mail:RefRelease()
  return err
end

function ActorAsync:Response_(addr, method, content, session)
  local mail = ActorMail.CreateMail_Response(self.addr, addr, method, content, session)
  local _, _, err = ActorDispatcher.SendMail(mail)
  mail:RefRelease()
  return err
end

function ActorAsync:Response_Interrupted_(addr, method, content, session)
  local mail = ActorMail.CreateMail_Response_Interrupted(self.addr, addr, method, content, session)
  local _, _, err = ActorDispatcher.SendMail(mail)
  mail:RefRelease()
  return err
end

local tempContent_ = {}

function ActorAsync:WaitFor_FrameEnd_()
  local otherAddr = ActorDispatcher.GetBaseActorAddress_Frame()
  return self:Get_(otherAddr, Actor_Frame_Method.OnFrameEnd)
end

function ActorAsync:WaitFor_Frame_(frameCount)
  local otherAddr = ActorDispatcher.GetBaseActorAddress_Frame()
  tempContent_.frameCount = frameCount
  return self:Get_(otherAddr, Actor_Frame_Method.OnFrameDelay, tempContent_)
end

function ActorAsync:WaitFor_Time_(seconds)
  local otherAddr = ActorDispatcher.GetBaseActorAddress_Frame()
  tempContent_.time = seconds
  return self:Get_(otherAddr, Actor_Frame_Method.OnTimeDelay, tempContent_)
end

function ActorAsync:WaitFor_UnscaledTime_(seconds)
  local otherAddr = ActorDispatcher.GetBaseActorAddress_Frame()
  tempContent_.time = seconds
  return self:Get_(otherAddr, Actor_Frame_Method.OnTimeDelay_Unscaled, tempContent_)
end

function ActorAsync:PreHandleMailbox_(mailbox)
end

function ActorAsync:DoLogic_(method, content, sendTimeStamp)
  self.methodMap[method](self, content, sendTimeStamp)
end

function ActorAsync:Proc()
  self:SetCoroutineExited_(false)
  local exit = false
  local response
  local err = ActorError.OK
  repeat
    local onemail = Coroutine_Yield_(false, response, err)
    if nil == onemail then
      exit = true
    else
      Assert_(not mail:IsPostInterrupt() and not mail:IsResponseInterrupted(), "onemail can not be interrupt mail")
      self:SetStatus_Bussy_()
      local isTagGet = onemail:IsTagGet()
      local fromAddr = onemail:GetFromAddress()
      local method = onemail:GetMethod()
      local content = onemail:GetContent()
      local session = onemail:GetSession()
      local sendTimeStamp = onemail:GetSendTimeStamp()
      response, err = self:DoLogic_(method, content, sendTimeStamp)
      onemail = nil
      self:SetStatus_Idle_()
      if mail:IsTagGet() then
        if ActorError.OK == err then
          self:Response_(fromAddr, method, response, session)
        else
          self:Response_Interrupted_(fromAddr, method, response, session)
        end
      end
      if ActorError.Exit == err then
        exit = true
      else
        self:SetStatus_Idle_()
      end
    end
  until exit
  self:SetCoroutineExited_(true)
end
