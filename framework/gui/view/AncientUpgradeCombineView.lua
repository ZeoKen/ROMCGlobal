autoImport("EnchantCombineView")
AncientUpgradeCombineView = class("AncientUpgradeCombineView", EnchantCombineView)
AncientUpgradeCombineView.ViewType = UIViewType.NormalLayer

function AncientUpgradeCombineView:InitConfig()
  self.TabGOName = {"EnchantTab"}
  self.TabIconMap = {
    EnchantTab = "tab_icon_153"
  }
  self.TabName = {
    ZhString.AncientUpgrade_MainTab
  }
  self.TabViewList = {
    PanelConfig.AncientUpgradePanel
  }
end

function AncientUpgradeCombineView:InitView()
  AncientUpgradeCombineView.super.InitView(self)
  self:AddClickEvent(self.shopEnterBtn, function()
    self:JumpPanel(2)
  end)
end

function AncientUpgradeCombineView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("AncientUpgradePanel", {
      npcdata = self.npcData,
      isCombine = true,
      OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data,
      CombineView = self
    })
  elseif tabIndex == 2 then
  end
end

function AncientUpgradeCombineView:OnExit()
  AncientUpgradeCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "AncientUpgradePanel",
    needRollBack = false
  })
end
