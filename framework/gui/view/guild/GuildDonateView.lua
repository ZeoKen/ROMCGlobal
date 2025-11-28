autoImport("GuildDonateItemCell")
autoImport("GuildDonateMemberCell")
autoImport("ItemCell")
GuildDonateConfirmTip = class("GuildDonateConfirmTip", CoreView)
autoImport("GainWayTip")
GuildDonateConfirmEvent = {
  Confirm = "GuildDonateConfirmEvent_Confirm"
}
local _AE_ExtraMode = ActivityEvent_pb.EAEREWARDMODE_GUILD_DONATE

function GuildDonateConfirmTip:ctor(go)
  GuildDonateConfirmTip.super.ctor(self, go)
  self:Init()
end

function GuildDonateConfirmTip:Init()
  local confirmTipCellGO = self:FindGO("SimpleItem")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:Hide()
  end
  
  self.confirmTipCell = ItemCell.new(confirmTipCellGO)
  self.confirmItemName = self:FindComponent("ItemName", UILabel)
  self.confirmNeedNum = self:FindComponent("NeedNum", UILabel)
  self.confirmHaveNum = self:FindComponent("HaveNum", UILabel)
  self.confirmGuildReward = self:FindComponent("GuildReward", UILabel)
  self.confirmMyReward = self:FindComponent("MyReward", UILabel)
  self.donateButton = self:FindGO("DonateButton")
  self.donateButtonLabel = self:FindComponent("Label", UILabel, self.donateButton)
  self.orderNumLabel = self:FindComponent("OrderNum", UILabel)
  self.orderNum = 1
  self.maxOrderNum = 5
  self.guildItemTotalNeed = 0
  self.plusBtnIcon = self:FindComponent("PlusBtn", UISprite)
  self.plusBtnCollider = self:FindComponent("PlusBtn", BoxCollider)
  self.minusBtnIcon = self:FindComponent("MinusBtn", UISprite)
  self.minusBtnCollider = self:FindComponent("MinusBtn", BoxCollider)
  local addBtn = self:FindGO("PlusBtn")
  self:AddClickEvent(addBtn, function()
    self:AddOrderNum()
  end)
  local minusBtn = self:FindGO("MinusBtn")
  self:AddClickEvent(minusBtn, function()
    self:MinusOrderNum()
  end)
  local getWayButton = self:FindGO("GetWayButton")
  self:AddClickEvent(getWayButton, function(go)
    if self.selectGuildItemData then
      local itemData = ItemData.new("DonateItem", self.selectGuildItemData.itemid)
      self:ShowItemGetWay(itemData)
    end
  end)
  local closeTipButton = self:FindGO("CloseTip")
  self:AddClickEvent(closeTipButton, function(go)
    self:HideItemGetWay()
    self.gameObject:SetActive(false)
  end)
  local confirmButton = self:FindGO("DonateButton")
  self:AddClickEvent(confirmButton, function(go)
    self:PassEvent(GuildDonateConfirmEvent.Confirm)
  end)
  self.gpContainer = self:FindGO("GainWayContainer")
end

function GuildDonateConfirmTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function GuildDonateConfirmTip:SetMaxOrderLimit(guildItemData)
  local maxNum = 0
  local tempdata = guildItemData
  local donateItemList = GuildProxy.Instance:GetGuildDonateItemList() or {}
  for i = 1, #donateItemList do
    local item = donateItemList[i]
    if item.time == tempdata.time and item.itemid == tempdata.itemid then
      maxNum = maxNum + 1
    end
  end
  self.maxOrderNum = maxNum
end

