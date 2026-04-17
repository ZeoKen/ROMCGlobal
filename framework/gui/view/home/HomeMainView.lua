autoImport("HomeInfoPage")
autoImport("HomeScorePage")
autoImport("HomeSettingPage")
autoImport("HomeRecommendPage")
autoImport("HouseTypeTabCell")
HomeMainView = class("HomeMainView", ContainerView)
HomeMainView.ViewType = UIViewType.NormalLayer
HomeMainView.TabName = {
  [1] = ZhString.HomeMainView_TabRecommend,
  [2] = ZhString.HomeMainView_TabName1,
  [3] = ZhString.HomeMainView_TabName2,
  [4] = ZhString.HomeMainView_TabName3
}
local _Single_Tab_Width = 128

function HomeMainView:Init()
  self:InitUI()
  self:AddListenEvts()
end

function HomeMainView:InitUI()
  local togglesParentObj = self:FindGO("Toggles")
  local toggleList = {}
  local longPressList = {}
  for i = 1, 4 do
    local toggleObj = self:FindGO("Toggle" .. i, togglesParentObj)
    toggleList[#toggleList + 1] = toggleObj
    local toggleLongPress = toggleObj:GetComponent(UILongPress)
    
    function toggleLongPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.HomeMainView, {state, i})
    end
    
    longPressList[#longPressList + 1] = toggleLongPress
  end
  for k, v in pairs(toggleList) do
    TabNameTip.SwitchShowTabIconOrLabel(Game.GameObjectUtil:DeepFindChild(v, "Icon"), Game.GameObjectUtil:DeepFindChild(v, "NameLabel"))
  end
  self:AddEventListener(TipLongPressEvent.HomeMainView, self.HandleLongPress, self)
  self.tabGrid = self:FindComponent("Tabs", UIGrid)
  self.houseTypeTabList = UIGridListCtrl.new(self.tabGrid, HouseTypeTabCell, "HouseTypeTabCell")
  self.houseTypeTabList:AddEventListener(MouseEvent.MouseClick, self.OnHouseTypeTabClick, self)
  self.tabLine = self:FindComponent("TabLine", UISprite)
  self.homeInfoPage = self:AddSubView("HomeInfoPage", HomeInfoPage)
  self.homeScorePage = self:AddSubView("HomeScorePage", HomeScorePage)
  self.homeSettingPage = self:AddSubView("HomeSettingPage", HomeSettingPage)
  self.homeRecommendPage = self:AddSubView("HomeRecommendPage", HomeRecommendPage)
  self:AddTabChangeEvent(toggleList[1], self.homeRecommendPage.gameObject, PanelConfig.HomeRecommendPage)
  self:AddTabChangeEvent(toggleList[2], self.homeInfoPage.gameObject, PanelConfig.HomeInfoPage)
  self:AddTabChangeEvent(toggleList[3], self.homeScorePage.gameObject, PanelConfig.HomeScorePage)
  self:AddTabChangeEvent(toggleList[4], self.homeSettingPage.gameObject, PanelConfig.HomeSettingPage)
  self:DisableTog()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
end

function HomeMainView:OnHouseTypeTabClick(cell)
  if cell.selected then
    self.houseType = cell.data and cell.data.id
    local tab = self.coreTabMap[self.curKey]
    if tab then
      if tab.tar == self.homeInfoPage.gameObject then
        self.homeInfoPage:OnSwitch(true, self.houseType)
      elseif tab.tar == self.homeScorePage.gameObject then
        self.homeScorePage:OnSwitch(true, self.houseType)
      elseif tab.tar == self.homeSettingPage.gameObject then
        self.homeSettingPage:OnSwitch(true, self.houseType)
      elseif tab.tar == self.homeRecommendPage.gameObject then
        self.homeRecommendPage:OnSwitch(true, self.houseType)
      end
    end
  end
end

function HomeMainView:TabChangeHandler(key)
  if self.curKey and self.curKey == key then
    return
  end
  self.curKey = key
  local ret = HomeMainView.super.TabChangeHandler(self, key)
  local tab = self.coreTabMap[key]
  if tab.tar == self.homeInfoPage.gameObject then
    self.homeInfoPage:OnSwitch(true, self.houseType)
  elseif tab.tar == self.homeScorePage.gameObject then
    self.homeScorePage:OnSwitch(true, self.houseType)
  elseif tab.tar == self.homeSettingPage.gameObject then
    self.homeSettingPage:OnSwitch(true, self.houseType)
  elseif tab.tar == self.homeRecommendPage.gameObject then
    self.homeRecommendPage:OnSwitch(true, self.houseType)
  end
  if ret and tab and not GameConfig.SystemForbid.TabNameTip then
    if self.currentKey then
      local iconSp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite)
      iconSp.color = ColorUtil.TabColor_White
    end
    self.currentKey = key
    local iconSp = Game.GameObjectUtil:DeepFindChild(tab.go, "Icon"):GetComponent(UISprite)
    iconSp.color = ColorUtil.TabColor_DeepBlue
  end
end

function HomeMainView:DisableTog()
  if not self.disableTabs then
    return
  end
  for i = 1, #self.disableTabs do
    local tab = self.coreTabMap[self.disableTabs[i]]
    if tab and tab.go then
      self:SetTextureGrey(tab.go)
      tab.go:GetComponent(BoxCollider).enabled = false
    end
  end
end

function HomeMainView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdQueryRecommendHomeCmd, self.OnHomeRecommendRefreshSuccess)
end

function HomeMainView:OnHomeRecommendRefreshSuccess()
end

function HomeMainView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, HomeMainView.TabName[index], false, Game.GameObjectUtil:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite))
end

function HomeMainView:OnEnter()
  HomeMainView.super.OnEnter(self)
  if not HomeProxy.Instance:GetMyHouseData() then
    local msgId = ProtoReqInfoList.QueryHouseDataHomeCmd.id
    local msgParam = HomeCmd_pb.QueryHouseDataHomeCmd()
    ServiceHomeCmdProxy.Instance:SendProto2(msgId, msgParam)
  end
  local datas = HomeProxy.Instance:GetHouseTypeList()
  self.houseTypeTabList:ResetDatas(datas)
  self.houseType = datas[1] and datas[1].id or HomeProxy.HouseType.Home
  self:TabChangeHandler(1)
  local cells = self.houseTypeTabList:GetCells()
  local cell = cells[1]
  if cell then
    cell:ToggleOn()
  end
  local tabCount = #cells
  self.tabLine.width = _Single_Tab_Width * tabCount + (self.tabGrid.cellWidth - _Single_Tab_Width) * (tabCount - 1)
end

function HomeMainView:OnExit()
  PictureManager.Instance:UnLoadHome()
  HomeMainView.super.OnExit(self)
end
