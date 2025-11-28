HelpConfirmCell = class("HelpConfirmCell", InviteConfirmCell)
HelpConfirmCell.resID = ResourcePathHelper.UICell("HelpConfirmCell")

function HelpConfirmCell:Enter()
  if not self.gameObject then
    self.gameObject = self:CreateObj(HelpConfirmCell.resID, self.parent)
    self.tipLabel = self:FindGO("Tip"):GetComponent(UILabel)
    self.nobtn = self:FindGO("NoBtn")
    self.yesbtn = self:FindGO("YesBtn")
    self.yestip = self:FindGO("Label", self.yesbtn):GetComponent(UILabel)
    self.lab1 = self:FindGO("Context1"):GetComponent(UILabel)
    self.lab2 = self:FindGO("Context2"):GetComponent(UILabel)
    self.timeSliderObj = self:FindGO("TimeSlider")
    self.timeSlider = self.timeSliderObj:GetComponent(UISlider)
    self:SetEvent(self.yesbtn, function()
      self:ExcuteYesEvent()
    end)
    self:SetEvent(self.nobtn, function()
      self:ExcuteNoEvent()
    end)
  end
  self:SetData()
end

function HelpConfirmCell:SetData(data)
  if data then
    self.data = data
  else
    data = self.data
  end
  if self.data then
    self.playerid = data.playerid
    if data.lab1 then
      self.lab1.text = data.lab1
    end
    if data.lab2 then
      self.lab2.text = data.lab2
    end
    self.yestip.text = data.button
    if data.tip then
      self.tipLabel.text = data.tip
    end
    self.yesevt = data.yesevt
    self.noevt = data.noevt
    self.endevt = data.endevt
    self:UpdateTime(data.time, data.time)
  end
end

function HelpConfirmCell:Exit()
  LeanTween.cancel(self.gameObject)
  if self.timeSliderObj and not LuaGameObject.ObjectIsNull(self.timeSliderObj) then
    LeanTween.cancel(self.timeSliderObj)
  end
  Game.GOLuaPoolManager:AddToUIPool(HelpConfirmCell.resID, self.gameObject)
  self.gameObject = nil
  HelpConfirmCell.super.Exit(self)
end
