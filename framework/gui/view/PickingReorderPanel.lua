autoImport("GunShootLocalConditionCell")
autoImport("PhotographPanel")
autoImport("SgAIManager")
PickingReorderPanel = class("PickingReorderPanel", ContainerView)
PickingReorderPanel.ViewType = UIViewType.FocusLayer
local shoot_effect = "Skill/Eff_Shooting_atk"

function PickingReorderPanel:Init()
  self:InitView()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.SelectTargetChangeHandler)
end

function PickingReorderPanel:InitView()
  self.cameraController = CameraController.Instance or CameraController.singletonInstance
  if not self.cameraController then
    printRed("cameraController is nil")
    self:CloseSelf()
    return
  end
  self.isComplete = false
  self.curSelectUniqueID = -1
  self.vecScreenCenter = LuaVector3(Screen.width / 2, Screen.height / 2, 0)
  self.lastScreenCenterX = -1
  self.lastScreenCenterY = -1
  self.CompleteArrSlot = {}
  self.ArrSlot = {}
  self.uiCm = NGUIUtil:GetCameraByLayername("UI")
  self.sceneUiCm = NGUIUtil:GetCameraByLayername("Default")
  self.quitBtn = self:FindChild("quitBtn")
  self:AddButtonEvent("quitBtn", function(go)
    self:CloseSelf()
  end)
  self.traceinfo = self:FindGO("countdown"):GetComponent(UILabel)
  self.sizeWidget = self:FindComponent("Size", UIWidget)
  self.shootTimeContainer = self:FindGO("ShootTimeContainer")
end

function PickingReorderPanel:OnEnter()
  if not GameConfig.PickingRecordParams then
    self:CloseSelf()
  end
  self.paramID = nil
  local viewdata = self.viewdata.viewdata
  if viewdata and viewdata.questData and viewdata.questData.params then
    local id = viewdata.questData.params.paramID
    if id then
      self.paramID = id
    end
  end
  if not self.paramID then
    self.paramID = 1
  end
  if not GameConfig.PickingRecordParams[self.paramID] then
    self:CloseSelf()
  end
  self.PickingRecordParam = GameConfig.PickingRecordParams[self.paramID]
  if self.PickingRecordParam.EnableOutline then
    PostprocessManager.Instance:SetEffect("OutLinePP")
  end
  self.CompleteArrSlot = self.PickingRecordParam.CompleteSlot
  self.ArrSlot = {}
  for i = 1, #self.PickingRecordParam.InitSlot do
    self.ArrSlot[i] = self.PickingRecordParam.InitSlot[i]
  end
  self.savePos = {}
  for i = 1, #self.PickingRecordParam.InitSlot do
    local curSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(i)
    if curSelectNpc[1] ~= nil then
      local tempPos = curSelectNpc[1].assetRole.complete.transform.localPosition
      self.savePos[i] = tempPos
    end
  end
  self.shootTimeContainer:SetActive(true)
  self.traceinfo.text = viewdata.questData.traceInfo or ""
  self.condition = self:FindComponent("ConditionContainer", UIGrid)
  self.conditionList = UIGridListCtrl.new(self.condition, GunShootLocalConditionCell, "GunShootLocalConditionCell")
  self:UpdateConditionList()
  self:initCameraCfgData()
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  manager:ShowAll()
  FloatingPanel.Instance:SetMidMsgVisible(false)
  FunctionPet.Me():PetGiftActiveSelf(false)
  TimeTickManager.Me():CreateTick(0, 100, self.UpdateGunShootTargetSymbol, self, 1)
end

function PickingReorderPanel:OnExit()
  Game.Myself:Client_NoMove(false)
  TimeTickManager.Me():ClearTick(self)
  FunctionCameraEffect.Me():ResetCameraPlot()
  FunctionCameraEffect.Me():RestoreDefault(0, true)
  FloatingPanel.Instance:SetMidMsgVisible(true)
  if self.PickingRecordParam and self.PickingRecordParam.Filter then
    FunctionSceneFilter.Me():EndFilter(self.PickingRecordParam.Filter)
  end
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter)
  FunctionSceneFilter.Me():EndFilter(FunctionSceneFilter.AllEffectFilter)
  if self.defaultHide then
    for i = 1, #self.defaultHide do
      local fileterItem = self.defaultHide[i]
      FunctionSceneFilter.Me():EndFilter(fileterItem)
    end
  end
  Game.AreaTriggerManager:SetIgnore(false)
  if self.uiCemera then
    self.uiCemera.touchDragThreshold = self.originUiCmTouchDragThreshold
  end
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:ResetLODEffect()
  _PerformanceManager:ResetLOD()
  _PerformanceManager:SkinWeightHigh(false)
  local manager = Game.GameObjectManagers[Game.GameObjectType.RoomShowObject]
  manager:HideAll()
  ReusableTable.DestroyAndClearTable(self.vpRange)
  FunctionPet.Me():PetGiftActiveSelf(true)
  self.super.OnExit(self)
end

