autoImport("GuildHeadCell")
GuildFindPage = class("GuildFindPage", SubView)
autoImport("GuildCell")
autoImport("GuildRecruitCell")
autoImport("GuildDateBattleRecordData")
local GvgDroiyanReward_Config = GameConfig.GvgDroiyan.GvgDroiyanReward
local HEAD_TEX = "shop_bg_05"
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
local Line_Color_Normal = Color(0.2784313725490196, 0.5764705882352941, 0.8784313725490196)
local Line_Color_Selected = Color(1, 1, 1, 1)

function GuildFindPage:Init(parent)
  self.isGuildDate = self.container.isGuildDate == true
  local GuildFindPage = self:FindGO("GuildFindPage")
  if GuildFindPage ~= nil then
    GuildFindPage:SetActive(false)
  end
  self.searchConds = {}
  self:CreatePageObj(parent)
  self:InitUI()
  self:InitCityFilter()
  self:InitGvgGroupFilter()
  self:MapListenEvt()
  self.pageMap = {}
end

function GuildFindPage:AddSearchCond(cond)
  if not cond then
    return false
  end
  if not table.ContainsValue(self.searchConds, cond) then
    table.insert(self.searchConds, cond)
    return true
  end
  return false
end

function GuildFindPage:RemoveSearchCond(cond)
  if not cond then
    return false
  end
  for i = #self.searchConds, 1, -1 do
    if self.searchConds[i] == cond then
      table.remove(self.searchConds, i)
      return true
    end
  end
  return false
end

function GuildFindPage:ClearSearchConds()
  self.searchConds = {}
end

function GuildFindPage:CreatePageObj(parent)
  self.parent = parent
  if self.parent then
    self:LoadPreferb("view/GuildFindPage", self.parent, true)
  end
end

