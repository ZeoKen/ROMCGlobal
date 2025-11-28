GemDecomposeRewardCell = class("GemDecomposeRewardCell", BaseCell)

function GemDecomposeRewardCell:Init()
  self.decomposeRewardIcon = self:FindComponent("DecomposeRewardIcon", UISprite)
  self.decomposeRewardNum = self:FindComponent("DecomposeRewardNum", UILabel)
  self:SetEvent(self.decomposeRewardIcon.gameObject, function()
    self:OnClickReward()
  end)
end

function GemDecomposeRewardCell:OnClickReward()
  if not self.data then
    return
  end
  local callback = function()
    self:CancelChooseReward()
  end
  local sdata = {
    itemdata = self.data,
    funcConfig = {},
    callback = callback
  }
  TipManager.Instance:ShowItemFloatTip(sdata, self.decomposeRewardIcon, NGUIUtil.AnchorSide.Left, {-225, 0})
end

function GemDecomposeRewardCell:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function GemDecomposeRewardCell:SetData(data)
  self.data = data
  if not data then
    self.decomposeRewardNum.text = ""
    return
  end
  local success = IconManager:SetItemIcon(Table_Item[data.staticData.id].Icon, self.decomposeRewardIcon)
  if success then
    self.decomposeRewardIcon:MakePixelPerfect()
  end
  self.decomposeRewardNum.text = tostring(data.num)
end
