autoImport("FloatMessage")
autoImport("CountDownMsg")
autoImport("FloatMessageEight")
autoImport("QueuePusherCtrl")
autoImport("QueueWaitCtrl")
autoImport("MidMsg")
autoImport("MidAlphaMsg")
autoImport("ShowyMsg")
autoImport("MaintenanceMsg")
autoImport("TypeNineFloatPanel")
autoImport("UIViewAchievementPopupTip")
autoImport("PrestigeExpTip")
FloatingPanel = class("FloatingPanel", ContainerView)
FloatingPanel.Instance = nil
FloatingPanel.ViewType = UIViewType.FloatLayer

function FloatingPanel:Init()
  self.pushCtrl = QueuePusherCtrl.new(self.gameObject, FloatMessage)
  self.pushCtrl.maxNum = 3
  self.pushCtrl.gap = -30
  self.pushCtrl.speed = 95
  self.pushCtrl.hideDelay = 0.5
  self.pushCtrl.hideDelayGrow = 0.4
  self.pushCtrl:SetStartPos(0, 60)
  self.pushCtrl:SetEndPos(0, 110)
  self.pushCtrl:SetDir(QueuePusherCtrl.Dir.Vertical)
  if FloatingPanel.Instance == nil then
    FloatingPanel.Instance = self
  end
  self.waitCtrl = QueueWaitCtrl.CreateAsArray(100)
  self.beforePanel = self:FindGO("BeforePanel")
  self.goUIViewAchievementPopupTip = self:FindGO("UIViewAchievementPopupTip", self.gameObject)
  self.effectContainer = self:FindGO("effectContainer")
  self.collider = self:FindGO("Collider")
  self:AddSubViews()
  self:AddEvtListener()
end

function FloatingPanel:AddSubViews()
  self.typeNineSubView = self:AddSubView("typeNineView", TypeNineFloatPanel)
  self.uiViewAchievementPopupTip = self:AddSubView("UIViewAchievementPopupTip", UIViewAchievementPopupTip)
  self.uiViewAchievementPopupTip:SetGameObject(self.goUIViewAchievementPopupTip)
  self.uiViewAchievementPopupTip:GetGameObjects()
  self.uiViewAchievementPopupTip:GetModelSet()
  self.uiViewAchievementPopupTip:LoadView()
end

function FloatingPanel:AddEvtListener()
  EventManager.Me():AddEventListener(ServiceEvent.PlayerMapChange, self.SceneLoadHandler, self)
  self:AddListenEvt(PlotStoryViewEvent.PlayUIEffect, self.HandlePlayUIEffect)
  self:AddListenEvt(ServiceEvent.WeatherWeatherChange, self.UpdateWeather)
  self:AddListenEvt(PlotStoryViewEvent.StartPlot, self.OnPlotStart)
  self:AddListenEvt(PlotStoryViewEvent.EndPlot, self.OnPlotEnd)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.SceneLoadFinish)
end

function FloatingPanel:HandlePlayUIEffect(note)
  local effect_path = note.body.path
  self:PlayUIEffect(effect_path, self.gameObject, true)
end

function FloatingPanel:SceneLoadHandler(note)
  if self.countDownMsg ~= nil and self.countDownMsg.DestroyWhenLoadScene then
    self:RemoveCountDown(self.countDownMsg.data.id)
  end
  self:RemoveMidMsg()
  ComboCtl.Instance:Clear()
  self:RemoveMapName()
  self:ClearZoneCountDown()
end

function FloatingPanel:SceneLoadFinish(note)
  self:TryCreateBWLoadingEffect()
end

function FloatingPanel:OnPlotStart()
  self.inPQTL = true
  self:DestroyMapPfb()
end

function FloatingPanel:OnPlotEnd()
  self.inPQTL = false
end

function FloatingPanel:SetStartPos(pos)
  self.pushCtrl:SetStartPos(pos.start.x, pos.start.y)
  self.pushCtrl:SetEndPos(pos.endPos.x, pos.endPos.y)
end

function FloatingPanel:ResetDefaultPos()
  self.pushCtrl:SetStartPos(0, 60)
  self.pushCtrl:SetEndPos(0, 110)
end

function FloatingPanel:FloatMiddleBottom(sortID, text)
  self.typeNineSubView:AddSysMsg(sortID, text)
end

function FloatingPanel:ClearFloatMiddleBottom()
  self.typeNineSubView:Clear()
