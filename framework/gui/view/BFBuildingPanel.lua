autoImport("BFBuildingWeatherCell")
autoImport("BFBuildingFunctionCell")
autoImport("BFBuildingDonateItemCell")
autoImport("BFBuildingDonateConfirmCell")
autoImport("BFBuildingReviveCell")
autoImport("BFBuildingBuyItemCell")
BFBuildingPanel = class("BFBuildingPanel", ContainerView)
BFBuildingPanel.ViewType = UIViewType.NormalLayer
BFBuildingPanel.TabName = {
  Donate = ZhString.BFBuilding_DonateTabName,
  Function = ZhString.BFBuilding_FunctionTabName
}
local queryInterval, bg2Pos = 3000, {-575, -560}
local buildingIns, buildingType, shopIns
local fdata = {
  pos = {},
  items = {},
  elements = {},
  weather = {},
  block = {},
  timer = {
    datas = {
      pos = {}
    }
  }
}

function BFBuildingPanel:Init()
  if not buildingIns then
    buildingIns = BFBuildingProxy.Instance
    buildingType = BFBuildingProxy.Type
    shopIns = HappyShopProxy.Instance
  end
  self:InitView()
  self:AddEvents()
end

function BFBuildingPanel:InitView()
  self.rightBg = self:FindComponent("rightBg", UISprite)
  self.bg2 = self:FindGO("Bg2")
  self.panelTitle = self:FindComponent("UserTitle", UILabel)
  self.waittext = self:FindComponent("waittext", UILabel)
  self.waittext.text = ZhString.BFBuilding_bottom_text2
  self.bottom = self:FindGO("bottom")
  self.donateProgress = self:FindComponent("progressBar", UISlider, self.bottom)
  self.donateProgressText = self:FindComponent("pvalue", UILabel, self.bottom)
  self.donateProgressEffect = self:FindGO("donateProgressEffect")
  self:FindComponent("text1", UILabel, self.bottom).text = ZhString.BFBuilding_bottom_text1
  self.top = self:FindGO("top")
  self.timeout = self:FindComponent("tvalue", UILabel, self.top)
  self.confirmContainer = self:FindGO("ConfirmContainer")
  self.donateGrid = self:FindGO("DonateGrid")
  local donateWrapCfg = {
    wrapObj = self.donateGrid,
    pfbNum = 6,
    cellName = "BFBuildingCommonCell",
    control = BFBuildingDonateItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.donateWrapHelper = WrapCellHelper.new(donateWrapCfg)
  self.donateWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickDonateCell, self)
  self.functionGrid = self:FindGO("FunctionGrid")
  local functionWrapCfg = {
    wrapObj = self.functionGrid,
    pfbNum = 6,
    cellName = "BFBuildingCommonCell",
    control = BFBuildingFunctionCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.functionWrapHelper = WrapCellHelper.new(functionWrapCfg)
  self.functionWrapHelper:AddEventListener(BFBuildingEvent.UseFunction, self.HandleUseFunction, self)
  self.functionWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickFunctionIconSprite, self)
  self.functionWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickFunctionCell, self)
  
  function self.functionWrapHelper.scrollView.onDragStarted()
    self.selectGO = nil
    self.buyCell.gameObject:SetActive(false)
    TipManager.CloseTip()
  end
  
  self:InitBuyItemCell()
  self:InitCostCtrls()
  self.tipData = {
    funcConfig = _EmptyTable
  }
  self.weatherGrid = self:FindComponent("WeatherGrid", UIGrid)
  self.weatherListCtl = UIGridListCtrl.new(self.weatherGrid, BFBuildingWeatherCell, "BFBuildingWeatherCell")
  self.weatherListCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickWeatherCell, self)
  self.weatherListCtl:AddEventListener(BFBuildingEvent.UseWeather, self.HandleUseWeather, self)
  self.reviveGrid = self:FindComponent("ReviveGrid", UIGrid)
  self.reviveListCtl = UIGridListCtrl.new(self.reviveGrid, BFBuildingReviveCell, "BFBuildingReviveCell")
  self.reviveListCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReviveCell, self)
  self.reviveListCtl:AddEventListener(BFBuildingEvent.UseRevive, self.HandleUseRevive, self)
  self.reviveListCtl:AddEventListener(BFBuildingEvent.ReviveQuery, self.HandleReviveQuery, self)
  self.reviveTimes = self:FindComponent("ReviveTimes", UILabel)
  self.tabParent = self:FindGO("toggles")
  self.donateTab = self:FindGO("Donate")
  self.functionTab = self:FindGO("Function")
  self.donateTabBC = self.donateTab:GetComponent(BoxCollider)
  self.functionTabBC = self.functionTab:GetComponent(BoxCollider)
  local tabList = {
    self.donateTab,
    self.functionTab
  }
  self.tabIconSpList = {}
  local icon, label
  for _, v in ipairs(tabList) do
    longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.BFBuildingPanel, {
        state,
        obj.gameObject
      })
    end
    
    icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
    label = Game.GameObjectUtil:DeepFindChild(v, "NameLabel")
    TabNameTip.SwitchShowTabIconOrLabel(icon, label)
  end
  self:AddEventListener(TipLongPressEvent.BFBuildingPanel, self.HandleLongPress, self)
  self:AddTabChangeEvent(self.donateTab, nil, 1)
  self:AddTabChangeEvent(self.functionTab, nil, 2)
  local toyShopType = GameConfig.BuildingCooperate.FunctionShopID
  if toyShopType then
    shopIns:InitShop(nil, 1, toyShopType)
  end
