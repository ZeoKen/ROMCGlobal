autoImport("GvgStrongHoldMapSymbol")
local BaseCell = autoImport("BaseCell")
BigMapGvgInfoTipCell = class("BigMapGvgInfoTipCell", BaseCell)
local ProgressColor = {
  Blue = Color(0.11372549019607843, 0.8431372549019608, 1, 1),
  Red = Color(0.9803921568627451, 0.11372549019607843, 0.2784313725490196, 1),
  White = Color(1, 1, 1, 1)
}

function BigMapGvgInfoTipCell:Init()
  self.symbol = GvgStrongHoldMapSymbol.new(self:FindGO("Symbol"), nil, nil, true, true)
  self.guildNameLab = self:FindComponent("GuildName", UILabel)
  self.statusLab = self:FindComponent("StatusLab", UILabel)
end

function BigMapGvgInfoTipCell:SetData(data)
  self.data = data
  if not self.data then
    return
  end
  self.symbol:SetData(data)
  local guildName = self.data:GetHoldGuildName()
  if guildName and guildName ~= "" then
    self.guildNameLab.text = string.format("[ %s ]", guildName)
  else
    self.guildNameLab.text = ""
  end
  local isNeutral = false
  if self.data:IsOccupied() then
    self.statusLab.text = ZhString.GvgStrongHold_Occupied
  elseif self.data:IsScrambling() then
    self.statusLab.text = ZhString.GvgStrongHold_InBattle
  else
    isNeutral = true
    self.statusLab.text = ZhString.GvgStrongHold_Neutral
  end
  if isNeutral then
    self.statusLab.color = ProgressColor.White
  else
    local guildId = self.data:GetHoldGuildId()
    if guildId and GuildProxy.Instance:IsMyGuildUnion(guildId) then
      self.statusLab.color = ProgressColor.Blue
    elseif guildId then
      self.statusLab.color = ProgressColor.Red
    else
      self.statusLab.color = ProgressColor.White
    end
  end
end