end

function FloatingPanel:TryFloatMessageByText(text, cellType)
  local cell = self:GetFloatCell(cellType)
  cell:SetMsg(text)
  self.pushCtrl:AddCell(cell)
end

function FloatingPanel:FloatTypeEightMsgByData(data, startPos, offset)
  local cell = FloatMessageEight.new(self.gameObject, data, startPos, offset)
  self.waitCtrl:AddCell(cell, 0.5)
end

function FloatingPanel:StopFloatTypeEightMsg()
  self.waitCtrl:Clear()
end

function FloatingPanel:TryFloatMessageByTextWithTransparentBg(text)
  local cell = self:GetFloatCellWithTransparentBg()
  cell:SetMsgCenterAlign(text)
  self.pushCtrl:AddCell(cell)
end

function FloatingPanel:GetFloatCellWithTransparentBg()
  local floatMsg = FloatMessage.new(self.gameObject)
  floatMsg:Hide(floatMsg.bg.gameObject)
  return floatMsg
end

function FloatingPanel:TryFloatMessageByData(data)
  self.pushCtrl:AddData(data)
end

function FloatingPanel:GetFloatCell(cellType)
  return FloatMessage.new(self.gameObject, cellType)
end

local displaytime = GameConfig.Weather and GameConfig.Weather.display_time

function FloatingPanel:ShowMapName(name1, name2, hideDetail, ignoreClickClose, prefabName, displayDuration)
  if self.inPQTL then
    return
  end
  prefabName = prefabName or "tip/MapNameTip"
  if self.lastMapPfbName ~= prefabName then
    self:DestroyMapPfb()
    self.lastMapPfbName = prefabName
  end
  local clickClose
  if self:ObjIsNil(self.mapPfb) then
    self.mapPfb = self:LoadPreferb(prefabName, self.gameObject)
    local maplab1 = self:FindComponent("MapLabel1", UILabel, self.mapPfb)
    maplab1.text = name1 or ""
    local maplab2 = self:FindComponent("MapLabel2", UILabel, self.mapPfb)
    maplab2.text = name2
    self.weathericon = self:FindComponent("weather", UISprite, self.mapPfb)
    local weatherid = ServiceWeatherProxy.Instance.weatherID
    self.weathericon.spriteName = Table_Weather[weatherid] and Table_Weather[weatherid].Icon or ""
    local line = self:FindComponent("line", UILabel, self.mapPfb)
    local zone = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
    line.text = zone
    local timelabel = self:FindChild("time", self.mapPfb):GetComponent(UILabel)
    timelabel.text = ClientTimeUtil.GetNowAMPM() .. "   " .. ClientTimeUtil.GetNowHourMinStr()
    clickClose = self.mapPfb:GetComponent(CloseWhenClickOtherPlace)
    if clickClose then
      function clickClose.callBack(...)
        self.mapPfb = nil
        
        self.weathericon = nil
      end
    end
    self.weathericon = self:FindChild("weather", self.mapPfb):GetComponent(UISprite)
    local duration = displayDuration or displaytime
    TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function(owner, deltaTime)
      self:DestroyMapPfb()
    end, self)
  end
  if clickClose then
    clickClose.enabled = not ignoreClickClose
    local collider = self.mapPfb:GetComponent(BoxCollider)
    if collider then
      collider.enabled = not ignoreClickClose
    end
  end
  local rainbow = self:FindComponent("rainbow", UISprite, self.mapPfb)
  rainbow.alpha = 0
  self:UpdateMapName(name1, name2, hideDetail)
end

