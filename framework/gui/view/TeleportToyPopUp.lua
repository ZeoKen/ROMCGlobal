TeleportToyPopUp = class("TeleportToyPopUp", ContainerView)
TeleportToyPopUp.ViewType = UIViewType.NormalLayer
autoImport("TeleportToyClickMap")

function TeleportToyPopUp:Init()
  self.data = self.viewdata.viewdata
  self.transmitterButtons = {}
  self.mapsize = {}
  self:FindObjs()
  self:AddEvts()
  self:LoadView()
end

function TeleportToyPopUp:FindObjs()
  local miniMapWindowGO = self:FindGO("MapWindow")
  self.minimapWindow = TeleportToyClickMap.new(miniMapWindowGO)
  self.minimapWindow:AddMapClick()
  self.objBtnTransmit = self:FindGO("btnTransmit")
end

function TeleportToyPopUp:AddEvts()
  self:AddClickEvent(self.objBtnTransmit, function()
    self:ClickTransmit()
  end)
  self:AddClickEvent(self:FindGO("btnClose"), function()
    self:CloseSelf()
  end)
end

function TeleportToyPopUp:LoadView()
  local viewData = self.viewdata.viewdata
  self.curMapID = Game.MapManager:GetMapID()
  if Table_Map[self.curMapID] then
    self.mapdata = Table_Map[self.curMapID]
  else
    redlog("Map表不存在id" .. self.curMapID)
  end
  self:GetSceneInfo(self.curMapID)
  local map2d = Game.Map2DManager:GetMap2D()
  self.minimapWindow:UpdateMapTexture(self.mapdata, LuaGeometry.GetTempVector3(325, 325), self.sceneInfo, map2d, 0)
end

function TeleportToyPopUp:GetSceneInfo(mapid)
  local sceneName = Table_Map[mapid].NameEn
  local sceneInfoName = "Scene_" .. sceneName
  local sceneInfo = autoImport(sceneInfoName)
  local scenePartUInfo
  if MapManager.Mode.PVE == mode then
    scenePartInfo = sceneInfo.PVE
  elseif MapManager.Mode.PVP == mode then
    scenePartInfo = sceneInfo.PVP
  elseif MapManager.Mode.Raid == mode then
    scenePartInfo = sceneInfo.Raids[raidID]
  end
  if nil ~= scenePartInfo then
    Game.DoPreprocess_ScenePartInfo(scenePartInfo, sceneInfoName)
  end
  self.sceneInfo = scenePartInfo
end

function TeleportToyPopUp:ClickTransmit()
  helplog("点击了传送")
  local pos = self.minimapWindow.savedPos
  if not pos then
    redlog("未选定目标点")
  else
    helplog("目标点坐标" .. pos.x, pos.y, pos.z)
    pos.x = pos.x * 1000
    pos.y = pos.y * 1000
    pos.z = pos.z * 1000
    ServiceTechTreeCmdProxy.Instance:CallToyTransSetPosCmd(pos)
    FunctionItemFunc.DoUseItem(self.data, nil, 1)
    self:CloseSelf()
  end
end

function TeleportToyPopUp:GetNPCPointArray(ID)
  if self.sceneInfo then
    return self.sceneInfo and self.sceneInfo.nps or nil
  else
    redlog("sceneInfo is nil")
  end
end

function TeleportToyPopUp:FindNPCPoint(ID)
  if self.sceneInfo then
    local map = self.sceneInfo.npMap
    return map and map[ID] or nil
  end
end

function TeleportToyPopUp:FindExitPoint(ID)
  if self.sceneInfo then
    local map = self.sceneInfo.epMap
    return map and map[ID] or nil
  end
end

function TeleportToyPopUp:FindBornPoint(ID)
  if self.sceneInfo then
    local map = self.sceneInfo.bpMap
    return map and map[ID] or nil
  end
end

function TeleportToyPopUp:GetMapNpcPointByNpcId(npcid)
  local npcList = self:GetNPCPointArray()
  if npcList then
    for i = 1, #npcList do
      local npcPoint = npcList[i]
      if npcPoint and npcPoint.ID == npcid then
        return npcPoint
      end
    end
  end
end
