EquipRecommendMainNew = class("EquipRecommendMainNew", SubView)
autoImport("TeamCell")
autoImport("TeamGoalCombineCellForER")
autoImport("ERCell")
autoImport("AdventureResearchCategoryCell")
autoImport("AdventureResearchDescriptionCell")
autoImport("AdventureResearchCombineItemCellForER")
autoImport("Charactor")
autoImport("AdventureResearchPage")
autoImport("SetQuickItemCell")
autoImport("ERLevelCell")
autoImport("ERModeCell")
autoImport("ERSlotTypeCell")
local View_Path = ResourcePathHelper.UIView("EquipRecommendMainNew")
EquipRecommendMainNew.ERCellRes = ResourcePathHelper.UICell("ERCell")
EquipRecommendMainNew.Instance = nil
local equipTypeSlot = {
  [1] = {1},
  [2] = {3},
  [3] = {2},
  [4] = {4},
  [5] = {5},
  [6] = {6, 7},
  [16] = {2},
  [17] = {2},
  [18] = {2},
  [19] = {2}
}
local midDepth = 2
local defaultSlotTypeId = 8
local panelParams = {
  None = {
    90,
    -201,
    400
  },
  One = {
    60,
    -186,
    370
  },
  Two = {
    30,
    -171,
    340
  }
}

function EquipRecommendMainNew:Init()
  if not EquipRecommendMainNew.Instance then
    EquipRecommendMainNew.Instance = self
  end
  self:FindObjs()
  self:AddViewEvts()
  self:InitView()
end

function EquipRecommendMainNew:InitView()
  self:Show()
  TimeTickManager.Me():CreateOnceDelayTick(10, function(owner, deltaTime)
    self.teamTable:Reposition()
  end, self)
  ServiceNUserProxy.Instance:CallServantRecEquipUserCmd(_EmptyTable)
  local list = ReusableTable.CreateArray()
  local datas = GameConfig.Servant.EquipRecommend_level
  local count = #datas
  self.curLevelId = 1
  local myLevel = MyselfProxy.Instance:RoleLevel()
  for i = 1, count do
    local min = i == 1 and 1 or datas[i - 1]
    list[i] = {
      id = i,
      min = min,
      max = datas[i]
    }
    if myLevel >= min then
      self.curLevelId = i
    end
  end
  table.sort(list, function(x, y)
    return x.id > y.id
  end)
  self.eRLevelDatas = list
  list = ReusableTable.CreateArray()
  datas = GameConfig.Servant.EquipRecommend_mode
  count = #datas
  for i = 1, count do
    list[i] = {
      id = i,
      data = datas[i]
    }
  end
  self.eRModeDatas = list
  list = ReusableTable.CreateArray()
  datas = GameConfig.Servant.EquipRecommend_SlotName
  count = #datas
  for i = 1, count do
    list[i] = {
      id = i,
      data = datas[i]
    }
  end
  self.eRSlotTypeDatas = list
  self.curModeId = 1
  self.curSlotTypeId = defaultSlotTypeId
  self:SelectERLevelCell(self.curLevelId)
  self:SelectERModeCell(self.curModeId)
  self:SelectERSlotTypeCell(self.curSlotTypeId)
  self:TrySelectFirstProfession()
end

function EquipRecommendMainNew:OnEnter()
  self:RegisterEvents()
  ServiceNUserProxy.Instance:CallProfessionQueryUserCmd()
end

function EquipRecommendMainNew:OnExit()
  self:RemoveEvents()
  if self.eRLevelDatas then
    ReusableTable.DestroyAndClearArray(self.eRLevelDatas)
    self.eRLevelDatas = nil
  end
  if self.eRModeDatas then
    ReusableTable.DestroyAndClearArray(self.eRModeDatas)
    self.eRModeDatas = nil
  end
  if self.eRSlotTypeDatas then
    ReusableTable.DestroyAndClearArray(self.eRSlotTypeDatas)
    self.eRSlotTypeDatas = nil
  end
end

function EquipRecommendMainNew:RegisterEvents()
  EventManager.Me():AddEventListener(EquipRecommendMainNewEvent.OnStartDragEvent, self.OnManualStartDrag, self)
  EventManager.Me():AddEventListener(EquipRecommendMainNewEvent.OnEndDragEvent, self.OnManualEndDrag, self)
  EventManager.Me():AddEventListener(EquipRecommendMainNewEvent.OnCursorEvent, self.OnCursorEvent, self)
  EventManager.Me():AddEventListener(EquipRecommendMainNewEvent.RecvProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd, self)
end

function EquipRecommendMainNew:RemoveEvents()
  EventManager.Me():RemoveEventListener(EquipRecommendMainNewEvent.OnStartDragEvent, self.OnManualStartDrag, self)
  EventManager.Me():RemoveEventListener(EquipRecommendMainNewEvent.OnEndDragEvent, self.OnManualEndDrag, self)
  EventManager.Me():RemoveEventListener(EquipRecommendMainNewEvent.OnCursorEvent, self.OnCursorEvent, self)
  EventManager.Me():RemoveEventListener(EquipRecommendMainNewEvent.RecvProfessionQueryUserCmd, self.RecvProfessionQueryUserCmd, self)
end

