StarArkVictoryView = class("StarArkVictoryView", ContainerView)
StarArkVictoryView.ViewType = UIViewType.NormalLayer
local StarArkConfig = GameConfig.StarArk
local EffectConfig = {
  [1] = EffectMap.UI.StarArk_SSS,
  [2] = EffectMap.UI.StarArk_SS,
  [3] = EffectMap.UI.StarArk_S,
  [4] = EffectMap.UI.StarArk_A
}
local _ScenePath = ResourcePathHelper.UIModel("VictoryScene")
local _GetPosition = LuaGameObject.GetPosition
local _GetRotation = LuaGameObject.GetRotation
local _ObjectIsNull = LuaGameObject.ObjectIsNull
local _outlineLayer = Game.ELayer.Outline
local _Const_V3_zero = LuaGeometry.Const_V3_zero
local _PartIndex = Asset_Role.PartIndex
local _PartIndexEx = Asset_Role.PartIndexEx

function StarArkVictoryView:Init()
  self:FindObjs()
  self:AddEvtListener()
  self:AddCloseButtonEvent()
  self:SetData()
end

function StarArkVictoryView:OnEnter()
  self:InitScene()
  self:LoadModel()
  StarArkVictoryView.super.OnEnter(self)
end

function StarArkVictoryView:FindObjs()
  self.raid = self:FindGO("raid"):GetComponent(UILabel)
  self.time = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.boxNum = self:FindGO("BoxNumLabel"):GetComponent(UILabel)
  self.reviveCount = self:FindGO("ReviveCountLabel"):GetComponent(UILabel)
  self.finalTimeLabel = self:FindGO("FinalTimeLabel"):GetComponent(UILabel)
  self.boxPenaltyLabel = self:FindGO("BoxPenaltyLabel"):GetComponent(UILabel)
  self.deathPenaltyLabel = self:FindGO("DeathPenaltyLabel"):GetComponent(UILabel)
  self.objRoot = self:FindGO("Root")
  self.objModelInfos = self:FindGO("ModelInfos")
  self.labMvpName = self:FindComponent("nameLabel", UILabel)
  self.objModelTexture = self:FindComponent("ModelRoot", UITexture)
  local damageObj = self:FindGO("Damage")
  self.name_Damage = self:FindGO("name", damageObj):GetComponent(UILabel)
  self.desc_Damage = self:FindGO("descLabel", damageObj):GetComponent(UILabel)
  self.damage_effectContainer = self:FindGO("effectContainer", damageObj)
  local healObj = self:FindGO("Heal")
  self.name_Heal = self:FindGO("name", healObj):GetComponent(UILabel)
  self.desc_Heal = self:FindGO("descLabel", healObj):GetComponent(UILabel)
  self.heal_effectContainer = self:FindGO("effectContainer", healObj)
  local damageTakenObj = self:FindGO("DamageTaken")
  self.name_DamageTaken = self:FindGO("name", damageTakenObj):GetComponent(UILabel)
  self.desc_DamageTaken = self:FindGO("descLabel", damageTakenObj):GetComponent(UILabel)
  self.damageTaken_effectContainer = self:FindGO("effectContainer", damageTakenObj)
  self.damageDataBtn = self:FindGO("DamageDataBtn")
  self:AddClickEvent(self.damageDataBtn, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.StarArkStatisticsView
    })
  end)
  self.effectContainer = self:FindGO("effectContainer")
  self.sailingAdd = self:FindGO("sailingAdd"):GetComponent(UILabel)
end

function StarArkVictoryView:AddEvtListener()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.CloseSelf, self)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function StarArkVictoryView:OnExit()
  self:ClearTick()
  self:_resetCamera()
  self:DestroyModel()
  self:DestroyScene()
  self:_destroySetCameraTick()
  if self.mvpUserData then
    self.mvpUserData:Destroy()
  end
  StarArkVictoryView.super.OnExit(self)
end

function StarArkVictoryView:DestroyModel()
  if self.assetRole and self.assetRole:Alive() then
    self.assetRole:SetEpNodesDisplay(false)
    self.assetRole:Destroy()
  end
  self.assetRole = nil
  self:_resetCamera()
end

function StarArkVictoryView:CloseSelf()
  StarArkVictoryView.super.CloseSelf(self)
end

