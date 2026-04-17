local BaseCell = autoImport("BaseCell")
autoImport("PveGeffenMagicStatCell")
PveGeffenMagicScoreCell = class("PveGeffenMagicScoreCell", BaseCell)

function PveGeffenMagicScoreCell:Init()
  self.title = self:FindComponent("Title", UILabel)
  self.scoreLab = self:FindComponent("Score", UILabel)
  self.scoreLab.text = ZhString.GeffenMagic_Score_Title
  self.emptyLab = self:FindComponent("Empty", UILabel)
  self.emptyLab.text = ZhString.GeffenMagic_Score_Empty
  self.scoreGrid = self:FindComponent("ScoreGrid", UIGrid)
  self.statCtl = UIGridListCtrl.new(self.scoreGrid, PveGeffenMagicStatCell, "PveGeffenMagicStatCell")
end

function PveGeffenMagicScoreCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  local isEmpty = type(data) ~= "table"
  if isEmpty then
    self.title.text = string.format(ZhString.GeffenMagic_Wave_Title, data)
    self:Show(self.emptyLab)
    self:Hide(self.scoreGrid)
    self:Hide(self.scoreLab)
  else
    self.title.text = string.format(ZhString.GeffenMagic_Wave_Title, data.wave)
    self:Hide(self.emptyLab)
    self:Show(self.scoreGrid)
    self:Show(self.scoreLab)
    self.statCtl:ResetDatas(data:GetDisplayStats())
  end
end
