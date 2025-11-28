RaidLogData = class("RaidLogData")

function RaidLogData:ctor()
  self.raidid = 0
  self.npcid = 0
  self.scale = 1
end

function RaidLogData:SetData(cfg)
  self.raidid = cfg.raidid
  self.npcid = cfg.npcid
  self.scale = cfg.scale
end

function RaidLogData:UpdateRecord(isCleared, time)
  self.time = time
  self.isCleared = isCleared
end

function RaidLogData:UpdateUnlock(isUnlocked)
  self.isUnlocked = isUnlocked
end

function RaidLogData:CheckUnlock()
  return self.isUnlocked == true
end
