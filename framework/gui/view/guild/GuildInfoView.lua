GuildInfoView = class("GuildInfoView", ContainerView)
GuildInfoView.ViewType = UIViewType.NormalLayer
autoImport("GuildInfoPage")
autoImport("GuildMemberListPage")
autoImport("GuildFaithPage")
autoImport("GuildFindPage")
autoImport("GuildAssetPage")
GuildInfoView.TabName = {
  [1] = ZhString.GuildInfoView_TabName1,
  [2] = ZhString.GuildInfoView_TabName2,
  [3] = ZhString.GuildInfoView_TabName3,
  [4] = ZhString.GuildInfoView_TabName4,
  [5] = ZhString.GuildInfoView_TabName5
}

function GuildInfoView:Init()
  self:ReInit()
end

function GuildInfoView:ReInit()
  self:InitUI()
  self:SetDisableTog(false)
  self:MapListenEvt()
  if self.showTab then
    self:TabChangeHandler(self.showTab)
  elseif self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
end

function GuildInfoView:InitUI()
  local togglesParentObj = self:FindGO("Toggles")
  self.togGrid = togglesParentObj:GetComponent(UIGrid)
  self.toggleList = {}
  local longPressList = {}
  for i = 1, 5 do
    local toggleName = "Toggle" .. i
    local toggleObj = self:FindGO(toggleName, togglesParentObj)
    self.toggleList[#self.toggleList + 1] = toggleObj
    local toggleLongPress = toggleObj:GetComponent(UILongPress)
    
    function toggleLongPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.GuildInfoView, {state, i})
    end
    
    longPressList[#longPressList + 1] = toggleLongPress
  end
  self.infoTog = self:FindGO("Tog", self.toggleList[1]):GetComponent(UIToggle)
  self.memTog = self:FindGO("Tog", self.toggleList[2]):GetComponent(UIToggle)
  self.faithTog = self:FindGO("Tog", self.toggleList[3]):GetComponent(UIToggle)
  self.assetTog = self.toggleList[5]
  self:AddEventListener(TipLongPressEvent.GuildInfoView, self.HandleLongPress, self)
  local infoBord = self:FindGO("InfoBord")
  local memberBord = self:FindGO("MemberBord")
  local faithBord = self:FindGO("GAttriBord")
  local findBord = self:FindGO("FindBord")
  local assetBord = self:FindGO("AssetBord")
  local infoHelpBtn = self:FindGO("InfoHelpBtn", infoBord)
  TipsView.Me():TryShowGeneralHelpByHelpId(35233, infoHelpBtn)
  if not GameConfig.SystemForbid.TabNameTip then
    for k, v in pairs(self.toggleList) do
      local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
      icon:SetActive(true)
      local nameLabel = Game.GameObjectUtil:DeepFindChild(v, "NameLabel")
      nameLabel:SetActive(false)
    end
  else
    for k, v in pairs(self.toggleList) do
      local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
      icon:SetActive(false)
      local nameLabel = Game.GameObjectUtil:DeepFindChild(v, "NameLabel")
      nameLabel:SetActive(true)
    end
  end
  local ihaveGuild = GuildProxy.Instance:IHaveGuild()
  if ihaveGuild then
    self:AddSubView("GuildInfoPage", GuildInfoPage)
    self:AddSubView("GuildMemberListPage", GuildMemberListPage)
    ServiceGuildCmdProxy.Instance:CallBuildingNtfGuildCmd()
  else
    self.disableTabs = {1, 2}
    self:AddSubView("GuildFindPage", GuildFindPage, findBord)
    self.toggleList[4]:SetActive(true)
    self.toggleList[1]:SetActive(false)
    local hasFaith = false
    local myfaithData = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_GODDESS)
    for i = 1, #myfaithData do
      local fdata = myfaithData[i]
      if fdata.level > 0 then
        hasFaith = true
        break
      end
    end
    if not hasFaith then
      table.insert(self.disableTabs, 3)
    end
    self.showTab = 4
  end
  self:AddSubView("GuildFaithPage", GuildFaithPage)
  self:AddSubView("GuildAssetPage", GuildAssetPage)
  self:AddTabChangeEvent(self.toggleList[1], infoBord, PanelConfig.GuildInfoPage)
  self:AddTabChangeEvent(self.toggleList[2], memberBord, PanelConfig.GuildMemberListPage)
  self:AddTabChangeEvent(self.toggleList[3], faithBord, PanelConfig.GuildFaithPage)
  self:AddTabChangeEvent(self.toggleList[4], findBord, PanelConfig.GuildFindPage)
  self:AddTabChangeEvent(self.toggleList[5], assetBord, PanelConfig.GuildAssetPage)
  local applyListButton = self:FindGO("ApplyListButton")
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_APPLY, UIUtil.GetAllComponentInChildren(self.toggleList[2], UISprite), 26)
  local moreBtnGO = self:FindGO("MoreButton")
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_APPLY, UIUtil.GetAllComponentInChildren(moreBtnGO, UISprite), 26)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_GUILD_APPLY, UIUtil.GetAllComponentInChildren(applyListButton, UISprite), 26)
end

