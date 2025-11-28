autoImport("LotteryRecoverCombineCell")
autoImport("RecoveryPreviewCell")
HeadWearRecoverView = class("HeadWearRecoverView", ContainerView)
HeadWearRecoverView.ViewType = UIViewType.NormalLayer
local serverItems = {}
local wrapConfig = {}

function HeadWearRecoverView:OnEnter()
  HeadWearRecoverView.super.OnEnter(self)
  self:NormalCameraFaceTo()
end

function HeadWearRecoverView:OnExit()
  LotteryProxy.Instance:SetIsOpenView(false)
  self:CameraReset()
  HeadWearRecoverView.super.OnExit(self)
end

function HeadWearRecoverView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function HeadWearRecoverView:FindObjs()
  self.money = self:FindGO("Money"):GetComponent(UILabel)
  self.cost = self:FindGO("Cost"):GetComponent(UILabel)
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  self.recoverRoot = self:FindGO("RecoverRoot")
  self.recoverEmpty = self:FindGO("RecoverEmpty")
  self.recoverTotalLabel = self:FindGO("RecoverTotalLabel"):GetComponent(UILabel)
  self.recoverLabel = self:FindGO("RecoverLabel"):GetComponent(UILabel)
  self.recoverBtn = self:FindGO("RecoverBtn"):GetComponent(UIMultiSprite)
  self.recoveryGetPreview = self:FindGO("RecoveryGetPreview")
  self.recoveryGetPreview:SetActive(false)
  self.recoveryGetGrid = self:FindGO("Grid", self.recoveryGetPreview):GetComponent(UIGrid)
  self.recoveryGetCtrl = UIGridListCtrl.new(self.recoveryGetGrid, RecoveryPreviewCell, "RecoveryPreviewCell")
end

function HeadWearRecoverView:AddEvts()
  self:AddClickEvent(self.recoverBtn.gameObject, function()
    self:Recover()
  end)
end

function HeadWearRecoverView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateRecover)
end

function HeadWearRecoverView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.recoverSelect = {}
  local npcdata = self:GetNpcDataFromViewData()
  self.npcId = npcdata == nil and 0 or npcdata.data.id
  local moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  local lotteryIcon = self:FindGO("LotteryIcon"):GetComponent(UISprite)
  local lotteryTenIcon = self:FindGO("LotteryTenIcon")
  lotteryTenIcon = lotteryTenIcon and lotteryTenIcon:GetComponent(UISprite)
  local money = Table_Item[GameConfig.MoneyId.Lottery]
  if money then
    local icon = money.Icon
    if icon then
      IconManager:SetItemIcon(icon, moneyIcon)
      IconManager:SetItemIcon(icon, lotteryIcon)
      if lotteryTenIcon then
        IconManager:SetItemIcon(icon, lotteryTenIcon)
      end
    end
  end
  self:UpdateMoney()
  self.lotteryType = LotteryType.Head
  local container = self:FindGO("RecoverContainer")
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = container
  wrapConfig.pfbNum = 5
  wrapConfig.cellName = "LotteryRecoverCombineCell"
  wrapConfig.control = LotteryRecoverCombineCell
  wrapConfig.dir = 1
  self.recoverHelper = WrapCellHelper.new(wrapConfig)
  self.recoverHelper:AddEventListener(MouseEvent.MouseClick, self.ClickRecover, self)
  self.recoverHelper:AddEventListener(LotteryEvent.Select, self.SelectRecover, self)
  self:InitTicket()
  self:InitRecover()
  self:UpdateRecover()
end

function HeadWearRecoverView:InitTicket()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local ticketIcon = self:FindGO("TicketIcon"):GetComponent(UISprite)
    local ticketCostIcon = self:FindGO("TicketCostIcon"):GetComponent(UISprite)
    local ticket = Table_Item[Ticket.itemid]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, ticketIcon)
      IconManager:SetItemIcon(ticket.Icon, ticketCostIcon)
      self.ticketName = ticket.NameZh
    end
  end
end

function HeadWearRecoverView:InitRecover()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    local recoverIcon = self:FindGO("RecoverIcon"):GetComponent(UISprite)
    local toRecoverIcon = self:FindGO("ToRecoverIcon"):GetComponent(UISprite)
    local recoverTitle = self:FindGO("RecoverTitle"):GetComponent(UILabel)
    local rItemId = Ticket.itemid
    rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
    local ticket = Table_Item[rItemId]
    if ticket then
      IconManager:SetItemIcon(ticket.Icon, recoverIcon)
      IconManager:SetItemIcon(ticket.Icon, toRecoverIcon)
      recoverTitle.text = ZhString.Lottery_HeadwearRecoveryTitle
    end
  end
end

