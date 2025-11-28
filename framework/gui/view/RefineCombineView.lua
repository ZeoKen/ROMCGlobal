autoImport("EnchantCombineView")
RefineCombineView = class("RefineCombineView", EnchantCombineView)
RefineCombineView.ViewType = UIViewType.NormalLayer

function RefineCombineView:InitConfig()
  self.TabGOName = {
    "RefineTab",
    "BatchTab",
    "TransferTab"
  }
  self.TabIconMap = {
    RefineTab = "tab_icon_86",
    BatchTab = "tab_icon_87",
    TransferTab = "tab_icon_Refinery-transfer"
  }
  self.TabName = {
    ZhString.RefineCombineView_RefineTab,
    ZhString.RefineCombineView_RefineBatchTab,
    ZhString.RefineCombineView_RefineTransferTab
  }
  self.TabViewList = {
    PanelConfig.NpcRefinePanel,
    PanelConfig.NpcRefineBatchPanel,
    PanelConfig.RefineTransferView
  }
  if FunctionUnLockFunc.CheckForbiddenByFuncState("refine_transfer_forbidden") then
    local tabObj = self:FindGO(self.TabGOName[3])
    if tabObj then
      self:Hide(tabObj)
    end
    self.TabGOName[3] = nil
    self.TabIconMap[3] = nil
    self.TabName[3] = nil
    self.TabViewList[3] = nil
  end
end

function RefineCombineView:InitView()
  RefineCombineView.super.InitView(self)
  self.isfashion = self.viewdata.viewdata and self.viewdata.viewdata.isfashion
  self.isFromBag = self.viewdata.viewdata and self.viewdata.viewdata.isFromBag
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.closeBtn = self:FindGO("CloseButton")
  self.closeBtn:SetActive(not self.isCombine)
  if self.isfashion then
    if self.cells[3] then
      self.cells[3]:Hide()
    end
    if self.isFromBag and self.cells[2] then
      self.cells[2]:Hide()
    end
  end
  self.grid:Reposition()
  if self.shopEnterBtn then
    if self.isfashion and self.isFromBag then
      self.shopEnterBtn:SetActive(false)
    else
      self.shopEnterBtn:SetActive(true)
      self:AddClickEvent(self.shopEnterBtn, function()
        self:JumpPanel(4)
      end)
    end
  end
end

function RefineCombineView:JumpPanel(tabIndex)
  local viewdata = self.viewdata.viewdata
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("NpcRefinePanel", {
      npcdata = self.npcData,
      isCombine = true,
      isfashion = viewdata and viewdata.isfashion,
      isFromBag = viewdata and viewdata.isFromBag,
      OnClickChooseBordCell_data = viewdata and viewdata.OnClickChooseBordCell_data,
      selectTicket = viewdata and viewdata.selectTicket
    })
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("NpcRefinePanel", {
      npcdata = self.npcData,
      isfashion = viewdata and viewdata.isfashion,
      isFromBag = viewdata and viewdata.isFromBag,
      isCombine = true,
      isOneClick = true,
      OnClickChooseBordCell_data = viewdata and viewdata.OnClickChooseBordCell_data
    })
  elseif tabIndex == 3 then
    self:_JumpPanel("RefineTransferView", {
      npcdata = self.npcData,
      isfashion = viewdata and viewdata.isfashion,
      isFromBag = viewdata and viewdata.isFromBag,
      isCombine = true
    })
  elseif tabIndex == 4 then
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

function RefineCombineView:OnExit()
  RefineCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "NpcRefinePanel",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "RefineTransferView",
    needRollBack = false
  })
end

RefineIntegerCombineView = class("RefineIntegerCombineView", RefineCombineView)

function RefineIntegerCombineView:JumpPanel(tabIndex)
  local viewdata = self.viewdata.viewdata
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    self:_JumpPanel("NpcRefineSubView", {
      npcdata = self.npcData,
      isCombine = true,
      isfashion = viewdata and viewdata.isfashion,
      isFromBag = viewdata and viewdata.isFromBag,
      OnClickChooseBordCell_data = viewdata and viewdata.OnClickChooseBordCell_data,
      selectTicket = viewdata and viewdata.selectTicket
    })
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    self:_JumpPanel("NpcRefineSubView", {
      npcdata = self.npcData,
      isfashion = viewdata and viewdata.isfashion,
      isFromBag = viewdata and viewdata.isFromBag,
      isCombine = true,
      isOneClick = true,
      OnClickChooseBordCell_data = viewdata and viewdata.OnClickChooseBordCell_data
    })
  elseif tabIndex == 3 then
    self:_JumpPanel("RefineTransferSubView", {
      npcdata = self.npcData,
      isfashion = viewdata and viewdata.isfashion,
      isFromBag = viewdata and viewdata.isFromBag,
      isCombine = true
    })
  elseif tabIndex == 4 then
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

function RefineIntegerCombineView:OnExit()
  RefineIntegerCombineView.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "RefineTransferSubView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "NpcRefineSubView",
    needRollBack = false
  })
end
