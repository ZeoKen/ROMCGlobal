GuildMemberListPage = class("GuildMemberListPage", SubView)
autoImport("GuildMemberCell")
autoImport("PlayerTipData")

function GuildMemberListPage:Init()
  self:InitUI()
  self:UpdateMemberList()
  self:UpdateInfo()
  self:MapListenEvt()
end

function GuildMemberListPage:InitUI()
  local memberWrap = self:FindGO("MemberWrapContent")
  local wrapConfig = {
    wrapObj = memberWrap,
    cellName = "GuildMemberCell",
    control = GuildMemberCell
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.ClickGuildMember, self)
  self.onlineNum = self:FindComponent("OnLineMemberNum", UILabel)
  self.buttonGrid = self:FindComponent("ButtonGrid", UIGrid)
  self.exitGuildButton = self:FindGO("ExitGuildButton")
  self.quitMercenaryButton = self:FindGO("QuitMercenaryButton")
  self.guildTreasureButton = self:FindGO("GuildTreasureButton")
  self.guildEditButton = self:FindGO("GuildEditButton")
  self.applyListButton = self:FindGO("ApplyListButton")
  self.eventButton = self:FindGO("EventButton")
  self:AddClickEvent(self.exitGuildButton, function(go)
    self:HideMorePanel()
    local myGuildData = GuildProxy.Instance.myGuildData
    local myMemberData = GuildProxy.Instance:GetMyGuildMemberData()
    local contribute = myMemberData.contribution
    MsgManager.DontAgainConfirmMsgByID(2802, function()
      ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd()
    end, nil, nil, myGuildData.name, contribute * 0.5)
  end)
  self.moreBtnGO = self:FindGO("MoreButton")
  self:AddClickEvent(self.moreBtnGO, function()
    self:OnMoreClicked()
  end)
  local comp = self.moreBtnGO:GetComponent(GameObjectForLua)
  comp = comp or self.moreBtnGO:AddComponent(GameObjectForLua)
  
  function comp.onDisable(go)
    self:OnMoreBtnDisabled()
  end
  
  self.morePanel = self:FindGO("MorePanel")
  self.moreGrid = self:FindComponent("MoreGrid", UIGrid, self.morePanel)
  self.moreGridBg = self:FindComponent("MoreBg", UISprite, self.morePanel)
  self:AddClickEvent(self.guildTreasureButton, function(go)
    self:HideMorePanel()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildTreasurePopUp
    })
  end)
  self:AddClickEvent(self.guildEditButton, function(go)
    self:HideMorePanel()
    FunctionSecurity.Me():GuildControl(self.DoGuildJobEdit, self)
  end)
  self:AddClickEvent(self.quitMercenaryButton, function(go)
    self:HideMorePanel()
    local myMercenaryGuildId = GuildProxy.Instance.myMercenaryGuildId
    if myMercenaryGuildId and 0 < myMercenaryGuildId then
      MsgManager.ConfirmMsgByID(31039, function()
        ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd(myMercenaryGuildId)
      end)
    end
  end)
  self:AddClickEvent(self.applyListButton, function(go)
    self:HideMorePanel()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildApplyApprove
    })
  end)
  self:AddClickEvent(self.eventButton, function(go)
    self:HideMorePanel()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildEventPopUp
    })
  end)
  self.GuildVoiceButton = self:FindGO("GuildVoiceButton")
  if self.GuildVoiceButton then
    self.GuildVoiceButton.gameObject:SetActive(ApplicationInfo.NeedOpenVoiceRealtime())
  end
  self.GuildVoiceButtonBlackBG = self:FindGO("BlackBG", self.GuildVoiceButton)
  self.GuildVoiceButtonVoiceButtonGrid = self:FindGO("VoiceButtonGrid", self.GuildVoiceButton)
  self.GuildVoiceButtonVoiceButtonGridButton1 = self:FindGO("Button1", self.GuildVoiceButtonVoiceButtonGrid)
  self.GuildVoiceButtonVoiceButtonGridButton2 = self:FindGO("Button2", self.GuildVoiceButtonVoiceButtonGrid)
  self.GuildVoiceButtonVoiceButtonGridButton3 = self:FindGO("Button3", self.GuildVoiceButtonVoiceButtonGrid)
  if self.GuildVoiceButtonVoiceButtonGridButton3 then
    self.GuildVoiceButtonBlackBG.gameObject:SetActive(false)
    self.GuildVoiceButtonVoiceButtonGrid.gameObject:SetActive(false)
    self:AddClickEvent(self.GuildVoiceButton, function(go)
      self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
    end)
    self.ShowGuildVoicePanel = self:FindGO("ShowGuildVoicePanel")
    self.ShowGuildVoicePanelView = self:FindGO("View", self.ShowGuildVoicePanel)
    self.ShowGuildVoicePanelViewCloseButton = self:FindGO("CloseButton", self.ShowGuildVoicePanelView)
    self.ShowGuildVoicePanelViewVoiceButtonGrid = self:FindGO("VoiceButtonGrid", self.ShowGuildVoicePanelView)
    self.ShowGuildVoicePanelViewVoiceButtonGridButton1 = self:FindGO("Button1", self.ShowGuildVoicePanelViewVoiceButtonGrid)
    self.ShowGuildVoicePanelViewVoiceButtonGridButton2 = self:FindGO("Button2", self.ShowGuildVoicePanelViewVoiceButtonGrid)
    self.ShowGuildVoicePanelViewVoiceButtonGridButton3 = self:FindGO("Button3", self.ShowGuildVoicePanelViewVoiceButtonGrid)
    if self.ShowGuildVoicePanel then
      self.ShowGuildVoicePanel.gameObject:SetActive(false)
      self:AddClickEvent(self.ShowGuildVoicePanelViewCloseButton, function(go)
        self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
      end)
      self:AddClickEvent(self.ShowGuildVoicePanelViewVoiceButtonGridButton1, function(go)
        if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
          self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
        end
      end)
      self:AddClickEvent(self.ShowGuildVoicePanelViewVoiceButtonGridButton2, function(go)
        if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
          self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
          self:GuildOpenVoice()
        else
        end
      end)
      self:AddClickEvent(self.ShowGuildVoicePanelViewVoiceButtonGridButton3, function(go)
        local data = Table_Help[522]
        if data ~= nil then
          self:OpenHelpView(data)
        end
        self.ShowGuildVoicePanel.gameObject:SetActive(not self.ShowGuildVoicePanel.gameObject.activeInHierarchy)
      end)
      if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
        self:SetThisButtonToBlue(self.ShowGuildVoicePanelViewVoiceButtonGridButton2)
        self:SetThisButtonToBlue(self.ShowGuildVoicePanelViewVoiceButtonGridButton1)
      else
        self:SetThisButtonToGray(self.ShowGuildVoicePanelViewVoiceButtonGridButton2)
        self:SetThisButtonToGray(self.ShowGuildVoicePanelViewVoiceButtonGridButton1)
      end
    end
  end
  self.searchInput = self:FindGO("SearchInput"):GetComponent(UIInput)
  self.searchInput.defaultText = ZhString.GuildMember_SearchName
  EventDelegate.Add(self.searchInput.onSubmit, function()
    self:OnSearchSubmit()
  end)
  self.noneTip = self:FindGO("NoneTip", self.searchInput.transform.parent.gameObject)
