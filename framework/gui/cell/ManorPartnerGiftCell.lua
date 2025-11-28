local BaseCell = autoImport("BaseCell")
ManorPartnerGiftCell = class("ManorPartnerGiftCell", BaseCell)

function ManorPartnerGiftCell:Init()
  self:FindObjs()
end

function ManorPartnerGiftCell:FindObjs()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.count = self:FindGO("Num"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self:AddCellClickEvent()
end

function ManorPartnerGiftCell:SetData(data)
  self.data = data
  local itemId = data or 151
  local own = BagProxy.Instance:GetItemNumByStaticID(itemId, GameConfig.PackageMaterialCheck.Exist)
  if own == 0 then
    self.icon.alpha = 0.4
  else
    self.icon.alpha = 1
  end
  if 1 <= own then
    self.count.text = own
  else
    self.count.text = ""
  end
  local staticData = Table_Item[itemId]
  if staticData then
    local setSuc = IconManager:SetItemIcon(staticData.Icon, self.icon)
    if not setSuc then
      IconManager:SetItemIcon("item_45001", self.icon)
    end
  end
end

function ManorPartnerGiftCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end
