AdventureHomePage = class("AdventureHomePage", SubView)
autoImport("AdventureProfessionCell")
autoImport("AdventureCollectionAchShowCell")
autoImport("AdventureAchievementCell")
autoImport("AdventureRewardPanel")
autoImport("AdventureFriendCell")
autoImport("Charactor")
autoImport("AdventureAttrSpecCell")
autoImport("AdventureHomeUserDataCell")
autoImport("AdventureHomeSkillCell")
autoImport("AdventureHomeSkillTipCell")
autoImport("AdventureBriefSummaryCell")
local blueColor = Color(0.24313725490196078, 0.34901960784313724, 0.6549019607843137, 1)
local greyColor = Color(0.5490196078431373, 0.5490196078431373, 0.5490196078431373, 1)
local tempArray = {}
local maxWidth = 460
local spacingY = 8
AdventureHomePage.ProfessionIconClick = "ProfessionPage_ProfessionIconClick"

function AdventureHomePage:Init()
  self:initView()
  self:addViewEventListener()
  self:AddListenerEvts()
  self:initData()
end

function AdventureHomePage:initView()
  self.gameObject = self:FindGO("AdventureHomePage")
  self.playerName = self:FindGO("UserName"):GetComponent(UILabel)
  self.manualPoint = self:FindComponent("manualPoint", UILabel)
  self.manualLevel = self:FindComponent("manualLevel", UILabel)
  self.achievementScoreSlider = self:FindGO("progressCt", self:FindGO("achievementCt")):GetComponent(UISlider)
  self.achievementCurScore = self:FindGO("curScore", self:FindGO("achievementCt")):GetComponent(UILabel)
  local rewardLabel = self:FindGO("rewardLabel"):GetComponent(UILabel)
  self.levelGrid = self:FindGO("levelGrid"):GetComponent(UIGrid)
  rewardLabel.text = ZhString.AdventureRewardPanel_RewardLabel
  self.friendScrollview = self:FindGO("friendRankCt")
  self.friendScrollview = self:FindComponent("content", UIScrollView, self.friendScrollview)
  self.myRank = self:FindComponent("myRank", UILabel)
  self.loading = self:FindGO("Loading")
  local ContentContainer = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = ContentContainer,
    pfbNum = 7,
    cellName = "AdventureFriendCell",
    control = AdventureFriendCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  local profileScrollGO = self:FindGO("ProfileCt")
  self.profileScrollView = profileScrollGO:GetComponent(UIScrollView)
  local profileTableGO = self:FindGO("ProfileTable")
  self.profileTable = profileTableGO:GetComponent(UITable)
  self.descText = self:FindComponent("DescriptionText", UILabel, profileScrollGO)
  self.descHelpBtnGO = self:FindGO("DescHelp", profileScrollGO)
  self.descTipGO = self:FindGO("DescTip", profileScrollGO)
  self.descTipGO:SetActive(true)
  self.descTipText = self:FindComponent("Label", UILabel, self.descTipGO)
  self.descTipText.text = ZhString.AdventureHomePage_AppellationTip
  self.descTipText:ProcessText()
  self.descTipBg = self:FindComponent("Bg", UISprite, self.descTipGO)
  self.descTipBg:UpdateAnchors()
  self.descTipGO:SetActive(false)
  self:AddClickEvent(self.descHelpBtnGO, function()
    self.descTipGO:SetActive(true)
  end)
  self.briefDataGO = self:FindGO("BriefUserData", profileScrollGO)
  local briefDataGrid = self:FindComponent("UserDataGrid", UIGrid, self.briefDataGO)
  self.briefDataCtrl = ListCtrl.new(briefDataGrid, AdventureHomeUserDataCell, "Adventure/AdventureHomeUserDataCell")
  self.briefDataCtrl:SetNoScrollView(true)
  self.nextLevelDesc = self:FindComponent("NextLevelDesc", UILabel, profileScrollGO)
  self.adventureSkillContainerGO = self:FindGO("AdventureSkill", profileScrollGO)
  local adventureSkillGrid = self:FindComponent("SkillGrid", UIGrid, self.adventureSkillContainerGO)
  self.adventureSkillCtrl = ListCtrl.new(adventureSkillGrid, ProfessionSkillCell, "ProfessionSkillCell")
  self.adventureSkillCtrl:AddEventListener(MouseEvent.MouseClick, self.OnAdventureSkillClicked, self)
  local gotoLearnSkillBtnGO = self:FindGO("GotoBtn", self.adventureSkillContainerGO)
  self:AddClickEvent(gotoLearnSkillBtnGO, function()
    if self.skillBtnIcon.CurrentState == 0 then
      FuncShortCutFunc.Me():CallByID(27)
    else
      local achData = MyselfProxy.Instance:GetCurManualAppellation()
      if achData then
        local nextAchData = Table_Appellation[achData.staticData.PostID]
        if nextAchData then
          MsgManager.ShowMsgByID(569, nextAchData.Name)
        end
      end
    end
  end)
  self.skillBtnIcon = self:FindComponent("Sprite", UIMultiSprite, gotoLearnSkillBtnGO)
  self.skillBtnLab = self:FindComponent("Label", UILabel, gotoLearnSkillBtnGO)
  self.skillTipStick = self:FindComponent("SkillTipStick", UIWidget)
  self.skillTipOffset = {180, 0}
  self.skillBordGO = self:FindGO("SkillBord")
  self.skillBordClickOtherPlace = self.skillBordGO:GetComponent(CloseWhenClickOtherPlace)
  local skillBordWrapper = self:FindGO("LevelWrapper", self.skillBordGO)
  local skillBordConfig = {
    wrapObj = skillBordWrapper,
    pfbNum = 6,
    cellName = "Adventure/AdventureHomeSkillTipCell",
    control = AdventureHomeSkillTipCell,
    dir = 1
  }
  self.skillBordCtl = WrapCellHelper.new(skillBordConfig)
  self.skillBordCtl:AddEventListener(UICellEvent.OnCellClicked, self.OnAdventureSkillClicked, self)
  self:Hide(self.skillBordGO)
  self.propBord = self:FindGO("PropBord")
  local proptyBtn = self:FindGO("proptyBtn")
  local lable = self:FindComponent("Label", UILabel, proptyBtn)
  lable.text = ZhString.AdventureHomePage_PropBordBtn
  IconManager:SetUIIcon("123", self:FindComponent("Sprite", UISprite, proptyBtn))
  self:AddClickEvent(proptyBtn, function()
    if PvpProxy.Instance:IsFreeFire() then
      MsgManager.ShowMsgByIDTable(26259)
      return
    end
    self:showPropView()
  end)
  self.oneClickActivateBtn = self:FindGO("oneClickActivateBtn")
  self.oneClickFakeActivateBtn = self:FindGO("oneClickFakeActivateBtn")
  self:AddClickEvent(self.oneClickActivateBtn, function()
    self:CallOneClickActivate()
  end)
  self:AddButtonEvent("PropBordClose", function()
    self:Hide(self.propBord)
  end)
  self.oneClickForbid = FunctionUnLockFunc.CheckForbiddenByFuncState("adventureOneClick_forbidden")
  if self.oneClickForbid then
    proptyBtn.transform.localPosition = LuaGeometry.GetTempVector3(-280, -142, 0)
    self.oneClickActivateBtn:SetActive(false)
    self.oneClickFakeActivateBtn:SetActive(false)
  end
  self:RegistShowGeneralHelpByHelpID(100001, self:FindGO("PropBordHelp"))
  lable = self:FindComponent("PropBordTitle", UILabel)
  lable.text = ZhString.AdventureHomePage_PropBordTitleDes
  lable = self:FindComponent("emptyDes", UILabel)
  lable.text = ZhString.AdventureHomePage_EmptyPropDes
  self.emptyCt = self:FindGO("emptyCt")
  self.appellationPropCt = self:FindGO("AppellationPropCt")
  self.applationTitle = self:FindComponent("title", UILabel, self.appellationPropCt)
  self.appellationGrid = self:FindComponent("Grid", UIGrid, self.appellationPropCt)
  self.appellationListCtrl = UIGridListCtrl.new(self.appellationGrid, AdventureAttrSpecCell, "AdventureAttrCell")
  
  function self.appellationGrid.onReposition()
    local cells = self.appellationListCtrl:GetCells()
    self:LayoutProps(cells, self.appellationGrid)
  end
  
  self.adventurePropCt = self:FindGO("AdventurePropCt")
  local title = self:FindComponent("title", UILabel, self.adventurePropCt)
  title.text = ZhString.AdventureHomePage_PropBordPropTitleDes
  self.adventurePropGrid = self:FindComponent("Grid", UIGrid, self.adventurePropCt)
  self.adventurePropListCtrl = UIGridListCtrl.new(self.adventurePropGrid, AdventureAttrSpecCell, "AdventureAttrCell")
  
  function self.adventurePropGrid.onReposition()
    local cells = self.adventurePropListCtrl:GetCells()
    self:LayoutProps(cells, self.adventurePropGrid)
  end
  
  self.briefSummaryCt = self:FindGO("briefSummaryCt")
  self.briefSummaryScrollview = self:FindComponent("ScrollView", UIScrollView, self.briefSummaryCt)
  local table = self:FindComponent("ctTable", UITable, self.briefSummaryCt)
  self.bsCtl = UIGridListCtrl.new(table, AdventureBriefSummaryCell, "AdventureBriefSummaryCell")
  self.bsCtl:AddEventListener(AdventureBriefSummaryCell.UIEvent.ClickShowAttr, self.AdventureBriefSummaryCell_ClickShowAttr, self)
  self.bsCtl:AddEventListener(AdventureBriefSummaryCell.UIEvent.ClickGoto, self.AdventureBriefSummaryCell_ClickGoto, self)
