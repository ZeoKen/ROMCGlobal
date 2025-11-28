local BaseCell = autoImport("BaseCell")
CostInfoCell2 = class("CostInfoCell2", BaseCell)
local PACKAGE_CHECK = GameConfig.PackageMaterialCheck.default
CostInfoCell2.ClickTrace = "CostInfoCell2_ClickTrace"

function CostInfoCell2:Init()
  local symbolGO = self:FindGO("resize/symbol")
  self.symbol = symbolGO:GetComponent(UISprite)
  self.label = self:FindComponent("num", UILabel)
  self.gobtn = self:FindGO("gobtn")
  self:SetEvent(self.gobtn, function()
    self:PassEvent(CostInfoCell2.ClickTrace, self)
  end)
  self:AddClickEvent(symbolGO, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function CostInfoCell2:SetData(id, bagTypes)
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
    num = BagProxy.Instance:GetItemNumByStaticID(id, bagTypes or PACKAGE_CHECK)
  end
  self.label.text = StringUtil.NumThousandFormat(num)
  local icon = Table_Item[id].Icon
  IconManager:SetItemIcon(icon, self.symbol)
end
