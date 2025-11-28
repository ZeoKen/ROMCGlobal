AdventureEquipComposeCell = class("AdventureEquipComposeCell", ItemCell)
local TextColor_Red = "[c][FF3B35]%s[-][/c]"
AdventureEquipComposeCell.ItemType = {
  EquipMaterial = 1,
  CommonMaterial = 2,
  UpgradeMaterial = 3
}

function AdventureEquipComposeCell:Init()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.needChoose = self:FindGO("NeedChoose")
  self.replaceIcon = self:FindGO("ReplaceIcon")
  local obj = self:LoadPreferb("cell/ItemCell", self.gameObject)
  AdventureEquipComposeCell.super.Init(self)
  self:AddTipEvt()
  self:AddCellClickEvent()
end

function AdventureEquipComposeCell:AddTipEvt()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local press = function(obj, state)
    if state and self.choosed and self.data ~= nil then
      self.tipData.itemdata = self.data
      TipManager.Instance:ShowItemFloatTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {210, -50})
    end
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.longPress.pressEvent = press
end

function AdventureEquipComposeCell:SetData(data)
  AdventureEquipComposeCell.super.SetData(self, data)
  self.data = data
  if data.neednum then
    local colorFormat = data.num >= data.neednum and "%s" or TextColor_Red
    self:UpdateNumLabel(string.format(colorFormat, data.neednum))
  else
    self:UpdateNumLabel(data.num)
  end
  self:ActiveChooseSymbol(false)
  self:ActiveNeedChoose(data.id ~= AdventureEquipComposeCell.ItemType.CommonMaterial)
  self:ActiveReplaceIcon(false)
end

function AdventureEquipComposeCell:ActiveNeedChoose(bool)
  self.needChoose:SetActive(bool)
end

function AdventureEquipComposeCell:ActiveReplaceIcon(bool)
  self.replaceIcon:SetActive(bool)
end

function AdventureEquipComposeCell:ActiveChooseSymbol(bool)
  self.chooseSymbol:SetActive(bool)
end