function GuildDonateConfirmTip:SetData(guildItemData)
  self.selectGuildItemData = guildItemData
  if guildItemData then
    local itemData = ItemData.new("DonateItem", guildItemData.itemid)
    self.confirmTipCell:SetData(itemData)
    self.confirmItemName.text = itemData.staticData.NameZh
    local addTimes = self.orderNum - 1
    local needNum = guildItemData.itemcount
    local tempconfigid = guildItemData.configid
    local itemData = guildItemData
    for i = 1, addTimes do
      local tempNextDonateItem = self:SwitchToNextGuildItem(itemData)
      local tempNeedNum = tempNextDonateItem.itemcount
      needNum = needNum + tempNeedNum
      itemData = tempNextDonateItem
    end
    self.guildItemTotalNeed = needNum
    self.confirmNeedNum.text = string.format(ZhString.GuildDonateConfirmTip_NeedNum, needNum)
    local havNum = GuildDonateItemCell.GetDonateItemNum(guildItemData.itemid)
    self.confirmHaveNum.text = string.format(ZhString.GuildDonateConfirmTip_HaveNum, havNum)
    if havNum < self.guildItemTotalNeed then
      self.donateButtonLabel.text = ZhString.GuildDonateConfirmTip_QuickBuy
    else
      self.donateButtonLabel.text = ZhString.GuildDonateConfirmTip_DoDonate
    end
    local detailInfo = FunctionDonateItem.Me():GetDetailInfo(guildItemData.configid)
    local con = detailInfo and detailInfo.con
    local asset = detailInfo and detailInfo.asset
    local newDetailInfo = {}
    newDetailInfo.con = {}
    newDetailInfo.asset = {}
    if con then
      for i = 1, #con do
        local citem = {}
        citem[1] = con[i][1]
        citem[2] = con[i][2]
        table.insert(newDetailInfo.con, citem)
      end
    end
    if asset then
      for i = 1, #asset do
        local citem = {}
        citem[1] = asset[i][1]
        citem[2] = asset[i][2]
        table.insert(newDetailInfo.asset, citem)
      end
    end
    for i = 1, addTimes do
      local tempGuildItemData = guildItemData
      local temp = self:SwitchToNextGuildItem(tempGuildItemData)
      tempGuildItemData = temp
      local nextDetailInfo = FunctionDonateItem.Me():GetDetailInfo(tempGuildItemData.configid)
      local combineResult = self:CombineContributeData(newDetailInfo, nextDetailInfo)
      newDetailInfo = combineResult
    end
    if newDetailInfo then
      self:UpdateConfirmDetailInfo(newDetailInfo)
    else
      self:UpdateConfirmDetailInfo(detailInfo)
    end
  end
end

function GuildDonateConfirmTip:GetSelectedDonateItemAllContributeData()
  if self.selectGuildItemData then
    local donateItemList = GuildProxy.Instance:GetGuildDonateItemList() or {}
    for i = 1, #donateItemList do
      local item = donateItemList[i]
      if item.itemid == self.selectGuildItemData.itemid then
        FunctionDonateItem.Me():GetDetailInfo(item.configid)
      end
    end
  else
    helplog("当前没有选定的捐赠目标")
  end
end

function GuildDonateConfirmTip:SwitchToNextGuildItem(data)
  local tempdata = data
  local donateItemList = GuildProxy.Instance:GetGuildDonateItemList() or {}
  for i = 1, #donateItemList do
    local item = donateItemList[i]
    if item.configid == tempdata.nextconfigid then
      tempdata = item
      break
    end
  end
  return tempdata
end

function GuildDonateConfirmTip:AddOrderNum()
  self.orderNum = self.orderNum + 1
  self.orderNumLabel.text = self.orderNum
  self:SetData(self.selectGuildItemData)
  self:RefreshPlusAndMinusBtn()
end

function GuildDonateConfirmTip:MinusOrderNum()
  self.orderNum = self.orderNum - 1
  self.orderNumLabel.text = self.orderNum
  self:SetData(self.selectGuildItemData)
  self:RefreshPlusAndMinusBtn()
end

function GuildDonateConfirmTip:ResetOrderNum()
  self.orderNum = 1
  self.orderNumLabel.text = self.orderNum
  self:RefreshPlusAndMinusBtn()
