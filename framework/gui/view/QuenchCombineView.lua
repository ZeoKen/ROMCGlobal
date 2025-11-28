autoImport("CommonNewTabListCell")
autoImport("EnchantCombineView")
QuenchCombineView = class("QuenchCombineView", EnchantCombineView)
QuenchCombineView.ViewType = UIViewType.NormalLayer

function QuenchCombineView:InitConfig()
  self.TabGOName = {"EnchantTab"}
  self.TabIconMap = {
    EnchantTab = "anying_page_icon"
  }
  self.TabName = {
    ZhString.EquipQuench_Title
  }
  self.TabViewList = {
    PanelConfig.EquipQuenchView
  }
  self.TabType = {1}
end

function QuenchCombineView:InitView()
  QuenchCombineView.super.InitView(self)
  self.shopEnterBtn:SetActive(false)
end

function QuenchCombineView:JumpPanel(tabIndex)
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("EquipQuenchView", {
      npcdata = self.npcData,
      isCombine = true,
      OnClickChooseBordCell_data = self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data
    })
  end
end

function QuenchCombineView:OnExit()
  QuenchCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "EquipQuenchView",
    needRollBack = false
  })
end