function GuildFindPage:InitUI()
  local guildWrap = self:FindGO("GuildWrapContent")
  local wrapConfig = {
    wrapObj = guildWrap,
    cellName = "GuildCell",
    control = GuildCell
  }
  self.guildlstCtl = WrapCellHelper.new(wrapConfig)
  self.guildlstCtl:AddEventListener(MouseEvent.MouseClick, self.ClickGuildCell, self)
  self.keyInput = self:FindComponent("Input", UIInput)
  local inputLimit = BranchMgr.IsJapan() and 12 or 8
  UIUtil.LimitInputCharacter(self.keyInput, inputLimit)
  EventDelegate.Add(self.keyInput.onSubmit, function()
    self:DoSearch()
  end)
  self.loadingFlag = self:FindGO("Loading")
  self.loadingFlag:SetActive(true)
  self.noneTip = self:FindGO("NoneTip", self.parent)
  self.noneTipLab = self:FindComponent("Label", UILabel, self.noneTip)
  self.noneTipLab.text = ZhString.GuildFindPage_NoData
  self.noneTip:SetActive(false)
  self.exitCDTime = self:FindComponent("ExitCDTime", UILabel)
  local searchButton = self:FindGO("SearchButton")
  local searchLab = self:FindComponent("Label", UILabel, searchButton)
  searchLab.text = ZhString.GuildFindPage_Search
  self:AddClickEvent(searchButton, function()
    self:DoSearch()
  end)
  self.recruitPos = self:FindGO("RecruitPos")
  self.unchooseLab = self:FindComponent("UnChooseGuild", UILabel, self.recruitPos)
  self.unchooseLab.text = ZhString.GuildFindPage_UnChoose
  self.infoPos = self:FindGO("InfoPos", self.recruitPos)
  local recruitTitle = self:FindComponent("RecruitTitle", UILabel, self.infoPos)
  recruitTitle.text = ZhString.GuildApproved_recruitLab
  local recruitGO = self:FindGO("RecruitScroll", self.infoPos)
  self.recruitListCtrl = ListCtrl.new(self:FindComponent("ULGrid", UIGrid, recruitGO), GuildRecruitCell, "Gvg/GuildRecruitCell")
  self.recruitLab = self:FindComponent("RecruitLab", UILabel, recruitGO)
  local chairman = self:FindComponent("ChairMan", UILabel, self.infoPos)
  chairman.text = ZhString.GuildApproved_ChairMan
  self.chairManLab = self:FindComponent("ChairManLab", UILabel, self.infoPos)
  self.guildLv = self:FindComponent("GuildLv", UILabel, self.infoPos)
  self.enterLevel = self:FindComponent("EnterLevel", UILabel, self.infoPos)
  self.battle_group = self:FindGO("BattleGroup")
  self.battle_groupLab = self:FindComponent("BattleGroupLab", UILabel, self.infoPos)
  self.battle_group_arrow = self:FindGO("Arrow", self.battle_group)
  self.battle_group_targetLabel = self:FindComponent("Target", UILabel, self.battle_group)
  self.battle_group_changeTip = self:FindComponent("ChangeTip", UILabel, self.battle_group)
  self.battle_group_changeTip.text = ZhString.GuildFindPage_ChangeLineTip
  self.cityName = self:FindComponent("City", UILabel, self.infoPos)
  self.guildGvg = self:FindComponent("GuildGvg", UILabel, self.infoPos)
  self.headTexture = self:FindComponent("HeadTexture", UITexture, self.infoPos)
  self.battleLine = self:FindComponent("BattleLine", UILabel, self.infoPos)
  if self.battleLine then
    self.battleLine.gameObject:SetActive(false)
  end
  self.changeLine = self:FindComponent("ChangeLine", UILabel, self.infoPos)
  if self.changeLine then
    self.changeLine.gameObject:SetActive(false)
  end
  self.applyBtn = self:FindComponent("ApplyBtn", UISprite, self.recruitPos)
  self.applyBtnCollider = self.applyBtn:GetComponent(BoxCollider)
  self.applyBtnTitle = self:FindComponent("ApplyBtnTitle", UILabel, self.applyBtn.gameObject)
  self.applyBtnTitle.text = ZhString.GuildFindPage_ApplyGuild
  self:ApplyBtnStateOn(false)
  self.guildDateBtn = self:FindGO("GuildDateBtn", self.recruitPos)
  self.guildDateLab = self:FindComponent("Label", UILabel, self.guildDateBtn)
  self.guildDateLab.text = ZhString.GuildDateBattle_InviteTitle
  self.guildDateBtn:SetActive(self.isGuildDate)
  self:AddClickEvent(self.guildDateBtn, function()
    if not self.selectedGuildData then
      return
    end
    local myGuildData = GuildProxy.Instance.myGuildData
    local client_data = {}
    client_data.id = 0
    client_data.mode = 1
    client_data.atk_guildid = myGuildData.id
    client_data.atk_guildname = myGuildData.name
    client_data.atk_guildportrait = myGuildData.portrait
    client_data.atkServerId = myGuildData.serverid
    client_data.def_guildid = self.selectedGuildData.id
    client_data.def_guildname = self.selectedGuildData.guildname
    client_data.def_guildportrait = self.selectedGuildData.portrait
    client_data.def_serverid = self.selectedGuildData.serverid
    client_data.atk_chairmanid = Game.Myself.data.id
    client_data.def_chairmanid = self.selectedGuildData:GetChairManId()
    local record_data = GuildDateBattleRecordData.new(client_data)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildDateBattleInviteView,
      viewdata = {data = record_data}
    })
  end)
  local guildHeadCellGO = self:FindGO("GuildHeadCell")
  self.headCell = GuildHeadCell.new(guildHeadCellGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.selectedGuildData = nil
  self:AddClickEvent(self.applyBtn.gameObject, function()
    if GuildProxy.Instance:IHaveGuild() then
      return
    end
    if self.selectedGuildData then
      if GuildProxy.Instance:IsInJoinCD() then
        MsgManager.ShowMsgByIDTable(4046)
        return
      end
      ServiceGuildCmdProxy.Instance:CallApplyGuildGuildCmd(self.selectedGuildData.id)
      self:ApplyBtnStateOn(false)
    end
  end)
  self.scrollView = self:FindComponent("GuildScroll", UIScrollView)
  self.scrollView.momentumAmount = 100
  NGUIUtil.HelpChangePageByDrag(self.scrollView, function()
    self:GetPrePageGuilds()
  end, function()
    self:GetNextPageGuilds()
  end, 120, true)
  self.applyMercenaryBtn = self:FindComponent("ApplyMercenaryBtn", UISprite, self.recruitPos)
  self.applyMercenaryBtnCollider = self.applyMercenaryBtn:GetComponent(BoxCollider)
  self.applyMercenaryTitle = self:FindComponent("ApplyMercenaryTitle", UILabel, self.applyMercenaryBtn.gameObject)
  self:UpdateMercenaryBtn()
  self:AddClickEvent(self.applyMercenaryBtn.gameObject, function()
    self:OnMercenaryBtnClicked()
  end)
  self.guildDateBattleTitle = self:FindComponent("GuildDateBattleTitle", UILabel, self.parent)
  self:Hide(self.guildDateBattleTitle)
  self.condTable = self:FindComponent("CondTable", UITable, self.parent)
  self.condToggle_1 = self:FindComponent("CondToggle_1", UIToggle, self.condTable.gameObject)
  self.condLab_1 = self:FindComponent("CondLab", UILabel, self.condToggle_1.gameObject)
  self.condLab_1.text = ZhString.GuildFindPage_SearchCondNoApproval
  self.condToggle_1.value = false
  EventDelegate.Add(self.condToggle_1.onChange, function()
    if self.condToggle_1.value then
      if self:AddSearchCond(GuildCmd_pb.EQUERYGUILD_NOCHECK) then
        self:ClearAndDoSearch()
      end
    elseif self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_NOCHECK) then
      self:ClearAndDoSearch()
    end
  end)
  self.condToggle_2 = self:FindComponent("CondToggle_2", UIToggle, self.condTable.gameObject)
  self.condLab_2 = self:FindComponent("CondLab", UILabel, self.condToggle_2.gameObject)
  self.condLab_2.text = ZhString.GuildFindPage_SearchCondMatchLevel
  self.condToggle_2.value = false
  EventDelegate.Add(self.condToggle_2.onChange, function()
    if self.condToggle_2.value then
      if self:AddSearchCond(GuildCmd_pb.EQUERYGUILD_LEVEL) then
        self:ClearAndDoSearch()
      end
    elseif self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_LEVEL) then
      self:ClearAndDoSearch()
    end
  end)
  self.condTable.gameObject:SetActive(not self.isGuildDate)
  self.cityFilterPopup = self:FindComponent("CityFilterPopup", UIPopupList)
  EventDelegate.Add(self.cityFilterPopup.onChange, function()
    if not self.cityFilterPopup.data then
      return
    end
    self.titles[2].text = self:GetCityFilterTitle(self.cityFilterPopup.data)
    local queryType = math.floor(self.cityFilterPopup.data)
    local rmL = queryType ~= GuildCmd_pb.EQUERYGUILD_CITY_LARGE and self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CITY_LARGE)
    local rmM = queryType ~= GuildCmd_pb.EQUERYGUILD_CITY_MIDDLE and self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CITY_MIDDLE)
    local rmS = queryType ~= GuildCmd_pb.EQUERYGUILD_CITY_SMALL and self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CITY_SMALL)
    local addType = 0 < queryType and self:AddSearchCond(queryType)
    if addType or rmL or rmM or rmS then
      self:ClearAndDoSearch()
    end
  end)
  self.gvgGroupFilterPopup = self:FindComponent("GvgGroupFilterPopup", UIPopupList)
  EventDelegate.Add(self.gvgGroupFilterPopup.onChange, function()
    if not self.gvgGroupFilterPopup then
      return
    end
    local filter_data = math.floor(self.gvgGroupFilterPopup.data)
    local opt_success = false
    if filter_data ~= GuildCmd_pb.EQUERYGUILD_CUR_GVGGROUP then
      opt_success = self:RemoveSearchCond(GuildCmd_pb.EQUERYGUILD_CUR_GVGGROUP)
    else
      opt_success = self:AddSearchCond(GuildCmd_pb.EQUERYGUILD_CUR_GVGGROUP)
    end
    if opt_success then
      self:ClearAndDoSearch()
    end
  end)
  self.gvgGroupFilterPopup.gameObject:SetActive(GvgProxy.Instance:HasMoreGroupZone() and GuildProxy.Instance:IHaveGuild())
  self.titleRoot = self:FindGO("GridTitle")
  self.titles = {}
  self.titles[1] = self:FindComponent("Title_GuildName", UILabel, self.titleRoot)
  self.titles[2] = self:FindComponent("CityScale", UILabel, self.titleRoot)
  self.titles[3] = self:FindComponent("MemberNum", UILabel, self.titleRoot)
  self.titles[4] = self:FindComponent("GvgGroup", UILabel, self.titleRoot)
  for i = 1, #self.titles do
    self.titles[i].text = ZhString["GuildFindPage_Title_" .. i]
  end
  self.helpBtn = self:FindGO("HelpBtn")
  if self.helpBtn then
    self.helpBtn:SetActive(false)
  end
  self.lineTabs = {}
  self.lineGroupGO = self:FindGO("LineGroup")
  local allLineTabGO = self:FindGO("AllLineTab", self.lineGroupGO)
  self:AddClickEvent(allLineTabGO, function()
    self:OnLineTabClicked(1)
  end)
  self.lineTabs[1] = {
    selectedGO = self:FindGO("Selected", self.lineGroupGO),
    lineIcon = self:FindComponent("Icon", UISprite, self.lineGroupGO),
    lineLab = self:FindComponent("Line", UILabel, self.lineGroupGO),
    searchCond = GuildCmd_pb.EQUERYGUILD_ALL_ZONE
  }
  local myLineTabGO = self:FindGO("MyLineTab", self.lineGroupGO)
  self:AddClickEvent(myLineTabGO, function()
    self:OnLineTabClicked(2)
  end)
  self.lineTabs[2] = {
    selectedGO = self:FindGO("Selected", myLineTabGO),
    lineIcon = self:FindComponent("Icon", UISprite, myLineTabGO),
    lineLab = self:FindComponent("Line", UILabel, myLineTabGO),
    searchCond = GuildCmd_pb.EQUERYGUILD_CUR_GVGGROUP
  }
  if not GuildProxy.Instance:IHaveGuild() then
    self.lineGroupGO:SetActive(false)
    return
  end
  self.lineGroupGO:SetActive(false)
  self.selectedLineTab = 1
  self:UpdateLineTabs()
  self:UpdateMyLineTab()
