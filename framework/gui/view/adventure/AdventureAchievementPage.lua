AdventureAchievementPage = class("AdventureAchievementPage", SubMediatorView)
autoImport("AdventureResearchCategoryCell")
autoImport("AdventureResearchDescriptionCell")
autoImport("AdventureResearchCombineItemCell")
autoImport("AchievementCategoryCell")
autoImport("AchievementDescriptionCell")
autoImport("AchievementSocialCell")
autoImport("AchievementChangeProCell")
autoImport("AdventureTitleBufferCell")
autoImport("TitleAdventureCombineItemCell")
autoImport("UICycledScrollCtrl")
autoImport("TitleAdventureNewCell")
AdventureAchievementPage.filterId = {
  all = 1,
  complete = 2,
  uncomplete = 3
}
AdventureAchievementPage.tabItems = {
  {
    id = AdventureAchievementPage.filterId.all,
    name = ZhString.AdventureAchievePage_AllAchieve
  },
  {
    id = AdventureAchievementPage.filterId.complete,
    name = ZhString.AdventureAchievePage_Complete
  },
  {
    id = AdventureAchievementPage.filterId.uncomplete,
    name = ZhString.AdventureAchievePage_UnComplete
  }
}
AdventureAchievementPage.SocialIDPair = {
  max_team = 1,
  max_hand = 2,
  max_wheel = 3,
  max_chat = 4,
  max_music = 5,
  max_save = 6,
  max_besave = 7
}
AdventureAchievementPage.SocialID = {
  "max_team",
  "max_hand",
  "max_wheel",
  "max_chat",
  "max_music",
  "max_save",
  "max_besave"
}
AdventureAchievementPage.changePf = {
  bepro_1_time = 1,
  bepro_2_time = 2,
  bepro_3_time = 3,
  bepro_4_time = 4,
  bepro_5_time = 5
}
AdventureAchievementPage.childGroupCellClick = "AdventureAchievementPage_childGroupCellClick"
local tempVector3 = LuaVector3.Zero()
local tempArray = {}

function AdventureAchievementPage:Init()
  self.isInited = false
end

function AdventureAchievementPage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureAchievementPage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:AddViewEvts()
  self:initView()
  self:initTabData()
  local UserName = self:FindComponent("UserName", UILabel)
  UserName.text = Game.Myself.data:GetName()
  self.UserTitle = self:FindComponent("UserTitle", UILabel)
  self.isInited = true
  self:OnEnter()
end

function AdventureAchievementPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.AchieveCmdQueryUserResumeAchCmd, self.QueryUserResumeAchCmd)
  self:AddListenEvt(ServiceEvent.AchieveCmdQueryAchieveDataAchCmd, self.HandleAchieveDataAchCmd)
  self:AddListenEvt(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, self.HandleNewAchieveDataAchCmd)
  self:AddListenEvt(ServiceEvent.QuestQuestUpdate, self.HandleQuestUpdate)
  self:AddListenEvt(ServiceEvent.QuestQuestStepUpdate, self.HandleQuestUpdate)
  self:AddListenEvt(ServiceEvent.UserEventChangeTitle, self.initTitleData)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChangeTitle, self.HandleChangeTitle, self)
end

function AdventureAchievementPage:SubAchieveClickHandle(data)
  self:ShowSubTitleAchieve(self.data.staticData.id, data.id)
end

function AdventureAchievementPage:HandleChangeTitle()
  self:initTitleProp()
end

function AdventureAchievementPage:requestAchieveData()
  ServiceAchieveCmdProxy.Instance:CallQueryUserResumeAchCmd()
end

function AdventureAchievementPage:HandleQuestUpdate()
  self:updateDescList(true)
end