end

function BFBuildingPanel:InitBuyItemCell()
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("HappyShopBuyItemCell"))
  go.transform:SetParent(self.gameObject.transform, false)
  go.transform.localPosition = LuaGeometry.GetTempVector3(-200)
  self.buyCell = BFBuildingBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
  self.buyCell.gameObject:SetActive(false)
end

function BFBuildingPanel:InitCostCtrls()
  self.costSps, self.costLabels = {}, {}
  local go
  for i = 1, 2 do
    go = self:FindGO("CostCtrl" .. i)
    self.costSps[i] = go:GetComponent(UISprite)
    self.costLabels[i] = self:FindComponent("Label", UILabel, go)
  end
end

function BFBuildingPanel:TabChangeHandler(key, noop)
  if BFBuildingPanel.super.TabChangeHandler(self, key) then
    if not noop and self.tabIndex ~= key then
      if key == 1 then
        self:ShowDonatePage()
      elseif key == 2 then
        self:ShowFunctionPage()
      end
      self:QueryInfo()
    end
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end

function BFBuildingPanel:AddEvents()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.OnBuyShopItem)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.OnQueryShopConfig)
  self:AddListenEvt(ServiceEvent.SessionShopShopDataUpdateCmd, self.OnShopDataUpdate)
  self:AddListenEvt(ServiceEvent.SessionShopServerLimitSellCountCmd, self.OnServerLimitSellCount)
  self:AddListenEvt(ServiceEvent.SessionShopUpdateShopConfigCmd, self.OnUpdateShopConfig)
  self:AddListenEvt(ServiceEvent.NUserBuildDataQueryUserCmd, self.OnRecvQuery)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ServiceEvent.NUserBuildOperateUserCmd, self.OnRecvOperate)
  self:AddListenEvt(MyselfEvent.SyncBuffs, self.UpdateView)
end

function BFBuildingPanel:ShowDonatePage()
  self.tabIndex = 1
  self.functionGrid:SetActive(false)
  self.weatherGrid.gameObject:SetActive(false)
  self.reviveGrid.gameObject:SetActive(false)
  self.donateGrid:SetActive(true)
  local tempV3 = LuaGeometry.TempGetLocalPosition(self.bg2.transform)
  tempV3.y = bg2Pos[1]
  self.bg2.transform.localPosition = tempV3
  self.reviveTimes.text = ""
  if not self.donatePageInited then
    self.donateWrapHelper:UpdateInfo(buildingIns:GetDonateData(self.id), true, true)
  else
    local cells = self.donateWrapHelper:GetCellCtls()
    for i = 1, #cells do
      cells[i]:SelfUpdateCell()
    end
    if self.donateSelect then
      self:HandleClickDonateCell(self.donateSelect)
    end
  end
  self.donatePageInited = true
