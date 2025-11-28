local PathChooseOption = {
  {
    ZhString.AstrolabeView_Simulation_SPPath,
    FunctionAstrolabe.SearchType.Path
  },
  {
    ZhString.AstrolabeView_Simulation_SPGold,
    FunctionAstrolabe.SearchType.Gold
  }
}
autoImport("AstrolabeView_SearchPointCell")
local localSaveProxy

function AstrolabeView:InitActive()
  localSaveProxy = LocalSaveProxy.Instance
  self.handlePointsMap = {}
  self.handlePointsList = {}
  self.savePointsMap = {}
  self.inSaveModePriStateMap = {}
  self.convertPopUpData = {
    convert = {}
  }
  self:MapActiveEvent()
  self:InitActiveInfo()
  self:InitResetInfo()
  self:InitSimulateInfo()
end

function AstrolabeView:InitActiveInfo()
  self.activeInfo = self:FindGO("ActiveBriefInfo")
  self.activeInfoTween = self.activeInfo:GetComponent(UIPlayTween)
  self.activeButtonGO = self:FindGO("ActiveButton", self.activeInfo)
  self.activeButton_label = self:FindComponent("Label", UILabel, self.activeButtonGO)
  self:AddClickEvent(self.activeButtonGO, function()
    self:ClickActiveButton()
  end)
  self.activeBord = self:FindGO("ActiveBord")
  self.activeBord_ConfirmButton = self:FindGO("ConfirmButton", self.activeBord)
  self.activeBord_ConfirmButton_Sp = self.activeBord_ConfirmButton:GetComponent(UISprite)
  self.activeBord_ConfirmButton_Collider = self.activeBord_ConfirmButton:GetComponent(BoxCollider)
  self.activeBord_ConfirmButton_Sprite = self:FindComponent("Sprite", UISprite, self.activeBord_ConfirmButton)
  self.activeBord_CancelButton = self:FindGO("CancelButton", self.activeBord)
  self.activeBord_ActivePoint = self:FindComponent("ActivePoint", UILabel, self.activeBord)
  self.activeBord_ReturnGold = self:FindComponent("CostGold", UILabel, self.activeBord)
  local activeBord_SymbolGold = self:FindComponent("SymbolGold", UISprite)
  IconManager:SetItemIcon("item_5261", activeBord_SymbolGold, self.activeBord)
  self:AddClickEvent(self.activeBord_ConfirmButton, function()
    self:DoServerActive()
  end)
  self:AddClickEvent(self.activeBord_CancelButton, function()
    self:ResetHandlePointsInfo()
    self.waitCancelChooseOnect = true
  end)
  self.activeBord_SimulateResetButton = self:FindGO("SimulateResetButton", self.activeBord)
  self:AddClickEvent(self.activeBord_SimulateResetButton, function()
    self.inSaveMode = true
    if self:TryResetPoints(1) then
      self:DoServerReset()
    end
    self.inSaveMode = false
  end)
  self.activeBord_SimulateConfirmButton = self:FindGO("SimulateConfirm", self.activeBord)
  self:AddClickEvent(self.activeBord_SimulateConfirmButton, function()
    if not self.saveInfoShow then
      self:ShowAndUpdateSimulateSaveInfo()
    end
    self:TrySavePoints()
    self:DoServerSave()
  end)
  self.activeBord_SimulateResetButtonLabel = self:FindComponent("Label", UILabel, self.activeBord_SimulateResetButton)
  self.activeBord_SimulateResetButtonLabel.text = ZhString.AstrolabeView_Simulation_Reset
  self.activeBord_SimulateConfirmButtonLabel = self:FindComponent("Label", UILabel, self.activeBord_SimulateConfirmButton)
  self.activeBord_SimulateConfirmButtonLabel.text = ZhString.AstrolabeView_Simulation_Confirm
end

function AstrolabeView:InitResetInfo()
  self.resetBord = self:FindGO("ResetBord")
  self.resetBord_ConfirmButton = self:FindGO("ConfirmButton", self.resetBord)
  self.resetBord_ConfirmButton_Sp = self.resetBord_ConfirmButton:GetComponent(UISprite)
  self.resetBord_ConfirmButton_Collider = self.resetBord_ConfirmButton:GetComponent(BoxCollider)
  self.resetBord_ConfirmButton_Sprite = self:FindComponent("Sprite", UISprite, self.resetBord_ConfirmButton)
  self.resetBord_CancelButton = self:FindGO("CancelButton", self.resetBord)
  self.resetBord_ResetPoint = self:FindComponent("ResetPoint", UILabel, self.resetBord)
  self.resetBord_CostZeny = self:FindComponent("CostZeny", UILabel, self.resetBord)
  local l_zenyIcon = self:FindComponent("SymbolZeny", UISprite, self.resetBord)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  self:AddClickEvent(self.resetBord_ConfirmButton, function()
    self:DoServerReset_Active()
  end)
  self:AddClickEvent(self.resetBord_CancelButton, function()
    self:ResetHandlePointsInfo()
    self.waitCancelChooseOnect = true
  end)
  self.resetBord_SimulateResetButton = self:FindGO("SimulateResetButton", self.resetBord)
  self:AddClickEvent(self.resetBord_SimulateResetButton, function()
    self.inSaveMode = true
    if self:TryResetPoints() then
      self:DoServerReset()
    end
    self.inSaveMode = false
  end)
  self.resetBord_SimulateConfirmButton = self:FindGO("SimulateConfirm", self.resetBord)
  self:AddClickEvent(self.resetBord_SimulateConfirmButton, function()
    if not self.saveInfoShow then
      self:ShowAndUpdateSimulateSaveInfo()
    end
    self:TrySavePoints(1)
    self:DoServerSave()
  end)
  self.resetBord_SimulateResetButtonLabel = self:FindComponent("Label", UILabel, self.resetBord_SimulateResetButton)
  self.resetBord_SimulateResetButtonLabel.text = ZhString.AstrolabeView_Simulation_Reset
  self.resetBord_SimulateConfirmButtonLabel = self:FindComponent("Label", UILabel, self.resetBord_SimulateConfirmButton)
  self.resetBord_SimulateConfirmButtonLabel.text = ZhString.AstrolabeView_Simulation_Confirm
