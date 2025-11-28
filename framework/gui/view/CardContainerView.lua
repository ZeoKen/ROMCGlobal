autoImport("CardDecomposeNewPage")
autoImport("CardRandomMakeNewPage")
autoImport("BossCardComposeNewPage")
autoImport("CardMakeNewPage")
autoImport("MvpCardComposeNewPage")
autoImport("CardTabCell")
autoImport("DungeonMvpCardComposeNewPage")
autoImport("CardUpgradePage")
CardContainerView = class("CardContainerView", ContainerView)
CardContainerView.ViewType = UIViewType.NormalLayer
local SubViewEnum = {
  CARDMAKE = 1701,
  BOSSCARDCOMPOSE = 1703,
  MVPCARDCOMPOSE = 1704,
  CARDRANDOMMAKE = 1700,
  CARDDECOMPOSE = 1702,
  DUNGEONMVPCARDCOMPOSE = 1705,
  CARDUPGRADE = 1706
}

function CardContainerView:Init()
  self.npcId = self.viewdata.viewdata.npcdata.data.id
  self.npcFunction = self.viewdata.viewdata.npcdata.data.staticData.NpcFunction
  self.tabIndex = self.viewdata.viewdata.tabIndex
  self.subViews = {}
  self:FindObjs()
  self:AddViewEvts()
  if self.tabIndex ~= SubViewEnum.CARDUPGRADE then
    ServiceItemProxy.Instance:CallQueryBossCardComposeRateCmd()
  end
end

function CardContainerView:FindObjs()
  self.container = self:FindGO("Container")
  self.tabs = {}
  self.toggles = {}
  self.sps = {}
  local grid = self:FindComponent("Grid", UIGrid)
  self.tabList = UIGridListCtrl.new(grid, CardTabCell, "CardTabCell")
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self.skipBtn = self:FindComponent("skipBtn", UISprite)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:OnSkip()
  end)
  local beforePanel = self:FindComponent("BeforePanel", UIPanel)
  local parentPanel = self.gameObject:GetComponent(UIPanel)
  beforePanel.depth = beforePanel.depth + parentPanel.depth
end

function CardContainerView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTotalCost)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemExchangeCardItemCmd, self.HandleExchangeCardItem)
  self:AddListenEvt(ServiceEvent.RecordTradeQueryItemPriceRecordTradeCmd, self.OnTradeReqPrice)
  self:AddListenEvt(ServiceEvent.ItemQueryBossCardComposeRateCmd, self.OnBossCardRateQuery)
end

function CardContainerView:TabChangeHandler(key)
  if not key then
    return
  end
  if self.curTab == key then
    return
  end
  self.curTab = key
  local cells = self.tabList:GetCells()
  if not self.subViews[key] and cells[key] then
    local id = cells[key].id
    if id == SubViewEnum.CARDMAKE then
      self.subViews[key] = self:AddSubView("CardMakeNewPage", CardMakeNewPage, id)
    elseif id == SubViewEnum.BOSSCARDCOMPOSE then
      self.subViews[key] = self:AddSubView("BossCardComposeNewPage", BossCardComposeNewPage, id)
    elseif id == SubViewEnum.CARDRANDOMMAKE then
      self.subViews[key] = self:AddSubView("CardRandomMakeNewPage", CardRandomMakeNewPage, id)
    elseif id == SubViewEnum.CARDDECOMPOSE then
      self.subViews[key] = self:AddSubView("CardDecomposeNewPage", CardDecomposeNewPage, id)
    elseif id == SubViewEnum.MVPCARDCOMPOSE then
      self.subViews[key] = self:AddSubView("MvpCardComposeNewPage", MvpCardComposeNewPage, id)
    elseif id == SubViewEnum.DUNGEONMVPCARDCOMPOSE then
      self.subViews[key] = self:AddSubView("DungeonMvpCardComposeNewPage", DungeonMvpCardComposeNewPage, id)
    elseif id == SubViewEnum.CARDUPGRADE then
      self.subViews[key] = self:AddSubView("CardUpgradePage", CardUpgradePage, id)
    end
  elseif self.subViews[key] then
    self.subViews[key]:Show()
  end
  for k, subView in pairs(self.subViews) do
    if k ~= key then
      subView:Hide()
    end
  end
  cells[key].toggle.value = true
  local skipType = self.subViews[key].skipType
  self.skipBtn.gameObject:SetActive(skipType ~= nil)
end

local skipTipOffset = {-100, 50}

function CardContainerView:OnSkip()
  local skipType = self.subViews[self.curTab].skipType
  TipManager.Instance:ShowSkipAnimationTip(skipType, self.skipBtn, NGUIUtil.AnchorSide.Left, skipTipOffset)
end

function CardContainerView:OnEnter()
  CardContainerView.super.OnEnter(self)
  if self.tabIndex == SubViewEnum.CARDUPGRADE then
    self:InitTabList()
  end
end

function CardContainerView:UpdateTotalCost()
  local cells = self.tabList:GetCells()
  if self.curTab and cells[self.curTab] then
    local id = cells[self.curTab].id
    if id == SubViewEnum.CARDDECOMPOSE then
      self.subViews[self.curTab]:UpdateTotalCost()
    end
  end
end

function CardContainerView:HandleItemUpdate()
  for _, subView in pairs(self.subViews) do
    subView:HandleItemUpdate()
  end
end

function CardContainerView:HandleExchangeCardItem(note)
  local data = note.body
  if data ~= nil and data.charid == Game.Myself.data.id then
    local skipType = self.subViews[self.curTab].skipType
    if not skipType then
      self:CloseSelf()
      return
    end
    local value = LocalSaveProxy.Instance:GetSkipAnimation(skipType)
    if not value then
      self:CloseSelf()
    end
  end
end

function CardContainerView:OnTradeReqPrice(note)
  local cells = self.tabList:GetCells()
  local id = cells[self.curTab].id
  if id == SubViewEnum.CARDDECOMPOSE or id == SubViewEnum.CARDRANDOMMAKE then
    self.subViews[self.curTab]:OnTradeReqPrice(note)
  end
end

function CardContainerView:OnBossCardRateQuery(note)
  self:InitTabList()
  local cells = self.tabList:GetCells()
  local id = cells[self.curTab].id
  if id == SubViewEnum.BOSSCARDCOMPOSE or id == SubViewEnum.MVPCARDCOMPOSE or id == SubViewEnum.DUNGEONMVPCARDCOMPOSE then
    self.subViews[self.curTab]:InitCardList()
  end
  for i = 1, #cells do
    cells[i]:CheckRateUp()
  end
end

function CardContainerView:InitTabList()
  if self.npcFunction then
    local datas = ReusableTable.CreateArray()
    for i = 1, #self.npcFunction do
      local func = self.npcFunction[i]
      local id = func.type
      if 1 < id and (id ~= SubViewEnum.DUNGEONMVPCARDCOMPOSE or CardMakeProxy.Instance:IsHaveUpRateCards(CardMakeProxy.MakeType.DungeonMvpCardCompose)) then
        datas[#datas + 1] = id
      end
    end
    self.tabList:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
  end
  local tabId = self.tabIndex or SubViewEnum.CARDRANDOMMAKE
  local tab = 1
  local cells = self.tabList:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    self:AddTabChangeEvent(cell.gameObject, nil, i)
    if tabId == cell.id then
      tab = i
    end
  end
  self:TabChangeHandler(tab)
end