end

function BFBuildingPanel:ShowFunctionPage()
  local data = buildingIns:GetBuildData(self.id)
  if not data then
    if self.functionPageInited then
      LogUtility.WarningFormat("Cannot get build data with id = {0}", self.id)
    end
    return
  end
  self.tabIndex = 2
  self.donateGrid:SetActive(false)
  self.functionGrid:SetActive(false)
  self.weatherGrid.gameObject:SetActive(false)
  self.reviveGrid.gameObject:SetActive(false)
  self:UpdateCostCtrls()
  local tempV3 = LuaGeometry.TempGetLocalPosition(self.bg2.transform)
  tempV3.y = bg2Pos[1]
  self.bg2.transform.localPosition = tempV3
  self.reviveTimes.text = ""
  local elementsDirty = data.elementsDirty
  if self.btype == buildingType.Summon then
  elseif self.btype == buildingType.Toy then
    self.functionGrid:SetActive(true)
    local cells = self.functionWrapHelper:GetCellCtls()
    for i = 1, #cells do
      cells[i].btype = buildingType.Toy
    end
    self:UpdateShopInfo()
  elseif self.btype == buildingType.Weather then
    self.weatherGrid.gameObject:SetActive(true)
    if not self.functionPageInited or elementsDirty then
      self.weatherListCtl:ResetDatas(data.elements)
      self.weatherListCtl:ResetPosition()
    else
      local cells = self.weatherListCtl:GetCells()
      for i = 1, #cells do
        cells[i]:SelfUpdateCell()
      end
    end
  elseif self.btype == buildingType.Transform then
    self.functionGrid:SetActive(true)
    local cells = self.functionWrapHelper:GetCellCtls()
    for i = 1, #cells do
      cells[i].btype = buildingType.Transform
    end
    if not self.functionPageInited or elementsDirty then
      self.functionWrapHelper:UpdateInfo(data.elements, true, true)
    else
      for i = 1, #cells do
        cells[i]:SelfUpdateCell()
      end
    end
  elseif self.btype == buildingType.Revive then
    self.reviveGrid.gameObject:SetActive(true)
    tempV3.y = bg2Pos[2]
    self.bg2.transform.localPosition = tempV3
    self.reviveTimes.text = string.format(ZhString.BFBuilding_revive_time, data.r_times, GameConfig.BuildingCooperate.TimerMaxCount)
    if not self.functionPageInited or elementsDirty then
      self.reviveListCtl:ResetDatas(data.r_elements)
      self.reviveListCtl:ResetPosition()
    else
      local cells = self.reviveListCtl:GetCells()
      for i = 1, #cells do
        cells[i]:SelfUpdateCell()
      end
    end
  end
  buildingIns:SetBuildDataElementsDirty(self.id, false)
  self.functionPageInited = true
end

function BFBuildingPanel:OnBuyShopItem(note)
  self:UpdateShopInfo()
end

function BFBuildingPanel:OnQueryShopConfig(note)
  self:UpdateShopInfo(true)
end

function BFBuildingPanel:OnShopDataUpdate(note)
  self:UpdateShopInfo()
end

function BFBuildingPanel:OnServerLimitSellCount(note)
  self:UpdateShopInfo()
end

function BFBuildingPanel:OnUpdateShopConfig(note)
  self:UpdateShopInfo(true)
end

function BFBuildingPanel:OnRecvQuery(data)
  data = data.body
  if data and data.data and data.data.id and data.data.id == self.id then
    self:UpdateView()
  end
end

function BFBuildingPanel:OnItemUpdate(data)
  self:UpdateView()
end

function BFBuildingPanel:OnRecvOperate(data)
  data = data.body
  if data and data.data and data.data.id and data.data.id == self.id then
    self:UpdateView()
  end
end