end

function AstrolabeView:InitSimulateInfo()
  self.helpGO = self:FindGO("HelpButton")
  self.handleState = AstrolabeView.HandleSate.None
  self.simulateInfoGO = self:FindGO("SimulateInfo", self.activeInfo)
  self.simulateBord = self:FindGO("SimulateBord", self.simulateInfoGO)
  self.simulateBord_SearchBord = self:FindGO("SearchBord", self.simulateBord)
  self.simulateBord_CostBord = self:FindGO("CostBord", self.simulateBord)
  self.simulateBord_Title = self:FindComponent("Label", UILabel, self.simulateBord_CostBord)
  local costBordGrid = self:FindComponent("CostBordGrid", UIGrid, self.simulateBord)
  self.simulateCostGridCtl = UIGridListCtrl.new(costBordGrid, AstrolabeMaterilaCell, "AstrolabeMaterilaCell")
  local pathButton = self:FindGO("PathButton")
  self.pathButton_Symbol = self:FindComponent("Symbol", UISprite, pathButton)
  self.pathButton_Symbol.spriteName = "xingpan_icon_path_hide"
  self:AddClickEvent(pathButton, function(go)
    if self.saveInfoShow then
      self:HideAndResetSimulateSaveInfo()
    else
      self:ShowAndUpdateSimulateSaveInfo()
    end
  end)
  local detailButton = self:FindGO("DetailButton", self.simulateInfoGO)
  self:AddClickEvent(detailButton, function()
    local data = {}
    if self.inSaveMode then
      data.bordData = self.curBordData
      data.savedata = self.curBordData:GetPlanIdsMap()
    else
      data.bordData = self.curBordData
      data.savedata = self.curBordData:GetActivePointsMap()
    end
    data.newdata = {}
    for id, _ in pairs(self.handlePointsMap) do
      if id ~= Astrolabe_Origin_PointID and not data.savedata[id] then
        data.newdata[id] = 1
      end
    end
    TipManager.Instance:ShowAstrolabeContraceTip(data)
  end)
  self.searchPointsBord = self:FindGO("SearchPointsBord")
  local closecomp = self.searchPointsBord:GetComponent(CloseWhenClickOtherPlace)
  
  function closecomp.callBack(go)
    self:HideSearchPointsBord()
  end
  
  local searchWrap = self:FindGO("SearchPointsGrid", self.searchPointsBord)
  self.searchPointsCtl = WrapListCtrl.new(searchWrap, AstrolabeView_SearchPointCell, "AstrolabeView_SearchPointCell", WrapListCtrl_Dir.Vertical)
  self.searchPointsCtl:AddEventListener(MouseEvent.MouseClick, self.ClickSearchPoint, self)
  self.simulateSearchInputGO = self:FindGO("SearchInput", self.simulateBord)
  self.simulateSearchInput = self.simulateSearchInputGO:GetComponent(UIInput)
  local doSearchButton = self:FindGO("S_Down", self.simulateSearchInputGO)
  self:AddClickEvent(doSearchButton, function(go)
    if self.searchPointsBord_Show then
      self:HideSearchPointsBord()
    else
      self:ShowSearchPointsBord()
    end
  end)
  local delButton = self:FindGO("S_Del", simulateSearchInputGO)
  self:AddClickEvent(delButton, function(go)
    self:ShowDefaultRecommendPointsEffect()
  end)
  self.searchDownTrans = self:FindGO("S_Down", simulateSearchInputGO).transform
  EventDelegate.Set(self.simulateSearchInput.onChange, function()
    if self.searchPointsBord_Show then
      self:DoSearchPoint(self.simulateSearchInput.value)
      return
    end
  end)
  local pathChoosePopUpButton = self:FindGO("PathChoosePopUp")
  self.pathChoosePopUpDownTrans = self:FindGO("S_Down", pathChoosePopUpButton).transform
  self.pathChoosePopUpDownLabel = self:FindComponent("Label", UILabel, pathChoosePopUpButton)
  self.pathChooseDropDownList = self:FindGO("PathChooseDropDownList")
  self.pathChooseDropDownCloseComp = self:FindComponent("PathChooseDropDownList", CloseWhenClickOtherPlace)
  
  function self.pathChooseDropDownCloseComp.callBack(go)
    self:HidePathChooseDropDownList()
  end
  
  self:AddClickEvent(pathChoosePopUpButton, function(go)
    if self.pathChoosePopUpShow then
      self:HidePathChooseDropDownList()
    else
      self:ShowPathChooseDropDownList()
    end
  end)
  local pathChooseDropDownLabels = self.pathChooseDropDownList:GetComponentsInChildren(UILabel, true)
  if pathChooseDropDownLabels then
    local maxCount = #pathChooseDropDownLabels > #PathChooseOption and #PathChooseOption or #pathChooseDropDownLabels
    for i = 1, maxCount do
      pathChooseDropDownLabels[i].gameObject:SetActive(true)
      pathChooseDropDownLabels[i].name = i
      pathChooseDropDownLabels[i].text = PathChooseOption[i][1]
      self:AddClickEvent(pathChooseDropDownLabels[i].gameObject, function(go)
        self:HidePathChooseDropDownList()
        self:DoPathChoose(go.name)
      end)
    end
  end
  self:AddButtonEvent("OneKnob", function()
    MsgManager.ConfirmMsgByID(41133, function()
      self:DoOneKnob()
    end)
  end)