function AdventureAchievementPage:RegistRedTip()
  local cells = self.achivementCategoryGrid:GetCells()
  if not cells or #cells == 0 then
    return
  end
  for i = 1, #cells do
    local singleCell = cells[i]
    local redTipIds = AdventureAchieveProxy.Instance:getCategoryRedtip(singleCell.data.staticData.id)
    if redTipIds then
      for j = 1, #redTipIds do
        self:RegisterRedTipCheck(redTipIds[j], singleCell.bg, nil, {-5, -5})
      end
    end
    local subCells = singleCell:getSubChildCells()
    if subCells and 0 < #subCells then
      for j = 1, #subCells do
        local RedTip = subCells[j].data.staticData.RedTip
        if RedTip then
          self:RegisterRedTipCheck(RedTip, subCells[j].bg, nil, {-5, -5})
        end
      end
    end
  end
end

function AdventureAchievementPage:HandleAchieveDataAchCmd()
  self:initCategoryData()
  if self.data then
    if self.data.staticData.id == AdventureAchieveProxy.HomeCategoryId then
      self:awardTitleProp()
      self:UpdateUserData()
      self:UpdateRecentAchieves()
    else
      self:updateDescList(true)
    end
  end
end

function AdventureAchievementPage:HandleNewAchieveDataAchCmd(note)
  local map = {}
  local dirty = false
  local datas = note.body
  if datas ~= nil then
    local item
    for i = 1, #datas.items do
      item = datas.items[i]
      map[item.id] = 1
      if item.finishtime > 0 then
        dirty = true
      end
    end
  end
  if dirty then
    self:initCategoryData()
    if self.data and self.data.staticData.id == AdventureAchieveProxy.HomeCategoryId then
      self:awardTitleProp()
      self:UpdateUserData()
      self:UpdateRecentAchieves()
    end
  end
  if self.data and self.data.staticData.id ~= AdventureAchieveProxy.HomeCategoryId then
    local bagData = AdventureAchieveProxy.Instance.bagMap[self.data.staticData.id]
    if bagData ~= nil then
      local wrapHelper = self.achieveDesWrapHelper
      if wrapHelper ~= nil then
        local cell, id, item
        local cells = wrapHelper:GetCells()
        for i = 1, #cells do
          cell = cells[i]
          if cell.data ~= nil then
            id = cell.data.staticData.id
            if map[id] ~= nil then
              if self.subGroupData then
                item = bagData:GetItem(self.subGroupData.staticData.id, id)
              else
                item = bagData:GetItem(nil, id)
              end
              cell:SetData(item)
            end
          end
        end
      end
    end
  end
end

function AdventureAchievementPage:initTitleProp(resetPos)
  if not self.PropBord.activeSelf then
    return
  end
  local allTitle = TitleProxy.Instance:GetTitle()
  self.propGridCtrl:ResetDatas(allTitle)
  if resetPos and self.gameObject.activeSelf then
    self.propTable:Reposition()
    self.propScrollView:ResetPosition()
  end
end

function AdventureAchievementPage:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if not datas or #datas == 0 then
    return newData
  end
  for i = 1, #datas do
    local i1 = math.floor((i - 1) / perRowNum) + 1
    local i2 = math.floor((i - 1) % perRowNum) + 1
    newData[i1] = newData[i1] or {}
    if datas[i] == nil then
      newData[i1][i2] = nil
    else
      newData[i1][i2] = datas[i]
    end
  end
  return newData
end

function AdventureAchievementPage:TitleCellClick(cellCtl)
  local data = cellCtl and cellCtl.data
  local go = cellCtl and cellCtl.titleName
  local newChooseID = data and data.id or 0
  TipManager.Instance:HideTitleTip()
  if self.chooseId ~= newChooseID then
    self.chooseId = newChooseID
    self:ShowTitleTip(data, go)
  else
    self.chooseId = 0
  end
  self:_refreshChoose()
end

function AdventureAchievementPage:ShowTitleTip(data, stick)
  local callback = function()
    if not self.destroyed then
      self.chooseId = 0
      self:_refreshChoose()
    end
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds,
    callback = callback
  }
  local tip = TipManager.Instance:ShowTitleTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-255, 0})
end

