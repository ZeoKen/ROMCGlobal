ServantRaidStatData = class("ServantRaidStatData")

function ServantRaidStatData:ctor(staticData)
  self.id = staticData.id
  self.staticData = staticData
  self.icon = staticData.Sub_Icon
  self.name = staticData.Title
  self.bosses = {}
  self.dailyLimit = 0
  self.weekLimit = 0
  self.stat = 0
  self.bosskills = 0
  self.status = EPROGRESSSTATUS.EPROGRESSSTATUS_MIN
  self.passtimes = 0
end

function ServantRaidStatData:UpdateStat(serverdata)
  self.status = serverdata.status
  self.passtimes = serverdata.passtimes
  self.exinfo = {}
  for i = 1, #serverdata.params do
    TableUtility.ArrayPushBack(self.exinfo, serverdata.params[i])
  end
end

function ServantRaidStatData:SetProgress()
end

function ServantRaidStatData:SetRaidStat()
end

function ServantRaidStatData:SetRaidBossStat()
end

ServantRaidMapStatData = class("ServantRaidMapStatData")

function ServantRaidMapStatData:ctor(staticData)
  self.staticData = staticData
  self.id = staticData.id
  self.type = staticData.PageType
  self.icon = staticData.Icon
  self.name = staticData.Name
  self.title = staticData.Area_Name
  self.drop = staticData.Falling
  self.stat = false
end

function ServantRaidMapStatData:UpdateRewardStat(stat)
  self.stat = self.stat or stat
end

function ServantRaidMapStatData:ClearRewardStat()
  self.stat = false
end