end

function AstrolabeView:HidePathChooseDropDownList()
  self.pathChoosePopUpShow = false
  self.pathChoosePopUpDownTrans.eulerAngles = LuaGeometry.GetTempVector3(0, 0, -90)
  self.pathChooseDropDownList:SetActive(false)
end

function AstrolabeView:ShowPathChooseDropDownList()
  self.pathChoosePopUpShow = true
  self.pathChoosePopUpDownTrans.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 90)
  self.pathChooseDropDownList:SetActive(true)
end

function AstrolabeView:OnEnter_Active()
  function UICamera.onSelect(go, select)
    if go ~= self.simulateSearchInputGO then
      return
    end
    if select then
      self:ShowSearchPointsBord()
    end
  end
  
  self:UpdatePreview()
  self:ShowDefaultRecommendPointsEffect()
  local oneKnob, viewData = self:FindGO("OneKnob"), self.viewdata.viewdata
  oneKnob:SetActive(not viewData or not viewData.saveId and not viewData.storageId and not viewData.FromProfessionInfoViewMP)
end

function AstrolabeView:OnExit_Active()
  UICamera.onSelect = nil
end

function AstrolabeView:ClickSearchPoint(cell)
  self:ChooseSearchPoint(cell.data)
  self.searchPointsBord:SetActive(false)
  self:HideSearchPointsBord()
end

function AstrolabeView:ChooseSearchPoint(data)
  self:ClearSearchPointEffect()
  local name = data:GetName()
  self.simulateSearchInput.value = name
  local nameLang = OverSea.LangManager.Instance():GetLangByKey(name)
  if nameLang then
    self.simulateSearchInput.value = nameLang
  end
  TableUtility.TableClear(self.searchPoints)
  self.curBordData:MatchSpecialPointByName(name, self.searchPoints, false)
  for i = 1, #self.searchPoints do
    self:AddSearchPointEffect(self.searchPoints[i])
  end
end

local SearchPointCellPath = ResourcePathHelper.EffectUI("SelectRune")

function AstrolabeView:AddSearchPointEffect(point)
  self:AddMiniMapSearchPointEffect(point)
  if self.searchPointEffectMap == nil then
    self.searchPointEffectMap = {}
  end
  local effect = self.searchPointEffectMap[point.guid]
  if effect == nil then
    effect = self:LoadPreferb_ByFullPath(SearchPointCellPath, self.effectContainer)
    self.searchPointEffectMap[point.guid] = effect
    effect.transform.localPosition = LuaGeometry.GetTempVector3(point:GetWorldPos_XYZ())
  end
end

function AstrolabeView:ClearSearchPointEffect()
  self:ClearMiniMapSearchPointEffect()
  if self.searchPointEffectMap == nil then
    return
  end
  for id, effectGO in pairs(self.searchPointEffectMap) do
    if not Slua.IsNull(effectGO) then
      GameObject.Destroy(effectGO)
    end
  end
  self.searchPointEffectMap = {}
  self.simulateSearchInput.value = ""
end

function AstrolabeView:ShowSearchPointsBord()
  self:DoSearchPoint(self.simulateSearchInput.value)
  self.searchPointsBord_Show = true
  self.searchPointsBord:SetActive(true)
  self.searchDownTrans.eulerAngles = LuaGeometry.GetTempVector3(0, 0, 90)
end

function AstrolabeView:HideSearchPointsBord()
  self.searchPointsBord_Show = false
  if self.searchPointsBord then
    self.searchPointsBord:SetActive(false)
  end
  if self.searchDownTrans then
    self.searchDownTrans.eulerAngles = LuaGeometry.GetTempVector3(0, 0, -90)
  end
end

