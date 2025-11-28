autoImport("DeComposeView")
EquipMemoryDecomposeView = class("EquipMemoryDecomposeView", DeComposeView)
autoImport("EquipMemoryCombineView")
EquipMemoryDecomposeView.BrotherView = EquipMemoryCombineView
autoImport("EquipMemoryItemCell")

function EquipMemoryDecomposeView:Init()
  local viewdata = self.viewdata.viewdata
  self.tipData = {}
  self:InitUI()
  self:MapEvent()
  self.chosenMap = {}
end

function EquipMemoryDecomposeView:InitUI()
  self.decomposeBord = self:FindGO("DecomposeBord")
  self.helpBtn = self:FindGO("HelpButton")
  self.resultScrollView = self:FindGO("ResultScrollView"):GetComponent(UIScrollView)
  self.resultGrid = self:FindComponent("ResultGrid", UIGrid)
  self.resultCtl = UIGridListCtrl.new(self.resultGrid, DecomposeItemCell, "DecomposeItemCell")
  self.resultCtl:AddEventListener(MouseEvent.MouseClick, self.clickResultCell, self)
  self.businessTip = self:FindGO("BusinessTip")
  self.businessTip_1 = self:FindComponent("Tip1", UILabel)
  self.businessTip_2 = self:FindComponent("Tip2", UILabel)
  self.noMaterialTip = self:FindGO("NoMaterialTip")
  self.cost = self:FindComponent("Cost", UILabel)
  self.cost.text = 0
  self.cost.gameObject:SetActive(false)
  local l_zenyIcon = self:FindComponent("Sprite", UISprite, self.cost.gameObject)
  IconManager:SetItemIcon(Table_Item[100].Icon, l_zenyIcon)
  local coins = self:FindChild("TopCoins")
  self.userRob = self:FindChild("Silver", coins)
  self.robLabel = self:FindComponent("Label", UILabel, self.userRob)
  local symbol = self:FindComponent("symbol", UISprite, self.userRob)
  IconManager:SetItemIcon(Table_Item[GameConfig.MoneyId.Zeny].Icon, symbol)
  self.bg = self:FindComponent("Bg", UISprite)
  self.waittingSymbol = self:FindGO("WaittingSymbol")
  self.addbord = self:FindGO("AddBord")
  self:InitTipLabels()
  self.colliderMask = self:FindGO("ColliderMask")
  self.startBtn = self:FindGO("StartButton")
  self.startBtn_BoxCollider = self.startBtn:GetComponent(BoxCollider)
  self:AddButtonEvent("StartButton", function(go)
    return self:StartDeCompose()
  end)
  self.decomposeBord:SetActive(true)
  self.chosenScrollView = self:FindGO("ChoosenPanel"):GetComponent(UIScrollView)
  local itemContainer = self:FindGO("ChoosenEquipWrap")
  self.chooseCtl = WrapListCtrl.new(itemContainer, EquipMemoryItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 5, 95)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.HandleRemoveChosen, self)
  self.chooseCtl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  self.emptyChosenTip = self:FindGO("EmptyChosenTip")
  self.chooseMemorys = {}
  local chooseContainer = self:FindGO("ChooseContainer")
  local chooseBordGO = self:LoadPreferb("part/EquipMemoryDecomposeChooseBord", chooseContainer)
  self.chooseScrollView = self:FindGO("ScrollView", chooseBordGO):GetComponent(UIScrollView)
  local wrapContainer = self:FindGO("Container", chooseBordGO)
  self.memoryListCtrl = WrapListCtrl.new(wrapContainer, EquipMemoryItemCell, "BagItemCell", WrapListCtrl_Dir.Vertical, 5, 95)
  self.memoryListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMemoryCell, self)
  self.memoryListCtrl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  self.chooseAllBtn = self:FindGO("ChooseAllBtn", chooseBordGO)
  local rightBord = self:FindGO("RightBord")
  self.autoDecomposeSetBtn = self:FindGO("AutoDecomposeSetBtn", rightBord)
  self:AddClickEvent(self.chooseAllBtn, function()
    self:HandleChooseAll()
  end)
  self:AddClickEvent(self.autoDecomposeSetBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipMemoryAutoDecomposePopup
    })
  end)
  self.filter = self:FindGO("Filter"):GetComponent(UIPopupList)
  EventDelegate.Add(self.filter.onChange, function()
    if self.filter.data == nil then
      return
    end
    if self.filterData ~= self.filter.data then
      self.filterData = self.filter.data
      self:UpdateChooseBord()
    end
  end)
  self:InitFilter()
