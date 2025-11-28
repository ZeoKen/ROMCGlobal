autoImport("HitPollyRewardCell")
HitPollyRewardPreviewCell = class("HitPollyRewardPreviewCell", ItemCell)

function HitPollyRewardPreviewCell:Init()
  self.indexLab = self:FindComponent("Index", UILabel)
  local rewardcell = self:FindGO("HitPollyRewardCell")
  if not rewardcell then
    local go = self:LoadPreferb("cell/HitPollyRewardCell", self.gameObject)
    go.name = "HitPollyRewardCell"
    self.rewardcell = HitPollyRewardCell.new(go)
  end
  self:AddClickEvent(self.rewardcell.gameObject, function(g)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function HitPollyRewardPreviewCell:SetData(data)
  self.data = data
  self.rewardcell:SetData(data)
  if data.index then
    self.indexLab.text = string.format(ZhString.ActivityHitPolly_RewardPreviewIndex, ZhString.ChinaNumber[data.index])
  end
end
