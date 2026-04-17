AsyncPvpRaidAffixCell = class("AsyncPvpRaidAffixCell", BaseCell)
local AscendColorStr = "[c][f12727]%s[-][/c]"
local DescendColorStr = "[c][4c9e0f]%s[-][/c]"

function AsyncPvpRaidAffixCell:Init()
  self:FindObjs()
end

function AsyncPvpRaidAffixCell:FindObjs()
  self.bg = self.gameObject:GetComponent(UISprite)
  self:AddClickEvent(self.gameObject, function()
    self:OnClick()
  end)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.descLabel = self:FindComponent("Desc", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.ratioLabel = self:FindComponent("Ratio", UILabel)
  self.checkmark = self:FindGO("Checkmark")
  self.checkBg = self:FindGO("CheckBg")
end

function AsyncPvpRaidAffixCell:SetData(data)
  self.data = data
  if data then
    local config = Table_MonsterAffix[data.id]
    if config then
      self.nameLabel.text = config.Name
      self.descLabel.text = config.Desc
      IconManager:SetSkillIcon(config.Icon, self.icon)
    end
    self.ratio = data.ratio
    local ratioPercent = NumberUtility.RoundToInt(self.ratio * 100)
    local ratioStr = self.ratio >= 0 and "+" .. string.format("%d%%", ratioPercent) or string.format("%d%%", ratioPercent)
    local str = string.format(ZhString.AsyncPvpRaidDiffSetView_Ratio, ratioStr)
    if self.ratio >= 0 then
      str = string.format(AscendColorStr, str)
    else
      str = string.format(DescendColorStr, str)
    end
    self.ratioLabel.text = str
    self.checkBg:SetActive(not data.isPreview)
    self.checkmark:SetActive(data.selected or false)
    self.bg.alpha = not (not data.isPreview or data.selected) and 0.5 or 1
    self.selected = data.selected
    self.checkmark:SetActive(self.selected or false)
  end
end

function AsyncPvpRaidAffixCell:OnClick()
  if not self.data or self.data.isPreview then
    return
  end
  self.selected = not self.selected
  self.checkmark:SetActive(self.selected or false)
  self:PassEvent(AsyncPvpRaidEvent.SelectAffix, self)
end
