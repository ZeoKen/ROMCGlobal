autoImport("GemAttributeProfitCell")
EnchantTransferAttributeCell = class("EnchantTransferAttributeCell", GemAttributeProfitCell)

function EnchantTransferAttributeCell:Init()
  EnchantTransferAttributeCell.super.Init(self)
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
end

function EnchantTransferAttributeCell:SetData(nameValueData)
  EnchantTransferAttributeCell.super.SetData(self, nameValueData)
  local flag = nameValueData ~= nil and next(nameValueData) ~= nil
  if not flag then
    return
  end
  self.label.width = StringUtil.IsEmpty(self.valueLabel.text) and 210 or 140
end

RefineTransferAttributeCell = class("RefineTransferAttributeCell", EnchantTransferAttributeCell)
local riseIndName, fallIndName = "Equipmentopen_icon_rise", "Equipmentopen_icon_fall"
local riseColorF, fallColorF = "[c][149b81]%s[-][/c]", "[c][ff6021]%s[-][/c]"

function RefineTransferAttributeCell:Init()
  self.label = self:FindComponent("Name", UILabel)
  self.valueLabel1 = self:FindComponent("Value1", UILabel)
  self.valueLabel2 = self:FindComponent("Value2", UILabel)
  self.indicator = self:FindComponent("Indicator", UISprite)
  self.arrow = self:FindComponent("Arrow", UISprite)
end

function RefineTransferAttributeCell:SetData(nameValueData)
  local flag = nameValueData ~= nil and next(nameValueData) ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.v1, self.v2 = nameValueData and nameValueData.value1, nameValueData and nameValueData.value2
  self.label.text = nameValueData and nameValueData.name or ""
  self.valueLabel1.text = self.v1 or ""
  local compare = nameValueData and nameValueData.compare
  self.valueLabel2.text = string.format(compare and riseColorF or fallColorF, self.v2 or "")
  self.indicator.spriteName = compare and riseIndName or fallIndName
end

EnchantNewTransferAttributeCell = class("EnchantNewTransferAttributeCell", GemAttributeProfitCell)

function EnchantNewTransferAttributeCell:Init()
  EnchantNewTransferAttributeCell.super.Init(self)
  self.bg = self:FindGO("Bg"):GetComponent(UISprite)
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
end

function EnchantNewTransferAttributeCell:SetData(nameValueData)
  EnchantNewTransferAttributeCell.super.SetData(self, nameValueData)
  local flag = nameValueData ~= nil and next(nameValueData) ~= nil
  if not flag then
    return
  end
  self.label.width = StringUtil.IsEmpty(self.valueLabel.text) and 210 or 140
  self.icon.spriteName = StringUtil.IsEmpty(self.valueLabel.text) and "enchant_list_icon_04" or "enchant_list_icon_01"
  self.bg.height = self.label.printedSize.y + 10
end
