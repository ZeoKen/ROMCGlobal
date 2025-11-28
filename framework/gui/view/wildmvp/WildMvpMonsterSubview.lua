autoImport("WildMvpMonsterCell")
autoImport("TechTreeSkillCell")
autoImport("TechTreeRewardCell")
autoImport("WildMvpDropCombineCell")
WildMvpMonsterSubview = class("WildMvpMonsterSubview", SubView)
local texObjStaticNameMap = {
  Detail = "tree_bg_jianbian",
  DetailTitleBg = "Games_bg_time"
}

function WildMvpMonsterSubview:Init()
  self:ReLoadPerferb("view/WildMvp/WildMvpMonsterSubview")
  self:FindObjs()
  self:UpdateView()
  self:AddListenEvents()
end

function WildMvpMonsterSubview:FindObjs()
  local helpBtnGO = self:FindGO("HelpBtn")
  local helpId = PanelConfig.WildMvpMonsterSubview.id
  self:TryOpenHelpViewById(helpId, nil, helpBtnGO)
  local picManager = PictureManager.Instance
  for objName, texName in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
    picManager:SetUI(texName, self[objName])
  end
  self.cellTable = self:FindComponent("CellTable", UITable)
  self.monsterListCtrl = ListCtrl.new(self.cellTable, WildMvpMonsterCell, "WildMvp/WildMvpMonsterCell")
  self.monsterListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnCellClicked, self)
  self.monsterListCtrl:AddEventListener(UICellEvent.OnMidBtnClicked, self.OnCellMidClicked, self)
  self.detailPanel = self:FindGO("Detail")
  self.nature = self:FindComponent("Nature", UISprite)
  self.detailTitle = self:FindComponent("DetailTitle", UILabel)
  self.detailLv = self:FindComponent("DetailLv", UILabel)
  self.normalStick = self:FindComponent("NormalStick", UIWidget)
  self.drag = self:FindComponent("DetailDrag", UIDragScrollView)
  self.featureTable = self:FindComponent("FeatureTable", UITable)
  self.raceLabel = self:FindComponent("Race", UILabel)
  self.shapeLabel = self:FindComponent("Shape", UILabel)
  self.detailScrollView = self:FindComponent("DetailScrollView", UIScrollView)
  self.detailTable = self:FindComponent("DetailTable", UITable)
  self.locked = self:FindGO("Locked")
  self.lockedLabel = self:FindComponent("LockedLabel", UILabel)
  self.explain = self:FindGO("Explain")
  self.explainLabel = self:FindComponent("ExplainLabel", UILabel)
  self.explainLabel = SpriteLabel.new(self.explainLabel, nil, 18, 20, true)
  self.char = self:FindGO("Char")
  self.charLabel = self:FindComponent("CharLabel", UILabel, self.char)
  self.charLabelGO = self.charLabel.gameObject
  self.charLabel = SpriteLabel.new(self.charLabel, nil, 18, 20, true)
  self.charLockLabel = self:FindComponent("CharLock", UILabel, self.char)
  self.charLockLabelGO = self.charLockLabel.gameObject
  self.charLockLabel = SpriteLabel.new(self.charLockLabel, nil, 18, 20, true)
  self.skill = self:FindGO("Skill")
  self.skillBg = self:FindComponent("SkillBg", UISprite)
  self.skillGrid = self:FindComponent("SkillGrid", UIGrid)
  self.skillCtrl = ListCtrl.new(self.skillGrid, TechTreeSkillCell, "TechTreeSkillCell")
  self.skillCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSkillCell, self)
  self.reward = self:FindGO("Reward")
  self.rewardBg = self:FindComponent("RewardBg", UISprite)
  self.rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardCtrl = ListCtrl.new(self.rewardGrid, TechTreeRewardCell, "TechTreeRewardCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardCell, self)
  self.cardIcon = self:FindGO("CardIcon", self.reward):GetComponent(UISprite)
  self.cardRefreshTip = self:FindGO("CardRefreshTip", self.reward):GetComponent(UILabel)
  IconManager:SetItemIcon("19", self.cardIcon)
  self.cardRefreshTip.text = string.format(ZhString.WildMvpCardRefreshTip, GameConfig.StormBoss.CardRewardRefreshCycle or 3)
  self.dropDetailPanel = self:FindGO("DropDetailPanel")
  self.dropTimeLabel = self:FindGO("TimeLabel", self.dropDetailPanel):GetComponent(UILabel)
  self.dropDetailCollider = self:FindGO("Collider")
  self:AddClickEvent(self.dropDetailCollider, function()
    self.dropDetailPanel:SetActive(false)
  end)
  self.dropScrollView = self:FindGO("DropScrollView", self.dropDetailPanel):GetComponent(UIScrollView)
  self.dropTable = self:FindGO("Table", self.dropDetailPanel):GetComponent(UITable)
  self.dropListCtrl = UIGridListCtrl.new(self.dropTable, WildMvpDropCombineCell, "WildMvp/WildMvpDropCombineCell")
  self.dropListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCardCell, self)
