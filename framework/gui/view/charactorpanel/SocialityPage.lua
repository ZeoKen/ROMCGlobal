autoImport("PopupGridList")
autoImport("WrapCellHelper")
autoImport("TitleCombineItemCell")
autoImport("SocialityTagCatalogCell")
autoImport("SocialityTagCell")
SocialityPage = class("SocialityPage", SubView)
local dateInfo = {
  [1] = 31,
  [2] = 29,
  [3] = 31,
  [4] = 30,
  [5] = 31,
  [6] = 30,
  [7] = 31,
  [8] = 31,
  [9] = 30,
  [10] = 31,
  [11] = 30,
  [12] = 31
}
local secretStatus = {
  [1] = ZhString.Charactor_SecretOpen,
  [2] = ZhString.Charactor_SecretOnlyFriend,
  [3] = ZhString.Charactor_SecretLock
}
local marrySecret = {
  [SceneUser2_pb.EQUERYTYPE_WEDDING_ALL] = ZhString.Charactor_SecretOpen,
  [SceneUser2_pb.EQUERYTYPE_WEDDING_FRIEND] = ZhString.Charactor_SecretOnlyFriend,
  [SceneUser2_pb.EQUERYTYPE_WEDDING_CLOSE] = ZhString.Charactor_SecretLock
}
local equipSecret = {
  [SceneUser2_pb.EQUERYTYPE_ALL] = ZhString.Charactor_SecretOpen,
  [SceneUser2_pb.EQUERYTYPE_FRIEND] = ZhString.Charactor_SecretOnlyFriend,
  [SceneUser2_pb.EQUERYTYPE_CLOSE] = ZhString.Charactor_SecretLock
}
local friendStatus = {
  [1] = ZhString.Charactor_FriendshipUnnecessary,
  [2] = ZhString.Charactor_Lover,
  [3] = ZhString.Charactor_TeamMember,
  [4] = ZhString.Charactor_Guider
}

function SocialityPage:Init()
  self:InitView()
  self:InitData()
  self:AddViewEventListener()
  self:AddListenerEvts()
end

