local colorIndex = {
  [1] = ColorUtil.NGUIWhite,
  [2] = ColorUtil.NGUIGray,
  [3] = ColorUtil.TeamOrange
}
FashionStarColorCell = class("FashionStarColorCell", BaseCell)

function FashionStarColorCell:Init()
  self:FindObjs()
end

function FashionStarColorCell:FindObjs()
  self.colorSprite = self.gameObject:GetComponent(UISprite)
  self.chooseSymbol = self:FindGO("Selected")
  self:AddCellClickEvent()
end

function FashionStarColorCell:SetData(data)
  self.data = data
  local _, c = ColorUtil.TryParseHexString(data.color)
  if _ then
    self.colorSprite.color = c
  end
  self:UpdateChoose()
end

function FashionStarColorCell:SetChoosen(index)
  self.chooseIndex = index
  self:UpdateChoose()
end

function FashionStarColorCell:UpdateChoose()
  if self.data and self.data.index == self.chooseIndex then
    self.chooseSymbol:SetActive(true)
  else
    self.chooseSymbol:SetActive(false)
  end
end
