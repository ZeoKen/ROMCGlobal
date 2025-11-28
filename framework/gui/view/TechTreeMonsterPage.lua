autoImport("TechTreeMonsterCell")
autoImport("TechTreeSkillCell")
autoImport("TechTreeRewardCell")
TechTreeMonsterPage = class("TechTreeMonsterPage", SubView)
local picIns, tickManager
local texObjStaticNameMap = {
  Detail = "tree_bg_jianbian",
  DetailTitleBg = "Games_bg_time"
}

function TechTreeMonsterPage:Init()
  if not picIns then
    picIns = PictureManager.Instance
    tickManager = TimeTickManager.Me()
  end
  self:ReLoadPerferb("view/TechTreeMonsterPage")
  self.trans:SetParent(self.container.pageContainer.transform, false)
  self:FindObjs()
  self:InitPage()
end

function TechTreeMonsterPage:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.cellTable = self:FindComponent("CellTable", UITable)
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
  self.char = self:FindGO("Char")
  self.charLabel = self:FindComponent("CharLabel", UILabel)
  self.skill = self:FindGO("Skill")
  self.skillBg = self:FindComponent("SkillBg", UISprite)
  self.skillGrid = self:FindComponent("SkillGrid", UIGrid)
  self.reward = self:FindGO("Reward")
  self.rewardBg = self:FindComponent("RewardBg", UISprite)
  self.rewardGrid = self:FindComponent("RewardGrid", UIGrid)
end

function TechTreeMonsterPage:InitPage()
  self.cellCtrl = ListCtrl.new(self.cellTable, TechTreeMonsterCell, "TechTreeMonsterCell")
  self.cellCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.cellCells = self.cellCtrl:GetCells()
  self.skillCtrl = ListCtrl.new(self.skillGrid, TechTreeSkillCell, "TechTreeSkillCell")
  self.skillCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSkillCell, self)
  self.skillCells = self.skillCtrl:GetCells()
  self.rewardCtrl = ListCtrl.new(self.rewardGrid, TechTreeRewardCell, "TechTreeRewardCell")
  self.rewardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardCell, self)
  self.rewardCells = self.rewardCtrl:GetCells()
  self.explainLabel = SpriteLabel.new(self.explainLabel, nil, 18, 20, true)
  self.charLabel = SpriteLabel.new(self.charLabel, nil, 18, 20, true)
end

local monsterListDataSortFunc = function(l, r)
  return l.Order < r.Order
end

function TechTreeMonsterPage:UpdateCells()
  local arr = ReusableTable.CreateArray()
  if Table_MonsterList then
    for _, d in pairs(Table_MonsterList) do
      if table.ContainsValue(GameConfig.TechTree.IconShowMap, d.MapID) then
        TableUtility.ArrayPushBack(arr, d)
      end
    end
  end
  table.sort(arr, monsterListDataSortFunc)
  self.cellCtrl:ResetDatas(arr)
  ReusableTable.DestroyAndClearArray()
  if self.queryReceived then
    self:UpdateCellState()
  end
end

function TechTreeMonsterPage:UpdateCellState()
  if not self.cellEliteDataMap then
    return
  end
  if not self.gameObject.activeSelf then
    return
  end
  for _, c in pairs(self.cellCells) do
    if c.data then
      c:UpdateElite(self.cellEliteDataMap[c.data.id])
    end
  end
end

