AdventureFoodPage = class("AdventureFoodPage", SubMediatorView)
autoImport("AdventureCookPage")
autoImport("AdventureTastePage")
autoImport("AdventureFoodItemCell")
autoImport("AdventureFoodPageCombineItemCell")
autoImport("FoodScoreTip")
AdventureFoodPage.Category = {CookPage = 1, TastePage = 2}
AdventureFoodPage.MaxCategory = {
  id = 99999999,
  value = {}
}
AdventureFoodPage.CheckHashSelected = "AdventureCookPage_CheckHashSelected"

function AdventureFoodPage:Init()
  self.isInited = false
end

function AdventureFoodPage:InitPage()
  if self.isInited then
    return
  end
  self:ReLoadPerferb("view/AdventureFoodPage")
  self.trans:SetParent(self.container:getSubPageParent(), false)
  self:AddViewEvts()
  self:initView()
  self.isInited = true
  self:OnEnter()
end

function AdventureFoodPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SceneFoodNewFoodDataNtf, self.Server_NewFoodDataNtf)
  self:AddListenEvt(ItemEvent.FoodUpdate, self.OnFoodUpdate)
end

function AdventureFoodPage:initView()
  self:AddTabChangeEvent(self:FindGO("categoryCook"), self:FindGO("AdventureCookPage"), AdventureFoodPage.Category.CookPage)
  self:AddTabChangeEvent(self:FindGO("categoryTaste"), self:FindGO("AdventureTastePage"), AdventureFoodPage.Category.TastePage)
  self.AdventureCookPage = self:AddSubView("categoryCook", AdventureCookPage)
  self.AdventureTastePage = self:AddSubView("categoryTaste", AdventureTastePage)
  local cookDes = self:FindComponent("cookDes", UILabel)
  local tasteDes = self:FindComponent("tasteDes", UILabel)
  local tasteName = self:FindComponent("tasteName", UILabel)
  local cookName = self:FindComponent("cookName", UILabel)
  cookDes.text = ZhString.AdventureFoodPage_FoodInstitul
  tasteDes.text = ZhString.AdventureFoodPage_FoodInstitul
  tasteName.text = ZhString.AdventureFoodPage_TasteTitleTitle
  cookName.text = ZhString.AdventureFoodPage_CookTitleTitle
  local itemContainer = self:FindGO("bag_itemContainer")
  local pfbNum = 7
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = pfbNum,
    cellName = "AdventureBagCombineItemCell",
    control = AdventureFoodPageCombineItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(AdventureFoodPage.CheckHashSelected, self.CheckHashSelected, self)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.scrollView = self:FindComponent("CookScrollView", ROUIScrollView)
  
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  
  self.tipHolderCt = self:FindGO("tipHolderCt")
  self.tipHolder = self:FindGO("tipHolder")
  self.profileCt = self:FindGO("profileCt")
  local TasteIcon_Sprite = self:FindComponent("TasteIcon_Sprite", UISprite)
  IconManager:SetItemIcon("task_certificate2", TasteIcon_Sprite)
  local CookIcon_Sprite = self:FindComponent("CookIcon_Sprite", UISprite)
  IconManager:SetItemIcon("task_certificate1", CookIcon_Sprite)
  self.itemTabs = PopupGridList.new(self:FindGO("ItemTabs"), function(self, data)
    if self.selectTabData ~= data then
      self.selectTabData = data
      self:UpdateList()
    end
  end, self, self:FindComponent("tabCt", UIPanel).depth + 1)
  self.tasteTog = self:FindComponent("tasteTog", UIToggle)
  self.cookTog = self:FindComponent("cookTog", UIToggle)
  self.detailDesCt = self:FindGO("detailDesCt")
end

function AdventureFoodPage:Server_NewFoodDataNtf(date)
  self:updateAllCookRecipe(true)
  if self.tobeUnlock then
    local cell = self:GetItemCellById(self.tobeUnlock)
    if cell then
      self:HandleClickItem(cell, true)
      cell:PlayUnlockEffect()
    end
  end
end

function AdventureFoodPage:ScrollViewRevert(callback)
  self.revertCallBack = callback
  self.scrollView:Revert()
end

function AdventureFoodPage:ShowSelf(viewdata)
  self:InitPage()
  self:Show()
  self:initTabData()
  self:updateAllCookRecipe()
  self:UpdateList()
  self.AdventureCookPage:ResetData()
  self.AdventureTastePage:ResetData()
  self:ReShowSelectedData()
end

function AdventureFoodPage:ReShowSelectedData()
  if not self.chooseItemId then
    return
  end
  self:removeTip()
  local cell = self:GetItemCellById(self.chooseItemId)
  if cell and cell.data then
    self:ShowItemTip(cell.data)
  end
end

function AdventureFoodPage:updateAllCookRecipe(noResetPos)
  self:UpdateList(noResetPos)
