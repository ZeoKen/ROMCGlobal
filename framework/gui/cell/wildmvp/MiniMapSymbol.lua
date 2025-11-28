MiniMapSymbol = class("MiniMapSymbol", CoreView)

function MiniMapSymbol:ctor(obj, data)
  MiniMapSymbol.super.ctor(self, obj)
  self:FindObjs()
  self:SetData(data)
end

function MiniMapSymbol:FindObjs()
  self.disabledIcon = self:FindComponent("DisableIcon", UISprite)
  self.progressIcon = self:FindComponent("ProgressIcon", UISprite)
  self.activeIcon = self:FindComponent("ActiveIcon", UISprite)
end

function MiniMapSymbol:SetData(data)
  if not data then
    return
  end
  self.data = data
  local depth = data:GetParama("depth") or 5
  if depth then
    self.disabledIcon.depth = depth + 1
    self.progressIcon.depth = depth + 2
    self.activeIcon.depth = depth + 3
  end
  local disableIconName = data:GetParama("Symbol_Disabled")
  if disableIconName and disableIconName ~= "" and self.disabledIcon.spriteName ~= disableIconName then
    IconManager:SetMapIcon(disableIconName, self.disabledIcon)
    self.disabledIcon:MakePixelPerfect()
  end
  local progressIconName = data:GetParama("Symbol")
  if progressIconName and progressIconName ~= "" and self.progressIcon.spriteName ~= progressIconName then
    IconManager:SetMapIcon(progressIconName, self.progressIcon)
    self.progressIcon:MakePixelPerfect()
  end
  local activeIconName = data:GetParama("Symbol")
  if activeIconName and activeIconName ~= "" and self.activeIcon.spriteName ~= activeIconName then
    IconManager:SetMapIcon(activeIconName, self.activeIcon)
    self.activeIcon:MakePixelPerfect()
  end
  if data.symbolSize then
    local ratio = self.disabledIcon.height / self.disabledIcon.width
    self.disabledIcon.width = data.symbolSize
    self.disabledIcon.height = data.symbolSize * ratio
    ratio = self.progressIcon.height / self.progressIcon.width
    self.progressIcon.width = data.symbolSize
    self.progressIcon.height = data.symbolSize * ratio
    ratio = self.activeIcon.height / self.activeIcon.width
    self.activeIcon.width = data.symbolSize
    self.activeIcon.height = data.symbolSize * ratio
  else
    local w, h = data:GetParama("w"), data:GetParama("h")
    if w and h then
      self.activeIcon.width = w
      self.activeIcon.height = h
    end
  end
  self.holdPercent = data.holdPercent
  self:UpdateProgress()
end

function MiniMapSymbol:UpdateProgress()
  if not self.data then
    return
  end
  local progress, isAlive = self.data:GetMapSymbolProgress()
  if isAlive then
    self.disabledIcon.gameObject:SetActive(false)
    self.progressIcon.gameObject:SetActive(false)
    self.activeIcon.gameObject:SetActive(true)
  else
    self.disabledIcon.gameObject:SetActive(true)
    self.progressIcon.gameObject:SetActive(true)
    self.activeIcon.gameObject:SetActive(false)
    if self.holdPercent and progress > self.holdPercent and progress < 1 then
      self.progressIcon.fillAmount = self.holdPercent
    else
      self.progressIcon.fillAmount = progress
    end
  end
end
