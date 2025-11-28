local SceneProxy = class("SceneProxy", pm.Proxy)
autoImport("SceneData")
SceneLoader = autoImport("SceneLoader")
SceneProxy.Instance = nil
SceneProxy.NAME = "SceneProxy"
SceneProxy.SceneState = {
  None = 1,
  Loading = 2,
  Loaded = 3,
  Entered = 4
}
local guildRaidType = 13

function SceneProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SceneProxy.NAME
  if SceneProxy.Instance == nil then
    SceneProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.currentScene = nil
  self.LoadingScenes = {}
  self.sceneLoader = SceneLoader.new()
  self.state = SceneProxy.SceneState.None
end

function SceneProxy:onRegister()
end

function SceneProxy:onRemove()
end

function SceneProxy:GetMapInfo(id)
  return Table_Map[id]
end

function SceneProxy:IsSameMapOrRaid(id)
  if self.currentScene then
    return self.currentScene:IsSameMapOrRaid(id)
  end
  return false
end

function SceneProxy:IsPvPScene()
  if self.currentScene then
    return self.currentScene:IsPvPMap()
  end
  return false
end

function SceneProxy:IsDungeonScene()
  return self.currentScene:IsInDungeonMap()
end

function SceneProxy:GetCurMapID()
  return self.currentScene.mapID
end

function SceneProxy:GetCurRaidID()
  return self.currentScene and self.currentScene.dungeonMapId
end

function SceneProxy:CloneSceneData()
  if self.currentScene then
    return self.currentScene:CloneServerData()
  end
end

function SceneProxy:SyncLoad(name, callBack)
  self.sceneLoader:SyncLoad(name, callBack)
end

function SceneProxy:StartChangeScene(sceneInfo)
  local subSceneInterval, subSceneYAxisOffset
  local subScenes = sceneInfo.subScenes
  if subScenes ~= nil and 0 < #subScenes then
    local raidID = sceneInfo.dungeonMapId
    local data = GameConfig.Roguelike.RaidInfo[raidID]
    subSceneInterval = data and data.SubSceneInterval or 0
    subSceneXAxisOffset = data and data.XAxisOffset
    subSceneYAxisOffset = data and data.YAxisOffset
    subSceneZAxisOffset = data and data.ZAxisOffset
  end
  self.sceneLoader:StartLoad(sceneInfo.mapName, subScenes, subSceneInterval, subSceneXAxisOffset, subSceneYAxisOffset, subSceneZAxisOffset)
end

function SceneProxy:GetFirstNeedLoad()
  return self.LoadingScenes[1]
end

function SceneProxy:GetLastNeedLoad()
  return self.LoadingScenes[#self.LoadingScenes]
end

function SceneProxy:RemoveNeedLoad(index)
  self.LoadingScenes[index] = nil
end

function SceneProxy:EnableLoaderFadeBGM(value)
  self.sceneLoader:EnableFadeBGM(value)
end

function SceneProxy:StartLoadFirst()
  if #self.LoadingScenes > 0 then
    self.sceneLoader.isLoading = true
    self.state = SceneProxy.SceneState.Loading
    self.sceneLoader:RestoreLimitLoadTime()
    if self.currentScene == nil then
      local sceneData = SceneData.new(self.LoadingScenes[1])
      self.currentScene = sceneData
      self.lastMapID = self.currentScene.mapID
    else
      local lastDmap = self.currentScene.dungeonMapId
      self.lastMapID = self.currentScene.mapID
      self.currentScene:Reset(self.LoadingScenes[1])
      local nowDmap = self.currentScene.dungeonMapId
      local lastMapRaid = Table_MapRaid[lastDmap]
      local nowMapRaid = Table_MapRaid[nowDmap]
      local nowMapID = self.currentScene.mapID
      local lastMap = Table_Map[self.lastMapID]
      local nowMap = Table_Map[nowMapID]
      if nowMapRaid ~= nil and lastMapRaid ~= nil then
        if lastMap.UniqueLoading and nowMap.UniqueLoading and nowMap.UniqueLoading == SceneData.LoadMode.ThanatosLoading then
          self.currentScene:SetThanatosLoadMode()
        elseif lastMapRaid.Type == nowMapRaid.Type and nowMapRaid.Type == guildRaidType then
          self.currentScene:SetQuickLoadWithoutProgress(-1)
          self.sceneLoader:SetLimitLoadTime(-1, 100)
        end
      end
    end
    local pic = FunctionQuest.Me():getIllustrationQuest(self.currentScene.mapID)
    if pic then
      self.currentScene:SetIllustrationLoadMode(pic)
    else
      local mapArea = WorldMapProxy.Instance:GetMapAreaDataByMapId(self.currentScene.mapID)
      if mapArea and mapArea.isNew then
        self.currentScene:SetNewExploreMapArea(mapArea)
      end
    end
    self:OpenCurrentLoadingView()
    self:sendNotification(LoadEvent.SceneFadeOut)
  end
end

function SceneProxy:ASyncLoad()
  local sceneInfo = self.currentScene
  self:StartChangeScene(sceneInfo)
  self:sendNotification(LoadEvent.StartLoadScene, sceneInfo.serverData)
end

function SceneProxy:OpenCurrentLoadingView()
  if SwitchRolePanel and SwitchRolePanel.isSwitchRoleIng then
    return
  end
  if self.currentScene.loadMode == SceneData.LoadMode.Default then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoadingViewDefault
    })
  elseif self.currentScene.loadMode == SceneData.LoadMode.Illustration then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoadingViewIllustration,
      viewdata = self.currentScene.param
    })
  elseif self.currentScene.loadMode == SceneData.LoadMode.NewExplore then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoadingViewNewExplore,
      viewdata = self.currentScene.param
    })
  elseif self.currentScene.loadMode == SceneData.LoadMode.QuickLoadWithoutProgress then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoadingViewQuickWithoutProgress,
      viewdata = self.currentScene.param
    })
  elseif self.currentScene.loadMode == SceneData.LoadMode.ThanatosLoading then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoadingViewThanatos,
      viewdata = self.currentScene.param
    })
  end
