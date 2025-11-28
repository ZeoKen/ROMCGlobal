WorldMapListView = class("WorldMapListView", SubView)
autoImport("UIGridListCtrl")
autoImport("WorldMapAreaCell")
autoImport("WorldMapSwitchCell")
local cloudEffectId = "Eff_CloudMap"

function WorldMapListView:ctor(viewObj)
  WorldMapListView.super.ctor(self, viewObj)
  self.enableMapClick = true
  local preferb = self:LoadPreferb("view/WorldMapListView")
  preferb.transform:SetParent(self.trans, false)
  self.gameObject = preferb
  self:InitViewData()
  self:InitView()
  self:MapListenEvent()
end

function WorldMapListView:InitViewData()
  self.myself = Game.Myself
end

function WorldMapListView:InitView()
  self.beforePanel = self:FindGO("BeforePanel")
  self.mapScrollView = self:FindComponent("MapScrollView", UIScrollViewEx)
  local mPanel = self.mapScrollView.panel
  local size = UIManagerProxy.Instance:GetUIRootSize()
  mPanel.baseClipRegion = Vector4(0, 0, size[1], size[2])
  self.menuScrollView = self:FindComponent("MenuScrollView", UIScrollView)
  self.map = self:FindComponent("Map", UITexture)
  self.mapBound = self:FindGO("MapBound")
  self.mapGrid = self:FindComponent("MapGrid", UIGrid)
  self:RefitMap()
  self.mapTween = self:FindComponent("MapContainer", Transform)
  self.menuTable = self:FindComponent("MenuTable", UITable)
  self.menuTween = self:FindComponent("TweenMenu", TweenPosition)
  local menuScrollGo = self:FindGO("MenuScrollView")
  self.menuTween:SetOnFinished(function()
    menuScrollGo:SetActive(false)
    menuScrollGo:SetActive(true)
  end)
  self.zoomSymbol = self:FindComponent("ZoomSymbol", UIMultiSprite)
  self.zoomLabel = self:FindComponent("ZoomLabel", UILabel)
  self.hideInfoSymbol = self:FindComponent("HideInfoSymbol", UIMultiSprite)
  self.hideInfoLabel = self:FindComponent("HideInfoLabel", UILabel)
  self.myPosSymbol = self:FindGO("MyPosSymbol")
  self.chooseSymbol = self:FindComponent("ChooseSymbol", Transform)
  self:InitMapCells()
  self:UpdateTeamMemerPos()
  self.zoomBtn = self:FindGO("ZoomBtn")
  self:AddClickEvent(self.zoomBtn, function(go)
    if self.zoomIn then
      self:PlayMapZoomAnim(false)
    else
      self:PlayMapZoomAnim(true)
    end
  end)
  self.hideBtn = self:FindGO("HideInfoBtn")
  self.showDetail = true
  self:AddClickEvent(self.hideBtn, function(go)
    self:ActiveMapDetail(not self.showDetail)
  end)
  self.ig = self.gameObject:GetComponent(InputGesture)
  
  function self.ig.zoomInAction()
    self:PlayMapZoomAnim(true)
  end
  
  function self.ig.zoomOutAction()
    self:PlayMapZoomAnim(false)
  end
  
  self.zoomSymbol.CurrentState = 0
  self.zoomLabel.text = ZhString.WorldMapListView_zoomIn
  self.hideInfoSymbol.CurrentState = 1
  self.hideInfoLabel.text = ZhString.WorldMapListView_infoHide
  self.introMapObj = self:FindGO("IntroPop")
  self.introMapIcon = self:FindComponent("Icon", UISprite, self.introMapObj)
  self.introMapName = self:FindComponent("Name", UILabel, self.introMapObj)
  self.introMapDesc = self:FindComponent("Desc", UILabel, self.introMapObj)
  self.introTween = self.introMapObj:GetComponent(TweenAlpha)
  self.mapSwitchHolder = self:FindGO("MapSwitchHolder")
  self.mapSwitchCtl = UIGridListCtrl.new(self.mapSwitchHolder, WorldMapSwitchCell, "WorldMapSwitchCell")
  self.mapSwitchCtl:AddEventListener(MouseEvent.MouseClick, self.SwitchWorldMapByWorldId, self)
end

