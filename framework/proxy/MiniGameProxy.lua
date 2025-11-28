MiniGameProxy = class("MiniGameProxy", pm.Proxy)
MiniGameProxy.Instance = nil
MiniGameProxy.NAME = "MiniGameProxy"
autoImport("MatchingCardData")
autoImport("MiniGameUnlockData")
autoImport("MiniGameAssistData")
autoImport("MiniGameRankData")
MiniGameCardDisplay = {
  ShowBack = 0,
  HideBack = 1,
  HideName = 2
}

function MiniGameProxy:ctor(proxyName, data)
  self.proxyName = proxyName or MiniGameProxy.NAME
  if MiniGameProxy.Instance == nil then
    MiniGameProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self.progressMap = {}
  self.unlockMap = {}
  self.oppoName = ""
  self.myChoose = 0
  self.inviterInfo = {}
end

function MiniGameProxy:GenerateCards(difficulty)
  self.cardMatchingDiff = difficulty
  if self.cardSet then
    TableUtility.TableClear(self.cardSet)
  else
    self.cardSet = {}
  end
  local config = Table_MiniGame_CardPairs[difficulty]
  if config ~= nil and config.Deck ~= nil then
    for i = 1, config.Deck do
      math.randomseed(tostring(os.time()):reverse():sub(1, 7) + i)
      self.cardSet[i] = self:GenerateCard(difficulty)
    end
  end
  return self.cardSet
end

function MiniGameProxy:GenerateCard(difficulty)
  if self.poolset1 then
    TableUtility.TableClear(self.poolset1)
  else
    self.poolset1 = {}
  end
  if self.poolset2 then
    TableUtility.TableClear(self.poolset2)
  else
    self.poolset2 = {}
  end
  local rule = Table_MiniGame_CardPairs[difficulty]
  if not rule then
    redlog("no rule", difficulty)
    return
  end
  local poolindex, set
  for i = 1, #rule.Main_Deck do
    poolindex = rule.Main_Deck[i]
    set = Table_MiniGame_CardPairs_Deck[poolindex] and Table_MiniGame_CardPairs_Deck[poolindex].Card_ID
    for j = 1, #set do
      table.insert(self.poolset1, set[j])
    end
  end
  for i = 1, #rule.Sub_Deck do
    poolindex = rule.Sub_Deck[i]
    set = Table_MiniGame_CardPairs_Deck[poolindex] and Table_MiniGame_CardPairs_Deck[poolindex].Card_ID
    for j = 1, #set do
      table.insert(self.poolset2, set[j])
    end
  end
  local n = rule.row_column[1]
  local m = rule.row_column[2]
  local totalNum = math.modf(n * m * 0.5)
  local pool1Num = math.ceil(totalNum * 0.75)
  if pool1Num > #self.poolset1 then
    pool1Num = #self.poolset1
  end
  local pool2Num = totalNum - pool1Num
  local tempindex = 0
  self:random_table(self.poolset1, pool1Num)
  self:random_table(self.poolset2, pool2Num)
  local cardSet = {}
  for i = 1, #self.poolset1 do
    cardSet[i] = MatchingCardData.new()
    cardSet[i]:SetData(i, self.poolset1[i])
  end
  for i = 1, #self.poolset2 do
    tempindex = #self.poolset1 + i
    cardSet[tempindex] = MatchingCardData.new()
    cardSet[tempindex]:SetData(tempindex, self.poolset2[i])
  end
  self:Double(cardSet, totalNum, totalNum * 2)
  self:GenerateDisplay(cardSet, totalNum, totalNum * 2, rule.Back, rule.Hide_Back)
  self:ShuffleCards(cardSet, totalNum * 2)
  return cardSet
end

function MiniGameProxy:GetCard(round)
  return self.cardSet[round]
end

