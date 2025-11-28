GuestVisitCell = class("GuestVisitCell", BaseCell)
autoImport("HeadIconCell")
autoImport("BaseCell")
local GuestEvent = {
  [1] = ZhString.MessageBoardView_TraceEvent1,
  [2] = ZhString.MessageBoardView_TraceEvent2,
  [3] = ZhString.MessageBoardView_TraceEvent3,
  [4] = ZhString.MessageBoardView_TraceEvent4
}

function GuestVisitCell:Init()
  self.isActive = true
  self:FindObjs()
  self:AddEvts()
end

function GuestVisitCell:FindObjs()
  self.visitTime = self:FindGO("VisitTime"):GetComponent(UILabel)
  self.visitInfo = self:FindGO("VisitInfo"):GetComponent(UILabel)
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.5)
  self.headIcon:SetMinDepth(2)
end

function GuestVisitCell:AddEvts()
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(MessageBoardTracePage.SelectHead, self)
  end)
end

function GuestVisitCell:SetData(data)
  if data then
    helplog("有数据")
    helplog(data.time)
  else
    helplog("no data")
  end
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if haveData then
    helplog(data.time)
    self.visitTime.text = data.time
    self.visitInfo.text = data.items.charname .. GuestEvent[data.items.eventid]
    helplog(self.visitInfo.text)
  end
end