function WorldMapListView:RefitMap()
  self.map:MakePixelPerfect()
  local mapHeight = self.map.height * 0.75
  local rootSize = UIManagerProxy.Instance:GetUIRootSize()
  local perfectRatio = 1.7777777777777777
  local scale = 1
  if perfectRatio < rootSize[1] / rootSize[2] then
    scale = rootSize[2] / mapHeight
  else
    scale = rootSize[1] / (mapHeight * perfectRatio)
  end
  self.map.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  self.mapBound.transform.localScale = LuaGeometry.GetTempVector3(scale, scale, scale)
  self.mapGrid.transform.localPosition = LuaGeometry.GetTempVector3(WorldMapOriPos[1], WorldMapOriPos[2], 0)
  local cellDuration = mapHeight / 10
  self.mapGrid.cellWidth = 140
  self.mapGrid.cellHeight = 140
  self.mapGrid.maxPerLine = WorldMapProxy.Size_X
  local cellScale = cellDuration / 140
  self.mapGrid.transform.localScale = LuaGeometry.GetTempVector3(cellScale, cellScale, cellScale)
end

local tempArgs = {}

function WorldMapListView:StartTrace()
  self.container:CloseSelf()
end

function WorldMapListView:ActiveButtons(b)
  self.zoomBtn:SetActive(b)
  self.hideBtn:SetActive(b)
end

function WorldMapListView:EnableMapClick(b)
  self.enableMapClick = b
end

function WorldMapListView:PlayMapZoomAnim(zoomIn)
  self.zoomIn = zoomIn
  if zoomIn then
    self.zoomSymbol.CurrentState = 1
    self.zoomLabel.text = ZhString.WorldMapListView_zoomOut
    self:ZoomScrollView(Vector3(1.2, 1.2, 1.2), 0.2, self.myPosSymbol.transform, function()
      self.mapScrollView.enabled = true
    end)
  else
    self.zoomSymbol.CurrentState = 0
    self.zoomLabel.text = ZhString.WorldMapListView_zoomIn
    self:ZoomScrollView(Vector3(0.62, 0.62, 0.62), 0.2, self.mapTween.gameObject, function()
      self.mapScrollView.enabled = false
    end)
  end
end

function WorldMapListView:PlayMenuAnim(dir, resetToBeginning)
  self.menuShow = dir
  if resetToBeginning then
    self.menuTween:ResetToBeginning()
  end
  if dir then
    self.menuTween:PlayForward()
  else
    self.menuTween:PlayReverse()
  end
end

function WorldMapListView:ActiveMapDetail(active)
  self.showDetail = active
  if active then
    self.hideInfoSymbol.CurrentState = 1
    self.hideInfoLabel.text = ZhString.WorldMapListView_infoHide
  else
    self.hideInfoSymbol.CurrentState = 0
    self.hideInfoLabel.text = ZhString.WorldMapListView_infoShow
  end
  local cells = self.mapCtl:GetCells()
  for k, cell in pairs(cells) do
    if type(cell.data) == "table" and cell.data.isactive then
      cell:SetCellInfoActive(active)
    end
  end
end

function WorldMapListView:InitMapCells()
  self.mapCtl = UIGridListCtrl.new(self.mapGrid, WorldMapAreaCell, "WorldMapAreaCell")
  self.mapCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self)
end

function WorldMapListView:ClickMapCell(cellctl)
  if not self.enableMapClick then
    return
  end
  if type(cellctl.data) == "table" then
    local mapid = cellctl.data.mapid
    if mapid then
      self:UpdateMapMenuList(cellctl.data)
      self.chooseSymbol:SetParent(cellctl.trans, false)
      self.chooseSymbol.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      self.chooseSymbol.localPosition = LuaGeometry.GetTempVector3()
    end
  end
end

function WorldMapListView:UpdateMapMenuList(data)
  local viewdata = self.viewdata and self.viewdata.viewdata
  local _isFromFurniture = viewdata and viewdata.isFromFurniture
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.WorldMapMenuPopUp,
    viewdata = {data = data, isFromFurniture = _isFromFurniture}
  })
end

function WorldMapListView:GetMapCellByMapId(mapid)
  local mapAreaData, index = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapid)
  if mapAreaData == nil or mapAreaData.staticData == nil or self.curWorld ~= (mapAreaData.staticData.World or 1) then
    redlog("not find mapAreaData", mapid)
    return
  end
  local cells = self.mapCtl:GetCells()
  return cells[index]
end

function WorldMapListView:UpdateTeamMemerPos()
  local cell = self:GetMapCellByMapId(SceneProxy.Instance.currentScene.mapID)
  if cell == nil then
    self.myPosSymbol:SetActive(false)
  else
    self.myPosSymbol:SetActive(true)
    self.myPosSymbol.transform:SetParent(cell.trans, false)
  end
  local myid = Game.Myself.data.id
  if not TeamProxy.Instance:IHaveTeam() then
    return
  end
  local memberlst = TeamProxy.Instance.myTeam:GetMembersList()
  for i = 1, #memberlst do
    local member = memberlst[i]
    if member and member.mapid and member.id ~= myid and not member:IsOffline() and member.zoneid == MyselfProxy.Instance:GetZoneId() then
      local cell = self:GetMapCellByMapId(member.mapid)
      if cell then
        cell:AddMapTeamMember()
      end
    end
  end
