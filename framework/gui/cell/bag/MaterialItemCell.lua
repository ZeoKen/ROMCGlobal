autoImport("BaseItemCell")
MaterialItemCell = class("MaterialItemCell", BaseItemCell)
MaterialItemCell.TextColor_Green = "%s/%s"
MaterialItemCell.TextColor_Red = "[c][FF3B35]%s[-][/c]/%s"
MaterialItemCell.ZenyTextColor_Red = "[c][FF3B35]%s[-][/c]"
MaterialItemCell.DefaultNumLabelLocalPos = LuaVector3.New(0, -37, 0)
MaterialItemCell.MaterialType = {
  StaticCost = "StaticCost",
  Material = "Material",
  MaterialItem = "MaterialItem",
  ChooseItem = "ChooseItem"
}

function MaterialItemCell:Init()
  self.super.Init(self)
  self:AddCellClickEvent()
  self.clickTipCt = self:FindGO("clickTip")
  if self.clickTipCt then
    self.clickTip = self:FindComponent("clickTipLabel", UILabel, self.clickTipCt)
    self.clickTip.text = ZhString.EquipRefinePage_ClickRefineTip
    self:SetEvent(self.clickTipCt, function()
      self:PassEvent(UICellEvent.OnLeftBtnClicked, self)
    end)
  end
  self.discountTip = self:FindGO("DiscountTip")
  if self.discountTip then
    self.discountTip_Sp = self.discountTip:GetComponent(UISprite)
    self.discountTip_Label = self:FindComponent("Label", UILabel, self.discountTip)
  end
  self.DeductionMaterialSp = self:FindComponent("DeductionMaterialTip", UISprite)
end

function MaterialItemCell:SetData(data)
  self.data = data
  self.super.SetData(self, data)
  if self.SetDeductionMaterial then
    self:SetDeductionMaterial(data.deduction)
  end
  local staticID = data.staticData and data.staticData.id
  if staticID == 100 then
    local colorFormat
    colorFormat = data.num >= data.neednum and "%s" or MaterialItemCell.ZenyTextColor_Red
    if data.deduction then
      self:UpdateNumLabel(string.format(colorFormat, data.ori_neednum))
    else
      self:UpdateNumLabel(string.format(colorFormat, data.neednum))
    end
  else
    local neednum = data.neednum
    if neednum and 0 < neednum then
      local colorFormat
      if data.deduction then
        colorFormat = neednum <= data.num and MaterialItemCell.TextColor_Green or MaterialItemCell.TextColor_Red
        self:UpdateNumLabel(string.format(colorFormat, data.num + data.ori_neednum - neednum, data.ori_neednum))
      else
        colorFormat = neednum <= data.num and MaterialItemCell.TextColor_Green or MaterialItemCell.TextColor_Red
        self:UpdateNumLabel(string.format(colorFormat, data.num, neednum))
      end
    else
      self:UpdateNumLabel(data.num)
    end
  end
  if self.clickTipCt then
    self:ActiveClickTip(data.id ~= MaterialItemCell.MaterialType.Material)
  end
  if data.discount and 100 > data.discount then
    self:SetDisCountTip(true, self.data.discount)
  else
    self:SetDisCountTip(false)
  end
end

function MaterialItemCell:ActiveClickTip(b)
  if self.clickTipCt then
    self.clickTipCt:SetActive(b)
  end
end

function MaterialItemCell:SetDisCountTip(b, pct)
  if self.discountTip then
    if b then
      pct = math.floor(pct + 0.01)
      self.discountTip:SetActive(true)
      self.discountTip_Label.text = pct .. "%"
      Game.convert2OffLbl(self.discountTip_Label)
    else
      self.discountTip:SetActive(false)
    end
  end
end

function MaterialItemCell:GetCellPartPrefix()
  return "ItemCell_"
end

function MaterialItemCell:SetDeductionMaterial(mat_id)
  if self.DeductionMaterialSp then
    if mat_id then
      self.DeductionMaterialSp.gameObject:SetActive(true)
      local itemSData = Table_Item[mat_id]
      if not IconManager:SetItemIcon(itemSData and itemSData.Icon, self.DeductionMaterialSp) then
        local _ = IconManager:SetItemIcon("item_45001", self.DeductionMaterialSp)
      end
    else
      self.DeductionMaterialSp.gameObject:SetActive(false)
    end
  end
end