end

function GuildMemberListPage:OnSearchSubmit()
  self:UpdateMemberList()
  self.wraplist:ResetPosition()
end

function GuildMemberListPage:SetThisButtonToGray(go)
  local button_Sprite = go:GetComponent(UISprite)
  button_Sprite.spriteName = "com_btn_13"
end

function GuildMemberListPage:SetThisButtonToBlue(go)
  local button_Sprite = go:GetComponent(UISprite)
  button_Sprite.spriteName = "com_btn_1"
end

function GuildMemberListPage:DoGuildJobEdit()
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GuildJobEditPopUp
  })
end

function GuildMemberListPage:DoGuildApproved()
  ServiceGuildCmdProxy.Instance:CallQueryCheckInfoGuildCmd()
end

function GuildMemberListPage:ClickGuildMember(cellCtl)
  local guildData = cellCtl.data
  local myid = Game.Myself.data.id
  local bg = self:FindComponent("Bg", UISprite, cellCtl.gameObject)
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(bg, NGUIUtil.AnchorSide.Center, {-180, 45})
  local ptdata = PlayerTipData.new()
  ptdata:SetByGuildMemberData(guildData)
  local funckeys = {
    "SendMessage",
    "AddFriend",
    "InviteMember",
    "ChangeGuildJob",
    "KickGuildMember",
    "GuildMercenaryKick",
    "ShowDetail",
    "Tutor_InviteBeStudent",
    "Tutor_InviteBeTutor",
    "AddBlacklist",
    "DistributeArtifact",
    "EnterHomeRoom"
  }
  local myFunckeys = {
    "DistributeArtifact"
  }
  local tipData = {
    playerData = ptdata,
    funckeys = guildData.id ~= myid and funckeys or myFunckeys
  }
  
  function tipData.clickcallback(funcData)
    if funcData and funcData.key == "SendMessage" then
      self.container:CloseSelf()
    end
  end
  
  playerTip:SetData(tipData)
