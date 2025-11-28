HomeSkadaDamageMonitor = class("HomeSkadaDamageMonitor")
DamageMonitorType = {
  All = 0,
  Physical = 1,
  Magical = 2,
  Other = 3
}
local tickInstance
local timeoutTid = 1
local onSelectUpdateTid = 2

function HomeSkadaDamageMonitor:ctor()
  self.monitorData = {}
  self:ResetMonitor()
  tickInstance = TimeTickManager.Me()
end

function HomeSkadaDamageMonitor:OnRemove()
  tickInstance:ClearTick(self)
  if self.removeCallBack then
    self.removeCallBack(self)
  end
end

function HomeSkadaDamageMonitor:IsMonitoring()
  return self.startMonitorTime ~= nil
end

function HomeSkadaDamageMonitor:ResetMonitor()
  self.damageAllSum = 0
  self.damagePhysicalSum = 0
  self.damageMagicalSum = 0
  self.damageOtherSum = 0
  self.dps = 0
  self.startMonitorTime = nil
  self.monitorTime = nil
end

function HomeSkadaDamageMonitor:AddDamage(type, value)
  local currentTime = ServerTime.CurServerTime() / 1000
  if not self.startMonitorTime then
    self.startMonitorTime = currentTime
  end
  tickInstance:ClearTick(self, timeoutTid)
  tickInstance:CreateTick(GameConfig.Home.Skada.resetTimeout * 1000, 0, self.ResetMonitor, self, timeoutTid)
  if currentTime - self.startMonitorTime <= GameConfig.Home.Skada.maxAnalysisTime then
    self.damageAllSum = self.damageAllSum + value
    if type == DamageMonitorType.Physical then
      self.damagePhysicalSum = self.damagePhysicalSum + value
    elseif type == DamageMonitorType.Magical then
      self.damageMagicalSum = self.damageMagicalSum + value
    elseif type == DamageMonitorType.Other then
      self.damageOtherSum = self.damageOtherSum + value
    end
  end
  if self.addDamageCallBack then
    self.addDamageCallBack(self)
  end
end

function HomeSkadaDamageMonitor:GetDamageSum(type)
  if type == DamageMonitorType.Physical then
    return self.damagePhysicalSum
  elseif type == DamageMonitorType.Magical then
    return self.damageMagicalSum
  elseif type == DamageMonitorType.Other then
    return self.damageOtherSum
  else
    return self.damageAllSum
  end
end

function HomeSkadaDamageMonitor:GetDPS()
  return self.dps
end

function HomeSkadaDamageMonitor:Update()
  if self.isOnSelect then
    self.dps = 0
    if self.startMonitorTime then
      self.monitorTime = ServerTime.CurServerTime() / 1000 - self.startMonitorTime
      if self.monitorTime >= 1 then
        self.dps = self.damageAllSum / self.monitorTime
      end
    end
    if self.updateCallBack then
      self.updateCallBack(self)
    end
  end
end

function HomeSkadaDamageMonitor:SetOnSelect(istrue, addDamageCallBack, updateCallBack, removeCallBack)
  self.isOnSelect = istrue
  if istrue then
    self.addDamageCallBack = addDamageCallBack
    self.updateCallBack = updateCallBack
    self.removeCallBack = removeCallBack
    tickInstance:CreateTick(0, 300, self.Update, self, onSelectUpdateTid)
  else
    tickInstance:ClearTick(self, onSelectUpdateTid)
    self.addDamageCallBack = nil
    self.updateCallBack = nil
    self.removeCallBack = nil
  end
end
