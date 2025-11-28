autoImport("ComodoBuildingSendAreaCell")
autoImport("ComodoBuildingSendAreaFeatureCell")
autoImport("ComodoBuildingSendItemCell")
ComodoBuildingSendPage = class("ComodoBuildingSendPage", ComodoBuildingSubPage)
local bgName = "Disney_yhqd_bg_03"
local panelNameList = {
  "DetailPanel",
  "RewardScrollView",
  "DetailSelectPanel",
  "SelectScrollView"
}
local tickManager

function ComodoBuildingSendPage:InitPage()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  ComodoBuildingSendPage.super.InitPage(self)
  self.bgTex = self:FindComponent("SendBg", UITexture)
  self.timesLabel1 = self:FindComponent("TimesLabel1", UILabel)
  self.timesLabel2 = self:FindComponent("TimesLabel2", UILabel)
  self:AddButtonEvent("SendBg", function()
    self:ChooseCell(0)
  end)
  self:InitAreaCells()
  self:InitDetailPanel()
  self:InitDetailSelectPanel()
end

function ComodoBuildingSendPage:InitAreaCells()
  self.cells = {}
  for i = 1, #Table_ManorAreaReward do
    self.cells[i] = ComodoBuildingSendAreaCell.new(self:FindGO("Cell" .. i), i)
    self:AddClickEvent(self.cells[i].gameObject, function()
      self:OnClickCell(i)
    end)
  end
end

function ComodoBuildingSendPage:InitDetailPanel()
  self.detailParent = self:FindGO("DetailPanel")
  self.detailPanel = self.detailParent:GetComponent(UIPanel)
  self.detailTitle = self:FindComponent("DetailTitle", UILabel)
  self.countdownLabel = self:FindComponent("CountdownLabel", UILabel)
  self.petAdd = self:FindGO("PetAdd")
  self.petData = {}
  self.petCell = ComodoBuildingSendItemCell.new(self:FindGO("PetCell", self.detailParent))
  self.equipAdd = self:FindGO("EquipAdd")
  self.equipData = {}
  self.equipCell = ComodoBuildingSendItemCell.new(self:FindGO("EquipCell", self.detailParent))
  self.sendBtn = self:FindGO("SendBtn")
  self.sentBtn = self:FindGO("SentBtn")
  self.recvBtn = self:FindGO("RecvBtn")
  self.costCfg = GameConfig.Manor.ManorDispatchItemCost[1]
  self.costNumLabel = self:FindComponent("CostNum", UILabel)
  self.costNumLabel.text = self.costCfg[2]
  self.costIcon = self:FindComponent("CostIcon", UISprite)
  IconManager:SetItemIcon(Table_Item[self.costCfg[1]].Icon, self.costIcon)
  self.featureCtrl = ListCtrl.new(self:FindComponent("FeatureGrid", UIGrid), ComodoBuildingSendAreaFeatureCell, "ComodoBuildingSendAreaFeatureCell")
  self.rewardCtrl = ListCtrl.new(self:FindComponent("RewardGrid", UIGrid), ComodoBuildingSendItemCell, "ComodoBuildingSendItemCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardIcon, self)
  self:AddButtonEvent("DetailCloseBtn", function()
    self.detailParent:SetActive(false)
  end)
  self:AddButtonEvent("PetBg", function()
    self:TrySelectPet()
  end)
  self:AddButtonEvent("EquipBg", function()
    self:TrySelectEquip()
  end)
  self:AddClickEvent(self.sendBtn, function()
    self:DoSend()
  end)
  self:AddClickEvent(self.recvBtn, function()
    self:DoRecv()
  end)
end

function ComodoBuildingSendPage:InitDetailSelectPanel()
  self.detailSelectParent = self:FindGO("DetailSelectPanel")
  self.detailSelectPanel = self.detailSelectParent:GetComponent(UIPanel)
  self.detailSelectTitle = self:FindComponent("DetailSelectTitle", UILabel)
  self.detailSelectNoneTip = self:FindGO("DetailSelectNoneTip")
  self.detailSelectNoneTipLabel = self:FindComponent("DetailSelectNoneTipLabel", UILabel)
  self.detailSelectFakeSelectBtn = self:FindGO("FakeSelectBtn")
  self.detailSelectSelectBtn = self:FindGO("SelectBtn")
  self.selectCtrl = ListCtrl.new(self:FindComponent("SelectTable", UITable), ComodoBuildingSendItemCell, "ComodoBuildingSendItemCell")
  self.selectCtrl:AddEventListener(MouseEvent.MouseClick, self.OnSelect, self)
  self.selectCtrl:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  self.selectCtrlCells = self.selectCtrl:GetCells()
  self:AddButtonEvent("DetailSelectCloseBtn", function()
    TipManager.CloseTip()
    self.detailSelectParent:SetActive(false)
  end)
  self:AddClickEvent(self.detailSelectSelectBtn, function()
    TipManager.CloseTip()
    self.detailSelectParent:SetActive(false)
    local id = self.selectCellId
    if not id then
      return
    end
    if Table_Item[id] then
      self:SetDetailEquip(id)
      self:SetDetailPet(self.petData.id)
    else
      self:SetDetailPet(id)
      self:SetDetailEquip(self.equipData.id)
    end
    self:UpdateRewards()
  end)
end

function ComodoBuildingSendPage:AddEvents()
  ComodoBuildingSendPage.super.AddEvents(self)
  self:AddListenEvt(ServiceEvent.SceneManorBuildDispatchManorCmd, self.OnSend)
  self:AddListenEvt(ServiceEvent.SceneManorPartnerInfoManorCmd, self.OnSend)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateTimesLabel)