end

function AdventureHomePage:OnAdventureSkillClicked(cell)
  local skillId = cell and cell.data
  if skillId then
    local skillItemData = SkillItemData.new(skillId)
    local tip = TipManager.Instance:ShowSkillStickTip(skillItemData, self.skillTipStick, NGUIUtil.AnchorSide.Right, self.skillTipOffset)
    if tip and self.skillBordGO.activeInHierarchy then
      self.skillBordClickOtherPlace:AddTarget(tip.gameObject.transform)
    end
  end
end

function AdventureHomePage:ShowAllAdventureSkill()
  self:Show(self.skillBordGO)
  local proxy = AdventureDataProxy.Instance
  local myLevel = proxy:getManualLevel()
  local datas, startIndex = proxy:GetAllAdventureSkillDatas(myLevel)
  self.skillBordCtl:UpdateInfo(datas)
  if startIndex and 0 < startIndex then
    self.skillBordCtl:SetStartPositionByIndex(startIndex, true)
  end
end

function AdventureHomePage:Show(target, plzDontRefresh)
  AdventureHomePage.super.Show(self, target)
  if plzDontRefresh then
    return
  end
  self:setCurrentAchIcon()
  self:UpdateNextLevelDesc()
  self:UpdateBriefUserData()
  self:UpdateAdventureSkills()
  self.profileTable:Reposition()
  self:UpdateBriefSummaryList(true)
