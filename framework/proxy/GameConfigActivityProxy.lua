GameConfigActivityProxy = class("GameConfigActivityProxy", pm.Proxy)

function GameConfigActivityProxy:GetActData()
  return self.actData
end

function GameConfigActivityProxy:GetConfig()
  return self.actData and self.actData:GetConfig()
end

function GameConfigActivityProxy:IsActive()
  return self.actData and self.actData:IsActive()
end

function GameConfigActivityProxy:CanShow()
  local config = self:GetConfig()
  if not config then
    return false
  end
  local menuId = config.MenuID
  if not FunctionUnLockFunc.Me():CheckCanOpen(menuId) then
    return false
  end
  return true
end

function GameConfigActivityProxy:ShouldRemoveRedTip()
  return true
end

function GameConfigActivityProxy:UpdateRedTip()
  if not self.redTipId then
    return
  end
  if self:ShouldRemoveRedTip() then
    RedTipProxy.Instance:RemoveWholeTip(self.redTipId)
  else
    RedTipProxy.Instance:UpdateRedTip(self.redTipId)
  end
end

function GameConfigActivityProxy:OpenView()
end