end

function SceneProxy:EnterScene()
  self.state = SceneProxy.SceneState.Entered
end

function SceneProxy:IsInScene()
  return self.state == SceneProxy.SceneState.Entered
end

function SceneProxy:IsLoading()
  return self.state ~= SceneProxy.SceneState.Entered and self.state ~= SceneProxy.SceneState.None
end

function SceneProxy:CanLoad()
  return (self:IsLoading() == false and #self.LoadingScenes > 0) == true
end

function SceneProxy:IsCurrentScene(sceneInfo)
  local currentScene = self.currentScene
  if currentScene == nil then
    return false
  end
  local mapID = sceneInfo.mapID
  if mapID == nil then
    return false
  end
  local mapRaid = Table_MapRaid[mapID]
  if mapRaid and mapRaid.SameMapReBoot == 1 then
    return false
  end
  if not self:_CheckSameSceneByName(mapID) then
    if mapID ~= currentScene.mapID then
      return false
    end
    if sceneInfo.dmapID ~= currentScene.dungeonMapId then
      return false
    end
  end
  if SceneData.MapIDIsPVPMap(mapID) ~= currentScene:IsPvPMap() then
    return false
  end
  if sceneInfo.subScenes ~= nil and #sceneInfo.subScenes > 0 then
    return false
  end
  return true
end

function SceneProxy:_CheckSameSceneByName(toMapID)
  local currentScene = self.currentScene
  if currentScene == nil then
    return false
  end
  local mapID = currentScene.mapID
  if mapID == nil then
    return false
  end
  local config = GameConfig.SchoolRule
  if config == nil then
    return false
  end
  local data = config[mapID]
  if data == nil then
    return false
  end
  if data.tomap ~= toMapID then
    return false
  end
  local map = Table_Map[toMapID]
  if map == nil then
    return false
  end
  return map.NameEn == currentScene:GetMapNameEn()
end

function SceneProxy:IsSameScene(sceneInfo1, sceneInfo2)
  return (sceneInfo1 ~= nil and sceneInfo1.mapID == sceneInfo2.mapID and sceneInfo1.dmapID == sceneInfo2.dmapID and SceneData.MapIDIsPVPMap(sceneInfo1.mapID) == SceneData.MapIDIsPVPMap(sceneInfo2.mapID)) == true
end

function SceneProxy:LoadingProgress()
  if self.sceneLoader == nil then
    return 0
  else
    return self.sceneLoader.Progress
  end
end

function SceneProxy:SetLoadFinish(callback)
  self.sceneLoader:SetDoneCallBack(callback)
end

function SceneProxy:AddLoadingScene(sceneInfo)
  if #self.LoadingScenes > 1 then
    self.LoadingScenes[2] = sceneInfo
  else
    table.insert(self.LoadingScenes, sceneInfo)
  end
  return true
end

function SceneProxy:IsCurMapCameraLocked()
  return self.currentScene and self.currentScene:IsCameraLocked() or false
end

function SceneProxy:IsCurMapFreeCameraLockVert()
  return self.currentScene and self.currentScene:IsFreeCameraLockVert() or false
end

function SceneProxy:FinishLoadScene(sceneInfo)
  self.currentScene:Reset(sceneInfo)
  self.currentScene.loaded = true
  self.state = SceneProxy.SceneState.Loaded
  for _, o in pairs(self.LoadingScenes) do
    if o.mapID == sceneInfo.mapID then
      table.remove(self.LoadingScenes, _)
      break
    end
  end
  return self.LoadingScenes
end

function SceneProxy:LoadedSceneAwaked()
  self.sceneLoader:SceneAwake()
end

function SceneProxy:SetGameTime(data)
end

function SceneProxy:IsCurMapAfk()
  return self.currentScene and self.currentScene:IsAfk() or false
end

function SceneProxy:IsMask()
  return self.currentScene and self.currentScene:IsMask() or false
end

function SceneProxy:IsNeedWaitCutScene()
  return self.currentScene and (self.currentScene:NeedWaitCutScene() or self.currentScene:Is_wutaiju()) or false
end

function SceneProxy:IsNeedWaitCutScene_NoDelayClose()
  return self.currentScene and self.currentScene:Is_wutaiju() or false
end

function SceneProxy:ClearNeedWaitCutScene()
  return self.currentScene and self.currentScene:ClearNeedWaitCutScene() or false
end

function SceneProxy:IsCurForbidCameraMode(mode)
  if not self.currentScene then
    return false
  end
  local cameraLock = self.currentScene.mapStaticData.CameraLock or 0
  if 0 < cameraLock & 1 << mode - 1 then
    return true
  end
  return false
end

return SceneProxy