function BFBuildingPanel:InitialView()
  self.panelTitle.text = Table_BuildingCooperate and Table_BuildingCooperate[self.npcid] and Table_BuildingCooperate[self.npcid].Desc
  self.donateTabBC.enabled = false
  self.functionTabBC.enabled = false
  self.donateGrid:SetActive(false)
  self.weatherGrid.gameObject:SetActive(false)
  self.functionGrid:SetActive(false)
  self.top:SetActive(false)
  self.bottom:SetActive(false)
  self.waittext.gameObject:SetActive(true)
  if self.btype == buildingType.Summon then
    self.functionTab:SetActive(false)
  else
    self.functionTab:SetActive(true)
  end
  self:TabChangeHandler(1, true)
  if self.btype == buildingType.Summon or self.btype == buildingType.Revive then
    self.tabParent:SetActive(true)
    self.bottom:SetActive(true)
  else
    self.tabParent:SetActive(false)
    self.bottom:SetActive(false)
  end
  self:QueryInfo()
  self.dataInited = nil
end

function BFBuildingPanel:QueryInfo()
  ServiceNUserProxy.Instance:CallBuildDataQueryUserCmd(fdata)
end

function BFBuildingPanel:UpdateView()
  local data = buildingIns:GetBuildData(self.id)
  if not data then
    self:InitialView()
    return
  end
  local status = data.status
  if self.status and self.status ~= status then
    if status == EBUILDSTATUS.EBUILDSTATUS_RUN then
      MsgManager.FloatMsg("", ZhString.BFBuilding_to_run)
    elseif status == EBUILDSTATUS.EBUILDSTATUS_INIT then
      MsgManager.FloatMsg("", ZhString.BFBuilding_to_init)
    end
  end
  self.status = status
  self.donateTabBC.enabled = true
  self.functionTabBC.enabled = true
  self.btype = data.sdata.BuildingType
  self.donateProgress.value = data.progress
  self.donateProgressText.text = string.format("%d%%", data.progress * 100)
  self.donateProgressEffect:SetActive(data.progress >= 1)
  if self.btype ~= buildingType.Toy then
    if self.status == EBUILDSTATUS.EBUILDSTATUS_RUN or self.status == EBUILDSTATUS.EBUILDSTATUS_OPER and data.time then
      if data.time and data.time > ServerTime.CurServerTime() / 1000 then
        self:StartCountdown(data.time)
        self.top:SetActive(true)
      else
        self.top:SetActive(false)
      end
      self.bottom:SetActive(false)
    else
      self:ClearTick()
      self.top:SetActive(false)
      self.bottom:SetActive(true)
    end
  end
  self.waittext.gameObject:SetActive(false)
  if self.btype == buildingType.Summon and self.status == EBUILDSTATUS.EBUILDSTATUS_RUN then
    self:CloseSelf()
  end
  if not self.dataInited then
    self.dataInited = true
    local initShowPage = (self.status == EBUILDSTATUS.EBUILDSTATUS_RUN or self.status == EBUILDSTATUS.EBUILDSTATUS_OPER) and 2 or 1
    self:TabChangeHandler(initShowPage)
  elseif self.tabIndex == 1 then
    self:ShowDonatePage()
  elseif self.tabIndex == 2 then
    self:ShowFunctionPage()
  end
end

function BFBuildingPanel:OnEnter()
  BFBuildingPanel.super.OnEnter(self)
  local npcinfo = self.viewdata and self.viewdata.npcinfo
  self.id = npcinfo.data and npcinfo.data.id
  self.npcid = npcinfo.data and npcinfo.data.staticData and npcinfo.data.staticData.id
  self.btype = BFBuildingProxy.GetBuildingType(self.npcid)
  self:InitialView()
  if not (self.id and self.npcid) or not self.btype then
    return
  end
  buildingIns:SetCurBuildingUICtrl(self)
  if npcinfo.assetRole and npcinfo.assetRole.completeTransform then
    local vp = Table_BuildingCooperate[self.npcid] and Table_BuildingCooperate[self.npcid].ViewPort
    local rot = Table_BuildingCooperate[self.npcid] and Table_BuildingCooperate[self.npcid].Rotation
    self:CameraFaceTo(npcinfo.assetRole.completeTransform, vp and LuaVector3.New(vp[1], vp[2], vp[3]) or CameraConfig.HappyShop_ViewPort, rot and LuaVector3.New(rot[1], rot[2], rot[3]) or CameraConfig.HappyShop_ViewPort)
  end
  self.isEverAutoBattle = Game.AutoBattleManager.on
  FunctionSystem.InterruptMyselfAI()
  if cycle then
    TimeTickManager.Me():CreateTick(0, queryInterval, self.QueryInfo, self, 2)
  else
    self:QueryInfo()
  end
