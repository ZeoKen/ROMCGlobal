autoImport("NewRechargeHeroToggleCell")
autoImport("NewRechargeHeroCell")
autoImport("WrapInfiniteListCtrl")
NewRechargeHeroSubView = class("NewRechargeHeroSubView", SubView)
local hero_ticket_shop = GameConfig.Profession.hero_ticket_shop or {
  812,
  1,
  56596
}

function NewRechargeHeroSubView:ctor(container, initParama, subViewData)
  self.container = container
  if self.container then
    self.viewdata = self.container.viewdata
  end
  self.profId = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.profId or self.viewdata.viewdata.profIdOnce
  self.subViewData = subViewData
  self.gameObject = self:LoadPreferb("part/NewRechargeHeroSubView", container.gameObject, true)
  self.trans = self.gameObject.transform
  self.effectCache = {}
  self:InitSubView(initParama)
  self:InitListenEvts()
end

function NewRechargeHeroSubView:InitSubView(initParama)
  self.scrollViewGO = self:FindGO("mainpage/scrollview")
  self.scrollView = self.scrollViewGO:GetComponent(UIScrollView)
  self.scrollPanel = self.scrollView.panel
  local grid = self:FindComponent("mainpage/scrollview/grid", UIGrid)
  self.pageCtrl = UIGridListCtrl.new(grid, NewRechargeHeroCell, "NewRechargeHeroCell")
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.PreView, self.OnClickCellPreview, self)
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.Buy, self.OnClickCellBuy, self)
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.More, self.OnClickCellMore, self)
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.ClickItem1, self.OnClickCellClickItem1, self)
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.ClickItem2, self.OnClickCellClickItem2, self)
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.GetTimeOut, self.OnHeroGetTimeOut, self)
  self.pageCtrl:AddEventListener(NewRechargeHeroCell_Event.ToPack, self.OnClickCellToPack, self)
  self.beforePanelGO = self:FindGO("beforepanel")
  self.beforePanel = self.beforePanelGO:GetComponent(UIPanel)
end

function NewRechargeHeroSubView:OnHeroGetTimeOut()
  self:UpdateCtrls(false)
end

function NewRechargeHeroSubView:InitCellVideoUpdate()
  if self.videoUpdateInited then
    return
  end
  self.videoUpdateInited = true
  local dir = 1
  
  function self.scrollPanel.onClipMove()
    if not (self.viewActive and self.pageCtrl) or not self.scrollViewCenterX then
      return
    end
    local clipOffsetX = self.scrollPanel.clipOffset[1]
    if self.lastClipOffsetX then
      dir = clipOffsetX > self.lastClipOffsetX and -1 or 1
    end
    local cells = self.pageCtrl:GetCells()
    local activeCell
    local autoStart = false
    if dir == 1 then
      for i = #cells, 1, -1 do
        videoGOX = NGUIUtil.GetUIPositionXYZ(cells[i].videoGO)
        videoGOX = videoGOX - 245
        autoStart = i <= 3
        if videoGOX <= self.scrollViewLeftX then
          cells[i]:OpenVideo(autoStart)
        end
        if videoGOX <= self.scrollViewCenterX + 100 then
          activeCell = cells[i]
          break
        end
      end
    else
      for i = 1, #cells do
        videoGOX = NGUIUtil.GetUIPositionXYZ(cells[i].videoGO)
        videoGOX = videoGOX + 245
        if videoGOX >= self.scrollViewCenterX - 100 then
          activeCell = cells[i]
          break
        end
      end
    end
    if activeCell and self.nowAciveCell ~= activeCell then
      if self.nowAciveCell then
        self.nowAciveCell:PlayVideo(false)
      end
      if autoStart then
        activeCell:PlayVideo(true)
      end
      self.nowAciveCell = activeCell
    end
  end
end

function NewRechargeHeroSubView:UpdateProgressBar(step)
end

function NewRechargeHeroSubView:OnClickCellPreview(cell)
  ProfessionProxy.Instance:SaveChooseClassID(cell.data.classid)
  ServiceNUserProxy.Instance:CallGoToFunctionMapUserCmd(SceneUser2_pb.EFUNCMAPTYPE_HEROPRO)
  self.parentView:CloseSelf()
end

