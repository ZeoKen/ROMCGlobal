autoImport("ActivitySelfChooseCardCell")
autoImport("ActivitySelfChooseTaskCell")
autoImport("CardNCell")
autoImport("BossComposeCardCell")
ActivitySelfChooseCardView = class("ActivitySelfChooseCardView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivitySelfChooseCardView")
local CardNCellResPath = ResourcePathHelper.UICell("CardNNewCell")
local BagCardCellResPath = ResourcePathHelper.UICell("BagCardCell")
local BgName = "MVPcard_bg_02"
local TargetCardBaName = "MVPcard_bg_07"
local tempVector3 = LuaVector3.Zero()

function ActivitySelfChooseCardView:Init()
  self:InitData()
  self:LoadPrefab()
  self:FindObjs()
  self:AddListenEvts()
  self.tipData = {}
  self.tipData.funcConfig = {79}
end

local _CardSortFunc = function(l, r)
  local lid = l.sortId
  local rid = r.sortId
  return lid < rid
end

function ActivitySelfChooseCardView:InitData()
  self.act_id = self.subViewData and self.subViewData.ActivityId or 0
  self.cards = {}
  local actConfig = Table_ActPersonalTimer[self.act_id]
  local groupWeight = actConfig and actConfig.Misc and actConfig.Misc.GroupWeight
  local totalGroupWeight = 0
  local groupProbability = {}
  local groupCardNum = {}
  if groupWeight then
    for i = 1, #groupWeight do
      totalGroupWeight = totalGroupWeight + groupWeight[i]
    end
    for i = 1, #groupWeight do
      groupProbability[i] = groupWeight[i] / totalGroupWeight
    end
  end
  local config = Game.FateSelectPool[self.act_id]
  if config then
    for itemId, data in pairs(config) do
      local itemData = ItemData.new("", itemId)
      local num = ActivitySelfChooseProxy.Instance:GetSelfChooseItemNum(self.act_id, itemId)
      itemData.act_id = self.act_id
      itemData.num = num
      itemData.composeId = data.ComposeID
      itemData.sortId = data.SortID
      local group = data.Group
      groupCardNum[group] = groupCardNum[group] or 0
      groupCardNum[group] = groupCardNum[group] + 1
      itemData.group = group
      self.cards[#self.cards + 1] = itemData
    end
  end
  table.sort(self.cards, _CardSortFunc)
  for i = 1, #self.cards do
    local itemData = self.cards[i]
    local group = itemData.group
    itemData.RateShow = groupProbability[group] / groupCardNum[group] * 100
  end
end

function ActivitySelfChooseCardView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivitySelfChooseCardView"
  self.gameObject = obj
end

function ActivitySelfChooseCardView:FindObjs()
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self.remainTimeLabel = self:FindComponent("RemainTime", UILabel)
  self.tipLabel = self:FindComponent("Tip", UILabel)
  local helpBtn = self:FindGO("HelpBtn")
  self:AddClickEvent(helpBtn, function()
    self:OnHelpBtnClick()
  end)
  local possibilityBtn = self:FindGO("PossibilityBtn")
  self:AddClickEvent(possibilityBtn, function()
    self:OnPossibilityBtnClick()
  end)
  local grid = self:FindComponent("Grid", UIGrid)
  self.cardList = UIGridListCtrl.new(grid, ActivitySelfChooseCardCell, "ActivitySelfChooseCardCell")
  self.cardList:AddEventListener(MouseEvent.MouseClick, self.OnCardChoose, self)
  self.anchor_right = self:FindGO("Anchor_Right")
  local taskGrid = self:FindComponent("TaskGrid", UIGrid)
  self.taskList = UIGridListCtrl.new(taskGrid, ActivitySelfChooseTaskCell, "ActivitySelfChooseTaskCell")
  self.getCardBtn = self:FindGO("GetBtn")
  self:AddClickEvent(self.getCardBtn, function()
    self:OnGetCardBtnClick()
  end)
  self.getCardBtnGrey = self:FindGO("GetBtnGrey")
  self.cardDetail = self:FindGO("CardDetailPanel")
  self.targetCardBg = self:FindComponent("CardDetailBg", UITexture)
  self.targetCard = self:FindGO("TargetCard")
  local obj = Game.AssetManager_UI:CreateAsset(CardNCellResPath, self.targetCard)
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  obj.transform.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, 1.25, 1.25, 1)
  obj.transform.localScale = tempVector3
  self.targetCardCell = CardNCell.new(obj)
  self.targetCardCell:Hide(self.targetCardCell.useButton.gameObject)
  local closeDetailBtn = self:FindGO("CloseDetailBtn")
  self:AddClickEvent(closeDetailBtn, function()
    self:OnCardDetailClose()
  end)
  self.composeCardContainer = self:FindGO("ComposeCardContainer")
  obj = Game.AssetManager_UI:CreateAsset(BagCardCellResPath, self.composeCardContainer)
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  obj.transform.localPosition = tempVector3
  LuaVector3.Better_Set(tempVector3, 1, 1, 1)
  obj.transform.localScale = tempVector3
  self.composeCardCell = BagCardCell.new(obj)
  self.composeCardCell:AddEventListener(MouseEvent.MouseClick, self.OnComposeCardClick, self)
