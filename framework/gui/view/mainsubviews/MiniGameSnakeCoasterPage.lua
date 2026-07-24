autoImport("ShortCutCoasterSkill")
autoImport("SnakeCoasterManager")
MiniGameSnakeCoasterPage = class("MiniGameSnakeCoasterPage", ContainerView)
MiniGameSnakeCoasterPage.ViewType = UIViewType.ToolsLayer

function MiniGameSnakeCoasterPage:Init()
  self:initView()
  self:AddViewEvts()
end

function MiniGameSnakeCoasterPage:OnEnter()
  self.super.OnEnter(self)
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, false)
  self.uipanel.depth = self.uipanel.depth - 250
  self.inputEnabled = false
  self.score = 0
  self.displayScore = 0
  local coasterMove = Game.Myself and Game.Myself.snakeCoasterMove
  self:SetScore(coasterMove and coasterMove:GetScore() or 0, true)
end

function MiniGameSnakeCoasterPage:OnExit()
  TimeTickManager.Me():ClearTick(self, "scoreRoll")
  if self.coasterSkillList then
    self.coasterSkillList:RemoveAll()
  end
  self.inputEnabled = false
  UIManagerProxy.Instance:ActiveLayer(UIViewType.MainLayer, true)
  self.uipanel.depth = self.uipanel.depth + 250
  self.super.OnExit(self)
end

function MiniGameSnakeCoasterPage:initView()
  self.uipanel = self.gameObject:GetComponent(UIPanel)
  self.labelDesc = self:FindComponent("LabelDesc", UILabel)
  self.labelScore = self:FindComponent("LabelScore", UILabel)
  if self.labelScore then
    self.tweenScale = self.labelScore.gameObject:GetComponent(TweenScale)
    self.labelScore.transform.localScale = Vector3.one
  end
  local coasterSkillGrid = self:FindGO("CoasterSkillGrid")
  if coasterSkillGrid then
    local grid = coasterSkillGrid:GetComponent(UIGridActiveSelf) or coasterSkillGrid:GetComponent(UIGrid)
    if grid then
      self.coasterSkillList = UIGridListCtrl.new(grid, ShortCutCoasterSkill, "ShortCutCoasterSkill")
      self.coasterSkillList:SetAddCellHandler(self.OnAddCoasterSkillCell, self)
      self.coasterSkillList:AddEventListener(MouseEvent.MouseClick, self.OnClickCoasterSkill, self)
    end
  end
  local backBtn = self:FindGO("ButtonBack")
  if backBtn then
    self:AddClickEvent(backBtn, function()
      self:CustomExit()
    end)
  end
end

function MiniGameSnakeCoasterPage:AddViewEvts()
  self:AddListenEvt(SnakeCoasterEvent.StartCoaster, self.OnStartCoaster)
  self:AddListenEvt(SnakeCoasterEvent.EndCoaster, self.OnEndCoaster)
  self:AddListenEvt(SnakeCoasterEvent.ScoreUpdate, self.OnScoreUpdate)
  self:AddListenEvt(SnakeCoasterEvent.InnerGameStart, self.OnInnerGameStart)
  self:AddListenEvt(SnakeCoasterEvent.InnerGameFinish, self.OnInnerGameFinish)
end

function MiniGameSnakeCoasterPage:OnStartCoaster()
  self:RefreshCoasterSkills()
  self:SetInputEnabled(true)
end

function MiniGameSnakeCoasterPage:OnEndCoaster()
  self:SetInputEnabled(false)
  if self.isQuit then
    self.isQuit = false
    self:HandleQuitResult()
  end
  self:CloseSelf()
end

function MiniGameSnakeCoasterPage:HandleQuitResult()
  local data = {result = 2, simply = true}
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = data
  })
end

function MiniGameSnakeCoasterPage:OnInnerGameStart()
  self:SetInputEnabled(true)
end

function MiniGameSnakeCoasterPage:OnInnerGameFinish()
  self:SetInputEnabled(false)
end

function MiniGameSnakeCoasterPage:OnScoreUpdate(note)
  local data = note and note.body
  if data then
    self:SetScore(data.score)
  end
end

function MiniGameSnakeCoasterPage:OnAddCoasterSkillCell(cell)
  cell.container = self.coasterSkillList and self.coasterSkillList.grid
end

function MiniGameSnakeCoasterPage:OnClickCoasterSkill(cell)
  if not self.inputEnabled then
    return
  end
  local data = cell and cell.data
  if data == nil then
    return
  end
  local coasterMove = Game.Myself and Game.Myself.snakeCoasterMove
  if coasterMove ~= nil then
    coasterMove:SetCurrentActionId(data.actionType, data.actionId)
    coasterMove:PlayCoasterAction(data.actionId)
  end