function AdventureAchievementPage:_refreshChoose()
  local cells = self.propGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(self.chooseId)
  end
end

function AdventureAchievementPage:QueryUserResumeAchCmd()
  self:RefreshHomeData()
end

function AdventureAchievementPage:initTabData()
  self.itemTabs:Clear()
  for i = 1, #AdventureAchievementPage.tabItems do
    local single = AdventureAchievementPage.tabItems[i]
    self.itemTabs:AddItem(single.name, single)
  end
  self.itemTabs.value = AdventureAchievementPage.tabItems[1].name
end

function AdventureAchievementPage:initCategoryData()
  local list = {}
  for k, v in pairs(AdventureAchieveProxy.Instance.categoryDatas) do
    table.insert(list, v)
  end
  table.sort(list, function(l, r)
    return l.staticData.id < r.staticData.id
  end)
  self.achivementCategoryGrid:ResetDatas(list)
  self:RegistRedTip()
end

function AdventureAchievementPage:initTitleData()
  local titleData = Table_Appellation[Game.Myself.data:GetAchievementtitle()]
  if titleData then
    self:Show(self.UserTitle.gameObject)
    self.UserTitle.text = "[" .. titleData.Name .. "]"
  else
    self:Hide(self.UserTitle.gameObject)
  end
end

function AdventureAchievementPage:initData()
  self:initCategoryData()
  self:initTitleData()
end

function AdventureAchievementPage:RefreshListData()
  self:updateDescList()
end

function AdventureAchievementPage:RefreshHomeData()
  self:UpdateHead()
  self:awardTitleProp()
  self:UpdateUserData()
  self:UpdateRecentAchieves()
  self:initTitleProp()
end

function AdventureAchievementPage:updateAchieveTitle()
  local unlock, total = AdventureAchieveProxy.Instance:getTotalAchieveProgress()
  local value = math.floor(unlock / total * 1000) / 10
  self.adventureAchievementTabTitle.text = string.format(ZhString.AdventureAchievePage_AchievementTabTitle, value)
end