function EquipRecommendMainNew:FindObjs()
  local container = self:FindGO("ServantImproveViewNew")
  self.gameObject = self:LoadPreferb_ByFullPath(View_Path, container, true)
  self.gameObject:SetActive(true)
  self.JobClassScrollView = self:FindComponent("JobClassScrollView", UIScrollView)
  self.JobClassPanel = self:FindComponent("JobClassScrollView", UIPanel)
  self.JobClassTabel = self:FindGO("JobClassTabel", self.JobClassScrollView.gameObject)
  self.goalListCtl = ListCtrl.new(self.JobClassTabel:GetComponent(UITable), TeamGoalCombineCellForER, "TeamGoalCombineCellForER")
  self.goalListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGoal, self)
  self.TeamScroll = self:FindGO("TeamScroll", self.gameObject)
  self.TeamScroll_UIPanel = self.TeamScroll:GetComponent(UIPanel)
  self.TeamList = self:FindGO("TeamList", self.TeamScroll)
  self.teamTable = self.TeamList:GetComponent(UITable)
  self.teamListCtl = UIGridListCtrl.new(self.teamTable, ERCell, "ERCell")
  self.teamListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickERCell, self)
  self.goalListCtl:ResetDatas(self:GetFatherTable())
  self.TanChu = self:FindGO("TanChu")
  self.TanChu.gameObject:SetActive(false)
  self.TanChu_Close = self:FindGO("Close", self.TanChu)
  self.TanChu_UIPanel = self.TanChu:GetComponent(UIPanel)
  self:AddClickEvent(self.TanChu_Close, function()
    self.TanChu.gameObject:SetActive(false)
    self.isShowTanChu = false
  end)
  self.ResearchItemList = self:FindGO("ResearchItemList", self.TanChu)
  self.ItemScrollView = self:FindGO("ItemScrollView", self.ResearchItemList)
  self.itemContainer = self:FindGO("bag_itemContainer", self.ItemScrollView)
  self.itemContainer.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 1)
  local pfbNum = 6
  local rt = Screen.height / Screen.width
  if 0.5625 < rt then
    pfbNum = 10
  end
  local wrapConfig = {
    wrapObj = self.itemContainer,
    pfbNum = pfbNum,
    cellName = "AdventureBagCombineItemCell",
    control = AdventureResearchCombineItemCellForER,
    dir = 1
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.ItemWraperScrollView = self.ItemScrollView:GetComponent(ROUIScrollView)
  
  function self.ItemWraperScrollView.OnStop()
    self.ItemWraperScrollView:Revert()
  end
  
  self.tipHolder = self:FindComponent("ScrollBg", UIWidget, self.ResearchItemList)
  self.TanChu_ERCellPoint = self:FindGO("ERCellPoint", self.TanChu)
  local obj = Game.AssetManager_UI:CreateAsset(EquipRecommendMainNew.ERCellRes, self.TanChu_ERCellPoint)
  self.TanChu_ERCell = ERCell.new(obj)
  self.TanChu_ERCell.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self.TanChu_TipPoint = self:FindGO("TipPoint", self.TanChu)
  self.TanChu_TipPoint_UIWidget = self.TanChu_TipPoint:GetComponent(UIWidget)
  local allItemCells = self.wraplist:GetCellCtls()
  for k, v in pairs(allItemCells) do
    local cells = v:GetCells()
    for m, n in pairs(cells) do
      n:CanDrag(true)
    end
  end
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
  self.TanChu_FilterCondition = self:FindGO("FilterCondition", self.TanChu)
  self.FilterCondition = self.TanChu_FilterCondition:GetComponent(UIToggle)
  self.FilterConditionLabel = self:FindComponent("Label", UILabel, self.FilterCondition.gameObject)
  self.FilterConditionLabel.text = "当前职业"
  self:AddClickEvent(self.FilterCondition.gameObject, function(obj)
    self.professionSelected = self.FilterCondition.value
    self:tabClick(self.selectTabData)
  end)
  local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
  local cells = cellCtrl:GetCells()
  cellCtrl:AddEventListener(SetQuickItemCell.SwapObj, self.SetQuickUseFunc, self)
  self.rightbtn1 = self:FindGO("rightbtn1", self.TanChu)
  self.rightbtn2 = self:FindGO("rightbtn2", self.TanChu)
  self.label_rightbtn2 = self:FindComponent("Name", UILabel, self.rightbtn2)
  self.effectColor_rightbtn2_name = self.label_rightbtn2.effectColor
  self:AddClickEvent(self.rightbtn1.gameObject, function(obj)
    if self.CurrentTanChuERCellId then
      self.TanChu_ERCell:SetData(Table_Equip_recommend[self.CurrentTanChuERCellId])
      local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
      local cells = cellCtrl:GetCells()
      for k, v in pairs(cells) do
        v:SetQuickPos(k)
        v:RemoveUIDragScrollView()
      end
      self:SetTextureGrey(self.rightbtn2)
      self:CheckoutSaveButton()
    end
  end)
  self:AddClickEvent(self.rightbtn2.gameObject, function(obj)
    local ServantEquipItemData = {}
    ServantEquipItemData.id = self.CurrentTanChuERCellId
    ServantEquipItemData.equipid = {}
    local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
    local cells = cellCtrl:GetCells()
    for k, v in pairs(cells) do
      local vid = v:GetEquipId()
      ServantEquipItemData.equipid[#ServantEquipItemData.equipid + 1] = vid
    end
    if not self:CheckoutSaveButton() then
      return nil
    end
    MsgManager.ShowMsgByIDTable(34009)
    local t = ReusableTable.CreateArray()
    TableUtility.ArrayPushBack(t, ServantEquipItemData)
    ServiceNUserProxy.Instance:CallServantRecEquipUserCmd(t)
    ReusableTable.DestroyAndClearArray(t)
    self:SetTextureGrey(self.rightbtn2)
  end)
  self.SearchButton = self:FindGO("SearchButton", self.TanChu)
  self.ContentInput = self:FindGO("ContentInput", self.TanChu)
  self.ContentInput_UIInput = self.ContentInput:GetComponent(UIInput)
  self:AddClickEvent(self.SearchButton.gameObject, function(g)
    self:Button_Search()
  end)
  self.NameForJob = self:FindGO("NameForJob")
  self.NameForJob_UILabel = self.NameForJob:GetComponent(UILabel)
  self.NameForJob_UILabel.text = MyselfProxy.Instance:GetMyProfessionName()
  self.NameForZhuan = self:FindGO("NameForZhuan")
  self.NameForZhuan_UILabel = self.NameForZhuan:GetComponent(UILabel)
  local myProfession = MyselfProxy.Instance:GetMyProfession()
  local config = Table_Class[myProfession]
  local depth = ProfessionProxy.Instance:GetDepthByClassId(myProfession)
  if config ~= nil and config.FeatureSkill ~= nil then
    self.NameForZhuan_UILabel.text = ZhString.HeroTransfer
  elseif depth == 1 then
    self.NameForZhuan_UILabel.text = ZhString.OneTransfer
  elseif depth == 2 then
    self.NameForZhuan_UILabel.text = ZhString.TwoTransfer
  elseif depth == 3 then
    self.NameForZhuan_UILabel.text = ZhString.ThreeTransfer
  elseif depth == 4 then
    self.NameForZhuan_UILabel.text = ZhString.FourTransfer
  elseif depth == 5 then
    self.NameForZhuan_UILabel.text = ZhString.FiveTransfer
  else
    self.NameForZhuan_UILabel.text = ""
  end
  self.curProfessionDepth = depth
  self.maxProfessionDepth = 0
  self.joblv = self:FindGO("joblv")
  self.joblv_Label = self:FindGO("Label", self.joblv)
  self.joblv_Label_UILabel = self.joblv_Label:GetComponent(UILabel)
  local userdata = Game.Myself.data.userdata
  local baseLv = userdata:Get(UDEnum.ROLELEVEL)
  self.joblv_Label_UILabel.text = baseLv
  self.rightTop = self:FindGO("rightTop")
  self:RegistShowGeneralHelpByHelpID(30002, self.rightTop)
  self.item_Level = self:FindGO("Item_Level")
  self.panel_Level = self:FindGO("Panel_Level")
  self.bg_Panel_Level = self:FindComponent("BG_Panel_Level", UISprite)
  self.label_Level = self:FindComponent("Label_Level", UILabel)
  self.eRLevelGrid = self:FindComponent("ERLevelGrid", UIGrid)
  self.eRLevelCtrl = UIGridListCtrl.new(self.eRLevelGrid, ERLevelCell, "ERLevelCell")
  self.eRLevelCtrl:AddEventListener(MouseEvent.MouseClick, self.ChosseERLevelCell, self)
  self.item_Mode = self:FindGO("Item_Mode")
  self.panel_Mode = self:FindGO("Panel_Mode")
  self.bg_Panel_Mode = self:FindComponent("BG_Panel_Mode", UISprite)
  self.label_Mode = self:FindComponent("Label_Mode", UILabel)
  self.eRModeGrid = self:FindComponent("ERModeGrid", UIGrid)
  self.eRModeCtrl = UIGridListCtrl.new(self.eRModeGrid, ERModeCell, "ERModeCell")
  self.eRModeCtrl:AddEventListener(MouseEvent.MouseClick, self.ChosseERModeCell, self)
  self.item_SlotType = self:FindGO("Item_SlotType")
  self.panel_SlotType = self:FindGO("Panel_SlotType")
  self.bg_Panel_SlotType = self:FindComponent("BG_Panel_SlotType", UISprite)
  self.label_SlotType = self:FindComponent("Label_SlotType", UILabel)
  self.eRSlotTypeGrid = self:FindComponent("ERSlotTypeGrid", UIGrid)
  self.eRSlotTypeCtrl = UIGridListCtrl.new(self.eRSlotTypeGrid, ERSlotTypeCell, "ERSlotTypeCell")
  self.eRSlotTypeCtrl:AddEventListener(MouseEvent.MouseClick, self.ChosseERSlotTypeCell, self)
  self:AddClickEvent(self:FindGO("Button_Level"), function()
    self:Button_Level()
  end)
  self:AddClickEvent(self:FindGO("Button_Mode"), function()
    self:Button_Mode()
  end)
  self:AddClickEvent(self.item_SlotType, function()
    self:Button_SlotType()
  end)
  self:AddClickEvent(self:FindGO("Button_Close_Panel_Level"), function()
    self.panel_Level:SetActive(false)
  end)
  self:AddClickEvent(self:FindGO("Button_Close_Panel_Mode"), function()
    self.panel_Mode:SetActive(false)
  end)
  self:AddClickEvent(self:FindGO("Button_Close_Panel_SlotType"), function()
    self.panel_SlotType:SetActive(false)
  end)
  self:AddListenEvt(ServiceEvent.NUserServantRecEquipUserCmd, self.RecEquipUserCmd)
  self.gotoRoot = self:FindGO("GotoRoot")
  local gotoAttribute = self:FindGO("GotoAttribute", self.gotoRoot)
  self:AddClickEvent(gotoAttribute, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Charactor,
      viewdata = {tab = 1}
    })
  end)
  local config = Table_Class[MyselfProxy.Instance:GetMyProfession()]
  if config ~= nil and config.FeatureSkill ~= nil then
    local gotoSkillRoot = self:FindGO("GotoSkillRoot", self.gotoRoot)
    gotoSkillRoot:SetActive(false)
  else
    local gotoSkill = self:FindGO("GotoSkill", self.gotoRoot)
    self:AddClickEvent(gotoSkill, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = FunctionUnLockFunc.Me():GetPanelConfigById(4)
      })
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.SkillRecommendPopUp
      })
    end)
  end
