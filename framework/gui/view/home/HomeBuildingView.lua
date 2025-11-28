autoImport("HomeFurniturOutLine")
autoImport("NFurnitureData")
autoImport("HomeBuildingSeriesTypeCell")
autoImport("HomeBuildingTypeCell")
autoImport("HomeContentCell")
autoImport("HomeBuildingRenovationPosCell")
autoImport("PhotographSingleFilterText")
autoImport("HomeBuildingCameraControl")
autoImport("HomeBuildingWorldGridControl")
autoImport("HomeBuildingGuideView")
autoImport("HomeBuildingSceneBPControl")
autoImport("QuickUsePopupFuncCell")
HomeBuildingView = class("HomeBuildingView", ContainerView)
HomeBuildingView.ViewType = UIViewType.NormalLayer
HomeBuildingView.CellSize = 0.5
HomeBuildingView.SelectHeight = 0.18
local E_EditMode = {Building = 1, Recovery = 2}
local FilterID_ShowGrid = "HomeBuildingView_ShowGrid"
local FilterID_ShowItemTip = "HomeBuildingView_ShowItemTip"
local FilterID_ShowRotateButtons = "HomeBuildingView_ShowRotateButtons"
local SettingFilters = {
  {
    id = FilterID_ShowItemTip,
    text = ZhString.HomeBuilding_ShowContentTip
  },
  {
    id = FilterID_ShowGrid,
    text = ZhString.HomeBuilding_ShowGrid,
    isSelect = false
  },
  {
    id = FilterID_ShowRotateButtons,
    text = ZhString.HomeBuilding_ShowRotateButtons
  }
}
local m_typeTipLocalOffset = 75
local m_typeTipShowTime = 0.8
local m_typeTipFadeTime = 0.5
local m_renovationInterval = 1
local m_color_outlineRed = LuaColor(0.7843137254901961, 0, 0.058823529411764705, 1)
local m_color_greenScore = LuaColor(0.25098039215686274, 0.5450980392156862, 0, 1)
local m_color_redScore = LuaColor(0.9725490196078431, 0.27450980392156865, 0.29411764705882354, 1)
local m_emptyTable = {}

function HomeBuildingView:Init()
  self:InitSeriesTypeDatas()
  self:FindObjs()
  self:InitViewEvents()
  self:InitEventListeners()
  self.recoveryItemsMap = {}
  self.renovationOutlineMap = {}
  self.cameraControl = self:AddSubView("HomeBuildingCameraControl", HomeBuildingCameraControl)
  self.worldGridControl = self:AddSubView("HomeBuildingWorldGridControl", HomeBuildingWorldGridControl)
  self.bpControl = self:AddSubView("HomeBuildingSceneBPControl", HomeBuildingSceneBPControl)
  self.guideView = self:AddSubView("HomeBuildingGuideView", HomeBuildingGuideView)
end

function HomeBuildingView:InitSeriesTypeDatas()
  local l_furnitureSeriesConfig = GameConfig.Home.FurnitureSeries
  for i = 1, #l_furnitureSeriesConfig do
    l_furnitureSeriesConfig[i].buildType = HomeProxy.BuildType.Furniture
  end
  local l_renovationSeries = {}
  local dataTypes
  for i = 1, HomeManager.Me():GetCurMaxFloorIndex() do
    dataTypes = HomeManager.Me():GetDataTypesArray(HomeProxy.BuildType.Renovation, i)
    if dataTypes and 0 < #dataTypes then
      l_renovationSeries[#l_renovationSeries + 1] = {
        icon = string.format("home_icon_%dF", i),
        selectIcon = string.format("home_icon_%dF_selection", i),
        seriesType = i,
        buildType = HomeProxy.BuildType.Renovation
      }
    end
  end
  self.seriesTypeDatas = {
    [HomeProxy.BuildType.Furniture] = l_furnitureSeriesConfig,
    [HomeProxy.BuildType.Renovation] = l_renovationSeries
  }
end

function HomeBuildingView:FindObjs()
  self.tsfItemRoot = HomeManager.Me():GetFurnitureRootTransform()
  self.objBuildUI = self:FindGO("BuildUI")
  self.widgetBuildUI = self.objBuildUI:GetComponent(UIWidget)
  self.objFrontPanel = self:FindGO("FrontPanel", self.objBuildUI)
  local l_objBoard = self:FindGO("OperateBoard", self.objFrontPanel)
  local l_gridButtons = self:FindComponent("gridOperateButtons", UIGrid, l_objBoard)
  self.tabOperateBoard = {
    gameObject = l_objBoard,
    transform = l_objBoard.transform,
    gridButtons = l_gridButtons,
    cellWidth = l_gridButtons.cellWidth,
    sprBoardBG = self:FindComponent("BoardBG", UISprite, l_objBoard),
    objBtnRotate = self:FindGO("btnRotate", l_objBoard),
    objBtnRecovery = self:FindGO("btnRecovery", l_objBoard),
    objBtnCancel = self:FindGO("btnCancel", l_objBoard)
  }
  self.objActiveWithBuildUI = self:FindGO("ActiveWithBuildUI", self.objFrontPanel)
  local l_objItemTypeTip = self:FindGO("labItemTypeTip", self.objActiveWithBuildUI)
  self.tabItemTypeTip = {
    gameObject = l_objItemTypeTip,
    transform = l_objItemTypeTip.transform,
    label = l_objItemTypeTip:GetComponent(UILabel),
    sprBG = self:FindComponent("BG", UISprite, l_objItemTypeTip)
  }
  local l_objItemTip = self:FindGO("ItemTip", self.objActiveWithBuildUI)
  local l_objTipUnlockContents = self:FindGO("UnlockContent", l_objItemTip)
  local l_objTipLockContents = self:FindGO("LockContent", l_objItemTip)
  local l_objItemSize = self:FindGO("labItemSize", l_objTipUnlockContents)
  local l_objTipLabMoveRoot = self:FindGO("tipLabMoveRoot", l_objTipUnlockContents)
  self.tabItemTip = {
    gameObject = l_objItemTip,
    transform = l_objItemTip.transform,
    objUnlockContents = l_objTipUnlockContents,
    objLockContents = l_objTipLockContents,
    labItemName = self:FindComponent("labItemName", UILabel, l_objItemTip),
    labItemScore = self:FindComponent("labItemScore", UILabel, l_objTipUnlockContents),
    labItemSize = l_objItemSize:GetComponent(UILabel),
    labItemType = self:FindComponent("labItemType", UILabel, l_objTipLabMoveRoot),
    labAreaLimit = self:FindComponent("labAreaLimit", UILabel, l_objTipLabMoveRoot),
    labCondition = self:FindComponent("labCondition", UILabel, l_objTipLockContents),
    objBtnMake = self:FindGO("btnMake", l_objItemTip),
    tsfTipLabMoveRoot = l_objTipLabMoveRoot.transform,
    vecLabsPos_Furniture = l_objTipLabMoveRoot.transform.localPosition,
    vecLabsPos_Renovation = l_objItemSize.transform.localPosition
  }
  local l_objCell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HomeContentCell"), self:FindGO("ItemShow", l_objItemTip).transform)
  self.tabItemTip.homeContentCell = HomeContentCell.new(l_objCell)
  self.tabItemTip.homeContentCell:DisableFunctions(true)
  if not self.quickUsePopUp then
    local l_objQuickUse = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIPopup("QuickUsePopup"), self:FindGO("QuickUseRoot", self.objActiveWithBuildUI))
    l_objQuickUse.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.quickUsePopUp = QuickUsePopupFuncCell.new(l_objQuickUse)
  end
  self.quickUsePopUp:Hide()
  l_objCell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HomeContentCell"), self:FindGO("OperateItem", self.objFrontPanel).transform)
  self.curOperateCell = HomeContentCell.new(l_objCell)
  self.curOperateCell:DisableFunctions()
  self.objAdjustFurnitureBtns = self:FindGO("AdjustFurnitureBtns", self.objFrontPanel)
  self.tsfAdjustFurnitureBtns = self.objAdjustFurnitureBtns.transform
  self.objInputSearch = self:FindGO("inputSearch", self.objFrontPanel)
  self.inputSearch = self.objInputSearch:GetComponent(UIInput)
  self.inputSearch.defaultText = ZhString.HomeBuilding_FurnitureName
  self.objSettingBoard = self:FindGO("SettingBoard", self.objFrontPanel)
  self.listSettings = UIGridListCtrl.new(self:FindComponent("gridSettings", UIGrid, self.objSettingBoard), PhotographSingleFilterText, "PhotographSingleFilterText")
  local l_objHomeScore = self:FindGO("HomeScore", self.objFrontPanel)
  local l_objAddScore = self:FindGO("labAddScore")
  self.tabScoreBoard = {
    labHomeLv = self:FindComponent("labHomeLv", UILabel, l_objHomeScore),
    labHomeScore = self:FindComponent("labHomeScore", UILabel, l_objHomeScore),
    labAddScore = l_objAddScore:GetComponent(UILabel),
    tweenerAddScore = l_objAddScore:GetComponent(TweenAlpha),
    sliderHomeScore = l_objHomeScore:GetComponent(UISlider)
  }
  self.objTypeSelectRoot = self:FindGO("TypeSelectRoot", self.objBuildUI)
  self.objBtnEditFurniture = self:FindGO("btnEditFurniture", self.objTypeSelectRoot)
  self.objBtnEditFurnitureSelect = self:FindGO("Select", self.objBtnEditFurniture)
  self.objBtnEditRenovation = self:FindGO("btnEditRenovation", self.objTypeSelectRoot)
  self.objBtnEditRenovationSelect = self:FindGO("Select", self.objBtnEditRenovation)
  self.objBtnSwitchShowUI = self:FindGO("btnSwitchShowUI", self.objBuildUI)
  self.tsfBtnSwitchShowUIIcon = self:FindGO("Icon", self.objBtnSwitchShowUI).transform
  self.objListSeriesType = self:FindGO("ScrollSeriesType", self.objTypeSelectRoot)
  self.listSeriesTypes = UIGridListCtrl.new(self:FindComponent("gridSeriesType", UIGrid, self.objListSeriesType), HomeBuildingSeriesTypeCell, "HomeBuildingSeriesTypeCell")
  local l_objScrollDataTypes = self:FindGO("ScrollDataType", self.objTypeSelectRoot)
  self.scrollDataType = l_objScrollDataTypes:GetComponent(UIScrollView)
  self.listDataTypes = UIGridListCtrl.new(self:FindComponent("gridDataType", UIGrid, l_objScrollDataTypes), HomeBuildingTypeCell, "HomeBuildingTypeCell")
  self.listRenovationPoses = UIGridListCtrl.new(self:FindComponent("gridRenovationPos", UIGrid, self.objBuildUI), HomeBuildingRenovationPosCell, "HomeBuildingSeriesTypeCell")
  local l_objListItem = self:FindGO("ScrollItem", self.objBuildUI)
  self.scrollHomeContentCells = l_objListItem:GetComponent(UIScrollView)
  self.listHomeContentCells = WrapListCtrl.new(self:FindGO("itemCellsContainer", l_objListItem), HomeContentCell, "HomeContentCell", WrapListCtrl_Dir.Horizontal, nil, nil, true)
