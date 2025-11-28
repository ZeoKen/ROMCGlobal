autoImport("ItemCell")
ItemNewCell = class("ItemNewCell", ItemCell)
ItemNewCell.CellPartPathFolderName = "ItemNewCellParts"
ItemNewCell.DefaultNumLabelLocalPos = LuaVector3.New(31, -32, 0)
ItemNewCell.CardSlotElementWidth = 13.5

function ItemNewCell:InitItemCell()
  ItemNewCell.super.InitItemCell(self)
  self:SetDefaultBgSprite(nil, "new-com_bg_icon_01")
  self:SetCellPartScale(1)
end

function ItemNewCell:GetCellPartPrefix(key)
  return "ItemNewCell_"
end

function ItemNewCell:LoadCellPart(key, parent)
  local go = ItemNewCell.super.LoadCellPart(self, key, parent)
  if not self.cellPartScaleBypassMap or not self.cellPartScaleBypassMap[key] then
    self:UpdateCellPartScale(go)
  end
  return go
end

function ItemNewCell:SetCellPartScale(scale)
  self.exCellPartScale = self.cellPartScale or 1
  self.cellPartScale = tonumber(scale) or self.exCellPartScale
  local ratio = self.cellPartScale / self.exCellPartScale
  if not math.Approximately(ratio, 1) then
    self:UpdateCellPartScale()
  end
end

function ItemNewCell:UpdateCellPartScale(...)
  local parts = ReusableTable.CreateArray()
  local argCount = select("#", ...)
  if argCount <= 0 then
    if self.cellPartMap then
      for key, go in pairs(self.cellPartMap) do
        if not self.cellPartScaleBypassMap or not self.cellPartScaleBypassMap[key] then
          TableUtility.ArrayPushBack(parts, go)
        end
      end
    end
  else
    for i = 1, argCount do
      TableUtility.ArrayPushBack(parts, select(i, ...))
    end
  end
  for i = 1, #parts do
    self:_UpdateCellPartScale(parts[i])
  end
  ReusableTable.DestroyAndClearArray(parts)
end

function ItemNewCell:_UpdateCellPartScale(go)
  local ratio = self.cellPartScale / self.exCellPartScale
  local exScaleX, exScaleY, exScaleZ = LuaGameObject.GetLocalScale(go.transform)
  go.transform.localScale = LuaGeometry.GetTempVector3(exScaleX * ratio, exScaleY * ratio, exScaleZ * ratio)
end

function ItemNewCell:SetIcon(data)
  if not self.icon then
    return
  end
  local scale = LuaGeometry.TempGetLocalScale(self.icon.transform)
  ItemNewCell.super.SetIcon(self, data)
  self.icon.transform.localScale = scale
end

ItemNewCellForTips = class("ItemNewCellForTips", ItemNewCell)
ItemNewCellForTips.DefaultNumLabelLocalPos = LuaVector3.New(42, -43, 0)
ItemNewCellForTips.CardSlotElementWidth = 11
ItemNewCellForTips.SpecialCellPartPrefixMap = {
  Equip = "ItemNewCellForTips_",
  ConditionForbid = "ItemNewCellForTips_",
  MainColorPalette = "ItemNewCellForTips_"
}

function ItemNewCellForTips:InitItemCell()
  ItemNewCellForTips.super.InitItemCell(self)
  self:SetCellPartScale(1.3)
end

function ItemNewCellForTips:GetCellPartPrefix(key)
  if self.SpecialCellPartPrefixMap[key] then
    self.cellPartScaleBypassMap = self.cellPartScaleBypassMap or {}
    self.cellPartScaleBypassMap[key] = true
    return self.SpecialCellPartPrefixMap[key]
  end
  return ItemNewCellForTips.super.GetCellPartPrefix(self, key)
end
