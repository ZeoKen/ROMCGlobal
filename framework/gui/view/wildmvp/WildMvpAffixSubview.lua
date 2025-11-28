autoImport("WildMvpAffixDetailCell")
WildMvpAffixSubview = class("WildMvpAffixSubview", SubView)

function WildMvpAffixSubview:Init()
  self:ReLoadPerferb("view/WildMvp/WildMvpAffixSubview")
  self:FindObjs()
  self:UpdateView()
end

function WildMvpAffixSubview:FindObjs()
  local helpBtnGO = self:FindGO("HelpBtn")
  local help_id = PanelConfig.WildMvpAffixSubview.id
  self:TryOpenHelpViewById(help_id, nil, helpBtnGO)
  local showAllBtnGO = self:FindGO("ShowAllBtn")
  self:AddClickEvent(showAllBtnGO, function()
    self:ShowAllAffix()
  end)
  local midGO = self:FindGO("Mid")
  local affixContainer = self:FindComponent("AffixContainer", UIGrid, midGO)
  self.affixListCtrl = ListCtrl.new(affixContainer, WildMvpAffixDetailCell, "WildMvp/WildMvpAffixDetailCell")
  local leftBtnGO = self:FindGO("LeftBottom")
  local showAllBtnGO = self:FindGO("ShowAllBtn", leftBtnGO)
  self:AddClickEvent(showAllBtnGO, function()
    self:ShowAllAffixPopup()
  end)
  local bottomGO = self:FindGO("Bottom")
  self.timerGO = self:FindGO("TimerBg", bottomGO)
  self.timerLabel = self:FindComponent("Timer", UILabel, self.timerGO)
  self.emptyGO = self:FindGO("EmptyLab")
  self.emptyLab = self.emptyGO:GetComponent(UILabel)
  self.emptyLab.text = ZhString.WildMvpLoading
  local topGO = self:FindGO("Top")
  self.titleLab = self:FindComponent("Title", UILabel, topGO)
  local title = GameConfig.StormBoss and GameConfig.StormBoss.AffixViewTitle
  if title then
    self.titleLab.text = title
  end
end

function WildMvpAffixSubview:AddListenEvents()
  EventManager.Me():AddEventListener(WildMvpEvent.OnAffixUpdated, self.UpdateView, self)
end

function WildMvpAffixSubview:RemoveListenEvents()
  EventManager.Me():RemoveEventListener(WildMvpEvent.OnAffixUpdated, self.UpdateView, self)
end

function WildMvpAffixSubview:OnShow()
  self:UpdateView()
end

function WildMvpAffixSubview:OnHide()
  self:StopTimer()
end

function WildMvpAffixSubview:OnEnter()
  WildMvpAffixSubview.super.OnEnter(self)
  WildMvpProxy.Instance:QueryStormBossAffix()
  self:AddListenEvents()
  self:StartTimer()
end

function WildMvpAffixSubview:OnExit()
  self:RemoveListenEvents()
  self:StopTimer()
  WildMvpAffixSubview.super.OnExit(self)
end

function WildMvpAffixSubview:UpdateView()
  local datas = WildMvpProxy.Instance:GetActiveAffixDatas()
  if datas and 0 < #datas then
    self.emptyGO:SetActive(false)
  else
    self.emptyGO:SetActive(true)
  end
  if datas then
    self.affixListCtrl:ResetDatas(datas)
  end
  self:StartTimer()
end

function WildMvpAffixSubview:ShowAllAffixPopup()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WildMvpAllAffixPopup,
    viewdata = {
      AffixData = WildMvpProxy.Instance:GetWildMvpAffixDatas()
    }
  })
end

function WildMvpAffixSubview:StartTimer()
  if self.timer then
    return
  end
  if self:UpdateTimerLabel() then
    self.timer = TimeTickManager.Me():CreateTick(0, 500, function()
      if not self:UpdateTimerLabel() then
        self:StopTimer()
      end
    end, self)
  end
end

function WildMvpAffixSubview:StopTimer()
  if self.timer then
    self.timer:Destroy()
    self.timer = nil
  end
end

function WildMvpAffixSubview:UpdateTimerLabel()
  local proxy = WildMvpProxy.Instance
  local timeLeft = proxy:GetAffixRefreshTimeLeft()
  if timeLeft and 0 < timeLeft then
    self.timerGO:SetActive(true)
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(timeLeft)
    if 0 < day then
      self.timerLabel.text = string.format(ZhString.WildMvpAffixRefreshDay, day + 1)
    else
      self.timerLabel.text = string.format(ZhString.WildMvpAffixRefreshTimer, hour, min, sec)
    end
    return true
  else
    if timeLeft and timeLeft <= 0 then
      proxy:QueryStormBossAffix()
    end
    self.timerGO:SetActive(false)
    return false
  end
end