function SocialityPage:InitView()
  self.socialScrollViewGO = self:FindGO("SocialityScrollView")
  self.socialScrollView = self.socialScrollViewGO:GetComponent(UIScrollView)
  self.rootTable = self:FindGO("Table", self.socialScrollViewGO):GetComponent(UITable)
  self.birthPart = self:FindGO("Birth")
  self.birthLabel = self:FindGO("BirthLabel"):GetComponent(UILabel)
  self.birthLabel.text = ZhString.Charactor_Birthday
  self.constellationIcon = self:FindGO("ConstellationIcon"):GetComponent(UISprite)
  self.titlePart = self:FindGO("TitleSet")
  self.titleFilter = self:FindGO("RecordPopup", self.titlePart)
  self.titleListRoot = self:FindGO("TitleList", self.titlePart)
  self.titleLabCurrent = self:FindGO("labCurrent", self.titleFilter):GetComponent(UILabel)
  self.titleArrow = self:FindGO("tabsArrow", self.titleFilter)
  local svObj = self:FindGO("TitleSc", self.titleListRoot)
  self.titleScrollV = svObj:GetComponent(UIScrollView)
  self.titleItemRoot = self:FindGO("Container", self.titleListRoot)
  self.cancelTitleBtn = self:FindGO("cancelTitleBtn", self.titleListRoot)
  self.titlePropBtn = self:FindGO("TitlePropBtn")
  self.monthPopupList = PopupGridList.new(self:FindGO("MonthPopup"), function(self, data)
    self:OnClickMonth(data)
  end, self, 30)
  self.dayPopupList = PopupGridList.new(self:FindGO("DayPopup"), function(self, data)
    self:OnClickDay(data)
  end, self, 30)
  self.friendapplyPopupList = PopupGridList.new(self:FindGO("FriendApplyPopup"), function(self, data)
    self:OnClickFriendApply(data)
  end, self, 30)
  local showWedding = MyselfProxy.Instance:GetQueryWeddingType()
  if 0 < showWedding then
    self.marryPopupList = PopupGridList.new(self:FindGO("MarryPopup"), function(self, data)
      self:OnClickMarry(data)
    end, self, 30)
  else
    local go = self:FindGO("MarryPopup")
    go:SetActive(false)
  end
  local showDetail = MyselfProxy.Instance:GetQueryType()
  if 0 < showDetail then
    self.equipPopupList = PopupGridList.new(self:FindGO("EquipPopup"), function(self, data)
      self:OnClickEquip(data)
    end, self, 30)
  else
    local go = self:FindGO("EquipPopup")
    go:SetActive(false)
  end
  self.signSetPart = self:FindGO("SignSet")
  self.signCount = self:FindGO("SignCount", self.signSetPart):GetComponent(UILabel)
  self.signInput = self.signSetPart:GetComponent(UIInput)
  local checkInput = function()
    local manualInput = self.signInput.value
    local length = StringUtil.Utf8len(manualInput)
    if 30 < length then
      local subInput = StringUtil.getTextByIndex(manualInput, 1, 30)
      self.signInput.value = subInput
      MsgManager.ShowMsgByID(28010)
      self.signCount.text = StringUtil.Utf8len(subInput) .. "/30"
      return
    end
    if FunctionMaskWord.Me():CheckMaskWord(self.signInput.value, GameConfig.MaskWord.ChatroomName) then
      MsgManager.ShowMsgByIDTable(2604)
      return
    end
    self.signCount.text = length .. "/30"
    self:CheckConfirmStatus()
  end
  EventDelegate.Set(self.signInput.onSubmit, checkInput)
  self:AddSelectEvent(self.signInput, checkInput)
  self.tagPart = self:FindGO("Tag", self.socialScrollViewGO)
  self.tagCenterRoot = self:FindGO("Root", self.tagPart)
  self.tagBg = self:FindGO("Bg", self.tagPart):GetComponent(UISprite)
  self.tagLabel = self:FindGO("TagLabel", self.tagPart):GetComponent(UILabel)
  self.catalogGrid = self:FindGO("CatalogGrid", self.tagPart):GetComponent(UIGrid)
  self.tagCatalogCtrl = UIGridListCtrl.new(self.catalogGrid, SocialityTagCatalogCell, "SocialityTagCatalogCell")
  self.tagCatalogCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickCatalog, self)
  self.tagGrid = self:FindGO("TagGrid", self.tagPart):GetComponent(UIGrid)
  self.tagCtrl = UIGridListCtrl.new(self.tagGrid, SocialityTagCell, "SocialityTagCell")
  self.tagCtrl:AddEventListener(MouseEvent.MouseClick, self.handleClickTag, self)
  self.myTags = {}
  for i = 1, 3 do
    self.myTags[i] = {}
    self.myTags[i].go = self:FindGO("Tag" .. i)
    self.myTags[i].label = self.myTags[i].go:GetComponent(UILabel)
    self.myTags[i].go:SetActive(false)
  end
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmBtnIcon = self.confirmBtn:GetComponent(UISprite)
  self.confirmBtnLab = self:FindGO("ConfirmLabel", self.confirmBtn):GetComponent(UILabel)
  self.confirmBtnBoxCollider = self.confirmBtn:GetComponent(BoxCollider)
end

function SocialityPage:InitData()
  self.curProfileData = {}
  self:InitMonthList()
  self:InitDayList()
  self:InitFriendApplySetList()
  self:InitMarryStatusList()
  self:InitEquipShowStatusList()
  self:InitTitleList()
  self.tagList = {}
  self:InitTagStaticData()
  self:InitTagCatalog()
end

function SocialityPage:AddViewEventListener()
  self:AddClickEvent(self.titleFilter, function()
    self:ShowTitle()
  end)
  self:AddClickEvent(self.cancelTitleBtn, function()
    self:CancelTitle()
  end)
  self:AddClickEvent(self.confirmBtn, function()
    self:DoConfirm()
  end)
  self:AddClickEvent(self.titlePropBtn, function()
    self:ShowPropInfo()
  end)
end

function SocialityPage:AddListenerEvts()
  self:AddListenEvt(ServiceEvent.UserEventSetProfileUserEvent, self.HandleQueryUserInfo, self)
  self:AddListenEvt(ServiceEvent.NUserSetOptionUserCmd, self.CheckConfirmStatus, self)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleMyDataChange, self)
  EventManager.Me():AddEventListener(ServiceEvent.UserEventChangeTitle, self.HandleChangeTitle, self)
end

function SocialityPage:HandleMyDataChange()
  xdlog("MyDataChange")
  self:CheckConfirmStatus()
end

