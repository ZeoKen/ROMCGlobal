local BaseCell = autoImport("BaseCell")
GuildCountDownCell = class("GuildCountDownCell", BaseCell)

function GuildCountDownCell:Init()
  self.table = self.gameObject:GetComponent(UITable)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.targetLabel = self:FindGO("Target"):GetComponent(UILabel)
  self.arrow = self:FindGO("Arrow")
  self.countDownLabel = self:FindGO("CountDownLabel"):GetComponent(UILabel)
end

function GuildCountDownCell:SetData(data)
  self.data = data
  self.tipLabel.text = data.tip or "???"
  if data.target then
    self.arrow:SetActive(true)
    self.targetLabel.gameObject:SetActive(true)
    self.targetLabel.text = data.target
  else
    self.arrow:SetActive(false)
    self.targetLabel.gameObject:SetActive(false)
  end
  local timeStamp = data.timeStamp
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 1000, function(deltaTime)
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(timeStamp)
    local tip = ZhString.GuildInfoPage_DismissGuildTip
    if 0 < leftDay then
      self.countDownLabel.text = string.format("（%02d:%02d:%02d）", leftDay, leftHour, leftMin)
    else
      self.countDownLabel.text = string.format("（%02d:%02d:%02d）", leftHour, leftMin, leftSec)
    end
  end, self, 1)
  self.table:Reposition()
end

function GuildCountDownCell:OnCellDestroy()
  TimeTickManager.Me():ClearTick(self)
end
