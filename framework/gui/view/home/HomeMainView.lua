autoImport("HomeInfoPage")
autoImport("HomeScorePage")
autoImport("HomeSettingPage")
HomeMainView = class("HomeMainView", ContainerView)
HomeMainView.ViewType = UIViewType.NormalLayer
HomeMainView.TabName = {
  [1] = ZhString.HomeMainView_TabName1,
  [2] = ZhString.HomeMainView_TabName2,
  [3] = ZhString.HomeMainView_TabName3
}

function HomeMainView:Init()
  self:InitUI()
  self:AddListenEvt()
end

function HomeMainView:InitUI()
  local togglesParentObj = self:FindGO("Toggles")
  local toggleList = {}
  local longPressList = {}
  for i = 1, 3 do
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
  self.homeInfoPage = self:AddSubView("HomeInfoPage", HomeInfoPage)
  self.homeScorePage = self:AddSubView("HomeScorePage", HomeScorePage)
  self.homeSettingPage = self:AddSubView("HomeSettingPage", HomeSettingPage)
  self:AddTabChangeEvent(toggleList[1], self.homeInfoPage.gameObject, PanelConfig.HomeInfoPage)
  self:AddTabChangeEvent(toggleList[2], self.homeScorePage.gameObject, PanelConfig.HomeScorePage)
  self:AddTabChangeEvent(toggleList[3], self.homeSettingPage.gameObject, PanelConfig.HomeSettingPage)
  self:DisableTog()
  self:TabChangeHandler(1)
end

function HomeMainView:TabChangeHandler(key)
  if self.curKey and self.curKey == key then
    return
  end
  self.curKey = key
  local ret = HomeMainView.super.TabChangeHandler(self, key)
  local tab = self.coreTabMap[key]
  if tab.tar == self.homeInfoPage.gameObject then
    self.homeInfoPage:OnSwitch(true)
  elseif tab.tar == self.homeScorePage.gameObject then
    self.homeScorePage:OnSwitch(true)
  elseif tab.tar == self.homeSettingPage.gameObject then
    self.homeSettingPage:OnSwitch(true)
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

function HomeMainView:AddListenEvt()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
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
end

function HomeMainView:OnExit()
  PictureManager.Instance:UnLoadHome()
  HomeMainView.super.OnExit(self)
end
