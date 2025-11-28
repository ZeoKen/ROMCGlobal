LogicManager_Player_Props = class("LogicManager_Player_Props", LogicManager_Creature_Props)

function LogicManager_Player_Props:ctor()
  LogicManager_Player_Props.super.ctor(self)
  self:AddUpdateCall("TransformID", self.UpdateTransformState)
end

function LogicManager_Player_Props:UpdateTransformState(ncreature, propName, oldValue, p)
  local transformID = p:GetValue()
  if transformID == 0 then
    FunctionTransform.Me():EndTransform(ncreature)
  else
    FunctionTransform.Me():TransformTo(ncreature, transformID)
  end
end

function LogicManager_Player_Props:UpdateHp(ncreature, propName, oldValue, p)
  LogicManager_Player_Props.super.UpdateHp(self, ncreature, propName, oldValue, p)
  local targetCreature = Game.Myself:GetLockTarget()
  if not targetCreature or not targetCreature.data then
    return
  end
  local tGuid = targetCreature.data.id
  if ncreature and ncreature.data and ncreature.data.id == tGuid then
    EventManager.Me():DispatchEvent(MyselfEvent.SelectTarget_HpChange, ncreature)
  end
end