end

function BFBuildingPanel:OnExit()
  self:ClearTick(true)
  self:CameraReset()
  buildingIns:SetCurBuildingUICtrl()
  BFBuildingPanel.super.OnExit(self)
  self.weatherListCtl:Destroy()
  if self.isEverAutoBattle then
    Game.AutoBattleManager:AutoBattleOn()
  end
end

function BFBuildingPanel:UpdateShopInfo(isReset)
  if self.btype ~= buildingType.Toy then
    return
  end
  local datas = shopIns:GetShopItems()
  if datas then
    self.functionWrapHelper:UpdateInfo(datas, nil, true)
  end
  if isReset == true then
    self:UpdateCostCtrls()
    self.functionWrapHelper:ResetPosition()
    self.buyCell.gameObject:SetActive(false)
    shopIns:SetSelectId(nil)
  end
  self.currentFunctionItem = nil
  self.selectGo = nil
end

function BFBuildingPanel:UpdateBuyItemInfo(data)
  if not data then
    return
  end
  local itemType = data.itemtype
  if itemType and itemType ~= 2 then
    self.buyCell:SetData(data)
    self.buyCell:UpdateConfirmBtn(shopIns:GetCanBuyCount(data) ~= 0)
    self.buyCell.gameObject:SetActive(true)
    TipManager.CloseTip()
  else
    self.buyCell.gameObject:SetActive(false)
  end
end

function BFBuildingPanel:UpdateCostCtrls()
  local moneyTypes = self.btype == buildingType.Toy and self:GetMoneyType() or _EmptyTable
  for i = 1, #self.costSps do
    self:_UpdateCostCtrl(i, moneyTypes[i])
  end
end

function BFBuildingPanel:_UpdateCostCtrl(index, moneyId)
  if index and self.costSps[index] then
    if moneyId and Table_Item[moneyId] then
      IconManager:SetItemIcon(Table_Item[moneyId].Icon, self.costSps[index])
      self.costSps[index].gameObject:SetActive(true)
      self.costLabels[index].text = StringUtil.NumThousandFormat(shopIns:GetItemNum(moneyId))
    else
      self.costSps[index].gameObject:SetActive(false)
    end
  end
end

function BFBuildingPanel:GetMoneyType()
  local shopItems, item, id, id2 = shopIns:GetShopItems()
  for _, shopItem in pairs(shopItems) do
    item = shopIns:GetShopItemDataByTypeId(shopItem)
    if item and item.ItemID2 then
      id, id2 = item.ItemID, item.ItemID2
    end
  end
  if not id then
    item = shopIns:GetShopItemDataByTypeId(shopItems[1])
    if item then
      id = item.ItemID
    end
  end
  return {id, id2}
end

function BFBuildingPanel:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, BFBuildingPanel.TabName[go.name], false, go:GetComponent(UISprite))
end

function BFBuildingPanel:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end

function BFBuildingPanel:StartCountdown(endTime)
  self.endTime = endTime
  self.timeTick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountDown, self, 1)
end

function BFBuildingPanel:UpdateCountDown()
  local leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
  local t_min = math.ceil(leftTime) / 60
  local t_sec = math.ceil(leftTime) % 60
  self.timeout.text = string.format("%02d:%02d", t_min, t_sec)
  if leftTime <= 0 then
    self:ClearTick()
    self:QueryInfo()
  end
end

function BFBuildingPanel:ClearTick(clearall)
  if self.timeTick ~= nil then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
  if clearall then
    TimeTickManager.Me():ClearTick(self)
  end
end

