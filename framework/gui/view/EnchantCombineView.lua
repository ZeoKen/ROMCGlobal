autoImport("CommonNewTabListCell")
EnchantCombineView = class("EnchantCombineView", BaseView)
EnchantCombineView.ViewType = UIViewType.NormalLayer

function EnchantCombineView:InitConfig()
  self.TabGOName = {
    "EnchantTab",
    "EnchantAttrUp",
    "EnchantThirdAttrReset",
    "EnchantTransferTab"
  }
  self.TabIconMap = {
    EnchantTab = "tab_icon_enchant",
    EnchantAttrUpgrade = "tab_icon_enchantUp",
    EnchantThirdAttrReset = "tab_icon_enchantChange",
    EnchantTransferTab = "tab_icon_enchantment-transfer"
  }
  self.TabName = {
    ZhString.EnchantCombineView_EnchantTab,
    ZhString.EnchantCombineView_EnchantAttrUpTab,
    ZhString.EnchantCombineView_EnchantThirdAttrResetTab,
    ZhString.EnchantCombineView_EnchantTransferTab
  }
  self.TabViewList = {
    PanelConfig.EnchantNewView,
    PanelConfig.EnchantAttrUpView,
    PanelConfig.EnchantThirdAttrResetView,
    PanelConfig.EnchantTransferView
  }
  if FunctionUnLockFunc.CheckForbiddenByFuncState("enchant_transfer_forbidden") then
    local tabObj = self:FindGO(self.TabGOName[4])
    if tabObj then
      self:Hide(tabObj)
    end
    self.TabGOName[4] = nil
    self.TabIconMap[4] = nil
    self.TabName[4] = nil
    self.TabViewList[4] = nil
  end
end

function EnchantCombineView:Init()
  self:InitConfig()
  self:InitData()
  self:InitView()
end

function EnchantCombineView:InitData()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcData = viewdata.npcdata
    self.index = viewdata.index or 1
    self.OnClickChooseBordCell_data = viewdata.OnClickChooseBordCell_data
    self.isFromBag = viewdata.isFromBag
  end
end

function EnchantCombineView:SetStackViewIndex(index)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    viewdata.index = index
  end
end

function EnchantCombineView:InitView()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.cells = {}
  local tabName, longPress, tabObj
  for i = 1, #self.TabGOName do
    tabName = self.TabGOName[i]
    tabObj = self:FindGO(tabName)
    self:Show(tabObj)
    self.cells[i] = CommonNewTabListCell.new(self:FindGO(tabName))
    self.cells[i]:SetIcon(self.TabIconMap[tabName], self.TabType and self.TabType[i])
    local check = {
      tab = i,
      id = self.TabViewList[i].id
    }
    self:AddTabChangeEvent(self.cells[i].gameObject, nil, check)
    longPress = self.cells[i].gameObject:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.EnchantCombineView, {state, i})
    end
  end
  self.grid:Reposition()
  self.shopEnterBtn = self:FindGO("ShopEnter")
  self:AddClickEvent(self.shopEnterBtn, function()
    self:JumpPanel(5)
  end)
  self:AddEventListener(TipLongPressEvent.EnchantCombineView, self.HandleLongPress, self)
  self:AddListenEvt(ServiceEvent.LoginUserCmdLoginResultUserCmd, self.CloseSelf, self)
end

function EnchantCombineView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, self.TabName[index], false, self.cells[index].sp)
end

function EnchantCombineView:TabChangeHandler(key)
  if self.tab_key == key then
    return
  end
  self.tab_key = key
  if not EnchantCombineView.super.TabChangeHandler(self, key) then
    return
  end
  self:JumpPanel(key)
  if self.cells and self.cells[key] then
    self.cells[key].toggle.value = true
  end
end

function EnchantCombineView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("EnchantNewView", {
      isFromHomeWorkbench = true,
      isCombine = true,
      OnClickChooseBordCell_data = self.OnClickChooseBordCell_data
    })
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("EnchantAttrUpView", {
      npcdata = self.npcData
    })
  elseif tabIndex == 3 then
    self:SetStackViewIndex(3)
    self:_JumpPanel("EnchantThirdAttrResetView", {
      npcdata = self.npcData
    })
  elseif tabIndex == 4 then
    self:SetStackViewIndex(4)
    self:_JumpPanel("EnchantTransferView", {
      npcdata = self.npcData,
      isCombine = true,
      isnew = true
    })
  elseif tabIndex == 5 then
    FunctionNpcFunc.TypeFunc_Shop(self.npcData, 1, Table_NpcFunction[850])
  end
end

function EnchantCombineView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end

function EnchantCombineView:OnEnter()
  EnchantCombineView.super.OnEnter(self)
  self:TabChangeHandler(self.index)
  EventManager.Me():AddEventListener(EnchantEvent.ReturnToReset, self.ReturnToResetView, self)
end

function EnchantCombineView:ReturnToResetView()
  self:TabChangeHandler(3)
end

function EnchantCombineView:CloseSelf()
  EnchantCombineView.super.CloseSelf(self)
end

function EnchantCombineView:OnExit()
  EnchantCombineView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(EnchantEvent.ReturnToReset, self.ReturnToResetView, self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantNewView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantAttrUpView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantThirdAttrResetView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "EnchantTransferView",
    needRollBack = false
  })
  EnchantEquipUtil.Instance:SetCurrentEnchantId(nil)
end
