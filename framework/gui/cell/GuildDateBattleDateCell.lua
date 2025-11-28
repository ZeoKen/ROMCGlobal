local fixedClock = 24
GuildDateBattleTipCell = class("GuildDateBattleTipCell", BaseCell)

function GuildDateBattleTipCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.content = self:FindComponent("Content", UILabel)
  self:AddCellClickEvent()
end

function GuildDateBattleTipCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.type = data[1]
  self.tipData = data[2]
  self.isClock = self.data <= fixedClock
  self:SetContent()
  self:SetState()
end

function GuildDateBattleTipCell:SetContent()
  if self.type == EGuildDateBattleTip.Clock then
    self.content.text = string.format(ZhString.GuildDateBattle_Clock, self.data)
  elseif self.type == EGuildDateBattleTip.SecendStamp then
    local curDate = os.date("*t", self.data)
    self.content.text = string.format(ZhString.GuildDateBattle_DateFmt, curDate.year, curDate.month, curDate.day)
  elseif self.type == EGuildDateBattleTip.Mode then
    local mode_config = GuildDateBattleProxy.GetModeConfig()
    self.content.text = mode_config and mode_config[self.data.type] and mode_config[self.data.type].name or ""
  end
end

function GuildDateBattleTipCell:SetState()
  local inValid = false
  if self.type == EGuildDateBattleTip.Clock then
    inValid = GuildDateBattleProxy.Instance:CheckClockInValid(self.data)
  elseif self.type == EGuildDateBattleTip.SecendStamp then
    inValid = GuildDateBattleProxy.Instance:CheckDateInvalid(self.data)
  end
  self.inValid = inValid
  self.bg.alpha = inValid and 0.5 or 1
end
