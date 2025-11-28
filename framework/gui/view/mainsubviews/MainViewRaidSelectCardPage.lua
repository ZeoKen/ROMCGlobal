autoImport("RaidSelectCardCell")
MainViewRaidSelectCardPage = class("MainViewRaidSelectCardPage", MainViewDungeonInfoSubPage)
local qualityBgSpMap = {
  [1] = "GVG_rift_bg_icon1",
  [2] = "GVG_rift_bg_icon3",
  [3] = "GVG_rift_bg_icon2",
  [4] = "GVG_rift_bg_icon4",
  [5] = "GVG_rift_bg_icon5"
}
local skillIns

function MainViewRaidSelectCardPage:Init()
  if not skillIns then
    skillIns = SkillProxy.Instance
  end
  self:ReLoadPerferb("view/MainViewRaidSelectCardPage", nil, LuaGeometry.GetTempVector3(0, -279, 0), self:FindGO("Anchor_TopLeft").transform)
  self.trans:SetParent(self.traceInfoParent.transform, true)
  self:AddListenEvts()
  self:InitView()
  self:ResetData()
end

function MainViewRaidSelectCardPage:AddListenEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.OnFinishLoadScene)
  self:AddListenEvt(ServiceEvent.RaidCmdRaidSelectCardResetCmd, self.OnCardReset)
  self:AddListenEvt(ServiceEvent.RaidCmdRaidSelectCardHistoryResultCmd, self.ResetData)
  self:AddListenEvt(ServiceEvent.RaidCmdRaidSelectCardResultRes, self.ResetData)
  self:AddListenEvt(SkillEvent.SkillStartEvent, self.OnSkillUpdate)
end

function MainViewRaidSelectCardPage:InitView()
  local rSize = UIManagerProxy.Instance:GetUIRootSize()
  self.bg = self:FindComponent("Bg", UISprite)
  self.model = self:FindGO("Model")
  self.grid = self:FindComponent("Grid", UIGrid)
  self.showingCardParent = self:FindGO("ShowingCard")
  local foldBtn = self:FindGO("FoldBtn")
  self:AddClickEvent(foldBtn, function()
    self:SetFolded(not self.folded)
  end)
  self.foldBtnTrans = foldBtn.transform
  local skillBtnGrid = self:FindComponent("SkillBtnGrid", UIGrid)
  skillBtnGrid.transform.localPosition = LuaGeometry.GetTempVector3(rSize[1] - 442, 628 - rSize[2])
  self.skillCtrl = ListCtrl.new(skillBtnGrid, ShortCutSkill, "ShortCutSkill")
  self.skillCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickSkill, self)
  self.cells, self.skillDatas = {}, {}
end

function MainViewRaidSelectCardPage:ResetData()
  local results = self:GetRaidSelectResults()
  for i = 1, #results do
    self:UpdateCell(i, results[i])
  end
  for i = #results + 1, #self.cells do
    self.cells[i].go:SetActive(false)
  end
  self:UpdateFolded()
  if self.showingCard then
    self:Hide(self.showingCard)
  end
  self:ClearSkillDatas()
  self:_ForEachSkillOfSelectedCard(function(skillId)
    local data = SkillItemData.new(skillId, 0, 0, 0, 0)
    data.learned = true
    if not skillIns:HasLearnedSkill(skillId) then
      skillIns:LearnedSkill(data)
    end
    TableUtility.ArrayPushBack(self.skillDatas, data)
  end)
  self:OnSkillUpdate()
end

function MainViewRaidSelectCardPage:OnExit()
  if self.showingCard then
    self.showingCard:OnCellDestroy()
  end
  self.skillCtrl:RemoveAll()
  self:ClearSkillDatas()
  MainViewRaidSelectCardPage.super.OnExit(self)
end

function MainViewRaidSelectCardPage:OnFinishLoadScene()
  self:OnReset()
  DungeonProxy.Instance:ResetRaidSelectCard()
end

function MainViewRaidSelectCardPage:OnReset()
  self:sendNotification(MainViewEvent.RemoveDungeonInfoBord, self.__cname)
end

