autoImport("GPrayTypeCell")
autoImport("BaseGuildPrayDialog")
GuildPrayDialog = class("GuildPrayDialog", BaseGuildPrayDialog)
GuildPrayDialog.ViewType = UIViewType.DialogLayer
local _CertificateName
local _GuildConfig = GameConfig.Guild
local _GuildCertificateId = _GuildConfig.praydeduction[1]
local _GuildCertificateZenyRate = _GuildConfig.praydeduction[2]

function GuildPrayDialog:InitUI()
  _CertificateName = Table_Item[_GuildCertificateId].NameZh
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.GuildPrayDialog_Title
  local sliverGo = self:FindGO("Silver")
  self.sliver = self:FindComponent("Label", UILabel, sliverGo)
  self.sliverIcon = self:FindComponent("symbol", UISprite, sliverGo)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.sliverIcon)
  self.silverGetPathContainer = self:FindGO("GetPathContainer", sliverGo)
  self.contributeGo = self:FindGO("Contribute")
  self.contributeIcon = self:FindComponent("symbol", UISprite, self.contributeGo)
  IconManager:SetItemIcon("item_140", self.contributeIcon)
  self.contributeGetPathContainer = self:FindGO("GetPathContainer", self.contributeGo)
  self.contribute = self:FindComponent("Label", UILabel, self.contributeGo)
  self.bindContributeGo = self:FindGO("BindContribute")
  self.bindContributeIcon = self:FindComponent("symbol", UISprite, self.bindContributeGo)
  IconManager:SetItemIcon("item_141", self.bindContributeIcon)
  self.bindContributeGetPathContainer = self:FindGO("GetPathContainer", self.bindContributeGo)
  self.bindContribute = self:FindComponent("Label", UILabel, self.bindContributeGo)
  self.certificateGO = self:FindGO("Certificate")
  self.certificate = self:FindComponent("Label", UILabel, self.certificateGO)
  self.certificateIcon = self:FindComponent("symbol", UISprite, self.certificateGO)
  IconManager:SetItemIcon(Table_Item[_GuildCertificateId].Icon, self.certificateIcon)
  self.certificateGetPathContainer = self:FindGO("GetPathContainer", self.certificateGO)
  self:AddClickEvent(sliverGo, function()
    self:ShowGetPathOfCost(GameConfig.MoneyId.Zeny, self.silverGetPathContainer)
  end)
  self:AddClickEvent(self.contributeGo, function()
    self:ShowGetPathOfCost(GameConfig.MoneyId.Contribute, self.contributeGetPathContainer)
  end)
  self:AddClickEvent(self.bindContributeGo, function()
    self:ShowGetPathOfCost(GameConfig.MoneyId.Bind_Contribute, self.bindContributeGetPathContainer)
  end)
  self:AddClickEvent(self.certificateGO, function()
    self:ShowGetPathOfCost(_GuildCertificateId, self.certificateGetPathContainer)
  end)
  self.costRoot = self:FindGO("CostRoot")
  self.useTog = self:FindComponent("UseTog", UIToggle, self.costRoot)
  self.useTog.value = true
  self.fixedLab = self:FindComponent("FixedLab", UILabel, self.costRoot)
  self.fixedLab.text = ZhString.GuildPrayDialog_Cost
  self.costIcon = self:FindComponent("CostIcon", UISprite, self.costRoot)
  IconManager:SetItemIcon(Table_Item[_GuildCertificateId].Icon, self.costIcon)
  self.ownLab = self:FindComponent("OwnLab", UILabel, self.costRoot)
  self.prayGrid = self:FindComponent("PrayGrid", UIGrid)
  self:InitPrayType()
  self:InitPrayCtl()
  GuildPrayDialog.super.InitUI(self)
  self:_updateCoins()
  self:InitMaxPray()
  self:_updatePrayGrid()
  self:FirstChoosePray()
end

function GuildPrayDialog:InitPrayType()
  self.prayType = GuildCmd_pb.EPRAYTYPE_GODDESS
end

function GuildPrayDialog:InitPrayCtl()
  self.prayCtl = UIGridListCtrl.new(self.prayGrid, GPrayTypeCell, "GPrayTypeCell")
  self.prayCtl:AddEventListener(MouseEvent.MouseClick, self.ChoosePray, self)