end

function AdventureHomePage:initData()
  self.playerName.text = Game.Myself.data:GetName()
  self.manualScore = nil
end

function AdventureHomePage:SetData()
  self:setCurrentAchIcon()
  self:setAchievementScore()
  self:showScoreUpdateAnim()
  self:UpdateOneClickActivate()
  self:UpdateNextLevelDesc()
  self:UpdateBriefUserData()
  self:UpdateAdventureSkills()
  self.profileTable:Reposition()
  self:UpdateBriefSummaryList()
end

function AdventureHomePage:GetCurrentLevelAdventureSkillDatas(filter)
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local skills = AdventureDataProxy.Instance:getAdventureSkillByAppellation(achData.staticData.id)
    if skills and 0 < #skills then
      TableUtility.ArrayClear(tempArray)
      local profession = MyselfProxy.Instance:GetMyProfession()
      for i, skill in ipairs(skills) do
        if not filter or filter(skill) then
          tempArray[i] = {
            [1] = profession,
            [2] = skill
          }
        end
      end
      return tempArray
    end
  end
end

function AdventureHomePage:HaveAllSkillsBeLearned(skills)
  if skills then
    for _, skill in ipairs(skills) do
      if skill[2] and not FuncAdventureSkill.Instance():SkillIsHaveLearned(skill[2]) then
        return false
      end
    end
  end
  return true