end

function HomeBuildingView:InitEventListeners()
  local l_objInputAccepter = self:FindGO("InputAccepter")
  self:AddPressEvent(l_objInputAccepter, function(go, isPress)
    self:OnPress(go, isPress)
  end)
  self:AddDragEvent(l_objInputAccepter, function(go, delta)
    self:OnDrag(go, delta)
  end)
  self:AddClickEvent(self:FindGO("btnConfirm", self.tabOperateBoard.gameObject), function()
    self:OnClickBtnConfirm()
  end)
  self:AddClickEvent(self.tabOperateBoard.objBtnCancel, function()
    self:OnClickBtnCancel()
  end)
  self:AddClickEvent(self.tabOperateBoard.objBtnRotate, function()
    self:OnClickBtnRotate()
  end)
  self:AddClickEvent(self.tabOperateBoard.objBtnRecovery, function()
    self:RemoveCurOperateItem()
  end)
  self:AddClickEvent(self:FindGO("btnAdjustForward", self.objAdjustFurnitureBtns), function()
    self:AdjustFurniturePlaceCell(-1, 0)
  end)
  self:AddClickEvent(self:FindGO("btnAdjustBack", self.objAdjustFurnitureBtns), function()
    self:AdjustFurniturePlaceCell(1, 0)
  end)
  self:AddClickEvent(self:FindGO("btnAdjustLeft", self.objAdjustFurnitureBtns), function()
    self:AdjustFurniturePlaceCell(0, -1)
  end)
  self:AddClickEvent(self:FindGO("btnAdjustRight", self.objAdjustFurnitureBtns), function()
    self:AdjustFurniturePlaceCell(0, 1)
  end)
  self:AddClickEvent(self.objBtnEditFurniture, function()
    self:OnClickBtnEditFurniture()
  end)
  self:AddClickEvent(self.objBtnEditRenovation, function()
    self:OnClickBtnEditRenovation()
  end)
  self:AddClickEvent(self.objBtnSwitchShowUI, function()
    self:OnClickBtnSwitchShowUI()
  end)
  local l_objRightTopButtons = self:FindGO("RightTopButtons", self.objFrontPanel)
  self:AddClickEvent(self:FindGO("btnSearch", l_objRightTopButtons), function()
    self:ShowSearchBoard()
  end)
  self:AddClickEvent(self:FindGO("btnHelp", l_objRightTopButtons), function()
    self:OnClickBtnHelp()
  end)
  self:AddClickEvent(self:FindGO("btnPhoto", l_objRightTopButtons), function()
    self:OnClickBtnPhoto()
  end)
  self:AddClickEvent(self:FindGO("btnSetting", l_objRightTopButtons), function()
    self:ShowSettingBoard(nil, true)
  end)
  self:AddClickEvent(self:FindGO("btnRecovery", l_objRightTopButtons), function()
    self:SetEditRecovery(self.curEditMode ~= E_EditMode.Recovery)
  end)
  self:AddClickEvent(self:FindGO("btnClose", l_objRightTopButtons), function()
    if not self.cameraControl.isForbidOperate then
      self:CloseSelf()
    end
  end)
  self:AddClickEvent(self.tabItemTip.homeContentCell.gameObject, function()
    if self.tabItemTip.homeContentCell.data then
      local tipData = ReusableTable.CreateTable()
      tipData.itemdata = self.tabItemTip.homeContentCell.data:GetItemData()
      self:ShowItemTip(tipData, self.tabItemTip.homeContentCell.icon.sprite, NGUIUtil.AnchorSide.Left, {-260, -208})
      ReusableTable.DestroyAndClearTable(tipData)
    end
  end)
  self:AddClickEvent(self.tabItemTip.objBtnMake, function()
    if not self.tabItemTip.homeContentCell.data then
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HomeTipPopUp,
      viewdata = self.tabItemTip.homeContentCell.data.staticID
    })
  end)
  EventDelegate.Add(self.inputSearch.onSubmit, function()
    self:OnSearchSubmit()
  end)
  self.listSettings:AddEventListener(MouseEvent.MouseClick, self.OnClickSettingFilterCell, self)
  self.listSeriesTypes:AddEventListener(MouseEvent.MouseClick, self.OnClickSeriesTypeCell, self)
  self.listDataTypes:AddEventListener(MouseEvent.MouseClick, self.OnClickDataTypeCell, self)
  self.listHomeContentCells:AddEventListener(MouseEvent.MouseClick, self.OnClickContentCell, self)
  self.listHomeContentCells:AddEventListener(MouseEvent.MousePress, self.OnPressContentCell, self)
  self.listHomeContentCells:AddEventListener(DragDropEvent.OnDrag, self.OnDragContentCell, self)
  self.quickUsePopUp:AddEventListener(UIEvent.CloseUI, self.HandleQuickUsePopupClose, self)
end