end

function AdventureFoodPage:initTabData()
  local tabDataList = ReusableTable.CreateArray()
  tabDataList[#tabDataList + 1] = {
    id = AdventureFoodPage.MaxCategory.id,
    name = ZhString.AdventureFoodPage_AllFoods
  }
  for i = 1, 5 do
    tabDataList[#tabDataList + 1] = {
      id = i,
      name = string.format(ZhString.AdventureFoodPage_FoodsTab, i),
      RedTip = GameConfig.AdventureFoodRedTip[i]
    }
  end
  self.itemTabs:SetData(tabDataList)
  self.itemTabs:RegisterTopRedTips(GameConfig.AdventureFoodRedTip, 25)
  ReusableTable.DestroyAndClearArray(tabDataList)
end

function AdventureFoodPage:OnExit()
  if self.isInited then
    self:removeTip()
  end
  AdventureFoodPage.super.OnExit(self)
end

function AdventureFoodPage:OnEnter()
  if not self.isInited then
    return
  end
  AdventureFoodPage.super.OnEnter(self)
  if self.viewMap ~= nil then
    for _, o in pairs(self.viewMap) do
      o:OnEnter()
    end
  end
  self:TabChangeHandler(AdventureFoodPage.Category.CookPage)
end

function AdventureFoodPage:OnDestroy()
  if self.isInited then
    if self.viewMap ~= nil then
      for _, o in pairs(self.viewMap) do
        o:OnExit()
      end
    end
    self.selectTabData = nil
    local cell = self:GetItemCellById(self.chooseItemId)
    if cell then
      cell:setIsSelected(false)
    end
    self.chooseItemId = nil
    self.itemTabs:Destroy()
    self.wraplist:Destroy()
  end
  AdventureFoodPage.super.OnDestroy(self)
end

function AdventureFoodPage:OnFoodUpdate()
  if self.tip then
    self.tip:UpdateNumLabel()
  end
end

function AdventureFoodPage:handleCategoryClick(key)
  self:handleCategorySelect(key)
  if key == AdventureFoodPage.Category.CookPage then
    self.AdventureCookPage:ResetData()
  elseif key == AdventureFoodPage.Category.TastePage then
    self.AdventureTastePage:ResetData()
  end
end

function AdventureFoodPage:handleCategorySelect(key)
  if key == AdventureFoodPage.Category.CookPage then
  elseif key == AdventureFoodPage.Category.TastePage then
  end
  local cell = self:GetItemCellById(self.chooseItemId)
  if cell then
    cell:setIsSelected(false)
  end
  self:Hide(self.tipHolderCt)
  self.chooseItemId = nil
  self:ShowItemTip(nil)
  self:Show(self.detailDesCt)
end

function AdventureFoodPage:TabChangeHandler(key)
  if self.currentKey ~= key then
    self:SuperTabChangeHandler(key)
    self:handleCategoryClick(key)
    self.currentKey = key
  end
end

function AdventureFoodPage:AddTabChangeEvent(obj, target, openCheck, callback)
  if not self.coreTabMap then
    self.coreTabMap = {}
  end
  local key = openCheck
  if type(openCheck) == "table" and openCheck.tab then
    key = openCheck.tab
  end
  if not self.coreTabMap[key] then
    local toggle
    if obj then
      local togs = Game.GameObjectUtil:GetAllComponentsInChildren(obj, UIToggle, true)
      toggle = togs and togs[1]
    end
    self.coreTabMap[key] = {
      check = openCheck,
      go = obj,
      tog = toggle,
      tar = target
    }
    if obj ~= nil then
      self:AddClickEvent(obj, self:GetToggleEvent(callback))
    end
  end
end

function AdventureFoodPage:GetToggleEvent(callback)
  if not self.coreToggleEvent then
    function self.coreToggleEvent(obj)
      if self.coreTabMap then
        for k, v in pairs(self.coreTabMap) do
          if v.go == obj then
            if self:TabChangeHandler(k) and type(callback) == "function" then
              callback()
            end
            return
          end
        end
      end
    end
  end
  return self.coreToggleEvent
end

function AdventureFoodPage:SuperTabChangeHandler(key)
  if self.coreTabMap then
    local tabObj = self.coreTabMap[key]
    if type(tabObj.check) == "table" and tabObj.check.id and not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(tabObj.check.id, true) then
      if tabObj.tog ~= nil then
        tabObj.tog.value = false
      end
      return false
    end
    if tabObj.tog ~= nil then
      tabObj.tog.value = true
    end
    for k, v in pairs(self.coreTabMap) do
      if v.tar then
        v.tar.gameObject:SetActive(k == key)
      end
    end
    return true
  end
  return nil
end

