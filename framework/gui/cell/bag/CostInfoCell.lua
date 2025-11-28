local BaseCell = autoImport("BaseCell")
CostInfoCell = class("CostInfoCell", BaseCell)
local PACKAGE_CHECK = GameConfig.PackageMaterialCheck.default

function CostInfoCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.symbol = self:FindComponent("Symbol", UISprite)
  self:SetEvent(self.symbol.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CostInfoCell:SetData(id)
  if id then
    self.id = id
    local num
    if id == 100 then
      num = MyselfProxy.Instance:GetROB()
    elseif id == AstrolabeProxy.ContributeItemId then
      num = AstrolabeProxy.GetContributeNum()
    elseif id == AstrolabeProxy.BindedContributeItemId then
      num = AstrolabeProxy.GetBindedContributeNum()
    elseif id == 174 or id == 175 then
      num = HappyShopProxy.Instance:GetItemNumByStaticID(id)
    else
      num = BagProxy.Instance:GetItemNumByStaticID(id, PACKAGE_CHECK)
    end
    self.label.text = StringUtil.NumThousandFormat(num)
    local icon = Table_Item[id].Icon
    IconManager:SetItemIcon(icon, self.symbol)
  end
end

function CostInfoCell:SetSize(w, h)
  self.symbol.width = w
  self.symbol.heigth = h
end