function MiniGameProxy:random_table(t, num)
  self:ShuffleCards(t, #t)
  num = num or #t
  for i = #t, num + 1, -1 do
    t[i] = nil
  end
  return t
end

function MiniGameProxy:ShuffleCards(cards, num)
  for i, v in pairs(cards) do
    local r = math.random(num)
    local temp = cards[i]
    cards[i] = cards[r]
    cards[r] = temp
  end
end

function MiniGameProxy:Double(cardSet, half, totalNum)
  if not (cardSet and totalNum) or totalNum == 0 then
    return
  end
  local tempData = {}
  for i = half + 1, totalNum do
    cardSet[i] = MatchingCardData.new()
    tempData = cardSet[i - half]
    cardSet[i]:SetData(i, tempData.itemid)
  end
end

function MiniGameProxy:GenerateDisplay(cardSet, startI, endI, inforate, hidenameRate)
  if cardSet and #cardSet ~= 0 then
    for i = startI + 1, endI do
      if cardSet[i] then
        cardSet[i]:GenerateDisplay(inforate, hidenameRate)
      else
        redlog("cardSet i not exist", i)
      end
    end
  end
end

function MiniGameProxy:RecvMiniGameNtfMonsterShot(data)
  if not self.monsterShotInfo then
    self.monsterShotInfo = {}
    self.monsterShotInfo.requires = {}
  end
  self.monsterShotInfo.result = nil
  self.monsterShotInfo.gameResult = nil
  self.monsterShotInfo.countdown = data.countdown
  self.monsterShotInfo.misstimerest = data.misstimerest
  self.monsterShotInfo.totalrounds = data.totalrounds
  self.monsterShotInfo.curround = data.curround
  if data.requires then
    TableUtility.ArrayClear(self.monsterShotInfo.requires)
    local sr
    for i = 1, #data.requires do
      sr = data.requires[i]
      if sr.plusright and sr.plusright > 0 then
        TableUtility.ArrayPushBack(self.monsterShotInfo.requires, {
          monsterid = sr.plusleft,
          cmptype = sr.cmptype,
          value = sr.value,
          showasplus = true,
          last = i == #data.requires,
          checkOK = nil,
          realValue = nil
        })
        TableUtility.ArrayPushBack(self.monsterShotInfo.requires, {
          monsterid = sr.plusright,
          cmptype = sr.cmptype,
          value = sr.value,
          showasplus = false,
          last = i == #data.requires,
          plusright = true,
          checkOK = nil,
          realValue = nil
        })
      else
        TableUtility.ArrayPushBack(self.monsterShotInfo.requires, {
          monsterid = sr.plusleft,
          cmptype = sr.cmptype,
          value = sr.value,
          showasplus = false,
          last = i == #data.requires,
          checkOK = nil,
          realValue = nil
        })
      end
    end
  end
end

function MiniGameProxy:RecvMiniGameNtfGameOverCmd(data)
  if data and data.type == EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_PHOTO then
    self.monsterShotInfo.gameResult = data.result == EMINIGAMEOVERRESULT.EMINIGAME_OVER_WIN
  elseif data and data.type == EMINIGAMETYPE.EMINIGAMETYPE_MONSTER_ANSWER then
    local sdata = {}
    sdata.result = data.result == EMINIGAMEOVERRESULT.EMINIGAME_OVER_WIN and 1 or 2
    sdata.simply = true
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.UIVictoryView,
      viewdata = sdata
    })
    Game.DungeonManager:Shutdown()
  end
end

function MiniGameProxy:CheckMonsterShotResult(shotMonsters)
  if not self.shotMonsterResult then
    self.shotMonsterResult = {}
  end
  TableUtility.TableClear(self.shotMonsterResult)
  local mid
  for i = 1, #shotMonsters do
    if shotMonsters[i] and shotMonsters[i].data and shotMonsters[i].data.staticData then
      mid = shotMonsters[i].data.staticData.id
      if self.shotMonsterResult[mid] then
        self.shotMonsterResult[mid] = self.shotMonsterResult[mid] + 1
      else
        self.shotMonsterResult[mid] = 1
      end
    end
  end
  local lhs = 0
  local req, req2
  self.monsterShotInfo.result = true
  for i = 1, #self.monsterShotInfo.requires do
    req = self.monsterShotInfo.requires[i]
    if req.plusright == true then
    elseif req.showasplus then
      req2 = self.monsterShotInfo.requires[i + 1]
      req.realValue = self.shotMonsterResult[req.monsterid] or 0
      req2.realValue = self.shotMonsterResult[req2.monsterid] or 0
      lhs = req.realValue + req2.realValue
      req.checkOK = self:DoCmp(req.cmptype, lhs, req.value)
      req2.checkOK = req.checkOK
    else
      lhs = self.shotMonsterResult[req.monsterid] or 0
      req.realValue = lhs
      req.checkOK = self:DoCmp(req.cmptype, lhs, req.value)
    end
    self.monsterShotInfo.result = self.monsterShotInfo.result and req.checkOK
  end
  return self.monsterShotInfo.result