function AstrolabeView:DoSearchPoint(value)
  if self.searchPoints == nil then
    self.searchPoints = {}
  else
    TableUtility.TableClear(self.searchPoints)
  end
  self.curBordData:MatchSpecialPointByName(value, self.searchPoints, true)
  self.searchPointsCtl:ResetPosition()
  if #self.searchPoints == 0 then
    local spcPoints = self.curBordData:GetAllSpeicalPoints(true)
    self.searchPointsCtl:ResetDatas(spcPoints)
  else
    self.searchPointsCtl:ResetDatas(self.searchPoints)
  end
end

function AstrolabeView:ShowDefaultRecommendPointsEffect()
  if self.searchPoints == nil then
    self.searchPoints = {}
  else
    TableUtility.TableClear(self.searchPoints)
  end
  self:ClearSearchPointEffect()
  local points = self.curBordData:GetAllRecommendPoints()
  for i = 1, #points do
    if not points[i]:IsActive() then
      self:AddSearchPointEffect(points[i])
    end
  end
end

function AstrolabeView:DoPathChoose(value)
  local data = tonumber(value)
  self.pathChoosePopUpDownLabel.text = PathChooseOption[data][1]
  local savedata = localSaveProxy:GetAstrolabeView_PathFliter()
  if data == savedata then
    return
  end
  localSaveProxy:SetAstrolabeView_PathFliter(data)
  self.pathFliterValue = math.floor(data)
end

function AstrolabeView:UpdateActiveInfo()
  self:UpdateSimulateSearchInfo()
  self:UpdateHandleCost(nil)
end

function AstrolabeView:UpdateSimulateSearchInfo()
  local savedata2 = localSaveProxy:GetAstrolabeView_PathFliter()
  self.pathFliterValue = math.floor(tonumber(savedata2))
  for i = 1, #PathChooseOption do
    if PathChooseOption[i][2] == savedata2 then
      self.pathChoosePopUpDownLabel.text = PathChooseOption[i][1]
      break
    end
  end
end

function AstrolabeView:ShowAndUpdateSimulateSaveInfo()
  self.pathButton_Symbol.spriteName = "xingpan_icon_path"
  self.saveInfoShow = true
  self.maskPointsDirty = true
  TableUtility.TableClear(self.savePointsMap)
  local planIdsMap = self.curBordData:GetPlanIdsMap()
  if planIdsMap == nil or not next(planIdsMap) then
    self:RedrawHandlePoints()
    return
  end
  for guid, _ in pairs(planIdsMap) do
    self.savePointsMap[guid] = Astrolabe_Handle_PointType.Simulate_Save
  end
  self:RedrawHandlePoints()
end

function AstrolabeView:HideAndResetSimulateSaveInfo()
  if self.inSaveMode then
    return
  end
  self.pathButton_Symbol.spriteName = "xingpan_icon_path_hide"
  self.saveInfoShow = false
  self.maskPointsDirty = true
  TableUtility.TableClear(self.savePointsMap)
  self:RedrawHandlePoints()
end

local costData = {}
local addReusableCostDataElement = function(id, num)
  if not num then
    TableUtility.ArrayPushBack(costData, id)
    return
  end
  local t = ReusableTable.CreateArray()
  TableUtility.ArrayPushBack(t, id)
  TableUtility.ArrayPushBack(t, num)
  TableUtility.ArrayPushBack(costData, t)
end
local clearCostData = function()
  for _, t in pairs(costData) do
    if type(t) == "table" then
      ReusableTable.DestroyAndClearArray(t)
    end
  end
  TableUtility.TableClear(costData)
end
local checkIn = function(state, pointState)
  if type(pointState) == "table" then
    for _, st in pairs(pointState) do
      if state == st then
        return true
      end
    end
    return false
  else
    return state == pointState
  end
end

function AstrolabeView:UpdateHandleCost(pointState, title, checkValid)
  if title then
    self.simulateBord_Title.text = title
  end
  if not pointState then
    self.simulateCostGridCtl:ResetDatas(_EmptyTable)
    return
  end
  self.handleCostRecv = self.handleCostRecv or {}
  TableUtility.TableClear(self.handleCostRecv)
  local pointData
  for id, state in pairs(self.handlePointsMap) do
    if checkIn(state, pointState) then
      pointData = self.curBordData:GetPointByGuid(id)
      if checkValid == nil or checkValid(pointData) then
        self:_HelpUpdateActiveCostData(pointData:GetCost(), self.handleCostRecv, 1)
      end
    end
  end
  if pointState == Astrolabe_Handle_PointType.Reset then
    for nonBinded, binded in pairs(GameConfig.BindItem) do
      self.handleCostRecv[binded] = self.handleCostRecv[nonBinded]
      self.handleCostRecv[nonBinded] = nil
    end
  else
    AstrolabeProxy.TryConvertBindedCostMap(self.handleCostRecv)
  end
  for id, num in pairs(self.handleCostRecv) do
    if num and 0 < num then
      addReusableCostDataElement(id, num)
    end
  end
  self.simulateCostGridCtl:ResetDatas(costData)
  clearCostData()
end

