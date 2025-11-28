local _myCampCenterPos = {
  0,
  400,
  800
}
local _SetLocalPositionGO = LuaGameObject.SetLocalPositionGO
local _ArrayFindIndex = TableUtility.ArrayFindIndex
local _Proxy, _PicMgr, _TickManager
local _PrefixEnemyCampTexture = "3v3v3_bg_02_"
local _PrefixMyCampTexture = "3v3v3_bg_01_"
local _VS_TextureName = "3v3v3_bg_vs"
local _VS_BGTextureName = "3v3v3_bg_vs_bottom"
local _WhiteLineTextureName = "3v3v3_bg_line"
local _beginTweenScale = TweenScale.Begin
local _beginTweenAlpha = TweenAlpha.Begin
local _beginTweenPosition = TweenPosition.Begin
local _setLocalScaleGO = LuaGameObject.SetLocalScaleGO
autoImport("TriplePvpChooseProCell")
TriplePlayerPvpChooseProView = class("TriplePlayerPvpChooseProView", ContainerView)
TriplePlayerPvpChooseProView.ViewType = UIViewType.NormalLayer

function TriplePlayerPvpChooseProView:Init()
  _Proxy = TriplePlayerPvpProxy.Instance
  _PicMgr = PictureManager.Instance
  _TickManager = TimeTickManager.Me()
  self:FindObj()
  self:AddEvent()
end

local _BgTexture_FadeIn_Duration = 0.3

function TriplePlayerPvpChooseProView:_DoTween()
  if self.tweenRunning then
    return
  end
  self.tweenRunning = true
  self:_DoTween_Step1()
end

function TriplePlayerPvpChooseProView:_DoTween_Step1()
  _beginTweenAlpha(self.mask.gameObject, _BgTexture_FadeIn_Duration, 1)
  _beginTweenScale(self.bgLineTexture.gameObject, _BgTexture_FadeIn_Duration, LuaGeometry.Const_V3_one)
  _TickManager:CreateOnceDelayTick(_BgTexture_FadeIn_Duration * 100, function(owner, deltaTime)
    self:_DoTween_Step2()
  end, self, 1)
end

function TriplePlayerPvpChooseProView:_DoTween_Step2()
  for i = 1, #self.campTextureList do
    _beginTweenScale(self.campTextureList[i].gameObject, _BgTexture_FadeIn_Duration, LuaGeometry.Const_V3_one)
  end
  _TickManager:CreateOnceDelayTick(_BgTexture_FadeIn_Duration * 100 * 2, function(owner, deltaTime)
    self:_DoTween_Step3()
  end, self, 2)
end

local _tweenDuration = 0.5

function TriplePlayerPvpChooseProView:_DoTween_Step3()
  _TickManager:CreateOnceDelayTick(2000, function(owner, deltaTime)
    _beginTweenAlpha(self.vsRootTexture.gameObject, _tweenDuration, 1)
    _beginTweenScale(self.vsRootTexture.gameObject, _tweenDuration, LuaGeometry.Const_V3_one)
    _beginTweenAlpha(self.titleLab.gameObject, _tweenDuration, 1)
    self:PlayVSEffect()
  end, self, 3)
end

function TriplePlayerPvpChooseProView:_TryResetMyCampPos()
  if self.myPosReset then
    return
  end
  if not _Proxy:CheckIChoosen() then
    return
  end
  self:ResetMyTeamMemberPos()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ConfirmLayer)
  self.myPosReset = true
end

