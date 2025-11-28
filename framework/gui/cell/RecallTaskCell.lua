local baseCell = autoImport("BaseCell")
RecallTaskCell = class("RecallTaskCell", baseCell)
local tipData = {}
tipData.funcConfig = {}

function RecallTaskCell:Init()
  self:FindObjs()
end

function RecallTaskCell:FindObjs()
  self.mask = self:FindGO("mask")
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.rewardIcon = self:FindGO("rewardIcon"):GetComponent(UISprite)
  self.rewardDescLabel = self:FindGO("rewardDesc"):GetComponent(UILabel)
  self.unlockDesc = self:FindGO("unlockDesc"):GetComponent(UILabel)
  self:AddClickEvent(self.rewardIcon.gameObject, function()
    self:ClickItem()
  end)
  self.goBtn = self:FindGO("goBtn")
  self:AddClickEvent(self.goBtn, function()
    FuncShortCutFunc.Me():CallByID(self.gotoMode)
  end)
end

function RecallTaskCell:ClickItem()
  if self.rewarditem then
    local itemData = ItemData.new("", self.rewarditem[1].id)
    if self.rewarditem[1].refinelv and itemData:IsEquip() then
      itemData.equipInfo:SetRefine(self.rewarditem[1].refinelv)
    end
    tipData.itemdata = itemData
    self:ShowItemTip(tipData, self.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

local StartTime = ""
local EndTime = ""

function RecallTaskCell:SetData(data)
  self.id = data.id
  local taskName = data.name
  local iconStr = data.Icon
  if data.Reward then
    self.rewarditem = ItemUtil.GetRewardItemIdsByTeamId(data.Reward)
  end
  local UnlockType = data.UnlockType
  local UnlockID = data.UnlockID
  self.gotoMode = {}
  if data.GotoMode then
    TableUtility.ArrayShallowCopy(self.gotoMode, data.GotoMode)
  end
  local rewardDesc = data.RewardDesc
  local taskDesc = data.Desc
  self.name.text = taskName
  self.desc.text = taskDesc
  self.rewardDescLabel.text = rewardDesc
  local itemData = ItemData.new("", self.rewarditem[1].id)
  IconManager:SetItemIcon(itemData.staticData.Icon, self.rewardIcon)
  IconManager:SetUIIcon(iconStr, self.icon)
  local isShow = true
  if UnlockType == 1 then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    isShow = UnlockID <= mylv
    self.unlockDesc.text = string.format(ZhString.Recall_LevelDesc, UnlockID)
  elseif UnlockType == 2 then
    isShow = FunctionUnLockFunc.Me():CheckCanOpen(UnlockID)
    self.unlockDesc.text = Table_Menu[UnlockID] and Table_Menu[UnlockID].text
  end
  self.goBtn:SetActive(isShow)
  self.unlockDesc.gameObject:SetActive(not isShow)
  self.mask:SetActive(not isShow)
end