function AstrolabeView:ClickActiveButton()
  if self.choosePointData == nil then
    return
  end
  if self.inSaveMode then
    local pid = self.choosePointData.guid
    if self.curBordData:CheckIsInPlaned(pid) then
      self:TryResetPoints()
    else
      self:TrySavePoints()
    end
  elseif self.choosePointData:IsActive() then
    self:TryResetPoints()
  else
    self:TryActivePoints()
  end
  self:HideActiveBord()
end

function AstrolabeView:ShowOrHidePointActiveInfo(b)
  if self.inSaveMode and not self.init_inSaveModePriStateMap then
    self.init_inSaveModePriStateMap = true
    TableUtility.TableClear(self.inSaveModePriStateMap)
    local plateMap = self.curBordData:GetPlateMap()
    for _, plate in pairs(plateMap) do
      local pointMap = plate:GetPointMap()
      for _, pointCell in pairs(pointMap) do
        if Astrolabe_Origin_PointID ~= pointCell.guid then
          self.inSaveModePriStateMap[pointCell.guid] = Astrolabe_PointData_State.Lock
        else
          self.inSaveModePriStateMap[pointCell.guid] = Astrolabe_PointData_State.On
        end
      end
    end
  end
  self.screenView:RefreshDraw(true)
end

function AstrolabeView:DoServerActive()
  if #self.handlePointsList == 0 then
    return
  end
  local activePointsMap = AstrolabeProxy.Instance:GetActivePointsMap()
  local id
  for i = #self.handlePointsList, 1, -1 do
    id = self.handlePointsList[i]
    if activePointsMap[id] then
      table.remove(self.handlePointsList, i)
    end
  end
  self:CheckNonBindedThenCallActivate()
end

function AstrolabeView:BuildActiveHandlePath(pointState, searchFrom, checkActive, clearPre, notShowActiveBord)
  if clearPre then
    TableUtility.TableClear(self.handlePointsMap)
    TableUtility.ArrayClear(self.handlePointsList)
  end
  local id = self.choosePointData and self.choosePointData.guid
  local pathIds = FunctionAstrolabe.GetPath(id, math.floor(self.pathFliterValue), searchFrom)
  if pathIds == nil or #pathIds == 0 then
    MsgManager.ShowMsgByIDTable(2852)
    self:ResetHandlePointsInfo()
    self:RedrawHandlePoints()
    return
  end
  self.maskPointsDirty = true
  local pointData, cost, left_Cost, _helpCheckNotEnough
  if checkActive then
    left_Cost = {}
    left_Cost[100] = MyselfProxy.Instance:GetROB()
    left_Cost[AstrolabeProxy.ContributeItemId] = AstrolabeProxy.GetContributeNum() + AstrolabeProxy.GetBindedContributeNum()
    left_Cost[AstrolabeProxy.GoldMedalItemId] = AstrolabeProxy.GetGoldMedalNum() + AstrolabeProxy.GetBindedGoldMedalNum()
    
    function _helpCheckNotEnough(t)
      for k, v in pairs(t) do
        if type(v) == "number" and v < 0 then
          return true
        end
      end
      return false
    end
  end
  local suc
  local handlePointNum = 0
  local canActivePointNum = 0
  for i = 1, #pathIds do
    pointData = self.curBordData:GetPointByGuid(pathIds[i])
    self.handlePointsMap[pathIds[i]] = pointState
    suc = true
    cost = pointData:GetCost()
    if checkActive then
      if not pointData:IsActive() then
        self:_HelpUpdateActiveCostData(cost, left_Cost, -1)
        handlePointNum = handlePointNum + 1
      end
      if _helpCheckNotEnough(left_Cost) then
        self.handlePointsMap[pathIds[i]] = Astrolabe_Handle_PointType.Active_NotCan
        suc = false
      end
      if not pointData:IsActive() and suc then
        canActivePointNum = canActivePointNum + 1
      end
    else
      handlePointNum = handlePointNum + 1
    end
    if suc then
      table.insert(self.handlePointsList, pathIds[i])
    end
  end
  if not notShowActiveBord then
    self.activeBord:SetActive(true)
  end
  if checkActive then
    self.activeBord_ActivePoint.text = canActivePointNum .. "/" .. handlePointNum
  else
    self.activeBord_ActivePoint.text = handlePointNum
  end
  local pid = self.choosePointData.guid
  if self.curBordData:CheckIsInPlaned(pid) then
    self.activeBord_SimulateResetButton:SetActive(true)
    self.activeBord_SimulateConfirmButton:SetActive(false)
  else
    self.activeBord_SimulateResetButton:SetActive(false)
    self.activeBord_SimulateConfirmButton:SetActive(true)
  end
  self:RedrawHandlePoints()
  return canActivePointNum
end

function AstrolabeView:_HelpUpdateActiveCostData(cost, costRev, operate)
  operate = operate or 1
  for i = 1, #cost do
    local id, value = cost[i][1], cost[i][2]
    costRev[id] = costRev[id] or 0
    costRev[id] = costRev[id] + value * operate
  end
end

