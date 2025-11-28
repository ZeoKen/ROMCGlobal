local BaseCell = autoImport("BaseCell")
DriftBottleCellType3 = class("DriftBottleCellType3", BaseCell)
autoImport("DriftBottleGroupCell")
autoImport("RewardGridCell")

function DriftBottleCellType3:Init()
  DriftBottleCellType3.super.Init(self)
  self:FindObjs()
  self:InitData()
  self:AddCellClickEvent()
end

function DriftBottleCellType3:FindObjs()
  local mainInfo = self:FindGO("MainInfo")
  self.questGroupName = self:FindGO("QuestGroupName"):GetComponent(UILabel)
  self.questDesc = self:FindGO("QuestDesc"):GetComponent(UILabel)
  self.questName = self:FindGO("QuestName"):GetComponent(UILabel)
  self.npcName = self:FindGO("NpcName"):GetComponent(UILabel)
  self.headContainer = self:FindGO("HeadContainer")
  local rewardsPart = self:FindGO("Rewards")
  self.baseExpLabel = self:FindGO("BaseLabel", rewardsPart):GetComponent(UILabel)
  self.jobExpLabel = self:FindGO("JobLabel", rewardsPart):GetComponent(UILabel)
  self.rewardsGrid = self:FindGO("RewardGrid", rewardsPart):GetComponent(UIGrid)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.groupInfo = self:FindGO("GroupInfo")
  local info = self:FindGO("Info")
  self.groupTitle = self:FindGO("GroupTitle", info):GetComponent(UILabel)
  self.groupScrollView = self:FindGO("GroupScrollView", info):GetComponent(UIScrollView)
  self.groupGrid = self:FindGO("GroupGrid", info):GetComponent(UIGrid)
  self.groupListCtrl = UIGridListCtrl.new(self.groupGrid, DriftBottleGroupCell, "DriftBottleGroupCell3")
  self.groupListCtrl:AddEventListener(MouseEvent.MouseClick, self.refreshCurShow, self)
  self.rewardScrollView = self:FindGO("RewardScrollView", info):GetComponent(UIScrollView)
  self.rewardGrid = self:FindGO("RewardGrid", info):GetComponent(UIGrid)
  self.finalRewardCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.finalRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.btnGrid = self:FindGO("BtnGrid"):GetComponent(UIGrid)
  self.acceptBtn = self:FindGO("AcceptBtn")
  self.abandonBtn = self:FindGO("AbandonBtn")
  self.showDetailBtn = self:FindGO("ShowDetailBtn")
  local rewardGridGO = self:FindGO("RewardGrid")
  self.rewardCell = {}
  for i = 1, 4 do
    self.rewardCell[i] = {}
    self.rewardCell[i].GO = self:FindGO("Cell" .. i, rewardGridGO)
    self.rewardCell[i].icon = self:FindGO("Icon", self.rewardCell[i].GO):GetComponent(UISprite)
    self.rewardCell[i].num = self:FindGO("Num", self.rewardCell[i].GO):GetComponent(UILabel)
  end
  self:AddClickEvent(self.acceptBtn, function()
    self:PassEvent(DriftBottleEvent.ClickAcceptBtn, self)
  end)
  self:AddClickEvent(self.abandonBtn, function()
    self:PassEvent(DriftBottleEvent.ClickAbandonBtn, self)
  end)
  self:AddClickEvent(self.showDetailBtn, function()
    self.groupInfo:SetActive(not self.groupInfo.activeSelf)
    self:PassEvent(DriftBottleEvent.ClickShowDetail, self)
  end)
end

function DriftBottleCellType3:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function DriftBottleCellType3:SetData(data)
  xdlog("DriftBottleCellType3 SetData", data)
  self.data = data
  local npcid = data
  if npcid then
    local config = Table_Bottle[npcid]
    local bottlePieceId = config.UnlockPieceID
    self:RefreshPage(npcid)
    self.groupTitle.text = config.GroupName
    local rewardid = config.Reward
    local rewardItem = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
    for i = 1, #rewardItem do
      if rewardItem[i].id == 300 then
        self.baseExpLabel.text = string.format(ZhString.DriftBottle_BaseExp, rewardItem[i].num)
      elseif rewardItem[i].id == 400 then
        self.jobExpLabel.text = string.format(ZhString.DriftBottle_JobExp, rewardItem[i].num)
      end
    end
    local group = config.Group
    self:InitGroupList(group, npcid)
    local finalRewardId = config.Final_Reward
    self:SetFinalReward(finalRewardId)
  end
