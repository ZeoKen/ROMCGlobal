autoImport("EventDispatcher")
FunctionAutoHealing = class("FunctionCheck")

function FunctionAutoHealing.Me()
  if nil == FunctionAutoHealing.me then
    FunctionAutoHealing.me = FunctionAutoHealing.new()
  end
  return FunctionAutoHealing.me
end

function FunctionAutoHealing:ctor()
  self.timeTick = {}
  self.cdComplete = {}
  EventManager.Me():AddEventListener(MyselfEvent.MyPropChange, self.HandleMyHpSpChange, self)
end

function FunctionAutoHealing:CheckAutoHealing()
  self:HandleMyHpSpChange()
end

function FunctionAutoHealing:HandleMyHpSpChange()
  self:CheckIfUsePotion(1)
  self:CheckIfUsePotion(2)
end

function FunctionAutoHealing:CheckIfUsePotion(type)
  local myData = Game.Myself.data
  if myData then
    local props = myData.props
    local value, maxValue
    if type == 1 then
      value = myData:GetHP()
      maxValue = props:GetPropByName("MaxHp"):GetValue()
    elseif type == 2 then
      value = myData:GetMP()
      maxValue = props:GetPropByName("MaxSp"):GetValue()
    end
    if value and maxValue then
      local useLimit = AutoHealingProxy.Instance:GetPotionUseLimit(type)
      if value < useLimit * maxValue / 100 then
        self:UsePotion(type)
      end
    end
  end
end

function FunctionAutoHealing:UsePotion(type)
  local myself = Game.Myself
  local itemId, num = AutoHealingProxy.Instance:GetPotionItemIdCanUse(type)
  if itemId == -1 then
    return
  end
  if itemId == 0 then
    if num == 0 then
      local msgId
      if type == 1 then
        msgId = 41507
      elseif type == 2 then
        msgId = 41508
      end
      if msgId then
        local dontShowAgainTime = LocalSaveProxy.Instance:GetDontShowAgain(msgId)
        local curTime = ServerTime.CurServerTime()
        if not dontShowAgainTime then
          LocalSaveProxy.Instance:AddDontShowAgain(msgId, 1)
          MsgManager.ShowMsgByID(msgId)
        elseif 0 < dontShowAgainTime and dontShowAgainTime < curTime then
          LocalSaveProxy.Instance:RemoveDontShowAgain(msgId)
          LocalSaveProxy.Instance:AddDontShowAgain(msgId, 1)
          MsgManager.ShowMsgByID(msgId)
        end
      end
    end
    return
  end
  local item = BagProxy.Instance:GetItemByStaticID(itemId)
  local cdTime = item.cdTime
  if 0 < cdTime and not self.cdComplete[type] then
    if not self.timeTick[type] then
      self.timeTick[type] = TimeTickManager.Me():CreateOnceDelayTick(cdTime * 1000, function()
        self:OnPotionCdComplete(type, item)
      end, self)
    end
  else
    local isLimitUse = item:IsLimitUse()
    if isLimitUse then
      return
    end
    local mapid = SceneProxy.Instance:GetCurMapID()
    if not item:CheckMapLimit(mapid) then
      return
    end
    FunctionItemFunc.DoUseItem(item, myself)
  end
end

function FunctionAutoHealing:OnPotionCdComplete(type, item)
  self.timeTick[type] = nil
  self.cdComplete[type] = true
  self:CheckIfUsePotion(type)
  self.cdComplete[type] = nil
end
