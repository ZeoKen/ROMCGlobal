CookMasterMaterialCell = class("CookMasterMaterialCell", ItemCell)

function CookMasterMaterialCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function CookMasterMaterialCell:FindObjs()
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.materialName = self:FindGO("MaterialName"):GetComponent(UILabel)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.select = self:FindGO("Select")
end

function CookMasterMaterialCell:SetData(data)
  self.data = data
  self.select:SetActive(not data.exist or false)
  self.icon.alpha = data.exist and 1 or 0.4
  self.boxCollider.enabled = data.exist
  local itemData = Table_Item[data.id]
  if itemData then
    self.materialName.text = itemData.NameZh
    IconManager:SetItemIcon(itemData.Icon, self.icon)
    self.icon:MakePixelPerfect()
    self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 0.7)
  else
    redlog("无道具信息", data.id)
  end
end

function CookMasterMaterialCell:SetSelectStatus(bool)
  self.select:SetActive(bool)
end
