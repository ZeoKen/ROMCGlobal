local BaseCell = autoImport("BaseCell")
MapBoardQuestCell = class("BMLeftChildCell", BaseCell)
autoImport("CommonRewardCell")
local calSize = NGUIMath.CalculateRelativeWidgetBounds

function MapBoardQuestCell:Init()
  self.bg = self:FindGO("QuestInfoBG")
  self.bgSprite = self:FindComponent("QuestInfoBG", UIWidget)
  self.label = self:FindComponent("Label", UILabel)
  self.Img = self:FindComponent("Img", UISprite)
  self.title = self:FindComponent("Title", UILabel)
  self.indexLabel = self:FindComponent("IndexLabel", UILabel)
  self.desc = self:FindComponent("Desc", UIRichLabel)
  self.desc = SpriteLabel.new(self.desc, nil, 20, 20)
  self.line = self:FindGO("Line")
  self.table = self:FindComponent("Table", UITable)
  self.tableGO = self:FindGO("Table")
  self.multiReward = self:FindGO("MultiReward")
  self.describeBtn = self:FindGO("DescribeBtn")
  self.rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardCtl = UIGridListCtrl.new(self.rewardGrid, CommonRewardCell, "CommonRewardCell")
  self:SetEvent(self.bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.showDescription = false
  self:AddClickEvent(self.describeBtn, function()
    self:SwitchDescription()
    self.table:Reposition()
    local size = calSize(self.table.transform)
    local height = size.size.y
    self.bgSprite.height = height + 60
    self:PassEvent("MapBoardQuestcell_ClickDescribeBtn", self)
  end)
end

function MapBoardQuestCell:SetData(data)
  if data == nil then
    return
  end
  self.data = data
  self.title.text = data.traceTitle
  self.indexLabel.text = self.indexInList .. "."
  local worldQuestTable = Table_WorldQuest
  if worldQuestTable and worldQuestTable[self.data.id] then
    self.describeBtn.gameObject:SetActive(true)
  else
    self.describeBtn.gameObject:SetActive(false)
  end
  local desStr = data:parseTranceInfo()
  if desStr == "" and data.map then
    desStr = Table_Map[data.map].NameZh
  end
  self.desc:SetText(desStr)
  self.multiReward:SetActive(false)
  local rewards = QuestProxy.Instance:GetReplacedRewardByQuestData(data)
  local rewardList = {}
  if data.rewards then
    for i = 1, #data.rewards do
      local single = data.rewards[i]
      if single then
        local itemData = Table_Item[single.id]
        if itemData then
          itemData.num = single.count
          table.insert(rewardList, itemData)
        else
          redlog("Table_Item中找不到" .. single.id)
        end
      else
        break
      end
    end
    self.rewardCtl:ResetDatas(rewardList)
  elseif rewards and 1 < #rewards then
    self.line.gameObject:SetActive(true)
    self.multiReward:SetActive(true)
  else
    if rewards and 0 < #rewards then
      self.line.gameObject:SetActive(true)
      local rewardId = rewards[1]
      if rewardId then
        local items = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
        for i = 1, #items do
          local item = items[i]
          local itemData = Table_Item[item.id]
          if itemData then
            itemData.num = item.num
            table.insert(rewardList, itemData)
          else
            redlog("Table_Item中找不到" .. item.id)
          end
        end
        self.rewardCtl:ResetDatas(rewardList)
      else
        redlog("rewardID is nil")
      end
    else
    end
  end
  self.table:Reposition()
  local size = calSize(self.table.transform)
  local height = size.size.y
  self.bgSprite.height = height + 40
end

function MapBoardQuestCell:setISShowDir(bool)
end

function MapBoardQuestCell:SwitchDescription()
  if not self.showDescription then
    local worldQuestTable = Table_WorldQuest
    if worldQuestTable and worldQuestTable[self.data.id] then
      local desStr = worldQuestTable[self.data.id].Describe
      self.desc:SetText(desStr)
      self.showDescription = true
    else
      redlog("世界任务ID" .. self.data.id .. "在worldquest表格中不存在Describe,请检查")
    end
  else
    local desStr = self.data:parseTranceInfo()
    self.desc:SetText(desStr)
    self.showDescription = false
  end
end