end

function AdventureHomePage:GetNextLevelAdventureSkillDatas()
  local proxy = AdventureDataProxy.Instance
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local skills = proxy:getAdventureSkillByAppellation(achData.staticData.PostID)
    if skills and 0 < #skills then
      TableUtility.ArrayClear(tempArray)
      local profession = MyselfProxy.Instance:GetMyProfession()
      for i, skill in ipairs(skills) do
        tempArray[i] = {
          [1] = profession,
          [2] = skill
        }
      end
      return tempArray
    end
  end
end

function AdventureHomePage:UpdateAdventureSkills()
  local skillDatas = self:GetCurrentLevelAdventureSkillDatas()
  if skillDatas and 0 < #skillDatas and not self:HaveAllSkillsBeLearned(skillDatas) then
    self.adventureSkillContainerGO:SetActive(true)
    self.skillBtnIcon.CurrentState = 0
    self.skillBtnLab.color = blueColor
  else
    skillDatas = self:GetNextLevelAdventureSkillDatas()
    if skillDatas and 0 < #skillDatas then
      self.adventureSkillContainerGO:SetActive(true)
      self.skillBtnIcon.CurrentState = 1
      self.skillBtnLab.color = greyColor
    else
      self.adventureSkillContainerGO:SetActive(false)
    end
  end
  self.adventureSkillCtrl:ResetDatas(skillDatas or {})
end

function AdventureHomePage:unlockAdventureSkills()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local skills = AdventureDataProxy.Instance:getAdventureSkillByAppellation(achData.staticData.PostID)
    return skills
  end
end

function AdventureHomePage:showScoreUpdateAnim()
  self:setAchievementScore()
  local curScore = AdventureDataProxy.Instance:getPointData()
  if self.manualScore and curScore ~= self.manualScore then
    local score = curScore - self.manualScore
    if score < 0 then
      local manualLevel = AdventureDataProxy.Instance:getManualLevel()
      if Table_AdventureLevel[manualLevel - 1] then
        score = curScore + Table_AdventureLevel[manualLevel - 1].AdventureExp - self.manualScore
      end
    end
    MsgManager.ShowMsgByIDTable(44, {score})
  end
  self.manualScore = curScore
end

function AdventureHomePage:setCurrentAchIcon()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if achData then
    local manualLevel = AdventureDataProxy.Instance:getManualLevel()
    local itemData = Table_Item[achData.id]
    if itemData then
      self.descText.text = string.format(ZhString.AdventureHomePage_AppellationDes, itemData.NameZh)
      self.descText:ProcessText()
      self.manualLevel.text = string.format(ZhString.AdventureHomePage_manualLevel, manualLevel)
    else
      errorLog("AdventureHomePage:setCurrentAchIcon can't find ItemData by id:", achData.id)
    end
  else
    errorLog("AdventureHomePage:appellation is nil")
  end
end

function AdventureHomePage:setCollectionAchievement()
end

