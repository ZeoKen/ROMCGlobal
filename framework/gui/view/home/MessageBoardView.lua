autoImport("MessageTipPage")
autoImport("MessageBoardTracePage")
MessageBoardView = class("MessageBoardView", ContainerView)
MessageBoardView.ViewType = UIViewType.NormalLayer
MessageBoardView.TabName = {
  [1] = ZhString.MessageBoardView_TabName1,
  [2] = ZhString.MessageBoardView_TabName2,
  [3] = ZhString.MessageBoardView_TabName3
}

function MessageBoardView:Init()
  self:InitUI()
  self:AddListenEvt()
  self:InitData()
end

function MessageBoardView:InitUI()
  local togglesParentObj = self:FindGO("Toggles")
  local toggleList = {}
  local longPressList = {}
  for i = 1, 2 do
    local toggleObj = self:FindGO("Toggle" .. i, togglesParentObj)
    toggleList[#toggleList + 1] = toggleObj
    local toggleLongPress = toggleObj:GetComponent(UILongPress)
    
    function toggleLongPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.MessageBoardView, {state, i})
    end
    
    longPressList[#longPressList + 1] = toggleLongPress
  end
  for k, v in pairs(toggleList) do
    TabNameTip.SwitchShowTabIconOrLabel(Game.GameObjectUtil:DeepFindChild(v, "Icon"), Game.GameObjectUtil:DeepFindChild(v, "NameLabel"))
  end
  self:AddEventListener(TipLongPressEvent.MessageBoardView, self.HandleLongPress, self)
  self.messageTipPage = self:AddSubView("MessageTipPage", MessageTipPage)
  self.messageBoardTracePage = self:AddSubView("MessageBoardTracePage", MessageBoardTracePage)
  self:AddTabChangeEvent(toggleList[1], self.messageTipPage.gameObject, PanelConfig.MessageTipPage)
  self:AddTabChangeEvent(toggleList[2], self.messageBoardTracePage.gameObject, PanelConfig.MessageBoardTracePage)
  self:DisableTog()
  self:TabChangeHandler(1)
end

function MessageBoardView:InitData()
  local viewData = self.viewdata.viewdata
  self.furniture = viewData and viewData.furniture
  if not self.furniture then
    LogUtility.Error("Cannot get furniture when initializing MessageBoardView!")
  end
end

function MessageBoardView:TabChangeHandler(key)
  if self.curKey and self.curKey == key then
    return
  end
  self.curKey = key
  local ret = MessageBoardView.super.TabChangeHandler(self, key)
  local tab = self.coreTabMap[key]
  if tab.tar == self.messageTipPage.gameObject then
    self.messageTipPage:OnSwitch(true)
  elseif tab.tar == self.messageBoardTracePage.gameObject then
    self.messageBoardTracePage:OnSwitch(true)
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

function MessageBoardView:DisableTog()
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

function MessageBoardView:AddListenEvt()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
end

function MessageBoardView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, MessageBoardView.TabName[index], false, Game.GameObjectUtil:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite))
end

function MessageBoardView:OnEnter()
  MessageBoardView.super.OnEnter(self)
end

function MessageBoardView:OnExit()
  MessageBoardView.super.OnExit(self)
end
