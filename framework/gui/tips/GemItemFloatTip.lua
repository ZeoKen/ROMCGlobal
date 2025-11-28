autoImport("BaseTip")
autoImport("ItemTipGemCell")
GemItemFloatTip = class("GemItemFloatTip", BaseTip)

function GemItemFloatTip:Init()
  self:InitCell()
  self.root = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIRoot)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
end

function GemItemFloatTip:InitCell()
  self.grid = self:FindComponent("Grid", UIGrid)
  if not self.isInit then
    self.isInit = true
    local obj = self:LoadPreferb("cell/ItemTipGemCell", self.grid.gameObject)
    self.cell = ItemTipGemCell.new(obj)
    self.cell:AddEventListener(ItemTipEvent.ClickTipFuncEvent, self.OnClickTipFunc, self)
    self.cell:AddEventListener(ItemTipEvent.ConfirmMsgShowing, self.OnConfirmMsgShowing, self)
  end
end

function GemItemFloatTip:OnClickTipFunc()
  GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
  self:CloseSelf()
end

function GemItemFloatTip:OnConfirmMsgShowing(isShowing)
  self.closecomp.enabled = not isShowing
end

function GemItemFloatTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function GemItemFloatTip:SetData(data)
  self.data = data
  self:Refresh()
end

function GemItemFloatTip:Refresh()
  local data = self.data
  if not data then
    return
  end
  self.cell:SetData(data.itemdata)
  if data.noSelfClose then
    self.closecomp.enabled = false
  else
    self.closecomp.enabled = true
  end
  if data.hideItemIcon then
    self:HideItemIcon()
  end
  self.callback = data.callback
  self.callbackParam = data.callbackParam
  self.isShowFuncBtns = data.isShowFuncBtns
  self.ignoreBounds = data.ignoreBounds
  self.cell:SetShowFuncBtns(self.isShowFuncBtns)
end

function GemItemFloatTip:Reset()
  self.closecomp:ClearTarget()
  TimeTickManager.Me():ClearTick(self)
end

function GemItemFloatTip:OnEnter()
  if type(self.ignoreBounds) == "table" then
    for i = 1, #self.ignoreBounds do
      if not self:ObjIsNil(self.ignoreBounds[i]) then
        self:AddIgnoreBounds(self.ignoreBounds[i])
      end
    end
  end
  local colliders = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, BoxCollider, true)
  for i = 1, #colliders do
    colliders[i].enabled = false
  end
  TimeTickManager.Me():CreateOnceDelayTick(300, function(owner, deltaTime)
    for i = 1, #colliders do
      if not self:ObjIsNil(colliders[i]) then
        colliders[i].enabled = true
      end
    end
    if self.cell.ActiveColliderCall then
      self.cell:ActiveColliderCall()
    end
  end, self)
end

function GemItemFloatTip:SetPos(pos)
  self:Reset()
  GemItemFloatTip.super.SetPos(self, pos)
  self.grid:Reposition()
end

function GemItemFloatTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end

function GemItemFloatTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function GemItemFloatTip:RemoveIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:RemoveTarget(obj.transform)
  end
end

function GemItemFloatTip:HideItemIcon()
  if self.cell.HideItemIcon then
    self.cell:HideItemIcon()
  end
end

function GemItemFloatTip:OnExit()
  if self.cell.Exit then
    self.cell:Exit()
  end
  self:Reset()
  self.callback = nil
  self.callbackParam = nil
  self.closecomp = nil
  return true
end

function GemItemFloatTip:OnDestroy()
  GemItemFloatTip.super.OnDestroy(self)
  self.cell:OnDestroy()
  self.__destroyed = true
end
