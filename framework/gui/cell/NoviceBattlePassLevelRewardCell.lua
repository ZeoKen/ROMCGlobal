autoImport("BaseCell")
NoviceBattlePassLevelRewardCell = class("NoviceBattlePassLevelRewardCell", BaseCell)

function NoviceBattlePassLevelRewardCell:SetBPType(bPType)
  self.bPType = bPType
end

function NoviceBattlePassLevelRewardCell:GetIsNormalRewardReceived(level)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:IsNormalReturnRewardReceived(level)
  end
  return NoviceBattlePassProxy.Instance:IsNormalRewardReceived(level)
end

function NoviceBattlePassLevelRewardCell:GetIsNormalRewardLocked(level)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:IsNormalReturnRewardLocked(level)
  end
  return NoviceBattlePassProxy.Instance:IsNormalRewardLocked(level)
end

function NoviceBattlePassLevelRewardCell:GetIsProRewardReceived(level)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:IsProReturnRewardReceived(level)
  end
  return NoviceBattlePassProxy.Instance:IsProRewardReceived(level)
end

function NoviceBattlePassLevelRewardCell:GetIsProRewardLocked(level)
  if self.bPType == 2 then
    return NoviceBattlePassProxy.Instance:IsProReturnRewardLocked(level)
  end
  return NoviceBattlePassProxy.Instance:IsProRewardLocked(level)
end

function NoviceBattlePassLevelRewardCell:CallBPTargetRewardCmd(is_all, lv)
  if self.bPType == 2 then
    ServiceNoviceBattlePassProxy.Instance:CallReturnBPTargetRewardCmd(is_all, lv)
    return
  end
  ServiceNoviceBattlePassProxy.Instance:CallNoviceBPTargetRewardCmd(is_all, lv)
end

function NoviceBattlePassLevelRewardCell:Init()
  NoviceBattlePassLevelRewardCell.super.Init(self)
  self:FindObjs()
end

function NoviceBattlePassLevelRewardCell:FindObjs()
  self.bg1 = self:FindGO("BGA")
  self.bg2 = self:FindGO("BGB")
  self.levelLabel = self:FindComponent("Level", UILabel)
  local basic = self:FindGO("Basic")
  self.basicReceivedCheck = self:FindGO("get", basic)
  self.basicLock = self:FindGO("lock", basic)
  self.basicHolder = self:FindGO("holder", basic)
  local advGridGO = self:FindGO("AdvGrid")
  self.advGrid = advGridGO:GetComponent(UIGrid)
  self.adv = self:FindGO("Adv", advGridGO)
  self.advReceivedCheck = self:FindGO("get", self.adv)
  self.advLock = self:FindGO("lock", self.adv)
  self.advHolder = self:FindGO("holder", self.adv)
  self.adv2 = self:FindGO("Adv2", advGridGO)
  self.advReceivedCheck2 = self:FindGO("get", self.adv2)
  self.advLock2 = self:FindGO("lock", self.adv2)
  self.advHolder2 = self:FindGO("holder", self.adv2)
  self.basicMask = self:FindGO("BasicCover")
  self.advMask = self:FindGO("AdvCover")
  self.basicGetBtn = self:FindGO("BasicGetBtn")
  self.advGetBtn = self:FindGO("AdvGetBtn")
  self.advGetBtn:SetActive(false)
  self:AddClickEvent(self.basicGetBtn, function()
    self:CallBPTargetRewardCmd(false, self.level)
  end)
  self:AddClickEvent(basic, function()
    self:HandleClickRewardIcon(self.basicItemCell)
  end)
  self:AddClickEvent(self.adv, function()
    self:HandleClickRewardIcon(self.advItemCell1)
  end)
  self:AddClickEvent(self.adv2, function()
    self:HandleClickRewardIcon(self.advItemCell2)
  end)
  self:SetShowType()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function NoviceBattlePassLevelRewardCell:SetData(data)
  if data then
    self.level = data.Level
    self.levelLabel.text = string.format(ZhString.GuildFindPage_NeedLv, self.level)
    local basicRewardItem = data.RewardItems[1]
    local proRewardItem1 = data.ProRewardItems[1]
    local proRewardItem2 = data.ProRewardItems[2]
    if not self.basicItemCell then
      self.basicItemCell = self:SetRewardIcon(basicRewardItem, self.basicHolder)
    else
      local data = self.basicItemCell.data
      data:ResetData(basicRewardItem.itemid, basicRewardItem.itemid)
      data:SetItemNum(basicRewardItem.num)
      self.basicItemCell:SetData(data)
    end
    if not self.advItemCell1 then
      self.advItemCell1 = self:SetRewardIcon(proRewardItem1, self.advHolder)
    else
      local data = self.advItemCell1.data
      data:ResetData(proRewardItem1.itemid, proRewardItem1.itemid)
      data:SetItemNum(proRewardItem1.num)
      self.advItemCell1:SetData(data)
    end
    if not self.advItemCell2 then
      self.advItemCell2 = self:SetRewardIcon(proRewardItem2, self.advHolder2)
    else
      local data = self.advItemCell2.data
      data:ResetData(proRewardItem2.itemid, proRewardItem2.itemid)
      data:SetItemNum(proRewardItem2.num)
      self.advItemCell2:SetData(data)
    end
    if not self.advItemCell2 then
      self.adv2:SetActive(false)
    end
    self.advGrid:Reposition()
    self:RefreshRecvState(self.level)
  end
end

function NoviceBattlePassLevelRewardCell:SetRewardIcon(data, holder)
  if not data then
    return
  end
  local itemCell = BagItemCell.new(holder)
  itemCell:AddCellClickEvent()
  local itemData = ItemData.new(data.itemid, data.itemid)
  itemData:SetItemNum(data.num)
  itemCell:SetData(itemData)
  return itemCell
end

function NoviceBattlePassLevelRewardCell:SetShowType(type)
  self.showType = type
  if type == 2 then
    self.bg1:SetActive(false)
    self.bg2:SetActive(true)
    self.basicMask:SetActive(false)
    self.advMask:SetActive(false)
  else
    self.bg1:SetActive(true)
    self.bg2:SetActive(false)
  end
end

function NoviceBattlePassLevelRewardCell:RefreshRecvState(level)
  local isBasicReceived = self:GetIsNormalRewardReceived(level)
  local isBasicLocked = self:GetIsNormalRewardLocked(level)
  self.basicReceivedCheck:SetActive(isBasicReceived)
  self.basicLock:SetActive(isBasicLocked)
  self.basicMask:SetActive(self.showType ~= 2 and isBasicLocked)
  local isAdvReceived = self:GetIsProRewardReceived(level)
  local isAdvLocked = self:GetIsProRewardLocked(level)
  self.advReceivedCheck:SetActive(isAdvReceived)
  self.advReceivedCheck2:SetActive(isAdvReceived)
  self.advLock:SetActive(isAdvLocked)
  self.advLock2:SetActive(isAdvLocked)
  self.advMask:SetActive(self.showType ~= 2 and isAdvLocked)
  self.basicGetBtn:SetActive(not isBasicLocked and not isBasicReceived or not isAdvLocked and not isAdvReceived)
end

function NoviceBattlePassLevelRewardCell:HandleClickRewardIcon(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    local x, y, z = NGUIUtil.GetUIPositionXYZ(cellCtrl.icon.gameObject)
    if 0 < x then
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-280, 0})
    else
      self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Right, {280, 0})
    end
  end
end
