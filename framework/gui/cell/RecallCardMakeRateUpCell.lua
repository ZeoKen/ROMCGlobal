autoImport("CardMakeRateUpCell")
RecallCardMakeRateUpCell = class("RecallCardMakeRateUpCell", CardMakeRateUpCell)

function RecallCardMakeRateUpCell:Init()
  RecallCardMakeRateUpCell.super.Init(self)
  self.emptyLabelGO = self:FindGO("EmptyLabel")
  self.reChooseBtn = self:FindGO("RechooseBtn")
  self:AddClickEvent(self.reChooseBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.cardCellParent, function()
    if not self.data or self.data == BagItemEmptyType.Empty then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function RecallCardMakeRateUpCell:SetData(data)
  if data then
    RecallCardMakeRateUpCell.super.SetData(self, data)
  else
    self:SetRateUpTime()
  end
  self.emptyLabelGO:SetActive(data == nil or data == BagItemEmptyType.Empty)
  self.reChooseBtn:SetActive(data ~= nil and data ~= BagItemEmptyType.Empty)
end

function RecallCardMakeRateUpCell:SetRateUpTime()
  if not RecallMvpCardProxy.Instance:IsEnd() then
    local endTime = RecallMvpCardProxy.Instance:GetEndTime()
    local remainTime = math.max(0, endTime - ServerTime.CurServerTime() / 1000)
    local remainDay, remainHour, remainMin = ClientTimeUtil.FormatTimeBySec(remainTime)
    if 0 < remainDay then
      self.upTimeLabel.text = string.format(ZhString.RemainTimeDay, remainDay)
    elseif 0 < remainHour then
      self.upTimeLabel.text = string.format(ZhString.RemainTimeHour, remainHour)
    elseif 0 <= remainMin then
      remainMin = math.max(1, remainMin)
      self.upTimeLabel.text = string.format(ZhString.RemainTimeMin, remainMin)
    else
      self.upTimeLabel.text = ""
    end
  else
    self.upTimeLabel.text = ""
  end
end
