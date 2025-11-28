autoImport("ServantRaidStatData")
autoImport("ServantRaidMapStatData")
ServantRaidStatProxy = class("ServantRaidStatProxy", pm.Proxy)
ServantRaidStatProxy.Instance = nil
ServantRaidStatProxy.NAME = "ServantRaidStatProxy"
ServantRaidStatProxy.RAIDSTAT = {
  LOCK = 0,
  OPEN = 1,
  GIFT = 2,
  RECEIVED = 3
}
local RaidOnMap = {
  [3] = 1,
  [6] = 1,
  [9] = 1,
  [10] = 1,
  [13] = 1,
  [16] = 1,
  [19] = 1,
  [23] = 1,
  [24] = 1,
  [33] = 1
}

function ServantRaidStatProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ServantRaidStatProxy.NAME
  if ServantRaidStatProxy.Instance == nil then
    ServantRaidStatProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ServantRaidStatProxy:Init()
  self:PreprocessServantRaidData()
end

function ServantRaidStatProxy:PreprocessServantRaidData(serverLogin)
  if GameConfig.SystemForbid.ServantRaidStat then
    return
  end
  self.mapdata = {}
  self.onmaptypedata = {}
  local tempF = {}
  for k, _ in pairs(RaidOnMap) do
    RaidOnMap[k] = 0
    tempF[Table_DeaconStatistics[k].PageType] = k
  end
  local keys = {}
  for k, _ in pairs(Table_DeaconStatistics) do
    keys[k] = 1
    local pt = Table_DeaconStatistics[k].PageType
    local kk = tempF[pt]
    RaidOnMap[kk] = RaidOnMap[kk] + pt
  end
  if serverLogin then
    for k, v in pairs(Table_DeaconStatistics) do
      if v.FuncState and not FunctionUnLockFunc.checkFuncStateValid(v.FuncState) then
        keys[k] = nil
        local pt = Table_DeaconStatistics[k].PageType
        local kk = tempF[pt]
        if RaidOnMap[kk] then
          RaidOnMap[kk] = RaidOnMap[kk] - pt
        end
      end
    end
  end
  for k, v in pairs(RaidOnMap) do
    if 0 < v then
      self:AddMapData(k)
    end
  end
  self.mapindexdata = {}
  local v
  for k, _ in pairs(keys) do
    v = Table_DeaconStatistics[k]
    if v.PageType then
      local PageType = v.PageType
      local Difficulty = v.Difficulty
      if not self.mapindexdata[PageType] then
        self.mapindexdata[PageType] = {}
      end
      if not self.mapindexdata[PageType][Difficulty] then
        self.mapindexdata[PageType][Difficulty] = {}
        if v.TargetBoss then
          local data = self.mapindexdata[PageType][Difficulty][v.TargetBoss]
          data = data or ServantRaidStatData.new(v)
          self.mapindexdata[PageType][Difficulty][v.TargetBoss] = data
        else
          self.mapindexdata[PageType][Difficulty] = ServantRaidStatData.new(v)
        end
      elseif v.TargetBoss then
        local data = self.mapindexdata[PageType][Difficulty][v.TargetBoss]
        data = data or ServantRaidStatData.new(v)
        self.mapindexdata[PageType][Difficulty][v.TargetBoss] = data
      else
        self.mapindexdata[PageType][Difficulty] = ServantRaidStatData.new(v)
      end
    end
  end
end

function ServantRaidStatProxy:AddMapData(id)
  local data = Table_DeaconStatistics[id]
  if not data then
    return
  end
  data = ServantRaidMapStatData.new(data)
  local type = data.type
  self.mapdata[id] = data
  if not self.onmaptypedata[type] then
    self.onmaptypedata[type] = {}
  end
  local onmap = self.onmaptypedata[type]
  if 0 == TableUtility.ArrayFindIndex(onmap, id) then
    TableUtility.ArrayPushBack(onmap, id)
  end
end

