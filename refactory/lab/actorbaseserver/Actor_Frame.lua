local FrameDelayMailComparator = function(lhsMail, rhsMail)
  return lhsMail:GetContent().frameCount - rhsMail:GetContent().frameCount
end
local TimeDelayMailComparator = function(lhsMail, rhsMail)
  return lhsMail:GetContent().time - rhsMail:GetContent().time
end
Actor_Frame = class("Actor_Frame", ActorAsync)
Actor_Frame_Method = {
  OnFrameEnd = 1,
  OnFrameDelay = 2,
  OnTimeDelay = 3,
  OnTimeDelay_Unscaled = 4
}
local pushMailFuncs_ = {}

function Actor_Frame:ctor()
  Actor_Frame.super.ctor(self)
  self.frameEndMailbox = {}
  self.frameDelayMailbox = PriorityQueue.new(FrameDelayMailComparator)
  self.timeDelayMailbox = PriorityQueue.new(TimeDelayMailComparator)
  self.timeDelayMailbox_Unscaled = PriorityQueue.new(TimeDelayMailComparator)
end

function Actor_Frame:DoConstruct(asArray, addr)
  Actor_Frame.super.DoConstruct(self, asArray, addr)
end

function Actor_Frame:DoDeconstruct(asArray)
  Actor_Frame.super.DoDeconstruct(self, asArray)
  self:DiscardAllMails_(self.frameEndMailbox)
end

function Actor_Frame:PushMail_OnFrameEnd_(mail)
  self.frameEndMailbox[#self.frameEndMailbox] = mail
  mail:RefRetain()
end

function Actor_Frame:PushMail_OnFrameDelay_(mail)
  local mailContent = mail:GetContent()
  mailContent.targetFrameCount = mail:GetSendTimeStamp().frameCount + mailContent.frameCount
  frameDelayMailbox:Push(mail)
  mail:RefRetain()
end

function Actor_Frame:PushMail_OnTimeDelay_(mail)
  local mailContent = mail:GetContent()
  mailContent.targetTime = mail:GetSendTimeStamp().time + mailContent.time
  timeDelayMailbox:Push(mail)
  mail:RefRetain()
end

function Actor_Frame:PushMail_OnTimeDelay_Unscaled_(mail)
  local mailContent = mail:GetContent()
  mailContent.targetTime = mail:GetSendTimeStamp().unscaledTime + mailContent.time
  timeDelayMailbox_Unscaled:Push(mail)
  mail:RefRetain()
end

pushMailFuncs_[Actor_Frame_Method.OnFrameEnd] = Actor_Frame.PushMail_OnFrameEnd_

function Actor_Frame:PushMail_(mail)
  local func = pushMailFuncs_[mail:GetMethod()]
  func(self, mail)
  return true
end

function Actor_Frame:ResponseAllMails_(mailbox, response)
  local mailCount = #mailbox
  if 0 < mailCount then
    for i = mailCount, 1, -1 do
      local mail = mailbox[i]
      mailbox[i] = nil
      self:Response_(mail:GetFromAddress(), mail:GetMethod(), response, mail:GetSession())
      mail:RefRelease()
    end
  end
end

function Actor_Frame:FrameProc(timeStamp)
  local mail = self.frameDelayMailbox:Peek()
  if nil ~= mail and mail:GetContent().targetFrameCount <= timeStamp.frameCount then
    self.frameDelayMailbox:Pop()
    self:Response_(mail:GetFromAddress(), mail:GetMethod(), nil, mail:GetSession())
  end
  local mail = self.timeDelayMailbox:Peek()
  if nil ~= mail and mail:GetContent().targetTime <= timeStamp.time then
    self.timeDelayMailbox:Pop()
    self:Response_(mail:GetFromAddress(), mail:GetMethod(), nil, mail:GetSession())
  end
  local mail = self.timeDelayMailbox_Unscaled:Peek()
  if nil ~= mail and mail:GetContent().targetTime <= timeStamp.unscaledTime then
    self.timeDelayMailbox_Unscaled:Pop()
    self:Response_(mail:GetFromAddress(), mail:GetMethod(), nil, mail:GetSession())
  end
end

function Actor_Frame:FrameEnd(timeStamp)
  self:ResponseAllMails_(self.frameEndMailbox)
end