function SocialityPage:OnEnter()
  self:SetCurAchTitle()
  ServiceUserEventProxy.Instance:CallSetProfileUserEvent()
end

function SocialityPage:OnExit()
  self.destroyed = true
  EventManager.Me():RemoveEventListener(ServiceEvent.UserEventChangeTitle, self.HandleChangeTitle, self)
  self.itemWrapHelper:Destroy()
end

local popupItems = {}

function SocialityPage:InitMonthList()
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(dateInfo) do
    local data = ReusableTable.CreateTable()
    data.name = k
    table.insert(popupItems, data)
  end
  self.monthPopupList:SetData(popupItems, true)
end

function SocialityPage:InitDayList()
  TableUtility.ArrayClear(popupItems)
  if not self.curMonth then
    self.curMonth = 1
  end
  local dayCount = dateInfo and dateInfo[self.curMonth]
  for i = 1, dayCount do
    local data = ReusableTable.CreateTable()
    data.name = i
    table.insert(popupItems, data)
  end
  self.dayPopupList:SetData(popupItems, true)
end

function SocialityPage:InitFriendApplySetList()
  TableUtility.ArrayClear(popupItems)
  for i = 1, #friendStatus do
    local data = ReusableTable.CreateTable()
    data.name = friendStatus[i]
    data.index = i
    table.insert(popupItems, data)
  end
  self.friendapplyPopupList:SetData(popupItems, true)
end

function SocialityPage:InitMarryStatusList()
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(marrySecret) do
    local data = ReusableTable.CreateTable()
    data.name = v
    data.index = k
    table.insert(popupItems, data)
  end
  self.marryPopupList:SetData(popupItems)
end

function SocialityPage:InitEquipShowStatusList()
  TableUtility.ArrayClear(popupItems)
  for k, v in pairs(equipSecret) do
    local data = ReusableTable.CreateTable()
    data.name = v
    data.index = k
    table.insert(popupItems, data)
  end
  self.equipPopupList:SetData(popupItems)
end

function SocialityPage:InitTitleList()
  local allTitle = TitleProxy.Instance:GetTitle()
  self:ShowTitleList(allTitle)
end

function SocialityPage:ShowTitleList(data)
  local newData = self:ReUniteCellData(data, 1)
  if self.itemWrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.titleItemRoot,
      pfbNum = 8,
      cellName = "TitleCombineItemCell",
      control = TitleCombineItemCell,
      dir = 1
    }
    self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
    self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickTitle, self)
  end
  self.itemWrapHelper:UpdateInfo(newData)
end

function SocialityPage:ShowTitle()
  local activeState = self.titleListRoot.activeSelf
  if activeState then
    self:Hide(self.titleListRoot)
    self.titleArrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
  else
    self:Show(self.titleListRoot)
    self.titleArrow.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 180)
  end
end

function SocialityPage:CancelTitle()
  local title = TitleProxy.Instance:GetCurAchievementTitle()
  if not title then
    return
  end
  if "" ~= title then
    TitleProxy.Instance:ChangeTitle(titleType, 0)
  end
  self:ShowTitle()
  TipManager.Instance:HideTitleTip()
end

function SocialityPage:ShowTitleTip(data, stick)
  local callback = function()
    if not self.destroyed then
      self.chooseId = 0
      self:_refreshChoose()
    end
  end
  local sdata = {
    itemdata = data,
    ignoreBounds = ignoreBounds,
    callback = callback
  }
  local tip = TipManager.Instance:ShowTitleTip(sdata, stick, NGUIUtil.AnchorSide.Right, {-490, -75})
  tip:AddIgnoreBounds(self.titleListRoot)
end

function SocialityPage:SetCurAchTitle()
  local title = TitleProxy.Instance:GetCurAchievementTitle()
  if nil == title then
  end
  self.titleLabCurrent.text = title or ZhString.Charactor_NoTitleTip
end

function SocialityPage:HandleChangeTitle(data)
  self.chooseId = 0
  self:_refreshChoose()
  self:Hide(self.titleListRoot)
  self:SetCurAchTitle()
  TipManager.Instance:HideTitleTip()
  self:ResetCellData()
end

function SocialityPage:ResetCellData()
  local allTitle = TitleProxy.Instance:GetTitle()
  self:ShowTitleList(allTitle)
end

