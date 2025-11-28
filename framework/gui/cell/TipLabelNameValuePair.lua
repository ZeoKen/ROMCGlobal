TipLabelNameValuePair = class("TipLabelNameValuePair", CoreView)

function TipLabelNameValuePair:ctor(obj)
  TipLabelNameValuePair.super.ctor(self, obj)
  self:Init()
end

function TipLabelNameValuePair:Init()
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.valueLabel = self:FindComponent("Value", UILabel)
  self.lockedLabel = self:FindComponent("Locked", UILabel)
  self.lockedSprite = self:FindComponent("LockedSprite", UISprite)
end

function TipLabelNameValuePair:SetData(nameValueData)
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
  self.lockedLabel.gameObject:SetActive(locked)
  self.nameLabel.gameObject:SetActive(not locked)
  self.valueLabel.gameObject:SetActive(not locked)
  if locked then
    self.lockedLabel.text = type(nameValueData.locked) == "string" and nameValueData.locked or ZhString.ItemTip_UnlockAfterGot
  else
    self.nameLabel.text = nameValueData.name or ""
    self.valueLabel.text = nameValueData.value or ""
    self.nameLabel.width = StringUtil.IsEmpty(self.valueLabel.text) and 298 or 228
  end
  self:TrySetColor()
end

function TipLabelNameValuePair:TrySetColor(nameValueData)
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

function TipLabelNameValuePair:_GetRealColor(color)
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
