autoImport("WorldMapListView")
NewExploreModeView = class("NewExploreModeView", SubView)

function NewExploreModeView:Init()
  self:InitView()
  self:FindObjs()
  self:ResetPanelDepth()
  self:AddViewListeners()
end

function NewExploreModeView:InitView()
  self.gameObject = self:FindGO("NewExploreMode")
  self.roadPathPoint = self:FindGO("RoadPathPoint")
  self.worldMapView = self:AddSubView("WorldMapListView", WorldMapListView)
  self.worldMapView.gameObject.transform.parent = self.gameObject.transform
  self.worldMapView:ShowMapForNewExploreModeView(SceneProxy.Instance.currentScene.mapID)
  self.mapContainer = self:FindGO("MapContainer")
end

function NewExploreModeView:ResetPanelDepth()
  self.loadingViewDepth = self.container.loadingViewDepth
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.worldMapView.gameObject, UIPanel, true)
  local maxDepth = 0
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + self.loadingViewDepth
    maxDepth = math.max(maxDepth, uipanels[i].depth)
  end
  self.foreLayer.depth = maxDepth + 1
end

function NewExploreModeView:Test()
  local mine = WorldMapProxy.Instance:GetMapAreaDataByMapId(SceneProxy.Instance.currentScene.mapID)
  mine:SetActive(true)
end

function NewExploreModeView:FindObjs()
  self.foreLayer = self:FindGO("ForeLayer"):GetComponent(UIPanel)
  self.effectContainer = self:FindGO("effectContainer")
  self.labelBg = self:FindGO("labelBg"):GetComponent(UIWidget)
  self.foreLayer.gameObject:SetActive(false)
end

function NewExploreModeView:AddViewListeners()
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.ServerReceiveLoadedHandler)
end

function NewExploreModeView:OnExit()
  local mapID = SceneProxy.Instance.currentScene.mapID
  local mapArea = WorldMapProxy.Instance:GetMapAreaDataByMapId(mapID)
  if mapArea then
    mapArea:SetIsNew(false)
  end
  NewExploreModeView.super.OnExit(self)
end

function NewExploreModeView:ServerReceiveLoadedHandler(note)
  if SceneProxy.Instance:IsMask() or SceneProxy.Instance:IsNeedWaitCutScene() then
    self.container:SafeDelayClose(SceneProxy.Instance:IsNeedWaitCutScene_NoDelayClose())
    return
  end
  self:AllDone()
end

function NewExploreModeView:AllDone()
  self.container:CloseSelf()
end

function NewExploreModeView:SceneFadeOut(note)
  self.foreLayer.gameObject:SetActive(false)
  self.worldMapView.gameObject:SetActive(false)
  self.container:DoFadeOut(nil, SceneProxy.Instance:IsMask() and 1 or 0)
end

function NewExploreModeView:SceneFadeOutFinish()
  self:SetFrom()
end

function NewExploreModeView:StartLoadScene(note)
  self.foreLayer.gameObject:SetActive(true)
  self.worldMapView.gameObject:SetActive(true)
  self:MoveToNew()
  self:ReFitLabelBg()
  self:PlayUIEffect(EffectMap.UI.Eff_loading_walk, self.effectContainer)
  local effect = self:PlayUIEffect(EffectMap.UI.Eff_loading_new, self.effectContainer)
  effect:ResetLocalPositionXYZ(-110, -58, 0)
end

function NewExploreModeView:Update(delta)
end

function NewExploreModeView:MoveToNew()
  local toID = SceneProxy.Instance.currentScene.mapID
  local toCell = self.worldMapView:GetMapCellByMapId(toID)
  local hasFrom, fromPos = self:SetFrom()
  if toCell ~= nil then
    self.cellParent = toCell.gameObject.transform.parent
    if hasFrom then
      local duration = 0.8
      LeanTweenUtil.moveLocal(self.worldMapView.myPosSymbol, toCell.trans.localPosition, duration):setOnComplete(function()
        toCell:IsExplored(true)
      end)
    end
    UIUtil.GetUIParticle(EffectMap.UI.WorldMapUnlock, 100, toCell.gameObject)
  end
end

function NewExploreModeView:SetFrom(toCell)
  local fromID = SceneProxy.Instance.lastMapID
  local fromCell = self.worldMapView:GetMapCellByMapId(fromID)
  if fromCell then
    self.worldMapView.myPosSymbol.transform:SetParent(fromCell.trans.parent, true)
    self.worldMapView.myPosSymbol.transform.localPosition = fromCell.trans.localPosition
    return true, fromCell.trans.localPosition
  elseif toCell then
    self.worldMapView.myPosSymbol.transform:SetParent(toCell.trans.parent, true)
    self.worldMapView.myPosSymbol.transform.localPosition = LuaGeometry.GetTempVector3()
  end
  return false
end

function NewExploreModeView:AddPoint(startPoint, endPoint, percent)
  if percent <= 1 then
    local point = GameObject.Instantiate(self.roadPathPoint)
    point.transform.parent = self.mapContainer.transform
    point:SetActive(true)
    point.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    local dir = endPoint - startPoint
    if self.cellParent ~= nil then
      point.transform.localPosition = startPoint + dir * percent + self.cellParent.localPosition
    else
      point.transform.localPosition = startPoint + dir * percent
    end
  end
end

function NewExploreModeView:ReFitLabelBg()
  local scale = self.labelBg.width / self.labelBg.height
  self.labelBg.height = self.foreLayer.width
  self.labelBg.width = self.labelBg.height * scale
  local y = self.foreLayer.localCorners[1].y + self.labelBg.width * 0.5
  local pos = self.labelBg.transform.localPosition
  pos.y = y
  self.labelBg.transform.localPosition = pos
end

function NewExploreModeView:SceneFadeInFinish()
  self.container:CloseSelf()
end

function NewExploreModeView:LoadFinish()
  self.container:FireLoadFinishEvent()
end
