autoImport("ServiceRecallCCmdAutoProxy")
ServiceRecallCCmdProxy = class("ServiceRecallCCmdProxy", ServiceRecallCCmdAutoProxy)
ServiceRecallCCmdProxy.Instance = nil
ServiceRecallCCmdProxy.NAME = "ServiceRecallCCmdProxy"

function ServiceRecallCCmdProxy:ctor(proxyName)
  if ServiceRecallCCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRecallCCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRecallCCmdProxy.Instance = self
  end
end

function ServiceRecallCCmdProxy:RecvQueryRecallInfoRecallCmd(data)
  RecallInfoProxy.Instance:UpdateInfo(data.info)
  self:Notify(ServiceEvent.RecallCCmdQueryRecallInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdQueryRecallInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvSignQueryInfoRecallCmd(data)
  if data.data and data.data.index then
    RecallSignProxy.Instance:UpdateSignData(data.data.index, data.data)
  end
  self:Notify(ServiceEvent.RecallCCmdSignQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdSignQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvSignInRecallCmd(data)
  self:Notify(ServiceEvent.RecallCCmdSignInRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdSignInRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvBattlePassQueryInfoRecallCmd(data)
  redlog("RecvBattlePassQueryInfoRecallCmd", data.data)
  RecallActivityBattlePassProxy.Instance:UpdateBPInfo(data.data)
  self:Notify(ServiceEvent.RecallCCmdBattlePassQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdBattlePassQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvMvpCardQueryInfoRecallCmd(data)
  RecallMvpCardProxy.Instance:UpdateMvpCards(data.info)
  self:Notify(ServiceEvent.RecallCCmdMvpCardQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdMvpCardQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvWeeklyTaskQueryInfoRecallCmd(data)
  if data.info then
    RecallWeeklyTaskProxy.Instance:UpdateTaskData(nil, data.info)
  end
  self:Notify(ServiceEvent.RecallCCmdWeeklyTaskQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdWeeklyTaskQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvWeeklyTaskGetRewardRecallCmd(data)
  if data.task then
    RecallWeeklyTaskProxy.Instance:UpdateTaskRewardStatus(data.task)
  end
  self:Notify(ServiceEvent.RecallCCmdWeeklyTaskGetRewardRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdWeeklyTaskGetRewardRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvFundQueryInfoRecallCmd(data)
  if data.info then
    RecallFundProxy.Instance:UpdateFundData(data.info)
  end
  self:Notify(ServiceEvent.RecallCCmdFundQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdFundQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvFundGetRewardRecallCmd(data)
  if data.day then
    RecallFundProxy.Instance:RecvFundGetRewardRecallCmd(data.day)
  end
  self:Notify(ServiceEvent.RecallCCmdFundGetRewardRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdFundGetRewardRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvShopQueryInfoRecallCmd(data)
  if data.info then
    RecallShopProxy.Instance:UpdateShopData(data.info)
  end
  self:Notify(ServiceEvent.RecallCCmdShopQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdShopQueryInfoRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvBuyShopGoodRecallCmd(data)
  xdlog("ServiceRecallCCmdProxy:RecvBuyShopGoodRecallCmd", "购买商品成功", TableUtil.Print(data))
  if RecallShopProxy.Instance then
    RecallShopProxy.Instance:OnBuyShopGoodSuccess(data)
  end
  self:Notify(ServiceEvent.RecallCCmdBuyShopGoodRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdBuyShopGoodRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvMvpCardSetUpCardRecallCmd(data)
  RecallMvpCardProxy.Instance:SetSelfChooseUpCard(data.card_id)
  self:Notify(ServiceEvent.RecallCCmdMvpCardSetUpCardRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdMvpCardSetUpCardRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvMvpCardRandCardRecallCmd(data)
  RecallMvpCardProxy.Instance:SetUpTimes(data.rand_count)
  self:Notify(ServiceEvent.RecallCCmdMvpCardRandCardRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdMvpCardRandCardRecallCmd, data)
end

function ServiceRecallCCmdProxy:RecvCatchUpQueryInfoRecallCmd(data)
  redlog("RecvCatchUpQueryInfoRecallCmd", data.info)
  if data.info then
    RecallCatchUpProxy.Instance:UpdateCatchUpData(data.info)
  end
  self:Notify(ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd, data)
  EventManager.Me():DispatchEvent(ServiceEvent.RecallCCmdCatchUpQueryInfoRecallCmd, data)
end