function HomeBuildingView:InitViewEvents()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self:AddListenEvt(LoadScene.LoadSceneLoaded, self.CloseSelf)
  self:AddListenEvt(ItemEvent.FurnitureUpdate, self.UpdateContentsStatus)
  self:AddListenEvt(ServiceEvent.SceneManualManualUpdate, self.UpdateContentsStatus)
  self:AddListenEvt(ItemEvent.BetterEquipAdd, self.HandleQuickUseItem)
  self:AddListenEvt(ServiceEvent.HomeCmdHouseDataUpdateHomeCmd, self.HandleHouseDataUpdate)
  self:AddListenEvt(ServiceEvent.HomeCmdFurnitureUpdateHomeCmd, self.HandleFurnitureUpdate)
  self:AddListenEvt(HomeEvent.RenovationChanged, self.RefreshHomeScore)
end

function HomeBuildingView:InitView()
  if not HomeProxy.Instance:IsServerInEditMode() and not HomeManager.ClientTest then
    redlog("服务器不在建造模式下，建造模式退出！")
    self:CloseSelf()
    return
  end
  self.mapInfo = HomeManager.Me():GetMapInfo()
  self.cameraUI = NGUIUtil:GetCameraByLayername("UI")
  self.isBuildUIShow = true
  self.isTypeSelectUIShow = true
  self.curEditMode = E_EditMode.Building
  self.dragScreenMoveEdge = GameConfig.Home.DragScreenMoveEdge
  self.dragScreenMoveSpeed = GameConfig.Home.DragScreenMoveSpeed / 1000
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  self.fUIBoardEdge = self.listHomeContentCells.container:TransformPoint(LuaGeometry.GetTempVector3(0, self.listHomeContentCells.wrap.itemSize / 2, 0)).y
  self.isLastOperateSuccess = true
  self.isShowContentTip = true
  self.curOperateItem = nil
  self.forbidRenovationCounter = 0
  TableUtility.TableClear(self.recoveryItemsMap)
  TableUtility.TableClear(self.renovationOutlineMap)
  self.objSettingBoard:GetComponent(UISprite).height = 26 + self.listSettings.layoutCtrl.cellHeight * #SettingFilters
  self.listSettings:ResetDatas(SettingFilters)
  self:AddMonoUpdateFunction(self.MonoUpdate)
  self:OnClickBtnEditFurniture()
  self:SetHomeScore()
end

function HomeBuildingView:HandleHouseDataUpdate()
  if not HomeProxy.Instance:IsServerInEditMode() and not HomeManager.ClientTest then
    redlog("服务器已退出建造模式，客户端自动关闭建造界面")
    self:CloseSelf()
  end
end

function HomeBuildingView:HandleFurnitureUpdate()
  self:RefreshHomeScore()
  self:UpdateContentsStatus()
end

function HomeBuildingView:SetEditRecovery(isEnterRecoveryMode)
  if isEnterRecoveryMode == nil then
    isEnterRecoveryMode = true
  end
  if isEnterRecoveryMode then
    if self.guideView:CheckOperateForbid() then
      return
    end
    self:OnClickBtnConfirm()
    self:RemoveCurOperateItem()
  end
  self.curEditMode = isEnterRecoveryMode and E_EditMode.Recovery or E_EditMode.Building
  for id, furnitureItem in pairs(self.recoveryItemsMap) do
    self:SelectItem(furnitureItem, false)
  end
  TableUtility.TableClear(self.recoveryItemsMap)
  self.bpControl:SelectFurnitureContent(not isEnterRecoveryMode and self.curContentData or nil)
  self:ShowBuildUI(not isEnterRecoveryMode)
  self:ShowOperateBoard(isEnterRecoveryMode, not isEnterRecoveryMode, not isEnterRecoveryMode)
end

function HomeBuildingView:ShowSearchBoard(isShow)
  if not self.isSearchShow and self.guideView:CheckOperateForbid() then
    return
  end
  if isShow == nil then
    self.isSearchShow = not self.isSearchShow
  else
    self.isSearchShow = isShow
  end
  self.objInputSearch:SetActive(self.isSearchShow)
end

function HomeBuildingView:OnSearchSubmit()
  self:ClearSelectContent()
  local contentDatas = self:SortContentDatas(HomeManager.Me():GetHomeContentDatasArrayByName(self.inputSearch.value))
  self.listHomeContentCells:ResetDatas(contentDatas or m_emptyTable, true)
end

function HomeBuildingView:OnClickBtnHelp()
  if self.guideView:CheckOperateForbid() or not self.cameraControl:IsInited() then
    return
  end
  self.guideView:CheckNeedShowGuide(false)
end

function HomeBuildingView:ShowSettingBoard(isShow, isFinishGuide)
  if isShow == nil then
    self.isSettingBoardShow = not self.isSettingBoardShow
  else
    self.isSettingBoardShow = isShow
  end
  if isFinishGuide then
    self.guideView:FinishGuideStep(HomeBuildingGuideView.Step.ClickSetting)
  end
  self.objSettingBoard:SetActive(self.isSettingBoardShow)
end

function HomeBuildingView:OnClickSettingFilterCell(cell)
  local isSelect = cell:getIsSelect()
  local id = cell.data.id
  if id == FilterID_ShowGrid then
    self.isShowGrid = isSelect
    self.worldGridControl:ShowWorldGrid(isSelect)
    return
  end
  if id == FilterID_ShowItemTip then
    self.isShowContentTip = isSelect
    if self.isShowContentTip then
      self:ShowCurContentTip()
    else
      self.tabItemTip.gameObject:SetActive(false)
    end
    return
  end
  if id == FilterID_ShowRotateButtons then
    self.cameraControl:ShowRotateArrows(isSelect)
    return
  end
  if not isSelect then
    FunctionSceneFilter.Me():StartFilter(id)
    if (id == GameConfig.FilterType.PhotoFilter.Guild or id == GameConfig.FilterType.PhotoFilter.Team) and FunctionSceneFilter.Me():IsFilterBy(GameConfig.FilterType.PhotoFilter.Guild) and FunctionSceneFilter.Me():IsFilterBy(GameConfig.FilterType.PhotoFilter.Team) then
      FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.TeamAndGuild)
    end
  else
    FunctionSceneFilter.Me():EndFilter(id)
    if id == GameConfig.FilterType.PhotoFilter.Guild or id == GameConfig.FilterType.PhotoFilter.Team then
      FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.TeamAndGuild)
    end
  end
end

function HomeBuildingView:OnClickBtnPhoto()
  self.cameraControl:TakePhoto()
end

