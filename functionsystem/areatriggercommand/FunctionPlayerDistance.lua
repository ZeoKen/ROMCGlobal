FunctionPlayerDistance = class("FunctionPlayerDistance")
FunctionPlayerDistance.CreatureType = {SceneUser = 1, SceneNpc = 2}
local _Game = Game

function FunctionPlayerDistance.Me()
  if nil == FunctionPlayerDistance.me then
    FunctionPlayerDistance.me = FunctionPlayerDistance.new()
  end
  return FunctionPlayerDistance.me
end

function FunctionPlayerDistance:ctor()
  self.reason = PUIVisibleReason.OutOfMyRange
  self.flag = FunctionPlayerDistance.CreatureType.SceneUser
end

function FunctionPlayerDistance:Launch()
  if self.timeTick == nil then
    self.timeTick = TimeTickManager.Me():CreateTick(0, 500, self.SelfUpdate, self)
  end
end

function FunctionPlayerDistance:SelfUpdate(deltaTime)
  if _Game.Myself ~= nil and _Game.Myself.assetRole ~= nil and _Game.Myself.data ~= nil then
    self:Update(deltaTime)
  end
end

local SqrDistanceXZ = VectorUtility.DistanceXZ_Square

function FunctionPlayerDistance:Update(deltaTime)
  local maskRange = _Game.MapManager:GetCreatureMaskRange()
  if maskRange == 0 then
    return
  end
  local roles
  if self.flag == FunctionPlayerDistance.CreatureType.SceneUser then
    roles = NSceneUserProxy.Instance:GetAll()
    self.flag = FunctionPlayerDistance.CreatureType.SceneNpc
  elseif self.flag == FunctionPlayerDistance.CreatureType.SceneNpc then
    roles = NSceneNpcProxy.Instance:GetAll()
    self.flag = FunctionPlayerDistance.CreatureType.SceneUser
  end
  local myselfId = _Game.Myself.data.id
  local pos = _Game.Myself:GetPosition()
  local squareRange = maskRange * maskRange
  for k, v in pairs(roles) do
    if myselfId ~= k and v ~= nil then
      if squareRange < SqrDistanceXZ(pos, v:GetPosition()) then
        self:MaskUI(v)
      else
        self:UnMaskUI(v)
      end
    end
  end
end

function FunctionPlayerDistance:MaskUI(creature)
  FunctionPlayerUI.Me():MaskHurtNum(creature, self.reason, false)
  FunctionPlayerUI.Me():MaskChatSkill(creature, self.reason, false)
  FunctionPlayerUI.Me():MaskEmoji(creature, self.reason, false)
end

function FunctionPlayerDistance:UnMaskUI(creature)
  FunctionPlayerUI.Me():UnMaskHurtNum(creature, self.reason, false)
  FunctionPlayerUI.Me():UnMaskChatSkill(creature, self.reason, false)
  FunctionPlayerUI.Me():UnMaskEmoji(creature, self.reason, false)
end
