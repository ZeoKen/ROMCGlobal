local BaseCell = autoImport("BaseCell")
ColorFillingColorCell = class("ColorFillingColorCell", BaseCell)

function ColorFillingColorCell:Init()
  self.colorSp = self.gameObject:GetComponent(UISprite)
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self.selectGo = self:FindGO("select")
  self:AddCellClickEvent()
end

function ColorFillingColorCell:SetData(data)
  self.data = data
  if not StringUtil.IsEmpty(data.spriteName) then
    self.colorSp.spriteName = data.spriteName
  end
  if data.color then
    self.colorSp.color = data.color
  end
  self.isEmpty = data.isEmpty
  if self.isEmpty then
    self.collider.enabled = false
  else
    self.collider.enabled = true
  end
  self:SetColorSelect(false)
end

function ColorFillingColorCell:SetColorSelect(isSelect)
  self.selectGo:SetActive(isSelect)
end