function PickingReorderPanel:initCameraCfgData()
  local viewdata = self.viewdata.viewdata
  if viewdata and viewdata.questData and viewdata.questData.params then
    local id = viewdata.questData.params.cameraId
    if id then
      printRed("PhotographPanel:from carrier cameraId:", id)
      self.cameraId = id
    end
  end
  Game.AreaTriggerManager:SetIgnore(true)
  local _PerformanceManager = Game.PerformanceManager
  _PerformanceManager:HighLODEffect()
  _PerformanceManager:LODHigh()
  _PerformanceManager:SkinWeightHigh(true)
  if not self.cameraId then
    self.cameraId = 9
  end
  FunctionCameraEffect.Me():DisableMove(true)
  local plots = FunctionCameraEffect._getCameraPlots(self.cameraId)
  local camera_config = plots[1].param
  local csToConfigDutationRatio = 2.18
  local duration = camera_config.Duration or 0
  local focusTrans = FunctionCameraEffect.Me():_getFocusByParam(plots[1].focus)
  FunctionCameraEffect.Me():DoFocusAndRotateTo(focusTrans, camera_config.ViewPort, camera_config.Rotation, duration / 1000 / csToConfigDutationRatio, camera_config.FieldOfView, LuaVector3.Zero(), false)
  local layer = LayerMask.NameToLayer("UI")
  if layer then
    self.uiCemera = UICamera.FindCameraForLayer(layer)
    if self.uiCemera then
      self.originUiCmTouchDragThreshold = self.uiCemera.touchDragThreshold
      self.uiCemera.touchDragThreshold = 1
    end
  end
  if self.PickingRecordParam.Filter then
    FunctionSceneFilter.Me():StartFilter(self.PickingRecordParam.Filter)
  end
end

function PickingReorderPanel:UpdateConditionList()
  local tmpList = ReusableTable.CreateArray()
  TableUtility.ArrayPushBack(tmpList, {
    point = self.totalShotPoint
  })
  self.conditionList:ResetDatas(tmpList)
  ReusableTable.DestroyAndClearArray(tmpList)
end

function PickingReorderPanel:CheckComplete()
  self.isComplete = true
  for i = 1, #self.CompleteArrSlot do
    if self.CompleteArrSlot[i] ~= self.ArrSlot[i] then
      self.isComplete = false
      break
    end
  end
  if self.isComplete == true then
    if self.PickingRecordParam.Effect then
      self:PlayUIEffect(self.PickingRecordParam.Effect, self.gameObject, true, function(go)
        if self.PickingRecordParam.EffectScale then
          go.gameObject.transform.localScale = LuaGeometry.GetTempVector3(self.PickingRecordParam.EffectScale, self.PickingRecordParam.EffectScale, self.PickingRecordParam.EffectScale)
        end
      end)
    end
    if self.PickingRecordParam.WaitTime then
      TimeTickManager.Me():CreateOnceDelayTick(self.PickingRecordParam.WaitTime * 1000, function(self)
        local questData = self.viewdata.viewdata.questData
        if questData ~= nil then
          QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        end
        self:CloseSelf()
      end, self, 0)
    else
      self:CloseSelf()
    end
  end
end

function PickingReorderPanel:SelectTargetChangeHandler(creature)
  if self.isComplete then
    return
  end
  if creature ~= nil and creature.body and creature.body.data and creature.body.data.uniqueid then
    if self.curSelectUniqueID == -1 then
      self.curSelectUniqueID = creature.body.data.uniqueid
      if self.PickingRecordParam.EnableOutline then
        local curSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.curSelectUniqueID)
        if curSelectNpc and curSelectNpc[1] then
          curSelectNpc[1].assetRole:AddOutlineProcess()
          local _, outlineColor = ColorUtil.TryParseHtmlString(self.PickingRecordParam.OutlineColor)
          curSelectNpc[1].assetRole.outline.OutlineColor = outlineColor
          curSelectNpc[1].assetRole.outline.enabled = true
        end
      end
    elseif self.curSelectUniqueID ~= creature.body.data.uniqueid then
      local curSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.curSelectUniqueID)
      local newSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(creature.body.data.uniqueid)
      if curSelectNpc[1] ~= nil and newSelectNpc[1] ~= nil then
        if self.PickingRecordParam.EnableOutline and curSelectNpc and curSelectNpc[1] then
          curSelectNpc[1].assetRole.outline.enabled = false
        end
        local tempPos = curSelectNpc[1].assetRole.complete.transform.localPosition
        curSelectNpc[1].assetRole.complete.transform.localPosition = newSelectNpc[1].assetRole.complete.transform.localPosition
        newSelectNpc[1].assetRole.complete.transform.localPosition = tempPos
        local slot = self.ArrSlot[self.curSelectUniqueID]
        self.ArrSlot[self.curSelectUniqueID] = self.ArrSlot[creature.body.data.uniqueid]
        self.ArrSlot[creature.body.data.uniqueid] = slot
      end
      self.curSelectUniqueID = -1
      Game.Myself:Client_LockTarget(nil)
      self:CheckComplete()
    elseif self.curSelectUniqueID == creature.body.data.uniqueid then
      local curSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.curSelectUniqueID)
      if curSelectNpc[1] ~= nil and curSelectNpc[1] ~= nil and self.PickingRecordParam.EnableOutline and curSelectNpc and curSelectNpc[1] then
        curSelectNpc[1].assetRole.outline.enabled = false
      end
      self.curSelectUniqueID = -1
    end
  end
end

function PickingReorderPanel:CloseSelf()
  if self.PickingRecordParam.EnableOutline then
    PostprocessManager.Instance:ClearEffect()
    if self.curSelectUniqueID then
      local curSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(self.curSelectUniqueID)
      if curSelectNpc and curSelectNpc[1] then
        curSelectNpc[1].assetRole.outline.enabled = false
      end
    end
  end
  for i = 1, #self.savePos do
    local curSelectNpc = NSceneNpcProxy.Instance:FindNpcByUniqueId(i)
    if curSelectNpc[1] ~= nil then
      curSelectNpc[1].assetRole.complete.transform.localPosition = self.savePos[i]
    end
  end
  Game.Myself:Client_LockTarget(nil)
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
    PickingReorderPanel.super.CloseSelf(self)
  end, self)
end
