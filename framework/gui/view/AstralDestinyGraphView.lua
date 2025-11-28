autoImport("AstralDestinyGraphSeasonCell")
AstralDestinyGraphView = class("AstralDestinyGraphView", ContainerView)
AstralDestinyGraphView.ViewType = UIViewType.PopUpLayer
local BgName = "Greatsecret_starrysky_bg_00"
local DecorationBgName = "Greatsecret_starrysky_bg_02"
local SeasonCellPfbPrefix = "AstralDestinyGraphSeasonCell_S"

function AstralDestinyGraphView:Init()
  self:FindObjs()
  self:AddListenEvts()
  self.isInit = true
  ServiceMessCCmdProxy.Instance:CallSyncDestinyGraphMessCCmd()
end

function AstralDestinyGraphView:InitData()
  local initSeason = AstralProxy.Instance:GetSeason()
  self.round = (initSeason - 1) // 4 + 1
  self.graphInfoList = {}
end

function AstralDestinyGraphView:FindObjs()
  self:AddCloseButtonEvent()
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.decorationBg = self:FindComponent("decoration2", UITexture)
  self.pointScrollView = self:FindComponent("PointPanel", UIScrollView)
  self.pointPanel = self.pointScrollView.gameObject:GetComponent(UIPanel)
  self.seasonCellParent = {}
  for i = 1, 12 do
    self.seasonCellParent[i] = self:FindGO("S" .. i)
  end
  self.season0 = self:FindGO("S0")
  self.filterBtn = self:FindGO("FilterBtn")
  self.filterList = PopupGridList.new(self.filterBtn, self.OnSelectRound, self, nil, nil, 4)
  local grid = self:FindComponent("Grid", UIGrid)
  self.totalBuffListCtrl = UIGridListCtrl.new(grid, AstralDestinyGraphPointBuffCell, "AstralDestinyGraphTotalBuffCell")
  self.totalEmptyTip = self:FindGO("TotalBuffEmptyTip")
  local currentMedalGO = self:FindGO("CurrentMedal")
  self.currentMedalIcon = self:FindComponent("Icon", UISprite, currentMedalGO)
  self:AddClickEvent(self.currentMedalIcon.gameObject, function()
    local itemId = GameConfig.Astral and GameConfig.Astral.NewMedalID
    local itemData = ItemData.new("", itemId)
    self.tipData.itemdata = itemData
    self:ShowItemTip(self.tipData, self.currentMedalIcon, NGUIUtil.AnchorSide.Left, {-280, 0})
  end)
  self.currentMedalNumLabel = self:FindComponent("Num", UILabel, currentMedalGO)
  local previousMedalGO = self:FindGO("PreviousMedal")
  self.previousMedalIcon = self:FindComponent("Icon", UISprite, previousMedalGO)
  self:AddClickEvent(self.previousMedalIcon.gameObject, function()
    local itemId = GameConfig.Astral and GameConfig.Astral.OldMedalID
    local itemData = ItemData.new("", itemId)
    self.tipData.itemdata = itemData
    self:ShowItemTip(self.tipData, self.previousMedalIcon, NGUIUtil.AnchorSide.Left, {-280, 0})
  end)
  self.previousMedalNumLabel = self:FindComponent("Num", UILabel, previousMedalGO)
  local collider = self:FindGO("DragCollider")
  self:AddClickEvent(collider, function()
    self:HidePointTip()
  end)
  local helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(32622, helpBtn)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.effectContainer = self:FindGO("EffectContainer")
end

function AstralDestinyGraphView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.MessCCmdSyncDestinyGraphMessCCmd, self.HandleSyncDestinyGraph)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RefreshCostItem)
end

function AstralDestinyGraphView:HandleSyncDestinyGraph()
  redlog("AstralDestinyGraphView:HandleSyncDestinyGraph", tostring(self.round))
  if self.isInit then
    self:InitData()
    self:InitFilter(true)
    self:TryScrollToPivot()
    self.isInit = false
  else
    self:InitFilter(true)
    self:RefreshView(self.round)
    if self.lightenPointData then
      local season = self.lightenPointData.season
      local index = self.lightenPointData.index
      local seasonCell = self.graphInfoList[(season - 1) % 4 + 1]
      if seasonCell then
        seasonCell:PlayPointEffect(index)
      end
    end
  end
