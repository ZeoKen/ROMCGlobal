SetViewSubPage = class("SetViewSubPage", SubView)

function SetViewSubPage:Init(initParama)
  self:ReLoadPerferb(initParama)
  self.trans:SetParent(self.container.subPageScrollView.transform, false)
end

function SetViewSubPage:SetTab(tabLabelText, tabIconName)
  self.tabGO = self:CreateTabGO()
  self.tabLabelText = tabLabelText
  self.tabBgSp = self:FindComponent("Background", UISprite, self.tabGO)
  local longPress = self.tabGO:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(TipLongPressEvent.SetView, state)
  end
  
  self:AddEventListener(TipLongPressEvent.SetView, self.HandleLongPress, self)
  self.tabIconSp = self:FindComponent("Icon", UISprite, self.tabGO)
  local label = self:FindComponent("Label", UILabel, self.tabGO)
  TabNameTip.SwitchShowTabIconOrLabel(self.tabIconSp.gameObject, label.gameObject)
  if self.tabIconSp.gameObject.activeInHierarchy then
    IconManager:SetUIIcon(tabIconName, self.tabIconSp)
  end
  if label.gameObject.activeInHierarchy then
    label.text = tabLabelText
  end
end

function SetViewSubPage:SetPageActive(isActive)
  isActive = isActive and true or false
  self.tabGO:SetActive(isActive)
  self.gameObject:SetActive(isActive)
end

function SetViewSubPage:GetPageActive()
  return self.tabGO.activeSelf and self.gameObject.activeSelf
end

function SetViewSubPage:HandleLongPress(isPressing)
  TabNameTip.OnLongPress(isPressing, self.tabLabelText, false, self.tabBgSp)
end

function SetViewSubPage:OnEnter()
  SetViewSubPage.super.OnEnter(self)
  local pageConfig = GameConfig.SetViewPages[self.__cname]
  pageConfig = pageConfig or GameConfig.SetViewPages and GameConfig.SetViewPages[self.__cname]
  local go
  if pageConfig and type(pageConfig) == "table" and next(pageConfig) then
    for goName, goConfig in pairs(pageConfig) do
      go = self:FindGO(goName)
      go:SetActive(goConfig and true or false)
    end
  end
end

function SetViewSubPage:Save()
end

function SetViewSubPage:SwitchOn()
  if self.tabIconSp.gameObject.activeInHierarchy then
    self.tabIconSp.color = ColorUtil.TabColor_DeepBlue
  end
end

function SetViewSubPage:SwitchOff()
  if self.tabIconSp.gameObject.activeInHierarchy then
    self.tabIconSp.color = ColorUtil.TabColor_White
  end
end

function SetViewSubPage:CreateTabGO(name)
  return SetViewSubPage.CreateObj(SetView.SetToggleCellResId, self.container.togglesParent, name)
end

function SetViewSubPage.CreateObj(path, parent, name)
  if Game.GameObjectUtil:ObjectIsNULL(parent) then
    return
  end
  local obj = Game.AssetManager_UI:CreateAsset(path, parent)
  if not obj then
    return
  end
  obj:SetActive(true)
  Game.GameObjectUtil:ChangeLayersRecursively(obj, parent.layer)
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  obj.transform.localRotation = LuaGeometry.GetTempQuaternion()
  if name then
    obj.name = name
  end
  return obj
end
