DisneyFriendsInfoPanel = class("DisneyFriendsInfoPanel", BaseView)
DisneyFriendsInfoPanel.ViewType = UIViewType.TeamLayer
autoImport("DisneyFriendsStoryCell")
autoImport("DisneyFriendsBondCell")
autoImport("DisneyFriendAttrCell")
autoImport("PartnerAreaCell")
autoImport("DisneyFriendHeartCell")
autoImport("ManorPartnerHeadCell")
autoImport("ManorPartnerGiftCell")
local calSize = NGUIMath.CalculateRelativeWidgetBounds

function DisneyFriendsInfoPanel:Init()
  self:InitUI()
  self:AddEvts()
  self:AddListenEvts()
  self:InitData()
  self:InitShow()
end

function DisneyFriendsInfoPanel:InitUI()
  self.titleLabel = self:FindGO("Title"):GetComponent(UILabel)
  self.titleLabel.text = ZhString.DisneyFriendInfo_Title1
  local toggleGO = self:FindGO("Toggles")
  self.partnerTogGO = self:FindGO("PartnerTog")
  self.partnerTog = self:FindGO("Tog", self.partnerTogGO):GetComponent(UIToggle)
  self.partnerTogIcon = self:FindGO("Icon", self.partnerTogGO):GetComponent(UISprite)
  self.buildingTogGO = self:FindGO("BuildingTog")
  self.buildingTog = self:FindGO("Tog", self.buildingTogGO):GetComponent(UIToggle)
  self.buildingTogIcon = self:FindGO("Icon", self.buildingTogGO):GetComponent(UISprite)
  self.partnerTog.value = true
  self.friendInfoPage = self:FindGO("FriendInfoPage")
  self.friendScrollView = self:FindGO("FriendScrollView", self.friendInfoPage):GetComponent(UIScrollView)
  self.friendGrid = self:FindGO("FriendGrid", self.friendInfoPage):GetComponent(UIGrid)
  self.friendInfoScrollView = self:FindGO("InfoScrollView", self.friendInfoPage):GetComponent(UIScrollView)
  self.friendListCtrl = UIGridListCtrl.new(self.friendGrid, ManorPartnerHeadCell, "ManorPartnerHeadCell")
  self.friendListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickFriendHead, self)
  self.areaGrid = self:FindGO("AreaGrid"):GetComponent(UIGrid)
  self.areaListCtrl = UIGridListCtrl.new(self.areaGrid, PartnerAreaCell, "MiniMapSymbol")
  local friendFile = self:FindGO("File", self.friendInfoPage)
  self.friendHeadIcon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
  self.friendName = self:FindGO("Name", friendFile):GetComponent(UILabel)
  self.friendJob = self:FindGO("Job", friendFile):GetComponent(UILabel)
  self.friendArea = self:FindGO("Area", friendFile):GetComponent(UILabel)
  self.friendHobby = self:FindGO("Hobby", friendFile):GetComponent(UILabel)
  self.favorLockStatus = self:FindGO("LockStatus")
  self.opinionGrid = self:FindGO("Opinion", friendFile):GetComponent(UIGrid)
  self.favorListCtrl = UIGridListCtrl.new(self.opinionGrid, DisneyFriendHeartCell, "DisneyFriendHeartCell")
  self.picHire = self:FindGO("Pic_Hire")
  self.mainInfoTable = self:FindGO("partnerInfoTable", self.friendInfoPage):GetComponent(UITable)
  local storyInfo = self:FindGO("Story")
  self.storyGrid = self:FindGO("StoryGrid", storyInfo):GetComponent(UITable)
  self.storyInfoCtrl = UIGridListCtrl.new(self.storyGrid, DisneyFriendsStoryCell, "DisneyFriendsStoryCell")
  self.storyInfoCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickFriendStoryCell, self)
  self.storyInfoCtrl:AddEventListener(DisneyEvent.DisneyFriendStoryCellExtendClick, self.HandleClickFriendStoryCellExtend, self)
  self.storyHelpBtn = self:FindGO("Help", storyInfo)
  self.storyLongPress = self.storyHelpBtn:GetComponent(UILongPress)
  local storySprite = self.storyHelpBtn:GetComponent(UISprite)
  
  function self.storyLongPress.pressEvent(obj, state)
    xdlog("pressEvent  story")
    self:PassEvent(TipLongPressEvent.DisneyPartnerPanelStory, {state, storySprite})
  end
  
  local bondInfo = self:FindGO("Bond")
  self.bondGrid = self:FindGO("Grid", bondInfo):GetComponent(UIGrid)
  self.bondInfoCtrl = UIGridListCtrl.new(self.bondGrid, DisneyFriendsBondCell, "DisneyFriendsBondCell")
  self.bondInfoCtrl:AddEventListener(TipLongPressEvent.DisneyPartnerPanelBond, self.HandleBondLongPress, self)
  self.bondInfoCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickBondCell, self)
  self.bondHelpBtn = self:FindGO("Help", bondInfo)
  self.bondLongPress = self.bondHelpBtn:GetComponent(UILongPress)
  local bondSprite = self.bondHelpBtn:GetComponent(UISprite)
  
  function self.bondLongPress.pressEvent(obj, state)
    self:PassEvent(TipLongPressEvent.DisneyPartnerPanelBond, {state, bondSprite})
  end
  
  self.summaryPage = self:FindGO("SummaryPage")
  self.itemScrollView = self:FindGO("ItemScrollView", self.summaryPage)
  self.summaryItemGrid = self:FindGO("ItemGrid", self.summaryPage):GetComponent(UIGrid)
  self.giftListCtrl = UIGridListCtrl.new(self.summaryItemGrid, ManorPartnerGiftCell, "RewardGridCell")
  self.giftListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickGiftCell, self)
  self.summaryInfoScrollView = self:FindGO("InfoScrollView", self.summaryPage):GetComponent(UIScrollView)
  self.summaryInfoTable = self:FindGO("InfoTable", self.summaryPage):GetComponent(UITable)
  local versionInfo = self:FindGO("VersionInfo", self.summaryPage)
  self.versionInfoGrid = self:FindGO("VersionInfoGrid"):GetComponent(UIGrid)
  self.versionInfoCtrl = UIGridListCtrl.new(self.versionInfoGrid, DisneyFriendAttrCell, "DisneyFriendAttrCell")
  self.versionNonetip = self:FindGO("NoneTip", versionInfo)
  self.versionClickBtn = self:FindGO("ClickBtn", versionInfo)
  local personInfo = self:FindGO("PersonalInfo", self.summaryPage)
  personInfo:SetActive(false)
  self.helpBtn = self:FindGO("HelpBtn")
  self.closeBtn = self:FindGO("CloseBtn")
