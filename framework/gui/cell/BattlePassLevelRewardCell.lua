BattlePassLevelRewardCell = class("BattlePassLevelRewardCell", BaseCell)

function BattlePassLevelRewardCell:Init()
  BattlePassLevelRewardCell.super.Init(self)
  self:FindObjs()
end

function BattlePassLevelRewardCell:FindObjs()
  self.cellgo = self:FindGO("cell")
  self.name = self:FindComponent("Level", UILabel)
  self.bg1 = self:FindGO("BGA")
  self.bg2 = self:FindGO("BGB")
  self.basicCon = {
    go = self:FindGO("Basic"),
    get = self:FindGO("get", self:FindGO("Basic")),
    lock = self:FindGO("lock", self:FindGO("Basic")),
    select = self:FindGO("select", self:FindGO("Basic")),
    mt1 = self:FindGO("mt1", self:FindGO("Basic")),
    mt2 = self:FindGO("mt2", self:FindGO("Basic"))
  }
  self.adv1Con = {
    go = self:FindGO("Adv"),
    get = self:FindGO("get", self:FindGO("Adv")),
    lock = self:FindGO("lock", self:FindGO("Adv")),
    select = self:FindGO("select", self:FindGO("Adv")),
    mt1 = self:FindGO("mt1", self:FindGO("Adv")),
    mt2 = self:FindGO("mt2", self:FindGO("Adv"))
  }
  self.adv2Con = {
    go = self:FindGO("Coll"),
    get = self:FindGO("get", self:FindGO("Coll")),
    lock = self:FindGO("lock", self:FindGO("Coll")),
    select = self:FindGO("select", self:FindGO("Coll")),
    mt1 = self:FindGO("mt1", self:FindGO("Coll")),
    mt2 = self:FindGO("mt2", self:FindGO("Coll"))
  }
  self.Con = {
    self.basicCon,
    self.adv1Con,
    self.adv2Con
  }
  self.ConRev = {
    [self.basicCon.go] = self.basicCon,
    [self.adv1Con.go] = self.adv1Con,
    [self.adv2Con.go] = self.adv2Con
  }
  self.basicCover = self:FindGO("BasicCover")
  self.advCover = self:FindGO("AdvCover")
  self.collCover = self:FindGO("CollCover")
  self.getBtn = self:FindGO("GetBtn")
  self:AddClickEvent(self.getBtn, function()
    self:GetLevelReward()
  end)
  for i = 1, #self.Con do
    self:AddClickEvent(self.Con[i].go, function(go)
      local icon = self.ConRev[go]
      if icon.multi and icon.select.activeSelf then
        self:SwitchShowRewardIcon(icon)
      end
      self:PassEvent(BattlePassEvent.LevelViewSelectRewardIcon, icon.itemid)
      icon.select:SetActive(true)
    end)
  end
  self.collParts = {}
  self.collParts[1] = self.adv2Con.go
  self.collParts[2] = self.collCover
  self.collParts[3] = self:FindGO("BGA3")
  self.collParts[4] = self:FindGO("BGB3")
end

function BattlePassLevelRewardCell:SetShowType(type, exhandler, exhandlerowner)
  if type == 1 then
    self.bg1:SetActive(true)
    self.bg2:SetActive(false)
    self.basicCover:SetActive(false)
    self.advCover:SetActive(false)
    self.collCover:SetActive(false)
    self.getBtn:SetActive(false)
    for i = 1, #self.Con do
      self:AddClickEvent(self.Con[i].go, function(go)
        local icon = self.ConRev[go]
        if icon.multi and icon.select.activeSelf then
          self:SwitchShowRewardIcon(icon)
        end
        exhandler(exhandlerowner, icon.itemid)
        icon.select:SetActive(true)
      end)
    end
  else
    self.bg1:SetActive(false)
    self.bg2:SetActive(true)
  end
end

function BattlePassLevelRewardCell:SetData(data)
  if not data then
    self.cellgo:SetActive(false)
    return
  end
  self.cellgo:SetActive(true)
  self.data = data
  self.level = data.Level or 0
  self.name.text = data.IsOverflowReward and ZhString.BattlePassLevelView_OverflowReward or "Lv" .. self.level
  self.name.gameObject:SetActive(true)
  self:SetRewardIcon(self.basicCon, data.ReplaceRewardItems or data.RewardItems)
  self:SetRewardIcon(self.adv1Con, data.ReplaceProRewardItems or data.ProRewardItems)
  self:SetRewardIcon(self.adv2Con, data.ReplaceSuperRewardItems or data.SuperRewardItems)
  self:UpdateStatus()
  self:SetAllRewardUnSelect()
  local hasColl = BattlePassProxy.Instance:HasColPass()
  if self.collParts then
    for i = 1, #self.collParts do
      self.collParts[i]:SetActive(hasColl)
    end
    if self:IsOverflowReward() then
      self.adv2Con.go:SetActive(hasColl and self.isSuHasReward)
      self.collCover:SetActive(self.isSuHasReward and self.isSuLock and hasColl)
    else
      self.collCover:SetActive(self.isSuLock and hasColl)
    end
  end