local GetGainWayItemDatas = function(addway)
  if not addway then
    return
  end
  local retDatas = {}
  for i = 1, #addway do
    local d = GainWayItemCellData.new(addway[i])
    d:ParseSingleNormalGainWay(addway[i])
    table.insert(retDatas, d)
  end
  return retDatas
end
local TicketCheckBags = GameConfig.PackageMaterialCheck.buy_profession

function NewRechargeHeroSubView:OnClickCellBuy(cell)
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
  if cell.data.addway then
    self.bdt = GainWayTip.new(self.beforePanelGO, self.beforePanel.depth + 3)
    self.bdt:SetListDatas(GetGainWayItemDatas(cell.data.addway))
    self.bdt:SetLocalPos(64, 293, 0)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, function()
      self.bdt = nil
    end, self)
    self.bdt:AddIgnoreBounds(cell.buyButton)
    return
  elseif cell.data.helpid then
    self:OpenHelpView(Table_Help[cell.data.helpid])
    return
  end
  local costid = cell.data.costid
  local ticketnum = BagProxy.Instance:GetItemNumByStaticID(costid, TicketCheckBags)
  if 0 < ticketnum then
    local allProfTicket = GameConfig.Profession.hero_ticket_id
    local allProfTicketItem = Table_Item[allProfTicket]
    if allProfTicketItem and 0 < BagProxy.Instance:GetItemNumByStaticID(allProfTicket, TicketCheckBags) then
      local costStr = string.format(ZhString.Friend_RecallRewardItem, 1, allProfTicketItem.NameZh)
      MsgManager.ConfirmMsgByID(9630, function()
        if not ProfessionProxy.CanChangeProfession4NewPVPRule(25389) then
          return
        end
        local tapdbID = self.profId
        if tapdbID then
          FunctionADBuiltInTyrantdb.Instance():SendTrackEvent("#BuyHeroFromStory")
        end
        ServiceSceneUser3Proxy.Instance:CallHeroBuyUserCmd(cell.data.branchId)
        ServiceSceneUser3Proxy.Instance:CallHeroShowUserCmd()
      end, nil, nil, costStr, cell.data.classname)
    end
  else
    local shopData = ShopProxy.Instance:GetShopDataByTypeId(hero_ticket_shop[1], hero_ticket_shop[2])
    local shop_item_data
    if shopData then
      local goods = shopData:GetGoods()
      for k, good in pairs(goods) do
        if good.id == hero_ticket_shop[3] then
          shop_item_data = good
          break
        end
      end
    end
    if self.parentView and shop_item_data then
      NewRechargeProxy.Instance:THero_GetClasstickGoods()
      self.parentView:ShopItemPurchaseDetailCell_Load(shop_item_data)
      HappyShopProxy.Instance:SetSelectId(shop_item_data.id)
    end
  end
end

function NewRechargeHeroSubView:OnClickCellMore(cell)
  self.profId = nil
  SaveInfoProxy.Instance:SetSavedLastBranchID(cell.data.branchId)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MultiProfessionNewView,
    viewdata = {
      tab = 1,
      classShowType = 2,
      fromRechargeHero = cell.data.classid
    }
  })
end

function NewRechargeHeroSubView:OnClickCellClickItem1(cell)
  self:mShowRechargeItemTip(cell.itemIcon1, cell.data.reward[1])
end

function NewRechargeHeroSubView:OnClickCellClickItem2(cell)
  self:mShowRechargeItemTip(cell.itemIcon2, cell.data.reward[2])
end

function NewRechargeHeroSubView:OnClickCellToPack(cell)
  local branchid = cell.data.branchId
  NewRechargeProxy.Instance:SetHotGiftHeroBranchId(branchid)
  autoImport("NewRechargeTHotSubView")
  if NewRechargeProxy.Instance:GetShouldShowHeroGift() then
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THot, NewRechargeTHotSubView.innerTab.HiddenHeroGift)
  else
    local packageInfo = NewRechargeProxy.Instance:GetHeroCombinePackInfo(branchid)
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_THot, NewRechargeTHotSubView.innerTab.MixRecommend, {
      combinePackAdvise = packageInfo.staticData.id
    })
  end
end

