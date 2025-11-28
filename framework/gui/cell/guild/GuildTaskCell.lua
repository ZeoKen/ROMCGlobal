local BaseCell = autoImport("BaseCell")
autoImport("ItemCell")
GuildTaskCell = class("GuildTaskCell", BaseCell)
local pos = LuaVector3.Zero()

function GuildTaskCell:Init()
  self:FindObjs()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GuildTaskCell:FindObjs()
  self.taskName = self:FindComponent("TaskName", UILabel)
  self.desc = self:FindComponent("Desc", UILabel)
  self.progress = self:FindComponent("Progress", UILabel)
  self.canRewardLab = self:FindComponent("CanRewardLab", UILabel)
  self.canRewardLab.text = ZhString.GuildChallenge_CanReward
  self.markObj = self:FindGO("MarkObj")
  local rewardRoot = self:FindGO("RewardRoot")
  local rewardObj = self:LoadPreferb("cell/ItemCell", rewardRoot)
  rewardObj.transform.localPosition = LuaGeometry.GetTempVector3()
  self.rewardCell = ItemCell.new(rewardObj)
  self.taskBg1 = self:FindGO("TaskBg1")
  self.taskBg2 = self:FindGO("TaskBg2")
end

function GuildTaskCell:SetData(data)
  self:_ClearTick()
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.taskName.text = data.name
  self.desc.text = data.desc
  local sizeX = self.taskName.localSize.x
  local posX = sizeX / 2 + 28
  pos[1] = posX
  self.taskBg1.transform.localPosition = pos
  pos[1] = -posX
  self.taskBg2.transform.localPosition = pos
  self.rewardCell:SetData(data.reward_item)
  self.canRewardLab.gameObject:SetActive(data.reward)
  if self.data.isChallenge then
    self.progress.text = data.progress
    self.markObj:SetActive(data.isFinished == true and not data.reward)
  else
    if not self.timeTick then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTick, self, 1)
    end
    self.markObj:SetActive(false)
  end
end

function GuildTaskCell:_UpdateTick()
  local refreshtime = self.data.refreshTime
  if not refreshtime then
    self:_ClearTick()
    return
  end
  local time = refreshtime - ServerTime.CurServerTime() / 1000
  if 0 < time then
    local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(time)
    self.progress.text = string.format(ZhString.GuildChallenge_RefreshTime, day * 24 + hour, min, sec)
  else
    self:_ClearTick()
  end
end

function GuildTaskCell:_ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end

function GuildTaskCell:OnCellDestroy()
  self:_ClearTick()
end
