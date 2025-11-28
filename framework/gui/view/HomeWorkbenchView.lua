autoImport("CommonNewTabListCell")
autoImport("CommonTabListCell")
HomeWorkbenchView = class("HomeWorkbenchView", BaseView)
HomeWorkbenchView.ViewType = UIViewType.NormalLayer
HomeWorkbenchView.ForceCoExist = true
HomeWorkbenchTabNameArray = {
  "Tab1",
  "Tab2",
  "Tab3",
  "Tab4"
}
HomeWorkbenchTabNameIconMap = {
  Tab1 = "tab_icon_38",
  Tab2 = "tab_icon_86",
  Tab3 = "tab_icon_87",
  Tab4 = "tab_icon_18"
}
HomeWorkbenchViewTabNameMap = {
  Tab1 = ZhString.PackageView_StrengthTabName,
  Tab2 = ZhString.ShopMall_ExchangeRefine,
  Tab3 = ZhString.NpcRefinePanel_OneClickTabName,
  Tab4 = ZhString.EnchantView_Enchant
}
local manager

function HomeWorkbenchView:Init()
  if not manager then
    manager = HomeManager.Me()
  end
  self:AddListenEvts()
  self:InitData()
  self:InitView()
end

function HomeWorkbenchView:AddListenEvts()
  self:AddListenEvt(HomeEvent.WorkbenchStartWork, self.OnStartWork)
  self:AddListenEvt(HomeEvent.WorkbenchHideHelpBtn, self.HideHelpButton)
  self:AddListenEvt(HomeEvent.WorkbenchShowHelpBtn, self.ShowHelpButton)
  self:AddListenEvt(HomeEvent.ExitHome, self.OnExitHome)
end

function HomeWorkbenchView:InitData()
  local viewData = self.viewdata.viewdata
  self.furniture = viewData and viewData.furniture
  self.actionName = viewData and viewData.actionName
end

function HomeWorkbenchView:InitView()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.cells = {}
  local tabName, longPress
  for i = 1, #HomeWorkbenchTabNameArray do
    tabName = HomeWorkbenchTabNameArray[i]
    self.cells[i] = CommonTabListCell.new(self:FindGO(tabName))
    self.cells[i]:SetIcon(HomeWorkbenchTabNameIconMap[tabName])
    self:AddTabChangeEvent(self.cells[i].gameObject, nil, i)
    longPress = self.cells[i].gameObject:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.HomeWorkbenchView, {state, i})
    end
  end
  self:AddEventListener(TipLongPressEvent.HomeWorkbenchView, self.HandleLongPress, self)
  self:InitShopEnter()
  self.colliderPanel = self:FindGO("ColliderPanel")
  self.colliderPanel:SetActive(false)
end

function HomeWorkbenchView:InitShopEnter()
  self.shopEnterBtn = self:FindGO("ShopEnter")
  self:AddClickEvent(self.shopEnterBtn, function()
    HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
    FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, self.viewdata.viewdata)
    self.noCloseNormal = true
    self:CloseSelf()
    manager.curWorkbenchTab = nil
    self.noCloseNormal = nil
  end)
end

function HomeWorkbenchView:OnEnter()
  HomeWorkbenchView.super.OnEnter(self)
  local isRefineOpen = self:_CheckCanOpen(4)
  self.cells[2].gameObject:SetActive(isRefineOpen)
  self.cells[3].gameObject:SetActive(isRefineOpen)
  local isEnchantOpen = self:_CheckCanOpen(73)
  self.cells[4].gameObject:SetActive(isEnchantOpen)
  self.grid:Reposition()
  local firstKey = manager.curWorkbenchTab or 1
  self:TabChangeHandler(firstKey)
end

function HomeWorkbenchView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "PackageView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "NpcRefinePanel",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantNewView",
    needRollBack = false
  })
  self:OnExitHome()
  HomeWorkbenchView.super.OnExit(self)
end

function HomeWorkbenchView:OnExitHome()
  manager.curWorkbenchTab = nil
  self:CloseSelf()
end

function HomeWorkbenchView:OnStartWork()
  if not self.furniture then
    return
  end
  self.furniture:PlayAction(self.actionName, nil, nil, nil, true)
end

function HomeWorkbenchView:TabChangeHandler(key)
  if not HomeWorkbenchView.super.TabChangeHandler(self, key) then
    return
  end
  if key == manager.curWorkbenchTab then
    return
  end
  self.notToClose = true
  TimeTickManager.Me():CreateOnceDelayTick(200, function(self)
    self.notToClose = nil
  end, self)
  self:JumpPanel(key)
  manager.curWorkbenchTab = key
  if self.cells and self.cells[key] then
    self.cells[key].toggle.value = true
  end
end

function HomeWorkbenchView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:_JumpPanel("EquipStrengthen", {hideTab = true, hideClose = true})
  elseif tabIndex == 2 then
    self:_JumpPanel("NpcRefinePanel", {isCombine = true})
  elseif tabIndex == 3 then
    self:_JumpPanel("NpcRefinePanel", {isCombine = true, isOneClick = true})
  elseif tabIndex == 4 then
    self:_JumpPanel("EnchantNewView", {isFromHomeWorkbench = true})
  end
end

function HomeWorkbenchView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end

function HomeWorkbenchView:_CheckCanOpen(menuId, withTip)
  return FunctionUnLockFunc.Me():CheckCanOpen(menuId, withTip)
end

function HomeWorkbenchView:AddHelpButtonEvent()
  self.helpButton = self:FindGO("HelpButton")
  self:TryOpenHelpViewById(3000001, nil, self.helpButton)
end

function HomeWorkbenchView:ShowHelpButton()
  if not self.helpButton then
    return
  end
  self.helpButton:SetActive(true)
end

function HomeWorkbenchView:HideHelpButton()
  if not self.helpButton then
    return
  end
  self.helpButton:SetActive(false)
end

function HomeWorkbenchView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, HomeWorkbenchViewTabNameMap[HomeWorkbenchTabNameArray[index]], false, self.cells[index].sp)
end