function AdventureHomePage:OnEnter()
  AdventureHomePage.super.OnEnter(self)
  self:setAchievementScore()
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(true)
  self:setFriendAdData(true)
  self:UpdateHead()
  self:initScoreData()
  self:UpdateOneClickActivate()
end

function AdventureHomePage:initScoreData()
  local curScore = AdventureDataProxy.Instance:getPointData()
  self.manualScore = curScore
end

function AdventureHomePage:OnExit()
  self.manualScore = nil
  ServiceSessionSocialityProxy.Instance:CallFrameStatusSocialCmd(false)
  AdventureHomePage.super.OnExit(self)
end

function AdventureHomePage:OnDestroy()
  self.itemWrapHelper:Destroy()
  self.appellationGrid.onReposition = nil
  self.adventurePropGrid.onReposition = nil
  AdventureHomePage.super.OnDestroy(self)
end

function AdventureHomePage:UpdateNextLevelDesc()
  local descList = {}
  local proxy = AdventureDataProxy.Instance
  local manualLevel = proxy:getManualLevel()
  local nextLevel = proxy:getNextAdventureLevelProp(manualLevel)
  if nextLevel ~= "" then
    table.insert(descList, string.format(ZhString.AdventureHomePage_ThirdContentTitle, manualLevel, manualLevel + 1, nextLevel))
  else
    table.insert(descList, string.format(ZhString.AdventureHomePage_ThirdContentTitle, manualLevel, manualLevel + 1, "Max"))
  end
  local sRet = proxy:getNextAppellationProp()
  local achData = MyselfProxy.Instance:GetCurManualAppellation()
  if sRet ~= "" then
    local needLv = GameConfig.AdventureAppellationLevel and GameConfig.AdventureAppellationLevel[achData.staticData.PostID]
    table.insert(descList, string.format(ZhString.AdventureHomePage_FourThContentTitle, needLv, sRet))
  end
  self.nextLevelDesc.text = table.concat(descList, "\n")
  self.nextLevelDesc:ProcessText()
end

local briefUserDataNames = {
  "Str",
  "Agi",
  "Vit",
  "Int",
  "Dex",
  "Luk",
  "Hp",
  "Sp",
  "Atk",
  "Def",
  "MAtk",
  "MDef",
  "MoveSpdPer",
  "Cri"
}

function AdventureHomePage:UpdateBriefUserData()
  local proxy = AdventureDataProxy.Instance
  local filterNames = GameConfig.BriefUserPropNames or briefUserDataNames
  local datas = proxy:GetAppellationPropsWithNames(filterNames)
  if datas and 0 < #datas then
    self.briefDataGO:SetActive(true)
    self.briefDataCtrl:ResetDatas(datas)
  else
    self.briefDataGO:SetActive(false)
  end
end

function AdventureHomePage:setAchievementScore()
  local score = AdventureDataProxy.Instance:getPointData()
  local curAch = AdventureDataProxy.Instance:getCurAchievement()
  local nextScore = curAch.AdventureExp
  local manualLevel = AdventureDataProxy.Instance:getManualLevel()
  manualLevel = StringUtil.StringToCharArray(tostring(manualLevel))
  Game.GameObjectUtil:DestroyAllChildren(self.levelGrid.gameObject)
  for i = 1, #manualLevel do
    local obj = GameObject("tx")
    obj.transform:SetParent(self.levelGrid.transform, false)
    obj.layer = self.levelGrid.gameObject.layer
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    local sprite = obj:AddComponent(UISprite)
    sprite.depth = 100
    local atlas = RO.AtlasMap.GetAtlas("NewCom")
    sprite.atlas = atlas
    sprite.spriteName = string.format("txt_%d", manualLevel[i])
    sprite:MakePixelPerfect()
  end
  self.levelGrid:Reposition()
  self.achievementCurScore.text = score .. "/" .. nextScore
  self.achievementScoreSlider.value = score / nextScore
  if self.manualPoint then
    self:Hide(self.manualPoint.gameObject)
  end
