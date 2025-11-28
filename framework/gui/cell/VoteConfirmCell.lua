autoImport("QueueBaseCell")
VoteConfirmCell = class("VoteConfirmCell", QueueBaseCell)
VoteConfirmCell.resID = ResourcePathHelper.UICell("VoteConfirmCell")

function VoteConfirmCell:ctor(parent, data)
  self.parent = parent
  self.data = data
end

function VoteConfirmCell:Enter()
  if not self.gameObject then
    self.gameObject = self:CreateObj(VoteConfirmCell.resID, self.parent)
    self.titleLab = self:FindGO("Title"):GetComponent(UILabel)
    self.nobtn = self:FindGO("NoBtn")
    self.notip = self:FindGO("Label", self.nobtn):GetComponent(UILabel)
    self.yesbtn = self:FindGO("YesBtn")
    self.yestip = self:FindGO("Label", self.yesbtn):GetComponent(UILabel)
    self.lab = self:FindGO("Context"):GetComponent(UILabel)
    self.timeSlider = self:FindGO("TimeSlider"):GetComponent(UISlider)
    self:SetEvent(self.yesbtn, function()
      self:ExcuteYesEvent()
    end)
    self:SetEvent(self.nobtn, function()
      self:ExcuteNoEvent()
    end)
  end
  self:SetData()
end

function VoteConfirmCell:ExcuteYesEvent()
  if self.yesevt then
    self.yesevt(self.playerid)
  end
  self:PassEvent(InviteConfirmEvent.Agree, self)
  local noClose = self.data and self.data.agreeNoClose
  if not noClose then
    self:Exit()
  end
end

function VoteConfirmCell:ExcuteNoEvent()
  if self.noevt then
    self.noevt(self.playerid)
  end
  self:PassEvent(InviteConfirmEvent.Refuse, self)
  self:Exit()
end

function VoteConfirmCell:SetData(data)
  if data then
    self.data = data
  else
    data = self.data
  end
  if self.data then
    self.playerid = data.playerid
    if data.msgId then
      local tipData = Table_Sysmsg[data.msgId]
      self.titleLab.text = tipData.Title
      local msgParama = data.msgParama or {}
      self.lab.text = MsgParserProxy.Instance:TryParse(tipData.Text, unpack(msgParama))
      self.yestip.text = tipData.button
      self.notip.text = tipData.buttonF
    end
    self.yesevt = data.yesevt
    self.noevt = data.noevt
    self.endevt = data.endevt
    self:UpdateTime(data.time, data.time)
  end
end

function VoteConfirmCell:UpdateTime(leftTime, totalTime)
  LeanTween.cancel(self.gameObject)
  if leftTime == nil or totalTime == nil then
    self.timeSlider.gameObject:SetActive(false)
    return
  end
  self.timeSlider.gameObject:SetActive(true)
  local value = leftTime / totalTime
  LeanTween.sliderNGUI(self.timeSlider, value, 0, leftTime):setOnComplete(function()
    if self.endevt then
      self.endevt(self.playerid)
    end
    self:PassEvent(InviteConfirmEvent.TimeOver, self)
    self:Exit()
  end)
end

function VoteConfirmCell:Exit()
  LeanTween.cancel(self.gameObject)
  Game.GOLuaPoolManager:AddToUIPool(VoteConfirmCell.resID, self.gameObject)
  self.gameObject = nil
  VoteConfirmCell.super.Exit(self)
end