end

function DisneyFriendsInfoPanel:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function DisneyFriendsInfoPanel:AddEvts()
  self:TryOpenHelpViewById(35068, nil, self.helpBtn)
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.partnerTogGO, function()
    self:UpdatePagesShow(1)
  end)
  self:AddClickEvent(self.buildingTogGO, function()
    self:UpdatePagesShow(2)
  end)
  self:AddClickEvent(self.versionClickBtn, function()
    self.versionInfoGrid.gameObject:SetActive(not self.versionInfoGrid.gameObject.activeSelf)
    self.summaryInfoTable:Reposition()
  end)
end

function DisneyFriendsInfoPanel:AddListenEvts()
  self:AddEventListener(TipLongPressEvent.DisneyPartnerPanelStory, self.HandleStoryLongPress, self)
  self:AddEventListener(TipLongPressEvent.DisneyPartnerPanelBond, self.HandleBondLongPress, self)
  self:AddListenEvt(ServiceEvent.SceneManorPartnerInfoManorCmd, self.HandleRefreshPartnerPage)
  self:AddListenEvt(RedTipProxy.RemoveRedTipEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.HandleRedTipUpdate)
  self:AddListenEvt(RedTipProxy.UpdateRedTipEvent, self.HandleRedTipUpdate)
end