function AdventureAchievementPage:initView()
  self.adventureProfileTitle = self:FindGO("AdventureProfileTitle")
  self.categoryScrollView = self:FindComponent("AchievementCategoryScrollView", UIScrollView)
  local categoryGrid = self:FindComponent("AchievementCategoryGrid", UITable)
  self.achivementCategoryGrid = UIGridListCtrl.new(categoryGrid, AchievementCategoryCell, "AchievementCategoryCell")
  self.achivementCategoryGrid:AddEventListener(AdventureAchievementPage.childGroupCellClick, self.childGroupCellClick, self)
  self.achivementCategoryGrid:AddEventListener(MouseEvent.MouseClick, self.categoryCellClick, self)
  local recentAchieveList = self:FindComponent("recentAchieveList", UITable)
  self.recentAchieveListGrid = UIGridListCtrl.new(recentAchieveList, AchievementDescriptionCell, "AchievementDescriptionCell")
  self.recentAchieveListGrid:AddEventListener(MouseEvent.MouseClick, self.recentAchieveDescCellClick, self)
  self.thirdContent = self:FindGO("thirdContent")
  self.fourthContent = self:FindGO("fourthContent")
  self.changeProfessionContent = self:FindGO("changeProfessionContent")
  self.changePfGrid = self:FindComponent("changeProfessionGrid", UIGrid)
  self.changeProfessionGrid = UIGridListCtrl.new(self.changePfGrid, AchievementChangeProCell, "AchievementChangeProCell")
  local SocialInfoGrid = self:FindComponent("SocialInfoGrid", UITable)
  self.SocialInfoGrid = UIGridListCtrl.new(SocialInfoGrid, AchievementSocialCell, "AchievementSocialCell")
  self.emptyContent = self:FindGO("EmptyContent")
  local EmptyContentLabel = self:FindComponent("EmptyContentLabel", UILabel)
  EmptyContentLabel.text = ZhString.AdventureAchievePage_EmptyContentLabel
  self.BornAndToulInfo = self:FindComponent("BornAndToulInfo", UILabel)
  local recentAchiveTitle = self:FindComponent("recentAchiveTitle", UILabel)
  recentAchiveTitle.text = ZhString.AdventureAchievePage_RecentAchiveTitle
  self.totalTourDis = self:FindComponent("totalTourDis", UILabel)
  self.AchievementList = self:FindGO("AchievementList")
  self.AchievementProfileView = self:FindGO("AchievementProfileView")
  self.secondContent = self:FindGO("secondContent")
  self.thirdContent = self:FindGO("thirdContent")
  self.itemTabs = self:FindGO("ItemTabs"):GetComponent(UIPopupList)
  self.ItemTabsBgSelect = self:FindGO("ItemTabsBgSelect"):GetComponent(UISprite)
  EventDelegate.Add(self.itemTabs.onChange, function()
    if self.selectTabData ~= self.itemTabs.data then
      self.selectTabData = self.itemTabs.data
      self:updateDescList()
    end
  end)
  local PropShowBtn = self:FindGO("PropShowBtn")
  self:AddClickEvent(PropShowBtn, function()
    self.PropBord:SetActive(not self.PropBord.activeSelf)
    self:initTitleProp()
  end)
  local PropShowBtnLabel = self:FindComponent("PropShowBtnLabel", UILabel, PropShowBtn)
  PropShowBtnLabel.text = ZhString.AdventureAchievePage_PropShowBtnLabel
  self.AchieveCategorySv = self:FindComponent("AchievementCategoryScrollView", UIScrollView)
  self.AchieveCategoryPanel = self:FindComponent("AchievementCategoryScrollView", UIPanel)
  self.AchieveListSv = self:FindComponent("AchieveListScrollView", UIScrollView)
  self.AchieveListPanel = self:FindComponent("AchieveListScrollView", UIPanel)
  self.AchieveProfileSv = self:FindComponent("AdventureProfileScrollView", UIScrollView)
  self.AchieveProfilePanel = self:FindComponent("AdventureProfileScrollView", UIPanel)
  local awardPropTitle = self:FindComponent("awardPropTitle", UILabel)
  awardPropTitle.text = ZhString.AdventureAchievePage_AwardTitlePropTitle
  self.awardPropAchieveList = self:FindComponent("awardPropAchieveList", UIGrid)
  self.awardPropAchieveList = UIGridListCtrl.new(self.awardPropAchieveList, AdventureTitleBufferCell, "AdventureTitleBufferCell")
  self.PropBord = self:FindGO("PropBord")
  self.PropBordScrollBg = self:FindComponent("PropBordScrollBg", UISprite)
  self.bag_itemContainer = self:FindGO("bag_itemContainer")
  self.achieveDesWrapObj = self:FindGO("achieveDesWrap")
  self:Hide(self.PropBord)
  self.propScrollView = self:FindComponent("propScrollView", UIScrollView)
  self.propTable = self:FindGO("propTable"):GetComponent(UITable)
  self.propGridCtrl = UIGridListCtrl.new(self.propTable, TitleAdventureNewCell, "TitleAdventureNewCell")
  self.propGridCtrl:AddEventListener(MouseEvent.MouseClick, self.TitleCellClick, self)
end

function AdventureAchievementPage:childGroupCellClick(cellCtl)
  if not cellCtl then
    return
  end
  self.itemTabs.value = AdventureAchievementPage.tabItems[1].name
  self.subGroupData = cellCtl.data
  self:updateDescList()
end

function AdventureAchievementPage:recentAchieveDescCellClick(cellCtl)
  local cells = self.recentAchieveListGrid:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local cell = cells[i]
      local data = cell.data
      if data.id == cellCtl.data.id then
        data:setSelected(not data.isSelected)
      else
        data:setSelected(false)
      end
      cell:UpdateSelected()
    end
  end
  self.recentAchieveListGrid:Layout()
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.AchieveProfilePanel.cachedTransform, cellCtl.gameObject.transform)
  local offset = self.AchieveProfilePanel:CalculateConstrainOffset(bound.min, bound.max)
  offset = Vector3(0, offset.y, 0)
  self.AchieveProfileSv:MoveRelative(offset)