end

function WildMvpMonsterSubview:OnEnter()
  WildMvpMonsterSubview.super.OnEnter(self)
  WildMvpProxy.Instance:QueryMapRareElites()
  WildMvpProxy.Instance:CallCardRewardQueryCmd()
  self:UpdateDropDetail()
end

function WildMvpMonsterSubview:OnExit()
  WildMvpMonsterSubview.super.OnExit(self)
  self:RemoveListenEvents()
  TimeTickManager.Me():ClearTick(self)
end

function WildMvpMonsterSubview:AddListenEvents()
  EventManager.Me():AddEventListener(WildMvpEvent.OnMonsterUpdated, self.UpdateView, self)
  self:AddListenEvt(ServiceEvent.MapCardRewardQueryCmd, self.handleCardRewardQuery, self)
end

function WildMvpMonsterSubview:RemoveListenEvents()
  EventManager.Me():RemoveEventListener(WildMvpEvent.OnMonsterUpdated, self.UpdateView, self)
end

function WildMvpMonsterSubview:OnShow()
  self:UpdateView()
end

function WildMvpMonsterSubview:OnHide()
  self:HideTips()
end

function WildMvpMonsterSubview:HideTips()
  TipsView.Me():HideCurrent()
end

function WildMvpMonsterSubview:SelectCellByIndex(index)
  local cells = self.monsterListCtrl:GetCells()
  if index > #cells then
    index = 1
  end
  self:OnCellClicked(cells[index])
end

function WildMvpMonsterSubview:UpdateView()
  local proxy = WildMvpProxy.Instance
  local datas = proxy:GetMonsterDatas()
  self.monsterListCtrl:ResetDatas(datas)
  self:SelectCellByIndex(self.selectedCellIndex or 1)
end

function WildMvpMonsterSubview:OnCellClicked(cell)
  local cells = self.monsterListCtrl:GetCells()
  self.selectedCellIndex = nil
  for i, v in ipairs(cells) do
    if v == cell then
      self.selectedCellIndex = i
      v:SetSelected(true)
    else
      v:SetSelected(false)
    end
  end
  self:UpdateDetailPanel(cell and cell.data)
end

function WildMvpMonsterSubview:OnCellMidClicked(cell)
  local data = cell.data
  local monsterid = data and data.id
  local monsterConfig = Table_Monster[monsterid]
  if monsterConfig and monsterConfig.BattleTimeReward and monsterConfig.BattleTimeReward.card_reward then
    self.dropDetailPanel:SetActive(true)
    self:UpdateDropDetail(monsterConfig.BattleTimeReward.card_reward)
  end
end