function MainViewRaidSelectCardPage:OnCardReset()
  if self.showingCard then
    self.showingCard:OnCellDestroy()
  end
  self.skillCtrl:RemoveAll()
  self:ClearSkillDatas()
  self:ResetData()
end

function MainViewRaidSelectCardPage:OnClickSkill(obj)
  local id = obj.data.data:GetID()
  if id and id ~= 0 then
    FunctionSkill.Me():TryUseSkill(id, Game.Myself:GetLockTarget())
  end
end

function MainViewRaidSelectCardPage:OnSkillUpdate()
  local arr, data = ReusableTable.CreateArray()
  for i = 1, #self.skillDatas do
    data = self.skillDatas[i]
    if not GameConfig.SkillType[data.staticData.SkillType].isPassive then
      TableUtility.ArrayPushBack(arr, data)
    end
  end
  self.skillCtrl:ResetDatas(arr)
  ReusableTable.DestroyAndClearArray(arr)
end

function MainViewRaidSelectCardPage:UpdateCell(index, id)
  local data = id and Table_SelectCardEffect[id]
  if data then
    local cell = self.cells[index] or self:GetCell(index)
    cell.go:SetActive(true)
    cell.bg.spriteName = qualityBgSpMap[data.Quality]
    DungeonProxy.UpdateRaidSelectCardItem(cell, data, self.LoadPreferb, self)
    self.cells[index] = cell
  end
end

function MainViewRaidSelectCardPage:GetCell(index)
  local cell, go = {}, self:CopyGameObject(self.model, self.grid.gameObject)
  cell.bg = go:GetComponent(UISprite)
  cell.icon = self:FindComponent("Icon", UISprite, go)
  cell.index = index
  cell.go = go
  self:AddClickEvent(go, function()
    self:ShowCardDetail(index)
  end)
  return cell
end

function MainViewRaidSelectCardPage:SetFolded(folded)
  self.folded = folded and true or false
  self:UpdateFolded()
end

function MainViewRaidSelectCardPage:UpdateFolded()
  local length = 40 * (self.folded and 0 or #self:GetRaidSelectResults())
  self.foldBtnTrans.localPosition = LuaGeometry.GetTempVector3(20 + length, 0)
  self.foldBtnTrans.localRotation = Quaternion.Euler(0, 0, self.folded and 0 or 180)
  self.bg.width = 36 + length
  local unfolded = not self.folded
  self.grid.gameObject:SetActive(unfolded)
  if unfolded then
    self.grid:Reposition()
  end
end

function MainViewRaidSelectCardPage:GetRaidSelectResults()
  return DungeonProxy.Instance.raidSelectResults or _EmptyTable
end

function MainViewRaidSelectCardPage:ShowCardDetail(index)
  local results = self:GetRaidSelectResults()
  local id = index and results[index]
  if id then
    if not self.showingCard then
      local go = self:LoadPreferb("cell/RaidSelectCardCell", self.showingCardParent)
      local comp = go:AddComponent(CloseWhenClickOtherPlace)
      comp.isDestroy = false
      comp:AddTarget(self.grid.transform)
      self.showingCard = RaidSelectCardCell.new(go)
      local pagePanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
      self.showingCard:SetDescDepth(pagePanel.depth + 10)
    end
    self.showingCard:SetData(id)
    self:Show(self.showingCard)
    local card, x, y = self.cells[index], 0, 0
    if card then
      x, y = LuaGameObject.GetPosition(card.go.transform)
    end
  end
end

function MainViewRaidSelectCardPage:ClearSkillDatas()
  local sData
  for _, data in pairs(self.skillDatas) do
    sData = skillIns:GetLearnedSkill(data.id)
    if sData then
      skillIns:RemoveLearnedSkill(sData)
    end
  end
  TableUtility.TableClear(self.skillDatas)
end

function MainViewRaidSelectCardPage:_ForEachSkillOfSelectedCard(action)
  local results, id, isSkillCard, skillId = self:GetRaidSelectResults()
  for i = 1, #results do
    id = results[i]
    isSkillCard, skillId = DungeonProxy.IsRaidSelectSkillCard(id)
    if isSkillCard then
      action(skillId)
    end
  end
end
