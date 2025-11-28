BaseCell = class("BaseCell", CoreView)

function BaseCell:ctor(obj)
  BaseCell.super.ctor(self, obj)
  self:Init()
end

function BaseCell:Init()
end

function BaseCell:AddCellClickEvent()
  self:SetEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function BaseCell:AddCellDoubleClickEvt()
  self:SetDoubleClick(self.gameObject, function()
    self:PassEvent(MouseEvent.DoubleClick, self)
  end)
end

function BaseCell:SetData(obj)
end

function BaseCell:SetEvent(evtObj, event, hideSound)
  self:AddClickEvent(evtObj, event, hideSound)
end

function BaseCell:SetDoubleClick(evtObj, event)
  self:AddDoubleClickEvent(evtObj, event)
end

function BaseCell:SetPress(evtObj, event)
  self:AddPressEvent(evtObj, event)
end

function BaseCell:SetActive(obj, state)
  if obj then
    obj.gameObject:SetActive(state)
    return true
  end
  return false
end

function BaseCell:FindChild(name, parent)
  parent = parent or self.gameObject
  return Game.GameObjectUtil:DeepFindChild(parent, name)
end

function BaseCell:CreateObj(path, parent)
  if not Game.GameObjectUtil:ObjectIsNULL(parent) then
    local obj = Game.AssetManager_UI:CreateAsset(path, parent)
    if not obj then
      return
    end
    obj:SetActive(true)
    Game.GameObjectUtil:ChangeLayersRecursively(obj, parent.layer)
    obj.transform.localPosition = LuaGeometry.GetTempVector3()
    obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    obj.transform.localRotation = LuaGeometry.GetTempQuaternion()
    return obj
  end
end

function BaseCell:ObjIsNil(obj)
  return Game.GameObjectUtil:ObjectIsNULL(obj)
end

function BaseCell:Notify(eventName, body, type)
  GameFacade.Instance:sendNotification(eventName, body, type)
end

function BaseCell:StartTweenLable(lable, _maxWidth, tweenPosition, from, duration, style)
  if BranchMgr.IsChina() or tweenPosition == nil then
    return
  end
  if lable == nil or _maxWidth == nil or _maxWidth >= lable.width then
    return
  end
  tweenPosition.duration = duration
  tweenPosition.style = style
  tweenPosition.from = from
  tweenPosition.to = LuaGeometry.GetTempVector3(from.x - lable.width / 2, from.y, from.z)
  tweenPosition.enabled = true
  tweenPosition:ResetToBeginning()
  tweenPosition:PlayForward()
end

function BaseCell:StopTweenLable(tweenPosition)
  if BranchMgr.IsChina() or tweenPosition == nil then
    return
  end
  if tweenPosition and tweenPosition.enabled == true then
    tweenPosition:ResetToBeginning()
    tweenPosition.enabled = false
  end
end

function BaseCell:SetAllSpriteAlpha(alpha, includeChild)
  if not alpha then
    return nil
  end
  alpha = NumberUtility.Clamp01(alpha)
  local sprites = self.gameObject:GetComponentsInChildren(UISprite, includeChild or false)
  local count, color = #sprites
  for i = 1, count do
    color = sprites[i].color
    sprites[i].color = LuaColor.New(color.r, color.g, color.b, alpha)
  end
end

function BaseCell:SetInoutAnimDelay(delay)
  if not self.inoutTween then
    return
  end
  self.inoutTween:SetOnFinished(function()
    self:OnInoutFinished()
  end)
  self.inoutTween.delay = delay or 0
end

function BaseCell:OnInoutFinished()
  self:PassEvent(UICellEvent.OnInoutAnimFinished, self)
end

function BaseCell:PlayInoutAnim(inOrOut)
  if not self.inoutTween then
    return
  end
  self.inOrOut = inOrOut
  if inOrOut == 1 then
    self.inoutTween:Play(false)
  else
    self.inoutTween:Play(true)
  end
  self.inoutTween:ResetToBeginning()
  if inOrOut == 1 then
    self.inoutTween:Play(false)
  else
    self.inoutTween:Play(true)
  end
end

function BaseCell:StopInoutAnim(jumpToFinish)
  if not self.inoutTween then
    return
  end
  if jumpToFinish and self.inoutTween.enabled then
    self.inoutTween:Toggle()
    self.inoutTween:ResetToBeginning()
  end
  self.inoutTween.enabled = false
end

return BaseCell
