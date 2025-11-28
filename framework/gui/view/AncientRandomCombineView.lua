autoImport("EnchantCombineView")
AncientRandomCombineView = class("AncientRandomCombineView", EnchantCombineView)
AncientRandomCombineView.ViewType = UIViewType.NormalLayer

function AncientRandomCombineView:InitConfig()
  self.TabGOName = {
    "EnchantTab",
    "EnchantAttrUp"
  }
  self.TabIconMap = {
    EnchantTab = "tab_icon_random",
    EnchantAttrUp = "tab_icon_153"
  }
  self.TabName = {
    ZhString.AncientRandom_RandomTab,
    ZhString.AncientUpgrade_MainTab
  }
  self.TabViewList = {
    PanelConfig.AncientRandomPanel,
    PanelConfig.AncientUpgradePanel
  }
end

function AncientRandomCombineView:InitView()
  AncientRandomCombineView.super.InitView(self)
  self:AddClickEvent(self.shopEnterBtn, function()
    self:JumpPanel(998)
  end)
end

function AncientRandomCombineView:JumpPanel(tabIndex)
  local contextData
  if self.viewdata.viewdata and self.viewdata.viewdata.OnClickChooseBordCell_data then
    contextData = self.viewdata.viewdata.OnClickChooseBordCell_data
    self.viewdata.viewdata.OnClickChooseBordCell_data = nil
  end
  if self.refinePanel and self.refinePanel.bord_Control then
    local nowData = self.refinePanel.bord_Control:GetNowItemData()
    if nowData then
      contextData = nowData
    end
  end
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("AncientRandomPanel", {
      npcdata = self.npcData,
      isCombine = true,
      OnClickChooseBordCell_data = contextData,
      CombineView = self
    })
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("AncientUpgradePanel", {
      npcdata = self.npcData,
      isCombine = true,
      OnClickChooseBordCell_data = contextData,
      CombineView = self
    })
  elseif tabIndex == 998 and self.refinePanel and self.refinePanel.bord_Control then
    local nowData = self.refinePanel.bord_Control:GetNowItemData()
    self.OnClickChooseBordCell_nowData = nowData
    local nowEquipData = nowData and nowData.equipInfo and nowData.equipInfo.equipData
    local shopType = 390
    if nowEquipData and nowEquipData.NewEquipRefine > 0 then
      shopType = nowEquipData.Spirit == 1 and 391 or 390
    end
    local npcFunctionData = Table_NpcFunction[shopType]
    if npcFunctionData ~= nil then
      FunctionNpcFunc.Me():DoNpcFunc(npcFunctionData, self.npcData, 1)
    end
  end
end

function AncientRandomCombineView:OnExit()
  AncientRandomCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "AncientRandomPanel",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "AncientUpgradePanel",
    needRollBack = false
  })
end
