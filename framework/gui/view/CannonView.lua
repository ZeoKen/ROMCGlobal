CannonView = class("CannonView", ContainerView)
CannonView.ViewType = UIViewType.FocusLayer
local _FuncCannon, _EventMrg
local _Power_min = GameConfig.Cannon and GameConfig.Cannon.minPower or 30
local _Power_max = GameConfig.Cannon and GameConfig.Cannon.minPower or 80

function CannonView:Init()
  _FuncCannon = FunctionCannon.Me()
  _EventMrg = EventManager.Me()
  self:FindObj()
end

function CannonView:FindObj()
  self.btn = self:FindGO("Btn")
  self:AddClickEvent(self.btn, function(go)
    self:OnClickBtn()
  end)
end

function CannonView:OnEnter()
  self:TickBegin()
  local focusNpcID = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npc_guid or 2147483857
  self.cannonType = FunctionCannon.Type.Cannon
  _FuncCannon:LaunchCannon(focusNpcID, self.cannonType)
  _EventMrg:AddEventListener(ServiceEvent.ConnReconnect, self.CloseSelf, self)
  self.super.OnEnter(self)
end

function CannonView:OnExit()
  _EventMrg:RemoveEventListener(ServiceEvent.ConnReconnect, self.CloseSelf, self)
  _FuncCannon:ShutDown()
  self.super.OnExit(self)
  _FuncCannon:ResetSwitchDuration()
  self:TickEnd()
end

function CannonView:OnClickBtn()
  _FuncCannon:FireBegin(self.power)
  if self.cannonType == FunctionCannon.Type.Airdrop then
    self:CloseSelf()
  end
end

function CannonView:CloseSelf()
  Game.InteractNpcManager:MyselfManualClick()
  CannonView.super.CloseSelf(self)
end

function CannonView:TickBegin()
  self.factor = 0
  self.tick = TimeTickManager.Me():CreateTick(0, 10, self._TickUpdate, self)
end

function CannonView:TickEnd()
  if self.tick then
    TimeTickManager.Me():ClearTick(self)
    self.tick = nil
  end
end

function CannonView:_TickUpdate()
  self.factor = self.factor + 0.01
  if self.factor > 1 then
    self.factor = 0
  end
  self.power = _Power_min + self.factor * (_Power_max - _Power_min)
end
