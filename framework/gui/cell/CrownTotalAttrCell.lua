autoImport("BaseCell")
CrownTotalAttrCell = class("CrownTotalAttrCell", BaseCell)

function CrownTotalAttrCell:Init()
  CrownTotalAttrCell.super.Init(self)
  self.dotLine = self:FindGO("DotLine")
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.attrValue = self:FindComponent("AttrValue", UILabel)
end

function CrownTotalAttrCell:SetData(data)
  CrownTotalAttrCell.super.SetData(self, data)
  self.data = data
  if not data then
    return
  end
  local varName = data.varName
  local value = data.value or 0
  local propConfig = data.propConfig
  local displayVarName = varName
  local displayPropConfig = propConfig
  if varName and string.sub(varName, -3) == "Per" then
    local baseVarName = string.sub(varName, 1, -4)
    local basePropConfig = Game.Config_PropName and Game.Config_PropName[baseVarName]
    if basePropConfig then
      displayVarName = baseVarName
      displayPropConfig = basePropConfig
    end
  end
  if self.attrName then
    if (displayVarName == "MaxHP" or displayVarName == "MaxHp") and ZhString.EquipMemory_MaxHp then
      self.attrName.text = ZhString.EquipMemory_MaxHp
    elseif displayPropConfig and displayPropConfig.PropName then
      self.attrName.text = displayPropConfig.PropName
    else
      self.attrName.text = displayVarName or varName or ""
    end
  end
  if self.attrValue then
    if not value or value == 0 then
      self.attrValue.gameObject:SetActive(false)
      if self.attrName then
        self.attrName.width = 450
      end
    else
      self.attrValue.gameObject:SetActive(true)
      if self.attrName then
        self.attrName.width = 300
      end
      local valueStr = ""
      local isPercent = propConfig and (propConfig.IsPercent == 1 or propConfig.IsClientPercent == 1) or varName and string.sub(varName, -3) == "Per"
      if isPercent then
        local percentValue = value * 100
        if percentValue == math.floor(percentValue) then
          valueStr = string.format("%d%%", percentValue)
        else
          valueStr = string.format("%.1f%%", percentValue)
        end
      else
        valueStr = tostring(math.floor(value))
      end
      if 0 < value then
        valueStr = "+" .. valueStr
      end
      self.attrValue.text = valueStr
    end
  end
  if self.dotLine then
    local isFirst = self.indexInList == 1
    if isFirst then
      self:Hide(self.dotLine)
    else
      self:Show(self.dotLine)
    end
  end
end