function DisneyFriendsInfoPanel:HandleStoryLongPress(param)
  local isPressing, sprite = param[1], param[2]
  local Desc = Table_Help[35058] and Table_Help[35058].Desc or ZhString.Help_RuleDes
  TabNameTip.OnLongPress(isPressing, Desc, false, sprite)
end

function DisneyFriendsInfoPanel:HandleBondLongPress(param)
  local isPressing, cellCtrl = param[1], param[2]
  local sprite = cellCtrl.bgSprite
  local composeId = cellCtrl.id
  local composeData = Table_ManorPartnerCompose[composeId]
  local composeDesc = composeData and composeData.UnlockDesc or "还没写还没写还没写还没写还没写还没写还没写还没写"
  TabNameTip.OnLongPress(isPressing, composeDesc, false, sprite, NGUIUtil.AnchorSide.Right, {-450, 0})
end

function DisneyFriendsInfoPanel:HandleClickBondCell(cellCtrl)
  local unlock = cellCtrl.data.unlock
  if not unlock then
    local composeId = cellCtrl.id
    local composeData = Table_ManorPartnerCompose[composeId]
    local composeDesc = composeData and composeData.UnlockDesc or "还没写还没写还没写还没写还没写还没写还没写还没写"
    MsgManager.FloatMsg(nil, composeDesc)
  end
end

function DisneyFriendsInfoPanel:HandleClickFriendHead(cell)
  xdlog("HandleClickFriendHead", cell.id)
  local partnerId = cell.id
  self:RefreshParnerInfo(partnerId)
  if self.curFriendHeadCell ~= cell then
    if self.curFriendHeadCell then
      self.curFriendHeadCell:SetChoose(false)
    end
    self.curFriendHeadCell = cell
    self.curFriendHeadCell:SetChoose(true)
  else
    self.curFriendHeadCell = cell
  end
  self.curTargetId = partnerId
end

function DisneyFriendsInfoPanel:HandleClickFriendStoryCell(cell)
  local partnerId = cell.data.partnerid
  local storyId = cell.data.id
  xdlog("call - >PartnerStroyManorCmd", partnerId, storyId)
  ServiceSceneManorProxy.Instance:CallPartnerStroyManorCmd(partnerId, storyId)
end

function DisneyFriendsInfoPanel:HandleClickFriendStoryCellExtend(cellCtrl)
  cellCtrl:SetExtendStatus()
  self.storyGrid:Reposition()
  self.mainInfoTable:Reposition()
end

function DisneyFriendsInfoPanel:InitShow()
  xdlog("初次打开界面")
  self.friendInfoPage:SetActive(true)
  self.summaryPage:SetActive(false)
  local partnerList = {}
  for i = 1, #Table_ManorPartner do
    local isUnlock = ManorPartnerProxy.Instance:GetPartnerInfo(Table_ManorPartner[i].PartnerId)
    local data = {
      id = Table_ManorPartner[i].PartnerId
    }
    if isUnlock then
      data.isUnlock = true
    else
      data.isUnlock = false
    end
    table.insert(partnerList, data)
  end
  self.friendListCtrl:ResetDatas(partnerList)
  local cells = self.friendListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:RegisterRedtip()
  end
  local unlockedPartnerList = ManorPartnerProxy.Instance:GetPartnerList()
  for k, v in pairs(unlockedPartnerList) do
    self.curTargetId = k
    break
  end
  local targetId = self.curTargetId or Table_ManorPartner[1].PartnerId
  local cells = self.friendListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i].id == targetId then
      cells[i]:SetChoose(true)
      self.curFriendHeadCell = cells[i]
    end
  end
  self:RefreshParnerInfo(targetId)
  self:RefreshBuildingInfo()
