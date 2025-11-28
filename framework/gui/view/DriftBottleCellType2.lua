local BaseCell = autoImport("BaseCell")
DriftBottleCellType2 = class("DriftBottleCellType2", BaseCell)
autoImport("DriftBottleGroupCell")

function DriftBottleCellType2:Init()
  DriftBottleCellType2.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DriftBottleCellType2:FindObjs()
  local mainInfo = self:FindGO("MainInfo")
  self.questDesc = self:FindGO("QuestDesc"):GetComponent(UILabel)
  self.questGroupName = self:FindGO("QuestGroupName"):GetComponent(UILabel)
  self.npcName = self:FindGO("NpcName"):GetComponent(UILabel)
  self.headContainer = self:FindGO("HeadContainer")
  local rewardsPart = self:FindGO("Rewards")
  self.baseExpLabel = self:FindGO("BaseLabel", rewardsPart):GetComponent(UILabel)
  self.jobExpLabel = self:FindGO("JobLabel", rewardsPart):GetComponent(UILabel)
  self.rewardsGrid = self:FindGO("RewardGrid", rewardsPart):GetComponent(UIGrid)
  self.btnGrid = self:FindGO("BtnGrid"):GetComponent(UIGrid)
  self.acceptBtn = self:FindGO("AcceptBtn")
  self.abandonBtn = self:FindGO("AbandonBtn")
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
end

function DriftBottleCellType2:SetData(data)
  xdlog("DriftBottleCellType2 SetData")
  self.data = data
  local npcid = data
  if npcid then
    self:RefreshPage(npcid)
  end
end

function DriftBottleCellType2:RefreshPage(npcid)
  local config = Table_Bottle[npcid]
  if not config then
    return
  end
  self.questGroupName.text = config.GroupName
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
end

function DriftBottleCellType2:setRewardData(rewardItem)
  local tempList = {}
  for i = 1, #rewardItem do
    if rewardItem[i].id ~= 300 and rewardItem[i].id ~= 400 then
      table.insert(tempList, rewardItem[i])
    end
  end
  for i = 1, 4 do
    if tempList[i] then
      local itemData = Table_Item[tempList[i].id]
      xdlog("奖品id", tempList[i].id)
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

function DriftBottleCellType2:SetNpcData(npcId)
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
