autoImport("GemCell")
GemContainerView = class("GemContainerView", ContainerView)
GemContainerView.ViewType = UIViewType.NormalLayer
GemContainerView.TogglePageNameMap = {
  EmbedTab = "GemEmbedPage",
  AppraiseTab = "GemAppraisePage",
  UpgradeTab = "GemUpgradePage",
  FunctionTab = "GemFunctionPage",
  SecretLandTab = "SecretLandGemOptionalPage"
}
local _TabNamePrefix = "GemContainer_TabName_"
local _Single_Tab_Width = 160
local _GemPageUnlockConfig = {
  SecretLandGemOptionalPage = {
    MenuId = GameConfig.Gem.SecretlandGemMenuID,
    GemType = SceneItem_pb.EPACKTYPE_GEM_SECRETLAND
  },
  GemFunctionPage = {
    GemType = SceneItem_pb.EPACKTYPE_GEM_SKILL
  },
  GemUpgradePage = {
    GemType = SceneItem_pb.EPACKTYPE_GEM_ATTR
  }
}

function GemContainerView:Init()
  GemProxy.Instance:InitSkillProfessionFilter()
  self.pageContainer = self:FindGO("PageContainer")
  if not self.pageContainer then
    LogUtility.Error("Cannot find PageContainer!")
    return
  end
  self.tabLineBg = self:FindComponent("TabLineBg", UISprite)
  self.tabGrid = self:FindComponent("Tabs", UIGrid)
  self.gem_forbidden_count = 0
  self.gem_tab_count = 0
  for tabName, pageName in pairs(self.TogglePageNameMap) do
    self[tabName] = self:FindGO(tabName, self.tabGrid.gameObject)
    if self[tabName] then
      self:Hide(self[tabName])
    end
  end
  self.npc_entrance = self.viewdata.viewdata and self.viewdata.viewdata.fromNpc or false
  local togglePageNameMap = self.npc_entrance and {
    FunctionTab = "GemFunctionPage"
  } or self.TogglePageNameMap
  for toggleName, pageName in pairs(togglePageNameMap) do
    self:FindAndAddToggle(toggleName, pageName)
  end
  self.tabGrid:Reposition()
  if self.tabLineBg then
    self.tabLineBg.width = (self.gem_tab_count - self.gem_forbidden_count) * _Single_Tab_Width
  end
  self:AddEvents()
end

function GemContainerView:FindAndAddToggle(toggleName, pageName)
  local toggleGO = self:FindGO(toggleName)
  self:Show(toggleGO)
  self.gem_tab_count = self.gem_tab_count + 1
  self:SetTogName("Label1", toggleGO, toggleName)
  self:SetTogName("Label2", toggleGO, toggleName)
  self:AddClickEvent(toggleGO, function(go)
    self:SwitchToPage(self.TogglePageNameMap[go.name])
  end)
  self.toggleMap = self.toggleMap or {}
  local toggle = toggleGO:GetComponent(UIToggle)
  if toggle then
    self.toggleMap[pageName] = toggle
  end
  self:HandleGemUnlock(toggle, pageName)
  return toggle
end

function GemContainerView:SetTogName(compName, toggleGO, toggleName)
  local togName1 = self:FindComponent(compName, UILabel, toggleGO)
  if togName1 and ZhString[_TabNamePrefix .. toggleName] then
    togName1.text = ZhString[_TabNamePrefix .. toggleName]
  end
end

function GemContainerView:HandleGemUnlock(toggle, pageName)
  local unlockConfig = _GemPageUnlockConfig[pageName]
  if unlockConfig then
    local menuId = unlockConfig.MenuId
    local gemType = unlockConfig.GemType
    if not (not menuId or FunctionUnLockFunc.Me():CheckCanOpen(menuId)) or gemType and GemProxy.CheckGemForbidden(gemType) then
      toggle.gameObject:SetActive(false)
      self.gem_forbidden_count = self.gem_forbidden_count + 1
    end
  end
end

function GemContainerView:TryLoadSubview(page_name)
  if not self.viewMap or not self.viewMap[page_name] then
    autoImport(page_name)
    if page_name == "GemFunctionPage" then
      self:AddSubView(page_name, _G[page_name], self.npc_entrance)
    else
      self:AddSubView(page_name, _G[page_name])
    end
  end
end

function GemContainerView:SwitchToPage(page_name)
  local toggle = self.toggleMap[page_name]
  if toggle then
    toggle.value = true
  end
  self:TryLoadSubview(page_name)
  local isActive
  for pageName, pageClass in pairs(self.viewMap) do
    isActive = pageName == page_name
    pageClass.gameObject:SetActive(isActive)
    if isActive then
      self.activePageName = pageName
      if pageClass.OnActivate then
        pageClass:OnActivate()
      end
    end
    if not isActive and pageClass.OnDeactivate then
      pageClass:OnDeactivate()
    end
  end
end

function GemContainerView:OnEnter()
  GemContainerView.super.OnEnter(self)
  local targetPageName = self.viewdata.viewdata and self.viewdata.viewdata.page
  targetPageName = targetPageName or self:GetDefaultPageName()
  self:SwitchToPage(targetPageName)
  GemProxy.Instance:SetContainerViewOpen(true)
end

function GemContainerView:GetDefaultPageName()
  return self.TogglePageNameMap.EmbedTab
end

function GemContainerView:OnExit()
  GemProxy.Instance:SetContainerViewOpen(false)
  GemContainerView.super.OnExit(self)
end

function GemContainerView:AddEvents()
end