end

function GuildDonateConfirmTip:RefreshPlusAndMinusBtn()
  helplog(self.maxOrderNum)
  if self.orderNum == 1 then
    self.minusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.5)
    self.plusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
    self.minusBtnCollider.enabled = false
    self.plusBtnCollider.enabled = true
    if self.maxOrderNum == 1 then
      self.plusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.5)
      self.plusBtnCollider.enabled = false
    end
  elseif self.orderNum == self.maxOrderNum then
    self.plusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 0.5)
    self.minusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
    self.plusBtnCollider.enabled = false
    self.minusBtnCollider.enabled = true
  else
    self.minusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
    self.plusBtnIcon.color = LuaGeometry.GetTempVector4(1, 1, 1, 1)
    self.minusBtnCollider.enabled = true
    self.plusBtnCollider.enabled = true
  end
end

function GuildDonateConfirmTip:CombineContributeData(detailInfo, nextDetailInfo)
  local itemStr = ""
  local con = detailInfo and detailInfo.con
  local nextCon = nextDetailInfo and nextDetailInfo.con
  local newCon = {}
  if con then
    for i = 1, #con do
      local id, count = con[i][1], con[i][2]
      for j = 1, #nextCon do
        local id2, count2 = nextCon[j][1], nextCon[j][2]
        if id2 == id then
          con[i][2] = count + count2
        end
      end
    end
    detailInfo.con = con
  end
  local asset = detailInfo and detailInfo.asset
  local nextAsset = nextDetailInfo and nextDetailInfo.asset
  local newAsset = {}
  if asset then
    for i = 1, #asset do
      local itemId, num = asset[i][1], asset[i][2]
      for j = 1, #nextAsset do
        local itemid2, num2 = nextAsset[j][1], nextAsset[j][2]
        if itemid2 == itemId then
          asset[i][2] = num + num2
        end
      end
    end
    detailInfo.asset = asset
  end
  return detailInfo
end

function GuildDonateConfirmTip:GetGuildDonateItemTotalNeed()
  if self.guildItemTotalNeed then
    return self.guildItemTotalNeed
  else
    helplog("捐赠物品需求总数出错")
    return 0
  end
end

function GuildDonateConfirmTip:GetOrderNum()
  if self.orderNum then
    return self.orderNum
  else
    helplog("捐赠物品数量为空")
    return 1
  end
end

function GuildDonateConfirmTip:UpdateConfirmDetailInfo(detailInfo)
  local asset = detailInfo and detailInfo.asset
  if asset then
    for i = 1, #asset do
      local itemId, num = asset[i][1], asset[i][2]
      if itemId and num then
        local itemStaticData = Table_Item[itemId]
        if itemStaticData then
          self.confirmGuildReward.text = ZhString.GuildDonateConfirmTip_GuildReward .. itemStaticData.NameZh .. "+" .. num
        end
      end
    end
  end
  local itemStr = ""
  local con = detailInfo and detailInfo.con
  if con then
    for i = 1, #con do
      local id, count = con[i][1], con[i][2]
      itemStr = itemStr .. string.format(ZhString.GuildDonateConfirmTip_MyReward, Table_Item[id].NameZh, count)
      if i < #con then
        itemStr = itemStr .. ZhString.GuildDonateConfirmTip_And .. "\n"
      end
    end
  end
  self.confirmMyReward.text = itemStr
end

function GuildDonateConfirmTip:ShowItemGetWay(itemData)
  if not self.bdt then
    self.bdt = GainWayTip.new(self.gpContainer)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, function()
      self.bdt = nil
      self.closecomp:ReCalculateBound()
    end, self)
  end
  self.bdt:SetData(itemData.staticData.id)
  self.bdt:Show()
  self.bdt:AddIgnoreBounds(self.gameObject)
  self:AddIgnoreBounds(self.bdt.gameObject)
end

function GuildDonateConfirmTip:HideItemGetWay()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end

