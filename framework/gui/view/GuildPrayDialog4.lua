autoImport("GvGPvpPrayTypeCell")
autoImport("GuildPrayDialog")
GuildPrayDialog4 = class("GuildPrayDialog4", GuildPrayDialog)
GuildPrayDialog4.ViewType = UIViewType.DialogLayer
local _GuildCertificateId = GameConfig.Guild.praydeduction[1]
local _GuildCertificateZenyRate = GameConfig.Guild.praydeduction[2]

function GuildPrayDialog4:InitUI()
  GuildPrayDialog4.super.InitUI(self)
  self:DeActiveContribution()
end

function GuildPrayDialog4:InitPrayType()
  self.prayType = GuildCmd_pb.EPRAYTYPE_FOUR
end

function GuildPrayDialog4:InitPrayCtl()
  self.prayCtl = UIGridListCtrl.new(self.prayGrid, GvGPvpPrayTypeCell, "GvGPvpPrayTypeCell")
  self.prayCtl:AddEventListener(MouseEvent.MouseClick, self.ChoosePray, self)
end

function GuildPrayDialog4:CheckContribution()
  return true
end

function GuildPrayDialog4:DeActiveContribution()
  if self.contributeGo then
    self.contributeGo:SetActive(false)
  end
  if self.bindContributeGo then
    self.bindContributeGo:SetActive(false)
  end
end

function GuildPrayDialog4:CheckLvLimited()
  local count = self.maxPrayTog.value and self.maxPrayCount or 1
  if self.chooseData:IsMax(count) then
    MsgManager.ShowMsgByIDTable(2625)
    return false
  end
  return true
end

function GuildPrayDialog4:CheckMoney()
  local maxPrayCount = self.chooseData:CalcMaxPrayCount(self:UseCertificate())
  if maxPrayCount <= 0 then
    MsgManager.ShowMsgByIDTable(3554, self.chooseData.costName)
    return false
  end
  return true
end

function GuildPrayDialog4:OnClickPray()
  if not self:CanPray() then
    return
  end
  self:ActiveLock(true)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    self:PlayPrayResultAnim()
    self:ActiveLock(false)
    self:_updatePrayGrid()
    self:_updateCoins()
    self:_updateDialogContent()
  end, self)
  local count = self.maxPrayTog.value and self.maxPrayCount or 1
  ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_PRAY, self.chooseData.id, count, self:UseCertificate())
end

function GuildPrayDialog4:_updateDialogContent()
  if self.lockState then
    return
  end
  local curNpc = self:GetCurNpc()
  if not curNpc then
    return
  end
  local prayDlgData = {
    Speaker = self:GetNpcID(),
    NoSpeak = true
  }
  local args = self.chooseData:GetMaxPrayParam(self:UseCertificate(), self.maxPrayTog.value)
  if args[1] then
    if 1 < args[1] then
      self.maxPrayCount = args[1]
      local useMax = self.maxPrayTog.value == true
      local prayCountText = string.format(ZhString.GuildPrayDialog_Pray_Multi, self.maxPrayCount)
      self.prayButtonLab.text = useMax and prayCountText or ZhString.GuildPrayDialog_Pray
      self:SetPrayBtnInvalid(false)
      self:UpdateMaxToggleCenter(false)
      self.maxZeny = args[5]
      prayDlgData.Text = string.format(ZhString.GvGPvPPray_Dialog4, args[2], args[4], args[5], args[6])
    else
      self.maxPrayCount = nil
      self.prayButtonLab.text = ZhString.GuildPrayDialog_Pray
      self:SetPrayBtnInvalid(args[1] == 0)
      self:UpdateMaxToggleCenter(true)
      self.maxZeny = args[5]
      prayDlgData.Text = string.format(ZhString.GvGPvPPray_Dialog4, args[2], args[4], args[5], args[6])
    end
  else
    self.maxPrayCount = nil
    self:SetPrayBtnInvalid(true)
    self:UpdateMaxToggleCenter(true)
    self.prayButtonLab.text = ZhString.GuildPrayDialog_Pray
    prayDlgData.Text = string.format(ZhString.GvGPvPPray_DialogLimit, args[2])
  end
  self.prayDialog:SetData(prayDlgData)
end

function GuildPrayDialog4:UpdateCostLab()
  if not self.chooseData then
    return
  end
  if self.chooseData:IsMax() then
    self:Hide(self.costRoot)
    return
  end
  self:Show(self.costRoot)
  local own = BagProxy.Instance:GetItemNumByStaticID(_GuildCertificateId, GameConfig.PackageMaterialCheck.guilddonate)
  local costMoney = self.maxPrayTog.value == true and self.maxZeny or self.chooseData.nextPray.itemCost.num
  costMoney = math.floor(costMoney / _GuildCertificateZenyRate)
  costMoney = math.min(costMoney, own)
  self.useCostNum = costMoney
  self.ownLab.text = costMoney .. "/" .. own
end
