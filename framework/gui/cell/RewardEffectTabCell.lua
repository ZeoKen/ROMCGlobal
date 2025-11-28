RewardEffectTabCell = class("RewardEffectTabCell", BaseCell)
local TabConfig = {
  [1] = {icon = "bag_tx_1", type = 2},
  [2] = {icon = "bag_tx_2", type = 1}
}
local color_blue = ColorUtil.TabColor_DeepBlue
local color_gray = ColorUtil.TitleGray
local colorwhite = LuaColor.White()
local colorhide = LuaColor.New(1, 1, 1, 0)
local colorgray = LuaColor.Gray()

function RewardEffectTabCell:Init()
  RewardEffectTabCell.super.Init(self)
  self.sp1 = self:FindComponent("sprite1", UISprite)
  self.select = self:FindComponent("Select", UISprite)
  self.sp2 = self:FindComponent("sprite2", UISprite)
  self.tog = self.gameObject:GetComponent(UIToggle)
  self.tog.instantTween = true
  self:SetEvent(self.gameObject, function()
    self:SetTog(true)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function RewardEffectTabCell:SetTog(v)
  if not self.tog then
    return
  end
  self.tog.value = v
  self.select.color = v and colorwhite or colorhide
end

function RewardEffectTabCell:SetGroup(g)
  g = g or 0
  self.tog.group = g
end

function RewardEffectTabCell:SetData(data)
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.data = data
  local spName = TabConfig[data.id].icon
  self.tabType = TabConfig[data.id].type
  local rewardData = PvpProxy.Instance:GetEffectInUse(self.tabType)
  if rewardData then
    local itemIcon = Table_Item[rewardData.itemID].Icon
    self.sp1.color = colorwhite
    IconManager:SetItemIcon(itemIcon, self.sp1)
    self.sp2.enabled = false
  else
    IconManager:SetUIIcon(spName, self.sp1)
    IconManager:SetUIIcon(spName, self.sp2)
    self.sp1.color = color_gray
    self.sp2:MakePixelPerfect()
    self.sp2.width = self.sp2.width * 0.6
    self.sp2.height = self.sp2.height * 0.6
    self.sp2.enabled = true
  end
  self.sp1:MakePixelPerfect()
  self.sp1.width = self.sp1.width * 0.6
  self.sp1.height = self.sp1.height * 0.6
end
