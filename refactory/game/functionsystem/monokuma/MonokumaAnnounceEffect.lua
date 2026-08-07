autoImport("NSceneSpeakCell")
MonokumaAnnounceEffect = class("MonokumaAnnounceEffect")
local kSpeakCellOffsetY = 0
local cellArgs = {}
local _emptyLostCallback = function()
end
local kBubbleWorldYOffset = 1.7
local _followOffset = LuaVector3.New(0, kBubbleWorldYOffset, 0)

function MonokumaAnnounceEffect:ctor()
  self.effect = nil
  self.follow = nil
  self.speakCell = nil
  self.expireTime = nil
  self.destroyed = false
end

function MonokumaAnnounceEffect:Init(caster, skillName, effectPath, pos, heightOffset, liveTime)
  self.expireTime = UnityTime + liveTime
  self.liveTime = liveTime
  self.effect = Asset_Effect.PlayAtXYZ(effectPath, pos.x, pos.y + heightOffset, pos.z, function(obj, callbackArg, effect)
    self:_OnEffectReady(caster, skillName, effect)
  end)
end

function MonokumaAnnounceEffect:_OnEffectReady(caster, skillName, effect)
  if self.destroyed then
    return
  end
  effect = effect or self.effect
  if effect == nil then
    return
  end
  self.effect = effect
  local effectGO = effect.effectObj
  if effectGO == nil or LuaGameObject.ObjectIsNull(effectGO) then
    return
  end
  local container = SceneUIManager.Instance:GetSceneUIContainer(SceneUIType.SpeakWord)
  if container == nil then
    return
  end
  local follow = GameObject("MonokumaSpeakFollow")
  follow.transform:SetParent(container.transform, false)
  follow.layer = container.layer
  Game.TransformFollowManager:RegisterFollowPos(follow.transform, effectGO.transform, _followOffset, _emptyLostCallback)
  self.follow = follow
  cellArgs[1] = follow
  cellArgs[2] = caster
  cellArgs[3] = true
  cellArgs[4] = false
  self.speakCell = NSceneSpeakCell.CreateAsArray(cellArgs)
  cellArgs[1] = nil
  cellArgs[2] = nil
  self.speakCell:SetData(skillName, self.liveTime * 1000)
  self.speakCell:SetOffsetY(kSpeakCellOffsetY)
end

function MonokumaAnnounceEffect:IsExpired()
  return self.expireTime ~= nil and UnityTime >= self.expireTime
end

function MonokumaAnnounceEffect:Destroy()
  if self.destroyed then
    return
  end
  self.destroyed = true
  if self.speakCell ~= nil then
    self.speakCell:Destroy()
    self.speakCell = nil
  end
  if self.follow ~= nil then
    Game.TransformFollowManager:UnregisterFollow(self.follow.transform)
    GameObject.Destroy(self.follow)
    self.follow = nil
  end
  if self.effect ~= nil then
    self.effect:Destroy()
    self.effect = nil
  end
  self.expireTime = nil
end
