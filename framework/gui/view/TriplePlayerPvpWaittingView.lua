autoImport("TriplePlayerPvpWaittingCell")
local _PrefixTextureName = "pvpwait_bg_0"
local _Proxy, _PicMgr
TriplePlayerPvpWaittingView = class("TriplePlayerPvpWaittingView", ContainerView)
TriplePlayerPvpWaittingView.ViewType = UIViewType.NormalLayer

function TriplePlayerPvpWaittingView:Init()
  _Proxy = TriplePlayerPvpProxy.Instance
  _PicMgr = PictureManager.Instance
  self:FindObj()
  self:AddEvent()
end

function TriplePlayerPvpWaittingView:OnReconnect()
  self:CloseSelf()
end

function TriplePlayerPvpWaittingView:FindObj()
  self.textures = {}
  for i = 1, 4 do
    self.textures[i] = self:FindComponent("Texture_" .. tostring(i), UITexture)
  end
  self.playerNumLab = self:FindComponent("PlayerNum", UILabel)
  self.cdTimeLab = self:FindComponent("CDTime", UILabel)
  self.effectContainer = self:FindGO("EffectContainer")
  local grid = self:FindComponent("Grid", UIGrid)
  self.playerList = UIGridListCtrl.new(grid, TriplePlayerPvpWaittingCell, "TriplePlayerPvpWaittingCell")
end

function TriplePlayerPvpWaittingView:OnEnter()
  TriplePlayerPvpWaittingView.super.OnEnter(self)
  self:LoadTexture()
  self:UpdateView()
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.OnReconnect, self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
end

function TriplePlayerPvpWaittingView:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.OnReconnect, self)
  self:UnloadTexture()
  self:_stopTick()
  self:DestroyTimeEffect()
  self.playerList:Destroy()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  TriplePlayerPvpWaittingView.super.OnExit(self)
end

function TriplePlayerPvpWaittingView:AddEvent()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleProfessionTimeFuBenCmd, self.UpdateState)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleEnterCountFuBenCmd, self.UpdateView)
end

function TriplePlayerPvpWaittingView:LoadTexture()
  for i = 1, #self.textures do
    _PicMgr:SetTriplePvpTexture(_PrefixTextureName .. tostring(i), self.textures[i])
  end
end

function TriplePlayerPvpWaittingView:UnloadTexture()
  for i = 1, #self.textures do
    _PicMgr:UnloadTriplePvpTexture(_PrefixTextureName .. tostring(i), self.textures[i])
  end
end

function TriplePlayerPvpWaittingView:UpdateState()
  if not _Proxy:IsWaitting() then
    self:CloseSelf()
  end
end

function TriplePlayerPvpWaittingView:UpdateView()
  local players = _Proxy:GetWaittingPlayerHeadImages()
  self.playerList:ResetDatas(players)
  self.playerNumLab.text = string.format(ZhString.Triple_Waitting_PlayerNum, _Proxy:GetEnterPlayerNum())
  if not _Proxy:IsWaitting() then
    self:CloseSelf()
  end
  self:_stopTick()
  self:_startTick()
end

function TriplePlayerPvpWaittingView:_stopTick()
  TimeTickManager.Me():ClearTick(self)
  self.tick = -1
end

function TriplePlayerPvpWaittingView:_startTick()
  local end_time = _Proxy:GetWaitEndTime()
  if not end_time or end_time <= 0 then
    self:_stopTick()
    self:DestroyTimeEffect()
    return
  end
  self:PlayTimeEffect()
  self.tick = math.floor(end_time - ServerTime.CurServerTime() / 1000)
  self.cdTimeLab.text = string.format(ZhString.TriplePlayerPvp_CD, tostring(self.tick))
  TimeTickManager.Me():CreateTick(0, 1000, self._updateTick, self)
end

function TriplePlayerPvpWaittingView:PlayTimeEffect()
  self.timeEffect = self:PlayUIEffect(EffectMap.UI.TriplePvp_Time, self.effectContainer, false)
end

function TriplePlayerPvpWaittingView:DestroyTimeEffect()
  if self.timeEffect then
    self.timeEffect:Destroy()
    self.timeEffect = nil
  end
end

function TriplePlayerPvpWaittingView:_updateTick()
  if self.tick <= 0 then
    self:CloseSelf()
    return
  end
  self.cdTimeLab.text = string.format(ZhString.TriplePlayerPvp_CD, tostring(self.tick))
  self.tick = self.tick - 1
end