function ServantRaidStatProxy:GetMapData(id)
  if id then
    return self.mapdata and self.mapdata[id]
  end
  return self.mapdata
end

function ServantRaidStatProxy:GetOnShowId(id)
  local data = Table_DeaconStatistics[id]
  if data then
    local type = data.PageType
    local onmap = self.onmaptypedata[type]
    if onmap and next(onmap) then
      if 0 == TableUtility.ArrayFindIndex(onmap, id) then
        return onmap[1]
      else
        return id
      end
    end
  end
end

function ServantRaidStatProxy:GetRaidData(type)
  if type and self.mapindexdata and self.mapindexdata[type] then
    local indexlist = self.mapindexdata[type]
    local typedata = {}
    for _, v in pairs(indexlist) do
      table.insert(typedata, v)
    end
    table.sort(typedata, function(t1, t2)
      return t1.id < t2.id
    end)
    return typedata
  end
end

function ServantRaidStatProxy:GetComodoRaidData(type)
  if type and self.mapindexdata and self.mapindexdata[type] then
    local indexlist = self.mapindexdata[type]
    local typedata = {}
    for diff, bossmap in pairs(indexlist) do
      for targetBoss, v in pairs(bossmap) do
        table.insert(typedata, v)
      end
    end
    table.sort(typedata, function(t1, t2)
      return t1.id < t2.id
    end)
    return typedata
  end
end

function ServantRaidStatProxy:GetSingleRaidData(type, difficulty)
  return self.mapindexdata and self.mapindexdata[type] and self.mapindexdata[type][difficulty]
end

function ServantRaidStatProxy:RecvServantStatisticsUserCmd(serverdata)
  if GameConfig.SystemForbid.ServantRaidStat then
    return
  end
  self.hasAvailRaidReward = false
  for _, v in pairs(self.mapdata) do
    v:ClearRewardStat()
  end
  if serverdata and serverdata.datas then
    for i = 1, #serverdata.datas do
      local data = serverdata.datas[i]
      local hasReward = data.status == EPROGRESSSTATUS.EPROGRESSSTATUS_REWARD
      local bossindex = data.params[1] or 0
      local indexData
      if (data.type == FuBenCmd_pb.ERAIDTYPE_COMODO_TEAM_RAID or data.type == FuBenCmd_pb.ERAIDTYPE_SEVEN_ROYAL_TEAM_RAID) and data.subtype and data.subtype then
        local sdata = self.mapindexdata and self.mapindexdata[data.type]
        if sdata then
          if not sdata[data.subtype] then
            redlog("服务器发来未统计的副本类型", "type", data.type, "subtype", data.subtype)
          else
            indexData = sdata[data.subtype][bossindex]
          end
        end
      else
        indexData = self.mapindexdata and self.mapindexdata[data.type] and self.mapindexdata[data.type][data.subtype]
      end
      if indexData then
        if hasReward then
          self.hasAvailRaidReward = true
        end
        indexData:UpdateStat(data)
        local onshow = self:GetOnShowId(indexData.id)
        onshow = onshow and self:GetMapData(onshow)
        if onshow then
          onshow:UpdateRewardStat(hasReward)
        end
      else
        redlog("服务器发来未统计的副本类型", "type", data.type, "subtype", data.subtype)
      end
    end
  end
  self:UpdateWholeRedTip()
end

