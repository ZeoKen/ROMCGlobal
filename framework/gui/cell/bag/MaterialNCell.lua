autoImport("BaseItemCell")
MaterialNCell = class("MaterialNCell", BaseItemCell)
MaterialNCell.NotFull = "[ff2a00]"
MaterialNCell.Full = "[7e5018]"

function MaterialNCell:Init()
  self.super.Init(self)
  self:AddCellClickEvent()
  self:FindObjs()
end

function MaterialNCell:FindObjs()
  self.deductionSp = self:FindComponent("Deduction", UISprite)
end

function MaterialNCell:SetData(data)
  self.data = data
  self.super.SetData(self, data)
  local colorStr = data.num >= data.neednum and MaterialNCell.Full or MaterialNCell.NotFull
  self:UpdateNumLabel(colorStr .. data.num .. "/" .. data.neednum .. "[-]", 0, -60, 0)
  if data.deduction then
    self.deductionSp.gameObject:SetActive(true)
    IconManager:SetUIIcon("equip_icon_" .. data.deduction, self.deductionSp)
  else
    self.deductionSp.gameObject:SetActive(false)
  end
  if data.id == "Deduction" then
    self:SetItemQualityBG(5)
  end
end

function MaterialNCell:SetScale(scale)
  LuaGameObject.SetLocalScaleGO(self.gameObject, scale, scale, 1)
end

function MaterialNCell:SetNumLabelWidth(width)
  if not width then
    return
  end
  if self.numLabGO then
    self.numLab.width = width
  end
end
