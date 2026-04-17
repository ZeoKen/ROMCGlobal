autoImport("AsyncPvpRaidWaveEnemyCombineCell")
autoImport("AsyncPvpRaidAffixCell")
autoImport("AsyncPvpRaidDiffToggleCell")
AsyncPvpRaidDiffSetView = class("AsyncPvpRaidDiffSetView", ContainerView)
AsyncPvpRaidDiffSetView.ViewType = UIViewType.PopUpLayer

function AsyncPvpRaidDiffSetView:Init()
  self.isPreview = self.viewdata and self.viewdata.viewdata or false
  self.isInBattle = AsyncPvpRaidProxy.Instance:IsInBattle() or false
  self.hasSelectedAffix = AsyncPvpRaidProxy.Instance:HasSelectedAffix() or false
  self.totalRatio = 1
  self:FindObjs()
end

function AsyncPvpRaidDiffSetView:FindObjs()
  local closeBtn = self:FindGO("CloseBtn")
  self:AddClickEvent(closeBtn, function()
    self:CloseSelf()
  end)
  local grid = self:FindComponent("EnemyGrid", UIGrid)
  self.enermyListCtrl = UIGridListCtrl.new(grid, AsyncPvpRaidWaveEnemyCombineCell, "AsyncPvpRaidWaveEnemyCombineCell")
  grid = self:FindComponent("AffixGrid", UIGrid)
  self.affixListCtrl = UIGridListCtrl.new(grid, AsyncPvpRaidAffixCell, "AsyncPvpRaidAffixCell")
  self.affixListCtrl:AddEventListener(AsyncPvpRaidEvent.SelectAffix, self.OnAffixSelect, self)
  local chooseDiffGO = self:FindGO("ChooseDiffGO")
  grid = self:FindComponent("DiffGrid", UIGrid)
  self.diffListCtrl = UIGridListCtrl.new(grid, AsyncPvpRaidDiffToggleCell, "AsyncPvpRaidDiffToggleCell")
  self.diffListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnDiffSelect, self)
  self.diffTipLabel = self:FindComponent("DiffTipLabel", UILabel)
  self.chooseDiffTipLabel = self:FindComponent("ChooseDiffTipLabel", UILabel)
  self.totalRatioLabel = self:FindComponent("TotalRatioLabel", UILabel)
  self.previewTotalRatioLabel = self:FindComponent("PreviewTotalRatioLabel", UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    self:OnConfirmBtnClick()
  end)
  local isEditable = not self.isPreview
  closeBtn:SetActive(not isEditable)
  chooseDiffGO:SetActive(isEditable)
  self.chooseDiffTipLabel.gameObject:SetActive(not isEditable)
  self.confirmBtn:SetActive(isEditable)
  local notInBattleTip = self:FindGO("NotInBattleTip")
  notInBattleTip:SetActive(not isEditable and not self.hasSelectedAffix or false)
  self.totalRatioLabel.gameObject:SetActive(isEditable)
  self.previewTotalRatioLabel.gameObject:SetActive(not isEditable and self.hasSelectedAffix or false)
end

function AsyncPvpRaidDiffSetView:OnEnter()
  self:UpdateDiffList()
  self:UpdateEnemyList()
  self:UpdateAffixList()
  self:UpdateTotalRatio()
end

function AsyncPvpRaidDiffSetView:OnExit()
  if not self.isPreview then
    local selectAffixes = {}
    local cells = self.affixListCtrl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if cell and cell.data then
        local id = cell.data.id
        local selected = cell.selected
        if selected then
          TableUtility.ArrayPushBack(selectAffixes, id)
        end
      end
    end
    local diff = self.curDiffCell and self.curDiffCell.id or GameConfig.GeffenMagic and GameConfig.GeffenMagic.DefaultDifficulty or 4
    ServiceFuBenCmdProxy.Instance:CallGeffenMagicSelectAffixCmd(selectAffixes, diff)
    AsyncPvpRaidProxy.Instance:SetLocalSelectedAffixes(selectAffixes)
  end
end