function ServantRaidStatProxy:RecvServantStatisticsMailUserCmd(serverdata)
  if GameConfig.SystemForbid.ServantRaidStat then
    return
  end
  if serverdata and serverdata.mail then
    self.mail = {}
    self.mail.new = true
    self.mail.time = serverdata.mail.time
    self.mail.has_team = serverdata.mail.has_team and 1 or 0
    self.mail.enter_raid = serverdata.mail.enter_raid and 1 or 0
    self.mail.battle_time = serverdata.mail.battle_time or 0
    self.mail.cards = {}
    local cardid, card
    for i = 1, #serverdata.mail.cards do
      cardid = serverdata.mail.cards[i]
      card = self:CreateItemCardCellDataFromStaticId(cardid)
      if card then
        TableUtility.ArrayPushBack(self.mail.cards, card)
      end
    end
    if serverdata.mail.calcdata then
      local extrainfo
      for i = 1, #serverdata.mail.calcdata do
        extrainfo = serverdata.mail.calcdata[i]
        if extrainfo.type == 26 then
          extrainfo = extrainfo.params
          for j = 1, #extrainfo do
            if not self.mail.team_member then
              self.mail.team_member = extrainfo[j]
            else
              self.mail.team_member = self.mail.team_member .. "," .. extrainfo[j]
            end
          end
          break
        end
      end
    end
  else
    self.mail = nil
  end
  self:UpdateWholeRedTip()
end

function ServantRaidStatProxy:GenerateMailContent()
  if self.mail then
    local week = ServerTime.CurServerWeek()
    local indent = Game.Myself.data.id % 3
    indent = GameConfig.ServantRaidStat.WeeklyGradeOrder[indent] and GameConfig.ServantRaidStat.WeeklyGradeOrder[indent][week] or 1
    local myServantid = MyselfProxy.Instance:GetMyServantID()
    if 0 < myServantid and Table_Npc and Table_Npc[myServantid] and GameConfig.ServantRaidStat and GameConfig.ServantRaidStat.GenderTrueIntent then
      local servantGender = Table_Npc[myServantid].Gender or 1
      local indentCfg = GameConfig.ServantRaidStat.GenderTrueIntent[servantGender]
      if indentCfg and indent <= #indentCfg then
        indent = indentCfg[indent]
      end
    end
    local content = ""
    local grade = 1
    local score = 0
    local realHasTeam = self.mail.has_team == 1 and self.mail.team_member
    local config = GameConfig.ServantRaidStat.MailScore.HasTeam[realHasTeam and 1 or 0]
    indent = indent <= #config.content and indent or 1
    content = content .. (realHasTeam and string.format(config.content[indent], self.mail.team_member) or config.content[indent])
    score = score + config.score
    config = GameConfig.ServantRaidStat.MailScore.EnterRaid[self.mail.enter_raid]
    content = content .. config.content[indent]
    score = score + config.score
    for _, v in pairs(GameConfig.ServantRaidStat.MailScore.BattleTime) do
      if (not v.min or self.mail.battle_time >= v.min) and (not v.max or self.mail.battle_time <= v.max) then
        content = content .. v.content[indent]
        score = score + v.score
        break
      end
    end
    for k, v in pairs(GameConfig.ServantRaidStat.MailScore.Grade) do
      if (not v.min or score >= v.min) and (not v.max or score <= v.max) then
        content = content .. v.content[indent]
        grade = k
        break
      end
    end
    return content, grade
  end
end

function ServantRaidStatProxy:GetMailColor()
  return 1
end

function ServantRaidStatProxy:CreateItemCardCellDataFromStaticId(id)
  if Table_Card and Table_Card[id] then
    local cardData = {}
    cardData.staticData = Table_Item[id]
    cardData.cardInfo = Table_Card[id]
    cardData.num = 1
    return cardData
  end
end

function ServantRaidStatProxy:SetMailReaded()
  if self.mail then
    self.mail.new = false
  end
  self:UpdateWholeRedTip()
end

function ServantRaidStatProxy:IsNewMail()
  return self.mail and self.mail.new or false
end

function ServantRaidStatProxy:GetMail()
  return self.mail
end

function ServantRaidStatProxy:HasAvailRaidReward()
  return self.hasAvailRaidReward or false
end

ServantRaidStatProxy.WholeRedTipID = 10405

function ServantRaidStatProxy:UpdateWholeRedTip()
  if self:IsNewMail() or self:HasAvailRaidReward() then
    RedTipProxy.Instance:UpdateRedTip(self.WholeRedTipID)
  else
    RedTipProxy.Instance:RemoveWholeTip(self.WholeRedTipID)
  end
end