function GuildInfoView:TabChangeHandler(key)
  local ret = GuildInfoView.super.TabChangeHandler(self, key)
  if PanelConfig.GuildInfoPage.tab == key then
    FunctionGuild.Me():QueryGuildItemList()
    GvgProxy.Instance:DoQueryGvgZoneGroup()
  elseif PanelConfig.GuildAssetPage.tab == key then
  elseif PanelConfig.GuildFindPage.tab == key then
    GvgProxy.Instance:DoQueryGvgZoneGroup()
  end
  if ret and not GameConfig.SystemForbid.TabNameTip then
    local tab = self.coreTabMap[key]
    if tab then
      if self.currentKey then
        local iconSp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite)
        iconSp.color = ColorUtil.TabColor_White
      end
      self.currentKey = key
      local iconSp = Game.GameObjectUtil:DeepFindChild(tab.go, "Icon"):GetComponent(UISprite)
      iconSp.color = ColorUtil.TabColor_DeepBlue or ColorUtil.NGUIWhite
    end
  end
end

function GuildInfoView:SetDisableTog(var)
  local disableTabs = self.disableTabs
  if disableTabs then
    for i = 1, #disableTabs do
      local tab = self.coreTabMap[disableTabs[i]]
      if tab and tab.go then
        if var then
          self:SetTextureWhite(tab.go)
        else
          self:SetTextureGrey(tab.go)
        end
        tab.go:GetComponent(BoxCollider).enabled = var
      end
    end
  end
end

function GuildInfoView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.HandleEnterGuild)
  self:AddListenEvt(ServiceEvent.GuildCmdExitGuildGuildCmd, self.HandleExitGuild)
end

function GuildInfoView:HandleEnterGuild()
  if self.needConfirm then
    self.needConfirm = nil
    self:_refreshUI4ServerDate()
  else
    FunctionGuild.Me():QueryGuildItemList()
  end
end

function GuildInfoView:HandleClose()
  self:CloseSelf()
end

function GuildInfoView:HandleExitGuild()
  if self.needConfirm then
    self.needConfirm = nil
  else
    self:CloseSelf()
  end
end

function GuildInfoView:PlayLvUpEffect()
  local myGuildMemberData = GuildProxy.Instance:GetMyGuildMemberData()
  if myGuildMemberData then
    local needShowEffect = myGuildMemberData:NeedPlayLevelUpEffect()
    if needShowEffect then
      FunctionGuild.Me():PlayUpgradeEffect()
    end
  end
end

function GuildInfoView:Tog2Fix()
  local tog2 = self:FindGO("Toggle2")
  local tog = self:FindGO("Tog", tog2)
  tog:GetComponent(UIToggle):Set(true)
end

function GuildInfoView:OnEnter()
  if not GuildProxy.Instance:IHaveGuild() and not GuildProxy.Instance.beenQueryServer4Confirm then
    self.needConfirm = true
    GuildProxy.Instance.beenQueryServer4Confirm = true
    ServiceGuildCmdProxy.Instance:CallQueryGuildInfoGuildCmd()
  end
  EventManager.Me():AddEventListener(GuildChallengeEvent.CloseUI, self.HandleClose, self)
  EventManager.Me():AddEventListener("Tog2Fix", self.Tog2Fix, self)
  GuildInfoView.super.OnEnter(self)
  self:PlayLvUpEffect()
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(true)
  if GuildProxy.Instance:IsActivityAssembleNew() then
    if not GuildProxy.Instance:IHaveGuild() then
      MsgManager.ConfirmMsgByID(43125)
    end
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_GUILD_ASSEMBLY_ACTIVITY_NTF)
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_GUILD_ASSEMBLY_ACTIVITY_NTF)
    GuildProxy.Instance.isGuildAssembleNew = false
  end
end

function GuildInfoView:OnExit()
  EventManager.Me():RemoveEventListener("Tog2Fix", self.Tog2Fix, self)
  EventManager.Me():RemoveEventListener(GuildChallengeEvent.CloseUI, self.HandleClose, self)
  ServiceGuildCmdProxy.Instance:CallFrameStatusGuildCmd(false)
  GuildInfoView.super.OnExit(self)
end

function GuildInfoView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  local sp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite)
  TabNameTip.OnLongPress(isPressing, GuildInfoView.TabName[index], false, sp)
end

function GuildInfoView:_refreshUI4ServerDate()
  self.toggleList[4]:SetActive(false)
  self.toggleList[1]:SetActive(true)
  self.togGrid:Reposition()
  for k, tab in pairs(self.coreTabMap) do
    local iconSp = Game.GameObjectUtil:DeepFindChild(tab.go, "Icon"):GetComponent(UISprite)
    iconSp.color = ColorUtil.NGUIWhite
  end
  self:SetDisableTog(true)
  self.infoPage = self:AddSubView("GuildInfoPage", GuildInfoPage)
  self.infoPage:ResetGuildID()
  self:AddSubView("GuildMemberListPage", GuildMemberListPage)
  self:TabChangeHandler(self.viewdata.view.tab)
  self.memTog.activeSprite.alpha = 0
end