function SocialityPage:ShowPropInfo()
  local pointData = TitleProxy.Instance:GetAllTitleProp()
  TipManager.Instance:ShowTitlePropTip(pointData, nil, nil, {0, 0})
end

function SocialityPage:InitTagStaticData()
  if not Table_PlayerTag then
    return
  end
  for k, v in pairs(Table_PlayerTag) do
    if not self.tagList[v.Group] then
      self.tagList[v.Group] = {}
    end
    table.insert(self.tagList[v.Group], k)
  end
end

function SocialityPage:InitTagCatalog()
  local result = {}
  for k, v in pairs(self.tagList) do
    table.insert(result, k)
  end
  self.tagCatalogCtrl:ResetDatas(result)
  local cells = self.tagCatalogCtrl:GetCells()
  self:handleClickCatalog(cells[1])
end

function SocialityPage:UpdateTagCatalog()
  if not self.curTags then
    return
  end
  local result = {}
  for i = 1, #self.curTags do
    local tagID = self.curTags[i]
    local config = Table_PlayerTag[tagID]
    if config then
      if not result[config.Group] then
        result[config.Group] = 1
      else
        result[config.Group] = result[config.Group] + 1
      end
    end
  end
  local cells = self.tagCatalogCtrl:GetCells()
  for i = 1, #cells do
    local count = result[i] or 0
    cells[i]:SetCount(count)
  end
  for i = 1, 3 do
    if self.curTags[i] then
      self.myTags[i].go:SetActive(true)
      self.myTags[i].label.text = Table_PlayerTag[self.curTags[i]] and Table_PlayerTag[self.curTags[i]].Name
    else
      self.myTags[i].go:SetActive(false)
    end
  end
  local appendStr = "%s(%s/3)"
  self.tagLabel.text = string.format(appendStr, ZhString.Charactor_Tag, #self.curTags or 0)
end

function SocialityPage:UpdateTagsStatus()
  local cells = self.tagCtrl:GetCells()
  for i = 1, #cells do
    if self.curTags and TableUtility.ArrayFindIndex(self.curTags, cells[i].id) > 0 then
      cells[i]:SetChoose(true)
    else
      cells[i]:SetChoose(false)
    end
    if self.unlockedTags and 0 < TableUtility.ArrayFindIndex(self.unlockedTags, cells[i].id) then
      cells[i]:SetStatus(true)
    else
      cells[i]:SetStatus(false)
    end
  end
end

function SocialityPage:InitCommonSetting()
end

function SocialityPage:OnClickMonth(data)
  self.monthPopupList.labCurrent.text = data.name
  self.monthPopupList.value = data.name
  self.curMonth = tonumber(data.name)
  self:InitDayList()
  local dayCount = dateInfo and dateInfo[self.curMonth]
  if self.curDay and dayCount < self.curDay then
    self.curDay = dayCount
  end
  self.dayPopupList.labCurrent.text = self.curDay
  self.dayPopupList.value = self.curDay
  self:UpdateConstellation()
  self:CheckConfirmStatus()
end

function SocialityPage:OnClickDay(data)
  self.dayPopupList.labCurrent.text = data.name
  self.dayPopupList.value = data.name
  self.curDay = tonumber(data.name)
  self:UpdateConstellation()
  self:CheckConfirmStatus()
end

function SocialityPage:OnClickFriendApply(data)
  self.friendapplyPopupList.labCurrent.text = data.name
  self.friendapplyPopupList.value = data.name
  self.curFriendApply = data.index
  self:CheckConfirmStatus()
end

function SocialityPage:OnClickMarry(data)
  if not self.curMarry then
    self.curMarry = MyselfProxy.Instance:GetQueryWeddingType()
    self.marryPopupList.labCurrent.text = marrySecret and marrySecret[self.curMarry]
    self.marryPopupList.value = marrySecret and marrySecret[self.curMarry]
  else
    self.curMarry = data.index
    self.marryPopupList.labCurrent.text = data.name
    self.marryPopupList.value = data.name
  end
  self:CheckConfirmStatus()
end

function SocialityPage:OnClickEquip(data)
  if not self.curEquip then
    self.curEquip = MyselfProxy.Instance:GetQueryType()
    self.equipPopupList.labCurrent.text = equipSecret and equipSecret[self.curEquip]
    self.equipPopupList.value = equipSecret and equipSecret[self.curEquip]
  else
    self.curEquip = data.index
    self.equipPopupList.labCurrent.text = data.name
    self.equipPopupList.value = data.name
  end
  self:CheckConfirmStatus()
end

function SocialityPage:OnClickTitle(cellCtl)
  local data = cellCtl and cellCtl.data
  local go = cellCtl and cellCtl.titleName
  local newChooseID = data and data.id or 0
  if self.chooseId ~= newChooseID then
    self.chooseId = newChooseID
    self:ShowTitleTip(data, go)
  else
    self.chooseId = 0
    TipManager.Instance:HideTitleTip()
  end
  self:_refreshChoose()
end

function SocialityPage:_refreshChoose()
  if not self.itemWrapHelper then
    return
  end
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local cell = cells[i]
    for j = 1, #cell.childrenObjs do
      local child = cell.childrenObjs[j]
      child:SetChoose(self.chooseId)
    end
  end
end

function SocialityPage:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function SocialityPage:handleClickCatalog(cellCtrl)
  xdlog("点击页签")
  local cells = self.tagCatalogCtrl:GetCells()
  for i = 1, #cells do
    if cells[i] == cellCtrl then
      cells[i]:SetChoose(true)
    else
      cells[i]:SetChoose(false)
    end
  end
  local id = cellCtrl and cellCtrl.id
  local tagArray = self.tagList[id]
  if not tagArray then
    return
  end
  self.tagCtrl:ResetDatas(tagArray)
  self:UpdateTagsStatus()
  local size = NGUIMath.CalculateRelativeWidgetBounds(self.tagCenterRoot.transform)
  local height = size.size.y
  if height < 100 then
    height = 100
  end
  self.tagBg.height = height + 60
end

function SocialityPage:handleClickTag(cellCtrl)
  if cellCtrl.toggle.value then
    xdlog("打钩", cellCtrl.id)
    if #self.curTags >= 3 then
      cellCtrl.toggle.value = false
      MsgManager.ShowMsgByID(43222)
      return
    else
      table.insert(self.curTags, cellCtrl.id)
    end
  else
    redlog("取消", cellCtrl.id)
    for i = 1, #self.curTags do
      if self.curTags[i] == cellCtrl.id then
        table.remove(self.curTags, i)
      end
    end
  end
  self:UpdateTagCatalog()
  self:CheckConfirmStatus()
end

function SocialityPage:HandleQueryUserInfo(note)
  local data = note.body
  if data then
    local profileData = data.profile
    if not profileData then
    end
    TableUtility.TableShallowCopy(self.curProfileData, profileData)
    self.curProfileData.label = self.curProfileData.label or {}
    self.curMonth = profileData.birthmonth == 0 and 1 or profileData.birthmonth
    self.curDay = profileData.birthday == 0 and 1 or profileData.birthday
    self.curFriendApply = profileData.needpartner == 0 and 1 or profileData.needpartner
    self.curSign = profileData.signtext or ""
    self.curTags = {}
    local testTags = ""
    for i = 1, #profileData.label do
      testTags = testTags .. profileData.label[i] .. ","
      table.insert(self.curTags, profileData.label[i])
    end
    self.unlockedTags = {}
    local testStr = ""
    for i = 1, #profileData.unlocklabels do
      testStr = testStr .. profileData.unlocklabels[i] .. ","
      table.insert(self.unlockedTags, profileData.unlocklabels[i])
    end
    self.birthUpdateTime = profileData.birthupdatetime or 0
    self.monthPopupList.labCurrent.text = self.curMonth
    self.monthPopupList.value = self.curMonth
    self.dayPopupList.labCurrent.text = self.curDay
    self.dayPopupList.value = self.curDay
    self.friendapplyPopupList.labCurrent.text = self.curFriendApply and friendStatus[self.curFriendApply] or friendStatus[1]
    self.friendapplyPopupList.value = self.curFriendApply and friendStatus[self.curFriendApply] or friendStatus[1]
    self.signInput.value = self.curSign
    local length = StringUtil.Utf8len(self.signInput.value)
    self.signCount.text = length .. "/30"
    self:CheckConfirmStatus()
    self:UpdateTagCatalog()
    self:UpdateTagsStatus()
    self:UpdateBirthdayChangeLimit()
    self:UpdateConstellation()
  end
end

function SocialityPage:UpdateBirthdayChangeLimit()
  if not self.birthUpdateTime or self.birthUpdateTime == 0 then
    return
  end
  local resetCD = GameConfig.System.birthday_resetcd or 3
  if self.birthUpdateTime + 86400 * resetCD > ServerTime.CurServerTime() / 1000 then
    self.monthPopupList:SetPopupEnable(false)
    self.dayPopupList:SetPopupEnable(false)
  end
end

function SocialityPage:UpdateConstellation()
  if not self.curMonth or not self.curDay then
    return
  end
  local constellationIndex = DateUtil.GetConstellation(self.curMonth, self.curDay)
  local config = GameConfig.Constellation[constellationIndex]
  if config then
    self.constellationIcon.spriteName = config.icon
  end
end

function SocialityPage:CheckConfirmStatus()
  local hasChange = false
  if self.curMonth ~= self.curProfileData.birthmonth then
    hasChange = true
  end
  if self.curDay ~= self.curProfileData.birthday then
    hasChange = true
  end
  if self.curFriendApply ~= self.curProfileData.needpartner then
    hasChange = true
  end
  if self.signInput.value ~= self.curProfileData.signtext then
    hasChange = true
  end
  if self.curTags and #self.curTags > 0 then
    if #self.curTags ~= #self.curProfileData.label then
      hasChange = true
    end
    for i = 1, #self.curTags do
      if not self.curProfileData.label[i] or self.curTags[i] ~= self.curProfileData.label[i] then
        hasChange = true
        break
      end
    end
  end
  if self.curMarry and self.curMarry ~= MyselfProxy.Instance:GetQueryWeddingType() then
    hasChange = true
  end
  if self.curEquip and self.curEquip ~= MyselfProxy.Instance:GetQueryType() then
    hasChange = true
  end
  if hasChange then
    self.confirmBtnIcon.spriteName = "com_btn_1"
    self.confirmBtnLab.effectColor = LuaGeometry.GetTempVector4(0 / 255, 0.12549019607843137, 0.6039215686274509, 1)
    self.confirmBtnBoxCollider.enabled = true
  else
    self.confirmBtnIcon.spriteName = "com_btn_13"
    self.confirmBtnLab.effectColor = ColorUtil.NGUIGray
    self.confirmBtnBoxCollider.enabled = false
  end
end

function SocialityPage:DoConfirm()
  local month, day, title, partner, marry, equip, sign, labels
  local dateChange = false
  local profile = {}
  if self.curProfileData.birthmonth ~= self.curMonth then
    xdlog("修改月", self.curMonth)
    dateChange = true
    month = self.curMonth
  end
  if self.curProfileData.birthday ~= self.curDay then
    xdlog("修改日", self.curDay)
    dateChange = true
    day = self.curDay
  end
  if self.curProfileData.needpartner ~= self.curFriendApply then
    xdlog("修改伙伴记录", self.curFriendApply)
    partner = self.curFriendApply
  end
  if self.curProfileData.signtext ~= self.signInput.value then
    xdlog("修改签名", self.signInput.value)
    sign = self.signInput.value
    if #sign == 0 then
      MsgManager.ShowMsgByID(43209)
      return
    end
    if FunctionMaskWord.Me():CheckMaskWord(self.signInput.value, GameConfig.MaskWord.ChatroomName) then
      MsgManager.ShowMsgByIDTable(2604)
      return
    end
  end
  profile.birthmonth = month
  profile.birthday = day
  profile.needpartner = partner
  profile.signtext = sign
  profile.label = self.curTags
  if dateChange then
    MsgManager.ConfirmMsgByID(43167, function()
      ServiceUserEventProxy.Instance:CallSetProfileUserEvent(profile)
    end)
  else
    ServiceUserEventProxy.Instance:CallSetProfileUserEvent(profile)
  end
  local commonSettingChange = false
  if self.curMarry and self.curMarry ~= MyselfProxy.Instance:GetQueryWeddingType() then
    xdlog("婚姻屏蔽不同")
    commonSettingChange = true
  end
  if self.curEquip and self.curEquip ~= MyselfProxy.Instance:GetQueryType() then
    xdlog("装备屏蔽不同")
    commonSettingChange = true
  end
  if commonSettingChange then
    local setting = {}
    setting.showWedding = self.curMarry
    setting.showDetail = self.curEquip
    LocalSaveProxy.Instance:SaveSetting(setting)
    ServiceNUserProxy.Instance:CallSetOptionUserCmd(self.curEquip, nil, self.curMarry)
  end
end