end

function AdventureAchievementPage:achieveDescCellClick(cellCtl)
  if not cellCtl or not cellCtl.data then
    return
  end
  self:achieveDescClick(cellCtl.data.id, cellCtl)
end

function AdventureAchievementPage:achieveDescClick(id, cellCtl)
  local datas = self.achieveDesWrapHelper:GetDatas()
  if not datas or #datas == 0 then
    return
  end
  local index = -1
  for i = 1, #datas do
    local data = datas[i]
    if data.id == id then
      index = i
      data:setSelected(not data.isSelected)
    else
      data:setSelected(false)
    end
  end
  local cells = self.achieveDesWrapHelper:GetCells()
  local targetCell
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data then
      cell:UpdateSelected()
      if not targetCell and cell.data.id == id then
        targetCell = cell
      end
    end
  end
  self.achieveDesWrapHelper:Reposition()
  return index
end

function AdventureAchievementPage:ResetEndCellsPosition(cellCtl)
  local cells = self.achieveDesWrapHelper:GetCells()
  local itemSize = self.achieveDesWrapCmp.itemSize
  local cellCtlTransform = cellCtl.gameObject.transform
  local _, posY, _ = LuaGameObject.GetLocalPosition(cellCtlTransform)
  local cellCtlBound = NGUIMath.CalculateRelativeWidgetBounds(cellCtlTransform)
  local lastPositionY = posY - cellCtlBound.size.y - 10
  for i = 1, #cells do
    local cell = cells[i]
    local transform = cell.gameObject.transform
    local x, y, z = LuaGameObject.GetLocalPosition(transform)
    if posY > y then
      local bound = NGUIMath.CalculateRelativeWidgetBounds(transform)
      local height = bound.size.y
      LuaVector3.Better_Set(tempVector3, x, lastPositionY, z)
      transform.localPosition = tempVector3
      lastPositionY = lastPositionY - height - 10
    end
  end
end

function AdventureAchievementPage:categoryCellClick(cellCtl)
  if not cellCtl.isSelected then
    self.itemTabs.value = AdventureAchievementPage.tabItems[1].name
    self:setCategoryData(cellCtl.data)
  end
  local cells = self.achivementCategoryGrid:GetCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local cell = cells[i]
      if cell == cellCtl then
        cell:clickEvent()
        cell:setSelected(true)
      else
        cell:setSelected(false)
      end
    end
  end
  self.achivementCategoryGrid:Layout()
end

function AdventureAchievementPage:changeToHomeCategory(result)
  if result then
    if self.AchievementProfileView.activeSelf == false then
      self:Show(self.AchievementProfileView)
      self:Hide(self.AchievementList)
      return true
    end
  else
    self:Hide(self.AchievementProfileView)
    self:Show(self.AchievementList)
  end
end

function AdventureAchievementPage:setCategoryData(data)
  self.data = data
  self.subGroupData = nil
  if data.staticData.id == AdventureAchieveProxy.HomeCategoryId then
    self:Show(self.AchievementProfileView)
    self:Hide(self.AchievementList)
    self:RefreshHomeData()
  else
    self:Show(self.AchievementList)
    self:Hide(self.AchievementProfileView)
    self:RefreshListData()
  end
end

function AdventureAchievementPage:checkSelect()
  if self.itemTabs.isOpen then
    self:Show(self.ItemTabsBgSelect)
  else
    self:Hide(self.ItemTabsBgSelect)
  end
end

function AdventureAchievementPage:OnExit()
  if self.isInited then
    TimeTickManager.Me():ClearTick(self)
    local datas = self.achieveDesWrapHelper:GetDatas()
    if not datas or #datas == 0 then
      return
    end
    for i = 1, #datas do
      local data = datas[i]
      data:setSelected(false)
    end
  end
  AdventureAchievementPage.super.OnExit(self)
