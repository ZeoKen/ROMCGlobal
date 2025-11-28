AchieveRewardCell = class("AchieveRewardCell", BaseCell)

function AchieveRewardCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function AchieveRewardCell:FindObjs()
  self.achieveName = self:FindComponent("AchieveName", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.finishSymbol = self:FindComponent("FinishSymbol", UISprite)
  self.statusLabel = self:FindComponent("StatusLabel", UILabel)
  self.conditionLabel = self:FindComponent("Condition", UILabel)
  self.recvBtn = self:FindGO("RecvBtn")
  self:AddClickEvent(self.recvBtn, function()
    xdlog("点击领取", self.data.id)
    ServiceAchieveCmdProxy.Instance:CallGetNpcAchieveRewardAchCmd(self.data.id)
  end)
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.itemCell = ItemCell.new(obj)
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  self:AddClickEvent(self.cellContainer, function()
    local itemData = self.itemCell.data
    if itemData then
      local funcData = {}
      funcData.itemdata = itemData
      self:ShowItemTip(funcData, self.itemCell.icon, NGUIUtil.AnchorSide.Center, {-300, -37})
    end
  end)
end

function AchieveRewardCell:AddEvts()
end

function AchieveRewardCell:SetData(data)
  self.data = data
  local emptyData = data == nil
  self.gameObject:SetActive(not emptyData)
  if emptyData then
    return
  end
  local staticData = Table_NpcAchieve[data.id]
  if staticData then
    self.achieveName.text = staticData.Title
    local process = data.process
    local maxProcess = staticData.TargetNum
    if process > maxProcess then
      process = maxProcess
    end
    self.desc.text = string.format(staticData.Desc, process)
    local reward = staticData.Reward
    if reward and 0 < #reward then
      local showReward = reward[1]
      local itemid = showReward[1]
      local num = showReward[2]
      local itemData = ItemData.new("Reward", itemid)
      itemData:SetItemNum(num)
      if itemData then
        self.itemCell:SetData(itemData)
      end
    end
  end
  local isFinish = data.finish_time and 0 < data.finish_time
  local isRewardGet = data.reward_get
  local isLock = data.can_get_reward == false
  self.conditionLabel.gameObject:SetActive(isLock and not isRewardGet)
  self.desc.gameObject:SetActive(not isLock or isRewardGet)
  if isLock then
    local condition = staticData.Condition
    local type = condition.type
    if type == "prestige" then
      local group = condition.group
      local level = condition.level
      local titleConfig = GameConfig.Prestige and GameConfig.Prestige.PrestigeTitle
      if titleConfig and titleConfig[group] then
        self.conditionLabel.text = string.format(ZhString.NpcAchieve_Lock_Prestige, titleConfig[group].level_name, level)
      else
        self.conditionLabel.text = ZhString.NewbieTechTree_Unenabled
      end
    else
      self.conditionLabel.text = ZhString.NewbieTechTree_Unenabled
    end
  end
  self.statusLabel.text = isLock and ZhString.NewbieTechTree_Unenabled or ZhString.NpcAchieve_Status_InProcess
  self.recvBtn.gameObject:SetActive(isFinish and not isRewardGet and not isLock)
  self.statusLabel.gameObject:SetActive(isLock and not isRewardGet or not isFinish and not isRewardGet)
  self.finishSymbol.gameObject:SetActive(isFinish and isRewardGet)
end