function AsyncPvpRaidDiffSetView:UpdateAffixList()
  local affixes = AsyncPvpRaidProxy.Instance:GetAllAffixes()
  local affixDatas = {}
  for i = 1, #affixes do
    local id = affixes[i]
    local data = {}
    data.id = id
    data.isPreview = self.isPreview
    data.isInBattle = self.isInBattle
    data.selected = AsyncPvpRaidProxy.Instance:IsSelectedAffix(id, self.isPreview)
    local config = Table_MonsterAffix[id]
    local type = config and config.Type
    local affixConfig = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Affix and GameConfig.GeffenMagic.Affix[type]
    data.ratio = affixConfig and affixConfig.ScoreRate or 0
    TableUtility.ArrayPushBack(affixDatas, data)
    self.totalRatio = self.totalRatio + (data.selected and data.ratio or 0)
  end
  self.affixListCtrl:ResetDatas(affixDatas)
end

function AsyncPvpRaidDiffSetView:UpdateDiffList()
  local diffs = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Difficulties
  if diffs then
    local diff = AsyncPvpRaidProxy.Instance:GetDifficulty()
    diff = diff ~= 0 and diff or GameConfig.GeffenMagic.DefaultDifficulty or 4
    local datas = {}
    for i = 1, #diffs do
      local data = {}
      data.id = i
      data.selected = i == diff
      TableUtility.ArrayPushBack(datas, data)
    end
    self.diffListCtrl:ResetDatas(datas)
    self.chooseDiffTipLabel.text = string.format(ZhString.AsyncPvpRaidDiffSetView_ChooseDiffTip, diffs[diff].Name or "")
    local cells = self.diffListCtrl:GetCells()
    for i = 1, #cells do
      local cell = cells[i]
      if cell.selected then
        self:OnDiffSelect(cell)
        break
      end
    end
  end
end

function AsyncPvpRaidDiffSetView:UpdateEnemyList()
  local enemyInfos = GeffenMagicWaveScoreProxy.Instance:GetEnemyInfos()
  local datas = {}
  for wave, enemyHeadDatas in pairs(enemyInfos) do
    local data = {}
    data.wave = wave
    data.enemys = enemyHeadDatas
    TableUtility.ArrayPushBack(datas, data)
  end
  self.enermyListCtrl:ResetDatas(datas)
end

function AsyncPvpRaidDiffSetView:OnAffixSelect(cell)
  if cell and cell.data then
    local ratio = cell.data.ratio
    local isSelected = cell.selected
    ratio = isSelected and ratio or -ratio
    self.totalRatio = self.totalRatio + ratio
    self:UpdateTotalRatio()
  end
end

function AsyncPvpRaidDiffSetView:OnDiffSelect(cell)
  if cell.selected and self.curDiffCell ~= cell then
    if self.curDiffCell then
      local config = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Difficulties and GameConfig.GeffenMagic.Difficulties[self.curDiffCell.id]
      self.totalRatio = self.totalRatio - (config and config.Ratio or 0)
    end
    self.curDiffCell = cell
    local config = GameConfig.GeffenMagic and GameConfig.GeffenMagic.Difficulties and GameConfig.GeffenMagic.Difficulties[cell.id]
    if config then
      local ratio = config.Ratio
      local strength = config.Strength
      local ratioPercent = NumberUtility.RoundToInt(ratio * 100)
      local ratioStr = 0 <= ratio and "+" .. string.format("%d%%", ratioPercent) or string.format("%d%%", ratioPercent)
      local strengthPercent = math.abs(NumberUtility.RoundToInt(strength * 100))
      local strengthStr = 0 <= strength and string.format(ZhString.AsyncPvpRaidDiffSetView_Ascend, strengthPercent) or string.format(ZhString.AsyncPvpRaidDiffSetView_Descend, strengthPercent)
      self.diffTipLabel.text = string.format(ZhString.AsyncPvpRaidDiffSetView_DiffTip, ratioStr, strengthStr)
      self.totalRatio = self.totalRatio + ratio
      self:UpdateTotalRatio()
    end
  end
end

function AsyncPvpRaidDiffSetView:OnConfirmBtnClick()
  self:CloseSelf()
end

function AsyncPvpRaidDiffSetView:UpdateTotalRatio()
  local minRatio = GameConfig.GeffenMagic and GameConfig.GeffenMagic.ScoreRateMin or 0.01
  local ratio = math.max(self.totalRatio, minRatio)
  local ratioPercent = NumberUtility.RoundToInt(ratio * 100)
  local str = string.format(ZhString.AsyncPvpRaidDiffSetView_TotalRatio, ratioPercent)
  self.totalRatioLabel.text = str
  self.previewTotalRatioLabel.text = str
end