end

function AdventureHomePage:addViewEventListener()
end

function AdventureHomePage:AddListenerEvts()
  self:AddListenEvt(AdventureDataEvent.SceneManualQueryManualData, self.QueryManualHandler)
  self:AddListenEvt(AdventureDataEvent.SceneManualManualUpdate, self.ManualUpdateHandler)
  self:AddListenEvt(ServiceEvent.SceneManualPointSync, self.showScoreUpdateAnim)
  self:AddListenEvt(SceneUserEvent.LevelUp, self.LevelUp)
  self:AddListenEvt(ServiceEvent.UserEventNewTitle, self.setCurrentAchIcon)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.setFriendAdData)
  self:AddListenEvt(ServiceEvent.AchieveCmdNewAchieveNtfAchCmd, self.NewAchieveNtfAchCmdHandler)
  self:AddListenEvt(ServiceEvent.SceneFoodNewFoodDataNtf, self.NewFoodDataNtfHandler)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTwelveLaunch)
end

function AdventureHomePage:HandleTwelveLaunch(note)
  self:Hide(self.propBord)
end

function AdventureHomePage:QueryManualHandler(note)
  self:setFriendAdData(false)
  self:SetData()
end

function AdventureHomePage:ManualUpdateHandler(note)
  self:SetData()
end

function AdventureHomePage:NewAchieveNtfAchCmdHandler(note)
  local datas = note.body
  if datas ~= nil then
    local dirty = false
    for i = 1, #datas.items do
      if datas.items[i].finishtime > 0 then
        dirty = true
        break
      end
    end
    if dirty then
      self:SetData()
    end
  end
end

function AdventureHomePage:NewFoodDataNtfHandler(note)
  self:SetData()
end

function AdventureHomePage:LevelUp(note)
  if note.type == SceneUserEvent.ManualLevelUp then
    FloatingPanel.Instance:ShowManualUp()
  end
end

function AdventureHomePage:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideLevel()
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByLPlayer(Game.Myself)
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end

function AdventureHomePage:setFriendAdData(resetPos)
  local isQuerySocialData = ServiceSessionSocialityProxy.Instance:IsQuerySocialData()
  local friends = {
    unpack(FriendProxy.Instance:GetFriendData())
  }
  if isQuerySocialData then
    local data = {}
    data.myself = true
    data.adventureLv = AdventureDataProxy.Instance:getManualLevel()
    data.adventureExp = AdventureDataProxy.Instance:getPointData()
    data.guid = Game.Myself.data.id
    data.appellation = ""
    data.name = Game.Myself.data:GetName()
    local achData = MyselfProxy.Instance:GetCurManualAppellation()
    if achData then
      data.appellation = achData.id
    end
    table.insert(friends, data)
    table.sort(friends, function(l, r)
      if l.adventureLv == r.adventureLv then
        if l.adventureExp == r.adventureExp then
          return l.guid > r.guid
        else
          return l.adventureExp > r.adventureExp
        end
      else
        return l.adventureLv > r.adventureLv
      end
    end)
    for i = 1, #friends do
      local single = friends[i]
      single.rank = i
      if single.myself then
        self.myRank.text = string.format(ZhString.AdventureHomePage_MyRank, i)
      end
    end
    self.itemWrapHelper:UpdateInfo(friends)
    if resetPos then
      self.friendScrollview:ResetPosition()
      self.itemWrapHelper:ResetPosition()
    end
  end
  self.loading:SetActive(not isQuerySocialData)
end

local sortFunc = function(l, r)
  local lprop = l.prop
  local rprop = r.prop
  return lprop.id < rprop.id
end

