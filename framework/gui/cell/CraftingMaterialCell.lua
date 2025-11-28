CraftingMaterialCell = class("CraftingMaterialCell", ItemCell)
local greenString = "[c][555B6E]%s[-][/c]"
local blackString = "[c][555B6E]%s[-][/c]"

function CraftingMaterialCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3(0, -30, 0)
  CraftingMaterialCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function CraftingMaterialCell:AddCellClickEvent()
  self:AddClickEvent(self.gameObject, function()
    if self.data and self.data.slotIndex then
      self:PassEvent("ChooseMaterial", self.data)
    end
  end)
  self:AddClickEvent(self.removeSymbol, function()
    if self.data and self.data.slotIndex and not self.data.isEmpty then
      self:PassEvent("RemoveMaterial", self.data)
    end
  end)
end

function CraftingMaterialCell:FindObjs()
  self.count = self:FindGO("Count"):GetComponent(UILabel)
  local itemCellNum = self:FindGO("NumLabel")
  if itemCellNum then
    itemCellNum.transform.localScale = LuaGeometry.Const_V3_zero
  end
  self.DeductionMaterialSp = self:FindComponent("DeductionMaterialTip", UISprite)
  self.emptyBG = self:FindComponent("EmptyBG", UISprite)
  self.removeSymbol = self:FindGO("RemoveSymbol")
  self.removeSymbol:SetActive(false)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(false)
  end
end

function CraftingMaterialCell:SetData(data)
  if data then
    self.slotIndex = data.slotIndex
    if data.isEmpty then
      self.itemData = nil
      self.isEnough = false
      local needCount = data.requiredNum or 0
      local str = string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, "0")
      self.count.text = string.format("%s[c][555B6E]/%s[-][/c]", str, needCount)
      local emptyItemData = ItemData.new(nil, 0)
      CraftingMaterialCell.super.SetData(self, emptyItemData)
      self:SetDeductionMaterial(nil)
      self.emptyBG.gameObject:SetActive(true)
      self:SetEmptyBG(data.quality or 1)
      self.removeSymbol:SetActive(false)
    else
      local count = 0
      self.itemData = ItemData.new(nil, data.id)
      count = data.exchangenum or CraftingPotProxy.Instance:GetItemNumByStaticID(data.id)
      local str, sum_num = tostring(count), data.ori_num or data.num
      self.isEnough = false
      if count >= sum_num then
        self.isEnough = true
        str = string.format(blackString, str)
      else
        str = string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, str)
      end
      self.count.text = string.format("%s[c][555B6E]/%s[-][/c]", str, sum_num)
      CraftingMaterialCell.super.SetData(self, self.itemData)
      self:SetDeductionMaterial(data.deduction or data.coupon)
      self.emptyBG.gameObject:SetActive(false)
      local itemConfig = Table_Item[data.id]
      local quality = itemConfig and itemConfig.Quality or 1
      self:SetItemQualityBG(quality)
    end
  else
    self.removeSymbol:SetActive(false)
  end
  self.data = data
end

function CraftingMaterialCell:IsEnough()
  return self.isEnough
end

function CraftingMaterialCell:NeedCount()
  if self.isEnough then
    return 0
  else
    redlog("needCount", self.data.num - CraftingPotProxy.Instance:GetItemNumByStaticID(self.data.id))
    return self.data.num - CraftingPotProxy.Instance:GetItemNumByStaticID(self.data.id)
  end
end

function CraftingMaterialCell:SetDeductionMaterial(mat_id)
  if self.DeductionMaterialSp then
    if mat_id then
      self.DeductionMaterialSp.gameObject:SetActive(true)
      IconManager:SetItemIconById(mat_id, self.DeductionMaterialSp)
    else
      self.DeductionMaterialSp.gameObject:SetActive(false)
    end
    self:UpdateRemoveSymbolVisibility()
  end
end

function CraftingMaterialCell:UpdateRemoveSymbolVisibility()
  if self.data and not self.data.isEmpty then
    local slotIndex = self.data.slotIndex or self.slotIndex
    if not slotIndex then
      redlog("没有slotIndex，不显示removeSymbol", "data.slotIndex:", self.data.slotIndex, "self.slotIndex:", self.slotIndex)
      self.removeSymbol:SetActive(false)
      return
    end
    local hasDeductionOrCoupon = self.data.deduction or self.data.coupon
    if hasDeductionOrCoupon then
      self.removeSymbol:SetActive(false)
    else
      self.removeSymbol:SetActive(true)
    end
  else
    self.removeSymbol:SetActive(false)
  end
end

function CraftingMaterialCell:SetEmptyBG(quality)
  if quality == 1 then
    local spName = self.DefaultBg_spriteName or "com_icon_bottom3"
    if self.emptyBG.spriteName ~= spName then
      self.emptyBG.atlas = self.DefaultBg_atlas or RO.AtlasMap.GetAtlas("NewCom")
      self.emptyBG.spriteName = spName
    end
  else
    self.emptyBG.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
    if quality == 2 then
      self.emptyBG.spriteName = "refine_bg_green"
    elseif quality == 3 then
      self.emptyBG.spriteName = "refine_bg_blue"
    elseif quality == 4 then
      self.emptyBG.spriteName = "refine_bg_purple"
    elseif quality == 5 then
      self.emptyBG.spriteName = "refine_bg_orange"
    elseif quality == 6 then
      self.emptyBG.spriteName = "refine_bg_red"
    end
  end
end

function CraftingMaterialCell:SetChooseSymbol(isShow)
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(isShow)
  end
end