function BFBuildingPanel:ShowDonateConfirmCell(itemData, needNum)
  if not self.donateConfirmCell then
    local go = self:LoadPreferb("cell/BFBuildingDonateConfirmCell", self.confirmContainer, true)
    self.donateConfirmCell = BFBuildingDonateConfirmCell.new(go)
    self.donateConfirmCell.parentPanel = self
    self.CloseWhenClickOtherPlace = self.donateConfirmCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
    
    function self.CloseWhenClickOtherPlace.callBack(go)
      self.donateSelect = nil
      if not self.donateConfirmCell then
        self.donateConfirmCell:SetCountInput(1)
      end
      if self.donateWrapHelper then
        local cells = self.donateWrapHelper:GetCellCtls()
        for i = 1, #cells do
          cells[i]:CheckSetSelect()
        end
      end
    end
  end
  self.donateConfirmCell.gameObject:SetActive(true)
  self.donateConfirmCell:SetData({
    bid = self.id,
    itemData = itemData,
    needNum = needNum
  })
end

function BFBuildingPanel:HandleClickDonateCell(cell)
  self.donateSelect = cell
  local cells = self.donateWrapHelper:GetCellCtls()
  for i = 1, #cells do
    cells[i]:CheckSetSelect()
  end
  self:ShowDonateConfirmCell(cell.itemData, cell.needNum)
end

function BFBuildingPanel:HandleClickWeatherCell(cell)
  local cells = self.weatherListCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetSelect(false)
  end
  cell:SetSelect(true)
end

function BFBuildingPanel:HandleUseWeather(cell)
  ServiceNUserProxy.Instance:CallBuildOperateUserCmd(cell.data, fdata)
end

function BFBuildingPanel:HandleUseFunction(cell)
  ServiceNUserProxy.Instance:CallBuildOperateUserCmd(cell.itemid, fdata)
end

function BFBuildingPanel:HandleClickReviveCell(cell)
  local cells = self.reviveListCtl:GetCells()
  for i = 1, #cells do
    cells[i]:SetSelect(false)
  end
  cell:SetSelect(true)
end

local tempV3 = LuaVector3.New()

function BFBuildingPanel:HandleUseRevive(cell)
  local data = cell.data
  if data.status == ERAREELITESTATUS.ERAREELITESTATUS_ALIVE then
    Game.Myself:TryUseQuickRide()
    LuaVector3.Better_Set(tempV3, data.pos.x / 1000, data.pos.y / 1000, data.pos.z / 1000)
    Game.Myself:Client_MoveTo(tempV3)
    self:CloseSelf()
  elseif data.status == ERAREELITESTATUS.ERAREELITESTATUS_DEAD then
    ServiceNUserProxy.Instance:CallBuildOperateUserCmd(data.npcid, fdata)
  end
end

function BFBuildingPanel:HandleReviveQuery(cell)
  self:QueryInfo()
end

local tipOffset = {-190, 0}

function BFBuildingPanel:HandleClickFunctionIconSprite(cellCtl)
  if self.btype ~= buildingType.Toy then
    return
  end
  local data = shopIns:GetShopItemDataByTypeId(cellCtl.data)
  if data and data.goodsID then
    self.tipData.itemdata = data:GetItemData()
    self:ShowItemTip(self.tipData, self.rightBg, NGUIUtil.AnchorSide.Left, tipOffset)
  end
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function BFBuildingPanel:HandleClickFunctionCell(cellCtl)
  if self.btype ~= buildingType.Toy then
    return
  end
  if self.currentFunctionItem ~= cellCtl then
    if self.currentFunctionItem then
      self.currentFunctionItem:SetChoose(false)
    end
    cellCtl:SetChoose(true)
    self.currentFunctionItem = cellCtl
  end
  local id = cellCtl.data
  local data = shopIns:GetShopItemDataByTypeId(id)
  local go = cellCtl.gameObject
  if self.selectGo == go then
    self.selectGo = nil
    return
  end
  self.selectGo = go
  if data then
    if data:GetLock() then
      FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID, true)
      self.buyCell.gameObject:SetActive(false)
      return
    end
    shopIns:SetSelectId(id)
    self:UpdateBuyItemInfo(data)
  end
end