end

function AstralDestinyGraphView:HandleChangeMap()
  self:CloseSelf()
end

function AstralDestinyGraphView:OnEnter()
  PictureManager.Instance:SetAstralTexture(BgName, self.bgTex)
  PictureManager.Instance:SetAstralTexture(DecorationBgName, self.decorationBg)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.HandleChangeMap, self)
  self:PlayUIEffect(EffectMap.UI.AstralGraphStar, self.effectContainer)
end

function AstralDestinyGraphView:OnExit()
  PictureManager.Instance:UnloadAstralTexture(BgName, self.bgTex)
  PictureManager.Instance:UnloadAstralTexture(DecorationBgName, self.decorationBg)
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.HandleChangeMap, self)
  self:ClearGraphInfoList()
  self:HidePointTip()
  self:DestroyUIEffects()
end

function AstralDestinyGraphView:InitFilter(doNotClickFilter)
  local _AstralProxy = AstralProxy.Instance
  local roundNum = _AstralProxy:GetGraphRoundNum()
  local seasonNum = _AstralProxy:GetSeasonNum()
  local datas = ReusableTable.CreateArray()
  for i = 1, roundNum do
    local str = self:GetFilterStr(i, seasonNum)
    local data = {}
    data.Name = str
    data.round = i
    datas[#datas + 1] = data
  end
  self.filterList:SetData(datas, nil, doNotClickFilter)
  ReusableTable.DestroyArray(datas)
  self.filterList:SetValue(self:GetFilterStr(self.round, seasonNum))
end

function AstralDestinyGraphView:GetFilterStr(round, maxSeason)
  local startSeason = (round - 1) * 4 + 1
  local endSeason = math.min(startSeason + 3, maxSeason)
  local lightenNum, totalNum = AstralProxy.Instance:GetLightenPointNumByRound(round)
  local str
  if startSeason == endSeason then
    str = string.format(ZhString.AstralGraph_RoundFilterOneSeason, startSeason, lightenNum, totalNum)
  else
    str = string.format(ZhString.AstralGraph_RoundFilter, startSeason, endSeason, lightenNum, totalNum)
  end
  return str
end

function AstralDestinyGraphView:OnSelectRound(data)
  if not data then
    return
  end
  if not self.isInit and self.round == data.round then
    return
  end
  self:RefreshView(data.round)
  self.pointScrollView.transform.localPosition = LuaGeometry.Const_V3_zero
  self.pointPanel.clipOffset = LuaGeometry.Const_V2_zero
end

function AstralDestinyGraphView:RefreshView(round)
  local graphInfos = AstralProxy.Instance:GetGraphInfosByRound(round)
  if round ~= self.round or #graphInfos ~= #self.graphInfoList then
    self:ClearGraphInfoList()
    self.round = round
  end
  self:HidePointTip()
  self.selectPointCell = nil
  for i = 1, #self.graphInfoList do
    local seasonCell = self.graphInfoList[i]
    seasonCell:ClearPointSelectState()
  end
  local curSeason = AstralProxy.Instance:GetSeason()
  if 1 < #graphInfos then
    for i = 1, #graphInfos do
      local graphData = graphInfos[i]
      local parent = self.seasonCellParent[(i + (round - 1) * 4 - 1) % 12 + 1]
      local seasonCell = self.graphInfoList[i]
      if not seasonCell then
        seasonCell = self:CreateSeasonCell(graphData, parent)
        self.graphInfoList[i] = seasonCell
      end
      seasonCell:SetData(graphData)
      if graphData.season == curSeason then
        local firstNoLightenPoint = graphData:GetFirstNoLightenPoint()
        if firstNoLightenPoint then
          self.selectPointCell = seasonCell:SetPointSelectState(firstNoLightenPoint.index)
        end
      end
    end
  elseif #graphInfos == 1 then
    local graphData = graphInfos[1]
    local seasonCell = self.graphInfoList[1]
    if not seasonCell then
      seasonCell = self:CreateSeasonCell(graphData, self.season0)
      self.graphInfoList[1] = seasonCell
    end
    seasonCell:SetData(graphData)
    local firstNoLightenPoint = graphData:GetFirstNoLightenPoint()
    if firstNoLightenPoint then
      self.selectPointCell = seasonCell:SetPointSelectState(firstNoLightenPoint.index)
    end
  end
  local buffEffects = AstralProxy.Instance:GetTotalBuffEffects()
  local datas = ReusableTable.CreateArray()
  for k, v in pairs(buffEffects) do
    local data = {}
    data.name = k
    data.value = v
    datas[#datas + 1] = data
  end
  local orderConfig = GameConfig.Astral and GameConfig.Astral.GraphPointAttrOrder
  if orderConfig then
    table.sort(datas, function(l, r)
      return orderConfig[l.name] < orderConfig[r.name]
    end)
  end
  self.totalBuffListCtrl:ResetDatas(datas)
  self.totalEmptyTip:SetActive(#datas == 0)
  ReusableTable.DestroyArray(datas)
  self:RefreshCostItem()
end

function AstralDestinyGraphView:RefreshCostItem()
  local currentMedalId, previousMedalId = GameConfig.Astral and GameConfig.Astral.NewMedalID, GameConfig.Astral and GameConfig.Astral.OldMedalID
  IconManager:SetItemIconById(currentMedalId, self.currentMedalIcon)
  IconManager:SetItemIconById(previousMedalId, self.previousMedalIcon)
  local currentNum, previousNum = BagProxy.Instance:GetItemNumByStaticID(currentMedalId, GameConfig.PackageMaterialCheck.destiny_graph), BagProxy.Instance:GetItemNumByStaticID(previousMedalId, GameConfig.PackageMaterialCheck.destiny_graph)
  self.currentMedalNumLabel.text = currentNum
  self.previousMedalNumLabel.text = previousNum
end

function AstralDestinyGraphView:CreateSeasonCell(graphData, parent)
  local pfbSuffix = (graphData.season - 1) % 12 + 1
  local prefabName = SeasonCellPfbPrefix .. pfbSuffix
  local seasonCell = AstralDestinyGraphSeasonCell.new(parent, prefabName)
  seasonCell:AddEventListener(MouseEvent.MouseClick, self.OnClickPointCell, self)
  return seasonCell
end

function AstralDestinyGraphView:ClearGraphInfoList()
  TableUtility.ArrayClearByDeleter(self.graphInfoList, function(v)
    v:OnCellDestroy()
    GameObject.DestroyImmediate(v.gameObject)
  end)
end

function AstralDestinyGraphView:OnClickPointCell(cell)
  for i = 1, #self.graphInfoList do
    self.graphInfoList[i]:SetCellSelectState(cell)
  end
  self:ShowPointTip(cell.data, cell.bg)
end

function AstralDestinyGraphView:ShowPointTip(data, stick)
  if not self.currentTip then
    self.currentTip = TipManager.Instance:ShowAstralDestinyGraphPointTip(data, stick, nil, {200, 0})
    self.currentTip:AddEventListener(UIEvent.JumpPanel, self.OnGotoBtnClick, self)
    self.currentTip:AddEventListener(UIEvent.CloseUI, self.HidePointTip, self)
    self.currentTip:AddEventListener(AstralGraphEvent.LightenPoint, self.OnPointLighten, self)
  else
    TipManager.Instance:ShowAstralDestinyGraphPointTip(data, stick, nil, {200, 0})
  end
end

function AstralDestinyGraphView:OnGotoBtnClick()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PveView,
    viewdata = {initialGroupId = 36}
  })
  self:CloseSelf()
end

function AstralDestinyGraphView:HidePointTip()
  TipManager.Instance:CloseAstralDestinyGraphPointTip()
  self.currentTip = nil
end

function AstralDestinyGraphView:OnPointLighten(data)
  redlog("CallLightenDestinyGraphMessCCmd")
  self.lightenPointData = data
  ServiceMessCCmdProxy.Instance:CallLightenDestinyGraphMessCCmd(data.season, data.index)
end

function AstralDestinyGraphView:TryScrollToPivot()
  if not self.selectPointCell then
    return
  end
  local curPointPos = self.trans:InverseTransformPoint(self.selectPointCell.trans.position)
  if curPointPos.x > 0 then
    local targetRelative = -curPointPos.x
    local relative = LuaGeometry.GetTempVector3(targetRelative, 0, 0)
    self.pointScrollView:MoveRelative(relative)
  end
end