end

function EquipMemoryDecomposeView:MapEvent()
  EquipMemoryDecomposeView.super.MapEvent(self)
  self:AddListenEvt(ServiceEvent.ItemMemoryDecomposeItemCmd, self.HandleDecomposeSuccess, self)
  self:AddListenEvt(ItemEvent.MemoryUpdate, self.HandleItemUpdate, self)
end

local QualityFilter = {
  [0] = "全部",
  [1] = "白色",
  [2] = "绿色",
  [3] = "蓝色",
  [4] = "紫色",
  [5] = "金色"
}

function EquipMemoryDecomposeView:InitFilter()
  self.filter:Clear()
  local decomposeFilter = GameConfig.EquipMemory and GameConfig.EquipMemory.Quality or QualityFilter
  local _tempFilter = {}
  for k, v in pairs(decomposeFilter) do
    local _tempData = {name = v, index = k}
    table.insert(_tempFilter, _tempData)
  end
  table.sort(_tempFilter, function(l, r)
    return l.index < r.index
  end)
  for i = 1, #_tempFilter do
    self.filter:AddItem(_tempFilter[i].name, _tempFilter[i].index)
  end
  local range = 0
  self.filterData = range
  local rangeData = decomposeFilter[range]
  self.filter.value = rangeData
end

function EquipMemoryDecomposeView:UpdateChooseBord()
  local equipdatas = self:GetEquipMemoryList()
  for i = 1, #equipdatas do
    if self.chosenMap[equipdatas[i].id] then
      equipdatas[i].isMark = true
    end
  end
  self.memoryListCtrl:ResetDatas(equipdatas)
end

function EquipMemoryDecomposeView:HandleChooseAll()
  xdlog("HandleChooseAll")
  local equipdatas = self:GetEquipMemoryList()
  for i = 1, #equipdatas do
    equipdatas[i].isMark = true
    if not self.chosenMap[equipdatas[i].id] then
      self.chosenMap[equipdatas[i].id] = {
        level = equipdatas[i].equipMemoryData.level,
        quality = Table_Item[equipdatas[i].staticData.id].Quality or 2,
        highValue = equipdatas[i].equipMemoryData:IsHighValue()
      }
    end
  end
  local cells = self.memoryListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateCheckMark()
  end
  self:UpdateChooseBord()
  self:DecomposePreview()
end

function EquipMemoryDecomposeView:UpdateFuncBtns()
end

function EquipMemoryDecomposeView:UpdateChooseAllBtn()
end

function EquipMemoryDecomposeView:InitTipLabels()
  local addTipLab = self:FindComponent("TipLabel", UILabel, self.addbord)
  addTipLab.gameObject:SetActive(false)
end

function EquipMemoryDecomposeView:HandleRemoveChosen(cellCtrl)
  if self.longPressEventDispatched then
    return
  end
  local itemData = cellCtrl.data
  if not itemData then
    return
  end
  self.clickEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    self.clickEventDispatched = nil
  end, self)
  xdlog("itemData", itemData.id)
  if self.chosenMap[itemData.id] then
    redlog("移除选择")
    self.chosenMap[itemData.id] = nil
  end
  self:UpdateChooseBord()
  self:DecomposePreview()
end

function EquipMemoryDecomposeView:GetEquipMemoryList()
  local items = BagProxy.Instance.memoryBagData and BagProxy.Instance.memoryBagData:GetItems()
  local filterQuality = self.filterData or 0
  local decomposeFilter = GameConfig.EquipMemory and GameConfig.EquipMemory.Quality
  xdlog("获取对应记忆列表", filterQuality)
  local result = {}
  for i = 1, #items do
    local quality = items[i].memoryData.Quality
    local qualityValid = decomposeFilter and decomposeFilter[quality] and (filterQuality == 0 or quality == filterQuality)
    if qualityValid and not BagProxy.Instance:CheckIsFavorite(items[i]) then
      local single = items[i]:Clone()
      table.insert(result, single)
    end
  end
  return result
end

function EquipMemoryDecomposeView:GetChosenMemories()
end

