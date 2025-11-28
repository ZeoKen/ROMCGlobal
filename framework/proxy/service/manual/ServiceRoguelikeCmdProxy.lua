autoImport("ServiceRoguelikeCmdAutoProxy")
ServiceRoguelikeCmdProxy = class("ServiceRoguelikeCmdProxy", ServiceRoguelikeCmdAutoProxy)
ServiceRoguelikeCmdProxy.Instance = nil
ServiceRoguelikeCmdProxy.NAME = "ServiceRoguelikeCmdProxy"

function ServiceRoguelikeCmdProxy:ctor(proxyName)
  if ServiceRoguelikeCmdProxy.Instance == nil then
    self.proxyName = proxyName or ServiceRoguelikeCmdProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceRoguelikeCmdProxy.Instance = self
  end
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeInviteCmd(data)
  FunctionPve.Me():HandleServerInvite(not data.open, data.entranceid, data.layer, data.lefttime)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeInviteCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeInfoCmd(data)
  DungeonProxy.Instance:SetRoguelikeMaxGrade(data.layer)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeInfoCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeQueryArchiveDataCmd(data)
  FunctionPve.Me():RefreshRoguelikeSaveDatas(data.datas)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeQueryArchiveDataCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeRaidInfoCmd(data)
  DungeonProxy.Instance:UpdateRoguelikeRaidInfo(data)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeRaidInfoCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeRankInfoCmd(data)
  DungeonProxy.Instance:UpdateRoguelikeRankInfo(data.multi == 0, data.datas, data.userdata)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeRankInfoCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeSubSceneCmd(data)
  local sceneData = SceneProxy.Instance:CloneSceneData()
  if sceneData == nil then
    return
  end
  sceneData.pos = nil
  sceneData.isRoguelike = true
  TableUtility.ArrayClear(sceneData.subScenes)
  for i = 1, #data.subScenes do
    sceneData.subScenes[i] = data.subScenes[i]
  end
  self:Notify(ServiceEvent.PlayerMapChange, sceneData, LoadSceneEvent.StartLoad)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeShopDataCmd(data)
  DungeonProxy.Instance:UpdateRoguelikeShopData(data.items, data.shop_cnt)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeShopDataCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeScoreModelCmd(data)
  DungeonProxy.Instance:UpdateScoreMode(data)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeScoreModelCmd(self, data)
end

local optDescMap, resultDescMap

function ServiceRoguelikeCmdProxy:RecvRoguelikeArchiveCmd(data)
  FunctionPve.Me():HandleRecvRoguelikeArchiveOption(data)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeArchiveCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeFightInfo(data)
  DungeonProxy.Instance:UpdateRoguelikeStatistics(data.info)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeFightInfo(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeWeekReward(data)
  DungeonProxy.Instance:UpdateRoguelikeWeekReward(data.layer, data.rewarded)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeWeekReward(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeSettlement(data)
  DungeonProxy.Instance:RecvRoguelikeSettlement(data)
  ServiceRoguelikeCmdProxy.super.RecvRoguelikeSettlement(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRogueTarotInfoCmd(data)
  DungeonProxy.Instance:RecvRoguelikeTarotInfo(data.progress, data.all_tarots, data.unlock_tarots)
  ServiceRoguelikeCmdProxy.super.RecvRogueTarotInfoCmd(self, data)
end

function ServiceRoguelikeCmdProxy:RecvRoguelikeReplyCmd(data)
  FunctionPve.Me():HandleReplay(data.charid, data.reply, PveRaidType.Rugelike)
  self:Notify(ServiceEvent.RoguelikeCmdRoguelikeReplyCmd, data)
end
