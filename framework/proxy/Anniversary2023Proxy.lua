autoImport("Anniversary2023Data")
autoImport("GameConfigActivityProxy")
Anniversary2023Proxy = class("Anniversary2023Proxy", GameConfigActivityProxy)

function Anniversary2023Proxy:ctor(proxyName, data)
  self.proxyName = proxyName or "Anniversary2023Proxy"
  self.redTipId = 10742
  if Anniversary2023Proxy.Instance == nil then
    Anniversary2023Proxy.Instance = self
  end
  if data ~= nil then
    self:Init(data)
  end
end

function Anniversary2023Proxy:Init(activityData)
  if GameConfig.SystemForbid.AnniversaryLive then
    return
  end
  if not activityData then
    self.actData = nil
    return
  end
  if self.actData then
    self.actData:SetData(activityData)
  else
    self.actData = Anniversary2023Data.new(activityData)
  end
  EventManager.Me():DispatchEvent(AnniversaryLive.OnActivityStart, memberData)
end

function Anniversary2023Proxy:Destroy()
  self.actData = nil
  EventManager.Me():DispatchEvent(AnniversaryLive.OnActivityEnd, memberData)
end

function Anniversary2023Proxy:UpdateServerData(serverData)
  if self.actData then
    self.actData:UpdateServerData(serverData)
  end
end

function Anniversary2023Proxy:OpenView()
  if not self.actData then
    return
  end
  if self.actData:IsSigninEnd() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Anniversary2023LiveView
    })
  else
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.Anniversary2023SigninView
    })
  end
end

function Anniversary2023Proxy:TakeReward(cellData)
  if cellData and cellData:CanTakeReward() then
    ServiceActivityCmdProxy.Instance:CallAnniversarySignInReward(cellData.day, cellData.isShare)
  end
end

function Anniversary2023Proxy:NotifyShareToServer()
  local cellData = self.actData and self.actData.extraData
  if cellData and cellData:IsInActive() then
    ServiceActivityCmdProxy.Instance:CallAnniversarySignInReward(0, false, true)
  end
end

function Anniversary2023Proxy:ShouldRemoveRedTip()
  if self.actData and self.actData:HasUntakenReward() then
    return false
  end
  return true
end
