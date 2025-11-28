local baseCell = autoImport("BaseCell")
MemoryTitleCell = class("MemoryTitleCell", baseCell)

function MemoryTitleCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function MemoryTitleCell:FindObjs()
  self.togBG = self:FindGO("Bg"):GetComponent(UISprite)
  self.label = self:FindGO("Label"):GetComponent(UILabel)
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.checkMark = self:FindGO("CheckMark")
end

function MemoryTitleCell:SetData(data)
  self.id = data
  local staticData = Table_YearMemoryLine[self.id]
  self.label.text = staticData and staticData.Preview
end

function MemoryTitleCell:SetChoose(bool)
  self.checkMark:SetActive(bool)
end

function MemoryTitleCell:SetStatus(enable)
  self.togBG.alpha = enable and 1 or 0.4
  self.label.color = enable and LuaColor.Black() or LuaGeometry.GetTempVector4(0.38823529411764707, 0.38823529411764707, 0.38823529411764707, 1)
  self.boxCollider.enabled = enable
end