end

function GuildFindPage:OnLineTabClicked(tabIndex)
  if self.selectedLineTab ~= tabIndex then
    self.selectedLineTab = tabIndex
    self:UpdateLineTabs()
    self:ClearAndDoSearch()
  end
end

function GuildFindPage:UpdateLineTabs()
  if not GuildProxy.Instance:IHaveGuild() then
    return
  end
  for i, tab in ipairs(self.lineTabs) do
    if i == self.selectedLineTab then
      tab.selectedGO:SetActive(true)
      tab.lineIcon.color = Line_Color_Selected
      tab.lineLab.color = Line_Color_Selected
      self:AddSearchCond(tab.searchCond)
    else
      tab.selectedGO:SetActive(false)
      tab.lineIcon.color = Line_Color_Normal
      tab.lineLab.color = Line_Color_Normal
      self:RemoveSearchCond(tab.searchCond)
    end
  end
end

function GuildFindPage:HandleGuildDataUpdate()
  self:UpdateMyLineTab()
end

function GuildFindPage:UpdateDateBattleCount()
  if not self.isGuildDate then
    return
  end
  local max = GameConfig.GuildDateBattle and GameConfig.GuildDateBattle.max_count or 12
  local cur = GuildDateBattleProxy.Instance:GetCurDateCount()
  self.guildDateBattleTitle.text = string.format(ZhString.GuildDateBattle_GuildFind, cur, max)
