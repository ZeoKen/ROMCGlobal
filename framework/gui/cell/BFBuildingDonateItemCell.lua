BFBuildingDonateItemCell = class("BFBuildingDonateItemCell", ItemCell)

function BFBuildingDonateItemCell:Init()
  self.cellContainer = self:FindGO("CellContainer")
  if self.cellContainer then
    local obj = self:LoadPreferb("cell/ItemCell", self.cellContainer)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.cellContainer:AddComponent(UIDragScrollView)
  end
  BFBuildingDonateItemCell.super.Init(self)
  self:InitCell()
  self:AddCellClickEvent()
end

function BFBuildingDonateItemCell:InitCell()
  self.desc = self:FindComponent("desc", UILabel)
  self.choose = self:FindGO("Choose")
  self:FindGO("donateSp"):SetActive(true)
  self:FindGO("ExchangeButton"):SetActive(false)
  self:FindGO("CostGrid"):SetActive(false)
  self.choose:SetActive(false)
end

function BFBuildingDonateItemCell:SetData(data)
  self.bdata = data
  if not data then
    return
  end
  if data then
    self.itemData = ItemData.new("building", self.bdata.id)
    BFBuildingDonateItemCell.super.SetData(self, self.itemData)
  end
  self:SelfUpdateCell()
end

function BFBuildingDonateItemCell:CheckSetSelect()
  local cbui = BFBuildingProxy.Instance:GetCurBuildingUICtrl()
  local istrue = self.bdata and cbui and cbui.donateSelect and cbui.donateSelect.bdata.id == self.bdata.id or false
  self.choose:SetActive(istrue)
end

function BFBuildingDonateItemCell:SelfUpdateCell()
  if not self.bdata then
    return
  end
  local idata = BFBuildingProxy.Instance:GetBuildData(self.bdata.build_id)
  local cnum = idata.items[self.bdata.id] or 0
  self.finished = cnum >= self.bdata.num
  self.needNum = math.max(self.bdata.num - cnum, 0)
  local cb = self.finished and "000000" or "FF0000"
  self.nameLab.color = ColorUtil.NGUIWhite
  self.nameLab.text = string.format("[000000]%s ([-][%s]%d/%d[-][000000])[-]", self.itemData.staticData.NameZh, cb, cnum, self.bdata.num)
  local selfHas = BagProxy.Instance:GetItemNumByStaticID(self.bdata.id, GameConfig.PackageMaterialCheck.default)
  self.desc.text = self.finished and ZhString.BFBuilding_yiwancheng or ZhString.BFBuilding_yiyongyou .. selfHas
  self:CheckSetSelect()
end
