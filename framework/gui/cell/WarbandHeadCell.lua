autoImport("WeddingHeadCell")
WarbandHeadCell = class("WarbandHeadCell", WeddingHeadCell)
local rankSP = {
  "Analysis_bg_NO.1_1",
  "Analysis_bg_NO.2_2",
  "Analysis_bg_NO.3_3",
  "Analysis_bg_NO.3_3"
}

function WarbandHeadCell:FindObjs()
  WarbandHeadCell.super.FindObjs(self)
  self.rankFrame = self:FindComponent("Rank", UISprite)
end

function WarbandHeadCell:SetData(data)
  WarbandHeadCell.super.SetData(self, data)
  if data then
    self.gameObject:SetActive(true)
    self.rankFrame.spriteName = rankSP[data.rank]
  else
    self.gameObject:SetActive(false)
  end
end
