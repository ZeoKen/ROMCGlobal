autoImport("AdventureAttrCell")
AdventureAttrSpecCell = class("AdventureAttrSpecCell", AdventureAttrCell)
local singleRowLabelMaxWidth = 120
local labelMaxWidth = 366
local valueRightPosX = 456
local valueRightPosY = -27
local valueLeftPosX = 213
local valueLeftPosY = 12

function AdventureAttrSpecCell:SetData(data)
  AdventureAttrSpecCell.super.SetData(self, data)
  self:LayoutCell()
end

function AdventureAttrSpecCell:LayoutCell(forceRight)
  local valuePos = self.value.transform.localPosition
  self.name:UpdateNGUIText()
  local size = NGUIText.CalculatePrintedSize(self.name.text)
  local width = size.x
  if width > singleRowLabelMaxWidth and width < labelMaxWidth then
    valuePos.x = valueRightPosX
    valuePos.y = valueLeftPosY
  elseif width >= labelMaxWidth then
    valuePos.x = valueRightPosX
    valuePos.y = valueRightPosY
  else
    valuePos.x = forceRight and valueRightPosX or valueLeftPosX
    valuePos.y = valueLeftPosY
  end
  self.value.transform.localPosition = valuePos
end