function HomeBuildingView:OnClickBtnEditFurniture()
  if self.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.SwitchToFurniture) then
    return
  end
  self.objBtnEditFurnitureSelect:SetActive(true)
  self.objBtnEditRenovationSelect:SetActive(false)
  local datas = self.seriesTypeDatas[HomeProxy.BuildType.Furniture]
  self.objListSeriesType:SetActive(1 < #datas)
  self.listSeriesTypes:ResetDatas(datas)
  if 0 < #datas then
    self:OnClickSeriesTypeCell(self.listSeriesTypes:GetCells()[1], true, true)
  else
    self.listDataTypes:ResetDatas(m_emptyTable)
    self.listHomeContentCells:ResetDatas(m_emptyTable)
    self:ClearSelectContent()
  end
  self.guideView:FinishGuideStep(HomeBuildingGuideView.Step.SwitchToFurniture)
end

function HomeBuildingView:OnClickBtnEditRenovation()
  if self.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.SwitchToRenovation) then
    return
  end
  self.objBtnEditFurnitureSelect:SetActive(false)
  self.objBtnEditRenovationSelect:SetActive(true)
  local datas = self.seriesTypeDatas[HomeProxy.BuildType.Renovation]
  self.curSeriesCell = nil
  self.objListSeriesType:SetActive(1 < #datas)
  self.listSeriesTypes:ResetDatas(datas)
  if 0 < #datas then
    self:OnClickSeriesTypeCell(self.listSeriesTypes:GetCells()[1], true, true)
  else
    self.listDataTypes:ResetDatas(m_emptyTable)
    self.listHomeContentCells:ResetDatas(m_emptyTable)
    self:ClearSelectContent()
  end
  self.guideView:FinishGuideStep(HomeBuildingGuideView.Step.SwitchToRenovation)
end

function HomeBuildingView:OnClickSeriesTypeCell(cell, hideTip, force)
  if not force and self.guideView:CheckOperateForbid() then
    return
  end
  if self.curSeriesCell then
    self.curSeriesCell:Select(false)
  end
  self.curSeriesCell = cell
  self.curSeriesCell:Select(true)
  if self.curSeriesCell.tipText and not hideTip then
    self:ShowTypeTip(self.curSeriesCell.tipText, self.curSeriesCell.trans:TransformPoint(LuaGeometry.GetTempVector3(m_typeTipLocalOffset, 0, 0)))
  end
  local dataTypes = HomeManager.Me():GetDataTypesArray(cell.buildType, cell.seriesType)
  self.curDataTypeCell = nil
  self.listDataTypes:ResetDatas(dataTypes or m_emptyTable)
  self.scrollDataType:ResetPosition()
  if dataTypes and 0 < #dataTypes then
    self:OnClickDataTypeCell(self.listDataTypes:GetCells()[1], true, true)
  else
    self:ClearSelectContent()
    self.listHomeContentCells:ResetDatas(m_emptyTable)
  end
  self:CloseMenus()
end

function HomeBuildingView:OnClickDataTypeCell(cell, hideTip, force)
  if not force and self.guideView:CheckOperateForbid() then
    return
  end
  if not self.curSeriesCell then
    LogUtility.Error("丢失当前SeriesTypeCell，操作无法继续，尝试重新进入编辑家具模式。")
    self.OnClickBtnEditFurniture()
    return
  end
  if self.curDataTypeCell then
    self.curDataTypeCell:Select(false)
  end
  self.curDataTypeCell = cell
  self.curDataTypeCell:Select(true)
  if self.curDataTypeCell.tipText and not hideTip then
    self:ShowTypeTip(self.curDataTypeCell.tipText, self.curDataTypeCell.trans:TransformPoint(LuaGeometry.GetTempVector3(m_typeTipLocalOffset, 0, 0)))
  end
  self:ClearSelectContent()
  local contentDatas = HomeManager.Me():GetHomeContentDatasArray(self.curSeriesCell.buildType, self.curSeriesCell.seriesType, cell.dataType)
  self.listHomeContentCells:ResetDatas(self:SortContentDatas(contentDatas) or m_emptyTable, true)
  self:CloseMenus()
  for id, renovationInfo in pairs(self.renovationOutlineMap) do
    HomeFurniturOutLine.Me():RemoveTarget(id)
  end
  TableUtility.TableClear(self.renovationOutlineMap)
  if self.curSeriesCell.buildType ~= HomeProxy.BuildType.Renovation then
    return
  end
  local renovationTypeInfoMap = HomeManager.Me():GetRenovationObjs(self.curSeriesCell.seriesType, cell.dataType)
  for _, renovationInfo in pairs(renovationTypeInfoMap) do
    if renovationInfo.gameObject then
      HomeFurniturOutLine.Me():AddTarget(renovationInfo.gameObject, renovationInfo.id)
      self.renovationOutlineMap[renovationInfo.id] = renovationInfo
    end
  end
  if HomeManager.Me():IsRenovationTypeDivideByPos(self.curDataTypeCell.dataType) then
    return
  end
  local useless, matInfo = next(self.renovationOutlineMap)
  if not matInfo then
    return
  end
  local curRenovationMatName = matInfo.meshRenderer.material.name
  local found = false
  local contentCells = self.listHomeContentCells:GetCells()
  for i = 1, #contentCells do
    if contentCells[i]:IsActive() and HomeManager.Me():IsSameMatetial(contentCells[i].staticID, curRenovationMatName) then
      self:OnClickContentCell(contentCells[i], true)
      found = true
      break
    end
  end
  if found or not contentDatas then
    return
  end
  for i = 1, #contentDatas do
    if HomeManager.Me():IsSameMatetial(contentDatas[i].staticID, curRenovationMatName) then
      self:SelectContentData(contentDatas[i], true, true)
      break
    end
  end
end

function HomeBuildingView:ShowTypeTip(text, vecWorldPos)
  if self.ltTypeTipShow then
    self.ltTypeTipShow:Destroy()
    self.ltTypeTipShow = nil
  end
  local tweenAlpha = self.tabItemTypeTip.gameObject:GetComponent(TweenAlpha)
  if tweenAlpha then
    tweenAlpha.enabled = false
  end
  self.tabItemTypeTip.label.alpha = 1
  self.tabItemTypeTip.label.text = text
  self.tabItemTypeTip.sprBG:ResetAndUpdateAnchors()
  self.tabItemTypeTip.transform.position = vecWorldPos
  self.tabItemTypeTip.gameObject:SetActive(true)
  self.ltTypeTipShow = TimeTickManager.Me():CreateOnceDelayTick(m_typeTipShowTime * 1000, function(owner, deltaTime)
    TweenAlpha.Begin(self.tabItemTypeTip.gameObject, m_typeTipFadeTime, 0)
    self.ltTypeTipShow = nil
  end, self)
end

function HomeBuildingView:OnClickBtnSwitchShowUI()
  if self.guideView:CheckOperateForbid() then
    return
  end
  self.isTypeSelectUIShow = not self.isTypeSelectUIShow
  TweenPosition.Begin(self.objTypeSelectRoot, 0.3, LuaGeometry.GetTempVector3(self.isTypeSelectUIShow and 0 or -240, 0, 0))
  TweenAlpha.Begin(self.objTypeSelectRoot, 0.3, self.isTypeSelectUIShow and 1 or 0)
  self.tsfBtnSwitchShowUIIcon.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, self.isTypeSelectUIShow and 180 or 0)
end

function HomeBuildingView:OnPress(go, isPress)
  if not self.cameraControl:IsInited() then
    return
  end
  self.cameraControl:OnPress(go, isPress)
  if self.lastMouseInTheWorld == false then
    self.worldGridControl:ShowBuildSigns(true)
  end
  self.lastMouseInTheWorld = nil
  if isPress then
    self:OnPressDown()
  else
    self:OnPressUp()
  end
end

