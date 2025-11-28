local _continue_score = GameConfig.GvgNewConfig and GameConfig.GvgNewConfig.continue_score or 2
local _GetMaxValue = function(key)
  if key == "occupyCity" then
    return GvgProxy.Instance:GetMaxOccupyCityScore()
  elseif key == "contineOccupyCity" then
    return _continue_score
  end
end
GvgScoreFixedCell = class("GvgScoreFixedCell", BaseCell)

function GvgScoreFixedCell:Init()
  GvgScoreFixedCell.super.Init(self)
  self.nameLab = self:FindComponent("Name", UILabel)
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.extraRoot = self:FindGO("CityRoot")
  if self.extraRoot then
    self:Hide(self.extraRoot)
  end
end

function GvgScoreFixedCell:SetData(configData)
  local name
  if GvgProxy.Instance:IsLeisureSeason() then
    if configData.type == "defense" then
      local perfect_score = GvgProxy.Instance:GetScoreInfoByKey("perfect")
      if 0 < perfect_score then
        name = string.format(ZhString.MainViewGvgPage_GvgQuestTip_Complete, configData.title)
      else
        name = configData.title
      end
    else
      name = configData.title
    end
  else
    local maxValue = _GetMaxValue(configData.type)
    name = string.format(configData.title, maxValue)
  end
  self.nameLab.text = name
  self.descLab.text = configData.desc
end