function FloatingPanel:UpdateMapName(name1, name2, hideDetail)
  local maplab1 = self:FindChild("MapLabel1", self.mapPfb):GetComponent(UILabel)
  maplab1.text = name1
  local maplab2 = self:FindChild("MapLabel2", self.mapPfb):GetComponent(UILabel)
  maplab2.text = name2
  local detailGO = self:FindChild("info", self.mapPfb)
  if hideDetail then
    detailGO:SetActive(false)
  else
    detailGO:SetActive(true)
    local weatherid = ServiceWeatherProxy.Instance.weatherID
    self.weathericon.spriteName = Table_Weather[weatherid] and Table_Weather[weatherid].Icon or ""
    local line = self:FindChild("line", self.mapPfb):GetComponent(UILabel)
    local zone = ChangeZoneProxy.Instance:ZoneNumToString(MyselfProxy.Instance:GetZoneId())
    line.text = zone
    local timelabel = self:FindChild("time", self.mapPfb):GetComponent(UILabel)
    timelabel.text = ClientTimeUtil.GetNowAMPM() .. "   " .. ClientTimeUtil.GetNowHourMinStr()
    local cameraLabel = self:FindChild("cameralabel", self.mapPfb):GetComponent(UILabel)
    local curCameraMode = FunctionCameraEffect.Me():GetCurCameraMode()
    if curCameraMode == FunctionCameraEffect.CameraMode.Free then
      cameraLabel.text = ZhString.Real3DCtl
    elseif curCameraMode == FunctionCameraEffect.CameraMode.FreeHori then
      cameraLabel.text = ZhString.Half3DCtl
    else
      cameraLabel.text = ZhString.LockCameraCtl
    end
  end
end

function FloatingPanel:DestroyMapPfb()
  if not self:ObjIsNil(self.mapPfb) then
    GameObject.Destroy(self.mapPfb)
    self.mapPfb = nil
    self.weathericon = nil
  end
end

function FloatingPanel:ShowRainbowMsg(msg)
  if self:ObjIsNil(self.mmPfb) then
    self.mmPfb = self:LoadPreferb("tip/MapMsgTip", self.gameObject)
    local maplab1 = self:FindComponent("MapLabel1", UILabel, self.mmPfb)
    maplab1.text = ""
    local maplab2 = self:FindComponent("MapLabel2", UILabel, self.mmPfb)
    maplab2.text = msg
    local clickClose = self.mmPfb:GetComponent(CloseWhenClickOtherPlace)
    if clickClose then
      function clickClose.callBack(...)
        self.mmPfb = nil
      end
    end
    TimeTickManager.Me():CreateOnceDelayTick(displaytime * 1000, function(owner, deltaTime)
      if not self:ObjIsNil(self.mmPfb) then
        GameObject.Destroy(self.mmPfb)
        self.mmPfb = nil
      end
    end, self)
  end
  local maplab2 = self:FindComponent("MapLabel2", UILabel, self.mmPfb)
  maplab2.text = msg
end

function FloatingPanel:FloatingMidEffect(effectid)
  if effectid == 76 then
    local menuId = GameConfig.SystemOpen_MenuId.BigCatInvade
    if menuId and not FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
      return
    end
  end
  local effectName = effectid and EffectMap.UIEffect_IdMap[effectid]
  if effectName then
    self:PlayUIEffect(effectName, self.beforePanel, true, FloatingPanel._HandleMidEffectShow, self)
  end
end

function FloatingPanel:FloatingMidEffectByFullPath(fullPath)
  self:PlayEffectByFullPath(fullPath, self.beforePanel, true, FloatingPanel._HandleMidEffectShow, self)
end

