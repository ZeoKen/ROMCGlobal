local baseCell = autoImport("BaseCell")
AierBlacksmithWantedCell = class("AierBlacksmithWantedCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function AierBlacksmithWantedCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function AierBlacksmithWantedCell:FindObjs()
  self.nameLb = self:FindComponent("lb1", UILabel)
  self.headContainer = self:FindGO("head")
  self.finMark = self:FindGO("finMark")
  self.rewardSp = self:FindComponent("rewardicon", UISprite)
  self.rewardLb = self:FindComponent("reward", UILabel)
  self.gotoBtn = self:FindGO("gotoBtn")
  self:SetEvent(self.gotoBtn, function()
    if self.cfg and self.cfg.ShortcutPowerID then
      FuncShortCutFunc.Me():CallByID(self.cfg.ShortcutPowerID)
    end
  end)
end

function AierBlacksmithWantedCell:SetData(data)
  self.data = data
  if data == nil then
    self:Hide()
    return
  end
  self:Show()
  self:SetNpcData(data.info and data.info.MonsterID)
  self.finMark:SetActive(data.killed)
  self.gotoBtn:SetActive(not data.killed)
  if data.killed then
  else
  end
  local rewardCfg = data.info
  self.cfg = rewardCfg
  local reward = rewardCfg.DailyReward
  if type(reward) == "table" then
    reward = reward[1]
  end
  reward = ItemUtil.GetRewardItemIdsByTeamId(reward) or ItemUtil.GetRewardItemIdsByTeamId(6122)
  reward = reward[1]
  local cfg = Table_Item[reward.id]
  UIUtil.TempSetItemIcon(self.rewardSp, cfg.Icon, 45)
  self.rewardLb.text = "+" .. reward.num
end

function AierBlacksmithWantedCell:SetNpcData(npcId)
  local npcdata = Table_Monster[npcId] or Table_Npc[npcId]
  self.nameLb.text = tostring(npcId)
  if npcdata then
    if not self.targetCell then
      self.targetCell = HeadIconCell.new()
      self.targetCell:CreateSelf(self.headContainer)
      self.targetCell:SetScale(1)
      self.targetCell:SetMinDepth(3)
      self.targetCell:HideFrame()
    end
    self.nameLb.text = npcdata.NameZh
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
  end
end
