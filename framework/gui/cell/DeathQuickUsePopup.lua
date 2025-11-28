DeathQuickUsePopup = class("DeathQuickUsePopup", QuickUsePopupFuncCell)

function DeathQuickUsePopup:Init()
  DeathQuickUsePopup.super.Init(self)
end

function DeathQuickUsePopup:TryClose()
  DeathQuickUsePopup.super.Hide(self)
  redlog("try hide")
end

function DeathQuickUsePopup:ItemClick()
  local data = self.data
  if data then
    local itemTarget = data.staticData.ItemTarget
    local itemid = data.staticData.id
    if itemTarget and itemTarget.type then
      local realTarget = Game.Myself:GetLockTarget()
      if not realTarget then
        MsgManager.ShowMsgByIDTable(710)
        return
      end
      local creatureType = realTarget:GetCreatureType()
      if Creature_Type.Player == creatureType and not data:CanUseForTarget(ItemTarget_Type.Player) then
        MsgManager.ShowMsgByIDTable(711)
        return
      elseif Creature_Type.Npc == creatureType then
        if realTarget.data:IsNpc() and not data:CanUseForTarget(ItemTarget_Type.Npc, realTarget.data:GetStaticID()) then
          MsgManager.ShowMsgByIDTable(711)
          return
        elseif realTarget.data:IsMonster() and not data:CanUseForTarget(ItemTarget_Type.Monster) then
          MsgManager.ShowMsgByIDTable(711)
          return
        end
      end
    end
    ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_LIMIT_ITEM, itemid)
  end
  self:TryClose()
end
