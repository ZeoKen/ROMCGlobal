autoImport("HouseTypeTabCell")
autoImport("BlueprintRecommendItemData")
autoImport("BlueprintRecommendCell")
HomeBluePrintRecommendPage = class("HomeBluePrintRecommendPage", SubView)
local _Single_Tab_Width = 128
local PopSortArrowTickId = 1
local PopSortType = {
  [1] = ZhString.HomeBluePrint_PopSort_All,
  [2] = ZhString.HomeBluePrint_PopSort_GuildFriend,
  [3] = ZhString.HomeBluePrint_PopSort_Hot,
  [4] = ZhString.HomeBluePrint_PopSort_Official
}
local PopSortIndex = {Official = 4}
local PopSortToAction = {
  [1] = HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_ALL,
  [2] = HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_SOCIAL,
  [3] = HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_HOT,
  [4] = HomeCmd_pb.EPRINTACTION_QUERY
}

function HomeBluePrintRecommendPage:Init()
  self.isInEditMode = HomeManager.Me():IsInEditMode()
  redlog("[HomeBluePrintRecommendPage] isInEditMode=", tostring(self.isInEditMode))
  self:FindObjs()
  self:InitUI()
  self:AddListenEvts()
end

function HomeBluePrintRecommendPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdPrintUpdateHomeCmd, self.OnPrintUpdateHomeCmd)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadFinish, self.OnPhotoDownloadFinish)
end

function HomeBluePrintRecommendPage:OnPrintUpdateHomeCmd(note)
  redlog("[HomeBluePrintRecommendPage:OnPrintUpdateHomeCmd]")
  local data = note and note.body
  if not data then
    return
  end
  local action = data.action
  redlog("[HomeBluePrintRecommendPage:OnPrintUpdateHomeCmd]action=", action)
  if action == HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_ALL or action == HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_SOCIAL or action == HomeCmd_pb.EPRINTACTION_QUERY_RECOMMEND_HOT then
    if self:GetPopSortIndex() ~= PopSortIndex.Official then
      self:RefreshView()
    end
  elseif action == HomeCmd_pb.EPRINTACTION_QUERY then
    if self:GetPopSortIndex() == PopSortIndex.Official then
      self:InvalidateOfficialBlueprintCache()
      self:RefreshView()
    end
  elseif action == HomeCmd_pb.EPRINTACTION_PRAISE or action == HomeCmd_pb.EPRINTACTION_UNPRAISE or action == HomeCmd_pb.EPRINTACTION_COLLECT_IN or action == HomeCmd_pb.EPRINTACTION_COLLECT_OUT then
    if self:GetPopSortIndex() == PopSortIndex.Official then
      self:InvalidateOfficialBlueprintCache()
    end
    self:RefreshView()
  end
end

function HomeBluePrintRecommendPage:OnPhotoDownloadFinish(note)
  local data = note and note.body
  if not data or data.type ~= FunctionPhotoStorage.PhotoType.HomeBlueprint or not data.isThumb then
    return
  end
  local photoId = data.index
  local cells = self.bpRecommendList:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    local cell = cells[i]
    local cellData = cell and cell.data
    if cellData and not cellData.isOfficial and cellData.photoId == photoId and cellData:GetPhotoKey() == data.customParam then
      if data.byte then
        cell:SetPhoto(data.byte)
        break
      end
      cell:ClearPhoto()
      LogUtility.Error(string.format("[HomeBluePrintRecommendPage] Download failed: %s", tostring(data.error)))
      break
    end
  end
end

function HomeBluePrintRecommendPage:FindObjs()
  self.gameObject = self:FindGO("RecommendPage")
  self.tabGrid = self:FindComponent("Tabs", UIGrid)
  self.houseTypeTabList = UIGridListCtrl.new(self.tabGrid, HouseTypeTabCell, "HouseTypeTabCell")
  self.houseTypeTabList:AddEventListener(MouseEvent.MouseClick, self.OnHouseTypeTabClick, self)
  self.tabLine = self:FindComponent("TabLine", UISprite)
  local grid = self:FindComponent("Grid", UIGrid)
  self.bpRecommendList = UIGridListCtrl.new(grid, BlueprintRecommendCell, "BlueprintRecommendCell")
  self.bpRecommendList:AddEventListener(MouseEvent.MouseClick, self.OnBpRecommendCellClick, self)
  self.popSort = self:FindComponent("popSort", UIPopupList)
  EventDelegate.Add(self.popSort.onChange, function()
    self:RequestData()
  end)
  self.popArrow = self:FindComponent("Arrow", UISprite, self.popSort.gameObject)
  for i = 1, #PopSortType do
    self.popSort:AddItem(PopSortType[i])
  end
  self.noneTip = self:FindGO("NoneTip")
  local refreshBtn = self:FindGO("RefreshBtn")
  self:AddClickEvent(refreshBtn, function()
    self:RequestData()
  end)
end

function HomeBluePrintRecommendPage:InitUI()
  local datas = HomeProxy.Instance:GetHouseTypeList()
  self.houseTypeTabList:ResetDatas(datas)
  local cells = self.houseTypeTabList:GetCells()
  for _, c in ipairs(cells) do
    if c.toggle then
      c.toggle.group = 3
    end
  end
  local tabCount = #cells
  self.tabLine.width = _Single_Tab_Width * tabCount + (self.tabGrid.cellWidth - _Single_Tab_Width) * (tabCount - 1)
  self.popSort.value = PopSortType[1]
end

function HomeBluePrintRecommendPage:OnEnter()
  HomeBluePrintRecommendPage.super.OnEnter(self)
  self._popSortArrowSyncOpen = nil
  TimeTickManager.Me():CreateTick(0, 100, self.SyncPopSortArrowWithOpenState, self, PopSortArrowTickId)