function GuildDonateConfirmTip:Show()
  self.gameObject:SetActive(true)
end

function GuildDonateConfirmTip:Hide()
  self.gameObject:SetActive(false)
  self:HideItemGetWay()
end

GuildDonateView = class("GuildDonateView", ContainerView)
GuildDonateView.ViewType = UIViewType.NormalLayer

function GuildDonateView:Init()
  self:InitView()
  self:MapEvent()
end

function GuildDonateView:InitView()
  local donation = self:FindGO("Donation")
  self.donationlabel = self:FindComponent("Label", UILabel, donation)
  self.donationSp = self:FindComponent("symbol", UISprite, donation)
  IconManager:SetItemIcon("item_140", self.donationSp)
  self.noneTip = self:FindGO("NoneTip")
  self.refreshTimelabel = self:FindComponent("NextRefreshTime", UILabel)
  self.orderCount = self:FindComponent("OrderCount", UILabel)
  self.rankBord = self:FindGO("RankBord")
  self.rankButton = self:FindGO("RankButton")
  self:AddClickEvent(self.rankButton, function(go)
    self.rankBord:SetActive(true)
  end)
  self.donateItemGrid = self:FindComponent("DonateItemGrid", UIGrid)
  self.donateItemCtl = UIGridListCtrl.new(self.donateItemGrid, GuildDonateItemCell, "GuildDonateItemCell")
  self.donateItemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDonateItemCell, self)
  local rankGrid = self:FindComponent("RankGrid", UIGrid)
  self.rankCtl = UIGridListCtrl.new(rankGrid, GuildDonateMemberCell, "GuildDonateMemberCell")
  self.confirmTip = GuildDonateConfirmTip.new(self:FindGO("ConfirmTip"))
  self.confirmTip:AddEventListener(GuildDonateConfirmEvent.Confirm, self.DoDonate, self)
  self:InitExtraActivity()
  self:UpdateDonateItemList()
end

function GuildDonateView:InitExtraActivity()
  self.extraActivityRoot = self:FindGO("ExtraActivityRoot")
  self.donateItemGrid_Scaled_down = self:FindComponent("DonateItemGrid_Scaled_down", UIGrid, self.extraActivityRoot)
  self.extra_donateItemCtl = UIGridListCtrl.new(self.donateItemGrid_Scaled_down, GuildDonateItemCell, "GuildDonateItemCell")
  self.extra_donateItemCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDonateItemCell, self)
  self.extra_limitedLab = self:FindComponent("LimitedLab", UILabel, self.extraActivityRoot)
  self.extraRewardItemRoot = self:FindGO("ExtraRewardItem", self.extraActivityRoot)
  self.extraRewardIcon = self:FindComponent("Icon", UISprite, self.extraRewardItemRoot)
  self:AddClickEvent(self.extraRewardIcon.gameObject, function()
    self:OnClickRewardItem()
  end)
  self.extraRewardCount = self:FindComponent("Num", UILabel, self.extraRewardItemRoot)
  self.extra_descLab = self:FindComponent("DescLab", UILabel, self.extraActivityRoot)
  self.extra_descLab.text = ZhString.GuildDonateView_ExtraRewardDesc
end

function GuildDonateView:UpdateExtraActivity(data, extra_rewards)
  self.extra_donateItemCtl:ResetDatas(data)
  if extra_rewards and 0 < #extra_rewards then
    local id = extra_rewards[1].id
    if id and Table_Item[id] then
      self.extraRewardID = id
      IconManager:SetItemIcon(Table_Item[id].Icon, self.extraRewardIcon)
      self.extraRewardCount.text = extra_rewards[1].count
    end
  end
  local _AERewardInfoData = ActivityEventProxy.Instance:GetRewardByType(_AE_ExtraMode)
  if not _AERewardInfoData then
    return
  end
  local finishcount = _AERewardInfoData.extraFinishCnt
  local daylimit = _AERewardInfoData.extraDayLimit
  self.extra_limitedLab.text = string.format(ZhString.GuildDonateView_ExtraLimitedFormat, finishcount, daylimit)