end

function DisneyFriendsInfoPanel:HandleRedTipUpdate()
  local cells = self.friendListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:RegisterRedtip()
  end
end

function DisneyFriendsInfoPanel:HandleRefreshPartnerPage()
  if not self.curTargetId then
    local unlockedPartnerList = ManorPartnerProxy.Instance:GetPartnerList()
    local targetId = 1
    for k, v in pairs(unlockedPartnerList) do
      self.curTargetId = k
      break
    end
  end
  self:RefreshParnerInfo(self.curTargetId or Table_ManorPartner[1].PartnerId)
end

function DisneyFriendsInfoPanel:UpdatePagesShow(index)
  if index == 1 then
    self.partnerTog.value = true
    self.partnerTogIcon.color = LuaGeometry.GetTempVector4(0.41568627450980394, 0.47843137254901963, 0.6078431372549019, 1)
    self.buildingTogIcon.color = LuaGeometry.GetTempVector4(0.5686274509803921, 0.6196078431372549, 0.7176470588235294, 1)
    self.friendInfoPage:SetActive(true)
    self.summaryPage:SetActive(false)
    self.titleLabel.text = ZhString.DisneyFriendInfo_Title1
  elseif index == 2 then
    self.buildingTog.value = true
    self.partnerTogIcon.color = LuaGeometry.GetTempVector4(0.5686274509803921, 0.6196078431372549, 0.7176470588235294, 1)
    self.buildingTogIcon.color = LuaGeometry.GetTempVector4(0.41568627450980394, 0.47843137254901963, 0.6078431372549019, 1)
    self.friendInfoPage:SetActive(false)
    self.summaryPage:SetActive(true)
    self.titleLabel.text = ZhString.DisneyFriendInfo_Title2
  end
end

