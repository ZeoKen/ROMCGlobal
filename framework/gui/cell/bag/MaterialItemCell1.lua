autoImport("ItemCell")
MaterialItemCell1 = class("MaterialItemCell1", ItemCell)
MaterialItemCell1.DefaultNumLabelLocalPos = LuaVector3.New(0, -39, 0)
MaterialItemCell1.TextColor_Red = "[c][FF6021]%s[-][/c]/%s"
MaterialItemCell1.EmptyData = {
  Add = "Add",
  Add2 = "Add2",
  Space = "Space"
}
MaterialItemCell1.Event = {
  Delete = "MaterialItemCell1.Event.Delete"
}

function MaterialItemCell1:Init()
  MaterialItemCell1.super.Init(self)
  self:AddCellClickEvent()
  self.clickTipCt = self:FindGO("clickTip")
  if self.clickTipCt then
    self.clickTip = self:FindComponent("clickTipLabel", UILabel, self.clickTipCt)
    self.clickTip.text = ZhString.EquipRefinePage_ClickRefineTip
  end
  self.discountTip = self:FindGO("DiscountTip")
  if self.discountTip then
    self.discountTip_Sp = self.discountTip:GetComponent(UISprite)
    self.discountTip_Label = self:FindComponent("Label", UILabel, self.discountTip)
  end
  self.deleteIcon = self:FindGO("deleteIcon")
  self:AddClickEvent(self.deleteIcon, function()
    self:PassEvent(MaterialItemCell1.Event.Delete, self)
  end)
  self.empty_Add = self:FindGO("Empty/Add")
  self.empty_Add2 = self:FindGO("Empty/Add2")
  self.empty_Space = self:FindGO("Empty/Space")
end

function MaterialItemCell1:SetAttriPivot_BottomLeft()
  if not self.attrGrid then
    self.needSetAttriPivot = true
    return
  end
  self.needSetAttriPivot = false
  self.attrGrid.pivot = 8
  self.attrGrid.transform.localPosition = LuaGeometry.GetTempVector3(-37, -27)
  self.refinelv.pivot = 3
end

function MaterialItemCell1:ActiveDeleteIcon(b)
  self.deleteIcon:SetActive(b)
end

function MaterialItemCell1:SetData(data)
  if type(data) == "table" then
    MaterialItemCell1.super.SetData(self, data)
    if data.neednum then
      local colorFormat = data.num >= data.neednum and "%s/%s" or self.TextColor_Red
      self:UpdateNumLabel(string.format(colorFormat, data.num, data.neednum))
    else
      self:UpdateNumLabel(data.num)
    end
    if data.showClickTip then
      self:ActiveClickTip(true)
    else
      self:ActiveClickTip(false)
    end
    if data.discount and data.discount < 100 then
      self:SetDisCountTip(true, self.data.discount)
    else
      self:SetDisCountTip(false)
    end
    if data.neednum and data.staticData.id == GameConfig.MoneyId.Zeny then
      self:UpdateNumLabel(string.format(data.num >= data.neednum and "%s" or "[c][FF6021]%s[-][/c]", data.neednum))
    end
    self:ActiveDeleteIcon(data.showDelete == true)
  else
    self.data = data
    self.item:SetActive(false)
    if self.empty then
      self.empty:SetActive(true)
      if data == MaterialItemCell1.EmptyData.Space then
        if self.empty_Space then
          self.empty_Space:SetActive(true)
        end
        if self.empty_Add2 then
          self.empty_Add2:SetActive(false)
        end
        if self.empty_Add then
          self.empty_Add:SetActive(false)
        end
      elseif data == MaterialItemCell1.EmptyData.Add2 then
        if self.empty_Space then
          self.empty_Space:SetActive(false)
        end
        if self.empty_Add2 then
          self.empty_Add2:SetActive(true)
        end
        if self.empty_Add then
          self.empty_Add:SetActive(false)
        end
      else
        if self.empty_Space then
          self.empty_Space:SetActive(false)
        end
        if self.empty_Add2 then
          self.empty_Add2:SetActive(false)
        end
        if self.empty_Add then
          self.empty_Add:SetActive(true)
        end
      end
    end
    self:ActiveDeleteIcon(false)
    self:SetDisCountTip(false)
  end
  if self.needSetAttriPivot then
    self:SetAttriPivot_BottomLeft()
  end
end

function MaterialItemCell1:ActiveClickTip(b)
  if self.clickTipCt then
    self.clickTipCt:SetActive(b)
  end
end

function MaterialItemCell1:SetDisCountTip(b, pct)
  if not self.discountTip then
    return
  end
  if b then
    self.discountTip:SetActive(true)
    pct = math.floor(pct + 0.01)
    self.discountTip_Label.text = pct .. "%"
    Game.convert2OffLbl(self.discountTip_Label)
  else
    self.discountTip:SetActive(false)
  end
end

function MaterialItemCell1:SetIconAlpha(val)
  if self.icon then
    self.icon.alpha = val
  end
end

function MaterialItemCell1:AttriGridReposition()
  if self.attrGrid then
    self.attrGrid:Reposition()
    self.attrGrid.repositionNow = true
  end
end
