SceneData = class("SceneData")
SceneData.LoadMode = {
  Default = 1,
  Illustration = 2,
  NewExplore = 3,
  QuickLoadWithoutProgress = 4,
  ThanatosLoading = 7036
}
SceneData.MapFeature = {TransformAtk = 0}

function SceneData.MapIDIsPVPMap(mapID)
  return Table_Map[mapID].PVPmap == 1
end

function SceneData:ctor(ChangeSceneUserCmd)
  self:Reset(ChangeSceneUserCmd)
end

function SceneData:ParseServerData(serverData)
  local pos
  if serverData.pos then
    pos = {}
    pos.x, pos.y, pos.z = serverData.pos.x, serverData.pos.y, serverData.pos.z
  end
  local invisiblexit = {}
  if serverData.invisiblexit then
    for i = 1, #serverData.invisiblexit do
      invisiblexit[i] = serverData.invisiblexit[i]
    end
  end
  local subScenes = {}
  if serverData.subScenes then
    TableUtility.ArrayShallowCopy(subScenes, serverData.subScenes)
  end
  return {
    mapID = serverData.mapID,
    mapName = serverData.mapName,
    dmapID = serverData.dmapID,
    preview = serverData.preview,
    pos = pos,
    invisiblexit = invisiblexit,
    imageid = serverData.imageid,
    subScenes = subScenes,
    mask = serverData.mask,
    cutscene = serverData.cutscene,
    isDScene = serverData.isDScene,
    sceneid = serverData.sceneid
  }
end

function SceneData:SetData(ChangeSceneUserCmd)
  self.serverData = self:ParseServerData(ChangeSceneUserCmd)
  self.mapID = ChangeSceneUserCmd.mapID
  self.mapStaticData = Table_Map[self.mapID]
  self.dungeonMapId = ChangeSceneUserCmd.dmapID
  self.mapName = "Scene" .. self:GetData().NameEn
  self.mapNameZH = ChangeSceneUserCmd.mapName
  self.invisiblexit = self.serverData.invisiblexit
  self.loadMode = SceneData.LoadMode.Default
  self.preview = ChangeSceneUserCmd.preview
  self.imageid = ChangeSceneUserCmd.imageid
  self.subScenes = self.serverData.subScenes
  self.mask = ChangeSceneUserCmd.mask
  self.cutscene = ChangeSceneUserCmd.cutscene
end

function SceneData:Reset(ChangeSceneUserCmd)
  self:SetData(ChangeSceneUserCmd)
  self.loaded = false
  self.param = nil
end

function SceneData:SetIllustrationLoadMode(pic)
  self.loadMode = SceneData.LoadMode.Illustration
  self.param = pic
end

function SceneData:SetNewExploreMapArea(mapData)
  self.loadMode = SceneData.LoadMode.NewExplore
  self.param = mapData
end

function SceneData:SetThanatosLoadMode(mapData)
  self.loadMode = SceneData.LoadMode.ThanatosLoading
  self.param = mapData
end

function SceneData:SetQuickLoadWithoutProgress(limitTime)
  self.loadMode = SceneData.LoadMode.QuickLoadWithoutProgress
  self.param = limitTime
end

function SceneData:GetData()
  return self.mapStaticData
end

function SceneData:IsPvPMap()
  return SceneData.MapIDIsPVPMap(self.mapID)
end

function SceneData:IsInDungeonMap()
  return self.dungeonMapId ~= 0
end

function SceneData:IsSameMapOrRaid(id)
  return self.mapID == id or self.dungeonMapId == id
end

function SceneData:IsCameraLocked()
  local cameraLock = self.mapStaticData.CameraLock or 0
  if 0 < cameraLock & 2 and 0 < cameraLock & 4 then
    return true
  end
  return false
end

function SceneData:IsFreeCameraLockVert()
  local cameraLock = self.mapStaticData.CameraLock or 0
  return 0 < cameraLock & 4
end

function SceneData:CanTransformAtk()
  local feature = self.mapStaticData.MapCompositeFunction
  if feature and BitUtil.valid(feature, SceneData.MapFeature.TransformAtk) then
    return BitUtil.band(feature, SceneData.MapFeature.TransformAtk) > 0
  end
  return false
end

function SceneData:CloneServerData()
  local data = {}
  TableUtility.TableShallowCopy(data, self.serverData)
  return data
end

function SceneData:UpdateExitPointState(id, state)
  local index = TableUtility.ArrayFindIndex(self.invisiblexit, id)
  if not state and index == 0 then
    table.insert(self.invisiblexit, id)
  elseif state and 0 < index then
    table.remove(self.invisiblexit, index)
  end
end

function SceneData:IsAfk()
  return self.mapStaticData.IsAfk == 1
end

function SceneData:GetMapNameEn()
  return self.mapStaticData.NameEn
end

function SceneData:IsMask()
  return self.mask
end

function SceneData:IsDScene()
  return self.serverData and self.serverData.isDScene or false
end

function SceneData:NeedWaitCutScene()
  return self.cutscene
end

function SceneData:ClearNeedWaitCutScene()
  self.cutscene = nil
  return true
end

function SceneData:Is_wutaiju()
  return self.dungeonMapId == 1900079
end