function EquipMemoryDecomposeView:DecomposePreview()
  local result = {}
  local levelConfig = Table_ItemMemoryLevel
  if not levelConfig then
    redlog("缺表Table_ItemMemoryLevel")
  end
  local itemList = {}
  local chosenList = {}
  for guid, info in pairs(self.chosenMap) do
    local level = info.level
    if level and levelConfig[level] then
      local decomposeItem = levelConfig[level].DecomposeItem and levelConfig[level].DecomposeItem[info.quality]
      if decomposeItem and 0 < #decomposeItem then
        for i = 1, #decomposeItem do
          local itemId = decomposeItem[i][1]
          local count = decomposeItem[i][2]
          if not itemList[itemId] then
            itemList[itemId] = count
          else
            itemList[itemId] = itemList[itemId] + count
          end
        end
      end
    end
    local item = BagProxy.Instance:GetItemByGuid(guid)
    if item then
      table.insert(chosenList, item)
    end
  end
  for itemId, count in pairs(itemList) do
    local itemData = ItemData.new("Decompose", itemId)
    itemData.num = count
    table.insert(result, itemData)
  end
  self.resultCtl:ResetDatas(result)
  if 5 <= #result then
    self.resultScrollView.contentPivot = UIWidget.Pivot.Left
  else
    self.resultScrollView.contentPivot = UIWidget.Pivot.Center
  end
  self.resultScrollView:ResetPosition()
  self.chooseCtl:ResetDatas(chosenList)
  self.chosenScrollView:ResetPosition()
  self.noMaterialTip:SetActive(#result == 0)
  self.emptyChosenTip:SetActive(#chosenList == 0)
  if #result == 0 then
    self:SetTextureGrey(self.startBtn)
    self.startBtn_BoxCollider.enabled = false
  else
    self:SetTextureWhite(self.startBtn, ColorUtil.ButtonLabelBlue)
    self.startBtn_BoxCollider.enabled = true
  end
end

function EquipMemoryDecomposeView:GetGUIDs()
end

function EquipMemoryDecomposeView:StartDeCompose()
  xdlog("推送分解")
  local result = {}
  local hasHighValue = false
  for guid, info in pairs(self.chosenMap) do
    if info.highValue then
      hasHighValue = true
    end
    table.insert(result, guid)
  end
  if 0 < #result then
    if hasHighValue then
      FunctionSecurity.Me():NormalOperation(function()
        MsgManager.ConfirmMsgByID(43541, function()
          ServiceItemProxy.Instance:CallMemoryDecomposeItemCmd(result)
        end)
      end)
    else
      ServiceItemProxy.Instance:CallMemoryDecomposeItemCmd(result)
    end
  end
end

function EquipMemoryDecomposeView:ClickMemoryCell(cell)
  if self.longPressEventDispatched then
    return
  end
  local data = cell.data
  if not data then
    return
  end
  self.clickEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    self.clickEventDispatched = nil
  end, self)
  cell.data.isMark = not cell.data.isMark
  cell:UpdateCheckMark()
  if cell.data.isMark then
    self.chosenMap[cell.data.id] = {
      level = cell.data.equipMemoryData.level,
      quality = Table_Item[cell.data.staticData.id].Quality or 2,
      highValue = cell.data.equipMemoryData:IsHighValue()
    }
  else
    self.chosenMap[cell.data.id] = nil
  end
  self:DecomposePreview()
end

function EquipMemoryDecomposeView:OnSelectLongPress(cell)
  if self.clickEventDispatched then
    return
  end
  self.longPressEventDispatched = true
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self.longPressEventDispatched = nil
  end, self)
  local data = cell.data
  if not data then
    return
  end
  if data then
    local itemTip = self:ShowItemTip(data)
    local tipCell = itemTip:GetCell(1)
    tipCell:AddTipFunc(self.chosenMap[data.id] ~= nil and ZhString.Push_cancelButtonTitle or ZhString.Gem_AppraiseSelectBtnName, function(param, num)
      self:ClickMemoryCell(cell)
    end)
  end
end

function EquipMemoryDecomposeView:HandleDecomposeSuccess()
  xdlog("分解成功")
  TableUtility.TableClear(self.chosenMap)
  self:UpdateChooseBord()
  self:DecomposePreview()
end

function EquipMemoryDecomposeView:OnEnter()
  EquipMemoryDecomposeView.super.OnEnter(self)
  if self.npcdata then
    local rootTrans = self.npcdata.assetRole.completeTransform
    self:CameraFocusAndRotateTo(rootTrans, CameraConfig.SwingMachine_ViewPort, CameraConfig.SwingMachine_Rotation)
  else
    self:CameraFocusToMe()
  end
  self:UpdateCoins()
  self:UpdateChooseBord()
  self:DecomposePreview()
end

function EquipMemoryDecomposeView:HandleItemUpdate()
  self:UpdateChooseBord()
  self:DecomposePreview()
end
