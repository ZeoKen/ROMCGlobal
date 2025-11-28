StatueNpcState = {
  InActive = 1,
  Active = 2,
  Calm = 3
}
StatueNpc = class("StatueNpc")

function StatueNpc:ctor(camp, array)
  self.monsters = array
  self.camp = camp
  self:InitUpdateFunc()
  self:Reset()
end

function StatueNpc:ResetMonster(score)
  self.score = score
  local score_index = score == 0 and 1 or score + 1
  self.monster_id = self.monsters[score_index]
  self:ReInitStatic()
  EndlessBattleDebug("[无尽战场] 设置事件得分 score|camp|monster_id", score, self.camp, self.monster_id)
end

function StatueNpc:ReInitStatic()
  if not self.monster_id then
    return
  end
  self.staticData = Table_Monster[self.monster_id]
  if not self.staticData then
    redlog("未配置monsterID ", self.monster_id)
    return
  end
  self.name = OverSea.LangManager.Instance():GetLangByKey(self.staticData.NameZh)
  self.hp = self.staticData.Hp
  self.headIcon = self.staticData.Icon
end

function StatueNpc:Reset()
  self.value = 0
  self.score = 0
  self.winner = FuBenCmd_pb.ETEAMPWS_MIN
  self.state = StatueNpcState.InActive
  self.monster_id = self.monsters[1]
  self:ReInitStatic()
end

function StatueNpc:InitUpdateFunc()
  self.stateUpdate = {}
  self.stateUpdate[StatueNpcState.InActive] = self._updatePassEventNum
  self.stateUpdate[StatueNpcState.Active] = self._updateHp
end

function StatueNpc:_updatePassEventNum(score)
  if self.score ~= score then
    self.score = score
    self:ResetMonster(score)
    EndlessBattleDebug("[无尽战场] 更新总比分", self.name, score)
  end
end

function StatueNpc:_updateHp(value)
  self.value = value
  EndlessBattleDebug("[无尽战场] 更新雕像血量", self.name, value)
end

function StatueNpc:SetState(var)
  self.state = var
end

function StatueNpc:SetWinner(w)
  self.winner = w
end

function StatueNpc:UpdateValue(arg)
  local updateCall = self.stateUpdate[self.state]
  if updateCall then
    updateCall(self, arg)
  end
end

function StatueNpc:GetValue()
  return self.value
end

function StatueNpc:GetName()
  return self.name
end

function StatueNpc:GetMonsterID()
  return self.monster_id
end

function StatueNpc:GetScore()
  return self.score
end

function StatueNpc:GetCamp()
  return self.camp
end

function StatueNpc:GetHp()
  return self.hp
end

function StatueNpc:GetHeadIcon()
  return self.headIcon or ""
end

EndlessBattleStatueData = class("EndlessBattleStatueData")

function EndlessBattleStatueData:ctor(event_id)
  self.npcMap = {}
  self.id = event_id
  self:Init()
end

function EndlessBattleStatueData:Init()
  self.staticData = Table_EndlessBattleFieldEvent[self.id]
  local monsters = self.staticData and self.staticData.Misc and self.staticData.Misc.monster_id
  if not monsters then
    redlog("未配置雕像monsteid。检查EndlessBattleFieldEvent表 id： ", self.id)
    return
  end
  for camp, monster in pairs(monsters) do
    self.npcMap[camp] = StatueNpc.new(camp, monster)
  end
end

function EndlessBattleStatueData:UpdateState(state)
  if self.state == state then
    return
  end
  self.state = state
  for _, data in pairs(self.npcMap) do
    data:SetState(state)
  end
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.StatueUpdate)
end

function EndlessBattleStatueData:UpdateValue(arg1, arg2)
  if self.state == StatueNpcState.Calm then
    return
  end
  if not arg1 or not arg2 then
    return
  end
  if nil == next(self.npcMap) then
    return
  end
  if self.arg1 == arg1 and self.arg2 == arg2 then
    return
  end
  self.arg1, self.arg2 = arg1, arg2
  self.npcMap[Camp_Human]:UpdateValue(arg1)
  self.npcMap[Camp_Vampire]:UpdateValue(arg2)
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.StatueUpdate)
end

function EndlessBattleStatueData:UpdateScore(arg1, arg2)
  if nil == next(self.npcMap) then
    return
  end
  self.npcMap[Camp_Human]:_updatePassEventNum(arg1)
  self.npcMap[Camp_Vampire]:_updatePassEventNum(arg2)
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.StatueUpdate)
end

function EndlessBattleStatueData:SetWinner(winner)
  if nil ~= self.winner and self.winner == winner then
    return
  end
  self.winner = winner
  for _, data in pairs(self.npcMap) do
    data:SetWinner(winner)
  end
  GameFacade.Instance:sendNotification(EndlessBattleFieldEvent.StatueUpdate)
end

function EndlessBattleStatueData:GetWinner()
  return self.winner
end

function EndlessBattleStatueData:Reset()
  self.winner = nil
  self.state = StatueNpcState.InActive
  self.arg1, self.arg2 = 0, 0
  for _, data in pairs(self.npcMap) do
    data:Reset()
  end
end

function EndlessBattleStatueData:GetData()
  return self.npcMap
end

function EndlessBattleStatueData:GetHP(camp)
  local statue = self.npcMap[camp]
  if statue then
    return statue:GetHp()
  end
end

function EndlessBattleStatueData:GetValue(camp)
  local statue = self.npcMap[camp]
  if statue then
    return statue:GetValue()
  end
end

function EndlessBattleStatueData:GetHeadIcon(camp)
  local statue = self.npcMap[camp]
  if statue then
    return statue:GetHeadIcon()
  end
end

function EndlessBattleStatueData:GetName(camp)
  local statue = self.npcMap[camp]
  if statue then
    return statue:GetName()
  end
end

function EndlessBattleStatueData:GetValue(camp)
  local statue = self.npcMap[camp]
  if statue then
    return statue:GetScore()
  end
end
