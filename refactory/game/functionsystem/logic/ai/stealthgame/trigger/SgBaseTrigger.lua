SgBaseTrigger = class("SgBaseTrigger", ReusableObject)
SgTriggerType = {
  eBurrow = 1,
  eMachine = 2,
  ePainting = 3,
  eResetBirth2 = 20,
  eRubble = 5,
  eStatue = 6,
  ePlot = 7,
  eBox = 8,
  eSavePoint = 9,
  ePushBox = 10,
  eHock = 11,
  eVictory = 12,
  eNpcPlayPlot = 13,
  eCostItemPlayPlot = 14,
  ePlayThePianoGame = 15,
  eDogHole = 16,
  eVisitTriggerChild = 17,
  eTrap = 18,
  ePutDownOrTakeOut = 19,
  eCheckBagItem = 21
}
SgTriggerCondition = {eEnter = 0, eClick = 1}

function SgBaseTrigger:DoConstruct(asArray)
end

function SgBaseTrigger:DoDeconstruct()
  if self.topSceneUI and self.topSceneUI.transform ~= nil then
    Game.TransformFollowManager:UnregisterFollow(self.topSceneUI.transform)
    GameObject.DestroyImmediate(self.topSceneUI)
    self.topSceneUI = nil
  end
  self.m_objTrigger = nil
  self.m_uiAnchor = nil
end

function SgBaseTrigger:initData(tc, uid, historyData)
  self.m_uid = uid
  if tc:GetNextTrigger() ~= nil then
    self.m_nextUid = tc:GetNextTrigger().UID
  end
  self.m_objId = tc.ObjID
  self.m_objType = tc.ObjType
  self.m_objTrigger = tc
  self.m_type = tc.MyType
  self.m_transform = tc.transform
  self.m_effectList = tc:GetEffectList()
  self.m_unLockItem = {}
  local tmp = tc:GetUnLockItems()
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_unLockItem, tmp[i])
    end
  end
  self.m_dropItem = {}
  tmp = tc:GetDropItems()
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_dropItem, tmp[i])
    end
  end
  self.m_memoryDialog = {}
  tmp = tc:GetMemoryDialogs()
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_memoryDialog, tmp[i])
    end
  end
  self.m_skillID = math.modf(tc.SkillID)
  self.m_plotID = tc.PlotID
  self.m_msgID = math.modf(tc.MsgID)
  self.m_triggerType = tc.TriggerType
  self.m_animationType = tc.AnimationType
  self.m_unlockKey = {}
  tmp = tc:GetUnLockKey()
  if tmp ~= nil then
    for i = 1, #tmp do
      table.insert(self.m_unlockKey, tmp[i])
    end
  end
  self.m_makeVoiceKey = tc:GetMakeVoiceKey()
  self.m_makeLightUpKey = tc:GetMakeLightUpKey()
  self.m_uiAnchor = tc.m_uiAnchor
  if nil == historyData then
    self.m_isGetReward = false
    self.m_isOff = false
  else
    self.m_isGetReward = historyData.m_isGetReward
    self.m_isOff = historyData.m_isOff
    if historyData.m_effectState then
      for _, v in ipairs(self.m_effectList) do
        v:ShowEffect()
      end
    else
      for _, v in ipairs(self.m_effectList) do
        v:HideEffect()
      end
    end
    if #historyData.m_animState / 2 == #self.m_effectList then
      for i = 1, #self.m_effectList do
        self.m_effectList[i]:Play(historyData.m_animState[i * 2 - 1], historyData.m_animState[i * 2])
      end
    end
  end
  if tc.HasClickEffect then
    local objs = Game.GameObjectManagers[Game.GameObjectType.StealthGame]
    for k, v in pairs(objs.objMap) do
      if k == self.m_objId then
        self.m_sceneObj = v
        break
      end
    end
  end
end

function SgBaseTrigger:setPlayerToBirth()
  local flag, x, y, z, dir = self.m_objTrigger:GetBirthPostion()
  if flag then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1)
    Game.Myself.logicTransform:SetTargetAngleY(dir)
  else
    redlog("该触发器没有重生点")
  end
end

function SgBaseTrigger:setPlayerToOutPosition()
  local flag, x, y, z, dir = self.m_objTrigger:GetOutPosition()
  if flag then
    Game.Myself:Server_SetPosXYZCmd(x, y, z, 1)
  else
    redlog("该触发器没有出去点")
  end
end

function SgBaseTrigger:isClickTrigger()
  return self.m_triggerType == 1
end

function SgBaseTrigger:enter()
  if self.m_triggerType == SgTriggerCondition.eEnter then
    self:onExecute()
  end
end

function SgBaseTrigger:exit()
  self:showEffect(false)
  EventManager.Me():PassEvent(StealthGameEvent.ExitTrigger, self)
  SgAIManager.Me():setCurrentTrigger(-1)
end

function SgBaseTrigger:onClick(obj)
  if self.m_sceneObj ~= nil then
    SgAIManager.Me():getInstance():OnShowClickEffect(self.m_sceneObj.gameObject, 0.2, 0.2)
  end
  if self.m_triggerType == SgTriggerCondition.eClick and self:playerInRange() then
    self:onExecute()
  else
    Game.Myself:Client_MoveTo(self:getPosition(), nil, function()
      if self.m_triggerType == SgTriggerCondition.eClick and self:playerInRange() then
        self:onExecute()
      end
    end, nil, nil, 0.5)
  end