end

function GuildFindPage:UpdateMyLineTab()
  if not GuildProxy.Instance:IHaveGuild() then
    return
  end
  local lineTab = self.lineTabs and self.lineTabs[2]
  if lineTab then
    lineTab.lineLab.text = GuildProxy.Instance:GetMyGuildClientGvgGroup()
  end
end

function GuildFindPage:ClearAndDoSearch()
  self.curPopData = nil
  self.nowPage = nil
  self.prePage = nil
  self:DoSearch()
end

function GuildFindPage:DoSearch()
  local key = self.keyInput.value
  if key and key ~= "" then
    self.keyword = key
    self:QueryGuildPageList(nil, key)
  else
    self.pageMap = {}
    self:QueryGuildPageList(1)
    self.guildlstCtl:ResetPosition()
  end
end

function GuildFindPage:GetMyGuildHeadData()
  if self.myGuildHeadData == nil then
    self.myGuildHeadData = GuildHeadData.new()
  end
  if self.selectedGuildData ~= nil then
    self.myGuildHeadData:SetBy_InfoId(self.selectedGuildData.portrait)
    self.myGuildHeadData:SetGuildId(self.selectedGuildData.id)
  end
  return self.myGuildHeadData
end

function GuildFindPage:InitCityFilter()
  local nameConfig, valueConfig = GuildProxy.Instance:GetGuildCityFilterConfig()
  if nameConfig and valueConfig and #nameConfig == #valueConfig then
    for i, name in ipairs(nameConfig) do
      self.cityFilterPopup:AddItem(name, valueConfig[i])
    end
  end