end

function GuildMemberListPage:GuildOpenVoice(cellCtl)
  if GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Voice) then
    helplog("====我有权限===" .. GVoiceProxy.Instance:GetCurGuildRealTimeVoiceCount())
    for k, v in pairs(self.wraplist:GetCellCtls()) do
      v:ShowVoiceSwitch()
    end
  else
    helplog("====我没有权限===")
  end
end

function GuildMemberListPage:UpdateInfo()
  local guildData = GuildProxy.Instance.myGuildData
  local onlineMembers = guildData:GetOnlineMembers()
  self.onlineNum.text = string.format("%s/%s", tostring(#onlineMembers), tostring(guildData.memberNum + guildData.mercenaryNum))
  local myGuildMemberInfo = GuildProxy.Instance:GetMyGuildMemberData()
  if not myGuildMemberInfo then
    errorLog("Cannot Find myGuildMemberInfo")
    return
  end
  local canLetIn = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.PermitJoin)
  self.applyListButton:SetActive(canLetIn)
  local editauth_value, editauth2_value = guildData:GetJobEditAuth(myGuildMemberInfo.job)
  self.guildEditButton:SetActive(true)
  self.guildTreasureButton:SetActive(FunctionUnLockFunc.checkFuncStateValid(4))
  self.quitMercenaryButton:SetActive(GuildProxy.Instance:DoIHaveMercenaryGuild())
  self.buttonGrid:Reposition()
  self.moreGrid:Reposition()
  local bounds = NGUIMath.CalculateRelativeWidgetBounds(self.moreGrid.transform)
  self.moreGridBg:UpdateAnchors()
  self:HideMorePanel()
end

function GuildMemberListPage:UpdateMemberList()
  local memberList = GuildProxy.Instance.myGuildData:GetMemberList()
  local searchFilter = self.searchInput.value
  if searchFilter and searchFilter ~= "" then
    local _ml = {}
    for i = 1, #memberList do
      if memberList[i].name and string.find(memberList[i].name, searchFilter) then
        _ml[#_ml + 1] = memberList[i]
      end
    end
    memberList = _ml
  end
  table.sort(memberList, function(a, b)
    local aOffline, bOffline = a:IsOffline(), b:IsOffline()
    if aOffline ~= bOffline then
      return not aOffline
    end
    if a.job ~= b.job then
      return a.job < b.job
    end
    if a.contribution ~= b.contribution then
      return a.contribution > b.contribution
    end
    return a.id < b.id
  end)
  self.wraplist:ResetDatas(memberList)
  self.noneTip:SetActive(#memberList == 0)
end

function GuildMemberListPage:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdJobUpdateGuildCmd, self.HandleMemberDataUpdate)
  self:AddListenEvt(ServiceEvent.GuildCmdArtifactUpdateNtfGuildCmd, self.UpdateMemberList)
  self:AddListenEvt(ServiceEvent.GuildCmdArtifactOptGuildCmd, self.UpdateMemberList)
  self:AddListenEvt(GuildEvent.ExitMercenary, self.HandleMemberDataUpdate)
end

function GuildMemberListPage:HandleMemberDataUpdate(note)
  if not GuildProxy.Instance.myGuildData then
    return
  end
  self:UpdateInfo()
  self:UpdateMemberList()
end

function GuildMemberListPage:HandleQueryCheckInfo(note)
end

function GuildMemberListPage:OnEnter()
  GuildMemberListPage.super.OnEnter(self)
  ArtifactProxy.Instance:SetDistributeActiveFlag(true)
end

function GuildMemberListPage:OnExit()
  GuildMemberListPage.super.OnExit(self)
  ArtifactProxy.Instance:SetDistributeActiveFlag(false)
end

function GuildMemberListPage:OnMoreClicked()
  self:ShowMorePanel()
end

function GuildMemberListPage:ShowMorePanel()
  if self.morePanel then
    self.morePanel:SetActive(true)
    self.moreGrid:Reposition()
    self.moreGridBg:UpdateAnchors()
  end
end

function GuildMemberListPage:HideMorePanel()
  if self.morePanel then
    self.morePanel:SetActive(false)
  end
end

function GuildMemberListPage:OnMoreBtnDisabled()
  self:HideMorePanel()
end