end

function BattlePassLevelRewardCell:IsOverflowReward()
  return self.data and self.data.IsOverflowReward
end

function BattlePassLevelRewardCell:SetAllRewardUnSelect()
  for i = 1, #self.Con do
    self.Con[i].select:SetActive(false)
  end
end

function BattlePassLevelRewardCell:UpdateStatus()
  if self:IsOverflowReward() then
    self:UpdateOverflowStatus()
    return
  end
  self.isNormalGet = BattlePassProxy.Instance:IsNormalRewardGet(self.level)
  self.isAdvGet = BattlePassProxy.Instance:IsAdvRewardGet(self.level)
  self.isSuGet = BattlePassProxy.Instance:IsSuRewardGet(self.level)
  self.isNormalLock = self.level > BattlePassProxy.BPLevel()
  self.isAdvLock = self.level > BattlePassProxy.BPLevel() or self.level > BattlePassProxy.Instance:AdvLevel()
  self.isSuLock = self.level > BattlePassProxy.BPLevel() or self.level > BattlePassProxy.Instance:SuLevel()
  self.isNormalHasReward = self.data.ReplaceRewardItems ~= nil or self.data.RewardItems and #self.data.RewardItems > 0 or false
  self.isAdvHasReward = self.data.ReplaceProRewardItems ~= nil or self.data.ProRewardItems and 0 < #self.data.ProRewardItems or false
  self.isSuHasReward = self.data.ReplaceSuperRewardItems ~= nil or self.data.SuperRewardItems and 0 < #self.data.SuperRewardItems or false
  self.isNormalAvail = not self.isNormalGet and not self.isNormalLock and self.isNormalHasReward
  self.isAdvAvail = not self.isAdvGet and not self.isAdvLock and self.isAdvHasReward
  self.isSuAvail = not self.isSuGet and not self.isSuLock and self.isSuHasReward
  self.basicCover:SetActive(self.isNormalLock)
  self.advCover:SetActive(self.isAdvLock)
  local hasColl = BattlePassProxy.Instance:HasColPass()
  self.collCover:SetActive(self.isSuLock and hasColl)
  self:UpdateRewardIcon(self.basicCon, self.isNormalGet, self.isNormalLock)
  self:UpdateRewardIcon(self.adv1Con, self.isAdvGet, self.isAdvLock)
  self:UpdateRewardIcon(self.adv2Con, self.isSuGet, self.isSuLock)
  self.getBtn:SetActive(self.isNormalAvail or self.isAdvAvail or self.isSuAvail)
end

function BattlePassLevelRewardCell:UpdateOverflowStatus()
  local proxy = BattlePassProxy.Instance
  local data = proxy:GetOverflowRewardConfig() or self.data
  self.data = data
  if not data then
    return
  end
  local hasColl = proxy:HasColPass()
  self:SetRewardIcon(self.basicCon, data.RewardItems)
  self:SetRewardIcon(self.adv1Con, data.ProRewardItems)
  self:SetRewardIcon(self.adv2Con, hasColl and data.SuperRewardItems or nil)
  local isFullLevel = BattlePassProxy.BPLevel() >= (proxy.maxBpLevel or 0)
  local overflowTotalRounds = proxy:GetOverflowTotalRounds()
  local normalAvailableRounds = proxy:GetOverflowNormalAvailableRounds()
  local proAvailableRounds = proxy:GetOverflowProAvailableRounds()
  local superAvailableRounds = proxy:GetOverflowSuperAvailableRounds()
  self.isNormalHasReward = data.RewardItems and #data.RewardItems > 0 or false
  self.isAdvHasReward = data.ProRewardItems and #data.ProRewardItems > 0 or false
  self.isSuHasReward = hasColl and data.SuperRewardItems and #data.SuperRewardItems > 0 or false
  self.isNormalLock = not isFullLevel
  self.isAdvLock = not isFullLevel or 0 >= (proxy:AdvLevel() or 0)
  self.isSuLock = not isFullLevel or 0 >= (proxy:SuLevel() or 0)
  self.isNormalAvail = isFullLevel and not self.isNormalLock and self.isNormalHasReward and data.NormalOverflowAvailable
  self.isAdvAvail = isFullLevel and not self.isAdvLock and self.isAdvHasReward and data.ProOverflowAvailable
  self.isSuAvail = isFullLevel and not self.isSuLock and self.isSuHasReward and data.SuperOverflowAvailable
  self.isNormalGet = self.isNormalHasReward and not self.isNormalLock and 0 < overflowTotalRounds and normalAvailableRounds <= 0
  self.isAdvGet = self.isAdvHasReward and not self.isAdvLock and 0 < overflowTotalRounds and proAvailableRounds <= 0
  self.isSuGet = self.isSuHasReward and not self.isSuLock and 0 < overflowTotalRounds and superAvailableRounds <= 0
  self.basicCover:SetActive(self.isNormalHasReward and self.isNormalLock)
  self.advCover:SetActive(self.isAdvHasReward and self.isAdvLock)
  self.collCover:SetActive(self.isSuHasReward and self.isSuLock and hasColl)
  self:UpdateRewardIcon(self.basicCon, self.isNormalGet, self.isNormalHasReward and self.isNormalLock)
  self:UpdateRewardIcon(self.adv1Con, self.isAdvGet, self.isAdvHasReward and self.isAdvLock)
  self:UpdateRewardIcon(self.adv2Con, self.isSuGet, self.isSuHasReward and self.isSuLock)
  local canGet = self.isNormalAvail or self.isAdvAvail or self.isSuAvail
  self.getBtn:SetActive(canGet)
  self.name.gameObject:SetActive(not canGet)
