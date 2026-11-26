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
  self.observeBtnGO = self:FindGO("ObserveBtn")
  if self.observeBtnGO then
    self.observeBtn = self.observeBtnGO:GetComponent(UISprite)
    self.observeLab = self:FindComponent("Label", UILabel, self.observeBtnGO)
    self:SetEvent(self.observeBtnGO, function()
      self:OnClickObserve()
    end)
  end
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
  if self.observeBtnGO then
    local isGoing = data:IsGoing()
    self.observeBtnGO:SetActive(isGoing)
    if isGoing and self.observeBtn then
      self.observeBtn.spriteName = data:IsOnMatch() and "com_btn_1s" or "com_btn_13s"
    end
  end
end

function GuildDateBattleOverviewResultCell:OnClickObserve()
  if not self.data then
    return
  end
  if Game.MapManager:IsGVG_Date() then
    MsgManager.ShowMsgByID(2245)
    return
  end
  local targetGuildId = self.data.defGuildid or self.data.atkGuildid
  if targetGuildId and targetGuildId ~= 0 then
    GuildDateBattleProxy.Instance:ClearObserveBattleInfo()
    ServiceFuBenCmdProxy.Instance:CallBattleObserveFubenCmd(FuBenCmd_pb.EBATTLE_OBSERVE_TYPE_DATE_BATTLE, targetGuildId, nil, {
      info = {}
    })
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