end

function GuildFindPage:InitGvgGroupFilter()
  if GvgProxy.Instance:HasMoreGroupZone() and GuildProxy.Instance:IHaveGuild() then
    local name, value = GuildProxy.Instance:GetAllGvgGroupFilterConfig()
    for i, v in ipairs(name) do
      self.gvgGroupFilterPopup:AddItem(v, value[i])
    end
  end
end

function GuildFindPage:GetFilterTitle(selectedValue)
  if self.rangeList and selectedValue == self.rangeList[1] then
    return ZhString.GuildFindPage_FilterTitleAll
  end
end

function GuildFindPage:GetCityFilterTitle(selectedValue)
  local nameConfig, valueConfig = GuildProxy.Instance:GetGuildCityFilterConfig()
  if nameConfig and valueConfig then
    for i, v in ipairs(valueConfig) do
      if v == selectedValue then
        if i == 1 then
          return ZhString.GuildFindPage_Title_2
        else
          return nameConfig[i] or ""
        end
      end
    end
  end
  return ""
end

function GuildFindPage:ClickGuildCell(cellctl)
  local data = cellctl and cellctl.data
  if not data then
    return
  end
  self:HandleClickCell(data)
end

function GuildFindPage:HandleClickCell(data, forceRefresh)
  if not forceRefresh and self.selectedGuildData and self.selectedGuildData.guid == data.guid then
    return
  end
  self.selectedGuildData = data
  self.guildLv.text = string.format("Lv.%s", data.level)
  if data.gvglevel and data.gvglevel > 0 then
    self.guildGvg.gameObject:SetActive(true)
    self.guildGvg.text = GvgDroiyanReward_Config[data.gvglevel].LvDesc
  else
    self.guildGvg.gameObject:SetActive(false)
  end
  self.enterLevel.text = string.format(ZhString.GuildFindPage_EnterLevel, self.selectedGuildData.needlevel or 0)
  self.enterLevel.text = self.selectedGuildData.needlevel or 0
  if self.battle_group then
    local targetGroup = data.next_battle_group
    xdlog("战线变更", data.battle_group, targetGroup)
    if targetGroup and targetGroup ~= 0 then
      self.battle_group_arrow:SetActive(true)
      self.battle_group_targetLabel.gameObject:SetActive(true)
      self.battle_group_targetLabel.text = GvgProxy.ClientGroupId(targetGroup)
      self.battle_group_changeTip.gameObject:SetActive(true)
    else
      self.battle_group_arrow:SetActive(false)
      self.battle_group_targetLabel.gameObject:SetActive(false)
      self.battle_group_changeTip.gameObject:SetActive(false)
    end
    if self.battle_groupLab then
      self.battle_groupLab.text = GvgProxy.ClientGroupId(data.battle_group)
    end
  end
  self.cityName.text = self.selectedGuildData:GetOccupiedCityName()
  local hasGuild = GuildProxy.Instance:IHaveGuild()
  local applyValid = data.applied
  self:ApplyBtnStateOn(not hasGuild and applyValid or false)
  self.applyBtnTitle.text = applyValid and ZhString.GuildFindPage_ApplyGuild or ZhString.GuildFindPage_ApplyGuildInvalid
  self.headCell:SetData(self:GetMyGuildHeadData())
  self.chairManLab.text = data.chairmanname
  self.recruitLab.text = data.recruitinfo
  self:UpdateRecruitPanel()
  local cells = self.guildlstCtl:GetCellCtls()
  if cells then
    for i = 1, #cells do
      cells[i]:SetChoose(data.guid)
    end
  end
  self:UpdateMercenaryBtn()