function AdventureFoodPage:HandleClickItem(cellCtl, noClickSound)
  if cellCtl and cellCtl.data then
    local data = cellCtl.data
    self.tobeUnlock = nil
    if data.status == SceneFood_pb.EFOODSTATUS_ADD then
      ServiceSceneFoodProxy.Instance:CallClickFoodManualData(SceneFood_pb.EFOODDATATYPE_FOODCOOK, data.itemid)
      self:PlayUISound(AudioMap.UI.maoxianshoucedianjijiesuo)
      self.tobeUnlock = data.itemid
      return
    end
    if data.itemid ~= self.chooseItemId then
      local cell = self:GetItemCellById(self.chooseItemId)
      if cell then
        cell:setIsSelected(false)
      end
      if not noClickSound then
        self:PlayUISound(AudioMap.UI.Click)
      end
      self:Hide(self.detailDesCt)
      self.currentKey = nil
      self.tasteTog.value = false
      self.cookTog.value = false
      if self.tip then
        self.tip:SetData(data)
      else
        self:ShowItemTip(data)
      end
      self.chooseItemId = data.itemid
      cellCtl:setIsSelected(true)
    end
  end
end

function AdventureFoodPage:ShowItemTip(data)
  self:removeTip()
  if not data then
    return
  end
  self:Show(self.tipHolderCt)
  self.tip = FoodScoreTip.new(self.tipHolder)
  self.tip:SetData(data)
end

function AdventureFoodPage:removeTip()
  if self.tipHolder.transform.childCount > 0 then
    local tip = self.tipHolder.transform:GetChild(0)
    if tip and self.tip then
      self.tip:OnExit()
    end
  end
  self.tip = nil
end

function AdventureFoodPage:CheckHashSelected(cellCtl)
  if cellCtl and cellCtl.data and self.chooseItemId then
    if self.chooseItemId == cellCtl.data.itemid then
      cellCtl:setIsSelected(true)
    else
      cellCtl:setIsSelected(false)
    end
  elseif cellCtl then
    cellCtl:setIsSelected(false)
  end
end

function AdventureFoodPage:UpdateList(noResetPos)
  local food_cook_info = FoodProxy.Instance.food_cook_info
  local list = {}
  local tabId = AdventureFoodPage.MaxCategory.id
  if self.selectTabData then
    tabId = self.selectTabData.id
  end
  for k, v in pairs(food_cook_info) do
    if v.itemData and v.itemData.staticData and v.itemData.staticData.AdventureValue and v.itemData.staticData.AdventureValue ~= 0 and ItemUtil.CheckDateValidByItemId(v.itemData.staticData.id) then
      local foodData = Table_Food[k]
      local hardLv = math.floor((foodData.CookHard + 1) / 2)
      if tabId == AdventureFoodPage.MaxCategory.id then
        list[#list + 1] = v
      elseif hardLv == tabId then
        list[#list + 1] = v
      end
    end
  end
  table.sort(list, function(l, r)
    return l.itemid < r.itemid
  end)
  self:SetData(list, noResetPos)
end

function AdventureFoodPage:SetData(datas, noResetPos)
  self.unitedDatas = self:ReUnitData(datas, 5)
  self.wraplist:UpdateInfo(self.unitedDatas)
  if not noResetPos and self.gameObject.activeSelf then
    self.wraplist:ResetPosition()
  end
end

function AdventureFoodPage:JumpToFirstClickableItem(force)
  local firstClickableIndex = self:FindFirstClickableItemRowIndex(self.unitedDatas)
  if firstClickableIndex or force then
    self.wraplist:SetStartPositionByIndex(firstClickableIndex or 0)
  end
end

function AdventureFoodPage:FindFirstClickableItemRowIndex(unitedDatas)
  if not unitedDatas then
    return
  end
  local rowDatas
  for i = 1, #unitedDatas do
    rowDatas = unitedDatas[i]
    for j = 1, #rowDatas do
      if rowDatas[j].status == SceneFood_pb.EFOODSTATUS_ADD then
        return i
      end
    end
  end
end

function AdventureFoodPage:ReUnitData(datas, rowNum)
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

function AdventureFoodPage:GetItemCellById(id)
  if not id then
    return
  end
  local cells = self:GetItemCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local single = cells[i]
      if single.data and single.data.itemid == id then
        return single
      end
    end
  end
end

function AdventureFoodPage:Show(obj)
  if not obj and not self.isInited then
    return
  end
  AdventureFoodPage.super.Show(self, obj)
end

function AdventureFoodPage:Hide(obj)
  if not obj then
    if not self.isInited then
      return
    end
    self:removeTip()
  end
  AdventureFoodPage.super.Hide(self, obj)
end

function AdventureFoodPage:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
  local result = {}
  for i = 1, #combineCells do
    local v = combineCells[i]
    local childs = v:GetCells()
    for i = 1, #childs do
      table.insert(result, childs[i])
    end
  end
  return result
end