end

function AdventureAchievementPage:Show(target)
  if not target and not self.isInited then
    return
  end
  AdventureAchievementPage.super.Show(self, target)
end

function AdventureAchievementPage:Hide(target)
  if not target and not self.isInited then
    return
  end
  AdventureAchievementPage.super.Hide(self, target)
end

function AdventureAchievementPage:OnDestroy()
  if self.isInited then
    self.itemTabs = nil
    self.propGridCtrl:RemoveAll()
    EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChangeTitle, self.HandleChangeTitle, self)
  end
  AdventureAchievementPage.super.OnDestroy(self)
end

function AdventureAchievementPage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureAchievementPage.super.OnEnter(self)
  self:requestAchieveData()
  TimeTickManager.Me():CreateTick(0, 500, self.checkSelect, self, 2)
end

function AdventureAchievementPage:ShowSelf(viewdata)
  self:InitPage()
  self:Show()
  self.categoryScrollView:ResetPosition()
  self.AchieveProfileSv:ResetPosition()
  self:initData()
  self:RefreshHomeData()
  local cells = self.achivementCategoryGrid:GetCells()
  if viewdata then
    local type = viewdata.type
    local id = viewdata.id
    if not cells or #cells == 0 then
      return
    end
    for i = 1, #cells do
      local cell = cells[i]
      if cell.data.staticData.id == type then
        if not cell.isSelected then
          self:categoryCellClick(cell)
        else
          self:updateDescList()
        end
        local index = self:achieveDescClick(id)
        if index and -1 ~= index then
          self.achieveDesWrapHelper:ResetDatas(self.achieveDesWrapHelper.datas, index, true)
        end
        break
      end
    end
  else
    if not cells or #cells == 0 then
      return
    end
    local cell = cells[1]
    self:categoryCellClick(cell)
  end
end

function AdventureAchievementPage:ShowSubTitleAchieve(type, id)
  local cells = self.achivementCategoryGrid:GetCells()
  if not cells or #cells == 0 then
    return
  end
  for i = 1, #cells do
    local cell = cells[i]
    if cell.data.staticData.id == type then
      self:categoryCellClick(cell)
      self:achieveDescClick(id)
      break
    end
  end
end

function AdventureAchievementPage:awardTitleProp()
  local items = TitleProxy.Instance:GetAllTitleProp()
  local achieveIds = AdventureAchieveProxy.Instance:getAllUnlockedAchieve()
  local achieveAttrMap = {}
  if achieveIds and 0 < #achieveIds then
    for i = 1, #achieveIds do
      local achieveConfig = Table_Achievement[achieveIds[i]]
      local baseProp = achieveConfig and achieveConfig.RewardAttr
      if baseProp ~= _EmptyTable then
        for k, v in pairs(baseProp) do
          if not achieveAttrMap[k] then
            achieveAttrMap[k] = v
          else
            achieveAttrMap[k] = achieveAttrMap[k] + v
          end
        end
      end
    end
  end
  for k, v in pairs(items) do
    if not achieveAttrMap[k] then
      achieveAttrMap[k] = v
    end
  end
  local tempArray = {}
  for k, v in pairs(achieveAttrMap) do
    local cdata = {k, v}
    table.insert(tempArray, cdata)
  end
  local x, y, z = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform, false)
  local height = bd.size.y
  if height ~= 0 then
    y = y - height - 20
  end
  if 0 < #tempArray then
    self:Show(self.thirdContent)
    self.awardPropAchieveList:ResetDatas(tempArray)
  else
    self.awardPropAchieveList:ResetDatas()
    self:Hide(self.thirdContent)
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
  LuaVector3.Better_Set(tempVector3, x1, y, z1)
  self.thirdContent.transform.localPosition = tempVector3
end