end

function GuildFindPage:UpdateRecruitPanel()
  local recruitLabHeight = self.recruitLab.height
  local recruitLineNum = self.recruitLab.text == "" and 0 or math.ceil(self.recruitLab.height / (self.recruitLab.fontSize + self.recruitLab.spacingY))
  recruitLineNum = math.max(recruitLineNum, 3)
  local datas = {}
  for i = 1, recruitLineNum do
    datas[i] = i
  end
  self.recruitListCtrl:ResetDatas(datas)
  self.recruitListCtrl:ResetPosition()
end

function GuildFindPage:ApplyBtnStateOn(on)
  if self.isGuildDate then
    self:Hide(self.applyBtn)
    return
  end
  self:Show(self.applyBtn)
  if on then
    self.applyBtnTitle.effectColor = ColorUtil.ButtonLabelOrange
    self.applyBtn.spriteName = "com_btn_2s"
    if self.applyBtnCollider then
      self.applyBtnCollider.enabled = true
    end
  else
    self.applyBtnTitle.effectColor = GRAY_LABEL_COLOR
    self.applyBtn.spriteName = "com_btn_13s"
    if self.applyBtnCollider then
      self.applyBtnCollider.enabled = false
    end
  end
end

function GuildFindPage:GetPrePageGuilds()
  if not self:CanQuery() then
    return
  end
  if self.nowPage then
    local page = math.max(self.nowPage - 1, 1)
    self:QueryGuildPageList(page)
  end
end

function GuildFindPage:GetNextPageGuilds()
  if not self:CanQuery() then
    return
  end
  if self.nowPage then
    local page = self.nowPage + 1
    if self.maxPage then
      page = math.min(self.maxPage, page)
    end
    self:QueryGuildPageList(page)
  end
end

function GuildFindPage:LockQuery()
  self.lastQueryTime = ServerTime.CurServerTime()
end

function GuildFindPage:UnlockQuery()
  self.lastQueryTime = nil
end

function GuildFindPage:CanQuery()
  local curServerTime = ServerTime.CurServerTime()
  if self.lastQueryTime and curServerTime - self.lastQueryTime < 5000 then
    return false
  end
  return true
end