function NewRechargeHeroSubView:mShowRechargeItemTip(sp, itemid)
  if sp and itemid then
    local itemData = ItemData.new("Reward", itemid)
    local tipData = {
      itemdata = itemData,
      ignoreBounds = {sp}
    }
    local x, _, _ = NGUIUtil.GetUIPositionXYZ(sp.gameObject)
    if 0 < x then
      self:ShowItemTip(tipData, sp, NGUIUtil.AnchorSide.Left, {-215, 0})
    else
      self:ShowItemTip(tipData, sp, NGUIUtil.AnchorSide.Right, {215, 0})
    end
  end
end

function NewRechargeHeroSubView:InitListenEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3HeroShowUserCmd, self.UpdateCtrls)
  self:AddListenEvt(ServiceEvent.SceneUser3HeroBuyUserCmd, self.OnBuySuccess)
end

function NewRechargeHeroSubView:OnBuySuccess(note)
  local serverData = note.body
  if serverData and serverData.success then
    local mapId = Game.MapManager:GetMapID()
    if mapId and Table_Map[mapId].Type == 6 then
      MsgManager.ConfirmMsgByID(43263, function()
        ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(serverData.branch, true)
      end)
    end
  end
end

function NewRechargeHeroSubView:UpdateCtrls(retPos)
  if not self.viewActive then
    return
  end
  local datas = ProfessionProxy.Instance:GetRechargeHeroList() or {}
  if #datas == 0 then
    self:UpdateProgressBar(#datas)
    self.pageCtrl:ResetDatas(datas)
    return
  end
  self:UpdateProgressBar(#datas)
  self.pageCtrl:ResetDatas(datas)
  local startIndex = 1
  local cells = self.pageCtrl:GetCells()
  if self.profId and cells and 0 < #cells then
    for i = 1, #cells do
      if cells[i].data.classid == self.profId then
        startIndex = i
        break
      end
    end
  end
  self.pageCtrl:ScrollToIndex(startIndex)
  local c1 = cells[1]
  if #datas == 1 then
    self.scrollView.enabled = false
    self.scrollView.restrictWithinPanel = false
    local cors = self.scrollView.panel.worldCorners
    local center = (cors[1] + cors[3]) / 2
    LuaGameObject.SetPositionGO(c1.gameObject, center[1], center[2], center[3])
    local x, y, z = LuaGameObject.GetLocalPositionGO(c1.gameObject)
    LuaGameObject.SetLocalPositionGO(c1.gameObject, x + 12, y, z)
  else
    self.scrollView.enabled = true
    self:InitCellVideoUpdate()
    if retPos == true then
      self.scrollView.restrictWithinPanel = true
      self.scrollView:ResetPosition()
    end
  end
  c1:OpenVideo()
  c1:PlayVideo(true)
  self.nowAciveCell = c1
  if not self.scrollViewCenterX then
    self.scrollViewCenterX, _, _ = NGUIUtil.GetUIPositionXYZ(self.scrollViewGO)
    local viewSize = self.scrollView.panel:GetViewSize()
    self.scrollViewLeftX = self.scrollViewCenterX + viewSize[1] / 2
  end
end

function NewRechargeHeroSubView:OnEnter()
  NewRechargeHeroSubView.super.OnEnter(self)
  NewRechargeProxy.Instance:THero_GetClasstickGoods()
  RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_HEROSHOP)
end

function NewRechargeHeroSubView:RefreshView()
  self:UpdateCtrls(true)
end

function NewRechargeHeroSubView:OnExit()
  self.pageCtrl:RemoveAll()
  if self.profId then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuestTracePanel,
      viewdata = {tabID = 6}
    })
  end
end

function NewRechargeHeroSubView:OnShow()
  self.viewActive = self.gameObject.activeSelf
  if not self.viewActive then
    return
  end
  FunctionBGMCmd.Me():SetMute(true)
  self:RefreshView()
  LocalSaveProxy.Instance:SetRechargeHero_New()
  RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_HEROSHOP)
  if self.parentView and self.parentView.onShowGiftRightDetailView then
    self.parentView:onShowGiftRightDetailView(false)
  end
end

function NewRechargeHeroSubView:OnHide()
  self.viewActive = false
  local cells = self.pageCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:PlayVideo(false)
  end
  if self.nowAciveCell then
    self.nowAciveCell = nil
  end
  FunctionBGMCmd.Me():StopUIBgm()
  FunctionBGMCmd.Me():SetMute(false)
end