function AdventureAchievementPage:sortItems(items)
  table.sort(items, function(l, r)
    if l:canGetReward() == r:canGetReward() then
      if l.finishtime == r.finishtime then
        return l.id < r.id
      elseif l.finishtime == nil then
        return false
      elseif r.finishtime == nil then
        return true
      else
        return l.finishtime > r.finishtime
      end
    else
      return l:canGetReward()
    end
  end)
end

function AdventureAchievementPage:UpdateRecentAchieves()
  local items = AdventureAchieveProxy.Instance:GetLastTenAchieveDatas()
  if items and 0 < #items then
    self:Show(self.fourthContent)
    if #items <= 10 then
      self:sortItems(items)
      self.recentAchieveListGrid:ResetDatas(items)
    else
      TableUtility.ArrayClear(tempArray)
      for i = 1, 10 do
        tempArray[#tempArray + 1] = items[i]
      end
      self:sortItems(tempArray)
      self.recentAchieveListGrid:ResetDatas(tempArray)
    end
    local bd = NGUIMath.CalculateRelativeWidgetBounds(self.thirdContent.transform, false)
    local height = bd.size.y
    local x, y, z = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
    if height ~= 0 then
      y = y - height - 20
    end
    local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.fourthContent.transform)
    LuaVector3.Better_Set(tempVector3, x1, y, z1)
    self.fourthContent.transform.localPosition = tempVector3
  else
    self:Hide(self.fourthContent)
  end
end

function AdventureAchievementPage:UpdateUserData()
  local createtime = AdventureAchieveProxy.Instance.createtime
  local logintime = AdventureAchieveProxy.Instance.logintime
  if not createtime then
    return
  end
  local bornMapConfig = GameConfig.System.AdventureBornMap
  local isTF = EnvChannel.IsTFBranch()
  local duration
  if isTF then
    duration = bornMapConfig.TFTime
  else
    duration = bornMapConfig.releaseTime
  end
  local startTime, endTime = duration[1], duration[2]
  if not startTime or not endTime then
    return
  end
  local startTimeStamp = KFCARCameraProxy.Instance:GetSelfCustomDate(startTime)
  local endTimeStamp = KFCARCameraProxy.Instance:GetSelfCustomDate(endTime)
  local str = ""
  if createtime > startTimeStamp and createtime < endTimeStamp then
    str = ZhString.AdventureAchievePage_NewGenBornAndToulInfo
  elseif createtime < startTimeStamp then
    local destProfession = Game.Myself.data.userdata:Get(UDEnum.DESTPROFESSION)
    if destProfession ~= 152 then
      str = ZhString.AdventureAchievePage_BornAndToulInfo
    else
      str = ZhString.AdventureAchievePage_DolamBornAndToulInfo
    end
  else
    str = ZhString.AdventureAchievePage_BornAndToulInfo
  end
  local dateStr = ""
  local totalDays = "0"
  if createtime and 0 < createtime then
    dateStr = os.date("%Y.%m.%d", createtime)
    local pastTime = ServerTime.CurServerTime() / 1000 - createtime
    totalDays = pastTime / 60 / 60 / 24
    totalDays = math.floor(totalDays)
  end
  local text = string.format(str, dateStr, totalDays, logintime)
  self.BornAndToulInfo.text = text
  self.totalTourDis.text = string.format(ZhString.AdventureAchievePage_TotalTourDis, AdventureAchieveProxy.Instance.walk_distance)
  self:updateProfessionData()
  self:updateSocialData()
end

