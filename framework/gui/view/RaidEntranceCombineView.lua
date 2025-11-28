autoImport("CommonCombineView")
RaidEntranceCombineView = class("RaidEntranceCombineView", CommonCombineView)
RaidEntranceCombineView.ViewType = UIViewType.NormalLayer
local fkCfg = {
  PveView = {
    name = ZhString.EquipUpgradePopUp_Upgrade,
    icon = "tab_btn_icon_zhuangbeishegnji"
  },
  RoadOfHeroView = {
    name = ZhString.EquipMake_Name,
    icon = "tab_btn_icon_zhuangbeizhizuo_"
  }
}

function RaidEntranceCombineView:InitConfig()
  self.TabGOName = {"Tab1", "Tab2"}
  self.TabIconMap = {
    Tab1 = "tab_icon_enchant",
    Tab2 = "tab_icon_enchantUp"
  }
  self.TabName = {
    ZhString.PvpTypeName_Default,
    ZhString.RoadOfHero_Name
  }
  self.TabViewList = {
    PanelConfig.PveView,
    PanelConfig.RoadOfHeroView
  }
end

function RaidEntranceCombineView:InitView()
  RaidEntranceCombineView.super.InitView(self)
  self:AddListenEvt(UICloseEvent.CloseSubView, self.CloseSelf, self)
end

function RaidEntranceCombineView:JumpPanel(tabIndex)
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
      viewdata.isCombine = true
      self:_JumpPanel("PveView", viewdata)
    elseif tabIndex == 2 then
      self:SetStackViewIndex(2)
      viewdata.isCombine = true
      self:_JumpPanel("RoadOfHeroView", viewdata)
    end
  end
end

function RaidEntranceCombineView:OnEnter()
  RaidEntranceCombineView.super.super.OnEnter(self)
  self:TabChangeHandler(self.index or 1)
  EventManager.Me():AddEventListener(EnchantEvent.ReturnToReset, self.ReturnToResetView, self)
  EventManager.Me():AddEventListener(EnchantEvent.ResetLockedAdvCost, self.ResetLockedAdvanceCost, self)
end

function RaidEntranceCombineView:CloseSelf()
  RaidEntranceCombineView.super.CloseSelf(self)
end

function RaidEntranceCombineView:OnExit()
  RaidEntranceCombineView.super.super.OnExit(self)
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
    self:sendNotification(UIEvent.CloseUI, {className = "PveView", needRollBack = false})
    self:sendNotification(UIEvent.CloseUI, {
      className = "RoadOfHeroView",
      needRollBack = false
    })
  end
end

function RaidEntranceCombineView:OnExitView(note)
  local viewCtrl = note.data
  if not viewCtrl then
    return
  end
  local viewName = viewCtrl.__cname
  if fkCfg[viewName] then
    self:CloseSelf()
  end
end
