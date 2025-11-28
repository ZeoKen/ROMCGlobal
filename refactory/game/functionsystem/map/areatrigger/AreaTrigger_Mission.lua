AreaTrigger_Mission = class("AreaTrigger_Mission")
AreaTrigger_Mission.UpdateInterval = 0.5
AreaTrigger_Mission.CheckType = {
  QuickUse = 1,
  CallBack = 2,
  ShowAreaEffect = 3
}

function AreaTrigger_Mission:ctor()
  self.quests = {}
  self.nextUpdateTime = 0
end

function AreaTrigger_Mission:Launch()
  if self.running then
    return
  end
  self.running = true
end

function AreaTrigger_Mission:Shutdown()
  if not self.running then
    return
  end
  self.running = false
end

local distanceFunc = VectorUtility.DistanceXZ_Square

function AreaTrigger_Mission:CheckInArea(pos, quest)
  if quest.distanceCheck then
    return quest.distanceCheck(quest, pos)
  end
  if not quest.reachDis2 then
    return distanceFunc(pos, quest.pos) <= quest.reachDis * quest.reachDis
  end
  return pos[1] >= quest.pos[1] - quest.reachDis and pos[1] <= quest.pos[1] + quest.reachDis and pos[3] >= quest.pos[3] - quest.reachDis2 and pos[3] <= quest.pos[3] + quest.reachDis2
end

function AreaTrigger_Mission:Update(time, deltaTime)
  if not self.running then
    return
  end
  if time < self.nextUpdateTime then
    return
  end
  self.nextUpdateTime = time + AreaTrigger_Mission.UpdateInterval
  local myselfPosition = Game.Myself:GetPosition()
  local currentSceneData = SceneProxy.Instance.currentScene
  for id, quest in pairs(self.quests) do
    if currentSceneData:IsSameMapOrRaid(quest.map) and self:CheckInArea(myselfPosition, quest) then
      self:EnterArea(quest, deltaTime)
    else
      self:ExitArea(quest)
    end
  end
end

function AreaTrigger_Mission:EnterArea(quest, deltaTime)
  if quest.waittime then
    if not quest._entertime then
      quest._entertime = UnityTime
    end
    if UnityTime - quest._entertime < quest.waittime then
      return
    else
      quest._entertime = nil
    end
  end
  if quest.reached == false or quest.forceReCheck == true then
    quest.reached = true
    quest.forceReCheck = false
    local imgId = ServicePlayerProxy.Instance:GetCurMapImageId()
    local inMirrorRaid = imgId ~= nil and 0 < imgId
    if quest.type == AreaTrigger_Mission.CheckType.CallBack then
      if quest.onEnter then
        if inMirrorRaid then
          if quest.imageid ~= 0 and imgId == quest.imageid then
            quest.onEnter(quest.owner, quest.questData, quest.id)
          end
        else
          quest.onEnter(quest.owner, quest.questData, quest.id)
        end
      end
    elseif quest.type == AreaTrigger_Mission.CheckType.ShowAreaEffect then
      NSceneEffectProxy.Instance:Client_AddSceneEffect(quest.id, quest.pos, EffectMap.Maps.GuideArea, false)
    else
      if quest.questData and QuestProxy.Instance.questDebug then
        QuestProxy.Instance:notifyQuestState(quest.questData.scope, quest.questData.id, quest.questData.staticData.FinishJump)
        return
      end
      if inMirrorRaid then
        if quest.imageid ~= 0 and imgId == quest.imageid then
          QuickUseProxy.Instance:AddQuestEnterAreaData(quest)
        end
      elseif quest.questData.params.bagcheck then
        local targetItemID = quest.questData.params.itemid
        local ownCount = BagProxy.Instance:GetItemNumByStaticID(targetItemID, {
          1,
          10,
          17
        })
        if 0 < ownCount then
          QuickUseProxy.Instance:AddQuestEnterAreaData(quest)
        else
          redlog("AreaTrigger未找到物品: ", targetItemID)
        end
      else
        QuickUseProxy.Instance:AddQuestEnterAreaData(quest)
      end
    end
  end
end