function AstrolabeView:TryActivePoints()
  self.handleState = AstrolabeView.HandleSate.Active
  local canActivePointNum = self:BuildActiveHandlePath(Astrolabe_Handle_PointType.Active_Can, FunctionAstrolabe.SearchFromType.Active, true)
  local checkValid = function(pointData)
    return not pointData:IsActive()
  end
  self:UpdateHandleCost({
    Astrolabe_Handle_PointType.Active_Can,
    Astrolabe_Handle_PointType.Active_NotCan
  }, ZhString.AstrolabeView_Simulation_CostTtile, checkValid)
  if canActivePointNum < 1 then
    self.activeBord_ConfirmButton_Sprite.color = ColorUtil.NGUIShaderGray
    self.activeBord_ConfirmButton_Sp.color = ColorUtil.NGUIShaderGray
    self.activeBord_ConfirmButton_Collider.enabled = false
  else
    self.activeBord_ConfirmButton_Sprite.color = ColorUtil.NGUIWhite
    self.activeBord_ConfirmButton_Sp.color = ColorUtil.NGUIWhite
    self.activeBord_ConfirmButton_Collider.enabled = true
  end
  self:RedrawHandlePoints()
end

function AstrolabeView:DoServerReset()
  if self.inSaveMode then
    self:DoServerReset_Plan()
  else
    self:DoServerReset_Active()
  end
end

function AstrolabeView:DoServerReset_Active()
  if PvpProxy.Instance:IsFreeFire() then
    MsgManager.ShowMsgByIDTable(26258)
    return
  end
  if self.choosePointData.guid == Astrolabe_Origin_PointID then
    ServiceAstrolabeCmdProxy.Instance:CallAstrolabeResetCmd({
      Astrolabe_Origin_PointID
    })
    return
  end
  TableUtility.ArrayClear(self.handlePointsList)
  local pointData
  for id, state in pairs(self.handlePointsMap) do
    if state == Astrolabe_Handle_PointType.Reset then
      pointData = self.curBordData:GetPointByGuid(id)
      pointData:SetOldState(pointData:GetState())
      table.insert(self.handlePointsList, id)
    end
  end
  if #self.handlePointsList > 0 then
    ServiceAstrolabeCmdProxy.Instance:CallAstrolabeResetCmd(self.handlePointsList)
  end
end

function AstrolabeView:DoServerReset_Plan()
  if self.choosePointData.guid == Astrolabe_Origin_PointID then
    self:DoServerSave({})
    return
  end
  self:DoServerSave()
end

function AstrolabeView:TryResetPoints(notShowResetBord)
  TableUtility.TableClear(self.handlePointsMap)
  TableUtility.TableClear(self.handlePointsList)
  local id = self.choosePointData.guid
  local pointIds, pointData = {}
  if id == Astrolabe_Origin_PointID then
    local pointsMap
    if self.inSaveMode then
      pointsMap = self.curBordData:GetPlanIdsMap()
    else
      pointsMap = self.curBordData:GetActivePointsMap()
    end
    for id, _ in pairs(pointsMap) do
      pointData = self.curBordData:GetPointByGuid(id)
      if self.inSaveMode then
        table.insert(pointIds, id)
      elseif pointData:IsActive() then
        table.insert(pointIds, id)
      end
    end
  else
    local pointIdMap
    if self.inSaveMode then
      pointIdMap = self.curBordData:ResetPlanPoint(id)
    else
      pointIdMap = self.curBordData:ResetActivePoint(id)
    end
    for id, _ in pairs(pointIdMap) do
      table.insert(pointIds, id)
    end
  end
  if pointIds == nil or #pointIds == 0 then
    self:RedrawHandlePoints()
    return false
  end
  self.handleState = AstrolabeView.HandleSate.Reset
  self.maskPointsDirty = true
  local cost_slivernum = 0
  for i = 1, #pointIds do
    pointData = self.curBordData:GetPointByGuid(pointIds[i])
    self.handlePointsMap[pointIds[i]] = Astrolabe_Handle_PointType.Reset
    if pointData:IsActive() then
      table.insert(self.handlePointsList, pointIds[i])
    else
      MsgManager.ShowMsgByID(41239)
      self:RedrawHandlePoints()
      return false
    end
  end
  if not self.inSaveMode then
    local checkValid = function(pointData)
      return pointData:IsActive()
    end
    self:UpdateHandleCost(Astrolabe_Handle_PointType.Reset, ZhString.AstrolabeView_Simulation_ReturnTtile, checkValid)
  else
    self:UpdateHandleCost(nil, ZhString.AstrolabeView_Simulation_ReturnTtile)
  end
  self:RedrawHandlePoints()
  self.resetBord_ResetPoint.text = #pointIds
  if not notShowResetBord then
    self.resetBord:SetActive(true)
  end
  local pid = self.choosePointData.guid
  if self.curBordData:CheckIsInPlaned(pid) then
    self.resetBord_SimulateResetButton:SetActive(true)
    self.resetBord_SimulateConfirmButton:SetActive(false)
  else
    self.resetBord_SimulateResetButton:SetActive(false)
    self.resetBord_SimulateConfirmButton:SetActive(true)
  end
  self.resetBord_CostZeny.text = cost_slivernum
  self.resetBord_ConfirmButton_Sprite.color = ColorUtil.NGUIWhite
  self.resetBord_ConfirmButton_Sp.color = ColorUtil.NGUIWhite
  self.resetBord_ConfirmButton_Collider.enabled = true
  return true