function TechTreeMonsterPage:UpdateDetail(data)
  local isUnlock = data ~= nil and FunctionUnLockFunc.Me():CheckCanOpen(data.MenuID)
  self.nature.gameObject:SetActive(isUnlock)
  self.raceLabel.gameObject:SetActive(isUnlock)
  self.shapeLabel.gameObject:SetActive(isUnlock)
  self.detailScrollView.gameObject:SetActive(isUnlock)
  self.locked:SetActive(not isUnlock)
  local mData = Table_Monster[data.id]
  self.detailTitle.text = isUnlock and mData.NameZh or "????????"
  self.detailLv.text = isUnlock and string.format("Lv.%d", mData.Level) or ""
  if isUnlock then
    IconManager:SetUIIcon(mData.Nature, self.nature)
    self.raceLabel.text = GameConfig.MonsterAttr.Race[mData.Race]
    self.shapeLabel.text = GameConfig.MonsterAttr.Body[mData.Shape]
    local hasExplain = not StringUtil.IsEmpty(data.explain)
    self.explain:SetActive(hasExplain)
    if hasExplain then
      TechTreeProxy.SetSpriteLabelWithGotoModeClickUrl(self.explainLabel, data.explain)
    end
    local hasChar = not StringUtil.IsEmpty(data.characteristic)
    self.char:SetActive(hasChar)
    if hasChar then
      TechTreeProxy.SetSpriteLabelWithGotoModeClickUrl(self.charLabel, data.characteristic)
    end
    local skillArr = data.Skill
    self.skillCtrl:ResetDatas(skillArr or _EmptyTable)
    for _, c in pairs(self.skillCells) do
      c:HandleDragScroll(self.drag)
    end
    self.skill:SetActive(skillArr ~= nil and 0 < #skillArr)
    self.skillBg.height = 16 + math.ceil(#skillArr / 5) * 78
    local eliteData, rewardArr = self.cellEliteDataMap and self.cellEliteDataMap[data.id], ReusableTable.CreateArray()
    if eliteData and eliteData.firstKilled then
      for i = 1, #data.Reward do
        self:TryAddReusableReward(rewardArr, data.Reward[i])
      end
      for i = 1, #data.DropReward do
        self:TryAddReusableReward(rewardArr, data.DropReward[i], true, true)
      end
    else
      for i = 1, #data.DropReward do
        self:TryAddReusableReward(rewardArr, data.DropReward[i], true)
      end
      for i = 1, #data.Reward do
        self:TryAddReusableReward(rewardArr, data.Reward[i])
      end
    end
    self.rewardCtrl:ResetDatas(rewardArr)
    for _, c in pairs(self.rewardCells) do
      c:HandleDragScroll(self.drag)
    end
    self.rewardBg.height = 16 + math.ceil(#rewardArr / 5) * 78
    for i = 1, #rewardArr do
      ReusableTable.DestroyAndClearTable(rewardArr[i])
    end
    ReusableTable.DestroyAndClearArray(rewardArr)
    tickManager:CreateOnceDelayTick(16, function(self)
      self.detailTable:Reposition()
    end, self)
  else
    self.lockedLabel.text = data.UnlockText
  end
  self.featureTable:Reposition()
end

function TechTreeMonsterPage:TryAddReusableReward(rewardItemArr, teamId, isFirst, isGot)
  local items, tbl = teamId and ItemUtil.GetRewardItemIdsByTeamId(teamId)
  if items then
    for i = 1, #items do
      tbl = ReusableTable.CreateTable()
      TableUtility.TableShallowCopy(tbl, items[i])
      tbl.isFirst = isFirst
      tbl.isGot = isGot
      TableUtility.ArrayPushBack(rewardItemArr, tbl)
    end
  end
end

function TechTreeMonsterPage:OnEnter()
  TechTreeMonsterPage.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  TechTreeProxy.CallMapRareElite()
end

function TechTreeMonsterPage:OnActivate()
  self:UpdateCells()
  self:OnClickCell(self.cellCells[1])
end

function TechTreeMonsterPage:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  self.cellCtrl:Destroy()
  tickManager:ClearTick(self)
  TechTreeMonsterPage.super.OnExit(self)
end

function TechTreeMonsterPage:OnQuery(note)
  local datas = note and note.body and note.body.datas
  if datas and 0 < #datas then
    self.cellEliteDataMap = self.cellEliteDataMap or {}
    TableUtility.TableClear(self.cellEliteDataMap)
    local data, remote, id
    for i = 1, #datas do
      remote = datas[i]
      id = remote.npcid
      data = self.cellEliteDataMap[id] or {}
      data.id = id
      data.status = remote.status
      data.leftTime = remote.lefttime
      data.posX = remote.pos.x
      data.posY = remote.pos.y
      data.posZ = remote.pos.z
      data.firstKilled = remote.first_killed
      self.cellEliteDataMap[id] = data
    end
    self:UpdateCellState()
    self.queryReceived = true
  end
end

function TechTreeMonsterPage:OnUnlockMenu()
  TechTreeProxy.CallMapRareElite()
end

function TechTreeMonsterPage:OnClickCell(cell)
  if not cell or not cell.data then
    return
  end
  self:UpdateDetail(cell.data)
  for _, c in pairs(self.cellCells) do
    c:SetChooseId(cell.data.id)
  end
end

local tipOffset = {-200, 0}

function TechTreeMonsterPage:OnClickSkillCell(cell)
  local id = cell and cell.data
  if not id then
    return
  end
  self.showingTipSkillData = self.showingTipSkillData or SkillItemData.new(nil, nil, nil, nil, nil, nil, nil, nil, true)
  self.showingTipSkillData:Reset(id)
  TipManager.Instance:ShowSkillStickTip(self.showingTipSkillData, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
end

function TechTreeMonsterPage:OnClickRewardCell(cell)
  if not cell or not cell.id then
    return
  end
  self.tipRewardData = self.tipRewardData or {
    funcConfig = _EmptyTable,
    itemdata = ItemData.new()
  }
  self.tipRewardData.itemdata:ResetData("Tip", cell.id)
  local tip = TipManager.Instance:ShowItemFloatTip(self.tipRewardData, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
  tip:AddIgnoreBounds(self.rewardGrid)
end
