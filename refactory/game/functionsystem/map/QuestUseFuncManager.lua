QuestUseFuncManager = class("QuestUseFuncManager")

function QuestUseFuncManager.Me()
  if not QuestUseFuncManager.Instance then
    QuestUseFuncManager.Instance = QuestUseFuncManager.new()
  end
  return QuestUseFuncManager.Instance
end

function QuestUseFuncManager:ctor()
  self.nextCheckRangeTime = 0
  self.questMap = {}
end

function QuestUseFuncManager:Launch()
  if self.running then
    return
  end
  self.running = true
  self:AddEventListener()
end

function QuestUseFuncManager:Shutdown()
  if not self.running then
    return
  end
  self.running = false
  self.nextCheckRangeTime = 0
  self:RemoveEventListener()
end

function QuestUseFuncManager:AddEventListener()
end

function QuestUseFuncManager:RemoveEventListener()
end

function QuestUseFuncManager:AddQuest(questData)
  if not questData then
    return
  end
  if not self.questMap[questData.id] then
    self.questMap[questData.id] = {}
  end
  local params = questData.params
  local tempData = {
    actionid = params.actionid,
    presstime = params.presstime or 1,
    se = params.se,
    effect = params.effect,
    pos = questData.pos
  }
  self.questMap[questData.id] = tempData
end

function QuestUseFuncManager:RemoveQuest(questid)
  if self.questMap[questid] then
    self:StopPlayUseEffect()
    self.questMap[questid] = nil
  end
end

function QuestUseFuncManager:PlayUseEffect(questid)
  if not self.questMap[questid] then
    return
  end
  local data = self.questMap[questid]
  xdlog("开始播放特效")
  local actionid = data.actionid or 11
  local actionData = Table_ActionAnime[actionid]
  if actionData then
    Game.Myself:Client_PlayAction(actionData.Name, nil, true)
  end
  local presstime = data.presstime
  local sceneUI = Game.Myself:GetSceneUI()
  if sceneUI then
    self.topSingUI = sceneUI.roleTopUI:createOrGetTopSingUI()
    if self.topSingUI then
      self.topSingUI.id = Game.Myself.data.id
      self.topSingUI.processTime = presstime
      self.topSingUI:SetActive(true)
      self.topSingUI:startProcess()
    end
  end
  local effectPath = data.effect
  if effectPath then
    self.effect = Asset_Effect.PlayAt(effectPath, data.pos)
  end
  local sePath = data.se or "Common/JobChange"
  if sePath then
    self.audioController = AudioUtility.PlayOneShot2D_Path(sePath, AudioSourceType.UI)
  end
  self.curProcessID = questid
end

function QuestUseFuncManager:StopPlayUseEffect()
  Game.Myself:Client_PlayAction(Game.Myself:GetIdleAction())
  self:ClearUseEffectProgress()
  if self.effect then
    self.effect:Destroy()
    self.effect = nil
  end
  if self.audioController then
    self.audioController:Stop()
    self.audioController = nil
  end
end

function QuestUseFuncManager:ClearUseEffectProgress()
  if self.topSingUI then
    self.topSingUI:stopProcess()
    self.topSingUI = nil
  end
end