end

function SgBaseTrigger:playerInRange()
  local pos = Game.Myself:GetPosition()
  return self.m_objTrigger:InRange(pos[1], pos[2], pos[3])
end

function SgBaseTrigger:showEffect(isIn)
  if isIn then
    for _, v in ipairs(self.m_effectList) do
      v:ShowEffect()
    end
    if self.m_animationType == 1 then
      for _, v in ipairs(self.m_effectList) do
        if not v:PlayAnimationByIndex(0) then
          redlog("触发器 -> " .. self:getUid() .. " play enter animation index = 0 失败")
        end
      end
    elseif self.m_animationType == 2 then
      for _, v in ipairs(self.m_effectList) do
        if not v:PlayAnimationByIndex(0) then
          redlog("触发器 -> " .. self:getUid() .. " play enter animation index = 0 失败")
        end
      end
    elseif self.m_animationType == 3 then
      for _, v in ipairs(self.m_effectList) do
        if not v:PlayAnimationByIndex(-1) then
          redlog("触发器 -> " .. self:getUid() .. " play enter animation index = -1 失败")
        end
      end
    elseif self.m_animationType == 4 then
      for _, v in ipairs(self.m_effectList) do
        if not v:PlayAnimationByIndex(1) then
          redlog("触发器 -> " .. self:getUid() .. " play enter animation index = 1 失败")
        end
      end
    else
      redlog("触发器 -> " .. self:getUid() .. " play enter animation 失败 未知动画类型")
    end
  elseif self.m_animationType == 2 then
    for _, v in ipairs(self.m_effectList) do
      if not v:PlayAnimationByIndex(1) then
        redlog("触发器 -> " .. self:getUid() .. " play exit animation index = 1 失败")
      end
    end
  elseif self.m_animationType == 4 then
    for _, v in ipairs(self.m_effectList) do
      if not v:PlayAnimationByIndex(0) then
        redlog("触发器 -> " .. self:getUid() .. " play exit animation index = 0 失败")
      end
    end
  end
end

function SgBaseTrigger:getReward()
  if not SgAIManager.Me():triggerIsVisited(self:getUid()) and not self.m_isGetReward then
    self.m_isGetReward = true
    for _, v in ipairs(self.m_dropItem) do
      SgAIManager.Me():playerAddItem(v, 1)
    end
  end
end

function SgBaseTrigger:getPosition()
  local x, y, z = LuaGameObject.GetPosition(self.m_transform)
  return {
    x,
    y,
    z
  }
end

function SgBaseTrigger:getPositionXYZ()
  local x, y, z = LuaGameObject.GetPosition(self.m_transform)
  return x, y, z
end

function SgBaseTrigger:getObjTrigger()
  return self.m_objTrigger
end

function SgBaseTrigger:getTransform()
  return self.m_transform
end

function SgBaseTrigger:inLightUpRange(x, y, z)
  return self.m_objTrigger:InLightUpRange(x, y, z)
end

function SgBaseTrigger:inVoiceRange(x, y, z)
  return self.m_objTrigger:InVoiceRange(x, y, z)
end

function SgBaseTrigger:getUid()
  return self.m_uid
end

function SgBaseTrigger:getType()
  return self.m_type
end

function SgBaseTrigger:getDropItem()
  return self.m_dropItem
end

function SgBaseTrigger:getUnLockItem()
  return self.m_unLockItem
end

function SgBaseTrigger:getMemoryDialog()
  return self.m_memoryDialog
end

function SgBaseTrigger:getHasSkill()
  return self.m_skillID
end

function SgBaseTrigger:getPlotID()
  return self.m_plotID
end

function SgBaseTrigger:onStopPlot()
end

function SgBaseTrigger:getData()
  local arg = {}
  arg.m_uid = self:getUid()
  arg.m_isGetReward = self.m_isGetReward
  arg.m_isOff = self.m_isOff
  arg.m_effectState = self.m_objTrigger:GetEffectState()
  arg.m_animState = {}
  local tmp = self.m_objTrigger:GetAnimationState()
  for i = 1, #tmp do
    table.insert(arg.m_animState, tmp[i])
  end
  return arg
end

local PATH_PFB = ResourcePathHelper.UIPrefab_Cell("TriggerTopUI")
local tempVector3 = LuaVector3.New(0, 0, 0)

function SgBaseTrigger:CreateSceneTopUI()
  local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.RoleTopEffect)
  if container then
    self.topSceneUI = GameObject("TriggerTop_%s" .. self.m_uid)
    local followTransform = self.topSceneUI.transform
    followTransform:SetParent(container.transform, false)
    self.topSceneUI.layer = container.layer
    local TopGO = Game.AssetManager_UI:CreateSceneUIAsset(PATH_PFB, followTransform)
    TopGO.transform:SetParent(followTransform, false)
    if self.m_uiAnchor ~= nil then
      Game.TransformFollowManager:RegisterFollowPos(self.topSceneUI.transform, self.m_uiAnchor, tempVector3, function()
      end)
    end
  else
    redlog("not roletpef")
  end
end

function SgBaseTrigger:SetTopUIActive(v)
  if not self.topSceneUI then
    self:CreateSceneTopUI()
  end
  if self.topSceneUI and self.topSceneUI.gameObject then
    self.topSceneUI:SetActive(v)
  end
end

function SgBaseTrigger:rePlayPlotOrAnimation()
end