end

function ComodoBuildingSendPage:OnEnter()
  ComodoBuildingSendPage.super.OnEnter(self)
  PictureManager.Instance:SetUI(bgName, self.bgTex)
  local containerDepth, panel = self.container.panel.depth
  for i = 1, #panelNameList do
    panel = self:FindComponent(panelNameList[i], UIPanel)
    if panel then
      panel.depth = containerDepth + 10 + i
    end
  end
  self.tipData.ignoreBounds = {
    self.rewardCtrl.layoutCtrl.gameObject,
    self.selectCtrl.layoutCtrl.gameObject
  }
  ServiceSceneManorProxy.Instance:CallPartnerInfoManorCmd()
end

function ComodoBuildingSendPage:OnExit()
  tickManager:ClearTick(self)
  PictureManager.Instance:UnLoadUI(bgName, self.bgTex)
  ComodoBuildingSendPage.super.OnExit(self)
end

function ComodoBuildingSendPage:OnActivate()
  ComodoBuildingSendPage.super.OnActivate(self)
  self:OnSend()
end

function ComodoBuildingSendPage:OnClickCell(id)
  self:ChooseCell(id)
  if self.cells[id].state ~= ComodoBuildingSendAreaCellState.Locked then
    self:OpenDetailPanel(id)
  end
end

local tipOffset = {-210, 0}

function ComodoBuildingSendPage:OnClickRewardIcon(cell)
  self.rewardItemData = self.rewardItemData or ItemData.new()
  self.rewardItemData:ResetData("Tip", cell.id)
  self:ShowItemTip(self.rewardItemData, cell.icon, NGUIUtil.AnchorSide.Left, tipOffset)
end

function ComodoBuildingSendPage:OnSelect(cell)
  if not cell then
    return
  end
  self:SetDetailSelectId(cell.id)
end

function ComodoBuildingSendPage:OnSelectLongPress(param)
  local isPressing, cell = param[1], param[2]
  if not cell then
    return
  end
  if Table_Item[cell.id] then
    if isPressing then
      self:OnClickRewardIcon(cell)
    end
  elseif isPressing then
    TipManager.Instance:TryShowVerticalComodoBuildingSendNameTip(cell.id, cell.icon)
  else
    TipManager.Instance:CloseTabNameTipWithFadeOut()
  end
end

function ComodoBuildingSendPage:OnItemUpdate()
  self:UpdatePrice()
end

function ComodoBuildingSendPage:OnQuery()
  self:OnSend()
end

function ComodoBuildingSendPage:OnLevelUp()
  self:OnSend()
end