function AdventureHomePage:showPropView(hideAppellationProp, AdventurePropBriefType, plzDontRefresh)
  self.propBord:SetActive(not self.propBord.activeSelf)
  if self.propBord.activeSelf then
    local approps = AdventureDataProxy.Instance:GetAppellationProp()
    table.sort(approps, sortFunc)
    local x, y, z = LuaGameObject.GetLocalPosition(self.appellationPropCt.transform)
    local apSize = #approps
    if apSize == 0 or hideAppellationProp then
      self:Hide(self.appellationPropCt)
    else
      local appData = MyselfProxy.Instance:GetCurManualAppellation()
      self.applationTitle.text = string.format(ZhString.AdventureHomePage_PropBordAppllationTitleDes, appData.staticData.Name)
      self.appellationListCtrl:ResetDatas(approps)
      self:Show(self.appellationPropCt, plzDontRefresh)
      local bd = NGUIMath.CalculateRelativeWidgetBounds(self.appellationPropCt.transform)
      local height = bd.size.y
      y = y - height - 20
    end
    local x1, y1, z1 = LuaGameObject.GetLocalPosition(self.adventurePropCt.transform)
    self.adventurePropCt.transform.localPosition = LuaGeometry.GetTempVector3(x1, y, z1)
    local props = AdventurePropBriefType == nil and AdventureDataProxy.Instance:GetAllAdventureProp() or AdventureDataProxy.Instance:GetAdventurePropByBriefType(AdventurePropBriefType)
    local propSize = #props
    if propSize == 0 then
      self:Hide(self.adventurePropCt)
    else
      table.sort(props, sortFunc)
      self.adventurePropListCtrl:ResetDatas(props, true, false)
      self:Show(self.adventurePropCt, plzDontRefresh)
      self.adventurePropListCtrl:ResetPosition()
    end
    if propSize == 0 and (apSize == 0 or hideAppellationProp) then
      self:Show(self.emptyCt, plzDontRefresh)
    else
      self:Hide(self.emptyCt)
    end
  end
end

function AdventureHomePage:UpdateOneClickActivate()
  if self.oneClickForbid then
    self.oneClickActivateBtn:SetActive(false)
    self.oneClickFakeActivateBtn:SetActive(false)
    return
  end
  local availableNum = AdventureDataProxy.Instance:getTotalCanBeClickNum() + AdventureDataProxy.Instance:getCollectionNumWithRewardCanGet() + AdventureAchieveProxy.Instance:getCanGetRewardNum() + FoodProxy.Instance:GetManualDataNumByStatus()
  local available = 0 < availableNum
  self.oneClickActivateBtn:SetActive(available)
  self.oneClickFakeActivateBtn:SetActive(not available)
end

function AdventureHomePage:CallOneClickActivate()
  local temp1, temp2, temp3, serverSingle, single, tmpList, appendData = ReusableTable.CreateArray(), ReusableTable.CreateArray(), ReusableTable.CreateArray()
  AdventureDataProxy.Instance:getTotalCanBeClickNum(temp1)
  for i = 1, #temp1 do
    single = temp1[i]
    if single.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
      serverSingle = NetConfig.PBC and {} or SceneManual_pb.UnlockList()
      serverSingle.type = single.type
      serverSingle.id = single.staticId
      table.insert(temp2, serverSingle)
    elseif single:canBeClick() then
      tmpList = ReusableTable.CreateArray()
      appendData = single:getCompleteNoRewardAppend(tmpList)
      appendData = appendData[1]
      table.insert(temp3, appendData.staticId)
      ReusableTable.DestroyAndClearArray(tmpList)
    end
  end
  if 0 < #temp2 then
    ServiceSceneManualProxy.Instance:CallUnlockQuickManualCmd(temp2)
  end
  if 0 < #temp3 then
    ServiceSceneManualProxy.Instance:CallGetQuestRewardQuickManualCmd(temp3)
  end
  ReusableTable.DestroyAndClearArray(temp3)
  TableUtility.ArrayClear(temp1)
  TableUtility.ArrayClear(temp2)
  AdventureAchieveProxy.Instance:getCanGetRewardNum(temp1)
  for i = 1, #temp1 do
    table.insert(temp2, temp1[i].id)
  end
  if 0 < #temp2 then
    ServiceAchieveCmdProxy.Instance:CallRewardGetQuickAchCmd(temp2)
  end
  ReusableTable.DestroyAndClearArray(temp2)
  TableUtility.ArrayClear(temp1)
  FoodProxy.Instance:GetManualDataNumByStatus(SceneFood_pb.EFOODSTATUS_ADD, temp1)
  for i = 1, #temp1 do
    serverSingle = NetConfig.PBC and {} or SceneManual_pb.UnlockFoodList()
    serverSingle.type = SceneFood_pb.EFOODDATATYPE_FOODCOOK
    serverSingle.id = temp1[i].itemData.staticData.id
    table.insert(temp1, serverSingle)
  end
  if 0 < #temp1 then
    ServiceSceneManualProxy.Instance:CallUnlockQuickManualCmd(nil, temp1)
  end
  ReusableTable.DestroyAndClearArray(temp1)
  ServiceSceneManualProxy.Instance:CallGroupActionManualCmd(SceneManual_pb.EGROUPACTION_COLLECTION_REWARD_QUICK)