function FloatingPanel:HandleMidEffectShow(effectHandle)
  local effectGO = effectHandle.gameObject
  local panels = UIUtil.GetAllComponentsInChildren(effectGO, UIPanel, true)
  if #panels == 0 then
    return
  end
  local upPanel = Game.GameObjectUtil:FindCompInParents(effectGO, UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  local startDepth = 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function FloatingPanel._HandleMidEffectShow(effectHandle, owner)
  if effectHandle and owner then
    owner:HandleMidEffectShow(effectHandle)
  end
end

function FloatingPanel:PlayMidEffect(effectPath, callBack, isLoop, isCollider)
  if isLoop then
    if isCollider == nil then
      isCollider = false
    end
    if self.collider then
      self.collider:SetActive(isCollider)
    end
  end
  return self:PlayUIEffect(effectPath, self.beforePanel, not isLoop, self._HandleMidEffectCreate_Mediator, {self, callBack})
end

function FloatingPanel:PlayMidEffectOnContainer(effectPath, callBack, isLoop)
  return self:PlayUIEffect(effectPath, self.effectContainer, not isLoop, self._HandleMidEffectCreate_Mediator, {self, callBack})
end

function FloatingPanel:DestroyUIEffects()
  if self.collider then
    self.collider:SetActive(false)
  end
  FloatingPanel.super.DestroyUIEffects(self)
end

function FloatingPanel._HandleMidEffectCreate_Mediator(effectHandle, param)
  local owner, callBack = param[1], param[2]
  owner:_HandleMidEffectCreate(effectHandle)
  if callBack then
    callBack(effectHandle)
  end
end

function FloatingPanel:_HandleMidEffectCreate(effectHandle)
  local go = effectHandle.gameObject
  local widgets = UIUtil.GetAllComponentsInChildren(go, UIWidget)
  for i = 1, #widgets do
    widgets[i].gameObject:SetActive(false)
    widgets[i].gameObject:SetActive(true)
  end
end

function FloatingPanel:ShowPowerUp(upvalue, effectid, tip)
  local effectid = effectid or EffectMap.UI.Score_Up
  local tip = tip or ZhString.Float_PlayerScoreUp
  local rid = ResourcePathHelper.EffectUI(effectid)
  local anchorDown = self:FindGO("Anchor_Down")
  local scoreup = self:ReInitEffect(rid, anchorDown, LuaGeometry.GetTempVector3(0, 180), function(go)
  end)
  local frome = 0
  local to = upvalue or 200
  local time = math.max(0.7, (to - frome) * 0.005)
  time = math.min(time, 1.5)
  local label = self:FindGO("Label", scoreup):GetComponent(UILabel)
  local anim = scoreup:GetComponent(Animator)
  TimeTickManager.Me():ClearTick(self, 100)
  TimeTickManager.Me():CreateTickFromTo(0, frome, to, time * 1000, function(owner, deltaTime, curValue)
    label.text = tip .. math.floor(curValue)
  end, self):SetCompleteFunc(function(owner, id)
    TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
      anim:Play("Score_up2", -1, 0)
      local autodestroy = scoreup:AddComponent(EffectAutoDestroy)
      
      function autodestroy.OnFinish()
        scoreup = nil
      end
    end, self, 100)
  end)
end

function FloatingPanel:ShowManualUp()
  AudioUtil.Play2DRandomSound(AudioMap.Maps.AdventureLevelUp)
  self:PlayUIEffect(EffectMap.UI.UIAdventureLv_up, self.beforePanel, true, FloatingPanel.UIAdventureLv_upEffectHandle, self)
end

function FloatingPanel.UIAdventureLv_upEffectHandle(effectHandle, owner)
  if owner then
    local effectGO = effectHandle.gameObject
    effectGO.transform.localPosition = LuaGeometry.GetTempVector3(0, 100, 0)
    local shuzi = owner:FindGO("shuzi", effectGO)
    Game.GameObjectUtil:DestroyAllChildren(shuzi)
    local grid = shuzi:GetComponent(UIGrid)
    grid = grid or shuzi:AddComponent(UIGrid)
    if grid then
      grid.cellWidth = 19
      grid.pivot = UIWidget.Pivot.Center
      local manualLevel = AdventureDataProxy.Instance:getManualLevel()
      manualLevel = StringUtil.StringToCharArray(tostring(manualLevel))
      local layer = shuzi.layer
      local atlas = RO.AtlasMap.GetAtlas("NewCom")
      for i = 1, #manualLevel do
        local obj = GameObject("tx")
        obj.layer = layer
        obj.transform:SetParent(grid.transform, false)
        obj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
        local sprite = obj:AddComponent(UISprite)
        sprite.atlas = atlas
        sprite.depth = 200
        sprite.spriteName = string.format("txt_%d", manualLevel[i])
        sprite:MakePixelPerfect()
      end
      grid:Reposition()
    end
  end
end

function FloatingPanel:AddCountDown(text, data)
  if self.countDownMsg == nil or self.countDownMsg and self.countDownMsg.hasBeenDestroyed then
    self.countDownMsg = CountDownMsg.new(self.gameObject)
  end
  self.countDownMsg:SetData(text, data)
  local inRaid = Game.MapManager:IsRaidMode()
  self.countDownMsg.DestroyWhenLoadScene = inRaid
end

function FloatingPanel:RemoveCountDown(id)
  if self.countDownMsg and not self.countDownMsg.hasBeenDestroyed and self.countDownMsg.data.id == id then
    self.countDownMsg:DestroySelf()
  end
  self.countDownMsg = nil
end

function FloatingPanel:DestroyCountDown()
  if self.countDownMsg then
    self.countDownMsg:DestroySelf()
  end
  self.countDownMsg = nil
end

function FloatingPanel:SetCountDownRemoveOnChangeScene(id, value)
  if self.countDownMsg and not self.countDownMsg.hasBeenDestroyed and self.countDownMsg.data.id == id then
    self.countDownMsg.DestroyWhenLoadScene = value
  end
