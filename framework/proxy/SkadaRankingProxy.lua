SkadaRankingProxy = class("SkadaRankingProxy", pm.Proxy)
SkadaRankingProxy.Instance = nil
SkadaRankingProxy.NAME = "SkadaRankingProxy"
local rank_data_1 = {
  hpreduce = 0,
  nature = 5,
  race = 2,
  shape = 2,
  totaldamage = 147,
  totaltime = 4,
  user = {
    baselevel = 11,
    blink = false,
    body = 14,
    charid = 4318815775,
    eye = 2,
    gender = 2,
    guildname = "",
    hair = 14,
    haircolor = 14,
    name = "123",
    profession = 22
  },
  rounds = {
    {
      atkcount = 1,
      skillid = 73001,
      totaldamage = 147
    }
  }
}
local rank_data_2 = {
  hpreduce = 0,
  nature = 5,
  race = 2,
  shape = 2,
  totaldamage = 147,
  totaltime = 4,
  user = {
    baselevel = 11,
    blink = false,
    body = 14,
    charid = 4318815775,
    eye = 2,
    gender = 2,
    guildname = "",
    hair = 14,
    haircolor = 14,
    name = "345",
    profession = 32
  },
  rounds = {
    {
      atkcount = 1,
      skillid = 73001,
      totaldamage = 147
    }
  }
}
local rank_data_3 = {
  hpreduce = 0,
  nature = 5,
  race = 2,
  shape = 2,
  totaldamage = 147,
  totaltime = 4,
  user = {
    baselevel = 11,
    blink = false,
    body = 14,
    charid = 4318815775,
    eye = 2,
    gender = 2,
    guildname = "",
    hair = 14,
    haircolor = 14,
    name = "323433",
    profession = 31
  },
  rounds = {
    {
      atkcount = 1,
      skillid = 73001,
      totaldamage = 147
    }
  }
}
SkadaRankingProxy.test_recv1 = {
  typebranch = 999,
  hpreduce = 999,
  ranks = {rank_data_1, rank_data_2},
  over = false
}
SkadaRankingProxy.test_recv1e = {
  typebranch = 999,
  hpreduce = 999,
  ranks = {rank_data_3},
  over = true
}

function SkadaRankingProxy:ctor(proxyName, data)
  self.proxyName = proxyName or SkadaRankingProxy.NAME
  if SkadaRankingProxy.Instance == nil then
    SkadaRankingProxy.Instance = self
  end
  if data then
    self:setData(data)
  end
end

local function temp_process_server_data(dataTable)
  for k, v in pairs(dataTable) do
    if type(v) == "number" and 1000000 < v then
      dataTable[k] = 1
    end
    if type(v) == "table" then
      temp_process_server_data(dataTable[k])
    end
  end
end

function SkadaRankingProxy:RecvRankingData(data)
  if not self.rankPending or self.rankTypeBranch and self.rankTypeBranch ~= data.typebranch or self.rankHpReduce and self.rankHpReduce ~= data.hpreduce then
    if self.rankingData then
      for i = 1, #self.rankingData do
        ReusableTable.DestroyAndClearTable(self.rankingData[i])
      end
      ReusableTable.DestroyAndClearArray(self.rankingData)
      self.rankingData = nil
    end
    self.rankingData = ReusableTable.CreateArray()
    self.rankTypeBranch = data.typebranch
    self.rankHpReduce = data.hpreduce
  end
  self.rankPending = not data.over
  data = data.ranks
  local singleTable, rounds, clientRounds, singleRound, singleServerData, profession
  for i = 1, #data do
    singleServerData = data[i]
    profession = singleServerData.user.profession
    singleTable = ReusableTable.CreateTable()
    clientRounds = ReusableTable.CreateArray()
    singleTable.rounds = clientRounds
    singleTable.rank = #self.rankingData + 1
    self.rankingData[singleTable.rank] = self:ParseServerDamageItem(singleTable, singleServerData)
    rounds = singleServerData.rounds
    for j = 1, #rounds do
      singleRound = rounds[j]
      singleTable = ReusableTable.CreateTable()
      singleTable.skillID = singleRound.skillid
      singleTable.atkCount = math.max(singleRound.atkcount, 1)
      singleTable.totalDamage = singleRound.totaldamage
      singleTable.averageDamage = singleRound.totaldamage / singleRound.atkcount
      singleTable.percent = singleRound.totaldamage / singleServerData.totaldamage
      singleTable.profession = profession
      clientRounds[#clientRounds + 1] = singleTable
    end
  end
end

function SkadaRankingProxy:GetRankingData()
  return self.rankingData
end

function SkadaRankingProxy:GetSelfRankingData()
  if not self.rankingData then
    return
  end
  for i = 1, #self.rankingData do
    local data = self.rankingData[i]
    if data.charid == Game.Myself.data.id then
      return data
    end
  end
end

function SkadaRankingProxy:ParseServerDamageItem(singleTable, singleServerData)
  local serverUser = singleServerData.user
  singleTable.charid = serverUser.charid
  singleTable.body = serverUser.body
  singleTable.eye = serverUser.eye
  singleTable.hair = serverUser.hair
  singleTable.haircolor = serverUser.haircolor
  singleTable.baselevel = serverUser.baselevel
  singleTable.blink = serverUser.blink
  singleTable.profession = serverUser.profession
  singleTable.gender = serverUser.gender
  singleTable.name = serverUser.name
  singleTable.guildname = serverUser.guildname
  singleTable.woodRace = singleServerData.race
  singleTable.woodShape = singleServerData.shape
  singleTable.woodNature = singleServerData.nature
  singleTable.woodNatureLv = singleServerData.naturelv
  singleTable.woodDamageReduce = singleServerData.hpreduce
  singleTable.totalDamage = math.max(singleServerData.totaldamage, 1)
  singleTable.totalTime = math.max(singleServerData.totaltime, 1)
  singleTable.averageDamage = singleTable.totalDamage / singleTable.totalTime
  return singleTable
end