end

function DriftBottleCellType3:RefreshPage(npcid)
  local config = Table_Bottle[npcid]
  if not config then
    return
  end
  self.questGroupName.text = config.GroupName
  self.questName.text = config.QuestName
  self.questDesc.text = config.Desc
  local targetNpcId = config.QuestNpc
  self:SetNpcData(targetNpcId)
  local rewardid = config.Reward
  local rewardItem = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
  for i = 1, #rewardItem do
    if rewardItem[i].id == 300 then
      self.baseExpLabel.text = string.format(ZhString.DriftBottle_BaseExp, rewardItem[i].num)
    elseif rewardItem[i].id == 400 then
      self.jobExpLabel.text = string.format(ZhString.DriftBottle_JobExp, rewardItem[i].num)
    end
  end
  self:setRewardData(rewardItem)
  local pieceData = DriftBottleProxy.Instance:GetCurPieceData(npcid)
  if pieceData and pieceData.status and pieceData.status == 2 then
    self.finishSymbol:SetActive(true)
  else
    self.finishSymbol:SetActive(false)
  end
end

function DriftBottleCellType3:InitGroupList(group, npcid)
  local groupList = DriftBottleProxy.Instance:GetGroupList(group)
  if groupList and 0 < #groupList then
    table.sort(groupList, function(l, r)
      return l < r
    end)
    self.groupListCtrl:ResetDatas(groupList)
  else
    redlog("BottlePiece表缺少group", group)
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

function DriftBottleCellType3:RefreshGroupList()
end

function DriftBottleCellType3:refreshCurShow(cell)
  xdlog("刷新页数")
  local npcid = cell.id
  self:RefreshPage(npcid)
end

function DriftBottleCellType3:setRewardData(rewardItem)
  local tempList = {}
  for i = 1, #rewardItem do
    if rewardItem[i].id ~= 300 and rewardItem[i].id ~= 400 then
      table.insert(tempList, rewardItem[i])
    end
  end
  for i = 1, 4 do
    if tempList[i] then
      local itemData = Table_Item[tempList[i].id]
      if itemData then
        self.rewardCell[i].GO:SetActive(true)
        self.rewardCell[i].num.text = tempList[i].num
        IconManager:SetItemIcon(itemData.Icon, self.rewardCell[i].icon)
        self.rewardCell[i].icon:MakePixelPerfect()
        local aspect = 80 / self.rewardCell[i].icon.width
        self.rewardCell[i].icon.width = aspect * self.rewardCell[i].icon.width
        self.rewardCell[i].icon.height = aspect * self.rewardCell[i].icon.height
        self.rewardCell[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.45, 0.45, 0.45)
      else
        redlog("Item表缺少ID", tempList[i].id)
      end
    else
      self.rewardCell[i].GO:SetActive(false)
    end
  end
end

function DriftBottleCellType3:SetFinalReward(rewardId)
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

function DriftBottleCellType3:SetNpcData(npcId)
  if npcId then
    local npcdata = Table_Npc[npcId]
    self:Show(self.headContainer)
    if npcdata then
      if not self.targetCell then
        self.targetCell = HeadIconCell.new()
        self.targetCell:CreateSelf(self.headContainer)
        self.targetCell:SetScale(0.55)
        self.targetCell:SetMinDepth(3)
      end
      self.npcName.text = npcdata.NameZh
      local data = ReusableTable.CreateTable()
      local hasSimpleIcon = npcdata.Icon and npcdata.Icon ~= ""
      local showDetailedIcon = npcdata.Body and npcdata.Hair and npcdata.HeadDefaultColor and npcdata.Gender and npcdata.Eye and npcdata.Head
      if showDetailedIcon or not hasSimpleIcon then
        data.bodyID = npcdata.Body or 0
        data.hairID = npcdata.Hair or 0
        data.haircolor = npcdata.HeadDefaultColor or 0
        data.gender = npcdata.Gender or -1
        data.eyeID = npcdata.Eye or 0
        data.headID = npcdata.Head or 0
        self.targetCell:SetData(data)
      else
        self.targetCell:SetSimpleIcon(npcdata.Icon)
      end
      ReusableTable.DestroyTable(data)
    else
      printRed("can't find npcData at id:" .. npcId)
    end
  else
    self:Hide(self.headContainer)
  end
end

function DriftBottleCellType3:HandleClickItem(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {-200, 50})
  end
end

function DriftBottleCellType3:HideConfirmBtn()
  self.acceptBtn:SetActive(false)
  self.btnGrid:Reposition()
end