end

function FloatingPanel:RecvUpdateZoneMapCmd(serverdata)
  if self.zoneMapInfo == nil then
    self.zoneMapInfo = {}
  end
  local data
  for i = 1, #serverdata.zones do
    data = serverdata.zones[i]
    self.zoneMapInfo[data.map_zone] = data.param
    if self.zoneMapID == data.map_zone then
      local zoneid, msgid, type = self.zoneMapID, self.zoneMsgID, self.zoneType
      self:RemoveZoneMap(zoneid)
      self:AddZoneMap(zoneid, msgid, type)
    end
  end
  for i = 1, #serverdata.del_zones do
    data = serverdata.del_zones[i]
    self.zoneMapInfo[data] = nil
    if self.zoneMapID == data then
      self:RemoveZoneMap(self.zoneMapID)
    end
  end
end

function FloatingPanel:AddZoneMap(zoneid, msgid, type)
  if self.zoneMapID == zoneid and self.zoneMsgID == msgid and self.zoneType == type then
    return
  end
  self.zoneMapID = zoneid
  self.zoneMsgID = msgid
  self.zoneType = type
  if self.zoneMapInfo == nil then
    return
  end
  local param = self.zoneMapInfo[zoneid]
  if param == nil then
    return
  end
  local staticData = Table_Sysmsg[msgid]
  if staticData == nil then
    return
  end
  if type == 1 then
    local data = {}
    data.id = zoneid
    data.time = param - ServerTime.CurServerTime() / 1000
    data.decimal = 0
    self:AddCountDown(staticData.Text, data)
  elseif type == 2 then
    local data = {}
    data.text = string.format(staticData.Text, param)
    local midMsg = self:GetMidMsg()
    midMsg:SetData(data)
  end
end

function FloatingPanel:RemoveZoneMap(zoneid)
  if self.zoneMapID ~= zoneid then
    return
  end
  if self.zoneType == 1 then
    self:RemoveCountDown(zoneid)
  elseif self.zoneType == 2 then
    self:RemoveMidMsg()
  end
  self.zoneMapID = nil
  self.zoneMsgID = nil
  self.zoneType = nil
end

function FloatingPanel:ClearZoneCountDown()
  if self.zoneMapID ~= nil then
    self:RemoveZoneMap(self.zoneMapID)
  end
end

function FloatingPanel:GetMidMsg()
  self:RemoveMidMsg()
  self.midMsg = MidMsg.new(self.gameObject)
  return self.midMsg
end

function FloatingPanel:RemoveMidMsg()
  if self.midMsg then
    self.midMsg:Exit()
    self.midMsg = nil
  end
end

function FloatingPanel:SetMidMsgVisible(istrue)
  if self.midMsg then
    self.midMsg.gameObject:SetActive(istrue)
  end
end

function FloatingPanel:ShowMidAlphaMsg(text)
  if not self.midAlphaMsg then
    self.midAlphaMsg = MidAlphaMsg.new(self.gameObject)
  end
  self.midAlphaMsg:SetData(text)
  self.midAlphaMsg:SetExitCall(self.MidAlphaMsgEnd, self)
end

function FloatingPanel:MidAlphaMsgEnd()
  self.midAlphaMsg = nil
end

function FloatingPanel:FloatShowyMsg(text)
  if self.showyMsg then
    self.showyMsg:Exit()
  end
  self.showyMsg = ShowyMsg.new(self.gameObject)
  self.showyMsg:SetExitCall(function()
    self.showyMsg = nil
  end)
  local data = {text = text}
  self.showyMsg:SetData(data)
  self.showyMsg:Enter()
end

local tempArgs = {}

function FloatingPanel:CloseMaintenanceMsg()
  if self.maintenanceMsg then
    self.maintenanceMsg:Exit()
  end
end

function FloatingPanel:ShowMaintenanceMsg(title, text, remark, buttonlab, picPath, confirmCall)
  self:CloseMaintenanceMsg()
  self.maintenanceMsg = MaintenanceMsg.new(self.gameObject)
  self.maintenanceMsg:SetExitCall(function()
    self.maintenanceMsg = nil
  end)
  TableUtility.TableClear(tempArgs)
  tempArgs[1] = title
  tempArgs[2] = text
  tempArgs[3] = remark
  tempArgs[4] = buttonlab
  tempArgs[5] = picPath
  tempArgs[6] = confirmCall
  self.maintenanceMsg:SetData(tempArgs)
  return self.maintenanceMsg
