BlueprintShareSelectPanel = class("BlueprintShareSelectPanel", ContainerView)
BlueprintShareSelectPanel.ViewType = UIViewType.PopUpLayer
autoImport("WrapCellHelper")
autoImport("PostcardTargetSelectCell")

function BlueprintShareSelectPanel:Init()
  self.blueprintData = self.viewdata and self.viewdata.viewdata
  self.tipData = {}
  self:FindObjs()
  self:AddListenEvts()
  ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
end

function BlueprintShareSelectPanel:FindObjs()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
  local friendBtn = self:FindGO("FriendBtn")
  local guildBtn = self:FindGO("GuildBtn")
  self:AddClickEvent(friendBtn, function()
    self:OnSelectTab(1)
  end)
  self:AddClickEvent(guildBtn, function()
    self:OnSelectTab(2)
  end)
  self.tabToggleList = {
    self:FindComponent("Toggle", UIToggle, friendBtn),
    self:FindComponent("Toggle", UIToggle, guildBtn)
  }
  self.tabIconSpList = {
    self:FindComponent("Icon", UISprite, friendBtn),
    self:FindComponent("Icon", UISprite, guildBtn)
  }
  self.titleLb = self:FindComponent("ListTitle", UILabel)
  self.searchInput = self:FindComponent("ContentInput", UIInput)
  self:AddClickEvent(self:FindGO("SearchBtn"), function()
    self:OnSearchBtn()
  end)
  EventDelegate.Add(self.searchInput.onSubmit, function()
    self:OnSearchBtn()
  end)
  self.scrollView = self:FindComponent("ContentScrollView", UIScrollView)
  local wrapConfig = {
    wrapObj = self:FindGO("ContentContainer"),
    pfbNum = 5,
    cellName = "PostcardTargetSelectCell",
    control = PostcardTargetSelectCell,
    dir = 1,
    disableDragIfFit = false
  }
  self.listHelper = WrapCellHelper.new(wrapConfig)
  self.listHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.listHelper:AddEventListener(FriendEvent.SelectHead, self.OnClickHeadIcon, self)
  self.listTip = self:FindGO("ListTip")
  self.loading = self:FindGO("Loading")
end

function BlueprintShareSelectPanel:AddListenEvts()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.OnFriendDataRefresh)
end

function BlueprintShareSelectPanel:OnEnter()
  self:OnSelectTab(1)
end

function BlueprintShareSelectPanel:OnSelectTab(tab)
  if self.curTab == tab then
    return
  end
  self.curTab = tab
  for i = 1, #self.tabToggleList do
    self.tabToggleList[i].value = i == tab
  end
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupColorOfCurrentTabIcon(self.tabIconSpList[tab])
  if tab == 1 then
    self.titleLb.text = ZhString.Postcard_To_Friend
    self.loading:SetActive(true)
    self.scrollView.gameObject:SetActive(false)
  else
    self.titleLb.text = ZhString.Postcard_To_GuildMember
    self.loading:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
  end
  self:RefreshList()
end

function BlueprintShareSelectPanel:OnFriendDataRefresh()
  if self.curTab == 1 then
    self.loading:SetActive(false)
    self.scrollView.gameObject:SetActive(true)
    self:RefreshList()
  end
end

function BlueprintShareSelectPanel:OnSearchBtn()
  self:RefreshList()
end

function BlueprintShareSelectPanel:RefreshList()
  local memberList
  if self.curTab == 1 then
    memberList = FriendProxy.Instance:GetFriendData()
  else
    memberList = GuildProxy.Instance.myGuildData and GuildProxy.Instance.myGuildData:GetMemberList() or {}
    local filtered = {}
    for i = 1, #memberList do
      if memberList[i].id ~= Game.Myself.data.id then
        filtered[#filtered + 1] = memberList[i]
      end
    end
    memberList = filtered
  end
  local searchFilter = self.searchInput.value
  if searchFilter and searchFilter ~= "" then
    local filtered = {}
    for i = 1, #memberList do
      if memberList[i].name and string.find(memberList[i].name, searchFilter) then
        filtered[#filtered + 1] = memberList[i]
      end
    end
    memberList = filtered
  end
  self.listHelper:ResetDatas(memberList, true)
  self.listTip:SetActive(not memberList or #memberList == 0)
end

function BlueprintShareSelectPanel:OnClickCell(cell)
  local targetGuid, targetName
  if cell.data.guildData then
    targetGuid = cell.data.id
    targetName = cell.data.name
  else
    targetGuid = cell.data.guid
    targetName = cell.data.name
  end
  self:SendBlueprintShareMsg(targetGuid, targetName)
  self:CloseSelf()
end

function BlueprintShareSelectPanel:SendBlueprintShareMsg(targetGuid, targetName)
  local data = self.blueprintData
  if not data then
    return
  end
  local url = string.format("blueprint%s%s%s%s%s%d%s%s", ChatRoomProxy.ItemCodeSymbol, tostring(data.accId), ChatRoomProxy.ItemCodeSymbol, tostring(data.charId), ChatRoomProxy.ItemCodeSymbol, data.photoId, ChatRoomProxy.ItemCodeSymbol, data.serverPath)
  local linkText = string.format(ZhString.HomeBluePrint_ShareChatText, data.userName, data.homeName)
  local shareMsg = string.format("[url=%s][u]%s[/u][/url]", url, linkText)
  ServiceChatCmdProxy.Instance:CallChatCmd(ChatChannelEnum.Private, shareMsg, targetGuid, nil, nil, nil, nil, nil, nil)
  MsgManager.ShowMsgByIDTable(43187)
end

function BlueprintShareSelectPanel:OnClickHeadIcon(cellctl)
  local playerData = PlayerTipData.new()
  if cellctl.data.guildData then
    playerData:SetByGuildMemberData(cellctl.data)
  else
    playerData:SetByFriendData(cellctl.data)
  end
  FunctionPlayerTip.Me():CloseTip()
  TableUtility.TableClear(self.tipData)
  self.tipData.playerData = playerData
  self.tipData.funckeys = {
    "SendMessage",
    "ShowDetail"
  }
  FunctionPlayerTip.Me():GetPlayerTip(cellctl.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60}, self.tipData)
end