end

function MiniGameProxy:DoCmp(cmptype, lhs, value)
  if cmptype == EMONSTERSHOTCOMPARE.EMONSTERSHOT_COMPARE_EQ then
    return lhs == value
  elseif cmptype == EMONSTERSHOTCOMPARE.EMONSTERSHOT_COMPARE_LT then
    return lhs < value
  elseif cmptype == EMONSTERSHOTCOMPARE.EMONSTERSHOT_COMPARE_GT then
    return value < lhs
  end
  return false
end

function MiniGameProxy:ResetMonsterShotInfo()
  if self.monsterShotInfo then
    TableUtility.ArrayClear(self.monsterShotInfo)
  end
end

function MiniGameProxy:IsMonsterShotRound()
  return self.monsterShotInfo and self.monsterShotInfo.result == nil
end

function MiniGameProxy:SetMonsterShotGameMode(mode)
  if not self.monsterShotInfo then
    self.monsterShotInfo = {}
    self.monsterShotInfo.requires = {}
  end
  self.monsterShotInfo.mode = mode
end

local entry

function MiniGameProxy:RecvMiniGameUnlockList(data)
  TableUtility.TableClear(self.progressMap)
  if data and data.list then
    for i = 1, #data.list do
      entry = data.list[i]
      self.progressMap[entry.type] = entry.difficulty
      local single = MiniGameUnlockData.new(entry)
      self.unlockMap[entry.type] = single
    end
  end
end

function MiniGameProxy:GetMiniGameUnlockList()
  return self.progressMap
end

function MiniGameProxy:CheckRewardGet(mtype, id)
  if self.unlockMap[mtype] then
    return id <= self.unlockMap[mtype].lastreward
  end
  return false
end

function MiniGameProxy:GetDailyRest(mtype)
  if self.unlockMap[mtype] then
    return self.unlockMap[mtype].dailyrest
  end
  return 0
end

function MiniGameProxy:GetChallengeRecord(gametype)
  return self.unlockMap[gametype]:GetChallengeRecord()
end

function MiniGameProxy:IsCleared(mtype)
  if self.unlockMap[mtype] then
    return self.unlockMap[mtype].passall
  end
  return false
end

function MiniGameProxy:RecvMiniGameNextRound(data)
  if data then
    if not self.itemMap then
      self.itemMap = {}
    else
      TableUtility.TableClear(self.itemMap)
    end
    local gametype = data.gametype
    local itemtype = 0
    if not self.itemMap[data.gametype] then
      self.itemMap[gametype] = {}
    else
      TableUtility.TableClear(self.itemMap[gametype])
    end
    if data.assistlist then
      for i = 1, #data.assistlist do
        itemtype = data.assistlist[i].type
        if not self.itemMap[data.gametype][itemtype] then
          self.itemMap[gametype][itemtype] = {}
        end
        local item = MiniGameAssistData.new(data.assistlist[i])
        TableUtility.ArrayPushBack(self.itemMap[gametype][itemtype], item)
      end
    end
  end
end

function MiniGameProxy:GetItemList(gametype, itemtype)
  if self.itemMap and self.itemMap[gametype] and self.itemMap[gametype][itemtype] then
    return self.itemMap[gametype][itemtype]
  else
    return _EmptyTable
  end
end

function MiniGameProxy:RecvCurrentGame(gametype, difficulty)
  self.currentGametype = gametype
  self.currentDifficulty = difficulty
end

function MiniGameProxy:GetCurrentGameDifficulty()
  return self.currentDifficulty
end

function MiniGameProxy:RecvMiniGameQueryRank(data)
  if not self.rankMap then
    self.rankMap = {}
  else
    TableUtility.TableClear(self.rankMap)
  end
  if not self.myRankMap then
    self.myRankMap = {}
  else
    TableUtility.TableClear(self.myRankMap)
  end
  if not data.type then
    return
  end
  if data.type then
    if not self.rankMap[data.type] then
      self.rankMap[data.type] = {}
    else
      TableUtility.ArrayClear(self.rankMap[data.type])
    end
    for i = 1, #data.ranks do
      local entry = MiniGameRankData.new(data.ranks[i], i)
      TableUtility.ArrayPushBack(self.rankMap[data.type], entry)
      if data.ranks[i].myself then
        self.myRankMap[data.type] = entry
      end
    end
  end