function AreaTrigger_Mission:ExitArea(quest)
  if quest._entertime then
    quest._entertime = nil
  end
  if quest.reached == true or quest.forceReCheck == true then
    quest.reached = false
    quest.forceReCheck = false
    if quest.type == AreaTrigger_Mission.CheckType.CallBack then
      if quest.onExit then
        quest.onExit(quest.owner, quest.questData)
      end
    elseif quest.type == AreaTrigger_Mission.CheckType.ShowAreaEffect then
      NSceneEffectProxy.Instance:Client_RemoveSceneEffect(quest.id)
    else
      QuickUseProxy.Instance:RemoveQuestData(quest)
    end
  end
end

function AreaTrigger_Mission:RemoveQuestCheck(id)
  local quest = self.quests[id]
  if quest ~= nil and (quest.type ~= AreaTrigger_Mission.CheckType.CallBack or quest.exitOnRemoveQuest) then
    self:ExitArea(quest)
  end
  if quest then
    if quest.pos ~= nil then
      LuaVector3.Destroy(quest.pos)
      quest.pos = nil
    end
    ReusableTable.DestroyAndClearTable(quest)
  end
  self.quests[id] = nil
end

function AreaTrigger_Mission:ForceReCheck(id)
  local quest = self.quests[id]
  if quest then
    quest.reached = false
  end
end

function AreaTrigger_Mission:OnPlayerMapChangeReCheck()
  for id, quest in pairs(self.quests) do
    if quest.requireMapChangeReCheck then
      quest.forceReCheck = true
    end
  end
end

function AreaTrigger_Mission:AddCheck(id, map, pos, reachDis, iconType, iconID, content, btn, questData, checkType, owner, onEnter, onExit, imageid, reachDis2, rectPos, waittime, distanceCheck, exitOnRemoveQuest)
  local quest = self.quests[id]
  if quest == nil then
    quest = ReusableTable.CreateTable()
    self.quests[id] = quest
  end
  quest.id = id
  quest.questData = questData
  quest.iconType = iconType
  quest.iconID = iconID
  quest.content = content
  quest.btn = btn
  quest.map = map
  quest.pos = pos and LuaVector3.Better_Clone(pos) or LuaVector3(0, 0, 0)
  quest.reachDis = reachDis or 9999999
  quest.reached = false
  quest.type = checkType
  quest.onEnter = onEnter
  quest.onExit = onExit
  quest.owner = owner
  quest.imageid = imageid
  quest.reachDis2 = reachDis2
  quest.waittime = waittime
  quest.requireMapChangeReCheck = nil
  quest.forceReCheck = nil
  if rectPos then
    quest.rectPos = rectPos
    
    function quest.distanceCheck(trigger, myPos)
      return LuaGeometry.IsPointInRect_XZ(myPos, trigger.rectPos[1], trigger.rectPos[2], trigger.rectPos[3], trigger.rectPos[4])
    end
  end
  if distanceCheck then
    quest.distanceCheck = distanceCheck
  end
  if quest.type == AreaTrigger_Mission.CheckType.CallBack then
    quest.exitOnRemoveQuest = exitOnRemoveQuest
  end
  return quest
end

function AreaTrigger_Mission:AddQuickUseCheck(id, map, pos, reachDis, iconType, iconID, content, btn, questData, imageid, reachDis2)
  return self:AddCheck(id, map, pos, reachDis, iconType, iconID, content, btn, questData, AreaTrigger_Mission.CheckType.QuickUse, nil, nil, nil, imageid, reachDis2)
end

function AreaTrigger_Mission:AddCallBackCheck(id, map, pos, reachDis, questData, owner, onEnter, onExit, imageid, rectPos, waittime, distanceCheck, exitOnRemoveQuest)
  return self:AddCheck(id, map, pos, reachDis, nil, nil, nil, nil, questData, AreaTrigger_Mission.CheckType.CallBack, owner, onEnter, onExit, imageid, nil, rectPos, waittime, distanceCheck, exitOnRemoveQuest)
end

function AreaTrigger_Mission:AddShowAreaEffectCheck(id, map, pos, reachDis, questData)
  self:AddCheck(id, map, pos, reachDis, nil, nil, nil, nil, questData, AreaTrigger_Mission.CheckType.ShowAreaEffect)
end