end

function GuildDonateView:OnClickRewardItem(cellctl)
  if not self.extraRewardID then
    return
  end
  local stick = self.extraRewardIcon
  local callback = function()
    self:CancelChooseReward()
  end
  local sdata = {
    itemdata = ItemData.new("extraReward", self.extraRewardID),
    funcConfig = {},
    callback = callback,
    ignoreBounds = {}
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
end

function GuildDonateView:CancelChooseReward()
  self:ShowItemTip()
end

function GuildDonateView:DoDonate()
  if self.selectGuildItemData then
    local itemid = self.selectGuildItemData.itemid
    local hasNum = GuildDonateItemCell.GetDonateItemNum(itemid)
    local needNum = self.confirmTip:GetGuildDonateItemTotalNeed()
    if hasNum < needNum then
      local needItem = {
        id = itemid,
        count = needNum - hasNum
      }
      if QuickBuyProxy.Instance:TryOpenView({needItem}) then
        self.confirmTip.closecomp.enabled = false
        return
      end
      MsgManager.ShowMsgByIDTable(8)
    else
      local configid = self.selectGuildItemData.configid
      local time = self.selectGuildItemData.time
      local count = self.confirmTip:GetOrderNum()
      ServiceGuildCmdProxy.Instance:CallDonateGuildCmd(configid, time, count)
      self.confirmTip:Hide()
      if self.selectGuildItemCell then
        self.selectGuildItemCell:ActiveGrey(true)
      end
      self.selectGuildItemData = nil
      self.selectGuildItemCell = nil
    end
  end
end

function GuildDonateView:ClickDonateItemCell(cellCtl)
  local data = cellCtl.data
  self.selectGuildItemData = data
  self.selectGuildItemCell = cellCtl
  if data then
    self.confirmTip:GetSelectedDonateItemAllContributeData()
    self.confirmTip:SetMaxOrderLimit(data)
    self.confirmTip:ResetOrderNum()
    self.confirmTip:SetData(data)
    self.confirmTip:Show()
    self.confirmTip:AddIgnoreBounds(cellCtl.gameObject)
  end
end

function GuildDonateView:UpdateGuildDonateInfo()
  local myGuildData = GuildProxy.Instance.myGuildData
  if myGuildData then
    local myGuildMemberData = myGuildData:GetMemberByGuid(Game.Myself.data.id)
    if myGuildMemberData then
      self.donationlabel.text = tostring(myGuildMemberData.contribution)
    end
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 1000, self.RefreshNextDonateTime, self, 1)
  end
end

function GuildDonateView:RefreshNextDonateTime()
  local myGuildData = GuildProxy.Instance.myGuildData
  local nextRefreshTime = myGuildData:GetNextDonateTime()
  local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(nextRefreshTime)
  if 0 < leftDay then
    self.refreshTimelabel.text = string.format("%s %02d:%02d:%02d", ZhString.GuildDonateView_NextRefreshTimeTip, leftDay, leftHour, leftMin)
  else
    self.refreshTimelabel.text = string.format("%s %02d:%02d:%02d", ZhString.GuildDonateView_NextRefreshTimeTip, leftHour, leftMin, leftSec)
  end
end

