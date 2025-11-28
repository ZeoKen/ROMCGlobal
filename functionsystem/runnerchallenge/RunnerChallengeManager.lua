RunnerChallengeManager = class("RunnerChallengeManager", EventDispatcher)

function RunnerChallengeManager.Me()
  if nil == RunnerChallengeManager.me then
    RunnerChallengeManager.me = RunnerChallengeManager.new()
  end
  return RunnerChallengeManager.me
end

local interverTime = 0.5
local runnerRivalNpcId = 821025
local mapConfig = GameConfig.Manor and GameConfig.Manor.RunGameRaidID or nil
local squareRange = 5

function RunnerChallengeManager:ctor()
  self:Init()
end

function RunnerChallengeManager:Init()
  self:InitNpcTargetGoal()
  self.nextRefreshTime = 0
end

function RunnerChallengeManager:Launch()
  if not mapConfig then
    return
  end
  self.raidID = Game.MapManager:GetRaidID()
  if mapConfig[self.raidID] then
    self.running = true
    runnerRivalNpcId = mapConfig[self.raidID].npcid
  end
end

function RunnerChallengeManager:Shutdown()
  if not self:IsWorking() then
    return
  end
  self.running = false
end

function RunnerChallengeManager:IsWorking()
  return self.running == true
end

function RunnerChallengeManager:CheckNpcPosition()
  local creature = NSceneNpcProxy.Instance:FindNpcs(runnerRivalNpcId)
  if creature and creature[1] then
    if not self.npcTarget then
      local questData = self:GetRaceQuest()
      if questData and questData.staticData.Params.npcpos then
        local npcPos = questData.staticData.Params.npcpos
        self.npcTarget = {
          npcPos[1],
          npcPos[2],
          npcPos[3]
        }
      end
    end
    if self.npcTarget then
      local distance = VectorUtility.DistanceXZ_Square(creature[1]:GetPosition(), self.npcTarget)
      if distance <= squareRange then
        local questData = self:GetRaceQuest()
        if questData then
          ServiceNUserProxy.Instance:CallRaceGameFinishUserCmd(false)
          QuestProxy.Instance:notifyQuestState(QuestDataScopeType.QuestDataScopeType_FUBEN, questData.id, 3)
        end
      end
    end
  end
end

function RunnerChallengeManager:GetRaceQuest()
  local questList = QuestProxy.Instance:getCurRaidQuest()
  for _, q in pairs(questList) do
    if q.questDataStepType == "race" then
      return q
    end
  end
end

function RunnerChallengeManager:InitNpcTargetGoal()
  self:GetRaceQuest()
end

function RunnerChallengeManager:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time > self.nextRefreshTime then
    self.nextRefreshTime = time + interverTime
    self:CheckNpcPosition()
  end
end