end

function ActivitySelfChooseCardView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdFateSelectSyncInfoCmd, self.RefreshView)
  self:AddListenEvt(ServiceEvent.ActivityCmdFateSelectDrawCmd, self.OnCardDrawed)
  self:AddListenEvt(ServiceEvent.ActivityCmdFateSelectTargetUpdateCmd, self.RefreshTaskList)
  self:AddListenEvt(ServiceEvent.ActivityCmdFateSelectRewardCmd, self.OnRewardGet)
end

function ActivitySelfChooseCardView:OnEnter()
  PictureManager.Instance:SetSelfChooseTexture(BgName, self.bgTex)
  PictureManager.Instance:SetSelfChooseTexture(TargetCardBaName, self.targetCardBg)
  self:RefreshView()
  self:RefreshTaskList()
  local _ActivitySelfChooseProxy = ActivitySelfChooseProxy.Instance
  local remainDay, remainHour = _ActivitySelfChooseProxy:GetRemainDay(self.act_id)
  if 0 < remainDay then
    self.remainTimeLabel.text = string.format(ZhString.RemainTimeDay, remainDay)
  else
    self.remainTimeLabel.text = string.format(ZhString.RemainTimeHour, remainHour)
  end
end

function ActivitySelfChooseCardView:OnExit()
  PictureManager.Instance:UnloadSelfChooseTexture(BgName, self.bgTex)
  PictureManager.Instance:UnloadSelfChooseTexture(TargetCardBaName, self.targetCardBg)
  self.targetCardCell:OnCellDestroy()
  self.targetCardCell = nil
  self.composeCardCell:OnCellDestroy()
  self.composeCardCell = nil
end

function ActivitySelfChooseCardView:RefreshView()
  local _ActivitySelfChooseProxy = ActivitySelfChooseProxy.Instance
  self.cardList:ResetDatas(self.cards)
  local drawedNum = _ActivitySelfChooseProxy:GetSelfChooseDrawedNum(self.act_id)
  local targetNum = _ActivitySelfChooseProxy:GetSelfChooseTargetDrawNum(self.act_id)
  self.tipLabel.text = string.format(ZhString.SelfChoose_Tip, drawedNum, targetNum)
  self:RefreshGetCardBtn()
end

function ActivitySelfChooseCardView:RefreshTaskList()
  local tasks = ActivitySelfChooseProxy.Instance:GetSelfChooseTasks(self.act_id)
  self.taskList:ResetDatas(tasks)
end

function ActivitySelfChooseCardView:RefreshGetCardBtn()
  local state = ActivitySelfChooseProxy.Instance:IsSelfChooseItemCanGet(self.act_id) and self.selectCardCell and not self.selectCardCell.isMask or false
  self:SetGetCardBtnState(state)
end

function ActivitySelfChooseCardView:SetGetCardBtnState(state)
  self.getCardBtn:SetActive(state)
  self.getCardBtnGrey:SetActive(not state)
end

