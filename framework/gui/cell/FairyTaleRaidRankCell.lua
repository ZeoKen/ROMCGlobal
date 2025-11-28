autoImport("TeamPwsRankCell")
FairyTaleRaidRankCell = class("FairyTaleRaidRankCell", TeamPwsRankCell)

function FairyTaleRaidRankCell:InitHead()
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(1)
  self.headIcon:SetMinDepth(1)
end

function FairyTaleRaidRankCell:ResetHeadData(data)
  self.headData = data.headData
end
