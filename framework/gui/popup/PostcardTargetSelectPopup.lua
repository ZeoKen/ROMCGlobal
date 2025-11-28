PostcardTargetSelectPopup = class("PostcardTargetSelectPopup", SubView)
autoImport("WrapCellHelper")
autoImport("PostcardTargetSelectCell")

function PostcardTargetSelectPopup:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
end

function PostcardTargetSelectPopup:AddViewEvts()
end

function PostcardTargetSelectPopup:initView()
  self.gameObject = self:FindGO("TargetSelectPart_Postcard")
  self.satab_list = {}
  self.tabIconSpList = {}
  local satab_btn1 = self:FindGO("FriendBtn")
  local satab_btn2 = self:FindGO("GuildBtn")
  self:AddClickEvent(satab_btn1, function()
    self:OnSelectTab(1)
  end)
  self:AddClickEvent(satab_btn2, function()
    self:OnSelectTab(2)
  end)
  self.satab_list[1] = self:FindComponent("Toggle", UIToggle, satab_btn1)
  self.satab_list[2] = self:FindComponent("Toggle", UIToggle, satab_btn2)
  self.tabIconSpList[1] = self:FindComponent("Icon", UISprite, satab_btn1)
  self.tabIconSpList[2] = self:FindComponent("Icon", UISprite, satab_btn2)
  self.titleLb = self:FindComponent("ListTitle", UILabel)
  self.searchInput = self:FindComponent("ContentInput", UIInput)
  self:AddClickEvent(self:FindGO("SearchBtn"), function()
    self:OnSearchBtn()
  end)
  EventDelegate.Add(self.searchInput.onSubmit, function()
    self:OnSearchBtn()
  end)
  self.searchResultSv = self:FindComponent("ContentScrollView", UIScrollView)
  local wrapConfig = {
    wrapObj = self:FindGO("ContentContainer"),
    pfbNum = 5,
    cellName = "PostcardTargetSelectCell",
    control = PostcardTargetSelectCell,
    dir = 1,
    disableDragIfFit = false
  }
  self.searchResultList = WrapCellHelper.new(wrapConfig)
  self.searchResultList:AddEventListener(MouseEvent.MouseClick, self.handleClickSelectCell, self)
  self.searchResultList:AddEventListener(FriendEvent.SelectHead, self.HandleClickItem, self)
  self.searchResultListTip = self:FindGO("ListTip")
  self.loading = self:FindGO("Loading")
  self:AddClickEvent(self:FindGO("CloseButton", self.gameObject), function(go)
    self.satab = nil
    self:Hide()
    if self.container and self.container.context.flag_PendingSelectTarget then
      self.container:CloseSelf()
    end
  end)
end

function PostcardTargetSelectPopup:initData()
  self.friendDataFetched = nil
  self.satab = nil
  self.tipData = {}
end

function PostcardTargetSelectPopup:OnEnter()
  self:OnSelectTab(1)
end

function PostcardTargetSelectPopup:OnExit()
end

function PostcardTargetSelectPopup:OnSearchBtn()
  self:RefreshResultList()
end

function PostcardTargetSelectPopup:OnSelectTab(tab)
  if self.satab ~= tab then
    self.satab = tab
    self:TryFetchList()
    self:RefreshResultList()
    for i = 1, #self.satab_list do
      self.satab_list[i].value = tab == i
    end
    self:SetCurrentTabIconColor(tab)
    if self.satab == 1 then
      self.titleLb.text = ZhString.Postcard_To_Friend
    elseif self.satab == 2 then
      self.titleLb.text = ZhString.Postcard_To_GuildMember
    end
  end
end

function PostcardTargetSelectPopup:UpdateOnSelectTab()
  if self.satab then
    self:TryFetchList()
    self:RefreshResultList()
    if self.satab == 1 then
      self.titleLb.text = ZhString.Postcard_To_Friend
    elseif self.satab == 2 then
      self.titleLb.text = ZhString.Postcard_To_GuildMember
    end
  end
end

