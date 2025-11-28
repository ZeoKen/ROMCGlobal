MindLockerView = class("MindLockerView", ContainerView)
MindLockerView.ViewType = UIViewType.UIScreenEffectLayer
local vignetting = "vignetting"

function MindLockerView:Init()
  self.beforePanel = self:FindGO("BeforePanel")
  self.effectContainer = self:FindGO("effectContainer")
  self.uiTexture = self:FindComponent("Texture", UITexture)
  self.effectMap = {}
end

function MindLockerView:OnEnter()
  MindLockerView.super.OnEnter(self)
  PictureManager.Instance:SetMindLockerTexture(vignetting, self.uiTexture)
  self:RefitFullScreenWidgetSize(self.uiTexture)
end

function MindLockerView:OnExit()
  MindLockerView.super.OnExit(self)
  TableUtility.TableClear(self.effectMap)
  self:RemoveCustomButton()
  PictureManager.Instance:UnloadMindLockerTexture(vignetting, self.uiTexture)
end

function MindLockerView:PlayEffect(path, callBack)
  local index = self.effectMap[path]
  local effect
  if not index then
    effect = self:PlayUIEffect(path, self.effectContainer, false, self.OnEffectCreate, {self, callBack})
    self.effectMap[path] = #self.uieffects
  else
    effect = self.uieffects[index]
  end
  return effect
end

function MindLockerView.OnEffectCreate(effectHandle, param)
  local owner, callBack = param[1], param[2]
  owner:_HandleEffectCreate(effectHandle)
  if callBack then
    callBack(effectHandle)
  end
end

function MindLockerView:_HandleEffectCreate(effectHandle)
  local go = effectHandle.gameObject
  local widgets = UIUtil.GetAllComponentsInChildren(go, UIWidget)
  for i = 1, #widgets do
    widgets[i].gameObject:SetActive(false)
    widgets[i].gameObject:SetActive(true)
  end
end

function MindLockerView:DestroyEffect(path)
  local index = self.effectMap[path]
  if index then
    local effect = self.uieffects[index]
    if effect:Alive() then
      effect:Destroy()
    end
    table.remove(self.uieffects, index)
  end
end

function MindLockerView:AddCustomButton(event, pos, size)
  local go = GameObject("button")
  go.transform:SetParent(self.beforePanel.transform, false)
  if pos then
    LuaGameObject.SetLocalPositionGO(go, pos[1], pos[2], 0)
  end
  local widget = go:AddComponent(UIWidget)
  if size then
    widget.width = size[1]
    widget.height = size[2]
  end
  NGUITools.AddWidgetCollider(go)
  self:AddClickEvent(go, event)
  self.button = go
end

function MindLockerView:RemoveCustomButton()
  if self.button then
    GameObject.Destroy(self.button)
  end
end
