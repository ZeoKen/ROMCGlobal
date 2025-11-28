GuildDateBattleTipCell = class("GuildDateBattleTipCell", BaseCell)

function GuildDateBattleTipCell:Init()
  self:InitTypeCall()
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
  self:SetCell()
end

function GuildDateBattleTipCell:InitTypeCall()
  self.typeCall = {}
  self.typeCall[EGuildDateBattleTip.SecendStamp] = GuildDateBattleTipCell.SetStamp
  self.typeCall[EGuildDateBattleTip.Clock] = GuildDateBattleTipCell.SetClock
  self.typeCall[EGuildDateBattleTip.Mode] = GuildDateBattleTipCell.SetMode
end

function GuildDateBattleTipCell:SetCell()
  local set_call = self.type and self.typeCall[self.type]
  if set_call then
    set_call(self)
    self.bg.alpha = self.inValid and 0.5 or 1
  end
end

function GuildDateBattleTipCell:SetStamp()
  local curDate = os.date("*t", self.tipData)
  self.content.text = string.format(ZhString.GuildDateBattle_DateFmt, curDate.year, curDate.month, curDate.day)
  self.inValid = GuildDateBattleProxy.Instance:CheckDateInvalid(self.tipData)
end

function GuildDateBattleTipCell:SetClock()
  self.content.text = string.format(ZhString.GuildDateBattle_Clock, self.tipData)
  self.inValid = GuildDateBattleProxy.Instance:CheckClockInValid(self.tipData)
end

function GuildDateBattleTipCell:SetMode()
  self.content.text = GuildDateBattleProxy.GetModeName(self.tipData)
  self.inValid = false
end