end

function GuildPrayDialog:FirstChoosePray()
  self:ChoosePray(self.prayCtl:GetCells()[1])
end

function GuildPrayDialog:InitMaxPray()
  self.prayButtonLab.text = ZhString.GuildPrayDialog_Pray
  self.maxPrayTog = self:FindComponent("MaxPrayTog", UIToggle)
  self.maxPrayTogLab = self:FindComponent("Label", UILabel, self.maxPrayTog.gameObject)
  self.maxPrayTogLab.text = ZhString.GuildPrayDialog_MaxPray
  EventDelegate.Add(self.maxPrayTog.onChange, function()
    self:_updateDialogContent()
    self:UpdateCostLab()
  end)
end

function GuildPrayDialog:AddMapEvent()
  GuildPrayDialog.super.AddMapEvent(self)
  self:AddListenEvt(MyselfEvent.ContributeChange, self._updateContribution)
end

function GuildPrayDialog:CanPray()
  if not self:GetCurNpc() then
    return false
  end
  local chooseData = self.chooseData
  if not chooseData then
    return false
  end
  if not self:CheckLvLimited() then
    return false
  end
  if not self:CheckMoney() then
    return false
  end
  if not self:CheckContribution() then
    return false
  end
  return true
end

function GuildPrayDialog:CheckLvLimited()
  if self.chooseData:IsMax() then
    MsgManager.ShowMsgByIDTable(2625)
    return false
  end
  return true
end

function GuildPrayDialog:CheckMoney()
  local costMoney = self.chooseData.cost_money
  if self:UseCertificate() then
    local useCertificateCost = costMoney - _GuildCertificateZenyRate * self.useCostNum
    if useCertificateCost > self.nowSliver then
      MsgManager.ShowMsgByIDTable(1)
      return false
    end
  elseif costMoney > self.nowSliver then
    MsgManager.ShowMsgByIDTable(1)
    return false
  end
  return true
end

function GuildPrayDialog:CheckContribution()
  if self.nowContribute + self.nowBindContribute < self.chooseData.cost_contribution then
    MsgManager.ShowMsgByIDTable(2820)
    return false
  end
  return true
end

function GuildPrayDialog:OnClickPray()
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
    self:UpdateCostLab()
  end, self)
  local count = self.maxPrayTog.value and self.maxPrayCount or 1
  ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_PRAY, self.chooseData.staticData.id, count, self:UseCertificate())
end

function GuildPrayDialog:UpdateCostLab()
  if not self.chooseData then
    return
  end
  local own = BagProxy.Instance:GetItemNumByStaticID(_GuildCertificateId, GameConfig.PackageMaterialCheck.guilddonate)
  local costMoney = self.maxPrayTog.value == true and self.maxZeny or self.chooseData.cost_money
  costMoney = math.floor(costMoney / _GuildCertificateZenyRate)
  costMoney = math.min(costMoney, own)
  self.useCostNum = costMoney
  self.ownLab.text = costMoney .. "/" .. own
end

function GuildPrayDialog:UseCertificate()
  return self.useCostNum and self.useCostNum > 0 and self.useTog.value == true
end

function GuildPrayDialog:PlayPrayResultAnim()
  if self.lastChoose then
    self.lastChoose:PlayPrayEffect()
  end
end

function GuildPrayDialog:ChoosePray(cellCtl)
  if self.lastChoose then
    self.lastChoose:SetChoose(false)
  end
  cellCtl:SetChoose(true)
  self.chooseData = cellCtl.data
  self:_updateDialogContent()
  self:UpdateCostLab()
  if not self.lockState then
    self.lastChoose = cellCtl
  end
end

