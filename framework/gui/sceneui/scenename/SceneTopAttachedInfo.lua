local BaseCell = autoImport("BaseCell")
SceneTopAttachedInfo = reusableClass("SceneTopAttachedInfo", BaseCell)
SceneTopAttachedInfo.resId = ResourcePathHelper.UIPrefab_Cell("SceneTopAttachedInfo")
SceneTopAttachedInfo.PoolSize = 30

function SceneTopAttachedInfo:Construct(asArray, args)
  self:DoConstruct(asArray, args)
end

function SceneTopAttachedInfo:Deconstruct(asArray)
  self.gameObject = nil
  self.m_uiImgProgress = nil
  self.m_uiImgArrow = nil
end

function SceneTopAttachedInfo:DoConstruct(asArray, args)
  self._alive = true
  self.m_disable = false
end

function SceneTopAttachedInfo:Alive()
  return self._alive
end

function SceneTopAttachedInfo:update()
  if SgAIManager.Me():IsHiding() and self.m_disable == false then
    self:disable()
    return
  end
  if not SgAIManager.Me():IsHiding() and self.m_disable == true then
    self:enable()
    return
  end
  local pos = Game.Myself:GetPosition()
  local dis = LuaVector3.Distance(self.m_lastPos, pos)
  dis = math.abs(dis)
  if 0 < dis then
    self.m_totalDis = self.m_totalDis + math.abs(dis)
    self.m_lastPos[1] = pos[1]
    self.m_lastPos[2] = pos[2]
    self.m_lastPos[3] = pos[3]
    local value = (self.m_maxDistance - self.m_totalDis) / self.m_maxDistance
    local angle = (168 * value - 84) * -1
    if angle < -84 then
      angle = -84
    elseif 84 < angle then
      angle = 84
    end
    self.m_uiImgArrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, angle)
    self.m_uiImgProgress.fillAmount = value
    if value < 0.2 and not self.m_isShowEffect and not self.m_disable then
      self.m_isShowEffect = true
    end
    if self.m_totalDis >= self.m_maxDistance then
      SgAIManager.Me():CancelAttachNPC()
      self:onHide()
    end
  end
end

function SceneTopAttachedInfo:onSetObj(value)
  self.gameObject = value
  self.m_uiImgProgress = self:FindGO("uiImgBg/uiImgProgress"):GetComponent(Image)
  self.m_uiImgArrow = self:FindGO("uiImgBg/uiImgArrow")
end

function SceneTopAttachedInfo:onShow()
  if self.m_tickTime then
    TimeTickManager.Me():ClearTick(self, 99999)
    self.m_tickTime = nil
  end
  local anchor = Game.Myself.assetRole:GetEP(RoleDefines_EP.Top)
  Game.TransformFollowManager:RegisterFollowPos(self.gameObject.transform.parent, anchor.transform, LuaVector3.New(0, 0.5, 0), function()
  end)
  local pos = Game.Myself:GetPosition()
  self.m_lastPos = LuaVector3.New(pos[1], pos[2], pos[3])
  self.m_totalDis = 0
  self.m_maxDistance = SgAIManager.Me():getMaxAttachedDistance()
  self.m_uiImgArrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, -84)
  self.m_uiImgProgress.fillAmount = 1
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  self.m_isShowEffect = false
  EventManager.Me():PassEvent(StealthGameEvent.Skill_AttachNPC, self)
  self.m_tickTime = TimeTickManager.Me():CreateTick(0, 33, self.update, self, 99999)
end

function SceneTopAttachedInfo:onHide()
  if self.m_tickTime then
    TimeTickManager.Me():ClearTick(self, 99999)
    self.m_tickTime = nil
  end
  self.m_maxDistance = 0
  Game.TransformFollowManager:UnregisterFollow(self.gameObject.transform.parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(10000, 10000, 0)
end

function SceneTopAttachedInfo:disable()
  self.m_disable = true
  self.gameObject:SetActive(false)
end

function SceneTopAttachedInfo:enable()
  self.m_disable = false
  if self.m_isShowEffect then
  end
  self.gameObject:SetActive(true)
end

function SceneTopAttachedInfo:isShow()
  return self.m_tickTime ~= nil
end
