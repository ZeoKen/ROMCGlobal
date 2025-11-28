LightPuzzleManager = class("LightPuzzleManager", EventDispatcher)
local lightTargetTag = "LightPuzzleTarget"
local game = Game
local lightDataMap = {}
local maxDisSquare = 1.2
local handleNodeName = "EP_1"

function LightPuzzleManager.Me()
  if not LightPuzzleManager.Instance then
    LightPuzzleManager.Instance = LightPuzzleManager.new()
  end
  return LightPuzzleManager.Instance
end

function LightPuzzleManager:ctor()
  self.manager = game.GameObjectManagers[game.GameObjectType.RaidPuzzle_Light]
  self.questMap = {}
  self.puzzleResultMap = {}
  self.effectMap = {}
  if GameConfig.LightPuzzle then
    for npcId, data in pairs(GameConfig.LightPuzzle) do
      lightDataMap[data.lightId] = data
    end
  end
end

function LightPuzzleManager:StartLightPuzzleQuest(questData)
  self.questMap[questData.id] = questData
  self.curQuestId = questData.id
end

function LightPuzzleManager:HandlePuzzleObject(npcId, param)
  if not GameConfig.LightPuzzle then
    return
  end
  local data = GameConfig.LightPuzzle[npcId]
  if not data then
    return
  end
  local lightObjects = self.manager:GetLightObjMap()
  if not lightObjects then
    return
  end
  game.PlotStoryManager:Launch()
  local comLine = lightObjects[data.lightId]
  local handleNode = comLine.transform.parent.gameObject
  self.curUpdateLight = data.lightId
  local viewdata = {}
  viewdata.npcId = npcId
  viewdata.handleNode = handleNode
  
  function viewdata.callback()
    self.curUpdateLight = nil
  end
  
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.LightPuzzleHandleView,
    viewdata = viewdata
  })
end

function LightPuzzleManager.OnRefreshLightFinish(light)
  LightPuzzleManager.Me():CheckPuzzleSolved()
end

function LightPuzzleManager:CheckLightPuzzleSolvedByNpc(npcId)
  if GameConfig.LightPuzzle and GameConfig.LightPuzzle[npcId] then
    local lightId = GameConfig.LightPuzzle[npcId].lightId
    return self.puzzleResultMap[lightId]
  end
  return false
end

function LightPuzzleManager:CheckPuzzleSolved()
  if not self.puzzleResultMap[self.curUpdateLight] then
    local hitObj = self.manager:GetLastHitGameObject(self.curUpdateLight)
    if hitObj then
      self:ShowLightSpot(hitObj)
      local lightData = lightDataMap[self.curUpdateLight]
      if lightData and lightData.targetName == hitObj.name then
        local x, y, z = self.manager:GetLastLinePosition(self.curUpdateLight)
        local tempV3 = LuaGeometry.GetTempVector3(x, y, z)
        if LuaVector3.Distance_Square(tempV3, hitObj.transform.position) <= maxDisSquare then
          self.puzzleResultMap[self.curUpdateLight] = true
          GameFacade.Instance:sendNotification(LightPuzzleEvent.PuzzleSolved)
          local pqtl_name = lightData.pqtl_name
          if pqtl_name then
            game.PlotStoryManager:Start_PQTLP(pqtl_name)
          end
        end
      end
    else
      self:HideLightSpot()
    end
    local questData = self.questMap[self.curQuestId]
    if not questData then
      return
    end
    if questData.params.npc then
      local isSolved = true
      for i = 1, #questData.params.npc do
        local npcId = questData.params.npc[i]
        if not self:CheckLightPuzzleSolvedByNpc(npcId) then
          isSolved = false
          break
        end
      end
      if isSolved then
        QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, questData.staticData.FinishJump)
        self:Clear()
      end
    end
  end
end

function LightPuzzleManager:ShowLightSpot(parent)
  local x, y, z = self.manager:GetLastLinePosition(self.curUpdateLight)
  local effect = self.effectMap[self.curUpdateLight]
  if not effect then
    local lightData = lightDataMap[self.curUpdateLight]
    if lightData then
      local effectName = lightData.lightSpotEffect
      local path = "Skill/" .. effectName
      effect = Asset_Effect.PlayAtXYZ(path, x, y, z, function(effectHandle, _, assetEffect)
        effect:ResetLocalEulerAnglesXYZ(90, 0, 0)
      end)
      self.effectMap[self.curUpdateLight] = effect
    end
  else
    effect:SetActive(true)
    effect:ResetLocalPositionXYZ(x, y, z)
  end
end

function LightPuzzleManager:HideLightSpot()
  local effect = self.effectMap[self.curUpdateLight]
  if effect then
    effect:SetActive(false)
  end
end

function LightPuzzleManager:Clear()
  TableUtility.TableClear(self.puzzleResultMap)
  TableUtility.TableClearByDeleter(self.effectMap, function(effect)
    effect:Stop()
  end)
  if self.curQuestId then
    self.questMap[self.curQuestId] = nil
    self.curQuestId = nil
  end
  self.curUpdateLight = nil
end

function LightPuzzleManager:Update(time, deltaTime)
  if not self.isRunning then
    return
  end
  if self.curUpdateLight then
    self.manager:RefreshLight(self.curUpdateLight, self.OnRefreshLightFinish)
  end
end

function LightPuzzleManager:Launch()
  if not self:IsInLightPuzzleRaid() then
    return
  end
  self.isRunning = true
  self:SetLightEnabled(true)
end

function LightPuzzleManager:Shutdown()
  if not self.isRunning then
    return
  end
  self.isRunning = false
  self:Clear()
  self:SetLightEnabled(false)
end

function LightPuzzleManager:IsInLightPuzzleRaid()
  local raidId = Game.MapManager:GetRaidID()
  if raidId == 0 then
    raidId = Game.MapManager:GetImageID()
  end
  local raidData = Table_MapRaid and Table_MapRaid[raidId]
  if not raidData then
    return false
  end
  local feature = raidData.Feature
  return feature and 0 < feature & MapManager.MapRaidFeature.IsLightPuzzle
end

function LightPuzzleManager:SetLightEnabled(enabled)
  local lightObjects = self.manager:GetLightObjMap()
  if lightObjects then
    for id, comLine in pairs(lightObjects) do
      local lineRenderer = comLine.gameObject:GetComponent(LineRenderer)
      if lineRenderer then
        lineRenderer.enabled = enabled
      end
    end
  end
end
