HitPollyRewardCell = class("HitPollyRewardCell", ItemCell)

function HitPollyRewardCell:Init()
  self.finishFlag = self:FindGO("Finish")
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  HitPollyRewardCell.super.Init(self)
end

function HitPollyRewardCell:SetData(data)
  self.data = data
  if data and data.itemdata then
    HitPollyRewardCell.super.SetData(self, data.itemdata)
    local bg = self:GetBgSprite()
    if bg then
      self:Hide(bg)
    end
    self:SetGOActive(self.empty, false)
    self.gameObject:SetActive(true)
    self:SetFinishFlag(true)
    if data.forcehideFinish then
      self:SetFinishFlag(false)
    end
  else
    self.gameObject:SetActive(false)
  end
end

function HitPollyRewardCell:SetFinishFlag(var)
  self.finishFlag:SetActive(var)
end
