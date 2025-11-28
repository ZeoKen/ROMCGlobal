local BaseCell = autoImport("BaseCell")
DriftBottleCellType1 = class("DriftBottleCellType1", BaseCell)
autoImport("DriftBottleGroupCell")

function DriftBottleCellType1:Init()
  DriftBottleCellType1.super.Init(self)
  self:FindObjs()
  self:InitData()
  self:AddCellClickEvent()
end

function DriftBottleCellType1:FindObjs()
  local mainInfo = self:FindGO("MainInfo")
  self.questGroupName = self:FindGO("QuestGroupName"):GetComponent(UILabel)
  self.questDesc = self:FindGO("QuestDesc"):GetComponent(UILabel)
  self.questTexture = self:FindGO("QuestTexture"):GetComponent(UITexture)
  self.processLabel = self:FindGO("ProcessLabel"):GetComponent(UILabel)
  self.groupInfo = self:FindGO("GroupInfo")
  local info = self:FindGO("Info")
  self.groupTitle = self:FindGO("GroupTitle", info):GetComponent(UILabel)
  self.groupScrollView = self:FindGO("GroupScrollView", info):GetComponent(UIScrollView)
  self.groupGrid = self:FindGO("GroupGrid", info):GetComponent(UIGrid)
  self.groupListCtrl = UIGridListCtrl.new(self.groupGrid, DriftBottleGroupCell, "DriftBottleGroupCell")
  self.groupListCtrl:AddEventListener(MouseEvent.MouseClick, self.refreshCurShow, self)
  self.rewardScrollView = self:FindGO("RewardScrollView", info):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.finalRewardCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.finalRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.btnGrid = self:FindGO("BtnGrid"):GetComponent(UIGrid)
  self.acceptBtn = self:FindGO("AcceptBtn")
  self.abandonBtn = self:FindGO("AbandonBtn")
  self:AddClickEvent(self.acceptBtn, function()
    self:PassEvent(DriftBottleEvent.ClickAcceptBtn, self)
  end)
  self:AddClickEvent(self.abandonBtn, function()
    self:PassEvent(DriftBottleEvent.ClickAbandonBtn, self)
  end)
end

function DriftBottleCellType1:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function DriftBottleCellType1:SetData(data)
  xdlog("DriftBottleCellType1 SetData")
  self.data = data
  local npcid = data
  if npcid then
    local config = Table_Bottle[npcid]
    self.groupTitle.text = config.GroupName
    local group = config.Group
    self:InitGroupList(group, npcid)
    self:RefreshPage(npcid)
    local finalRewardId = config.Final_Reward
    self:SetFinalReward(finalRewardId)
  end
end

function DriftBottleCellType1:RefreshPage(npcid)
  local config = Table_Bottle[npcid]
  if config then
    self.questGroupName.text = config.GroupName
    self.questDesc.text = config.Desc
  end
  local group = config.Group
  local groupList = DriftBottleProxy.Instance:GetGroupList(group)
  self.processLabel.text = ""
  for i = 1, #groupList do
    if groupList[i] == npcid then
      self.processLabel.text = i .. "/" .. self.groupListCount
    end
  end
  if config.Texture and config.Texture ~= "" then
    self.texturePath = config.Texture
    PictureManager.Instance:SetDriftbottleTexture(self.texturePath, self.questTexture)
  else
    self.questTexture.gameObject:SetActive(false)
  end
end

function DriftBottleCellType1:InitGroupList(group, npcid)
  local groupList = DriftBottleProxy.Instance:GetGroupList(group)
  if groupList and 0 < #groupList then
    self.groupListCount = #groupList
    table.sort(groupList, function(l, r)
      return l < r
    end)
    self.groupListCtrl:ResetDatas(groupList)
  else
    redlog("BottlePiece表缺少group", group)
    return
  end
  local cells = self.groupListCtrl:GetCells()
  for i = 1, #cells do
    local single = cells[i]
    if single.id == npcid then
      single:SetQuestName(1)
      single:SetStatusIcon(1)
      single:SetClickAble(true)
    end
  end
end

function DriftBottleCellType1:refreshCurShow(cell)
  xdlog("刷新页数")
  local bottlePieceid = cell.id
  self:RefreshPage(bottlePieceid)
end

function DriftBottleCellType1:SetFinalReward(rewardId)
  if not rewardId then
    return
  end
  local array = {}
  local list = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if list then
    for j = 1, #list do
      local single = list[j]
      local hasAdd = false
      for j = 1, #array do
        local temp = array[j]
        if temp.itemData.id == single.id then
          temp.num = temp.num + single.num
          hasAdd = true
          break
        end
      end
      if not hasAdd then
        local data = {}
        data.itemData = ItemData.new("Reward", single.id)
        if data.itemData then
          data.num = single.num
          table.insert(array, data)
        end
      end
    end
    self.finalRewardCtrl:ResetDatas(array)
  end
end

function DriftBottleCellType1:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-200, 50})
  end
end

function DriftBottleCellType1:OnDestroy()
  if self.texturePath then
    PictureManager.Instance:UnloadDriftbottleTexture(self.texturePath, self.questTexture)
  end
end
