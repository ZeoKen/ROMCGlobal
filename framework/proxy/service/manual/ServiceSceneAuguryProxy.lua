autoImport("ServiceSceneAuguryAutoProxy")
ServiceSceneAuguryProxy = class("ServiceSceneAuguryProxy", ServiceSceneAuguryAutoProxy)
ServiceSceneAuguryProxy.Instance = nil
ServiceSceneAuguryProxy.NAME = "ServiceSceneAuguryProxy"

function ServiceSceneAuguryProxy:ctor(proxyName)
  if ServiceSceneAuguryProxy.Instance == nil then
    self.proxyName = proxyName or ServiceSceneAuguryProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceSceneAuguryProxy.Instance = self
  end
end

function ServiceSceneAuguryProxy:RecvAuguryInviteReply(data)
  AuguryProxy.Instance:SetNpcId(data.npcguid)
  self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  if data.type == SceneAugury_pb.EReplyType_Refuse then
    MsgManager.ShowMsgByID(867)
  end
  self:Notify(ServiceEvent.SceneAuguryAuguryInviteReply, data)
end

function ServiceSceneAuguryProxy:RecvAuguryTitle(data)
  AuguryProxy.Instance:RecvAuguryTitle(data)
  if data.titleid then
    local tb = AuguryProxy.Instance:GetTable()
    if tb then
      local staticData = tb[data.titleid]
      if staticData and staticData.Type == 1 then
        local npcId = AuguryProxy.Instance:GetNpcId()
        if npcId then
          local npc = NSceneNpcProxy.Instance:Find(npcId)
          local squareRange = GameConfig.Augury.Range * GameConfig.Augury.Range
          if npc and squareRange >= VectorUtility.DistanceXZ_Square(Game.Myself:GetPosition(), npc:GetPosition()) then
            self:sendNotification(UIEvent.JumpPanel, {
              view = PanelConfig.AuguryView,
              viewdata = {isNpcFuncView = true}
            })
          else
            ServiceSceneAuguryProxy.Instance:CallAuguryQuit()
          end
        end
      end
    end
  end
  self:Notify(ServiceEvent.SceneAuguryAuguryTitle, data)
end

function ServiceSceneAuguryProxy:RecvAuguryChat(data)
  AuguryProxy.Instance:RecvAuguryChat(data)
  self:Notify(ServiceEvent.SceneAuguryAuguryChat, data)
end

function ServiceSceneAuguryProxy:RecvAuguryAstrologyInfo(data)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.AstrolotyResultView,
    viewdata = {
      id = data.id,
      buffid = data.buffid
    }
  })
  self:Notify(ServiceEvent.SceneAuguryAuguryAstrologyInfo, data)
end
