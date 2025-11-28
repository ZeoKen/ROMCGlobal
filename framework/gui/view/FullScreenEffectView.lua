FullScreenEffectView = class("FullScreenEffectView", BaseView)
FullScreenEffectView.ViewType = UIViewType.BlindLayer

function FullScreenEffectView:Init()
  self:AddEvtListener()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.effect = viewdata.effect
  self.notAdaptFullScreen = viewdata.notAdaptFullScreen
  self.fullScreenAnim = nil
  self:FullScreenEffect(self.effect)
  self.tip = self:FindGO("Tip"):GetComponent(UILabel)
  if self.tip then
    self.tip.text = viewdata.tip or ""
  end
end

function FullScreenEffectView:AddEvtListener()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.SceneLoadHandler, self)
  self:AddListenEvt(UIEvent.RemoveFullScreenEffect, self.closeFullScreenEffectPanel, self)
end

function FullScreenEffectView:FullScreenEffect(fullPath, isloop)
  self.fullScreenEffect = self:PlayEffectByFullPath(fullPath, self.gameObject, false, function(effectGO)
    effectGO.gameObject:SetActive(false)
    effectGO.gameObject:SetActive(true)
    if self.notAdaptFullScreen then
      return
    end
    local l, t, r, b = UIManagerProxy.Instance:GetMyMobileScreenAdaptionOffsets()
    local deviceName = SystemInfo.deviceModel
    local textures = effectGO.gameObject:GetComponentsInChildren(UITexture)
    if textures and 0 < #textures then
      for i = 1, #textures do
        local childTexture = textures[i]
        if l and childTexture then
          local absoluteLR = math.max(l, r)
          childTexture:SetAnchor(self.gameObject, -absoluteLR, childTexture.bottomAnchor.absolute, absoluteLR, childTexture.topAnchor.absolute)
        elseif GameConfig.IpadAdaption and GameConfig.IpadAdaption[deviceName] then
          redlog("ipad高度特殊适配")
          childTexture.height = 960
        end
      end
    end
  end)
end

function FullScreenEffectView._HandleMidEffectShow(effectHandle, owner)
  if effectHandle and owner then
    owner:HandleMidEffectShow(effectHandle)
  end
end

function FullScreenEffectView:HandleMidEffectShow(effectHandle)
  local effectGO = effectHandle.gameObject
  local panels = UIUtil.GetAllComponentsInChildren(effectGO, UIPanel, true)
  if #panels == 0 then
    return
  end
  local upPanel = Game.GameObjectUtil:FindCompInParents(effectGO, UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  local startDepth = 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function FullScreenEffectView:closeFullScreenEffectPanel()
  self:CloseSelf()
end

function FullScreenEffectView:SceneLoadHandler(note)
  self:CloseSelf()
end

function FullScreenEffectView.getInstance()
  if FullScreenEffectView.Instance == nil then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FullScreenEffectView
    })
  end
  return FullScreenEffectView.Instance
end

function FullScreenEffectView:OnEnter()
  FullScreenEffectView.super.OnEnter(self)
end

function FullScreenEffectView:OnExit()
  FullScreenEffectView.super.OnExit(self)
end