function StarArkVictoryView:ShowEffect()
  if not self.fightinfo then
    return
  end
  local ins = DungeonProxy.Instance
  self:PlayUIEffect(EffectConfig[ins.starArk_finalGrade or 1], self.effectContainer)
  if self.fightinfo.damage then
    self:PlayUIEffect(EffectMap.UI.StarArk_Highlight, self.damage_effectContainer)
  end
  if self.fightinfo.heal then
    self:PlayUIEffect(EffectMap.UI.StarArk_Highlight, self.heal_effectContainer)
  end
  if self.fightinfo.suffer then
    self:PlayUIEffect(EffectMap.UI.StarArk_Highlight, self.damageTaken_effectContainer)
  end
end

function StarArkVictoryView:SetData()
  local ins = DungeonProxy.Instance
  self.raid.text = ins:GetStarArkRaidName()
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(ins.starArk_finalSailingtime)
  self.time.text = string.format(ZhString.StarArk_SailingTime, min, sec)
  self.boxNum.text = string.format(ZhString.StarArk_BoxCount, ins.starArk_finalBoxleftnum, ins.starArk_finalBoxtotalnum)
  self.reviveCount.text = ins.starArk_finalRelivecount
  self.boxPenaltyLabel.text = "-" .. (ins.starArk_boxdecscore or 0)
  self.deathPenaltyLabel.text = "-" .. (ins.starArk_relivedecscore or 0)
  self.sailingAdd.text = "+" .. (ins.starArk_sailingaddscore or 0)
  self:PlayUIEffect(EffectConfig[ins.starArk_finalGrade or 1], self.effectContainer)
  local finalTime = ins.starArk_sailingaddscore - ins.starArk_boxdecscore - ins.starArk_relivedecscore
  self.finalTimeLabel.text = string.format(ZhString.StarArk_FinalTime, math.clamp(finalTime, 0, 100000))
  self.fightinfo = self.viewdata.viewdata.fightinfo
  self.name_Damage.text = self.fightinfo.damgename or ""
  self.desc_Damage.text = string.format(ZhString.StarArk_Damage, self.fightinfo.damage or 0)
  self.name_Heal.text = self.fightinfo.healname or ""
  self.desc_Heal.text = string.format(ZhString.StarArk_Heal, self.fightinfo.heal or 0)
  self.name_DamageTaken.text = self.fightinfo.suffername or ""
  self.desc_DamageTaken.text = string.format(ZhString.StarArk_Suffer, self.fightinfo.suffer or 0)
  local serverdata = self.fightinfo.mvpuserinfo
  local userdata = serverdata and serverdata.datas
  if userdata then
    self.mvpUserData = UserData.CreateAsTable()
    local sdata
    for i = 1, #userdata do
      sdata = userdata[i]
      if sdata then
        self.mvpUserData:SetByID(sdata.type, sdata.value, sdata.data)
      end
    end
  end
  self.labMvpName.text = serverdata and serverdata.name or ""
end

function StarArkVictoryView:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function StarArkVictoryView:InitScene()
  if nil ~= self.previewScene then
    return
  end
  self.RetrySetCameraCount = 0
  self.vecCameraPosRecord = LuaVector3()
  self.quaCameraRotRecord = LuaQuaternion()
  self.previewScene = Game.AssetManager_UI:CreateAsset(_ScenePath)
  self.previewScene.transform.position = LuaGeometry.GetTempVector3(0, 1000, 0)
  self.rolePos = self:FindGO("RolePos", self.previewScene).transform
  self.cameraPos = self:FindGO("CameraPos", self.previewScene).transform
  self.modelBgTrans = self:FindGO("Reloading_BG", self.previewScene).transform
  UIManagerProxy.Instance:RefitSceneModel(self.cameraPos, self.modelBgTrans)
  self:_setCamera()
end

