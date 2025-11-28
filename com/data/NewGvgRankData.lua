local _ArrayPushBack = TableUtility.ArrayPushBack
autoImport("NewGvgRank_GuildShowInfo")
GvgScoreDetailInfo = class("GvgScoreDetailInfo")

function GvgScoreDetailInfo:ctor(fire_count)
  self.dataArray = {
    fire_count,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
end

function GvgScoreDetailInfo:SetServerData(server_detail)
  if not server_detail then
    return
  end
  self.dataArray[1] = server_detail.firecount or 0
  self.dataArray[2] = server_detail.defense_score or 0
  self.dataArray[3] = server_detail.attack_score or 0
  self.dataArray[4] = server_detail.perfect_score or 0
  self.dataArray[5] = server_detail.occupy_score or 0
  self.dataArray[6] = server_detail.continue_score or 0
  self.dataArray[7] = server_detail.point_score or 0
  if GameConfig.GvgNewConfig.kill_mvp_score then
    self.dataArray[7] = server_detail.mvp_score or 0
  end
  local result = 0
  for i = 2, 7 do
    result = self.dataArray[i] + result
  end
  self.dataArray[8] = result
end

function GvgScoreDetailInfo:GetFireCount()
  return self.dataArray[1]
end

function GvgScoreDetailInfo:GetResultScore()
  return self.dataArray[8]
end

function GvgScoreDetailInfo:SetTop()
  self.isTop = true
end

NewGvgRankData = class("NewGvgRankData")

function NewGvgRankData:ctor(data)
  self.id = data.guildid
  self.rank = data.rank
  self.guildInfo = NewGvgRank_GuildShowInfo.new(data.guildid, data.guildinfo)
  self.portrait = self.guildInfo.portrait
  self.totalScore = data.score or 0
  self.detailDatas = {}
  local totalFireCnt = GvgProxy.Instance:GetWeekBattleCount()
  for i = 1, totalFireCnt do
    _ArrayPushBack(self.detailDatas, GvgScoreDetailInfo.new(i))
  end
  if not data.details then
    return
  end
  self.serverScore = {}
  local firecount
  self.hasDetailData = 0 < #data.details
  local serverDetailData
  for i = 1, #data.details do
    serverDetailData = data.details[i]
    firecount = serverDetailData.firecount
    local sd = GvgScoreDetailInfo.new(firecount)
    sd:SetServerData(serverDetailData)
    _ArrayPushBack(self.serverScore, sd)
    if self.detailDatas[firecount] then
      self.detailDatas[firecount]:SetServerData(serverDetailData)
    else
      redlog("[NewGVG]服务器场次同步错误，客户端服务器season_week_count 配置不一致,服务器场次： ", firecount)
    end
  end
  if not next(self.serverScore) then
    return
  end
  table.sort(self.serverScore, function(a, b)
    local aScore = a:GetResultScore()
    local bScore = b:GetResultScore()
    local aFireCnt = a:GetFireCount()
    local bFireCnt = b:GetFireCount()
    if aScore == bScore then
      return aFireCnt < bFireCnt
    else
      return aScore > bScore
    end
  end)
  local score_fire_count = GameConfig.GvgNewConfig.score_fire_count or 3
  for i = 1, score_fire_count do
    if self.serverScore[i] then
      firecount = self.serverScore[i]:GetFireCount()
      if self.detailDatas[firecount] then
        self.detailDatas[firecount]:SetTop()
      else
        redlog("[NewGVG]服务器场次同步错误，客户端服务器season_week_count 配置不一致,服务器场次： ", firecount)
      end
    end
  end
end

function NewGvgRankData:GetDetailDatas()
  return self.detailDatas or _EmptyTable
end

function NewGvgRankData:NoDetailData()
  return self.totalScore > 0 and not self.hasDetailData
end

function NewGvgRankData:IsTop3()
  return self.rank >= 1 and self.rank <= 3
end

function NewGvgRankData:NoRank()
  return self.rank == 0
end

function NewGvgRankData:IsChampion()
  return self.rank == 1
end

function NewGvgRankData:HasReward()
  local groupCtn = GvgProxy.Instance:GetGroupCnt()
  return not self:NoRank() and self.rank <= groupCtn + 1
end

function NewGvgRankData:GetLeaderName()
  return self.guildInfo.leaderName
end

function NewGvgRankData:GetGuildName()
  return self.guildInfo.guildName
end

function NewGvgRankData:GetServerId()
  return self.guildInfo.serverId
end

function NewGvgRankData:GetZoneId()
  return GvgProxy.ClientGroupId(self.guildInfo.gvgGroup)
end