function WildMvpMonsterSubview:UpdateDetailPanel(data)
  local hasData = data ~= nil
  self.nature.gameObject:SetActive(hasData)
  self.raceLabel.gameObject:SetActive(hasData)
  self.shapeLabel.gameObject:SetActive(hasData)
  self.detailScrollView.gameObject:SetActive(hasData)
  self.locked:SetActive(false)
  if hasData then
    local mData = Table_Monster[data.id]
    self.detailTitle.text = mData.NameZh or "????????"
    self.detailLv.text = string.format("Lv.%d", mData.Level) or ""
    IconManager:SetUIIcon(mData.Nature, self.nature)
    self.raceLabel.text = GameConfig.MonsterAttr.Race[mData.Race]
    self.shapeLabel.text = GameConfig.MonsterAttr.Body[mData.Shape]
    local hasExplain = not StringUtil.IsEmpty(data.staticData.explain)
    self.explain:SetActive(hasExplain)
    if hasExplain then
      TechTreeProxy.SetSpriteLabelWithGotoModeClickUrl(self.explainLabel, data.staticData.explain)
    end
    local hasChar = not StringUtil.IsEmpty(data.staticData.characteristic)
    self.char:SetActive(hasChar)
    if hasChar then
      local isUnLock = data:IsCharUnLock()
      self.charLabelGO:SetActive(isUnLock)
      self.charLockLabelGO:SetActive(not isUnLock)
      if isUnLock then
        TechTreeProxy.SetSpriteLabelWithGotoModeClickUrl(self.charLabel, data.staticData.characteristic)
      else
        self.charLockLabel:SetText(data.staticData.UnlockText, true)
      end
    end
    local skillArr = data.staticData.Skill or {}
    self.skillCtrl:ResetDatas(skillArr)
    local skillCells = self.skillCtrl:GetCells()
    for _, c in pairs(skillCells) do
      c:HandleDragScroll(self.drag)
    end
    self.skill:SetActive(skillArr ~= nil and 0 < #skillArr)
    self.skillBg.height = 16 + math.ceil(#skillArr / 5) * 78
    local cardRewardList = WildMvpProxy.Instance:GetCardRewardByMonsterID(data.id) or {}
    local endStamp = WildMvpProxy.Instance:GetCardRefreshTime()
    local rewardArr = data:GetRewards()
    if cardRewardList then
      for i = 1, #cardRewardList do
        TableUtility.ArrayPushFront(rewardArr, {
          id = cardRewardList[i]
        })
      end
    end
    self.rewardCtrl:ResetDatas(rewardArr)
    local rewardCells = self.rewardCtrl:GetCells()
    for _, c in pairs(rewardCells) do
      c:HandleDragScroll(self.drag)
      if endStamp and 0 < TableUtility.ArrayFindIndex(cardRewardList, c.id) then
        c:SetRefreshLabel(endStamp)
      else
        c:SetRefreshLabel()
      end
    end
    self.rewardBg.height = 16 + math.ceil(#rewardArr / 5) * 78
    self.detailTable:Reposition()
    if mData and mData.BattleTimeReward and mData.BattleTimeReward.card_reward then
      self.cardRefreshTip.gameObject:SetActive(true)
    else
      self.cardRefreshTip.gameObject:SetActive(false)
    end
  end
  self.featureTable:Reposition()
end

local tipOffset = {-200, 0}

function WildMvpMonsterSubview:OnClickSkillCell(cell)
  local id = cell and cell.data
  if not id then
    return
  end
  self.showingTipSkillData = self.showingTipSkillData or SkillItemData.new(nil, nil, nil, nil, nil, nil, nil, nil, true)
  self.showingTipSkillData:Reset(id)
  TipManager.Instance:ShowSkillStickTip(self.showingTipSkillData, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
end

function WildMvpMonsterSubview:OnClickRewardCell(cell)
  if not cell or not cell.id then
    return
  end
  self.tipRewardData = self.tipRewardData or {
    funcConfig = {},
    itemdata = ItemData.new()
  }
  self.tipRewardData.itemdata:ResetData("Tip", cell.id)
  local tip = TipManager.Instance:ShowItemFloatTip(self.tipRewardData, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
  tip:AddIgnoreBounds(self.rewardGrid)
end

function WildMvpMonsterSubview:OnClickCardCell(cell)
  local cardid = cell.data
  self.tipRewardData = self.tipRewardData or {
    funcConfig = {},
    itemdata = ItemData.new()
  }
  self.tipRewardData.itemdata:ResetData("Tip", cardid)
  TipManager.Instance:ShowItemFloatTip(self.tipRewardData, cell.widget, NGUIUtil.AnchorSide.Right, {210, -50})
end

function WildMvpMonsterSubview:handleCardRewardQuery()
  self:SelectCellByIndex(self.selectedCellIndex or 1)
end

function WildMvpMonsterSubview:UpdateDropDetail(groupids)
  local dropData = WildMvpProxy.Instance.cardDropData
  self.dropRefreshTime = dropData and dropData.refresh_time or ServerTime.CurServerTime() / 1000 + 600
  TimeTickManager.Me():ClearTick(self, 2)
  TimeTickManager.Me():CreateTick(0, 1000, function(owner, deltaTime)
    local leftDay, leftHour, leftMin, leftSec = ClientTimeUtil.GetFormatRefreshTimeStr(self.dropRefreshTime)
    if 0 < leftDay then
      leftHour = leftHour + leftDay * 24
    end
    self.dropTimeLabel.text = string.format(ZhString.WildMvpDropRefreshTime, leftHour, leftMin)
  end, self, 2)
  local list = {}
  local cardGroup = dropData and dropData.items or {}
  local rewardGroup = GameConfig.StormBoss and GameConfig.StormBoss.CardRewardGroup
  if groupids then
    for i = 1, #groupids do
      local groupid = groupids[i]
      local info = {groupid = groupid}
      local groupInfo = rewardGroup and rewardGroup[groupid]
      local _cardList = {}
      local index = cardGroup[groupid]
      for i = index, #groupInfo do
        table.insert(_cardList, groupInfo[i])
      end
      for i = 1, index - 1 do
        table.insert(_cardList, groupInfo[i])
      end
      info.cardList = _cardList
      table.insert(list, info)
    end
  else
    for groupid, index in pairs(cardGroup) do
      local info = {groupid = groupid}
      local groupInfo = rewardGroup and rewardGroup[groupid]
      local _cardList = {}
      for i = index, #groupInfo do
        table.insert(_cardList, groupInfo[i])
      end
      for i = 1, index - 1 do
        table.insert(_cardList, groupInfo[i])
      end
      info.cardList = _cardList
      table.insert(list, info)
    end
  end
  table.sort(list, function(l, r)
    return l.groupid < r.groupid
  end)
  self.dropListCtrl:ResetDatas(list)
end