function ActivitySelfChooseCardView:OnCardChoose(cell)
  if cell == self.selectCardCell then
    return
  end
  local data = cell.data
  local path = ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. data.cardInfo.Picture)
  local chooseState = Game.AssetLoadEventDispatcher:IsFileExist(path) == 0
  if self.targetCardCell.use ~= nil then
    chooseState = self.targetCardCell.use
  end
  self.targetCardCell:SetData(data, chooseState)
  if data.composeId and data.composeId ~= 0 then
    self.composeCardContainer:SetActive(true)
    if not self.composeItemData then
      self.composeItemData = ItemData.new("ComposeCard", data.composeId)
      self.composeItemData.num = 1
      local config = Table_ActPersonalTimer[self.act_id]
      local shortcutId = config and config.Misc and config.Misc.compose_shortcut_id
      self.composeItemData.shortcutId = shortcutId
    elseif self.composeItemData.staticData.id ~= data.composeId then
      self.composeItemData:ResetData("ComposeCard", data.composeId)
    end
    self.composeCardCell:SetData(self.composeItemData)
  else
    self.composeCardContainer:SetActive(false)
  end
  self:ShowCardDetail(true)
  if self.selectCardCell then
    self.selectCardCell:SetCardSelectState(false)
  end
  cell:SetCardSelectState(true)
  self.selectCardCell = cell
  self:RefreshGetCardBtn()
end

function ActivitySelfChooseCardView:ShowCardDetail(isShow)
  self.cardDetail:SetActive(isShow)
  self.anchor_right:SetActive(not isShow)
end

function ActivitySelfChooseCardView:OnGetCardBtnClick()
  MsgManager.ConfirmMsgByID(43499, function()
    if self.selectCardCell then
      ServiceActivityCmdProxy.Instance:CallFateSelectRewardCmd(self.act_id, self.selectCardCell.itemId)
    end
  end)
end

function ActivitySelfChooseCardView:OnComposeCardClick()
  self.tipData.itemdata = self.composeItemData
  self:ShowItemTip(self.tipData, self.composeCardCell.widget, NGUIUtil.AnchorSide.Left, {-400, 0})
end

function ActivitySelfChooseCardView:OnCardDetailClose()
  self:ShowCardDetail(false)
  if self.selectCardCell then
    self.selectCardCell:SetCardSelectState(false)
    self.selectCardCell = nil
    self:RefreshGetCardBtn()
  end
end

function ActivitySelfChooseCardView:OnHelpBtnClick()
  self:ShowHelp(1)
end

function ActivitySelfChooseCardView:OnPossibilityBtnClick()
  self:ShowHelp(2)
end

function ActivitySelfChooseCardView:ShowHelp(jumpIndex)
  local config = Table_ActPersonalTimer[self.act_id]
  if config then
    local datas = {}
    local helpId = config.Misc.help_id
    if helpId then
      local helpData = Table_Help[helpId]
      if helpData then
        datas[#datas + 1] = helpData
      end
    end
    local data = {}
    data.Title = ZhString.SelfChoose_HelpRewardTitle
    datas[#datas + 1] = data
    local cellDatas = {}
    for i = 1, #self.cards do
      local card = self.cards[i]
      local cellData = ItemData.new("", card.staticData.id)
      cellData.num = 1
      cellData.RateShow = card.RateShow
      cellDatas[i] = cellData
    end
    TipsView.Me():ShowSelfChooseHelp(datas, nil, cellDatas, BossComposeCardCell, "BagCardCell", jumpIndex)
  end
end

function ActivitySelfChooseCardView:OnCardDrawed(note)
  local cardId = note.body and note.body.result
  for i = 1, #self.cards do
    local itemData = self.cards[i]
    if itemData.staticData.id == cardId then
      itemData.num = itemData.num + 1
      break
    end
  end
  self:ShowAward(cardId, true)
end

function ActivitySelfChooseCardView:OnRewardGet(note)
  local cardId = note.body and note.body.select_item
  self:ShowAward(cardId)
  self.container:CloseSelf()
end

function ActivitySelfChooseCardView:ShowAward(cardId, isDrawed)
  local itemData = ItemData.new("ExchangeCard", cardId)
  local args = ReusableTable.CreateTable()
  args.disableMsg = true
  if isDrawed then
    args.leftBtnText = ZhString.FloatAwardView_Confirm
    
    function args.leftBtnCallback()
      if self.cardList then
        self:RefreshView()
        local cells = self.cardList:GetCells()
        for i = 1, #cells do
          local cell = cells[i]
          if cell.itemId == cardId then
            self.cardList:ScrollToIndex(i)
            cell:PlayEffect()
            break
          end
        end
      end
    end
  end
  FloatAwardView.addItemDatasToShow({itemData}, args)
  ReusableTable.DestroyAndClearTable(args)
end