function GuildPrayDialog:_updateDialogContent()
  if self.lockState then
    return
  end
  if not self:GetCurNpc() then
    return
  end
  local sData = self.chooseData.staticData
  local prayDlgData = {
    Speaker = self:GetNpcID(),
    NoSpeak = true
  }
  local arg = self.chooseData:CalcMaxLv(self:UseCertificate(), self.useCostNum)
  local isMax, baseLv, upLv = self.chooseData:IsMax()
  if isMax then
    self.maxPrayCount = nil
    self:SetPrayBtnInvalid(true)
    self:UpdateMaxToggleCenter(true)
    self.prayButtonLab.text = ZhString.GuildPrayDialog_Pray
    if baseLv then
      prayDlgData.Text = string.format(ZhString.GuildPrayDialog_Pray_FullTip2, sData.Name, baseLv, upLv)
    else
      prayDlgData.Text = string.format(ZhString.GuildPrayDialog_Pray_FullTip, sData.Name)
    end
  elseif not arg[1] then
    self.maxPrayCount = nil
    self:SetPrayBtnInvalid(true)
    self:UpdateMaxToggleCenter(true)
    self.prayButtonLab.text = ZhString.GuildPrayDialog_Pray
    attrStrList = {}
    local map = arg[7]
    for name, value in pairs(map) do
      table.insert(attrStrList, string.format(ZhString.GuildPrayDialog_PrayTipPart, name, value))
    end
    money, contri = arg[5], arg[6]
    self.maxZeny = money
    local attrStr = table.concat(attrStrList, ZhString.GuildPrayDialog_PrayTipPartSeperator)
    prayDlgData.Text = string.format(ZhString.GuildPrayDialog_PrayTipMulti, sData.Name, attrStr, money, _CertificateName, contri)
  else
    self.maxPrayCount = arg[1]
    local useMax = self.maxPrayTog.value == true
    local prayCountText = string.format(ZhString.GuildPrayDialog_Pray_Multi, arg[1])
    self.prayButtonLab.text = useMax and prayCountText or ZhString.GuildPrayDialog_Pray
    self:SetPrayBtnInvalid(false)
    self:UpdateMaxToggleCenter(false)
    attrStrList = {}
    local map = useMax and arg[2] or arg[7]
    for name, value in pairs(map) do
      table.insert(attrStrList, string.format(ZhString.GuildPrayDialog_PrayTipPart, name, value))
    end
    if useMax then
      money, contri = arg[3], arg[4]
    else
      money, contri = arg[5], arg[6]
    end
    self.maxZeny = money
    local attrStr = table.concat(attrStrList, ZhString.GuildPrayDialog_PrayTipPartSeperator)
    prayDlgData.Text = string.format(ZhString.GuildPrayDialog_PrayTipMulti, sData.Name, attrStr, money, _CertificateName, contri)
  end
  self.prayDialog:SetData(prayDlgData)
end

function GuildPrayDialog:OnExit()
  GuildPrayDialog.super.OnExit(self)
end

function GuildPrayDialog:_updatePrayGrid()
  if self.lockState then
    return
  end
  self.faithDatas = GuildPrayProxy.Instance:GetPrayListByType(self.prayType)
  self.prayCtl:ResetDatas(self.faithDatas)
  if self.chooseData then
    self.chooseData = GuildPrayProxy.Instance:GetPrayData(self.prayType, self.chooseData.id)
  end
end

function GuildPrayDialog:_updateCoins()
  local rob = MyselfProxy.Instance:GetROB()
  self.nowSliver = rob
  self.sliver.text = StringUtil.NumThousandFormat(rob)
  self:_updateContribution()
  local certificateNum = BagProxy.Instance:GetItemNumByStaticID(_GuildCertificateId) or 0
  self.certificate.text = tostring(certificateNum)
  self:UpdateCostLab()
end

function GuildPrayDialog:_updateContribution()
  local contribution = MyselfProxy.Instance:GetContribution()
  self.nowContribute = contribution
  if self.contribute then
    self.contribute.text = StringUtil.NumThousandFormat(contribution)
  end
  local bindContribute = MyselfProxy.Instance:GetBindContribution()
  self.nowBindContribute = bindContribute
  if self.bindContribute then
    self.bindContribute.text = StringUtil.NumThousandFormat(bindContribute)
  end
end

function GuildPrayDialog:ShowGetPathOfCost(itemID, parent)
  if self.bdt then
    self.bdt:OnExit()
  elseif itemID then
    self.bdt = GainWayTip.new(parent)
    self.bdt:SetAnchorPos(false)
    self.bdt:SetData(itemID)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end

function GuildPrayDialog:GetPathCloseCall()
  self.bdt = nil
end