end

function AstrolabeView:DoServerSave(savePMap)
  if savePMap == nil then
    savePMap = {}
    for id, state in pairs(self.savePointsMap) do
      if state == Astrolabe_Handle_PointType.Simulate_Save then
        savePMap[id] = 1
      else
        savePMap[id] = nil
      end
    end
    for id, state in pairs(self.handlePointsMap) do
      if state == Astrolabe_Handle_PointType.Simulate_Save then
        savePMap[id] = 1
      else
        savePMap[id] = nil
      end
    end
  end
  if self.saveStars == nil then
    self.saveStars = {}
  else
    TableUtility.TableClear(self.saveStars)
  end
  local insertSort = TableUtility.InsertSort
  local insertSortFunc = function(l, r)
    return r < l
  end
  for id, _ in pairs(savePMap) do
    insertSort(self.saveStars, id, insertSortFunc)
  end
  ServiceAstrolabeCmdProxy.Instance:CallAstrolabePlanSaveCmd(self.saveStars)
  TableUtility.TableClear(self.saveStars)
end

function AstrolabeView:TrySavePoints(notShowActiveBord)
  self.handleState = AstrolabeView.HandleSate.Simulate
  self:BuildActiveHandlePath(Astrolabe_Handle_PointType.Simulate_Save, FunctionAstrolabe.SearchFromType.Plan, nil, true, notShowActiveBord)
  local planIdsMap = AstrolabeProxy.Instance:GetPlanIdsMap()
  local checkValid = function(pointData)
    return planIdsMap[pointData.id] == nil
  end
  self:UpdateHandleCost(Astrolabe_Handle_PointType.Simulate_Save, ZhString.AstrolabeView_Simulation_CostTtile, checkValid)
end

function AstrolabeView:ResetHandlePointsInfo(notTweenBord)
  self.maskPointsDirty = true
  self.handleState = AstrolabeView.HandleSate.None
  TableUtility.TableClear(self.handlePointsMap)
  TableUtility.TableClear(self.handlePointsList)
  self:UpdateHandleCost(nil)
  self.activeBord:SetActive(false)
  self.resetBord:SetActive(false)
  self.activeBord_ConfirmButton_Sprite.color = ColorUtil.NGUIWhite
  self.activeBord_ConfirmButton_Sp.color = ColorUtil.NGUIWhite
  self.activeBord_ConfirmButton_Collider.enabled = true
  self:RedrawHandlePoints()
end

function AstrolabeView:ClickPoint_Active(pointData)
  if self.handleState ~= AstrolabeView.HandleSate.None then
    self:ResetHandlePointsInfo()
    self.waitCancelChooseOnect = true
  end
  self:ShowActiveBord()
  if self.inSaveMode then
    self:ShowAndUpdateSimulateSaveInfo()
    if self.curBordData:CheckIsInPlaned(pointData.guid) then
      self.activeButton_label.text = ZhString.AstrolabeView_Reset
    else
      self.activeButton_label.text = ZhString.AstrolabeView_Save
    end
  else
    local state = pointData:GetState()
    if state == Astrolabe_PointData_State.On then
      self.activeButton_label.text = ZhString.AstrolabeView_Reset
    else
      self.activeButton_label.text = ZhString.AstrolabeView_Active
    end
  end
end

function AstrolabeView:ShowActiveBord()
  self.activeInfoTween:Play(true)
end

function AstrolabeView:HideActiveBord()
  self.activeInfoTween:Play(false)
end

function AstrolabeView:MapActiveEvent()
  self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabeActivateStarCmd, self.HandleActivePoints)
  self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabeResetCmd, self.HandleResetPoints)
  self:AddListenEvt(ServiceEvent.AstrolabeCmdAstrolabePlanSaveCmd, self.HandleSavePoints)
end