function HomeBuildingView:OnPressDown()
  if self.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.DragFurniture) then
    return
  end
  local layers = ReusableTable.CreateArray()
  layers[#layers + 1] = Game.ELayer.HomeOperate
  layers[#layers + 1] = Game.ELayer.HomeFurniture
  if self.curEditMode ~= E_EditMode.Recovery then
    layers[#layers + 1] = Game.ELayer.HomeFurniture_BP
  end
  self.objSel = self.cameraControl:TryGetClickObjByLayers(layers)
  ReusableTable.DestroyAndClearArray(layers)
  if not self:CanOperate() then
    return
  end
  self.isDragObj = self.curOperateItem and self.curOperateItem.assetFurniture:IsMyColliderObj(self.objSel)
  if self.isDragObj then
    HomeManager.Me():ResetGroundHeight(self.curOperateItem.centerCellHeight * HomeBuildingView.CellSize)
    self:ShowAdjustFurnitureBtns(false)
  end
end

function HomeBuildingView:OnPressUp()
  if self.isDragged then
    if self.curOperateItem then
      if self.isBuildUIShow and self.curOperateCell.trans.position.y <= self.fUIBoardEdge then
        self:RemoveCurOperateItem()
      else
        if self.isDragObj and not self.isItemMoving then
          self:UpdateCurOperateItemMoving(true)
        end
        HomeManager.Me():AddFurnitureItem(self.curOperateItem)
      end
    end
  elseif self.isLastOperateSuccess then
    self:CloseMenus()
    if self.curEditMode == E_EditMode.Recovery then
      if self.objSel then
        local selectItem = HomeManager.Me():FindFurniture(self.objSel.name, true)
        if self.recoveryItemsMap[selectItem.data.id] then
          self:SelectItem(selectItem, false)
          self.recoveryItemsMap[selectItem.data.id] = nil
        else
          self:SelectItem(selectItem, true)
          self.recoveryItemsMap[selectItem.data.id] = selectItem
        end
      end
    else
      if not self.curOperateItem or not self.curOperateItem.assetFurniture:IsMyColliderObj(self.objSel) then
        self:OnClickBtnConfirm()
      end
      if self.objSel and not self.curOperateItem then
        local selectFurniture = HomeManager.Me():FindFurniture(self.objSel.name, true)
        if selectFurniture and self.guideView:CanSelectFurniture(selectFurniture) then
          self.curOperateItem = selectFurniture
          self.curOperateItem.assetFurniture:SetParent(self.tsfItemRoot, true)
          self:SelectItem(self.curOperateItem, true)
          self.curOperateCell:SetData(self.curOperateItem.data)
          local floorIndex, cells = HomeManager.Me():GetPlacedFurnitureCells(self.curOperateItem.tag)
          local itemPos = self.worldGridControl:GetPosAndShowBuildSignsByCells(floorIndex, cells)
          self.worldGridControl:ShowCurItemExtentGrid(true, itemPos, cells)
          self:ShowOperateBoard(true, true, not self.curOperateItem:IsAutoRotate())
          self:ShowBuildUI(false)
          self.guideView:StartGuideStep(HomeBuildingGuideView.Step.DragFurniture)
        elseif not self.guideView:CheckOperateForbid() and self.curEditMode ~= E_EditMode.Recovery then
          self.bpControl:TrySelectBPFurniture(self.objSel.name)
        end
      end
    end
  end
  HomeManager.Me():ResetGroundHeight(0)
  self:ShowAdjustFurnitureBtns(self.curOperateItem ~= nil)
  self.objSel = nil
  self.isDragged = false
  self.isDragObj = false
  self.isDragCell = false
  self.guideView:OnPressUp()
end

function HomeBuildingView:OnDrag(go, delta)
  if not self.cameraControl:IsInited() then
    return
  end
  self.isDragged = true
  if self.isDragObj then
    self:DragObj(delta)
  else
    self.cameraControl:OnDrag(go, delta)
  end
end

function HomeBuildingView:DragObj(delta)
  if not self.curOperateItem then
    return
  end
  if self.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.DragFurniture) then
    return
  end
  if not self:CanOperate() then
    return
  end
  local inputPos = LuaGeometry.GetTempVector3(LuaGameObject.GetMousePosition())
  inputPos.x = math.clamp(inputPos.x, 0, self.screenWidth)
  inputPos.y = math.clamp(inputPos.y, 0, self.screenHeight)
  local tweenPos = true
  if self.isBuildUIShow then
    local vecPos = self.cameraUI:ScreenToWorldPoint(inputPos)
    vecPos.z = 0
    self.curOperateCell.trans.position = vecPos
    local mouseInTheWorld = not self.isBuildUIShow or vecPos.y > self.fUIBoardEdge
    if self.lastMouseInTheWorld ~= mouseInTheWorld then
      self.curOperateCell.gameObject:SetActive(not mouseInTheWorld)
      self.curOperateItem.assetFurniture:SetActive(mouseInTheWorld)
      self.worldGridControl:ShowBuildSigns(mouseInTheWorld)
      self:ShowOperateBoard(mouseInTheWorld)
      self:ShowBuildUI(not mouseInTheWorld)
      self.lastMouseInTheWorld = mouseInTheWorld
      PpLua:Refresh()
      tweenPos = false
    end
    if not mouseInTheWorld then
      return
    end
  end
  local hitPoint, floorIndex = self.cameraControl:GetGroundPosAtScreenPos(inputPos)
  if not hitPoint then
    return
  end
  if self.curOperateItem:IsAutoRotate() then
    local angle, keepFlag = HomeManager.Me():CalculateRotationCloseToNearestWall(self.curOperateItem.staticID, hitPoint.x, hitPoint.z)
    if keepFlag ~= true then
      self.curOperateItem:SetRotationAngle(angle)
    end
  end
  if tweenPos and floorIndex == self.curOperateItem.curFloor then
    self.isItemMoving = true
    hitPoint.y = HomeManager.Me():GetWorldPosYByXZ(floorIndex, hitPoint.x, hitPoint.z) + HomeBuildingView.SelectHeight
    self.curTweenPosTarget = hitPoint
    TweenPosition.Begin(self.curOperateItem.gameObject, 0.05, hitPoint, true):SetOnFinished(function()
      self:UpdateCurOperateItemMoving(not self.isDragged)
      self.isItemMoving = false
    end)
  else
    local tweener = self.curOperateItem.gameObject:GetComponent(TweenPosition)
    if tweener then
      tweener.enabled = false
    end
    local result, right, wrong, placeRow, placeCol = HomeManager.Me():PlaceFurniture(self.curOperateItem, floorIndex, hitPoint.x, hitPoint.z)
    self.isLastOperateSuccess = result == BuildingGrid.EPlaceFurnitureResult.ESuccess
    HomeFurniturOutLine.Me():AddTarget(self.curOperateItem.gameObject, self.curOperateItem:GetInstanceID(), not self.isLastOperateSuccess and m_color_outlineRed)
    local itemPos = self.worldGridControl:GetPosAndShowBuildSignsByCells(floorIndex, right, wrong)
    self.curOperateItem.assetFurniture:SetPosition(itemPos)
    self.worldGridControl:ShowCurItemExtentGrid(true, itemPos, right, wrong)
  end
end

function HomeBuildingView:OnPressContentCell(cell)
  if self.guideView:CheckOperateForbid() then
    return
  end
  self.lastMouseInTheWorld = nil
  self.isStartDragCell = true
  self.isDragContentList = false
  self.scrollHomeContentCells:Press(cell.isPress)
  if not cell.isPress then
    self:OnPressUp()
  end
end

function HomeBuildingView:OnDragContentCell(cell)
  if self.guideView:CheckOperateForbid() then
    return
  end
  if not self:CanOperate() then
    return
  end
  self:CloseMenus()
  if self.isStartDragCell then
    self.isStartDragCell = false
    if cell.isDragList or cell.delta.x ~= 0 and math.abs(cell.delta.y) / math.abs(cell.delta.x) < 0.7 then
      self.isDragContentList = true
    else
      self:CreateFurnitureItemByCell(cell)
    end
  end
  if self.isDragContentList then
    self.scrollHomeContentCells:Drag()
    return
  end
  if self.isDragCell then
    self.isDragged = true
    self:DragObj(cell.delta)
  end
end

function HomeBuildingView:CreateFurnitureItemByCell(cell)
  if not self.isLastOperateSuccess then
    redlog("CreateFurnitureItemByCell =======1======")
    return
  end
  if self.curOperateItem then
    redlog("CreateFurnitureItemByCell =======2======")
    self:OnClickBtnConfirm()
  end
  if self.curOperateItem then
    redlog("CreateFurnitureItemByCell =======3======")
    return
  end
  local furnitureID = cell.data:GetUsableFurnitureID()
  if not furnitureID and HomeManager.ClientTest then
    furnitureID = "ClientTest"
  end
  if not furnitureID then
    redlog("CreateFurnitureItemByCell =======4======")
    return
  end
  redlog("CreateFurnitureItemByCell =======5======")
  NFurniture.new(furnitureID, cell.staticID, self.tsfItemRoot, function(nFurniture)
    redlog("CreateFurnitureItemByCell =======6======")
    local newNFurniture = nFurniture
    newNFurniture:SetData(HomeProxy.Instance:GetFurnitureData(newNFurniture.id, cell.staticID))
    if not newNFurniture.inited then
      return
    end
    self:OnClickContentCell(cell, true)
    self.isDragCell = true
    self.isDragObj = true
    self.curOperateItem = newNFurniture
    local houseConfig = HomeManager.Me():GetCurHouseConfig()
    self.curOperateItem:SetRotationAngle(houseConfig and houseConfig.DefaultFurnitureRotate or BuildingGrid.EBuildingRotation.E0)
    self:SelectItem(self.curOperateItem, true)
    self.curOperateItem.assetFurniture:SetActive(false)
    local cellPos = self.cameraUI:ScreenToWorldPoint(Input.mousePosition)
    cellPos.z = 0
    self.curOperateCell.trans.position = cellPos
    self.curOperateCell:SetData(cell.data)
    HomeManager.Me():ResetGroundHeight(self.curOperateItem.centerCellHeight * HomeBuildingView.CellSize)
    self:ShowOperateBoard(false, false, not self.curOperateItem:IsAutoRotate())
    self:ShowAdjustFurnitureBtns(false)
  end)
end

function HomeBuildingView:OnClickContentCell(cell, doNotReload)
  if not doNotReload and self.guideView:CheckOperateForbid() then
    return
  end
  if cell.data.type == HomeContentData.Type.Renovation then
    if cell.data:IsUsable() and self.isForbidRenovation then
      MsgManager.ShowMsgByID(49)
      return
    elseif not self.isForbidRenovation then
      self.isForbidRenovation = not doNotReload and cell.data:IsUsable()
    end
  end
  if not doNotReload and self.curContentData and self.curContentData.staticID == cell.staticID then
    if cell.data.type == HomeContentData.Type.Renovation then
      self:SelectCurRenovationContentData(false)
    end
    self:ClearSelectContent()
    return
  end
  self:ClearSelectContent()
  self.curContentCell = cell
  self.curContentCell:Select(true)
  self:SelectContentData(cell.data, doNotReload)
end

function HomeBuildingView:SelectContentData(homeContentData, doNotReload)
  if self.curContentData and self.curContentData.staticID ~= homeContentData.staticID then
    self:ClearSelectContent()
  end
  self.curContentData = homeContentData
  self.curContentData:Select(true)
  self:ShowCurContentTip()
  self.bpControl:SelectFurnitureContent(homeContentData)
  if not doNotReload and self.curContentData.type == HomeContentData.Type.Renovation and self.curContentData:IsUsable() then
    self:SelectCurRenovationContentData()
  end
end

local renovationInfosArray = {}

function HomeBuildingView:SelectCurRenovationContentData(isSelect)
  if not self.curSeriesCell or not self.curContentData then
    LogUtility.Error("丢失必要数据，操作无法继续，尝试重新进入编辑家具模式。")
    self.OnClickBtnEditFurniture()
    return
  end
  local defaultMatID = HomeManager.Me():GetDefaultMatIDByType(self.curContentData:GetDataType())
  if HomeManager.Me():IsRenovationTypeDivideByPos(self.curContentData:GetDataType()) then
    local renovationInfos = HomeManager.Me():GetRenovationObjs(self.curSeriesCell.seriesType, self.curContentData:GetDataType())
    if not renovationInfos then
      LogUtility.Error("没有找到目标物体！楼层：%s，类型ID：%s", tostring(), tostring(self.curContentData:GetDataType()))
      return
    end
    TableUtility.ArrayClear(renovationInfosArray)
    for _, singleInfo in pairs(renovationInfos) do
      renovationInfosArray[#renovationInfosArray + 1] = singleInfo
    end
    self.listRenovationPoses:ResetDatas(renovationInfosArray)
    local renovationPosCells = self.listRenovationPoses:GetCells()
    for i = 1, #renovationPosCells do
      renovationPosCells[i]:SetTargetMatetialID(self.curContentData.staticID, defaultMatID)
    end
  else
    HomeManager.Me():Renovation(isSelect == false and defaultMatID or self.curContentData.staticID, self.curSeriesCell.seriesType)
  end
end

function HomeBuildingView:ShowBuildUI(isShow)
  if self.isBuildUIShow == isShow then
    return
  end
  self.widgetBuildUI.alpha = isShow and 1 or 0
  self.objActiveWithBuildUI:SetActive(isShow)
  self.tabItemTypeTip.label.alpha = 0
  if isShow then
    for id, renovationInfo in pairs(self.renovationOutlineMap) do
      if renovationInfo.gameObject then
        HomeFurniturOutLine.Me():AddTarget(renovationInfo.gameObject, id)
      end
    end
  else
    for id, renovationInfo in pairs(self.renovationOutlineMap) do
      HomeFurniturOutLine.Me():RemoveTarget(id)
    end
  end
  self.isBuildUIShow = isShow
end

function HomeBuildingView:CloseMenus()
  if self.isSettingBoardShow then
    self:ShowSettingBoard(false)
  end
  if self.isSearchShow then
    self:ShowSearchBoard(false)
  end
end

function HomeBuildingView:SelectItem(nFurniture, isSelect)
  local x, y, z = nFurniture.assetFurniture:GetPositionXYZ()
  y = HomeManager.Me():GetWorldPosYByXZ(nFurniture.curFloor or 1, x, z)
  if isSelect then
    y = y + HomeBuildingView.SelectHeight
    nFurniture.assetFurniture:SetColliderLayer(Game.ELayer.HomeOperate)
    if self.curContentData and nFurniture.data.staticID ~= self.curContentData.staticID or self.curEditMode == E_EditMode.Recovery then
      self.bpControl:SelectFurnitureContent()
    end
    HomeFurniturOutLine.Me():AddTarget(nFurniture.gameObject, nFurniture:GetInstanceID())
  else
    nFurniture.assetFurniture:SetColliderLayer(Game.ELayer.HomeFurniture)
    HomeFurniturOutLine.Me():RemoveTarget(nFurniture:GetInstanceID())
    if self.curEditMode ~= E_EditMode.Recovery then
      self.bpControl:SelectFurnitureContent(self.curContentData)
    end
  end
  nFurniture:SetSelect(isSelect)
  nFurniture.assetFurniture:SetPositionXYZ(x, y, z)
end

function HomeBuildingView:ClearCurSelectItem()
  self:SelectItem(self.curOperateItem, false)
  self.worldGridControl:RecycleBuildSigns()
  self.worldGridControl:ShowCurItemExtentGrid(false)
  self.curOperateItem = nil
  self.curOperateCell.gameObject:SetActive(false)
  self:ShowOperateBoard(false)
  self:ShowAdjustFurnitureBtns(false)
end

function HomeBuildingView:RemoveCurOperateItem()
  if not self.curOperateItem then
    return
  end
  self:ShowBuildUI(true)
  local deleteItem = self.curOperateItem
  self:ClearCurSelectItem()
  HomeManager.Me():RemoveFurnitureItem(deleteItem.data.id)
  self.isLastOperateSuccess = true
end

function HomeBuildingView:ClearSelectContent()
  if self.curContentData then
    self.curContentData:Select(false)
  end
  if self.curContentCell then
    self.curContentCell:Select(false, self.curContentData)
  end
  self.curContentData = nil
  self.curContentCell = nil
  self.bpControl:SelectFurnitureContent()
  self.tabItemTip.gameObject:SetActive(false)
  self.listRenovationPoses:ResetDatas(m_emptyTable)
end

function HomeBuildingView:ShowCurContentTip()
  if not self.curContentData or not self.isShowContentTip then
    return
  end
  self.tabItemTip.homeContentCell:SetData(self.curContentData)
  local staticData = self.curContentData.staticData
  self.tabItemTip.labItemName.text = staticData.NameZh
  self.tabItemTip.objUnlockContents:SetActive(self.curContentData.isUnlocked == true)
  self.tabItemTip.objLockContents:SetActive(self.curContentData.isUnlocked ~= true)
  if self.curContentData.isUnlocked then
    self.tabItemTip.labItemScore.text = string.format(ZhString.HomeBuilding_Score, staticData.HomeScore or 0)
    if self.curContentData.type == HomeContentData.Type.Furniture then
      self.tabItemTip.labItemSize.text = string.format(ZhString.HomeBuilding_GridSize, staticData.Col or 0, staticData.Row or 0)
      self.tabItemTip.tsfTipLabMoveRoot.localPosition = self.tabItemTip.vecLabsPos_Furniture
    else
      self.tabItemTip.labItemSize.text = ""
      self.tabItemTip.tsfTipLabMoveRoot.localPosition = self.tabItemTip.vecLabsPos_Renovation
    end
    local typeID = self.curContentData.itemStaticData and self.curContentData.itemStaticData.Type
    self.tabItemTip.labItemType.text = string.format(ZhString.HomeBuilding_ItemType, HomeProxy.Instance:GetSimpleItemTypeName(typeID))
    local limitStr = HomeProxy.Instance:GetAreaLimitStr(staticData.AreaForceLimit or staticData.AreaLimit)
    self.tabItemTip.labAreaLimit.text = string.format(ZhString.HomeBuilding_PlaceLimit, limitStr)
    self.tabItemTip.objBtnMake:SetActive(Table_ItemBeTransformedWay[staticData.id] ~= nil)
  else
    self.tabItemTip.labCondition.text = staticData.UnlockDesc
  end
  self.tabItemTip.gameObject:SetActive(true)
end

function HomeBuildingView:ShowAdjustFurnitureBtns(isShow)
  if self.isShowAdjustFurnitureBtns ~= isShow then
    self.objAdjustFurnitureBtns:SetActive(isShow)
    self.isShowAdjustFurnitureBtns = isShow
  end
end

function HomeBuildingView:AdjustFurniturePlaceCell(deltaRow, deltaCol)
  if self.guideView:CheckOperateForbid(HomeBuildingGuideView.Step.DragFurniture) then
    return
  end
  if not self.curOperateItem or self.isDragObj or self.cameraControl.isCameraMoving or self.cameraControl.isCameraRotating then
    return
  end
  local lastItemPos = LuaGeometry.GetTempVector3(self.curOperateItem.assetFurniture:GetPositionXYZ())
  if deltaCol < 0 and lastItemPos.x < self.cameraControl.cameraMinPos[1] or 0 < deltaCol and lastItemPos.x > self.cameraControl.cameraMaxPos[1] or 0 < deltaRow and lastItemPos.z < self.cameraControl.cameraMinPos[2] or deltaRow < 0 and lastItemPos.z > self.cameraControl.cameraMaxPos[2] then
    return
  end
  local tweener = self.curOperateItem.gameObject:GetComponent(TweenPosition)
  if tweener then
    tweener.enabled = false
  end
  local result, right, wrong, placeRow, placeCol, floorIndex, newAngle = HomeManager.Me():MoveFurniture(self.curOperateItem, self.curOperateItem.curFloor, self.curOperateItem.curRow, self.curOperateItem.curCol, self.curOperateItem:GetRotationAngle(), deltaRow, deltaCol, self.curOperateItem:IsAutoRotate())
  self.isLastOperateSuccess = result == BuildingGrid.EPlaceFurnitureResult.ESuccess
  HomeFurniturOutLine.Me():AddTarget(self.curOperateItem.gameObject, self.curOperateItem:GetInstanceID(), not self.isLastOperateSuccess and m_color_outlineRed)
  self.curOperateItem:SetCurCell(floorIndex, placeRow, placeCol)
  if self.curOperateItem:IsAutoRotate() and newAngle then
    self.curOperateItem:SetRotationAngle(newAngle)
  end
  local itemPos = self.worldGridControl:GetPosAndShowBuildSignsByCells(floorIndex, right, wrong)
  self.curOperateItem.assetFurniture:SetPosition(itemPos)
  self.worldGridControl:ShowCurItemExtentGrid(true, itemPos, right, wrong)
end

function HomeBuildingView:SortContentDatas(datas)
  if not datas then
    return
  end
  table.sort(datas, function(l, r)
    if l.sortValue == r.sortValue then
      if l.itemType == r.itemType then
        return l.staticID < r.staticID
      end
      return l.itemType < r.itemType
    end
    return l.sortValue > r.sortValue
  end)
  return datas
end

function HomeBuildingView:CanOperate()
  return self.cameraControl:CanOperate()
end

function HomeBuildingView:UpdateContentsStatus()
  local datas = self.listHomeContentCells:GetDatas()
  local single
  for i = 1, #datas do
    single = datas[i]
    for j = 1, #single do
      single[j]:RefreshStatus()
    end
  end
  local cells = self.listHomeContentCells:GetCells()
  for i = 1, #cells do
    if cells[i].isActive then
      cells[i]:RefreshContentStatus()
    end
  end
end

function HomeBuildingView:SetHomeScore()
  self.tabScoreBoard.labAddScore.alpha = 0
  self.tabScoreBoard.tweenerAddScore.enabled = false
  self.curHomeScore = HomeProxy.Instance:CalMyHouseScore_Client()
  local tableHomeBuff = Table_HomeBuff
  local curLv = #tableHomeBuff
  local foundLv = false
  for i = 1, #tableHomeBuff do
    if self.curHomeScore < (tableHomeBuff[i].Score or 0) then
      foundLv = true
      curLv = i - 1
      break
    end
  end
  self.tabScoreBoard.labHomeLv.text = string.format(ZhString.Home_Lv, curLv)
  if not foundLv then
    self.tabScoreBoard.labHomeScore.text = "max"
    self.tabScoreBoard.sliderHomeScore.value = 1
  else
    local curLvData = tableHomeBuff[curLv]
    local curLvScore = curLvData and curLvData.Score or 0
    local nextLvData = tableHomeBuff[curLv + 1]
    local nextLvScore = nextLvData and nextLvData.Score or 0
    local curExp, needExp = self.curHomeScore - curLvScore, nextLvScore - curLvScore
    if curExp < 0 then
      curExp = 0
    end
    if needExp < 1 then
      needExp = 1
    end
    self.tabScoreBoard.labHomeScore.text = string.format("%s/%s", self.curHomeScore, nextLvScore)
    self.tabScoreBoard.sliderHomeScore.value = 0 < needExp and curExp / needExp or 0
  end
end

function HomeBuildingView:RefreshHomeScore()
  local lastHomeScore = self.curHomeScore
  self:SetHomeScore()
  if lastHomeScore and lastHomeScore ~= self.curHomeScore then
    if lastHomeScore < self.curHomeScore then
      self.tabScoreBoard.labAddScore.text = "+" .. self.curHomeScore - lastHomeScore
      self.tabScoreBoard.labAddScore.color = m_color_greenScore
    else
      self.tabScoreBoard.labAddScore.text = "-" .. lastHomeScore - self.curHomeScore
      self.tabScoreBoard.labAddScore.color = m_color_redScore
    end
    self.tabScoreBoard.tweenerAddScore:ResetToBeginning()
    self.tabScoreBoard.tweenerAddScore:PlayForward()
  end
end

function HomeBuildingView:HandleQuickUseItem(note)
  local data = QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1]
  if not (data and data.data) or data.type ~= QuickUseProxy.Type.Item then
    return
  end
  if type(data.data) ~= "table" or not Table_HomeFurnitureMaterial[data.data.staticData.id] then
    return
  end
  self.quickUsePopUp:SetData(data)
end

function HomeBuildingView:HandleQuickUsePopupClose()
  local datas = QuickUseProxy.Instance:GetFirstNotEmptyQueue()
  if datas then
    local data
    for i = 1, #datas do
      data = datas[i]
      if data and data.data and data.type == QuickUseProxy.Type.Item and type(data.data) == "table" and Table_HomeFurnitureMaterial[data.data.staticData.id] then
        self.quickUsePopUp:SetData(data)
        return
      end
    end
  end
  self.quickUsePopUp:SetData(nil)
end

function HomeBuildingView:ShowOperateBoard(isShow, showRecoveryBtn, showRotateBtn)
  if showRecoveryBtn ~= nil and showRecoveryBtn ~= self.tabOperateBoard.isBtnRecoveryActive then
    self.tabOperateBoard.objBtnRecovery:SetActive(showRecoveryBtn)
    self.tabOperateBoard.isBtnRecoveryActive = showRecoveryBtn
  end
  if showRotateBtn ~= nil and showRotateBtn ~= self.tabOperateBoard.isBtnRotateActive then
    self.tabOperateBoard.objBtnRotate:SetActive(showRotateBtn)
    self.tabOperateBoard.isBtnRotateActive = showRotateBtn
  end
  self.tabOperateBoard.gameObject:SetActive(isShow)
  if isShow then
    self.tabOperateBoard.gridButtons:Reposition()
    local activeNum = 2
    if self.tabOperateBoard.isBtnRecoveryActive then
      activeNum = activeNum + 1
    end
    if self.tabOperateBoard.isBtnRotateActive then
      activeNum = activeNum + 1
    end
    self.tabOperateBoard.sprBoardBG.width = self.tabOperateBoard.cellWidth * activeNum + 32
  end
end

function HomeBuildingView:OnClickBtnConfirm()
  if self.curEditMode == E_EditMode.Recovery then
    local tmpArray = ReusableTable.CreateArray()
    for id, furnitureItem in pairs(self.recoveryItemsMap) do
      HomeFurniturOutLine.Me():RemoveTarget(furnitureItem:GetInstanceID())
      tmpArray[#tmpArray + 1] = id
    end
    HomeManager.Me():RemoveFurnitureItems(tmpArray)
    ReusableTable.DestroyAndClearArray(tmpArray)
    TableUtility.TableClear(self.recoveryItemsMap)
    self:SetEditRecovery(false)
    return
  end
  if not self.curOperateItem or not self.isLastOperateSuccess then
    return
  end
  if self.curOperateItem:IsHideWithWall() then
    local x, y, z = self.curOperateItem.assetFurniture:GetPositionXYZ()
    self.curOperateItem.assetFurniture:SetParent(HomeManager.Me():GetNearestWall(self.curOperateItem.curFloor, x, z).transform, true)
  end
  HomeManager.Me():ConfirmPlaceFurniture(self.curOperateItem)
  self.guideView:OnFurniturePlaced(self.curOperateItem)
  self.bpControl:RefreshStatus()
  self:ClearCurSelectItem()
  self:ShowBuildUI(true)
end

function HomeBuildingView:OnClickBtnCancel()
  if self.curEditMode == E_EditMode.Recovery then
    self:SetEditRecovery(false)
    return
  end
  if not self.curOperateItem then
    return
  end
  if not self.curOperateItem:IsPlaced() then
    self:RemoveCurOperateItem()
    return
  end
  self.curOperateItem:SetRotationAngle(self.curOperateItem.placeAngle)
  local result, right, wrong, placeRow, placeCol = HomeManager.Me():PlaceFurniture_T(self.curOperateItem, self.curOperateItem.placeFloor, self.curOperateItem.placeRow, self.curOperateItem.placeCol, self.curOperateItem.placeAngle)
  self.isLastOperateSuccess = result == BuildingGrid.EPlaceFurnitureResult.ESuccess
  local itemPos = self.worldGridControl:GetPosAndShowBuildSignsByCells(self.curOperateItem.placeFloor, right, wrong, not self.isLastOperateSuccess)
  self.curOperateItem.assetFurniture:SetPosition(itemPos)
  self.worldGridControl:ShowCurItemExtentGrid(true, itemPos, right, wrong)
  if self.isLastOperateSuccess then
    self:ClearCurSelectItem()
    self:ShowBuildUI(true)
  else
    HomeFurniturOutLine.Me():AddTarget(self.curOperateItem.gameObject, self.curOperateItem:GetInstanceID(), m_color_outlineRed)
  end
end

function HomeBuildingView:OnClickBtnRotate()
  if not self.curOperateItem or self.curOperateItem:IsAutoRotate() then
    return
  end
  self.curOperateItem:Rotate()
  local floorIndex = self.curOperateItem.curFloor
  local result, right, wrong, placeRow, placeCol = HomeManager.Me():RotateFurniture(self.curOperateItem, floorIndex, self.curOperateItem.curRow, self.curOperateItem.curCol)
  self.isLastOperateSuccess = result == BuildingGrid.EPlaceFurnitureResult.ESuccess
  local itemPos = self.worldGridControl:GetPosAndShowBuildSignsByCells(floorIndex, right, wrong)
  self.curOperateItem.assetFurniture:SetPosition(itemPos)
  self.worldGridControl:ShowCurItemExtentGrid(true, itemPos, right, wrong)
  HomeFurniturOutLine.Me():AddTarget(self.curOperateItem.gameObject, self.curOperateItem:GetInstanceID(), not self.isLastOperateSuccess and m_color_outlineRed)
end

function HomeBuildingView:MonoUpdate(time, deltaTime)
  if self.isDragObj and self.lastMouseInTheWorld ~= false then
    local inputPos = LuaGeometry.GetTempVector3(LuaGameObject.GetMousePosition())
    inputPos.x = math.clamp(inputPos.x, 0, self.screenWidth)
    inputPos.y = math.clamp(inputPos.y, 0, self.screenHeight)
    local moveX = self:CalculateCameraAutoMoveSpeed(inputPos.x, self.screenWidth)
    local moveY = self:CalculateCameraAutoMoveSpeed(inputPos.y, self.screenHeight)
    if moveX ~= 0 or moveY ~= 0 then
      local delta = LuaGeometry.GetTempVector2(moveX, moveY)
      self.cameraControl:CameraMove(delta)
      self:DragObj(delta)
    end
  end
  if self.isItemMoving then
    self:UpdateCurOperateItemMoving()
  end
  if self.isForbidRenovation then
    self.forbidRenovationCounter = self.forbidRenovationCounter + deltaTime
    if self.forbidRenovationCounter > m_renovationInterval then
      self.forbidRenovationCounter = 0
      self.isForbidRenovation = false
    end
  end
  self.cameraControl:MonoUpdate(time, deltaTime)
end

function HomeBuildingView:CalculateCameraAutoMoveSpeed(value, maxValue)
  if value < self.dragScreenMoveEdge then
    return (1 - value / self.dragScreenMoveEdge) * self.dragScreenMoveSpeed
  elseif value > maxValue - self.dragScreenMoveEdge then
    return ((maxValue - value) / self.dragScreenMoveEdge - 1) * self.dragScreenMoveSpeed
  end
  return 0
end

function HomeBuildingView:UpdateCurOperateItemMoving(isResetPos)
  if not self.curOperateItem then
    return
  end
  local itemPos = isResetPos and self.curTweenPosTarget or LuaGeometry.GetTempVector3(self.curOperateItem.assetFurniture:GetPositionXYZ())
  local row, col = HomeManager.Me():ConvertWorldPositionToRowAndCol(self.curOperateItem.curFloor, itemPos.x, itemPos.z)
  if not row or not col then
    return
  end
  if self.curOperateItem.curRow ~= row or self.curOperateItem.curCol ~= col or isResetPos then
    local result, right, wrong, placeRow, placeCol = HomeManager.Me():PlaceFurniture(self.curOperateItem, self.curOperateItem.curFloor, itemPos.x, itemPos.z)
    self.isLastOperateSuccess = result == BuildingGrid.EPlaceFurnitureResult.ESuccess
    HomeFurniturOutLine.Me():AddTarget(self.curOperateItem.gameObject, self.curOperateItem:GetInstanceID(), not self.isLastOperateSuccess and m_color_outlineRed)
    itemPos = self.worldGridControl:GetPosAndShowBuildSignsByCells(self.curOperateItem.curFloor, right, wrong)
    self.worldGridControl:ShowCurItemExtentGrid(true, itemPos, right, wrong)
    if isResetPos then
      self.curOperateItem.assetFurniture:SetPosition(itemPos)
    end
  end
end

function HomeBuildingView:OnEnter()
  HomeBuildingView.super.OnEnter(self)
  self.objSettingBoard:SetActive(false)
  self.objInputSearch:SetActive(false)
  self.curOperateCell.gameObject:SetActive(false)
  self.tabItemTypeTip.label.alpha = 0
  self:ShowOperateBoard(false)
  self:ShowAdjustFurnitureBtns(false)
  self.tabItemTip.gameObject:SetActive(false)
  self:InitView()
end

function HomeBuildingView:OnExit()
  if HomeManager.Me():IsAtHome() then
    self:SetEditRecovery(false)
    self:OnClickBtnConfirm()
    self:RemoveCurOperateItem()
  else
    self.worldGridControl:RecycleBuildSigns()
  end
  if self.curContentData then
    self.curContentData:Select(false)
  end
  if self.ltTypeTipShow then
    self.ltTypeTipShow:Destroy()
    self.ltTypeTipShow = nil
  end
  HomeFurniturOutLine.Me():Release()
  HomeManager.Me():ExitEditMode()
  HomeBuildingView.super.OnExit(self)
end

function HomeBuildingView:OnDestroy()
  self.listSettings:Destroy()
  self.listSeriesTypes:Destroy()
  self.listDataTypes:Destroy()
  self.listRenovationPoses:Destroy()
  self.listHomeContentCells:Destroy()
  HomeBuildingView.super.OnDestroy(self)
end