end

function MiniGameProxy:GetMiniGameRank(gametype)
  if self.rankMap and gametype then
    return self.rankMap[gametype]
  end
end

function MiniGameProxy:GetMyRank(gametype)
  if self.myRankMap and gametype then
    return self.myRankMap[gametype]
  end
end

function MiniGameProxy:SetOppoInfo(id, name)
  self.oppoID = id
  self.oppoName = name
end

function MiniGameProxy:GetOppoInfo()
  return self.oppoID, self.oppoName
end

function MiniGameProxy:SetMyChoose(enum)
  self.myChoose = enum
end

function MiniGameProxy:SetInviter(id)
  TableUtility.TableClear(self.inviterInfo)
  self.inviterInfo[id] = ServerTime.CurServerTime() / 1000 + 60
end

function MiniGameProxy:GetInviter()
  for id, endTime in pairs(self.inviterInfo) do
    if endTime and endTime > ServerTime.CurServerTime() / 1000 then
      return id
    end
  end
end

function MiniGameProxy:GetInviteEndStamp()
  for id, time in pairs(self.inviterInfo) do
    return time
  end
end

function MiniGameProxy:SetTargetPlayerData(creature)
  local playerData = PlayerTipData.new()
  playerData:SetByCreature(creature)
  self.targetPData = playerData
end

function MiniGameProxy:GetTargetPlayerData()
  return self.targetPData
end

function MiniGameProxy:RecvInviterResultLoveConfessionMessCCmd(data)
  local success = data.success
  xdlog("是否邀请成功", success)
  if success then
    local targetPData = self:GetTargetPlayerData()
    if not targetPData then
      return
    end
    local tempArray = ReusableTable.CreateArray()
    tempArray[1] = targetPData.id
    ServiceSessionSocialityProxy.Instance:CallAddRelation(tempArray, SocialManager.PbRelation.Chat)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ChatRoomPage,
      viewdata = {
        key = "PrivateChat"
      }
    })
    GameFacade.Instance:sendNotification(ChatRoomEvent.UpdateSelectChat, targetPData)
    local inviterName = Game.Myself.data:GetName()
    self:SetOppoInfo(targetPData.id, targetPData.name)
    local inviteMsg = GameConfig.LoveChallenge and GameConfig.LoveChallenge.InviteMsg
    if not inviteMsg then
      return
    end
    local formatStr = inviteMsg[math.random(#inviteMsg)]
    local str = ""
    if string.find(formatStr, "%%s") then
      str = string.format(inviteMsg[math.random(#inviteMsg)], inviterName)
    else
      str = formatStr
    end
    local data = {
      type = "lovechallenge",
      str = str,
      loveconfession = 1,
      id = targetPData.id
    }
    GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendPrivateEvent, data)
  else
    self.targetPData = nil
  end
end

function MiniGameProxy:RecvInviterReceiveConfessionMessCCmd(data)
  local accept = data.accept or false
  xdlog("邀请者接受处理结果", accept)
  if not accept then
    MiniGameProxy.Instance:SetOppoInfo()
  else
    local inviter = data and data.inviter
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LoveChallengeView,
      viewdata = {page = 2, inviterID = inviter}
    })
  end
end

function MiniGameProxy:RecvFingerLoseLoveConfessionMessCCmd(data)
  TableUtility.TableClear(self.inviterInfo)
  local resultInviter = data and data.inviter
  local oppoID, oppoName = self:GetOppoInfo()
  local str = ""
  local myFinger = 0
  local winner = data and data.winner
  local winnerfinger = data and data.winnerfinger
  local loserfinger = data and data.loserfinger
  if winner and winner == Game.Myself.data.id then
    myFinger = winnerfinger
  else
    myFinger = loserfinger
  end
  if myFinger == 1 then
    str = ZhString.LoveChallenge_Rock
  elseif myFinger == 2 then
    str = ZhString.LoveChallenge_Scissors
  elseif myFinger == 3 then
    str = ZhString.LoveChallenge_Paper
  end
  ServiceChatCmdProxy.Instance:CallChatCmd(ChatChannelEnum.Private, str, oppoID, nil, nil, nil, nil, nil, nil)
end