function TriplePlayerPvpChooseProView:FindObj()
  self.timeLabRoot = self:FindGO("TimeLabRoot")
  self.timeLab = self:FindComponent("TimeLabel", UILabel, self.timeLabRoot)
  local enemy1Texture = self:FindComponent("Enemy1Texture", UITexture)
  local enemy2Texture = self:FindComponent("Enemy2Texture", UITexture)
  local myCampTexture = self:FindComponent("MyCampTexture", UITexture)
  self.bgLineTexture = self:FindComponent("LineBgTexture", UITexture)
  self.campTextureList = {
    enemy1Texture,
    enemy2Texture,
    myCampTexture
  }
  self.campTextureNameList = {}
  self.mask = self:FindComponent("Mask", UISprite)
  self.vsRootTexture = self:FindComponent("VSRootTexture", UITexture)
  self.vsTexture = self:FindComponent("VSTexture", UITexture, self.vsRootTexture.gameObject)
  self.vsBgTexture = self:FindComponent("VsBgTexture", UITexture)
  self.VSEffectContainer = self:FindGO("VSEffectContainer")
  self.titleLab = self:FindComponent("Title", UILabel)
  self.enemyGrid1 = self:FindComponent("EnemyGroup1", UIGrid)
  self.enemyGroup1Ctl = UIGridListCtrl.new(self.enemyGrid1, TriplePvpChooseProCell, "TriplePvpChooseProCell")
  self.enemyGrid2 = self:FindComponent("EnemyGroup2", UIGrid)
  self.enemyGroup2Ctl = UIGridListCtrl.new(self.enemyGrid2, TriplePvpChooseProCell, "TriplePvpChooseProCell")
  local my_root = self:FindGO("MyGroup")
  self.myTeamMembers = {}
  for i = 1, 3 do
    local obj = self:LoadPreferb("cell/TriplePvpChooseProCell", my_root)
    obj.name = "My_TriplePvpChooseProCell" .. i
    self.myTeamMembers[i] = TriplePvpChooseProCell.new(obj)
  end
end

function TriplePlayerPvpChooseProView:PlayVSEffect()
  self.vsEffect = self:PlayUIEffect(EffectMap.UI.TriplePvp_VS, self.VSEffectContainer, false)
  self.vsBgTexture.gameObject:SetActive(false)
  self.vsBgTexture.gameObject:SetActive(true)
  self.vsTexture.gameObject:SetActive(false)
  self.vsTexture.gameObject:SetActive(true)
end

function TriplePlayerPvpChooseProView:DestroyVSEffect()
  if self.vsEffect then
    self.vsEffect:Destroy()
  end
end

function TriplePlayerPvpChooseProView:_InitYmirTip()
  if PvpObserveProxy.Instance:IsRunning() then
    return
  end
  if self.ymirInit then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.YmirTipView_TriplePvp,
    viewdata = {
      index = _Proxy.myselfIndex
    }
  })
  self.ymirInit = true
end

function TriplePlayerPvpChooseProView:OnReconnect()
  self:DoExit()
end

function TriplePlayerPvpChooseProView:OnEnter()
  TriplePlayerPvpChooseProView.super.OnEnter(self)
  EventManager.Me():AddEventListener(ServiceEvent.ConnReconnect, self.OnReconnect, self)
  _PicMgr:SetTriplePvpTexture(_VS_TextureName, self.vsTexture)
  _PicMgr:SetTriplePvpTexture(_VS_BGTextureName, self.vsBgTexture)
  _PicMgr:SetTriplePvpTexture(_WhiteLineTextureName, self.bgLineTexture)
  self:_updateCampGroup()
  self:UpdateTime()
  UIManagerProxy.Instance:NeedEnableAndroidKey(false)
end

function TriplePlayerPvpChooseProView:OnExit()
  _TickManager:ClearTick(self)
  self:_unLoadTexture()
  self:DestroyVSEffect()
  EventManager.Me():RemoveEventListener(ServiceEvent.ConnReconnect, self.OnReconnect, self)
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  TriplePlayerPvpChooseProView.super.OnExit(self)
end

function TriplePlayerPvpChooseProView:_unLoadTexture()
  _PicMgr:UnloadTriplePvpTexture(_VS_TextureName, self.vsTexture)
  _PicMgr:UnloadTriplePvpTexture(_VS_BGTextureName, self.vsBgTexture)
  _PicMgr:UnloadTriplePvpTexture(_WhiteLineTextureName, self.bgLineTexture)
  self:_unloadCampTexture()
end

function TriplePlayerPvpChooseProView:_unloadCampTexture()
  for i = 1, #self.campTextureList do
    if self.campTextureNameList[i] then
      _PicMgr:UnloadTriplePvpTexture(self.campTextureNameList[i], self.campTextureList[i])
    end
  end
end