function GuildFindPage:QueryGuildPageList(page, keyword)
  self.prePage = self.nowPage
  self.nowPage = page or 1
  if keyword then
    self.nowPage = nil
    self.prePage = nil
    self.pageMap = {}
    self.keyword = keyword
    self.loadingFlag:SetActive(true)
    ServiceGuildCmdProxy.Instance:CallQueryGuildListGuildCmd(keyword, 1, self.searchConds)
    self:LockQuery()
  elseif not self.pageMap[self.nowPage] then
    self.pageMap[self.nowPage] = 1
    self.loadingFlag:SetActive(true)
    ServiceGuildCmdProxy.Instance:CallQueryGuildListGuildCmd(nil, self.nowPage, self.searchConds)
    self:LockQuery()
    if self.nowPage > 1 then
      MsgManager.FloatMsg(nil, ZhString.GuildFindPage_Loading)
    end
  end
end

function GuildFindPage:MapListenEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGuildListGuildCmd, self.HandleGuildListUpdate)
  self:AddListenEvt(GuildEvent.ExitMercenary, self.OnExitMercenary)
  self:AddListenEvt(GuildEvent.EnterMercenary, self.OnEnterMercenary)
  self:AddListenEvt(ServiceEvent.GuildCmdEnterGuildGuildCmd, self.OnEnterGuild)
  self:AddListenEvt(ServiceEvent.GuildCmdGuildDataUpdateGuildCmd, self.HandleGuildDataUpdate)
end

function GuildFindPage:OnEnterGuild()
  self:UpdateMercenaryBtn()
end

function GuildFindPage:OnEnterMercenary()
  self:UpdateMercenaryBtn()
  self:DoSearch()
end

function GuildFindPage:OnExitMercenary()
  self:UpdateMercenaryBtn()
  self:DoSearch()
end

function GuildFindPage:HandleGuildListUpdate(note)
  self:UnlockQuery()
  self.loadingFlag:SetActive(false)
  local datas = GuildProxy.Instance:GetGuildList()
  local needResetPosition = false
  if self.keyword then
    self.keyword = nil
    self.guildlstCtl:ResetDatas(datas)
    needResetPosition = true
  elseif self.prePage then
    if 0 < #datas then
      if self.nowPage < self.prePage then
        for i = #datas, 1, -1 do
          self.guildlstCtl:InsertData(datas[i], 1)
        end
      elseif self.prePage < self.nowPage then
        for i = 1, #datas do
          self.guildlstCtl:InsertData(datas[i])
        end
      end
    else
      self.nowPage = self.prePage
      self.maxPage = self.nowPage
    end
  elseif self.nowPage then
    self.guildlstCtl:ResetDatas(datas)
    needResetPosition = true
  end
  local alldatas = self.guildlstCtl:GetDatas()
  self:ApplyBtnStateOn(false)
  if 0 < #alldatas then
    if 0 < #datas then
      self:HandleClickCell(datas[1], true)
    end
    self.noneTip:SetActive(false)
    self.infoPos:SetActive(true)
    self.unchooseLab.gameObject:SetActive(false)
  else
    self.noneTip:SetActive(true)
    self.infoPos:SetActive(false)
    self.unchooseLab.gameObject:SetActive(true)
    self.selectedGuildData = nil
  end
  if needResetPosition then
    self.guildlstCtl:ResetPosition()
  end
  self:UpdateMercenaryBtn()
end

function GuildFindPage:UpdateCDTime()
  local exit_timetick = GuildProxy.Instance:GetExitTimeTick()
  if exit_timetick == nil or exit_timetick == 0 then
    self.exitCDTime.text = ""
    self.exitCDTime.gameObject:SetActive(false)
    return
  end
  local delta_sec = ServerTime.ServerDeltaSecondTime(exit_timetick * 1000)
  if delta_sec <= 0 then
    self.exitCDTime.text = ""
    self.exitCDTime.gameObject:SetActive(false)
    return
  end
  self.exitCDTime.gameObject:SetActive(true)
  local hour = math.ceil(delta_sec / 3600)
  self.exitCDTime.text = string.format(ZhString.GuildFindPage_ExitCDTip, hour)
