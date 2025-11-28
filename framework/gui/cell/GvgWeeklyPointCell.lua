local _ArrayPushBack = TableUtility.ArrayPushBack
local _TopColor = "[c][f97c21]%d[-][/c]"
local _Color = "[c][4059a8]%d[-][/c]"
GvgWeeklyPointCell = class("GvgWeeklyPointCell", BaseCell)

function GvgWeeklyPointCell:Init()
  self:FindObj()
end

function GvgWeeklyPointCell:FindObj()
  self.root = self:FindGO("Root")
  self.pointLabs = {}
  _ArrayPushBack(self.pointLabs, self:FindComponent("RankLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("DefenseLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("AttackLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("PerfectDefenseLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("OccupiedLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("StepByStepOccLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("ScorePointLab", UILabel, self.root))
  _ArrayPushBack(self.pointLabs, self:FindComponent("ResultLab", UILabel, self.root))
end

function GvgWeeklyPointCell:SetData(data)
  self.data = data
  local dataArray = data and data.dataArray
  if not dataArray then
    self:Hide(self.root)
    return
  end
  self:Show(self.root)
  for i = 1, #self.pointLabs do
    local value = dataArray[i] or 0
    if i == 1 then
      self.pointLabs[i].text = string.format(ZhString.GvgWeeklyPoint_IndexFormat, value)
    elseif i == #self.pointLabs then
      if data.isTop then
        self.pointLabs[i].text = string.format(_TopColor, value)
      else
        self.pointLabs[i].text = string.format(_Color, value)
      end
    else
      self.pointLabs[i].text = value
    end
  end
end