function AstrolabeView:HandleActivePoints(note)
  local stars = note.body.stars
  local animDatas = {}
  local add_EffectMap = {}
  local add_SpecialEffectMap = {}
  if stars[1] == Astrolabe_Origin_PointID then
    local pointData = self.curBordData:GetPointByGuid(Astrolabe_Origin_PointID)
    table.insert(animDatas, pointData)
  else
    for i = 1, #self.handlePointsList do
      local pointData = self.curBordData:GetPointByGuid(self.handlePointsList[i])
      if pointData:IsActive() then
        table.insert(animDatas, pointData)
      end
      local effect = pointData:GetEffect()
      if effect then
        for attriKey, value in pairs(effect) do
          if add_EffectMap[attriKey] then
            add_EffectMap[attriKey] = add_EffectMap[attriKey] + value
          else
            add_EffectMap[attriKey] = value
          end
        end
      end
      local specialEffect = pointData:GetSpecialEffect()
      if specialEffect then
        if add_SpecialEffectMap[specialEffect] == nil then
          add_SpecialEffectMap[specialEffect] = 1
        else
          add_SpecialEffectMap[specialEffect] = add_SpecialEffectMap[specialEffect] + 1
        end
      end
    end
  end
  self:PlayUISound(AudioMap.UI.LinkRune2)
  self:PlayHandleAnims(animDatas, "ToUnlock", function()
    for _, cell in pairs(self.plateCellMap) do
      cell:Refresh()
    end
    self:RedrawOuterLine()
    self.curBordData:CheckNeed_DoServer_InitPlate()
  end)
  local PropNameConfig = Game.Config_PropName
  local str = ""
  for attriType, value in pairs(add_EffectMap) do
    local config = PropNameConfig[attriType]
    if config ~= nil then
      str = config.PropName
      if 0 < value then
        str = str .. " +"
      end
      if config.IsPercent == 1 then
        str = str .. value * 100 .. "%"
      else
        str = str .. value
      end
      MsgManager.ShowMsgByIDTable(2850, {str})
    end
  end
  for specialid, addlv in pairs(add_SpecialEffectMap) do
    local specialData = Table_RuneSpecial[specialid]
    MsgManager.ShowMsgByIDTable(2850, {
      specialData.RuneName
    })
  end
  self:ResetHandlePointsInfo(true)
  if self.choosePointData then
    local state = self.choosePointData:GetState()
    if state == Astrolabe_PointData_State.Lock then
      self.activeButton_label.text = ZhString.AstrolabeView_Active
    elseif state == Astrolabe_PointData_State.On then
      self.activeButton_label.text = ZhString.AstrolabeView_Reset
    elseif state == Astrolabe_PointData_State.Off then
      self.activeButton_label.text = ZhString.AstrolabeView_Active
    end
  end
end

function AstrolabeView:HandleResetPoints(note)
  local animDatas = {}
  local min_EffectMap = {}
  local min_SpecialEffectMap = {}
  for i = 1, #self.handlePointsList do
    local pointData = self.curBordData:GetPointByGuid(self.handlePointsList[i])
    if not pointData:IsActive() then
      table.insert(animDatas, pointData)
      local effect = pointData:GetEffect()
      if effect then
        for attriKey, value in pairs(effect) do
          if min_EffectMap[attriKey] then
            min_EffectMap[attriKey] = min_EffectMap[attriKey] - value
          else
            min_EffectMap[attriKey] = -value
          end
        end
      end
      local specialEffect = pointData:GetSpecialEffect()
      if specialEffect then
        if min_SpecialEffectMap[specialEffect] == nil then
          min_SpecialEffectMap[specialEffect] = 1
        else
          min_SpecialEffectMap[specialEffect] = min_SpecialEffectMap[specialEffect] + 1
        end
      end
    end
  end
  local PropNameConfig, str = Game.Config_PropName
  for attriType, value in pairs(min_EffectMap) do
    local config = PropNameConfig[attriType]
    if config ~= nil then
      str = config.PropName
      if 0 < value then
        str = str .. " +"
      end
      if config.IsPercent == 1 then
        str = str .. value * 100 .. "%"
      else
        str = str .. value
      end
      MsgManager.ShowMsgByIDTable(2851, {str})
    end
  end
  for specialid, minlv in pairs(min_SpecialEffectMap) do
    local specialData = Table_RuneSpecial[specialid]
    MsgManager.ShowMsgByIDTable(2851, {
      specialData.RuneName
    })
  end
  self:ResetHandlePointsInfo(true)
  self:PlayUISound(AudioMap.UI.ResetRune)
  self:PlayHandleAnims(animDatas, "AtharReset", function()
    for _, cell in pairs(self.plateCellMap) do
      cell:Refresh()
    end
    self:RedrawOuterLine()
    self.curBordData:CheckNeed_DoServer_InitPlate()
  end)
end

function AstrolabeView:HandleSavePoints(note)
  self:ShowAndUpdateSimulateSaveInfo()
  self:ResetHandlePointsInfo(true)
end

function AstrolabeView:UpdatePreview()
  self.helpGO:SetActive(self.isPreview ~= true)
  self.activeInfo:SetActive(self.isPreview ~= true)
end

function AstrolabeView:DoOneKnob()
  FunctionAstrolabe.DFSOneKnobActive(self.handlePointsList, AstrolabeProxy.GetContributeNum() + AstrolabeProxy.GetBindedContributeNum(), AstrolabeProxy.GetGoldMedalNum() + AstrolabeProxy.GetBindedGoldMedalNum())
  self:CheckNonBindedThenCallActivate()
  self:HideActiveBord()
end

function AstrolabeView:CheckNonBindedThenCallActivate()
  local callActivate = function()
    ServiceAstrolabeCmdProxy.Instance:CallAstrolabeActivateStarCmd(self.handlePointsList)
  end
  local simulateCostCells, hasNonBindedItem = self.simulateCostGridCtl:GetCells(), false
  TableUtility.TableClear(self.convertPopUpData.convert)
  for _, cell in pairs(simulateCostCells) do
    if cell.id and GameConfig.BindItem[cell.id] then
      hasNonBindedItem = true
      self.convertPopUpData.convert[cell.id] = cell.num
    end
  end
  if hasNonBindedItem then
    self.convertPopUpData.confirmFunc = callActivate
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.AstrolabeAskForConvertPopUp,
      viewdata = self.convertPopUpData
    })
  else
    callActivate()
  end
end