end

function GuildFindPage:OnEnter()
  GuildFindPage.super.OnEnter(self)
  PictureManager.Instance:SetUI(HEAD_TEX, self.headTexture)
  self:QueryGuildPageList(1)
  self:UpdateCDTime()
end

function GuildFindPage:OnExit()
  PictureManager.Instance:UnLoadUI(HEAD_TEX, self.headTexture)
  self.scrollView.onDragFinished = nil
  self.scrollView.onStoppedMoving = nil
  GuildFindPage.super.OnExit(self)
end

function GuildFindPage:UpdateMercenaryBtn()
  if self.isGuildDate then
    self:Hide(self.applyMercenaryBtn)
    return
  end
  self:Show(self.applyMercenaryBtn)
  local proxy = GuildProxy.Instance
  local myMercenaryGuildData = proxy:GetMyMercenaryGuildData()
  local isMyMercenaryGuild = proxy:IsMyMercenaryGuild(self.selectedGuildData and self.selectedGuildData.id)
  local isMyGuild = proxy:IsMyGuild(self.selectedGuildData and self.selectedGuildData.id)
  local canClick = true
  if not self.selectedGuildData or self.selectedGuildData.id <= 0 then
    self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenary
    self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
    self.applyMercenaryBtn.spriteName = "com_btn_13s"
    canClick = false
  elseif myMercenaryGuildData and myMercenaryGuildData.id and myMercenaryGuildData.id > 0 then
    if isMyMercenaryGuild then
      self.applyMercenaryTitle.text = ZhString.GuildFindPage_QuitMercenary
      self.applyMercenaryTitle.effectColor = ColorUtil.ButtonLabelBlue
      self.applyMercenaryBtn.spriteName = "com_btn_1s"
    else
      self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenary
      self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
      self.applyMercenaryBtn.spriteName = "com_btn_13s"
      canClick = false
    end
  else
    local mercenaryValid = self.selectedGuildData and self.selectedGuildData.mercenary or false
    if isMyGuild then
      self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
      self.applyMercenaryBtn.spriteName = "com_btn_13s"
      canClick = false
      self.applyMercenaryTitle.text = mercenaryValid and ZhString.GuildFindPage_ApplyMercenary or ZhString.GuildFindPage_ApplyMercenaryInvalid
    elseif mercenaryValid then
      self.applyMercenaryTitle.effectColor = ColorUtil.ButtonLabelBlue
      self.applyMercenaryBtn.spriteName = "com_btn_1s"
      self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenary
    else
      self.applyMercenaryTitle.effectColor = GRAY_LABEL_COLOR
      self.applyMercenaryBtn.spriteName = "com_btn_13s"
      self.applyMercenaryTitle.text = ZhString.GuildFindPage_ApplyMercenaryInvalid
      canClick = false
    end
  end
  if self.applyMercenaryBtnCollider then
    self.applyMercenaryBtnCollider.enabled = canClick
  end
end

function GuildFindPage:OnMercenaryBtnClicked()
  if not self.selectedGuildData then
    return
  end
  local proxy = GuildProxy.Instance
  local selectedGuildId = self.selectedGuildData.id
  local myMercenaryGuildData = proxy:GetMyMercenaryGuildData()
  local myMercenaryGuildId = myMercenaryGuildData and myMercenaryGuildData.id
  if myMercenaryGuildId and 0 < myMercenaryGuildId then
    if proxy:IsMyMercenaryGuild(selectedGuildId) then
      MsgManager.ConfirmMsgByID(31039, function()
        ServiceGuildCmdProxy.Instance:CallExitGuildGuildCmd(myMercenaryGuildData.id)
      end)
    end
  elseif not proxy:IsMyGuild(selectedGuildId) then
    ServiceGuildCmdProxy.Instance:CallApplyGuildGuildCmd(selectedGuildId, GuildCmd_pb.EGUILDJOB_APPLY_MERCENARY)
  end
end
