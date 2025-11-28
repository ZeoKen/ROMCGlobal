autoImport("ActivityFlipCardLinkRewardCell")
autoImport("ActivityFlipCardGridCell")
autoImport("ActivityFlipCardGridRewardCell")
autoImport("ActivityFlipCardRewardDetailCell")
autoImport("ActivityFlipCardBuyChanceCell")
ActivityFlipCardView = class("ActivityFlipCardView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityFlipCardView")
local BgName = "kingtreasure_bg_01"
ActivityFlipCardEvent_TimeOut = "ActivityFlipCardEvent_TimeOut"

function ActivityFlipCardView:Init()
  self:InitData()
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
end

function ActivityFlipCardView:InitData()
  self.activityId = self.subViewData and self.subViewData.ActivityId
  self.rowRewards = {}
  self.columnRewards = {}
  self.linkRewards = {}
  local sortFunc = function(l, r)
    local lStatic = Table_FlipCard[l]
    local rStatic = Table_FlipCard[r]
    return lStatic.Index < rStatic.Index
  end
  for id, v in pairs(Table_FlipCard) do
    if v.ActID == self.activityId then
      if v.Type == 1 then
        self.rowRewards[v.Index] = id
      elseif v.Type == 2 then
        self.columnRewards[v.Index] = id
      elseif v.Type == 3 then
        self.diagonalReward = id
      elseif v.Type == 4 then
        self.linkRewards[#self.linkRewards + 1] = id
      end
    end
  end
  table.sort(self.linkRewards, sortFunc)
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityFlipCardView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityFlipCardView"
  self.gameObject = obj
end

function ActivityFlipCardView:FindObjs()
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.remainTimeLabel = self:FindComponent("RemainTime", UILabel)
  local token = self:FindGO("Token")
  self:AddClickEvent(token, function()
    self:ShowItemTip(self.tipData, self.tokenIcon, NGUIUtil.AnchorSide.Left, {-200, 0})
  end)
  self.tokenIcon = self:FindComponent("icon", UISprite, token)
  self.tokenNum = self:FindComponent("num", UILabel, token)
  self.addWayLabel = SpriteLabel.new(self:FindGO("AddWay"), nil, 26, 26, true)
  self:AddButtonEvent("ShortcutBtn", function()
    self:OnShortcutBtnClick()
  end)
  self.buyBtn = self:FindGO("BuyBtn")
  self:AddClickEvent(self.buyBtn, function()
    if not ActivityFlipCardProxy.Instance:IsActivityAvailable(self.activityId) then
      MsgManager.ShowMsgByID(41346)
      self:HandleActTimeOut()
      return
    end
    if not self.buyChanceCell then
      self.buyChanceCell = ActivityFlipCardBuyChanceCell.Create(self.gameObject.transform)
      self.buyChanceCell:SetData(self.activityId)
    end
    self.buyChanceCell:Show()
  end)
  self.buyBtnGrey = self:FindGO("BuyBtnGrey")
  self.buyTipLabel = SpriteLabel.new(self:FindGO("BuyTip"), nil, 26, 26, true)
  local rewardPanel = self:FindGO("RewardPanel")
  local rewardGrid = self:FindComponent("Grid", UIGrid, rewardPanel)
  self.rewardListCtrl = UIGridListCtrl.new(rewardGrid, ActivityFlipCardLinkRewardCell, "ActivityFlipCardLinkRewardCell")
  self.rewardListCtrl:AddEventListener(ActivityFlipCardEvent_TimeOut, self.HandleActTimeOut, self)
  self:AddButtonEvent("DetailBtn", function()
    self.rewardDetailPanel:SetActive(true)
  end)
  self.tipLabel = SpriteLabel.new(self:FindGO("Tip"), nil, 26, 26, true)
  local container = self:FindGO("GridContainer")
  local config = Table_ActPersonalTimer[self.activityId]
  local maxLength = config and config.Misc.side_length and config.Misc.side_length or 6
  self.wrapHelper = WrapListCtrl.new(container, ActivityFlipCardGridCell, "ActivityFlipCardGridCell", WrapListCtrl_Dir.Vertical, maxLength, 76)
  self.wrapHelper:AddEventListener(ActivityFlipCardEvent_TimeOut, self.HandleActTimeOut, self)
  local rowRewardPanel = self:FindGO("RowRewardPanel")
  local rowRewardGrid = self:FindComponent("Grid", UIGrid, rowRewardPanel)
  self.rowRewardListCtrl = UIGridListCtrl.new(rowRewardGrid, ActivityFlipCardGridRewardCell, "ActivityFlipCardGridCell")
  self.rowRewardListCtrl:AddEventListener(ActivityFlipCardEvent_TimeOut, self.HandleActTimeOut, self)
  local columnRewardPanel = self:FindGO("ColumnRewardPanel")
  local columnRewardGrid = self:FindComponent("Grid", UIGrid, columnRewardPanel)
  self.columnRewardListCtrl = UIGridListCtrl.new(columnRewardGrid, ActivityFlipCardGridRewardCell, "ActivityFlipCardGridCell")
  self.columnRewardListCtrl:AddEventListener(ActivityFlipCardEvent_TimeOut, self.HandleActTimeOut, self)
  self.diagonalRewardHolder = self:FindGO("Holder")
  self.rewardDetailPanel = self:FindGO("GridRewardDetailBg")
  local rewardDetailGrid = self:FindComponent("Grid", UIGrid, self.rewardDetailPanel)
  self.rewardDetailListCtrl = UIGridListCtrl.new(rewardDetailGrid, ActivityFlipCardRewardDetailCell, "ActivityFlipCardRewardDetailCell")
end

function ActivityFlipCardView:AddEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdFlipCardInfoSyncCmd, self.RefreshView)
end

