autoImport("ServiceMiniGameCmdAutoProxy")
ServiceMiniGameCmdProxy = class("ServiceMiniGameCmdProxy", ServiceMiniGameCmdAutoProxy)
ServiceMiniGameCmdProxy.Instance = nil
ServiceMiniGameCmdProxy.NAME = "ServiceMiniGameCmdProxy"

function ServiceMiniGameCmdProxy:ctor(proxyName)
  if ServiceMiniGameCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceMiniGameCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceMiniGameCmdProxy.Instance = self
  end
end

function ServiceMiniGameCmdProxy:RecvMiniGameNtfMonsterAnswer(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfMonsterAnswer, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameSubmitMonsterAnswer(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameSubmitMonsterAnswer, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameNtfMonsterShot(data)
  MiniGameProxy.Instance:RecvMiniGameNtfMonsterShot(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfMonsterShot, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameNtfGameOverCmd(data)
  MiniGameProxy.Instance:RecvMiniGameNtfGameOverCmd(data)
  redlog("RecvMiniGameNtfGameOverCmd")
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNtfGameOverCmd, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameUnlockList(data)
  MiniGameProxy.Instance:RecvMiniGameUnlockList(data)
  redlog("RecvMiniGameUnlockList")
  self:Notify(ServiceEvent.MiniGameCmdMiniGameUnlockList, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameAction(data)
  if data.gametype == MiniGameCmd_pb.EMINIGAMETYPE_CARD_PAIR then
    if data.errcode == 0 and not MiniGameProxy.Instance.isInCardGame and not data.endcardpair then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.CardsMatchView,
        viewdata = {
          difficulty = data.difficulty,
          endtime = data.endtime
        }
      })
    end
  elseif data.gametype == MiniGameCmd_pb.EMINIGAMETYPE_MONSTER_PHOTO then
    MiniGameProxy.Instance:SetMonsterShotGameMode(data.mode)
  end
  MiniGameProxy.Instance:RecvCurrentGame(data.gametype, data.difficulty)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameAction, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameNextRound(data)
  redlog("MiniGameCmdMiniGameNextRound")
  MiniGameProxy.Instance:RecvMiniGameNextRound(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameNextRound, data)
end

function ServiceMiniGameCmdProxy:RecvMiniGameQueryRank(data)
  MiniGameProxy.Instance:RecvMiniGameQueryRank(data)
  self:Notify(ServiceEvent.MiniGameCmdMiniGameQueryRank, data)
end
