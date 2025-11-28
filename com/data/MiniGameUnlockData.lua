MiniGameUnlockData = class("MiniGameUnlockData")

function MiniGameUnlockData:ctor(serverdata)
  self.type = 0
  self.difficulty = 0
  self.lastreward = 0
  self.dailyrest = 0
  self.passall = false
  self:SetData(serverdata)
end

function MiniGameUnlockData:SetData(serverdata)
  self.type = serverdata.type
  self.difficulty = serverdata.difficulty
  self.lastreward = serverdata.lastreward
  self.dailyrest = serverdata.dailyrest
  self.passall = serverdata.passall
  if serverdata.challengerecord then
    self:UpdateChallengeRecord(serverdata.challengerecord)
  end
end

function MiniGameUnlockData:UpdateChallengeRecord(challengerecord)
  self.record = challengerecord.value
  self.recordTime = challengerecord.timestamp
end

function MiniGameUnlockData:GetChallengeRecord()
  return self.record, self.recordTime
end
