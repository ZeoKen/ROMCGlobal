local baseView = autoImport("BaseView")
ClientGuideView = class("ClientGuideView", BaseView)
ClientGuideView.ViewType = UIViewType.GuideLayer
ClientGuideView.BrotherView = GuideMaskView
local IsNull = Slua.IsNull
local GetTargetKeyByVal = function(targetVal)
  for k, v in pairs(ClientGuide.TargetType) do
    if v == targetVal then
      return k
    end
  end
end
local tempColor = LuaColor.New(0, 0, 0, 0.00392156862745098)

function ClientGuideView:Init()
  self.effectMap = {}
  self.assetEffectMap = {}
  self.eContinerMap = {}
  self:InitView()
  self:InitEvent()
end

function ClientGuideView:InitView()
  self.mask = self:FindGO("Mask")
  self.mask_sp = self.mask:GetComponent(UISprite)
  self:AddClickEvent(self.mask, function(go)
    FunctionClientGuide.Me():ClickGuideMask()
  end)
  self.eContainers = {}
  for i = 1, 10 do
    self.eContainers[i] = self:FindGO("EffectContainer" .. i)
  end
  self.girlHintGO = self:FindGO("girlHintTextCt")
  self.girlHintText = self:FindComponent("girlHintText", UILabel, self.girlHintGO)
end

function ClientGuideView:GetEContainer()
  local go = table.remove(self.eContainers, 1)
  if go then
    go:SetActive(true)
  end
  return go
end

function ClientGuideView:ReturnEContainer(eContainer)
  if eContainer then
    eContainer:SetActive(false)
  end
  table.insert(self.eContainers, eContainer)
end

function ClientGuideView:InitEvent()
  self:AddDispatcherEvt(GuideEvent.TargetRegisted, self.HandleTargetRegisted)
  self:AddDispatcherEvt(GuideEvent.UnTargetRegisted, self.HandleTargetUnRegisted)
end

function ClientGuideView:HandleTargetRegisted(note)
  local targetType = GetTargetKeyByVal(note)
  if targetType and self.effectMap[targetType] then
    self:PlayGuideEffect(unpack(self.effectMap[targetType]))
  end
end

function ClientGuideView:HandleTargetUnRegisted(note)
  local targetType = GetTargetKeyByVal(note)
  if targetType then
    self:ResetGuideEffect(targetType)
  end
end

function ClientGuideView:PlayGuideEffect(targetType, effectName, effectOffset)
  local targetGO
  if not targetType then
    targetType = "root"
    targetGO = self.gameObject
  else
    targetGO = FunctionClientGuide.Me():FindTarget(targetType)
  end
  self:ResetGuideEffect(targetType)
  self.effectMap[targetType] = {
    targetType,
    effectName,
    effectOffset
  }
  if IsNull(targetGO) then
    return
  end
  if not self.eContinerMap[targetType] then
    self.eContinerMap[targetType] = self:GetEContainer()
    LuaGameObject.SetParent(self.eContinerMap[targetType], targetGO, false)
  end
  self.assetEffectMap[targetType] = self:PlayUIEffect(effectName, self.eContinerMap[targetType], false, function(go)
    if effectOffset then
      LuaGameObject.SetLocalPositionGO(go.gameObject, unpack(effectOffset))
    end
  end)
  self.assetEffectMap[targetType]:RegisterWeakObserver(self)
end

function ClientGuideView:ObserverDestroyed(obj)
  for k, effect in pairs(self.assetEffectMap) do
    if effect == obj then
      self.assetEffectMap[k] = nil
      self:ResetGuideEffect(k)
    end
  end
end

function ClientGuideView:ResetGuideEffect(targetType)
  if self.assetEffectMap[targetType] then
    self.assetEffectMap[targetType]:Destroy()
    self.assetEffectMap[targetType] = nil
  end
  if self.eContinerMap[targetType] then
    if not IsNull(self.eContinerMap[targetType]) then
      LuaGameObject.SetParent(self.eContinerMap[targetType], self.gameObject, false)
      self:ReturnEContainer(self.eContinerMap[targetType])
    end
    self.eContinerMap[targetType] = nil
  end
end

function ClientGuideView:ClearGuideEffect()
  for k, v in pairs(self.assetEffectMap) do
    self:ResetGuideEffect(targetType)
  end
  self.effectMap = {}
end

function ClientGuideView:ExcuteGuide(data)
  if not data then
    error("引导未配置display")
    return
  end
  self.data = data
  if not data then
    return
  end
  if data.maskcolor then
    tempColor:Set(data.maskcolor[1] or 0, data.maskcolor[2] or 0, data.maskcolor[3] or 0, data.maskcolor[4] or 0)
  else
    tempColor:Set(0, 0, 0, 0.00392156862745098)
  end
  self.mask_sp.color = tempColor
  if data.uieffect then
    if data.targets then
      for i = 1, #data.targets do
        self:PlayGuideEffect(data.targets[i], data.uieffect, data.effectoffset)
      end
    else
      self:PlayGuideEffect(data.target, data.uieffect, data.effectoffset)
    end
  end
  if data.tiptext and data.tiptext ~= "" then
    self.girlHintGO:SetActive(true)
    self.girlHintText.text = data.tiptext
    if data.tipuipos then
      LuaGameObject.SetLocalPositionGO(self.girlHintGO, unpack(data.tipuipos))
    else
      local targetGO = FunctionClientGuide.Me():FindTarget(data.target)
      if not IsNull(targetGO) then
        local x, y, z = LuaGameObject.GetPositionGO(targetGO)
        LuaGameObject.SetPositionGO(self.girlHintGO, x, y, z)
      end
    end
    if data.tipuioffset then
      local x, y, z = LuaGameObject.GetLocalPositionGO(self.girlHintGO)
      x = x + data.tipuioffset[1]
      y = y + data.tipuioffset[2]
      z = z + data.tipuioffset[3]
      LuaGameObject.SetLocalPositionGO(self.girlHintGO, x, y, z)
    end
  else
    self.girlHintGO:SetActive(false)
  end
end

function ClientGuideView:UpdateMask()
  self.mask:SetActive(FunctionClientGuide.Me():DisplayMaskEnabled())
end

function ClientGuideView:OnEnter()
  ClientGuideView.super.OnEnter(self)
  self:ExcuteGuide(self.viewdata.viewdata and self.viewdata.viewdata.display)
  self:UpdateMask()
end

function ClientGuideView:OnExit()
  ClientGuideView.super.OnExit(self)
  self:ClearGuideEffect()
end