function ActivityFlipCardView:InitView()
  local config = Table_ActPersonalTimer[self.activityId]
  if not config then
    return
  end
  local token = config.Misc.chance_token
  local itemData = ItemData.new("token", token)
  self.tipData.itemdata = itemData
  local tipStr = string.format(ZhString.FlipCard_Tip, token)
  self.tipLabel:SetText(tipStr)
  local max_chance_by_act = config.Misc.max_chance_by_act
  local cur_chance_by_act = ActivityFlipCardProxy.Instance:GetByActChance(self.activityId)
  local addWayStr = string.format(ZhString.FlipCard_AddWay, token, cur_chance_by_act, max_chance_by_act)
  self.addWayLabel:SetText(addWayStr)
  if config.Misc.buy_chance_price then
    local money = config.Misc.buy_chance_price[1]
    local price = config.Misc.buy_chance_price[2]
    local buyTipStr = string.format(ZhString.FlipCard_BuyTip, money, price, token)
    self.buyTipLabel:SetText(buyTipStr)
  end
  IconManager:SetItemIconById(token, self.tokenIcon)
  if ActivityFlipCardProxy.Instance:IsActivityAvailable(self.activityId) then
    local endTime = ActivityFlipCardProxy.Instance:GetEndTime(self.activityId)
    local curTime = ServerTime.CurServerTime() / 1000
    local leftDay = math.floor((endTime - curTime) / 3600 / 24)
    if 0 < leftDay then
      self.remainTimeLabel.text = string.format(ZhString.FlipCard_RemainDay, leftDay)
    else
      local leftHour = math.floor((endTime - curTime) / 3600)
      self.remainTimeLabel.text = string.format(ZhString.FlipCard_RemainHour, leftHour)
    end
  end
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("ActivityFlipCardGridCell"))
  obj.transform:SetParent(self.diagonalRewardHolder.transform, false)
  obj.name = "DiagonalRewardCell"
  self.diagonalRewardCell = ActivityFlipCardGridRewardCell.new(obj)
  self.diagonalRewardCell:AddEventListener(ActivityFlipCardEvent_TimeOut, self.HandleActTimeOut, self)
  self.rewardDetailPanel:SetActive(false)
  local rewardDatas = ItemUtil.GetRewardItemIdsByTeamId(config.Misc.single_grid_reward)
  if rewardDatas then
    local datas = ReusableTable.CreateArray()
    local count = #rewardDatas
    local total = 0
    local jp_total = 0
    for i = 1, count do
      local rewardData = rewardDatas[i]
      total = total + rewardData.rate
      jp_total = jp_total + rewardData.jp_rate
    end
    for i = 1, count do
      local rewardData = rewardDatas[i]
      local data = {}
      data.id = rewardData.id
      data.num = rewardData.num
      data.probability = rewardData.rate / total
      data.jp_probability = rewardData.jp_rate / jp_total
      datas[#datas + 1] = data
    end
    self.rewardDetailListCtrl:ResetDatas(datas)
    ReusableTable.DestroyArray(datas)
  end
  self:RefreshView()
end

function ActivityFlipCardView:OnEnter()
  PictureManager.Instance:SetFlipCardTexture(BgName, self.bgTex)
end

function ActivityFlipCardView:OnExit()
  PictureManager.Instance:UnloadFlipCardTexture(BgName, self.bgTex)
end

function ActivityFlipCardView:RefreshView()
  self:UpdateGridPanel()
  self:UpdateRewardPanel(self.rowRewardListCtrl, self.rowRewards)
  self:UpdateRewardPanel(self.columnRewardListCtrl, self.columnRewards)
  self:UpdateLinkRewardPanel()
  local chance = ActivityFlipCardProxy.Instance:GetRemainFlipChance(self.activityId)
  self.tokenNum.text = chance
  local data = self:SetRewardData(self.diagonalReward)
  data.isDiagonal = true
  self.diagonalRewardCell:SetData(data)
  local isCanBuy = ActivityFlipCardProxy.Instance:IsChanceCanBuy(self.activityId)
  self.buyBtn:SetActive(isCanBuy)
  self.buyBtnGrey:SetActive(not isCanBuy)
end

function ActivityFlipCardView:UpdateGridPanel()
  local config = Table_ActPersonalTimer[self.activityId]
  if config then
    local datas = {}
    local maxLength = config.Misc.side_length or 6
    local token = config.Misc.chance_token
    for i = 1, maxLength do
      for j = 1, maxLength do
        local data = {}
        data.act_id = self.activityId
        data.row = i
        data.column = j
        data.itemId = token
        data.state = ActivityFlipCardProxy.Instance:IsCardFliped(self.activityId, i, j) and 1 or 0
        local index = ActivityFlipCardProxy.GetGridIndexByRowAndCol(self.activityId, i, j)
        datas[index] = data
      end
    end
    self.wrapHelper.pos_reseted = true
    self.wrapHelper:ResetDatas(datas)
  end
end

function ActivityFlipCardView:SetRewardData(id)
  local data = {}
  data.act_id = self.activityId
  data.id = id
  data.state = ActivityFlipCardProxy.Instance:IsRewardReceived(self.activityId, id)
  return data
end

function ActivityFlipCardView:UpdateRewardPanel(listCtrl, rewards)
  local datas = ReusableTable.CreateArray()
  for i = 1, #rewards do
    local id = rewards[i]
    local data = self:SetRewardData(id)
    if listCtrl == self.rowRewardListCtrl then
      data.row = i
    elseif listCtrl == self.columnRewardListCtrl then
      data.column = i
    end
    datas[i] = data
  end
  listCtrl:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
end

function ActivityFlipCardView:UpdateLinkRewardPanel()
  local datas = ReusableTable.CreateArray()
  local curLink = ActivityFlipCardProxy.Instance:GetLinkLineCount(self.activityId)
  for i = 1, #self.linkRewards do
    local id = self.linkRewards[i]
    local sData = Table_FlipCard[id]
    local data = self:SetRewardData(id)
    data.curLink = curLink
    data.targetLink = sData.Index
    datas[i] = data
  end
  self.rewardListCtrl:ResetDatas(datas)
  ReusableTable.DestroyAndClearArray(datas)
end

function ActivityFlipCardView:OnShortcutBtnClick()
  local config = Table_ActPersonalTimer[self.activityId]
  if config then
    local helpId = config.Misc.help_id
    local shortcutId = config.Misc.shortcut_id
    if helpId then
      local helpData = Table_Help[helpId]
      if helpData then
        TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
      end
    elseif shortcutId then
      if not ActivityFlipCardProxy.Instance:IsActivityAvailable(self.activityId) then
        MsgManager.ShowMsgByID(41346)
        self:HandleActTimeOut()
        return
      end
      FuncShortCutFunc.Me():CallByID(shortcutId)
    end
  end
end

function ActivityFlipCardView:HandleActTimeOut()
  self.container:CloseSelf()
end