end

function WorldMapListView:MapListenEvent()
  self:AddListenEvt(WorldMapEvent.StartTrace, self.StartTrace, self)
end

function WorldMapListView:CenterMapByMapId(mapid, endScale, time, onfinish)
  local cell = self:GetMapCellByMapId(mapid)
  if cell then
    self:ZoomScrollView(endScale, time, cell.gameObject, onfinish)
  end
end

function WorldMapListView:ZoomScrollView(endScale, time, centerTarget, onfinish)
  local mDrag = self.mapScrollView
  local mPanel = mDrag.panel
  local mTrans = mDrag.transform
  local pTrans = mTrans.parent
  time = time or 1
  local startPos = centerTarget.transform.position
  local endPos = (mPanel.worldCorners[1] + mPanel.worldCorners[3]) * 0.5
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateTickFromTo(0, 0, 1, time * 1000, function(owner, deltaTime, curValue)
    self.mapTween.localScale = Vector3.Lerp(Vector3.one, endScale, curValue)
    local before = centerTarget.transform.position
    local after = Vector3.Lerp(startPos, endPos, curValue)
    local offset = after - before
    local mlPosition = mTrans.localPosition
    mTrans.position = mTrans.position + offset
    mPanel.clipOffset = mPanel.clipOffset - (mTrans.localPosition - mlPosition)
    local b = NGUIMath.CalculateRelativeWidgetBounds(mTrans, self.map.transform)
    local calOffset = mPanel:CalculateConstrainOffset(b.min, b.max)
    if calOffset.magnitude >= 0.01 then
      mTrans.localPosition = mTrans.localPosition + calOffset
      mPanel.clipOffset = mPanel.clipOffset - Vector2(calOffset.x, calOffset.y)
    end
  end, self):SetCompleteFunc(onfinish)
end

function WorldMapListView:UpdateQuestInfo()
  local cells = self.mapCtl:GetCells()
  for k, cell in pairs(cells) do
    if type(cell.data) == "table" and cell.data.isactive then
      cell:UpdateQuestSymbol()
    end
  end
end

function WorldMapListView:SwitchWorldMapByMapId(mapid)
  local worldid = mapid and Table_Map[mapid] and Table_Map[mapid].World or 1
  self:SwitchWorldMapByWorldId(worldid)
end

function WorldMapListView:LoadPlayCloudEffect()
  if self.cloudEffectGo and self.cloudEffect then
    self.cloudEffectGo:SetActive(false)
    self.cloudEffectGo:SetActive(true)
    self.cloudEffect:SetPlaybackSpeed(1)
  else
    self:PlayUIEffect(cloudEffectId, self.beforePanel, false, function(go, args, assetEffect)
      self.cloudEffect = assetEffect
      go.transform.localEulerAngles = LuaGeometry.GetTempVector3(-90, 0, 0)
      self.cloudEffectGo = go.gameObject
    end)
  end
end

function WorldMapListView:SwitchWorldMapByWorldId(worldid)
  self:LoadPlayCloudEffect()
  worldid = worldid or 1
  self.mapCtl:ResetDatas(WorldMapProxy.Instance:GetMapAreaDatas(worldid))
  local worldData = worldid and Table_WorldMap and Table_WorldMap[worldid]
  if not worldData or self.curWorld == worldid then
    return
  end
  self.curWorld = worldid
  if not GameConfig.SystemForbid.WorldMap then
    self.introMapObj:SetActive(true)
    IconManager:SetUIIcon(worldData.Icon, self.introMapIcon)
    self.introMapName.text = worldData.NameZh
    self.introMapDesc.text = worldData.Desc
    self.introTween:ResetToBeginning()
    self.introTween:PlayForward()
    self.mapSwitchCtl:ResetDatas(worldData.MapSwitch, false, false)
  else
    self.mapSwitchCtl:ResetDatas(nil, true, false)
  end
  PictureManager.Instance:SetMap(worldData.MapPic, self.map)
  self:UpdateTeamMemerPos()
end

function WorldMapListView:ShowMapForNewExploreModeView(mapid)
  self:LoadPlayCloudEffect()
  self.ig.enabled = false
  self:ActiveButtons(false)
  self:ActiveMapDetail(false)
  self:EnableMapClick(false)
  local worldid = mapid and Table_Map[mapid] and Table_Map[mapid].World or 1
  self.curWorld = worldid
  self.mapCtl:ResetDatas(WorldMapProxy.Instance:GetMapAreaDatas(worldid))
  local worldData = worldid and Table_WorldMap and Table_WorldMap[worldid]
  if not worldData then
    return
  end
  PictureManager.Instance:SetMap(worldData.MapPic, self.map)
end