end

function BattlePassLevelRewardCell:SetRewardIcon(icon, data)
  if not icon then
    return
  end
  icon.data = data
  if not data or #data == 0 then
    icon.showidx = 1
    icon.itemid = 0
    icon.multi = false
    icon.go:SetActive(false)
  else
    icon.showidx = 1
    local sData = icon.data[icon.showidx]
    icon.itemid = sData.itemid
    if not icon.item then
      icon.item = BagItemCell.new(self:FindGO("holder", icon.go))
    end
    local itemData = ItemData.new("", sData.itemid)
    itemData:SetItemNum(sData.num or 1)
    icon.item:SetData(itemData)
    icon.go:SetActive(true)
    icon.mt1:SetActive(#icon.data > 1)
    icon.mt2:SetActive(#icon.data > 2)
    icon.multi = #icon.data > 1
  end
end

function BattlePassLevelRewardCell:SwitchShowRewardIcon(icon)
  if icon.multi then
    icon.showidx = icon.showidx % #icon.data + 1
    local sData = icon.data[icon.showidx]
    icon.itemid = sData.itemid
    if not icon.item then
      icon.item = BagItemCell.new(self:FindGO("holder", icon.go))
    end
    local itemData = ItemData.new("", sData.itemid)
    itemData:SetItemNum(sData.num or 1)
    icon.item:SetData(itemData)
  end
end

function BattlePassLevelRewardCell:UpdateRewardIcon(icon, isGet, isLock)
  if not icon then
    return
  end
  icon.get:SetActive(isGet)
  icon.lock:SetActive(isLock)
end

function BattlePassLevelRewardCell:GetLevelReward()
  if self:IsOverflowReward() then
    if self.isNormalAvail or self.isAdvAvail or self.isSuAvail then
      ServiceBattlePassProxy.Instance:CallGetRewardBattlePassCmd(nil, nil, nil, nil, true)
    end
    return
  end
  if self.isNormalAvail then
    ServiceBattlePassProxy.Instance:CallGetRewardBattlePassCmd(nil, self.level, nil, nil)
  end
  if self.isAdvAvail then
    ServiceBattlePassProxy.Instance:CallGetRewardBattlePassCmd(nil, nil, self.level, nil)
  end
  if self.isSuAvail then
    ServiceBattlePassProxy.Instance:CallGetRewardBattlePassCmd(nil, nil, nil, self.level)
  end
end

function BattlePassLevelRewardCell:OnCellDestroy()
  self:DestroyBagItemCell(self.basicCon.item)
  self:DestroyBagItemCell(self.adv1Con.item)
  self:DestroyBagItemCell(self.adv2Con.item)
  TableUtility.TableClear(self)
end

function BattlePassLevelRewardCell:DestroyBagItemCell(bagItemCell)
  if bagItemCell then
    if bagItemCell.OnCellDestroy and type(bagItemCell.OnCellDestroy) == "function" then
      bagItemCell:OnCellDestroy()
    end
    TableUtility.TableClear(bagItemCell)
    bagItemCell = nil
  end
end