end

function MiniGameSnakeCoasterPage:SetInputEnabled(enabled)
  self.inputEnabled = enabled
end

function MiniGameSnakeCoasterPage:RefreshCoasterSkills()
  if self.coasterSkillList == nil then
    return
  end
  local difficulty = SnakeCoasterManager.Me():GetCurrentDifficulty() or 1
  local skillDatas = self:_BuildSnakeCoasterSkillDatas(difficulty)
  self.coasterSkillList:ResetDatas(skillDatas)
  self.coasterSkillList:Layout()
end

function MiniGameSnakeCoasterPage:_GetSnakeCoasterConfig(difficulty)
  return SnakeCoasterManager.Me():GetRuntimeConfig(difficulty)
end

function MiniGameSnakeCoasterPage:_GetSnakeCoasterPointConfig(sexKey)
  local snakeCoaster = GameConfig.SnakeCoaster
  if snakeCoaster == nil then
    return nil
  end
  return sexKey == "Female" and snakeCoaster.FemalePoints or snakeCoaster.MalePoints
end

function MiniGameSnakeCoasterPage:_ResolveSnakeCoasterSkillData(sexKey, pointID)
  if pointID == nil then
    return nil
  end
  local pointConfig = self:_GetSnakeCoasterPointConfig(sexKey)
  return pointConfig and pointConfig[pointID] or nil
end

function MiniGameSnakeCoasterPage:_BuildSnakeCoasterSkillDatas(difficulty)
  local coasterConfig = self:_GetSnakeCoasterConfig(difficulty)
  local sexConfigKey = MyselfProxy.Instance ~= nil and MyselfProxy.Instance:GetMySex() == 2 and "Female" or "Male"
  local sourceSkillDatas = coasterConfig and coasterConfig[sexConfigKey] or {}
  local skillDatas = {}
  for i = 1, #sourceSkillDatas do
    local skillData = self:_ResolveSnakeCoasterSkillData(sexConfigKey, sourceSkillDatas[i])
    if skillData ~= nil then
      skillDatas[#skillDatas + 1] = {
        actionId = skillData.actionId,
        actionType = skillData.actionType,
        icon = skillData.icon,
        text = skillData.text,
        effectPath = skillData.effectPath
      }
    end
  end
  return skillDatas
end

function MiniGameSnakeCoasterPage:SetScore(score, immediate)
  if score == self.score and not immediate then
    return
  end
  self.score = math.max(0, math.floor(tonumber(score) or 0))
  if immediate then
    TimeTickManager.Me():ClearTick(self, "scoreRoll")
    self.displayScore = self.score
    self:RefreshScore()
  else
    if self.tweenScale then
      self.tweenScale:ResetToBeginning()
      self.tweenScale:PlayForward()
    end
    self:RollScoreTo(self.score, 0.5)
  end
end

function MiniGameSnakeCoasterPage:RefreshScore()
  if self.labelScore ~= nil then
    self.labelScore.text = tostring(self.displayScore or 0)
  end
end

function MiniGameSnakeCoasterPage:RollScoreTo(to, duration)
  to = math.max(0, math.floor(tonumber(to) or 0))
  duration = duration or 1
  local from = self.displayScore or 0
  if from == to then
    TimeTickManager.Me():ClearTick(self, "scoreRoll")
    self.displayScore = to
    self:RefreshScore()
    return
  end
  if duration <= 0 then
    TimeTickManager.Me():ClearTick(self, "scoreRoll")
    self.displayScore = to
    self:RefreshScore()
    self:OnScoreRollArrive()
    return
  end
  TimeTickManager.Me():CreateTickFromTo(0, from, to, duration * 1000, function(owner, deltaTime, curValue)
    self.displayScore = math.floor(curValue + 0.5)
    self:RefreshScore()
  end, self, "scoreRoll"):SetCompleteFunc(function(owner, id)
    self.displayScore = to
    self:RefreshScore()
    self:OnScoreRollArrive()
  end)
end

function MiniGameSnakeCoasterPage:OnScoreRollArrive()
end

function MiniGameSnakeCoasterPage:SetDesc(text)
  if self.labelDesc then
    self.labelDesc.text = text or ""
  end
end

function MiniGameSnakeCoasterPage:OnClickQuitButton()
  self:_DoQuit()
end

function MiniGameSnakeCoasterPage:CustomExit()
  MsgManager.ConfirmMsgByID(41103, function()
    self:_DoQuit()
  end)
end

function MiniGameSnakeCoasterPage:_DoQuit()
  self.isQuit = true
  SnakeCoasterManager.Me():QuitCoasterGame()
end