function DisneyFriendsInfoPanel:RefreshParnerInfo(id)
  local partnerInfo = ManorPartnerProxy.Instance:GetPartnerInfo(id)
  local friendData
  for i = 1, #Table_ManorPartner do
    local single = Table_ManorPartner[i]
    if single.PartnerId == id then
      friendData = single
    end
  end
  if not friendData then
    redlog("ManorPartner表缺少ID")
    return
  end
  local partnerId = friendData.PartnerId
  local icon = Table_Npc[partnerId].Icon
  IconManager:SetFaceIcon(icon, self.friendHeadIcon)
  self.friendName.text = string.format(ZhString.DisneyFriendInfo_Name, friendData.Desc)
  self.friendHobby.text = string.format(ZhString.DisneyFriendInfo_Habit, friendData.Habit)
  local areaList = friendData.Area
  self.areaListCtrl:ResetDatas(areaList)
  local favorConfig = friendData.Favors
  if partnerInfo then
    local curMaxfavor = partnerInfo.maxFavor
    local curFavor = partnerInfo.favor
    local step1Favor = favorConfig[1]
    local maxFavor = favorConfig[2]
    local favorReward = friendData.FavorReward
    local favorRewardList = {}
    if favorReward and 0 < #favorReward then
      for i = 1, #favorReward do
        local a, b = math.modf(favorReward[i][1] / 4)
        favorRewardList[a] = 1
      end
    end
    local totalHeart = 0
    if maxFavor == curMaxfavor then
      totalHeart = math.modf(maxFavor / 4)
      self.favorLockStatus:SetActive(false)
    else
      totalHeart = math.modf(step1Favor / 4)
      self.favorLockStatus:SetActive(true)
      self.favorLockStatus.transform.localPosition = LuaGeometry.GetTempVector3(-130 + totalHeart * 39, -43.6, 0)
    end
    self.favorListCtrl:SetEmptyDatas(totalHeart)
    local cells = self.favorListCtrl:GetCells()
    for i = 1, #cells do
      if favorRewardList[i] then
        cells[i]:SetGiftStatus(true)
      end
      if curFavor < i * 4 then
        cells[i]:SetHeartNum(curFavor - (i - 1) * 4)
      else
        cells[i]:SetHeartNum(4)
      end
    end
  else
    local step1Favor = favorConfig[1]
    local maxFavor = favorConfig[2]
    local totalHeart = math.modf(step1Favor / 4)
    self.favorListCtrl:SetEmptyDatas(totalHeart)
    self.favorLockStatus:SetActive(step1Favor ~= maxFavor)
    self.favorLockStatus.transform.localPosition = LuaGeometry.GetTempVector3(-130 + totalHeart * 39, -43.6, 0)
    local cells = self.favorListCtrl:GetCells()
    for i = 1, #cells do
      cells[i]:SetHeartNum(0)
    end
  end
  self.favorListCtrl:Layout()
  self.picHire:SetActive(partnerInfo ~= nil)
  local storyList = friendData.StoryList
  local partnerStoryList = partnerInfo and partnerInfo.stories
  local tempList = {}
  for i = 1, #storyList do
    local storyid = storyList[i]
    local isLock = true
    local isRead = false
    if partnerStoryList then
      for j = 1, #partnerStoryList do
        if partnerStoryList[j].id == storyid then
          isLock = false
          isRead = partnerStoryList[j].read
        end
      end
    end
    local data = {
      id = storyid,
      read = isRead,
      partnerid = partnerId
    }
    data.lock = isLock
    table.insert(tempList, data)
  end
  self.storyInfoCtrl:ResetDatas(tempList)
  local composesList = ManorPartnerProxy.Instance:GetPartnerCompose(partnerId)
  local unlockedParterComposes = partnerInfo and partnerInfo.composes
  local tempComposeList = {}
  if composesList then
    for k, v in pairs(composesList) do
      local data = {id = k}
      if unlockedParterComposes then
        if 0 < TableUtility.ArrayFindIndex(unlockedParterComposes, k) then
          data.unlock = true
        else
          data.unlock = false
        end
      else
        data.unlock = false
      end
      table.insert(tempComposeList, data)
    end
  end
  self.bondInfoCtrl:ResetDatas(tempComposeList)
  self.mainInfoTable:Reposition()
end

function DisneyFriendsInfoPanel:RefreshBuildingInfo()
  if not Table_ManorPartner then
    return
  end
  local giftList, tempList, favorItem = {}, {}
  for _, favorItems in pairs(ComodoBuildingProxy.Instance.partnerFavoredItemsMap) do
    for i = 1, #favorItems do
      favorItem = favorItems[i][1]
      if not giftList[favorItem] then
        giftList[favorItem] = BagProxy.Instance:GetItemNumByStaticID(favorItem, GameConfig.PackageMaterialCheck.Exist)
        table.insert(tempList, favorItem)
      end
    end
  end
  self.giftListCtrl:ResetDatas(tempList)
  local buildingResult = ComodoBuildingProxy.Instance:GetAllBuildingEffect()
  local buildingMapEffectResult = ComodoBuildingProxy.Instance:GetAllBuildingMapEffect()
  local composesEffectResult = ManorPartnerProxy.Instance:GetAllUnlockedComposesAttr()
  self.versionNonetip:SetActive(#buildingResult == 0 and #buildingMapEffectResult == 0 and #composesEffectResult == 0)
  for i = 1, #buildingMapEffectResult do
    TableUtility.ArrayPushBack(buildingResult, buildingMapEffectResult[i])
  end
  if composesEffectResult then
    for i = 1, #composesEffectResult do
      TableUtility.ArrayPushBack(buildingResult, composesEffectResult[i])
    end
  end
  self.versionInfoCtrl:ResetDatas(buildingResult)
  self.summaryInfoTable:Reposition()
end

function DisneyFriendsInfoPanel:HandleClickGiftCell(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = ItemData.new("Reward", cellCtrl.data)
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {200, -150})
  end
end