end

function FloatingPanel:UpdateWeather()
  if not self:ObjIsNil(self.mapPfb) and not self:ObjIsNil(self.weathericon) then
    local weatherid = ServiceWeatherProxy.Instance.weatherID
    local atlas = RO.AtlasMap.GetAtlas("Weather")
    self.weathericon.atlas = atlas
    self.weathericon.spriteName = Table_Weather[weatherid] and Table_Weather[weatherid].Icon or ""
  end
end

function FloatingPanel:RemoveMapName()
  if not self:ObjIsNil(self.mapPfb) then
    GameObject.Destroy(self.mapPfb)
    self.mapPfb = nil
    self.weathericon = nil
  end
end

function FloatingPanel:UpdateQuestFinishPopUp(text)
  local effect = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.EffectUI(EffectMap.UI.WorldQuestFinish), self.beforePanel)
  local label = effect:GetComponent(UILabel)
  if label and text then
    label.text = text
  end
end

function FloatingPanel:AddCustomButton(event, pos, size)
  local go = GameObject("button")
  go.transform:SetParent(self.beforePanel.transform, false)
  if pos then
    LuaGameObject.SetLocalPositionGO(go, pos[1], pos[2], 0)
  end
  local widget = go:AddComponent(UIWidget)
  if size then
    widget.width = size[1]
    widget.height = size[2]
  end
  NGUITools.AddWidgetCollider(go)
  self:AddClickEvent(go, event)
end

function FloatingPanel:ShowPrestigeUpdate(data)
  local prefabName = "tip/PrestigeExpTip"
  if not self.prestigeTip then
    self.prestigeTip = PrestigeExpTip.new(self.gameObject)
  end
  self.prestigeTip:ShowInfo(data)
  TimeTickManager.Me():ClearTick(self, 2)
  local previousValue = data.origin_value
  TimeTickManager.Me():CreateOnceDelayTick(previousValue and 7500 or 3000, function(owner, deltaTime)
    if self.prestigeTip then
      self.prestigeTip:DestroySelf()
      self.prestigeTip = nil
    end
  end, self, 2)
end

function FloatingPanel:TryCreateBWLoadingEffect()
  local map_id = Game.MapManager:GetMapID()
  local effect_path = map_id and GameConfig.BigMapUIEffect and GameConfig.BigMapUIEffect[map_id]
  if effect_path then
    local effect = self.bwLoadingEffect
    if effect ~= nil then
      if effect:GetPath() == effect_path then
        return
      else
        self:DestroyBigWorldLoadingEffect()
      end
    end
    effect = self:PlayUIEffect(effect_path, self.gameObject)
    effect:SetActive(false)
    self.bwLoadingEffect = effect
  else
    self:DestroyBigWorldLoadingEffect()
  end
end

function FloatingPanel:DestroyBigWorldLoadingEffect()
  if not self.bwLoadingEffect then
    return
  end
  self.bwLoadingEffect:Destroy()
  self.bwLoadingEffect = nil
end

function FloatingPanel:HandlePlayBWMapTransferEffect()
  if not self.bwLoadingEffect then
    self:TryCreateBWLoadingEffect()
  end
  local effect = self.bwLoadingEffect
  if effect then
    effect:SetActive(true)
    effect:ResetAction("state1001", 0)
  end
  self.loadingtime = UnityTime
  TimeTickManager.Me():ClearTick(self, 3)
  TimeTickManager.Me():ClearTick(self, 4)
  TimeTickManager.Me():CreateOnceDelayTick(3000, self.HandleEndBWTransferEffect, self, 3)
end

function FloatingPanel:HandleEndBWTransferEffect()
  if self.loadingtime == nil then
    return
  end
  TimeTickManager.Me():ClearTick(self, 3)
  self.loadingtime = nil
  local effect = self.bwLoadingEffect
  if effect ~= nil then
    effect:ResetAction("state2001", 0)
  end
  TimeTickManager.Me():ClearTick(self, 4)
  TimeTickManager.Me():CreateOnceDelayTick(1000, function()
    if self.bwLoadingEffect then
      self.bwLoadingEffect:SetActive(false)
    end
  end, self, 4)
end
