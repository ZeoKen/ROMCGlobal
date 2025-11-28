autoImport("ServiceDisneyActivityAutoProxy")
ServiceDisneyActivityProxy = class("ServiceDisneyActivityProxy", ServiceDisneyActivityAutoProxy)
ServiceDisneyActivityProxy.Instance = nil
ServiceDisneyActivityProxy.NAME = "ServiceDisneyActivityProxy"

function ServiceDisneyActivityProxy:ctor(proxyName)
  if ServiceDisneyActivityProxy.Instance == nil then
    self.proxyName = proxyName or ServiceDisneyActivityProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceDisneyActivityProxy.Instance = self
  end
end

function ServiceDisneyActivityProxy:RecvQueryDisneyGuideInfoCmd(data)
  DisneyStageProxy.Instance:HandleRecvGuideInfo(data)
  self:Notify(ServiceEvent.DisneyActivityQueryDisneyGuideInfoCmd, data)
end

function ServiceDisneyActivityProxy:RecvReceiveGuideRewardCmd(data)
  DisneyStageProxy.Instance:UpdateGuideReward(data)
  self:Notify(ServiceEvent.DisneyActivityReceiveGuideRewardCmd, data)
end

function ServiceDisneyActivityProxy:RecvReceiveMickeyRewardCmd(data)
  DisneyStageProxy.Instance:HandleRecvSliderReward(data)
  self:Notify(ServiceEvent.DisneyActivityReceiveMickeyRewardCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyChallengeTaskRankCmd(data)
  DisneyProxy.Instance:RecvDisneyChallengeTaskRankCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskRankCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyChallengeTaskTipCmd(data)
  DisneyProxy.Instance:RecvDisneyChallengeTaskTipCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskTipCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyChallengeTaskPointCmd(data)
  DisneyProxy.Instance:RecvDisneyChallengeTaskPointCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskPointCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyMusicRankCmd(data)
  helplog("-----------DisneyStage RecvDisneyMusicRankCmd ")
  DisneyStageProxy.Instance:HandleMusicGameRank(data.datas)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicRankCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyMusicUpdateCmd(data)
  helplog("-----------DisneyStage RecvDisneyMusicUpdateCmd")
  DisneyStageProxy.Instance:RecvDisneyMusicUpdateCmd(data.data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicUpdateCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyChallengeTaskNotifyFirstFinishCmd(data)
  DisneyProxy.Instance:RecvDisneyChallengeTaskNotifyFirstFinishCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyChallengeTaskNotifyFirstFinishCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyMusicStartCmd(data)
  DisneyStageProxy.Instance:Handle_RecvDisneyMusicStartCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicStartCmd, data)
end

function ServiceDisneyActivityProxy:RecvDisneyMusicResultCmd(data)
  DisneyStageProxy.Instance:Handle_RecvDisneyMusicResultCmd(data)
  self:Notify(ServiceEvent.DisneyActivityDisneyMusicResultCmd, data)
end