end

function HomeBluePrintRecommendPage:OnExit()
  TimeTickManager.Me():ClearTick(self, PopSortArrowTickId)
  self._popSortArrowSyncOpen = nil
  self:SetPopArrowFlipped(false)
  HomeBluePrintRecommendPage.super.OnExit(self)
end

function HomeBluePrintRecommendPage:SyncPopSortArrowWithOpenState()
  if not self.popSort or self:ObjIsNil(self.popSort.gameObject) then
    return
  end
  local open = self.popSort.isOpen
  if open == self._popSortArrowSyncOpen then
    return
  end
  self._popSortArrowSyncOpen = open
  self:SetPopArrowFlipped(open)
end

function HomeBluePrintRecommendPage:SetPopArrowFlipped(flipped)
  if not self.popArrow or self:ObjIsNil(self.popArrow.gameObject) then
    return
  end
  self.popArrow.flip = flipped and 2 or 0
end

function HomeBluePrintRecommendPage:SetHouseType(houseType)
  local cells = self.houseTypeTabList and self.houseTypeTabList:GetCells()
  local targetCell
  if cells then
    for i = 1, #cells do
      local cell = cells[i]
      if cell.data and cell.data.id == houseType then
        targetCell = cell
        break
      end
    end
    targetCell = targetCell or cells[1]
  end
  self.houseType = targetCell and targetCell.data and targetCell.data.id or HomeProxy.HouseType.Home
  if targetCell then
    targetCell:ToggleOn()
  end
end

function HomeBluePrintRecommendPage:OnHouseTypeTabClick(cell)
  if cell.selected then
    self.houseType = cell.data and cell.data.id
    self:RequestData()
  end
end

function HomeBluePrintRecommendPage:GetPopSortIndex()
  local v = self.popSort and self.popSort.value
  if not v then
    return 1
  end
  for i = 1, #PopSortType do
    if PopSortType[i] == v then
      return i
    end
  end
  return 1
end

function HomeBluePrintRecommendPage:GetContextMapIDForOfficial()
  local myHouse = HomeProxy.Instance:GetMyHouseData(self.houseType)
  local mapID = myHouse and myHouse.mapID
  if not mapID then
    local cur = HomeProxy.Instance:GetCurHouseData()
    mapID = cur and cur.mapID
  end
  return mapID
end

function HomeBluePrintRecommendPage:InvalidateOfficialBlueprintCache()
  self._officialBpCacheKey = nil
  self._officialBpCacheList = nil
end

function HomeBluePrintRecommendPage:BuildOfficialBlueprintList()
  local mapID = self:GetContextMapIDForOfficial()
  local serverHouseType = HomeProxy.HouseType2ServerHouseType[self.houseType] or HomeCmd_pb.EHOUSETYPE_PRIVATE
  local cacheKey = string.format("%s_%s_%s", tostring(self.houseType or 0), tostring(mapID or 0), tostring(serverHouseType))
  if self._officialBpCacheKey == cacheKey and self._officialBpCacheList then
    return self._officialBpCacheList
  end
  local list = {}
  if not mapID or not Table_HomeOfficialBluePrint then
    self._officialBpCacheKey = cacheKey
    self._officialBpCacheList = list
    return list
  end
  for _, row in pairs(Table_HomeOfficialBluePrint) do
    if row.MapID == mapID then
      local item = BlueprintRecommendItemData.CreateFromOfficial(row, serverHouseType, #list + 1)
      if item then
        local serverData = HomeBlueprintProxy.Instance:GetOfficialServerData(row.id)
        if serverData then
          item.likeNum = serverData.like_num or 0
          item.isLike = serverData.is_like or false
          item.isCollection = serverData.is_collection or false
        end
        list[#list + 1] = item
      end
    end
  end
  table.sort(list, function(a, b)
    return (a.officialId or 0) < (b.officialId or 0)
  end)
  for i = 1, #list do
    list[i].index = i
  end
  self._officialBpCacheKey = cacheKey
  self._officialBpCacheList = list
  return list
end

function HomeBluePrintRecommendPage:GetCurrentRecommendList()
  if self:GetPopSortIndex() == PopSortIndex.Official then
    return self:BuildOfficialBlueprintList()
  end
  local serverHouseType = HomeProxy.HouseType2ServerHouseType[self.houseType]
  return HomeBlueprintProxy.Instance:GetRecommendList(serverHouseType)
end

function HomeBluePrintRecommendPage:RefreshView()
  local recommendList = self:GetCurrentRecommendList()
  if self.bpRecommendList then
    self.bpRecommendList:ResetDatas(recommendList)
  end
  self.noneTip:SetActive(#recommendList == 0)
end

function HomeBluePrintRecommendPage:OnSwitch(isShow)
  if isShow then
    self:RefreshView()
    self.container.emptyTip.text = ""
  end
end

function HomeBluePrintRecommendPage:RequestData()
  local sortIndex = self:GetPopSortIndex()
  local action = PopSortToAction[sortIndex]
  if not action then
    return
  end
  local serverHouseType = HomeProxy.HouseType2ServerHouseType[self.houseType] or HomeCmd_pb.EHOUSETYPE_PRIVATE
  ServiceHomeCmdProxy.Instance:CallPrintActionHomeCmd(action, {etype = serverHouseType})
end

function HomeBluePrintRecommendPage:OnBpRecommendCellClick(cell)
  if not cell or not cell.data then
    return
  end
  self.container:ApplyBlueprintFromCell(cell.data)
end
