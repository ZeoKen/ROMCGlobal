ComodoBuildingUpgradeAttrListCell = class("ComodoBuildingUpgradeAttrListCell", CoreView)
local unavailableSpColor, availableLabelColor, unavailableLabelColor = LuaColor.New(1, 1, 1, 0.25), LuaColor.New(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1), LuaColor.New(0.6274509803921569, 0.6274509803921569, 0.6274509803921569, 1)
local buildingIns

function ComodoBuildingUpgradeAttrListCell:ctor(obj)
  if not buildingIns then
    buildingIns = ComodoBuildingProxy.Instance
  end
  ComodoBuildingUpgradeAttrListCell.super.ctor(self, obj)
  self:Init()
end

function ComodoBuildingUpgradeAttrListCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
end

function ComodoBuildingUpgradeAttrListCell:SetData(data)
  self.data = data
  local flag = data ~= nil and next(data) ~= nil
  self.gameObject:SetActive(flag)
  if not flag then
    return
  end
  self.label.text = buildingIns:GetAssetEffectDescs(data.BuildId, data.FuncType, data.Level)
  local curLv = buildingIns:GetBuildingFuncLevelByType(data.BuildId, data.FuncType)
  local available = curLv >= data.Level
  self.icon.spriteName = available and "new-com_icon_card_3" or "new-com_icon_card_5"
  self.icon.color = available and ColorUtil.NGUIWhite or unavailableSpColor
  self.label.color = available and availableLabelColor or unavailableLabelColor
end

function ComodoBuildingUpgradeAttrListCell:SetLabelWidth(width)
  self.label.width = width or 120
end