function StarArkVictoryView:_setCamera()
  if self.cameraOn then
    return
  end
  if self.cameraDelayTick then
    return
  end
  self.worldCameraLayer = self.worldCameraLayer or Game.ELayer.Default
  if not self.worldCamera or _ObjectIsNull(self.worldCamera) then
    self.worldCamera = NGUITools.FindCameraForLayer(self.worldCameraLayer)
    if not self.worldCamera then
      self.RetrySetCameraCount = self.RetrySetCameraCount + 1
      if self.RetrySetCameraCount > 9 then
        return
      end
      self.cameraDelayTick = TimeTickManager.Me():CreateOnceDelayTick(self.RetrySetCameraCount * 100, function(owner, deltaTime)
        self.cameraDelayTick = nil
        self:_setCamera()
      end, self, 3)
      return
    end
  end
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  FunctionSystem.InterruptMyself()
  self.cameraController = self.worldCamera.gameObject:GetComponent(CameraController)
  self.cameraWorldTransform = self.worldCamera.transform
  self.fovRecord = self.worldCamera.fieldOfView
  if self.cameraController then
    self.cameraController.applyCurrentInfoPause = true
    self.cameraController.enabled = false
  else
    LogUtility.Error("没有在主摄像机上找到CameraController！")
  end
  LuaVector3.Better_Set(self.vecCameraPosRecord, _GetPosition(self.cameraWorldTransform))
  LuaQuaternion.Better_Set(self.quaCameraRotRecord, _GetRotation(self.cameraWorldTransform))
  self.cameraWorldTransform.position = LuaGeometry.GetTempVector3(_GetPosition(self.cameraPos))
  self.cameraWorldTransform.rotation = LuaGeometry.GetTempQuaternion(_GetRotation(self.cameraPos))
  self.worldCamera.fieldOfView = 20
  self.cameraOn = true
end

function StarArkVictoryView:_destroySetCameraTick()
  if not self.cameraDelayTick then
    return
  end
  self.cameraDelayTick:Destroy()
  self.cameraDelayTick = nil
end

function StarArkVictoryView:ObserverDestroyed(obj)
  if self.assetRole == obj then
    self.assetRole:UnregisterWeakObserver(self)
    self.assetRole = nil
  end
end

function StarArkVictoryView:_resetCamera()
  if not self.cameraOn then
    return
  end
  self:_destroySetCameraTick()
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  if self.worldCamera and not _ObjectIsNull(self.worldCamera) then
    self.cameraWorldTransform.position = self.vecCameraPosRecord
    self.cameraWorldTransform.rotation = self.quaCameraRotRecord
    if self.fovRecord then
      self.worldCamera.fieldOfView = self.fovRecord
    end
    if self.cameraController then
      self.cameraController.applyCurrentInfoPause = false
      self.cameraController:InterruptSmoothTo()
      self.cameraController.enabled = true
      self:CameraRotateToMe(false, _RotateViewPort, nil, nil, 0)
    end
  end
  self.fovRecord = nil
  self.RetrySetCameraCount = 0
  self.cameraOn = false
  self:CameraReset()
end

function StarArkVictoryView:LoadModel()
  local userdata = self.mvpUserData
  if not userdata then
    return
  end
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
  parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
  parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
  parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
  parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
  parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
  parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
  parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
  parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
  parts[partIndex.Mount] = 0
  parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
  parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
  parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  if not self.assetRole then
    self.assetRole = Asset_Role_UI.Create(parts)
    self.assetRole:SetParent(self.rolePos, false)
    self.assetRole:SetLayer(_outlineLayer)
    self.assetRole:SetPosition(_Const_V3_zero)
    self.assetRole:SetEulerAngleY(180)
    self.assetRole:SetScale(1)
    self.assetRole:SetShadowEnable(false)
    self.assetRole:ActiveMulColor(LuaColor.New(1, 1, 1, 1))
    self.assetRole:RegisterWeakObserver(self)
    self.assetRole:SetEpNodesDisplay(true)
    self.assetRole:SetForceShowMount(true)
  else
    self.assetRole:Redress(parts, true)
  end
  local animParams = Asset_Role.GetPlayActionParams(GameConfig.teamPVP.Victoryanimation, Asset_Role.ActionName.Idle, 1)
  animParams[7] = function()
    if self.role then
      self.role:PlayAction_Simple(Asset_Role.ActionName.Idle)
    end
  end
  self.assetRole:PlayAction(animParams)
end

function StarArkVictoryView:DestroyScene()
  if not self.previewScene then
    return
  end
  if not Slua.IsNull(self.previewScene) then
    GameObject.DestroyImmediate(self.previewScene)
  end
  self.previewScene = nil
  self.rolePos = nil
  self.cameraPos = nil
  self.modelBgTrans = nil
  self.vecCameraPosRecord:Destroy()
  self.quaCameraRotRecord:Destroy()
end
