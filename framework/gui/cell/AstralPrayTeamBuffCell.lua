AstralPrayTeamBuffCell = class("AstralPrayTeamBuffCell", BaseCell)

function AstralPrayTeamBuffCell:Init()
  self:FindObjs()
end

function AstralPrayTeamBuffCell:FindObjs()
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.check = self:FindGO("Check")
  self.unactiveGO = self:FindGO("Unactive")
end

function AstralPrayTeamBuffCell:SetData(data)
  self.data = data
  if data then
    local buffId = data.buffId
    local prayedNum = data.prayedNum
    local level = self.indexInList
    local config = Table_Buffer[buffId]
    local levelCondition = GameConfig.Astral and GameConfig.Astral.LevelCondition
    local teamMemberTarget = levelCondition and levelCondition[level] or 0
    local isActive = prayedNum >= teamMemberTarget
    local col = isActive and "f36c1a" or "808080"
    self.descLabel.text = string.format(ZhString.Pve_Astral_TeamBuffDesc, col, level, config and config.BuffDesc or "")
    self.check:SetActive(isActive)
    self.unactiveGO:SetActive(not isActive)
    local lineHeight = self.descLabel.fontSize + self.descLabel.spacingY
    self.lineCount = math.ceil(self.descLabel.height / lineHeight)
  end
end
