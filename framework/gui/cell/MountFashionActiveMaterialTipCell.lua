MountFashionActiveMaterialTipCell = class("MountFashionActiveMaterialTipCell", BaseCell)
local CountDesc_De = "[c][FF6021]%s[-][/c][c][000000]/%s[-][/c]"
local CountDesc = "[c][000000]%s[-][/c][c][000000]/%s[-][/c]"
local tipData = {}
tipData.funcConfig = {}

function MountFashionActiveMaterialTipCell:Init()
  self:FindObjs()
end

function MountFashionActiveMaterialTipCell:FindObjs()
  self.icon = self:FindComponent("Icon", UISprite)
  self.count = self:FindComponent("Count", UILabel)
  self:AddButtonEvent("Background", function()
    tipData.itemdata = self.itemData
    self:ShowItemTip(tipData, self.icon, NGUIUtil.AnchorSide.Right, {200, 0})
  end)
end

function MountFashionActiveMaterialTipCell:SetData(data)
  self.data = data
  local config = Table_Item[data.itemId]
  if config then
    IconManager:SetItemIcon(config.Icon, self.icon)
    local myNum = BagProxy.Instance:GetAllItemNumByStaticID(data.itemId)
    local strDesc = myNum < data.num and CountDesc_De or CountDesc
    self.count.text = string.format(strDesc, myNum, data.num)
    self.itemData = ItemData.new("", data.itemId)
  end
end
