local _Color = {Win = "497cc2", Lose = "777777"}
autoImport("GuildHeadCell")
autoImport("GuildHeadData")
GuildDateBattleOverviewResultCell = class("GuildDateBattleOverviewResultCell", BaseCell)

function GuildDateBattleOverviewResultCell:Init()
  self.root = self:FindGO("Root")
  self.dateLab = self:FindComponent("Date", UILabel)
  self.dfLab = self:FindComponent("Defensive_Side", UILabel)
  local defGuildHeadCellGO = self:FindGO("DefGuildHeadCell")
  self.defHeadCell = GuildHeadCell.new(defGuildHeadCellGO)
  self.defHeadCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.defServerIDLab = self:FindComponent("DefServerId", UILabel)
  self.defWinGo = self:FindGO("DefWinGO")
  self.defMask = self:FindGO("DefMask")
  self.ofLab = self:FindComponent("Offensive_Side", UILabel)
  local offGuildHeadCellGO = self:FindGO("OffGuildHeadCell")
  self.offHeadCell = GuildHeadCell.new(offGuildHeadCellGO)
  self.offHeadCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.offWinGo = self:FindGO("OffWinGO")
  self.offServerIDLab = self:FindComponent("OffServerId", UILabel)
  self.offMask = self:FindGO("OffMask")
  self.modeLab = self:FindComponent("Mode", UILabel)
end

function GuildDateBattleOverviewResultCell:SetData(data)
  self.data = data
  if not data then
    self:Hide(self.root)
    return
  end
  self:Show(self.root)
  self.dfLab.text = data:GetDefGuildName()
  self.ofLab.text = data:GetOffGuildName()
  self.dateLab.text = data:GetDateStampStr()
  self.modeLab.text = data:GetModeName()
  self.defHeadCell:SetData(data.defGuildHeadData)
  self.offHeadCell:SetData(data.offGuildHeadData)
  self:_SetServerId(data.atkServerId, self.offServerIDLab)
  self:_SetServerId(data.defServerId, self.defServerIDLab)
  local _, c_win = ColorUtil.TryParseHexString(_Color.Win)
  local _, c_lose = ColorUtil.TryParseHexString(_Color.Lose)
  local offIsWin = data.winner == data.atkGuildid
  local dffIsWin = data.winner == data.defGuildid
  if offIsWin or dffIsWin then
    self.offWinGo:SetActive(offIsWin)
    self.defMask:SetActive(offIsWin)
    self.offMask:SetActive(dffIsWin)
    self.defWinGo:SetActive(dffIsWin)
    self.ofLab.color = offIsWin and c_win or c_lose
    self.dfLab.color = dffIsWin and c_win or c_lose
  else
    self.offWinGo:SetActive(false)
    self.offMask:SetActive(false)
    self.defWinGo:SetActive(false)
    self.defMask:SetActive(false)
  end
end

function GuildDateBattleOverviewResultCell:_SetServerId(server_id, label_comp)
  local my_guild_server_id = GuildProxy.Instance:GetMyGuildServerId()
  if my_guild_server_id and my_guild_server_id == server_id then
    self:Hide(label_comp)
  else
    self:Show(label_comp)
    label_comp.text = tostring(server_id)
  end
end