function PostcardTargetSelectPopup:TryFetchList()
  if self.satab == 1 and not self.friendDataFetched then
    local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData() or false
    self.loading:SetActive(not isQuerySocialData)
    self.searchResultSv.gameObject:SetActive(isQuerySocialData)
    ServiceSessionSocialityProxy.Instance:CallQuerySocialData()
    self.friendDataFetched = true
  else
    self.loading:SetActive(false)
    self.searchResultSv.gameObject:SetActive(true)
  end
  self.searchResultListTip:SetActive(false)
end

function PostcardTargetSelectPopup:RefreshResultList()
  local memberList
  if self.satab == 1 then
    memberList = FriendProxy.Instance:GetFriendData()
  elseif self.satab == 2 then
    memberList = GuildProxy.Instance.myGuildData and GuildProxy.Instance.myGuildData:GetMemberList() or {}
    local _ml = {}
    for i = 1, #memberList do
      if memberList[i].id ~= Game.Myself.data.id then
        _ml[#_ml + 1] = memberList[i]
      end
    end
    memberList = _ml
  end
  local searchFilter = self.searchInput.value
  if searchFilter and searchFilter ~= "" then
    local _ml = {}
    for i = 1, #memberList do
      if memberList[i].name and string.find(memberList[i].name, searchFilter) then
        _ml[#_ml + 1] = memberList[i]
      elseif self.satab == 1 and memberList[i].guid == tonumber(searchFilter) then
        _ml[#_ml + 1] = memberList[i]
      elseif self.satab == 2 and memberList[i].id == tonumber(searchFilter) then
        _ml[#_ml + 1] = memberList[i]
      end
    end
    memberList = _ml
  end
  if self.satab == 1 then
    table.sort(memberList, function(a, b)
      local offlinevar_a = a.offlinetime or 0
      local offlinevar_b = b.offlinetime or 0
      if offlinevar_a ~= offlinevar_b then
        if offlinevar_a == 0 then
          return true
        elseif offlinevar_b == 0 then
          return false
        else
          return offlinevar_a > offlinevar_b
        end
      end
      return a.guid < b.guid
    end)
  else
    table.sort(memberList, function(a, b)
      if a.baselevel == 0 then
        return false
      elseif b.baselevel == 0 then
        return true
      end
      local offlinevar_a = a.offlinetime or 0
      local offlinevar_b = b.offlinetime or 0
      if offlinevar_a ~= offlinevar_b then
        if offlinevar_a == 0 then
          return true
        elseif offlinevar_b == 0 then
          return false
        else
          return offlinevar_a > offlinevar_b
        end
      end
      return a.id < b.id
    end)
  end
  self.searchResultList:ResetDatas(memberList, true)
  if memberList and 0 < #memberList then
    self.searchResultListTip:SetActive(false)
  else
    self.searchResultListTip:SetActive(true)
  end
end

function PostcardTargetSelectPopup:TryUpdateFriendList()
  if self.satab == 1 then
    self:TryFetchList()
    self:RefreshResultList()
  end
end

function PostcardTargetSelectPopup:handleClickSelectCell(cell)
  local targetData = {}
  if cell.data.guildData then
    targetData.guid = cell.data.id
    targetData.name = cell.data.name
  else
    targetData.guid = cell.data.guid
    targetData.name = cell.data.name
  end
  self.container:Sender_SetTarget(targetData)
  self:Hide()
end

function PostcardTargetSelectPopup:SetCurrentTabIconColor(tab)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupColorOfCurrentTabIcon(self.tabIconSpList[tab])
end

function PostcardTargetSelectPopup:HandleClickItem(cellctl)
  local data = cellctl.data
  local playerData = PlayerTipData.new()
  if cellctl.data.guildData then
    playerData:SetByGuildMemberData(cellctl.data)
  else
    playerData:SetByFriendData(cellctl.data)
  end
  FunctionPlayerTip.Me():CloseTip()
  TableUtility.TableClear(self.tipData)
  self.tipData.playerData = playerData
  if data.offlinetime == 0 then
    self.tipData.funckeys = self.funkey
  else
    self.tipData.funckeys = self.funkeyOffline
  end
  FunctionPlayerTip.Me():GetPlayerTip(cellctl.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60}, self.tipData)
end
