ActivityFlipCardRewardDetailCell = class("ActivityFlipCardRewardDetailCell", BaseCell)

function ActivityFlipCardRewardDetailCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ActivityFlipCardRewardDetailCell:FindObjs()
  self:AddButtonEvent("iconBg", function()
    self:ShowItemTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {200, 0})
  end)
  self.icon = self:FindComponent("icon", UISprite)
  self.num = self:FindComponent("num", UILabel)
  self.probability = self:FindComponent("probability", UILabel)
end

function ActivityFlipCardRewardDetailCell:SetData(data)
  IconManager:SetItemIconById(data.id, self.icon)
  self.num.text = data.num > 1 and data.num or ""
  local probability = BranchMgr.IsJapan() and data.jp_probability or data.probability
  self.probability.text = string.format(ZhString.FlipCard_GridProbability, probability * 100)
  local itemData = ItemData.new("", data.id)
  self.tipData.itemdata = itemData
end
