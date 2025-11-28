WildMvpMapSymbol = class("WildMvpMapSymbol", CoreView)

function WildMvpMapSymbol:ctor(obj, data)
  WildMvpMapSymbol.super.ctor(self, obj)
  self:FindObjs()
  self:SetData(data)
end

function WildMvpMapSymbol:FindObjs()
  self.disabledIcon = self:FindComponent("DisableIcon", UISprite)
  self.progressIcon = self:FindComponent("ProgressIcon", UISprite)
  self.activeIcon = self:FindComponent("ActiveIcon", UISprite)
end

function WildMvpMapSymbol:SetData(data)
  if not data then
    return
  end
  self.data = data
  local depth = data:GetMapSymbolDepth()
  if depth then
    self.disabledIcon.depth = depth + 1
    self.progressIcon.depth = depth + 2
    self.activeIcon.depth = depth + 3
  end
  local disableIconName = data:GetDisabledMapSymbolIcon()
  if disableIconName then
    IconManager:SetMapIcon(disableIconName, self.disabledIcon)
  end
  local progressIconName = data:GetProgressMapSymbolIcon()
  if progressIconName then
    IconManager:SetMapIcon(progressIconName, self.progressIcon)
  end
  local activeIconName = data:GetActiveMapSymbolIcon()
  if activeIconName then
    IconManager:SetMapIcon(activeIconName, self.activeIcon)
  end
  if data.symbolSize then
    self.disabledIcon.width = data.symbolSize
    self.disabledIcon.height = data.symbolSize
    self.progressIcon.width = data.symbolSize
    self.progressIcon.height = data.symbolSize
    self.activeIcon.width = data.symbolSize
    self.activeIcon.height = data.symbolSize
  end
  self.holdPercent = data.holdPercent
  self:UpdateProgress()
end

function WildMvpMapSymbol:UpdateProgress()
  if not self.data then
    return
  end
  if self.data.noPosHide then
    self.gameObject:SetActive(false)
    return
  else
    self.gameObject:SetActive(true)
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
