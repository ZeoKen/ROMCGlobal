TipLabelNameValuePair_Memory = class("TipLabelNameValuePair_Memory", CoreView)

function TipLabelNameValuePair_Memory:ctor(obj)
  TipLabelNameValuePair_Memory.super.ctor(self, obj)
  self:Init()
end

function TipLabelNameValuePair_Memory:Init()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel, self.gameObject)
  self.lockedLabel = self:FindComponent("Locked", UILabel)
  self.lockedSprite = self:FindComponent("LockedSprite", UISprite)
  self.colorSymbol = self:FindGO("ColorSymbol"):GetComponent(UISprite)
  self.lockSymbol = self:FindGO("LockSymbol")
end

function TipLabelNameValuePair_Memory:SetData(nameValueData)
  local flag = nameValueData ~= nil and next(nameValueData) ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self.data = nameValueData
  else
    self.data = nil
    return
  end
  local locked
  if nameValueData.locked then
    locked = true
  else
    locked = false
  end
  local isEmpty = nameValueData.empty or false
  local color = nameValueData.color
  self.valueLabel.gameObject:SetActive(color == nil)
  self.lockedLabel.gameObject:SetActive(locked)
  self.nameLabel.gameObject:SetActive(not locked)
  if isEmpty then
    self.nameLabel.width = 300
    self.nameLabel.text = nameValueData.name or ""
    self.valueLabel.text = ""
    self.colorSymbol.gameObject:SetActive(false)
    self.lockSymbol:SetActive(true)
  else
    self.lockSymbol:SetActive(false)
    self.nameLabel.text = nameValueData.name or ""
    if color ~= nil then
      self.valueLabel.text = ""
      self.colorSymbol.gameObject:SetActive(true)
      self.colorSymbol.spriteName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
      self.nameLabel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(29, 9, 0)
      self.nameLabel.width = 300
    else
      self.valueLabel.text = nameValueData.value or ""
      self.colorSymbol.gameObject:SetActive(false)
      self.nameLabel.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 9, 0)
      self.nameLabel.width = 228
    end
  end
  self:TrySetColor()
end

function TipLabelNameValuePair_Memory:TrySetColor(nameValueData)
  nameValueData = nameValueData or self.data
  if not nameValueData then
    return
  end
  local realNameColor = self:_GetRealColor(nameValueData.nameColor or nameValueData.color)
  if realNameColor then
    self.lockedLabel.color = realNameColor
    self.lockedSprite.color = realNameColor
    self.nameLabel.color = realNameColor
  end
  local realValueColor = self:_GetRealColor(nameValueData.valueColor or nameValueData.color)
  if realValueColor then
    self.valueLabel.color = realValueColor
  end
end

function TipLabelNameValuePair_Memory:_GetRealColor(color)
  local tColor, realColor = type(color)
  if tColor == "table" then
    realColor = color
  elseif tColor == "string" then
    local succ, pColor = ColorUtil.TryParseHexString(color)
    if succ then
      realColor = pColor
    end
  end
  return realColor
end