function ComodoBuildingSendPage:OnSend()
  self:UpdateAreaCells()
  self:UpdateTimesLabel()
  if self.detailParent.activeSelf then
    self:UpdateDetailPanel()
  end
  ComodoBuildingProxy.RefreshFurniture()
end

function ComodoBuildingSendPage:UpdateAreaCells()
  local cell, countdown
  for _, d in pairs(Table_ManorAreaReward) do
    cell = self.cells[d.id]
    if cell then
      countdown = self.proxyIns:GetDispatchCountdownByAreaId(d.id)
      if countdown < 0 then
        cell:SwitchToState(self.proxyIns.unlockedDispatchAreaIdMap[d.id] and ComodoBuildingSendAreaCellState.Normal or ComodoBuildingSendAreaCellState.Locked)
      elseif countdown == 0 then
        cell:SwitchToState(ComodoBuildingSendAreaCellState.Complete)
      elseif 0 < countdown then
        cell:SwitchToState(ComodoBuildingSendAreaCellState.Sent)
      end
    end
  end
end

function ComodoBuildingSendPage:UpdateTimesLabel()
  local finishedTimes, maxTimes = self.proxyIns:GetFinishedDispatchTimesOfToday(), self.proxyIns:GetUnlockedMaxDispatchTimes(self.buildingId)
  self.timesLabel1.text = maxTimes - finishedTimes
  self.timesLabel2.text = string.format("/%s", maxTimes)
end

function ComodoBuildingSendPage:OpenDetailPanel(id)
  self.detailParent:SetActive(true)
  self:UpdateDetailPanel(id)
end

function ComodoBuildingSendPage:UpdateDetailPanel(id)
  id = id or self.showingAreaId
  local sData = Table_ManorAreaReward[id]
  if not sData then
    LogUtility.WarningFormat("Cannot find static data of manor area with id = {0}", id)
    return
  end
  self.showingAreaId = id
  self.detailTitle.text = sData.Desc
  self.featureCtrl:ResetDatas(sData.Features or _EmptyTable)
  if not self.countdownTick then
    self.countdownTick = tickManager:CreateTick(0, 300, self.UpdateByTick, self, 9)
  end
  local dispatch = self.proxyIns:GetDispatchDataByAreaId(id)
  self:SetDetailPet(dispatch and dispatch.petId)
  self:SetDetailEquip(dispatch and dispatch.equipId)
  self:UpdateRewards(true)
  self:UpdateCountdown()
  self:UpdateDetailBtn()
  self:OnItemUpdate()
  TipManager.CloseTip()
  self.detailSelectParent:SetActive(false)
end

function ComodoBuildingSendPage:UpdateByTick()
  self:UpdateAreaCells()
  self:UpdateCountdown()
  self:UpdateDetailBtn()
end

function ComodoBuildingSendPage:UpdateCountdown()
  local c = self.proxyIns:GetDispatchCountdownByAreaId(self.showingAreaId)
  if c < 0 then
    c = GameConfig.Manor.ManorDispatchInterval
  end
  self.countdownLabel.text = self:MakeTimeStr(c)
end

function ComodoBuildingSendPage:SetDetailPet(id)
  self.petData.id = id
  self.petAdd:SetActive(id == nil)
  self.petData.hasStar = self:StarPetPredicate(id)
  self.petCell:SetData(self.petData)
end

function ComodoBuildingSendPage:SetDetailEquip(id)
  self.equipData.id = id
  self.equipAdd:SetActive(id == nil)
  self.equipData.hasStar = self:StarEquipPredicate(id)
  self.equipCell:SetData(self.equipData)
end

function ComodoBuildingSendPage:SetDetailSelectId(id)
  self.selectCellId = id
  local hasSelected = false
  for _, c in pairs(self.selectCtrlCells) do
    c:SetChooseId(id)
    hasSelected = hasSelected or c.id == id
  end
  self.detailSelectFakeSelectBtn:SetActive(not hasSelected)
  self.detailSelectSelectBtn:SetActive(hasSelected)
end

local addReusableSendItem = function(arr, id, grey, hasStar, got)
  local t = ReusableTable.CreateTable()
  t.id = id
  t.grey = grey and true or nil
  t.hasStar = hasStar and true or nil
  t.got = got and true or nil
  TableUtility.ArrayPushBack(arr, t)
