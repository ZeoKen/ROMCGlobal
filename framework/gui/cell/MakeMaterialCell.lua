MakeMaterialCell = class("MakeMaterialCell", ItemCell)
local greenString = "[c][555B6EFF]%s[-][/c]"
local blackString = "[c][555B6EFF]%s[-][/c]"

function MakeMaterialCell:Init()
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  MakeMaterialCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function MakeMaterialCell:FindObjs()
  self.count = self:FindGO("Count"):GetComponent(UILabel)
  self.DeductionMaterialSp = self:FindComponent("DeductionMaterialTip", UISprite)
  local itemCellNum = self:FindGO("NumLabel")
  if itemCellNum then
    itemCellNum.transform.localScale = LuaGeometry.Const_V3_zero
  end
  self.canQuickMfrBtn = self:FindGO("CanQuickMfrBtn")
  if self.canQuickMfrBtn then
    self.canQuickMfrBtn:SetActive(false)
    local QuickMfrBtnLabel = self:FindComponent("text", UILabel, self.canQuickMfrBtn)
    QuickMfrBtnLabel.text = ZhString.EquipMake_CanQuickMfrBtn
    self:AddClickEvent(self.canQuickMfrBtn, function(obj)
      self:PassEvent(EquipMfrView.ClickMaterialQuickMake, self)
    end)
  end
end

function MakeMaterialCell:SetData(data)
  if data then
    local count = 0
    if data.preprocessed then
      self.itemData = data.preprocessed.itemData
      count = data.preprocessed.count
    else
      self.itemData = ItemData.new(nil, data.id)
      count = EquipMakeProxy.Instance:GetItemNumByStaticID(data.id)
    end
    local str, sum_num = tostring(count), tostring(data.num)
    if data.deduction then
      str = tostring(count + data.ori_num - data.num)
      sum_num = tostring(data.ori_num)
    end
    self.isEnough = false
    if count >= data.num then
      self.isEnough = true
      if data.deduction then
        str = string.format(greenString, str)
      elseif data.id == 100 then
        str = string.format(blackString, sum_num)
      else
        str = string.format(blackString, str)
      end
    elseif data.id == 100 then
      str = string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, sum_num)
    else
      str = string.format("[c]%s%s[-][/c]", CustomStrColor.BanRed, str)
    end
    if data.id == 100 then
      self.count.text = str
    else
      self.count.text = string.format("%s/%s", str, sum_num)
    end
    MakeMaterialCell.super.SetData(self, self.itemData)
  end
  self:SetDeductionMaterial(data and data.deduction)
  self.data = data
  self:SetCanQuickMfrBtnActive(false)
  self.qmfr_lackCount = nil
  self.qmfr_staticId = nil
  if self.itemData and self.itemData.equipInfo then
    local lackCount = data.num - data.preprocessed.count
    local staticId = self.itemData.equipInfo.equipData.id
    if 0 < lackCount and EquipMakeProxy.Instance:CheckIsComposeStep1Equip(staticId) then
      self.qmfr_lackCount = lackCount
      self.qmfr_staticId = staticId
      self:SetCanQuickMfrBtnActive(true)
    end
  end
end

function MakeMaterialCell:IsEnough()
  return self.isEnough
end

function MakeMaterialCell:NeedCount()
  if self.isEnough then
    return 0
  else
    if self.data.preprocessed then
      return self.data.num - self.data.preprocessed.count
    end
    return self.data.num - EquipMakeProxy.Instance:GetItemNumByStaticID(self.data.id)
  end
end

function MakeMaterialCell:SetDeductionMaterial(mat_id)
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

function MakeMaterialCell:SetCanQuickMfrBtnActive(isActive)
  if self.canQuickMfrBtn then
    self.canQuickMfrBtn:SetActive(isActive)
  end
end