function HeadWearRecoverView:UpdateRecover()
  local data = LotteryProxy.Instance:GetFixedHeadwearRecover()
  if data then
    local newData = self:ReUniteCellData(data, 3)
    self.recoverHelper:UpdateInfo(newData)
    self.recoverHelper:ResetPosition()
    self.recoverEmpty:SetActive(#data == 0)
  end
  TableUtility.ArrayClear(self.recoverSelect)
  self:UpdateRecoverBtn()
  self:UpdateTicket()
end

function HeadWearRecoverView:UpdateRecoverBtn()
  local list = LotteryProxy.Instance:GetHeadwearRepairRecover(self.recoverSelect)
  local recoverList = {}
  if list then
    for k, v in pairs(list) do
      local data = {costItem = k, totalCost = v}
      table.insert(recoverList, data)
    end
  end
  self.recoveryGetPreview:SetActive(0 < #recoverList)
  self.recoveryGetCtrl:ResetDatas(recoverList)
  self.canRecover = #self.recoverSelect > 0
  if self.canRecover then
    self.recoverBtn.CurrentState = 0
    self.recoverLabel.effectStyle = UILabel.Effect.Outline
  else
    self.recoverBtn.CurrentState = 1
    self.recoverLabel.effectStyle = UILabel.Effect.None
  end
end

function HeadWearRecoverView:UpdateTicket()
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  if Ticket then
    self.ticket.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(Ticket.itemid))
  end
end

function HeadWearRecoverView:ClickRecover(cell)
  local data = cell.data
  if data then
    self:_SelectCount(cell, 1)
  end
end

function HeadWearRecoverView:SelectRecover(cell)
  local data = cell.data
  if data then
    self:_SelectCount(cell, -1)
  end
end

function HeadWearRecoverView:_SelectCount(cell, offset)
  local data = cell.data
  local originalCount = data.selectCount
  cell:SelectCount(offset)
  if originalCount == 0 and data.selectCount > 0 then
    TableUtility.ArrayPushBack(self.recoverSelect, data.itemData.id)
  elseif 0 < originalCount and data.selectCount == 0 then
    TableUtility.ArrayRemove(self.recoverSelect, data.itemData.id)
  end
  self:UpdateRecoverBtn()
end

function HeadWearRecoverView:Recover()
  local ticketName = self.ticketName
  local Ticket = GameConfig.Lottery.Ticket[self.lotteryType]
  local rItemId = Ticket.recoverItemId ~= nil and Ticket.recoverItemId or Ticket.itemid
  ticketName = Table_Item[rItemId].NameZh
  if self.canRecover then
    local isExist, ticketCount = LotteryProxy.Instance:GetSpecialHeadwearEquipCount(self.recoverSelect)
    if isExist then
      MsgManager.DontAgainConfirmMsgByID(3556, function()
        self:CheckRecover()
        helplog("CallLotteryHeadwearExchange")
        ServiceItemProxy.Instance:CallLotteryHeadwearExchange(self:_GetRecoverList(), nil, self.lotteryType)
      end, nil, nil, LotteryProxy.Instance:GetHeadwearRecoverTotalPrice(self.recoverSelect, self.lotteryType), ticketName, ticketCount, ticketName)
    else
      MsgManager.ConfirmMsgByID(3552, function()
        self:CheckRecover()
        helplog("CallLotteryHeadwearExchange")
        ServiceItemProxy.Instance:CallLotteryHeadwearExchange(self:_GetRecoverList(), nil, self.lotteryType)
      end, nil, nil, LotteryProxy.Instance:GetHeadwearRecoverTotalPrice(self.recoverSelect, self.lotteryType), ticketName)
    end
  end
end

function HeadWearRecoverView:CheckRecover()
  local bagData = BagProxy.Instance.bagData
  if not bagData:IsFull() then
    self.isRecover = true
  end
end

function HeadWearRecoverView:_GetRecoverList()
  TableUtility.ArrayClear(serverItems)
  local _LotteryProxy = LotteryProxy.Instance
  local id, data
  for i = 1, #self.recoverSelect do
    id = self.recoverSelect[i]
    data = _LotteryProxy:GetHeadwearRecoverData(id)
    if data ~= nil then
      local sitem = NetConfig.PBC and {} or SceneItem_pb.SItem()
      sitem.guid = id
      sitem.count = data.selectCount
      serverItems[#serverItems + 1] = sitem
    end
  end
  return serverItems
end

function HeadWearRecoverView:UpdateMoney()
  if self.money ~= nil then
    self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
  end
end

function HeadWearRecoverView:NormalCameraFaceTo()
  local npcdata = self:GetNpcDataFromViewData()
  if npcdata then
    local viewPort = CameraConfig.Lottery_ViewPort
    local rotation = CameraConfig.Lottery_Rotation
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end

function HeadWearRecoverView:GetNpcDataFromViewData()
  local viewdata = self.viewdata.viewdata
  if not viewdata or type(viewdata) ~= "table" then
    return nil
  end
  return viewdata.npcdata
end

function HeadWearRecoverView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
