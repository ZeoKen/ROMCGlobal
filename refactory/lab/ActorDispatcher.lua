local Assert_ = function(condition, msg)
  return assert(condition, msg)
end
local Stack_IsEmpty_ = function(stack)
  return 0 == #stack
end
local Stack_Push_ = function(stack, obj)
  stack[#stack + 1] = obj
end
local Stack_Pop_ = function(stack)
  local i = #stack
  local obj = stack[i]
  stack[i] = nil
  return obj
end
ActorDispatcher = class("ActorDispatcher")
local actorMap_
local nextAddr_ = 1
local actors_Mail_, actors_Response_, actors_PostSignal_, baseActor_Frame_, timeStamp_
local RefreshTimeStamp_ = function()
  if nil ~= timeStamp_ then
    timeStamp_:RefRelease()
  end
  timeStamp_ = TimeStamp.Create()
end
local AllocAddress_ = function()
  local addr = nextAddr_
  nextAddr_ = nextAddr_ + 1
  return addr
end
local FreeAddress_ = function(addr)
end
local GetActor_ = function(addr)
  return actorMap_[addr]
end

function ActorDispatcher.Startup()
  Assert_(nil == actorMap_, "ActorDispatcher has already startuped")
  actorMap_ = {}
  nextAddr_ = 1
  actors_Mail_ = {}
  actors_Response_ = {}
  actors_PostSignal_ = {}
  local addr = AllocAddress_()
  baseActor_Frame_ = ReusableObject.Create(Actor_Frame, true, addr)
end

function ActorDispatcher.Shutdown()
  Assert_(nil ~= actorMap_, "ActorDispatcher is not working")
  local actorMap = actorMap_
  actorMap_ = nil
  actors_Mail_ = nil
  actors_Response_ = nil
  actors_PostSignal_ = nil
  for _, actor in actorMap, nil, nil do
    actor:Destroy()
  end
  baseActor_Frame_:Destroy()
  baseActor_Frame_ = nil
end

function ActorDispatcher.CreateActor(Type)
  local addr = AllocAddress_()
  local actor = ReusableObject.Create(Type, true, addr)
  actorMap_[addr] = actor
  return addr
end

function ActorDispatcher.DestroyActor(addr)
  local actor = actorMap_[addr]
  if nil ~= actor then
    actorMap_[addr] = nil
    actor:Destroy()
    FreeAddress_(addr)
  end
end

function ActorDispatcher.GetBaseActorAddress_Frame()
  return baseActor_Frame_:GetAddress()
end

function ActorDispatcher.SendMail(mail)
  local actor = GetActor_(addr)
  if nil == actor then
    return false, nil, ActorError.NoActor
  end
  mail:SetSendTimeStamp(timeStamp_)
  return actor:SendMail(mail)
end

function ActorDispatcher.RegisterActor_Mail(actor)
  actors_Mail_[actor] = 1
end

function ActorDispatcher.RegisterActor_Response(actor)
  actors_Response_[actor] = 1
end

function ActorDispatcher.RegisterActor_PostSignal(actor)
  actors_PostSignal_[actor] = 1
end

local tempTable_ = {}
local RegisterActor_Mail_ = ActorDispatcher.RegisterActor_Mail
local HandleAllMails_Response_ = function()
  local temp = tempTable_
  tempTable_ = actors_Response_
  actors_Response_ = temp
  for actor, _ in pairs(tempTable_) do
    actor:HandleResponseMail()
    tempTable_[actor] = nil
  end
end
local HandleAllMails_PostSignal_ = function()
  local temp = tempTable_
  tempTable_ = actors_PostSignal_
  actors_PostSignal_ = temp
  for actor, _ in pairs(tempTable_) do
    actor:HandlePostSignalMail()
    tempTable_[actor] = nil
  end
end
local HandleAllMails_OneMail_ = function()
  local temp = tempTable_
  tempTable_ = actors_Mail_
  actors_Mail_ = temp
  for actor, _ in pairs(tempTable_) do
    if mail:HandleOneMail(timeStamp_) then
      RegisterActor_Mail_(mail)
    end
    tempTable_[actor] = nil
  end
end
local HandleFrame_ = function()
  baseActor_Frame_:FrameProc(timeStamp_)
end
local HandleFrameEnd_ = function()
  local temp = tempTable_
  tempTable_ = actors_Response_
  actors_Response_ = temp
  baseActor_Frame_:FrameEnd(timeStamp_)
  HandleAllMails_Response_()
  temp = tempTable_
  tempTable_ = actors_Response_
  actors_Response_ = temp
end

function ActorDispatcher.Update(time, deltaTime)
  RefreshTimeStamp_()
  HandleFrame_()
  HandleAllMails_Response_()
  HandleAllMails_PostSignal_()
  HandleAllMails_OneMail_()
  HandleFrameEnd_()
end