end
local tryAddUniqueReusableSendItemsByRewardTeamId = function(arr, addedItemIdMap, teamId)
  local reward, id = ItemUtil.GetRewardItemIdsByTeamId(teamId)
  for i = 1, #reward do
    id = reward[i].id
    if not addedItemIdMap[id] then
      addReusableSendItem(arr, id)
      addedItemIdMap[id] = true
    end
  end
end

function ComodoBuildingSendPage:UpdateRewards(resetPosition)
  if not self.showingAreaId then
    LogUtility.Warning("Cannot find self.showingAreaId. Rewards update failed.")
    return
  end
  local arr, addedItemIdMap = ReusableTable.CreateArray(), ReusableTable.CreateTable()
  local pId, eId = self.petData.id, self.equipData.id
  if pId and eId then
    for _, data in pairs(Table_ManorSpecialReward) do
      if data.PetId == pId and data.EquipId == eId then
        local reachLimit, id = self.proxyIns:GetAreaSpecialRewardReceiveCount(data.id) >= data.Limit
        for i = 1, #data.ItemReward do
          id = data.ItemReward[i][1]
          addReusableSendItem(arr, id, reachLimit, not reachLimit, reachLimit)
          addedItemIdMap[id] = true
        end
        break
      end
    end
  end
  local areaRewardData, list = Table_ManorAreaReward[self.showingAreaId]
  if pId then
    list = areaRewardData.PetReward
    for i = 1, #list do
      if list[i][1] == pId then
        tryAddUniqueReusableSendItemsByRewardTeamId(arr, addedItemIdMap, list[i][2])
      end
    end
  end
  if eId then
    list = areaRewardData.EquipReward
    for i = 1, #list do
      if list[i][1] == eId then
        tryAddUniqueReusableSendItemsByRewardTeamId(arr, addedItemIdMap, list[i][2])
      end
    end
  end
  list = areaRewardData.BaseReward
  for i = 1, #list do
    tryAddUniqueReusableSendItemsByRewardTeamId(arr, addedItemIdMap, list[i])
  end
  self.rewardCtrl:ResetDatas(arr)
  if resetPosition then
    self.rewardCtrl:ResetPosition()
  end
  for _, t in pairs(arr) do
    ReusableTable.DestroyAndClearTable(t)
  end
  ReusableTable.DestroyAndClearArray(arr)
  ReusableTable.DestroyAndClearTable(addedItemIdMap)
end

function ComodoBuildingSendPage:UpdateDetailBtn()
  local c = self.proxyIns:GetDispatchCountdownByAreaId(self.showingAreaId)
  self.sendBtn:SetActive(c < 0)
  self.sentBtn:SetActive(0 < c)
  self.recvBtn:SetActive(c == 0)
end

local labelEnoughColor, labelNotEnoughColor = LuaColor.New(0.7686274509803922, 0.5254901960784314, 0), LuaColor.New(1, 0.3764705882352941, 0.12941176470588237)

function ComodoBuildingSendPage:UpdatePrice()
  self.costNumLabel.color = self:CheckCost() and LuaGeometry.GetTempColor() or labelNotEnoughColor
  self.costNumLabel.effectColor = self:CheckCost() and labelEnoughColor or LuaGeometry.GetTempColor()
end

function ComodoBuildingSendPage:TrySelectPet()
  if self.proxyIns:GetDispatchCountdownByAreaId(self.showingAreaId) >= 0 then
    return
  end
  self:UpdateDetailSelect("SelectPetTitle", self.proxyIns:GetAvailableDispatchPartnerIdMap(), "SelectPetNoneTip", self.StarPetPredicate, 0)
  self:SetDetailSelectId(self.petData.id)
end

function ComodoBuildingSendPage:TrySelectEquip()
  if self.proxyIns:GetDispatchCountdownByAreaId(self.showingAreaId) >= 0 then
    return
  end
  self:UpdateDetailSelect("SelectEquipTitle", self.proxyIns:GetAvailableDispatchEquipIdMap(), "SelectEquipNoneTip", self.StarEquipPredicate, 0.8)
  self:SetDetailSelectId(self.equipData.id)
