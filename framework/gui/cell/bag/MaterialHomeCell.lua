autoImport("BaseItemCell")
MaterialHomeCell = class("MaterialHomeCell", BaseItemCell)
MaterialHomeCell.NotFull = "[cf1c0f]"
MaterialHomeCell.Full = "[41c419]"

function MaterialHomeCell:Init()
  self.super.Init(self)
  self:AddCellClickEvent()
  self:FindObjs()
end

function MaterialHomeCell:FindObjs()
  self.deductionSp = self:FindComponent("Deduction", UISprite)
end

function MaterialHomeCell:SetData(data)
  self.data = data
  self.super.SetData(self, data)
  local haveNum = self.data.num
  local needNum = self.data.neednum
  local colorStr = haveNum >= needNum and MaterialHomeCell.Full or MaterialHomeCell.NotFull
  self:UpdateNumLabel(colorStr .. haveNum .. "/" .. needNum .. "[-]", 71.35, 0, 0)
  local itemType = self.data and self.data.staticData and self.data.staticData.Type
  if itemType and itemType == 55 then
    IconManager:SetUIIcon("icon_62", self:GetBgSprite())
  elseif data.id == "Deduction" then
    self:SetItemQualityBG(5)
  end
  if data.deduction then
    self.deductionSp.gameObject:SetActive(true)
    IconManager:SetUIIcon("equip_icon_" .. data.deduction, self.deductionSp)
  else
    self.deductionSp.gameObject:SetActive(false)
  end
end

function MaterialHomeCell:GetBgSprite()
  self.bg = self:FindComponent("ItemBg", UISprite)
  return self.bg
end