end

function AdventureHomePage:UpdateBriefSummaryList(isResetPosition)
  local list = AdventureDataProxy.Instance:GetBriefSummary_All()
  self.bsCtl:ResetDatas(list)
  if isResetPosition then
    self.bsCtl:ResetPosition()
  end
  if not self.bsCtl_created then
    self.briefSummaryScrollview.enabled = false
    TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      local cells = self.bsCtl:GetCells()
      for i = 1, #cells do
        cells[i]:DoReposition()
      end
    end, self)
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self.briefSummaryScrollview.enabled = true
      self.bsCtl:ResetPosition()
    end, self)
    self.bsCtl_created = true
  end
end

function AdventureHomePage:AdventureBriefSummaryCell_ClickShowAttr(cell)
  if cell and cell.data then
    self:showPropView(true, cell.data.btype, true)
  end
end

local needOrder = 8

function AdventureHomePage:AdventureBriefSummaryCell_ClickGoto(cell)
  if cell and cell.data then
    local getOrder = Table_ItemTypeAdventureLog[cell.data.btype]
    getOrder = getOrder and getOrder.Order
    if getOrder and getOrder < needOrder then
      getOrder = nil
    end
    self.container.viewdata.viewdata.tabId = cell.data.btype
    self.container:resetCategory(getOrder)
    self.container.tabId = nil
  end
end

function AdventureHomePage:LayoutProps(cells, parentGrid)
  local curPosX, curPosY, nextLinePosY = 0, 0, 0
  local cellWidth = parentGrid.cellWidth
  for i = 1, #cells do
    local cell = cells[i]
    local bound = NGUIMath.CalculateRelativeWidgetBounds(cell.gameObject.transform, true)
    local roundIntX = math.floor(bound.size.x + 0.5)
    local cellPos = cell.gameObject.transform.localPosition
    nextLinePosY = curPosY - bound.size.y - spacingY
    local isNextLine = 0 < curPosX
    if roundIntX >= maxWidth then
      cellPos.x = 0
      cellPos.y = isNextLine and nextLinePosY or curPosY
      curPosX = 0
      curPosY = isNextLine and nextLinePosY - bound.size.y - spacingY or nextLinePosY
      if isNextLine then
        local lastCell = cells[i - 1]
        if lastCell then
          lastCell:LayoutCell(true)
        end
      end
    else
      cellPos.x = curPosX
      cellPos.y = curPosY
      curPosX = isNextLine and 0 or curPosX + cellWidth
      curPosY = isNextLine and nextLinePosY or curPosY
    end
    cell.gameObject.transform.localPosition = cellPos
  end
end
