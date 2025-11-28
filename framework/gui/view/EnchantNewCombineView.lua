autoImport("CommonCombineView")
EnchantNewCombineView = class("EnchantNewCombineView", CommonCombineView)
EnchantNewCombineView.ViewType = UIViewType.NormalLayer
local fkCfg = {
  EnchantNewView = {
    name = ZhString.EnchantCombineView_EnchantTab,
    icon = "tab_icon_enchant"
  }
}

function EnchantNewCombineView:InitConfig()
  self.TabGOName = {
    "Tab1",
    "Tab2",
    "Tab3",
    "Tab4"
  }
  self.TabIconMap = {
    Tab1 = "tab_icon_enchant",
    Tab2 = "tab_icon_enchantUp",
    Tab3 = "tab_icon_enchantChange",
    Tab4 = "tab_icon_enchantment-transfer"
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

function EnchantNewCombineView:InitView()
  EnchantNewCombineView.super.InitView(self)
  self.shopEnterBtn = self:FindGO("ShopEnter")
  self.shopEnterBtn:SetActive(true)
  self:AddClickEvent(self.shopEnterBtn, function()
    self:JumpPanel(5)
  end)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion
  self.isFromBag = self.viewdata.viewdata and self.viewdata.viewdata.isFromBag
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.closeBtn = self:FindGO("CloseButton")
  self.closeBtn:SetActive(not self.isCombine)
end

function EnchantNewCombineView:JumpPanel(tabIndex)
  if self.customTabs then
    local panel = self.customTabs[tabIndex].panel
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    self:_JumpPanel(panel.class, viewdata)
  else
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    if tabIndex == 1 then
      self:SetStackViewIndex(1)
      self:_JumpPanel("EnchantNewView", viewdata)
      self.viewdata.viewdata.OnClickChooseBordCell_data = nil
    elseif tabIndex == 2 then
      self:SetStackViewIndex(2)
      self:_JumpPanel("EnchantAttrUpView", viewdata)
    elseif tabIndex == 3 then
      self:SetStackViewIndex(3)
      self:_JumpPanel("EnchantThirdAttrResetView", viewdata)
    elseif tabIndex == 4 then
      self:SetStackViewIndex(4)
      self:_JumpPanel("EnchantTransferView", {
        isFromHomeWorkbench = true,
        npcdata = self.npcData,
        isCombine = true,
        isnew = true
      })
    elseif tabIndex == 5 then
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      local callbackList = {
        {
          func = function()
            GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
              viewname = "EquipIntegrateView"
            })
          end
        }
      }
      HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
      FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
        npcdata = self.npcData,
        callbackList = callbackList
      })
    end
  end
end

function EnchantNewCombineView:ResetLockedAdvanceCost()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.lockedAdvanceCost then
    self.viewdata.viewdata.lockedAdvanceCost = nil
  end
end

function EnchantNewCombineView:OnEnter()
  EnchantNewCombineView.super.super.OnEnter(self)
  self:TabChangeHandler(self.index)
  EventManager.Me():AddEventListener(EnchantEvent.ReturnToReset, self.ReturnToResetView, self)
  EventManager.Me():AddEventListener(EnchantEvent.ResetLockedAdvCost, self.ResetLockedAdvanceCost, self)
end

function EnchantNewCombineView:CloseSelf()
  EnchantNewCombineView.super.CloseSelf(self)
end

function EnchantNewCombineView:OnExit()
  EnchantNewCombineView.super.super.OnExit(self)
  if self.viewdata.viewdata and self.viewdata.viewdata.tabs then
    for i = 1, #self.viewdata.viewdata.tabs do
      local panel = self.viewdata.viewdata.tabs[i]
      self:sendNotification(UIEvent.CloseUI, {
        className = panel.class,
        needRollBack = false
      })
    end
  else
    EventManager.Me():RemoveEventListener(EnchantEvent.ReturnToReset, self.ReturnToResetView, self)
    EventManager.Me():RemoveEventListener(EnchantEvent.ResetLockedAdvCost, self.ResetLockedAdvanceCost, self)
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
  end
end

EnchantIntegerCombineView = class("EnchantIntegerCombineView", EnchantNewCombineView)

function EnchantIntegerCombineView:JumpPanel(tabIndex)
  if self.customTabs then
    local panel = self.customTabs[tabIndex].panel
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    self:_JumpPanel(panel.class, viewdata)
  else
    local viewdata = {}
    if self.viewdata and self.viewdata.viewdata then
      TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
    end
    if tabIndex == 1 then
      self:SetStackViewIndex(1)
      self:_JumpPanel("EnchantSubView", viewdata)
      self.viewdata.viewdata.OnClickChooseBordCell_data = nil
    elseif tabIndex == 2 then
      self:SetStackViewIndex(2)
      self:_JumpPanel("EnchantAttrUpSubView", viewdata)
    elseif tabIndex == 3 then
      self:SetStackViewIndex(3)
      self:_JumpPanel("EnchantThirdAttrResetSubView", viewdata)
    elseif tabIndex == 4 then
      self:SetStackViewIndex(4)
      self:_JumpPanel("EnchantTransferSubView", {
        isFromHomeWorkbench = true,
        npcdata = self.npcData,
        isCombine = true,
        isnew = true
      })
    elseif tabIndex == 5 then
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
      local callbackList = {
        {
          func = function()
            GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
              viewname = "EquipIntegrateView"
            })
          end
        }
      }
      HappyShopProxy.Instance:InitShop(self.npcData, 1, 850)
      FunctionNpcFunc.JumpPanel(PanelConfig.HappyShop, {
        npcdata = self.npcData,
        callbackList = callbackList
      })
    end
  end
end

function EnchantIntegerCombineView:OnExit()
  EnchantIntegerCombineView.super.super.OnExit(self)
  if self.viewdata.viewdata and self.viewdata.viewdata.tabs then
    for i = 1, #self.viewdata.viewdata.tabs do
      local panel = self.viewdata.viewdata.tabs[i]
      self:sendNotification(UIEvent.CloseUI, {
        className = panel.class,
        needRollBack = false
      })
    end
  else
    EventManager.Me():RemoveEventListener(EnchantEvent.ReturnToReset, self.ReturnToResetView, self)
    EventManager.Me():RemoveEventListener(EnchantEvent.ResetLockedAdvCost, self.ResetLockedAdvanceCost, self)
    self:sendNotification(UIEvent.CloseUI, {
      className = "EnchantSubView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EnchantAttrUpSubView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EnchantThirdAttrResetSubView",
      needRollBack = false
    })
    self:sendNotification(UIEvent.CloseUI, {
      className = "EnchantTransferSubView",
      needRollBack = false
    })
  end
end
