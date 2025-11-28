autoImport("WarbandProxy")
WarbandProxy_MultiServer = class("WarbandProxy_MultiServer", WarbandProxy)
WarbandProxy_MultiServer.Instance = nil
WarbandProxy_MultiServer.NAME = "WarbandProxy_MultiServer"

function WarbandProxy_MultiServer:ctor(proxyName, data)
  self.proxyName = proxyName or WarbandProxy_MultiServer.NAME
  WarbandProxy_MultiServer.Instance = self
  if data ~= nil then
    self:setData(data)
  end
  self.myWarband = nil
  self.myWarbandId = -1
  self.warbandMap = {}
  self.warbandList = {}
  self.opponentGroup = {}
  self.preRoundOpponentGroup = {}
  self.opponentPlayoff = {}
  self.ESchedule = WarbandProxy.ESchedule.NoOpen
  self.opponentCount = {}
  self.preRoundOpponentCount = {}
  self.effectMap = {}
  self.effectList = {}
  self.seasonReward = {}
  self.opponentStatus = false
  self.cal_twelveSeasonTime = {}
  self.forbiddenProMap = {}
  self.forbiddenPro = {}
  self.curStage = 0
end

function WarbandProxy_MultiServer:DoQuerySeasonRank()
  if self.seasonRunning and self.seasonRank and #self.seasonRank > 0 then
    return
  end
  ServiceMatchCCmdProxy.Instance:CallTwelveWarbandSortMatchCCmd(nil, nil, true)
end