function AdventureAchievementPage:updateProfessionData()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.secondContent.transform, false)
  local height = bd.size.y
  local currentPf = Game.Myself.data:GetCurOcc()
  local curCl = currentPf.professionData
  local professMap = {}
  while curCl and AdventureAchieveProxy.Instance.advanceClasses[curCl.id] do
    professMap[ProfessionProxy.GetProfessDepthByClassID(curCl.id)] = ProfessionProxy.GetProfessionName(curCl.id, MyselfProxy.Instance:GetMySex())
    curCl = AdventureAchieveProxy.Instance.advanceClasses[curCl.id]
  end
  TableUtility.ArrayClear(tempArray)
  for i = 1, AdventureAchieveProxy.Instance.currentCgPfNum do
    local key = string.format("bepro_%s_time", i)
    local value = AdventureAchieveProxy.Instance[key]
    if value and 0 < value and professMap[i] then
      local data = {
        name = professMap[i],
        time = value
      }
      tempArray[#tempArray + 1] = data
    end
  end
  self.changeProfessionGrid:ResetDatas(tempArray)
  local x, y, z = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  if 0 < height then
    y = y - height - 20
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.changeProfessionContent.transform)
  LuaVector3.Better_Set(tempVector3, x1, y, z1)
  self.changeProfessionContent.transform.localPosition = tempVector3
end

function AdventureAchievementPage:updateSocialData()
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.changeProfessionContent.transform, false)
  local height = bd.size.y
  TableUtility.ArrayClear(tempArray)
  for i = 1, #AdventureAchievementPage.SocialID do
    local key = AdventureAchievementPage.SocialID[i]
    local value = AdventureAchieveProxy.Instance[key]
    if value and 0 < #value then
      local data = {
        id = AdventureAchievementPage.SocialIDPair[key],
        value = value
      }
      tempArray[#tempArray + 1] = data
    end
  end
  self.SocialInfoGrid:ResetDatas(tempArray)
  local x, y, z = LuaGameObject.GetLocalPosition(self.changeProfessionContent.transform)
  if 0 < height then
    y = y - height - 20
  end
  local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.thirdContent.transform)
  LuaVector3.Better_Set(tempVector3, x1, y, z1)
  self.thirdContent.transform.localPosition = tempVector3
end

function AdventureAchievementPage:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    LuaVector3.Better_Set(tempVector3, 0, 0, 0)
    self.headCellObj.transform.localPosition = tempVector3
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end

local eventWhenUpdate = function(obj, wrapI, realI)
end

function AdventureAchievementPage:updateDescList(noResetPos)
  if self.achieveDesWrapHelper == nil then
    self.achieveDesWrapHelper = UICycledScrollCtrl.new(self:FindComponent("TableHolder", UITable), AchievementDescriptionCell, "AchievementDescriptionCell", 7)
    self.achieveDesWrapHelper:AddEventListener(MouseEvent.MouseClick, self.achieveDescCellClick, self)
    self.achieveDesWrapHelper:AddEventListener(AchievementDescriptionCell.SubAchieveClick, self.SubAchieveClickHandle, self)
  end
  if self.data and self.data.staticData.id ~= AdventureAchieveProxy.HomeCategoryId then
    local bagData = AdventureAchieveProxy.Instance.bagMap[self.data.staticData.id]
    if not bagData then
      return
    end
    local items
    if self.subGroupData then
      items = bagData:GetItemsForce(self.subGroupData.staticData.id, true)
    else
      items = bagData:GetItemsForce(nil, true)
    end
    if items and 0 < #items then
      local list = {}
      if self.selectTabData then
        if self.selectTabData.id == AdventureAchievementPage.filterId.all then
          list = items
        elseif self.selectTabData.id == AdventureAchievementPage.filterId.complete then
          for i = 1, #items do
            if items[i]:getCompleteString() then
              list[#list + 1] = items[i]
            end
          end
        elseif self.selectTabData.id == AdventureAchievementPage.filterId.uncomplete then
          for i = 1, #items do
            if not items[i]:getCompleteString() then
              list[#list + 1] = items[i]
            end
          end
        end
      end
      self.achieveDesWrapHelper:ResetDatas(list, nil, not noResetPos)
      self:Hide(self.emptyContent)
      if not noResetPos then
        self.AchieveListSv:ResetPosition()
      end
    else
      self.achieveDesWrapHelper:ResetDatas({})
      self:Show(self.emptyContent)
    end
  end
end