function TriplePlayerPvpChooseProView:_loadCampTexture()
  for i = 1, #self.campTextureList do
    if not self.campTextureNameList[i] then
      local texture_name_prefix = i == 3 and _PrefixMyCampTexture or _PrefixEnemyCampTexture
      self.campTextureNameList[i] = texture_name_prefix .. _Proxy:GetCamp(i)
      _PicMgr:SetTriplePvpTexture(self.campTextureNameList[i], self.campTextureList[i])
    end
  end
end

function TriplePlayerPvpChooseProView:_SetMyCamp()
  local myTeam = _Proxy:GetMyTeam()
  if myTeam then
    local members = myTeam:GetMembers()
    for i = 1, #self.myTeamMembers do
      self.myTeamMembers[i]:SetData(members[i])
    end
  end
end

function TriplePlayerPvpChooseProView:AddEvent()
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTriplePlayerModelFuBenCmd, self._updateCampGroup)
  self:AddListenEvt(ServiceEvent.FuBenCmdSyncTripleProfessionTimeFuBenCmd, self.UpdateTime)
end

function TriplePlayerPvpChooseProView:DoExit()
  _Proxy:RaidNoMove(false)
  self:_stopTimeTick()
  self.enemyGroup1Ctl:Destroy()
  self.enemyGroup2Ctl:Destroy()
  for i = 1, #self.myTeamMembers do
    self.myTeamMembers[i]:OnCellDestroy()
  end
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.ConfirmLayer)
  self:CloseSelf()
end

function TriplePlayerPvpChooseProView:UpdateTime()
  if _Proxy:IsNoneState() then
    self:DoExit()
    return
  end
  self:_updateTitle()
  self:_stopTimeTick()
  self:_startTimeTick()
end

function TriplePlayerPvpChooseProView:_SetEnemyCamp()
  self.enemyGroup1Ctl:ResetDatas(_Proxy:GetMembersByCamp(1))
  self.enemyGroup2Ctl:ResetDatas(_Proxy:GetMembersByCamp(2))
end

function TriplePlayerPvpChooseProView:ResetMyTeamMemberPos()
  for i = 1, 3 do
    local pos = LuaGeometry.GetTempVector3(_myCampCenterPos[i], 0, 0)
    _beginTweenPosition(self.myTeamMembers[i].gameObject, 0.5, pos)
  end
end

function TriplePlayerPvpChooseProView:_updateCampGroup()
  self:_loadCampTexture()
  self:_SetEnemyCamp()
  self:_SetMyCamp()
  self:_DoTween()
  self:_InitYmirTip()
  self:_TryResetMyCampPos()
end

function TriplePlayerPvpChooseProView:_updateTitle()
  if not _Proxy:IsChoosing() then
    return
  end
  if _Proxy:GetFireBeginTime() > 0 then
    self.titleLab.text = ZhString.TriplePlayerPvp_Fire
  else
    self.titleLab.text = string.format(ZhString.TriplePlayerPvp_Phase, _Proxy:GetPhase())
  end
end

function TriplePlayerPvpChooseProView:_stopTimeTick()
  _TickManager:ClearTick(self, 10)
  self.tick = -1
end

function TriplePlayerPvpChooseProView:_startTimeTick()
  local phase_end_time = _Proxy:GetPhaseEndTime()
  local fire_begin_time = _Proxy:GetFireBeginTime()
  if phase_end_time <= 0 and fire_begin_time <= 0 then
    self:_stopTimeTick()
    return
  end
  local end_time = 0 < phase_end_time and phase_end_time or fire_begin_time
  self.tick = math.floor(end_time - ServerTime.CurServerTime() / 1000)
  self:_setTimeLab()
  _TickManager:CreateTick(0, 1000, self._updateTick, self, 10)
end

function TriplePlayerPvpChooseProView:_setTimeLab()
  self.timeLab.text = tostring(self.tick)
end

function TriplePlayerPvpChooseProView:_updateTick()
  if self.tick <= 0 then
    self:_stopTimeTick()
    if 0 < _Proxy:GetFireBeginTime() then
      self:DoExit()
    end
    return
  end
  self:_setTimeLab()
  self.tick = self.tick - 1
end