function GuildDonateView:UpdateDonateItemList()
  local donateItemList = GuildProxy.Instance:GetGuildDonateItemList() or {}
  local donateItemSingleList = GuildProxy.Instance:GetGuildDonateItemSingleList() or {}
  self.shownItemListCount = #donateItemSingleList
  local extraReward, _ = ActivityEventProxy.Instance:GetRewardByMode(_AE_ExtraMode)
  if _ and nil ~= next(extraReward) then
    self:Show(self.extraActivityRoot)
    self:Hide(self.donateItemGrid)
    self:UpdateExtraActivity(donateItemSingleList, extraReward)
  else
    self:Hide(self.extraActivityRoot)
    self:Show(self.donateItemGrid)
    self.donateItemCtl:ResetDatas(donateItemSingleList)
  end
  self.selectGuildItemCell = nil
  local count = 0
  count = self.shownItemListCount
  self.noneTip:SetActive(count == 0)
  local myGuildData = GuildProxy.Instance.myGuildData
  if not myGuildData then
    return
  end
  local config = myGuildData:GetGuildConfig()
  if not config then
    return
  end
  self.orderCount.text = string.format(ZhString.GuildDonateView_OrderCountTip, count, config.DonateListLimit)
end

function GuildDonateView:UpdateDonateRankList()
  local memberList = GuildProxy.Instance.myGuildData:GetMemberList()
  table.sort(memberList, function(a, b)
    return a.weekasset > b.weekasset
  end)
  local rankList = {}
  for i = 1, #memberList do
    local rankData = {}
    rankData.index = i
    rankData.memberData = memberList[i]
    table.insert(rankList, rankData)
  end
  self.rankCtl:ResetDatas(rankList)
end

function GuildDonateView:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdDonateListGuildCmd, self.UpdateDonateItemList)
  self:AddListenEvt(ServiceEvent.GuildCmdUpdateDonateItemGuildCmd, self.UpdateDonateItemList)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.UpdateDonateItemList)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleMemeberDataUpdate)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdApplyRewardConGuildCmd, self.HandleUpdateDonateTip)
  self:AddListenEvt(ServiceEvent.ActivityEventActivityEventNtf, self.UpdateDonateItemList)
  EventManager.Me():AddEventListener(QuickBuyEvent.CloseUI, self.HandleQuickClose, self)
end

function GuildDonateView:HandleQuickClose()
  if not self.confirmTip then
    return
  end
  self.confirmTip.closecomp.enabled = true
end

function GuildDonateView:RefreshConfirmTip()
  if not self.confirmTip then
    return
  end
  if not self.selectGuildItemData then
    return
  end
  self.confirmTip:SetData(self.selectGuildItemData)
end

function GuildDonateView:HandleItemUpdate()
  self:UpdateDonateItemList()
  self:RefreshConfirmTip()
end

function GuildDonateView:HandleUpdateDonateTip(note)
  if self.selectGuildItemCell == nil then
    return
  end
  self:ClickDonateItemCell(self.selectGuildItemCell)
end

function GuildDonateView:HandleRewardConUpdate(note)
  if self.selectGuildItemData then
    local configid = self.selectGuildItemData.configid
    local detailInfo = FunctionDonateItem.Me():GetDetailInfo(configid)
    self.confirmTip:UpdateConfirmDetailInfo(detailInfo)
  end
end

function GuildDonateView:HandleGuildDataUpdate()
  self:UpdateDonateItemList()
  self:UpdateGuildDonateInfo()
end

function GuildDonateView:HandleMemeberDataUpdate()
  self:UpdateGuildDonateInfo()
  self:UpdateDonateRankList()
end

function GuildDonateView:OnEnter()
  GuildDonateView.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallDonateListGuildCmd()
  ServiceGuildCmdProxy.Instance:CallDonateFrameGuildCmd(true)
  local npcData = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  local rootTrans = npcData and npcData.assetRole.completeTransform
  if rootTrans then
    self:CameraFocusOnNpc(rootTrans)
  else
    self:CameraRotateToMe()
  end
  self:UpdateDonateRankList()
  self:UpdateGuildDonateInfo()
end

function GuildDonateView:OnExit()
  EventManager.Me():RemoveEventListener(QuickBuyEvent.CloseUI, self.HandleQuickClose, self)
  GuildDonateView.super.OnExit(self)
  ServiceGuildCmdProxy.Instance:CallDonateFrameGuildCmd(false)
  TimeTickManager.Me():ClearTick(self, 1)
  self:CameraReset()
end