end

function EquipRecommendMainNew:CheckoutSaveButton()
  local equipid = {}
  local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
  local cells = cellCtrl:GetCells()
  for k, v in pairs(cells) do
    local vid = v:GetEquipId()
    equipid[#equipid + 1] = vid
  end
  local tableData = self:GetRecordRecommendData(self.CurrentTanChuERCellId)
  local count, isDiff = #equipid, false
  for i = 1, count do
    if equipid[i] ~= tableData.equip[i] then
      isDiff = true
      break
    end
  end
  if isDiff then
    self:SetTextureWhite(self.rightbtn2)
    self.label_rightbtn2.effectColor = self.effectColor_rightbtn2_name
  else
    self:SetTextureGrey(self.rightbtn2)
  end
  return isDiff
end

function EquipRecommendMainNew:GetRecordRecommendData(id)
  local tableData = Table_Equip_recommend[id]
  if not tableData then
    LogUtility.Error(string.format("[%s] GetRecordRecommendData() Error : id = %s is not exist in Table_Equip_recommend!", self.__cname, tostring(id)))
    return nil
  end
  local data = {}
  TableUtil.deepcopy(data, tableData)
  local count = self.ERDatsFromServer and #self.ERDatsFromServer or 0
  for k = 1, count do
    if self.ERDatsFromServer[k].id == id then
      data.equip = self.ERDatsFromServer[k].equipid
      break
    end
  end
  return data
end

function EquipRecommendMainNew:Button_Level()
  self.eRLevelCtrl:ResetDatas(self.eRLevelDatas)
  local cells = self.eRLevelCtrl:GetCells()
  self.bg_Panel_Level.height = 37 * #cells + 53
  self.panel_Level:SetActive(true)
  self:SelectERLevelCell(self.curLevelId)
end

function EquipRecommendMainNew:Button_Mode()
  self.eRModeCtrl:ResetDatas(self.eRModeDatas)
  local cells = self.eRModeCtrl:GetCells()
  self.bg_Panel_Mode.height = 37 * #cells + 53
  self.panel_Mode:SetActive(true)
  self:SelectERModeCell(self.curModeId)
end

function EquipRecommendMainNew:Button_SlotType()
  self.eRSlotTypeCtrl:ResetDatas(self.eRSlotTypeDatas)
  local cells = self.eRSlotTypeCtrl:GetCells()
  local count = #cells - 1
  cells[7].gameObject:SetActive(false)
  cells[8].gameObject.transform.localPosition = cells[7].gameObject.transform.localPosition
  self.bg_Panel_SlotType.height = 37 * count + 53
  self.panel_SlotType:SetActive(true)
  self:SelectERSlotTypeCell(self.curSlotTypeId)
end

function EquipRecommendMainNew:ChosseERLevelCell(cell)
  if self.curERLevelCell ~= cell then
    self.curERLevelCell = cell
    self:SelectERLevelCell(cell.data.id, true)
  end
  self.panel_Level:SetActive(false)
end

function EquipRecommendMainNew:ChosseERModeCell(cell)
  if self.curERModeCell ~= cell then
    self.curERModeCell = cell
    self:SelectERModeCell(cell.data.id, true)
  end
  self.panel_Mode:SetActive(false)
end

function EquipRecommendMainNew:ChosseERSlotTypeCell(cell)
  if self.curERSlotTypeCell ~= cell then
    self.curERSlotTypeCell = cell
    self:SelectERSlotTypeCell(cell.data.id, true)
  end
  self.panel_SlotType:SetActive(false)
end

function EquipRecommendMainNew:SelectERLevelCell(id, isRefresh)
  local cells = self.eRLevelCtrl:GetCells()
  local count = #cells
  for i = 1, count do
    cells[i]:Select(cells[i].data.id == id)
  end
  self.curLevelId = id
  self:RefreshLevelInfo()
  self:RefreshItem_ModeState()
  if isRefresh then
    self:ClickGoal(self.clickParama, true)
  end
end

function EquipRecommendMainNew:SelectERModeCell(id, isRefresh)
  local cells = self.eRModeCtrl:GetCells()
  local count = #cells
  for i = 1, count do
    cells[i]:Select(cells[i].data.id == id)
  end
  self.curModeId = id
  self:RefreshModeInfo()
  if isRefresh then
    self:ClickGoal(self.clickParama, true)
  end
end

function EquipRecommendMainNew:SelectERSlotTypeCell(id, isRefresh)
  if self.TanChu_ERCell then
    self.TanChu_ERCell:SetSelectCell(id)
  end
  id = id == 7 and 6 or id
  local cells = self.eRSlotTypeCtrl:GetCells()
  local count = #cells
  for i = 1, count do
    cells[i]:Select(cells[i].data.id == id)
  end
  self.curSlotTypeId = id
  self:RefreshSlotTypeInfo()
  self.ContentInput_UIInput.value = ""
  if isRefresh then
    self:tabClick()
  end
end

function EquipRecommendMainNew:GetERLevelDatas(id)
  local datas = self.eRLevelDatas
  local count = #datas
  for i = 1, count do
    if datas[i].id == id then
      return datas[i]
    end
  end
  LogUtility.Error(string.format("[%s] GetERLevelDatas() Error : id = %s is not exist in self.eRLevelDatas!", self.__cname, tostring(id)))
  return nil
end

function EquipRecommendMainNew:RefreshLevelInfo()
  local data = self:GetERLevelDatas(self.curLevelId)
  self.label_Level.text = string.format("%s-%s", tostring(data.min), tostring(data.max))
end

function EquipRecommendMainNew:RefreshModeInfo()
  if self.curModeId == 0 then
    return nil
  end
  local data = self.eRModeDatas[self.curModeId]
  self.label_Mode.text = data.data
end

function EquipRecommendMainNew:RefreshSlotTypeInfo()
  if self.curSlotTypeId == 0 then
    return nil
  end
  local data = self.eRSlotTypeDatas[self.curSlotTypeId]
  self.label_SlotType.text = data.data
end

function EquipRecommendMainNew:CheckoutIsShowTanChu()
  return self.isShowTanChu
end

function EquipRecommendMainNew:Button_Search()
  if #self.ContentInput_UIInput.value > 0 then
    self:UpdateContent()
  elseif self.datasForTanChu then
    self:SetData(self.datasForTanChu)
  end
end

function EquipRecommendMainNew:OnManualStartDrag()
  local allItemCells, cells = self.wraplist:GetCellCtls()
  for k, v in pairs(allItemCells) do
    cells = v:GetCells()
    for m, n in pairs(cells) do
      n:SetAllSpriteAlpha(0.5)
    end
  end
  self.TanChu_ERCell:SetAllSpriteAlpha(0.5)
end

function EquipRecommendMainNew:OnManualEndDrag()
  local allItemCells, cells = self.wraplist:GetCellCtls()
  for k, v in pairs(allItemCells) do
    cells = v:GetCells()
    for m, n in pairs(cells) do
      n:SetAllSpriteAlpha(1)
    end
  end
  self.TanChu_ERCell:SetAllSpriteAlpha(1)
  self.TanChu_ERCell:SetSelectSlotItemData(false)
end

function EquipRecommendMainNew:OnCursorEvent(dragItem)
  local itemData = dragItem.data.itemdata
  if not itemData.equipInfo then
    LogUtility.Error(string.format("[%s] OnCursorEvent() Error : itemData.equipInfo == nil! id = %s", self.__cname, tostring(itemData.staticData.id)))
    return nil
  end
  if not itemData.equipInfo.equipData then
    LogUtility.Error(string.format("[%s] OnCursorEvent() Error : itemData.equipInfo.equipData == nil! id = %s", self.__cname, tostring(itemData.staticData.id)))
    return nil
  end
  local equipType = itemData.equipInfo.equipData.EquipType
  local slots = self:GetEquipSlotByType(equipType)
  if not slots then
    LogUtility.Error(string.format("[%s] OnCursorEvent() Error : id = %s, equipType = %s, is not exist in equipTypeSlot!", self.__cname, tostring(itemData.staticData.id), tostring(equipType)))
    return nil
  end
  local cells = self.TanChu_ERCell:GetGridCells()
  local datas = {}
  for i = 1, #slots do
    local cell = cells[slots[i]]
    datas[#datas + 1] = {
      data = cell.data,
      pos = cell.gameObject.transform.position
    }
  end
  self.TanChu_ERCell:SetSelectSlotItemData(true, datas)
end

function EquipRecommendMainNew:GetSlotString(slots)
  if not slots then
    return nil
  end
  local str = ""
  for i = 1, #slots do
    str = str .. tostring(slots[i]) .. (i < #slots and "," or "")
  end
  return str
end

function EquipRecommendMainNew:GetEquipSlotByType(equipType)
  return equipTypeSlot[equipType]
end

function EquipRecommendMainNew:CheckoutTargetSlotByType(curSlot, targetType)
  local slots = equipTypeSlot[targetType]
  local count = #slots
  if count == 0 then
    return false
  end
  for i = 1, count do
    if slots[i] == curSlot then
      return true
    end
  end
  return false
end

function EquipRecommendMainNew:GetRightDatas(outDatas, typeBranch, recommendLevel, recommendMode)
  local tables = Table_Equip_recommend
  for k, v in pairs(tables) do
    if v.branch == typeBranch and v.level == recommendLevel then
      if recommendLevel == #GameConfig.Servant.EquipRecommend_level then
        if v.mode == recommendMode then
          outDatas[#outDatas + 1] = v
        end
      else
        outDatas[#outDatas + 1] = v
      end
    end
  end
  return outDatas
end

function EquipRecommendMainNew:RecvProfessionQueryUserCmd(data)
  local datas, maxDepth, depth = data.items, 0
  if not datas then
    self.maxProfessionDepth = self.curProfessionDepth
    return nil
  end
  for k, v in pairs(datas) do
    depth = ProfessionProxy.Instance:GetDepthByClassId(v.profession)
    if maxDepth < depth then
      maxDepth = depth
    end
  end
  self.maxProfessionDepth = maxDepth
  self.maxProfessionDepth = self.maxProfessionDepth < self.curProfessionDepth and self.curProfessionDepth or self.maxProfessionDepth
  self.maxProfessionDepth = self.maxProfessionDepth < 2 and 2 or self.maxProfessionDepth
  self:RefreshItem_ModeState()
  self:TrySelectFirstProfession()
end

function EquipRecommendMainNew:RefreshItem_ModeState()
  if self.preLevelId == self.curLevelId then
    return nil
  end
  self.preLevelId = self.curLevelId
  self.item_Level:SetActive(true)
  local length = #GameConfig.Servant.EquipRecommend_level
  self.item_Mode:SetActive(self.curLevelId == length)
  local param = self.curLevelId == length and self:GetPanelParams("Two") or self:GetPanelParams("One")
  local pos = self.JobClassPanel.gameObject.transform.localPosition
  local clipOffset = self.JobClassPanel.clipOffset
  local baseClipRegion = self.JobClassPanel.baseClipRegion
  self.JobClassPanel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, param[1], pos.z)
  self.JobClassPanel.clipOffset = LuaGeometry.GetTempVector2(clipOffset.x, param[2])
  self.JobClassPanel.baseClipRegion = LuaGeometry.GetTempVector4(baseClipRegion.x, baseClipRegion.y, baseClipRegion.z, param[3])
end

function EquipRecommendMainNew:GetPanelParams(mode)
  return panelParams[mode]
end

function EquipRecommendMainNew:UpdateContent()
  local data = self:GetExchangeSearchContent(self.ContentInput_UIInput.value)
  if 0 < #data then
    self:SetData(data, noResetPos)
  else
    MsgManager.ShowMsgByID(34005)
  end
end

local searchContent = {}

function EquipRecommendMainNew:GetExchangeSearchContent(keyword)
  TableUtility.ArrayClear(searchContent)
  keyword = string.lower(keyword)
  local tempName
  if self.datasForTanChu ~= nil then
    for k, v in pairs(self.datasForTanChu) do
      if v.staticData.NameZh then
        tempName = string.lower(v.staticData.NameZh)
        if string.find(tempName, keyword) then
          table.insert(searchContent, v)
        end
      end
    end
  end
  return searchContent
end

function EquipRecommendMainNew:RecEquipUserCmd(param)
  if not self.ERDatsFromServer then
    self.ERDatsFromServer = {}
  end
  local count, isFind = #self.ERDatsFromServer
  for i = 1, #param.body.datas do
    local v = param.body.datas[i]
    local t = {}
    t.id = v.id
    t.equipid = {}
    for j = 1, #v.equipid do
      local n = v.equipid[j]
      t.equipid[#t.equipid + 1] = n
    end
    count, isFind = #self.ERDatsFromServer, false
    for k = 1, count do
      if self.ERDatsFromServer[k].id == t.id then
        self.ERDatsFromServer[k] = t
        isFind = true
        break
      end
    end
    if not isFind then
      self.ERDatsFromServer[#self.ERDatsFromServer + 1] = t
    end
  end
  self:UpdateUI()
end

function EquipRecommendMainNew:UpdateUI()
  local cells = self.teamListCtl:GetCells()
  for k, v in pairs(cells) do
    v:ChangeScrollViewDepth(self.TeamScroll_UIPanel.depth + 1)
    local erid = v:GetTableERid()
    if self.ERDatsFromServer then
      for m, n in pairs(self.ERDatsFromServer) do
        if n.id == erid then
          local newData = {}
          newData.id = erid
          newData.branch = Table_Equip_recommend[erid].branch
          newData.genre = Table_Equip_recommend[erid].genre
          newData.equip = n.equipid
          v:SetData(newData)
        end
      end
    end
    local cellCtrl = v:Get_EquipRecommendGrid_UIGridListCtrl()
    local e_cells = cellCtrl:GetCells()
    for m, n in pairs(e_cells) do
      n:CanDrag(false)
    end
  end
end

local noviceRaceFirstProfMap = {
  [2] = 152
}
local firstProfessionPredicate = function(curClass)
  if ProfessionProxy.IsNovice() then
    local noviceFProf = noviceRaceFirstProfMap[MyselfProxy.Instance:GetMyRace()]
    if noviceFProf then
      return curClass.TypeBranch == ProfessionProxy.GetTypeBranchFromProf(noviceFProf)
    end
  end
  return EquipRecommendMainNew.IsSameClassType(curClass.Type, MyselfProxy.Instance:GetMyProfessionType())
end

function EquipRecommendMainNew:TrySelectFirstProfession()
  local professionId = MyselfProxy.Instance:GetMyProfession()
  local goalCells, clicked, goalData = self.goalListCtl:GetCells()
  if goalCells and 0 < #goalCells then
    for i = 1, #goalCells do
      goalData = goalCells[i].data
      if goalData and firstProfessionPredicate(goalData.fatherGoal) then
        if self.maxProfessionDepth < midDepth then
          if self.curProfessionDepth == 0 then
            goalCells[i]:SetFolderState(false)
            goalCells[i]:ClickFather()
            self:JobClassScrollTowardsIndex(i)
            clicked = true
            break
          elseif goalCells[i].data.fatherGoal.id == professionId then
            goalCells[i]:SetFolderState(false)
            goalCells[i]:ClickFather()
            self:JobClassScrollTowardsIndex(i)
            clicked = true
            break
          end
        else
          goalCells[i]:SetFolderState(false)
          goalCells[i]:ClickFather()
          self:JobClassScrollTowardsIndex(i)
          if ProfessionProxy.GetJobDepth() < 2 then
            goalCells[i]:ClickChild()
            clicked = true
            break
          end
          do
            local childCells = goalCells[i].childCtl:GetCells()
            for j = 1, #childCells do
              if professionId == childCells[j].data.id then
                goalCells[i]:ClickChild(childCells[j])
                clicked = true
                break
              end
            end
          end
          break
        end
      end
    end
    local showArrow = not (self.maxProfessionDepth < midDepth)
    for i = 1, #goalCells do
      goalCells[i]:ShowArrow(showArrow)
    end
  end
  if not clicked then
    goalCells[1]:SetFolderState(false)
    goalCells[1]:ClickFather()
    goalCells[1]:ClickChild()
  end
end

function EquipRecommendMainNew:JobClassScrollTowardsIndex(index)
  self.goalListCtl:ResetPosition()
  local goalCells = self.goalListCtl:GetCells()
  local targetCell = goalCells[index]
  if not targetCell then
    return
  end
  local targetX, targetY, targetZ = LuaGameObject.GetLocalPosition(self.JobClassScrollView.transform)
  targetY = targetY + 70 * math.clamp(index - 2, 0, 99999)
  SpringPanel.Begin(self.JobClassScrollView.gameObject, LuaGeometry.GetTempVector3(targetX, targetY, targetZ), 30)
end

function EquipRecommendMainNew:SetQuickUseFunc(param)
  local surcData = param.surce.itemdata
  local surcPos = param.surce.pos
  local targetPos = param.target.pos
  local keys = {}
  local key = {
    guid = surcData.id,
    type = surcData.staticData.id,
    pos = targetPos - 1
  }
  table.insert(keys, key)
  local targetEId = param.target.data.staticData.id
  local tempItem = ItemData.new("", param.surce.itemdata.staticData.id)
  param.target:SetData(tempItem)
  if surcPos then
    local targetData = param.target.data
    local targetId, typeId
    if targetData then
      targetId = targetData.id
      typeId = targetData.staticData.id
    end
    local key2 = {
      guid = targetId,
      type = typeId,
      pos = surcPos - 1
    }
    table.insert(keys, key2)
    local tempItem = ItemData.new("", targetEId)
    local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
    local cells = cellCtrl:GetCells()
    for k, v in pairs(cells) do
      if k == param.surce.pos then
        v:SetData(tempItem)
      end
    end
  end
  self:CheckoutSaveButton()
end

function EquipRecommendMainNew:SetData(datas, noResetPos)
  datas = datas or {}
  self:resetSelectState(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 10)
  self.wraplist:UpdateInfo(newdata)
  self.selectData = nil
  local defaultItem = self:getDefaultSelectedItemData()
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end

function EquipRecommendMainNew:ClearSelectData()
  if self.chooseItemData then
    self.chooseItemData:setIsSelected(false)
  end
  if self.chooseItem then
    self.chooseItem:setIsSelected(false)
  end
  self.chooseItem = nil
  self.chooseItemData = nil
end

function EquipRecommendMainNew:resetSelectState(datas, noResetPos)
  if not noResetPos and self.gameObject.activeSelf then
    self.wraplist:ResetPosition()
    if self.chooseItem and self.chooseItemData then
      self.chooseItemData:setIsSelected(false)
      self.chooseItem:setIsSelected(false)
    end
    self:ClearSelectData()
  end
end

local itemCells = {}

function EquipRecommendMainNew:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
  TableUtility.TableClear(itemCells)
  for i = 1, #combineCells do
    local v = combineCells[i]
    local childs = v:GetCells()
    for i = 1, #childs do
      table.insert(itemCells, childs[i])
    end
  end
  return itemCells
end

function EquipRecommendMainNew:getDefaultSelectedItemData()
  local cells = self:GetItemCells() or _EmptyTable
  if 0 < #cells then
    if self.chooseItemData then
      for i = 1, #cells do
        local single = cells[i]
        if single.data then
          return single
        end
      end
    else
      for i = 1, #cells do
        local cell = cells[i]
        if cell.data then
          return cell
        end
      end
    end
  end
end

function EquipRecommendMainNew:tabClick(selectTabData, noResetPos)
  if not self.data then
    helplog("self.data is nil")
    return
  end
  self.selectTabData = selectTabData
  if self.data.staticData.id == AdventureResearchPage.DataFromMenuId then
    self:Hide(self.ResearchItemList)
    self:Show(self.ResearchDescriptionList)
    local descDatas = {}
    for k, v in pairs(Table_GameFunction) do
      table.insert(descDatas, v)
    end
    table.sort(descDatas, function(l, r)
      return l.Order < r.Order
    end)
    table.sort(descDatas, function(l, r)
      if FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) and FunctionUnLockFunc.Me():CheckCanOpen(r.MenuID) then
        return l.Order < r.Order
      elseif FunctionUnLockFunc.Me():CheckCanOpen(l.MenuID) then
        return true
      else
        return false
      end
    end)
    self.descriptionGrid:ResetDatas(descDatas)
  else
    self.datasForTanChu = nil
    self.datasForTanChu = {}
    if selectTabData and selectTabData.id ~= AdventureItemNormalListPage.MaxCategory.id then
      self.datasForTanChu = AdventureDataProxy.Instance:getItemsByCategoryAndClassifyNew(self.data.staticData.id, self.professionSelected, selectTabData.id, self.currentJobId)
    else
      self.datasForTanChu = AdventureDataProxy.Instance:getItemsByCategoryAndClassifyNew(self.data.staticData.id, self.professionSelected, nil, self.currentJobId)
    end
    local data, equipType
    for i = #self.datasForTanChu, 1, -1 do
      data = self.datasForTanChu[i]
      if self:IsThisLock(data) then
        table.remove(self.datasForTanChu, i)
      elseif self.curSlotTypeId ~= defaultSlotTypeId then
        if not data.equipInfo then
          LogUtility.Error(string.format("[%s] tabClick() Error : data.equipInfo == nil! id = %s", self.__cname, tostring(data.staticData.id)))
          return nil
        end
        if not data.equipInfo.equipData then
          LogUtility.Error(string.format("[%s] tabClick() Error : data.equipInfo.equipData == nil! id = %s", self.__cname, tostring(data.staticData.id)))
          return nil
        end
        equipType = data.equipInfo.equipData.EquipType
        if not self:CheckoutTargetSlotByType(self.curSlotTypeId, equipType) then
          table.remove(self.datasForTanChu, i)
        end
      end
    end
    if #self.ContentInput_UIInput.value > 0 then
      self:Button_Search()
    else
      self:SetData(self.datasForTanChu, noResetPos)
    end
  end
end

function EquipRecommendMainNew:IsThisLock(data)
  local status = true
  if data.type == SceneManual_pb.EMANUALTYPE_EQUIP then
    status = AdventureDataProxy.Instance:checkEquipIsUnlock(data.staticId)
  elseif data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or data.type == SceneManual_pb.EMANUALTYPE_ITEM then
    status = AdventureDataProxy.Instance:checkShopItemIsUnlock(data.staticId)
  elseif data.type == SceneManual_pb.EMANUALTYPE_MATE then
    status = AdventureDataProxy.Instance:checkMercenaryCatIsUnlock(data:getCatId())
  end
  status = not status
  return status
end

function EquipRecommendMainNew:setCategoryData(data)
  self.data = data
  local list = {}
  if data and data.classifys and #data.classifys > 0 then
    for i = 1, #data.classifys do
      local single = data.classifys[i]
      table.insert(list, single)
    end
    table.sort(list, function(l, r)
      return l.Order < r.Order
    end)
    self:tabClick()
    if data.staticData.id == AdventureResearchPage.ShowFilterConditionId then
      self:Show(self.FilterCondition.gameObject)
    else
      self:Hide(self.FilterCondition.gameObject)
    end
  else
    self:Hide(self.FilterCondition.gameObject)
    self:tabClick()
  end
end

function EquipRecommendMainNew:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = datas[i]
    end
  end
  return self.unitData
end

function EquipRecommendMainNew:HandleClickItem(cellCtl, noClickSound)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    if self.chooseItem ~= cellCtl or data ~= self.chooseItemData then
      if self.chooseItemData then
        self.chooseItemData:setIsSelected(false)
      end
      if self.chooseItem then
        self.chooseItem:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      data:setIsSelected(true)
      cellCtl:setIsSelected(true)
      self.TanChu_TipPoint_UIWidget.gameObject.transform.position = cellCtl.gameObject.transform.position
      self:ShowItemTipEx(data, self.TanChu_TipPoint_UIWidget)
      self.chooseItem = cellCtl
      self.chooseItemData = data
    elseif self.chooseItem == cellCtl or data == self.chooseItemData then
      self:ClearSelectData()
    end
  end
end

function EquipRecommendMainNew:ShowItemTipEx(data, go)
  go = go or self.tipHolder
  if data.type == SceneManual_pb.EMANUALTYPE_MATE then
    TipManager.Instance:ShowCatTipById(data:getCatId(), go, NGUIUtil.AnchorSide.Right, {200, 0})
  else
    local itemData = ItemData.new(data.staticId, data.staticId)
    local sdata = {
      itemdata = itemData,
      showUpTip = true,
      ignoreBounds = false,
      callback = function()
        self:ClearSelectData()
      end,
      showFrom = "EquipRecommendMainNew"
    }
    local equipType = itemData.equipInfo.equipData.EquipType
    local slots = self:GetEquipSlotByType(equipType)
    if not slots then
      LogUtility.Error(string.format("[%s] ShowItemTipEx() Error : id = %s, equipType = %s, is not exist in equipTypeSlot!", self.__cname, tostring(itemData.staticData.id), tostring(equipType)))
      return nil
    end
    local cells = self.TanChu_ERCell:GetGridCells()
    local compDatas, cell = {}
    for i = 1, #slots do
      cell = cells[slots[i]]
      compDatas[#compDatas + 1] = ItemData.new(cell.data.staticData.id, cell.data.staticData.id)
    end
    if 1 < #compDatas then
      table.insert(compDatas, 1, compDatas[#compDatas])
    end
    sdata.compdata1 = compDatas[1]
    sdata.compdata2 = compDatas[2]
    local tipOffset = {
      go.transform.localPosition.x,
      0
    }
    local tip = self:ShowItemTip(sdata, go, nil, tipOffset)
    if tip then
      tip:HideShowUpBtn()
    end
  end
end

function EquipRecommendMainNew:OnClickERCell(data)
  self.categorys = AdventureDataProxy.Instance:getTabsByCategory(SceneManual_pb.EMANUALTYPE_RESEARCH)
  local list = {}
  for k, v in pairs(self.categorys.childs) do
    table.insert(list, v)
  end
  table.sort(list, function(l, r)
    return l.staticData.Order < r.staticData.Order
  end)
  self.TanChu.gameObject:SetActive(true)
  self.isShowTanChu = true
  self:SetTextureGrey(self.rightbtn2)
  if data.data ~= nil then
    self.TanChu_ERCell:SetEquipRecommendMainNew(self)
    self.TanChu_ERCell:SetData(data.data)
    self.TanChu_ERCell:ProcessForTanChu()
    self.TanChu_ERCell:ChangeScrollViewDepth(self.TanChu_UIPanel.depth + 1)
    self.TanChu_ERCell:ShowBG2()
    self.CurrentTanChuERCellId = data.data.id
    local cellCtrl = self.TanChu_ERCell:Get_EquipRecommendGrid_UIGridListCtrl()
    local cells = cellCtrl:GetCells()
    for k, v in pairs(cells) do
      v:SetQuickPos(k)
      v:RemoveUIDragScrollView()
    end
    local job_branch = Table_Equip_recommend[self.CurrentTanChuERCellId].branch
    self.currentJobId = 0
    for k, v in pairs(Table_Class) do
      if v.TypeBranch == job_branch and (v.id % 10 == 2 or 0 < TableUtility.ArrayFindIndex(ProfessionProxy.specialDepthJobs, v.id)) then
        self.currentJobId = v.id
      end
    end
    local count, maxCount = #equipTypeSlot, 1
    for i = 1, count do
      if count < #equipTypeSlot[i] then
        count = #equipTypeSlot[i]
      end
    end
    self.TanChu_ERCell:GenericSelectSlotItem(count)
  end
  if list and 0 < #list then
    self:setCategoryData(list[1])
  end
end

function EquipRecommendMainNew:GetFatherTable()
  local branchTable = {}
  for k, v in pairs(Table_Equip_recommend) do
    branchTable[v.branch] = v.branch
  end
  local forbidBranch = ProfessionProxy.GetBannedBranches()
  if forbidBranch then
    for p, _ in pairs(forbidBranch) do
      branchTable[p] = nil
    end
  end
  local fatherTable = {}
  local branchTypeTable = {}
  for k, v in pairs(branchTable) do
    local branchType = self:GetTableClassTypeFromBranch(v)
    if branchType then
      branchTypeTable[branchType] = branchType
    end
  end
  for k, v in pairs(branchTypeTable) do
    for m, n in pairs(Table_Class) do
      if (n.id % 10 == 1 or TableUtility.ArrayFindIndex(ProfessionProxy.specialDepthJobs, n.id) > 0) and EquipRecommendMainNew.IsSameClassType(n.Type, v) then
        table.insert(fatherTable, {
          fatherGoal = Table_Class[n.id],
          childGoals = {}
        })
      end
    end
  end
  for k, v in pairs(branchTable) do
    for m, n in pairs(fatherTable) do
      if EquipRecommendMainNew.IsSameClassType(n.fatherGoal.Type, self:GetTableClassTypeFromBranch(v)) then
        local cData = self:GetClassDataToShow(v)
        if cData ~= nil and cData ~= _EmptyTable then
          table.insert(n.childGoals, cData)
        end
      end
    end
  end
  table.sort(fatherTable, function(a, b)
    return a.fatherGoal.id < b.fatherGoal.id
  end)
  return fatherTable
end

function EquipRecommendMainNew.IsSameClassType(l, r)
  return l == r or l == 0 and r == 7 or l == 7 and r == 0
end

function EquipRecommendMainNew:GetTableClassTypeFromBranch(branchId)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branchId then
      return v.Type
    end
  end
end

function EquipRecommendMainNew:GetClassDataToShow(branchId)
  local myDepth, isSpecialBranch, job, branch, isHero = ProfessionProxy.GetJobDepth()
  for i = 1, #ProfessionProxy.specialJobs do
    job = ProfessionProxy.specialJobs[i]
    branch = ProfessionProxy.GetTypeBranchFromProf(job)
    if branch == branchId then
      isSpecialBranch = true
    end
    if isSpecialBranch then
      isHero = ProfessionProxy.IsHero(job)
    end
  end
  local minBranchDepth = isHero and 5 or isSpecialBranch and 3 or 2
  local targetDepth = math.clamp(myDepth, minBranchDepth, 9999)
  for k, v in pairs(Table_Class) do
    if v.TypeBranch == branchId and ProfessionProxy.GetJobDepth(v.id) == targetDepth then
      return v
    end
  end
  return _EmptyTable
end

function EquipRecommendMainNew:_resetCurCombine()
  if self.combineGoal then
    self.combineGoal:SetChoose(false)
    self.combineGoal:SetFolderState(false)
    self.combineGoal = nil
  end
end

function EquipRecommendMainNew:ClickGoal(parama, isNotPlayAnim)
  if "Father" == parama.type then
    if self.maxProfessionDepth < midDepth then
      local combine = parama.combine
      if combine == self.combineGoal then
        return nil
      end
      self:_resetCurCombine()
      self.combineGoal = combine
      self.fatherGoalId = combine.data.fatherGoal.id
      self.goal = self.fatherGoalId
      local typeBranch = combine.data.fatherGoal.TypeBranch
      local recommendLevel = 2
      local recommendMode = 0
      local outDatas = ReusableTable.CreateArray()
      self:GetRightDatas(outDatas, typeBranch, recommendLevel, recommendMode)
      self:RefreshTeamScorllDatas(outDatas)
      ReusableTable.DestroyAndClearArray(outDatas)
      self.curProfessionId = self.goal
    else
      local combine = parama.combine
      if combine == self.combineGoal then
        if not isNotPlayAnim then
          combine:PlayReverseAnimation()
        end
        return
      end
      self:_resetCurCombine()
      self.combineGoal = combine
      self.combineGoal:PlayReverseAnimation()
      self.fatherGoalId = combine.data.fatherGoal.id
      self.goal = self.fatherGoalId
    end
  elseif parama.child and parama.child.data then
    self.goal = parama.child.data.id
    local typeBranch = parama.child.data.TypeBranch
    local recommendLevel, recommendMode = self.curLevelId, self.curModeId
    local outDatas = ReusableTable.CreateArray()
    self:GetRightDatas(outDatas, typeBranch, recommendLevel, recommendMode)
    self:RefreshTeamScorllDatas(outDatas)
    ReusableTable.DestroyAndClearArray(outDatas)
    self.curProfessionId = self.goal
    local goalCells = self.goalListCtl:GetCells()
    local count, childCtls = #goalCells
    for i = 1, count do
      childCtls = goalCells[i].childCtl:GetCells()
      for k = 1, #childCtls do
        childCtls[k]:SetChoose(childCtls[k].data.id == parama.child.data.id)
      end
    end
  else
    self.goal = self.fatherGoalId
  end
  if parama then
    self.clickParama = parama
  end
  self:ActiveGoTo(self.curProfessionId == MyselfProxy.Instance:GetMyProfession())
end

function EquipRecommendMainNew:RefreshTeamScorllDatas(datas)
  self.teamListCtl:ResetDatas(datas)
  self:UpdateUI()
  local cells = self.teamListCtl:GetCells()
  for k, v in pairs(cells) do
    v:ChangeScrollViewDepth(self.TeamScroll_UIPanel.depth + 1)
    local cellCtrl = v:Get_EquipRecommendGrid_UIGridListCtrl()
    local e_cells = cellCtrl:GetCells()
    for m, n in pairs(e_cells) do
      n:CanDrag(false)
    end
  end
end

function EquipRecommendMainNew:ResetTeamMembers()
  local cells = self.teamListCtl:GetCells()
  if cells then
    for i = 1, #cells do
      self:Hide(cells[i].listGrid)
    end
    self.teamListCtl:Layout()
  end
end

function EquipRecommendMainNew:HandleApplyCt()
  local cells = self.teamListCtl:GetCells()
  for i = 1, #cells do
    local ctDate = TeamProxy.Instance:GetUserApply(cells[i].data.id)
    cells[i]:CountDown(ctDate)
  end
end

function EquipRecommendMainNew:AddViewEvts()
end

function EquipRecommendMainNew:SelfShow()
  self.gameObject:SetActive(true)
  self:InitView()
end

function EquipRecommendMainNew:initData()
end

function EquipRecommendMainNew:SelfHide()
  self.gameObject:SetActive(false)
end

function EquipRecommendMainNew:ActiveGoTo(active)
  self.gotoRoot:SetActive(active)
  local pos = self.TeamScroll_UIPanel.gameObject.transform.localPosition
  local clipOffset = self.TeamScroll_UIPanel.clipOffset
  local baseClipRegion = self.TeamScroll_UIPanel.baseClipRegion
  self.TeamScroll_UIPanel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, active and -39 or 0, pos.z)
  self.TeamScroll_UIPanel.clipOffset = LuaGeometry.GetTempVector2(clipOffset.x, active and -17 or -37)
  self.TeamScroll_UIPanel.baseClipRegion = LuaGeometry.GetTempVector4(baseClipRegion.x, baseClipRegion.y, baseClipRegion.z, active and 508 or 548)
end