end

function ComodoBuildingSendPage:StarPetPredicate(pId)
  local areas = self.proxyIns.partnerFavoredAreasMap[pId]
  return areas and TableUtility.ArrayFindIndex(areas, self.showingAreaId) > 0 or false
end

function ComodoBuildingSendPage:StarEquipPredicate(eId)
  local pId = self.petData.id
  local favoredEquip = pId and self.proxyIns.partnerFavoredEquipMap[pId]
  if favoredEquip == eId then
    for _, data in pairs(Table_ManorSpecialReward) do
      if data.PetId == pId and data.EquipId == eId then
        return self.proxyIns:GetAreaSpecialRewardReceiveCount(data.id) < data.Limit
      end
    end
  end
  return false
end

local sortFunc = function(l, r)
  local lStar, rStar = l.hasStar and 1 or 0, r.hasStar and 1 or 0
  if lStar ~= rStar then
    return lStar > rStar
  end
  return l.id < r.id
end

function ComodoBuildingSendPage:UpdateDetailSelect(titleKeySuffix, map, noneTipTextKeySuffix, starPredicate, longPressTime)
  self.detailSelectParent:SetActive(true)
  self.detailSelectTitle.text = ZhString["ComodoBuilding_" .. titleKeySuffix]
  self.detailSelectNoneTipLabel.text = noneTipTextKeySuffix and ZhString["ComodoBuilding_" .. noneTipTextKeySuffix] or ""
  local arr = ReusableTable.CreateArray()
  for id, _ in pairs(map) do
    addReusableSendItem(arr, id, nil, starPredicate and starPredicate(self, id))
  end
  table.sort(arr, sortFunc)
  self.detailSelectNoneTip:SetActive(#arr == 0)
  self.selectCtrl:ResetDatas(arr)
  for _, c in pairs(self.selectCtrlCells) do
    c:SetLongPressTime(longPressTime)
  end
  tickManager:CreateOnceDelayTick(16, function(self)
    self.selectCtrl:ResetPosition()
    self.selectCtrl.layoutCtrl:Reposition()
  end, self)
  for _, t in pairs(arr) do
    ReusableTable.DestroyAndClearTable(t)
  end
  ReusableTable.DestroyAndClearArray(arr)
end

function ComodoBuildingSendPage:DoSend()
  local finishedTimes, maxTimes = self.proxyIns:GetFinishedDispatchTimesOfToday(), self.proxyIns:GetUnlockedMaxDispatchTimes(self.buildingId)
  if finishedTimes >= maxTimes then
    MsgManager.ShowMsgByID(41500)
    return
  end
  if self.proxyIns:CheckBuildingForbid(self.buildingId) then
    MsgManager.ShowMsgByID(42004)
    return
  end
  if not self.petData.id then
    MsgManager.FloatMsg(nil, ZhString.ComodoBuilding_SelectNonePetTip)
    return
  end
  if not self.equipData.id then
    MsgManager.FloatMsg(nil, ZhString.ComodoBuilding_SelectNoneEquipTip)
    return
  end
  if not self:CheckCost() then
    MsgManager.ShowMsgByIDTable(25418, Table_Item[self.costCfg[1]].NameZh)
    return
  end
  ComodoBuildingProxy.Dispatch(self.petData.id, self.showingAreaId, self.equipData.id)
end

function ComodoBuildingSendPage:DoRecv()
  ComodoBuildingProxy.Dispatch(self.petData.id, self.showingAreaId, self.equipData.id, true)
end

function ComodoBuildingSendPage:ChooseCell(id)
  self.cellChooseId = id
  for _, cell in pairs(self.cells) do
    cell:SetChoose(id)
  end
end

function ComodoBuildingSendPage:MakeTimeStr(time)
  if time < 0 then
    time = 0
  end
  local min = math.floor(time / 60)
  local s = time - min * 60
  return string.format("%02d:%02d", min, s)
end

function ComodoBuildingSendPage:CheckCost()
  return HappyShopProxy.Instance:GetItemNum(self.costCfg[1]) >= self.costCfg[2]
end
