Charactor = class("Charactor", ContainerView)
autoImport("AddPointPage")
autoImport("ProfessionPage")
autoImport("InfomationPage")
autoImport("SocialityPage")
autoImport("BaseAttributeView")
autoImport("AttributePointSolutionView")
autoImport("ProfessionInfoViewMP")
autoImport("PlayerDetailViewMP")
autoImport("LevelUpAccelerationView")
Charactor.ViewType = UIViewType.NormalLayer
Charactor.PlayerHeadCellResId = ResourcePathHelper.UICell("PlayerHeadCell")
Charactor.TabName = {
  Infomation = ZhString.Charactor_Infomation,
  AddPoint = ZhString.Charactor_AddPoint,
  Profession = ZhString.Charactor_Profession,
  Sociality = ZhString.Charactor_Sociality
}
local showProfessionPage = false

function Charactor:Init()
  self:initData()
  self:InitTitle()
  self:AddPages()
  self:InitToggle()
  self:initView()
  self:AddListenerEvts()
  self:initTitleData()
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
end

function Charactor:initData()
  self.currentKey = nil
  self:UpdateHead()
end

function Charactor.effectLoadFinish(obj, self, assetEffect)
  if not self then
    if assetEffect then
      assetEffect:Destroy()
    end
    return
  end
  self.effectObj = obj
  self.effect = assetEffect
end

function Charactor:HasMarryed()
  return WeddingProxy.Instance:IsSelfMarried()
end

function Charactor:initCouplePortrait()
  self.couplesCt = self:FindGO("couplesCt")
  local couplesBg = self:FindComponent("couplesBg", UISprite)
  if self:HasMarryed() then
    self:Show(self.couplesCt)
    local coupleLabel = self:FindGO("coupleLabel")
    if (BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU()) and coupleLabel then
      coupleLabel:SetActive(false)
    end
    self:AddClickEvent(self.couplesCt, function(...)
      local infoData = WeddingProxy.Instance:GetWeddingInfo()
      if infoData then
        local id = infoData:GetPartnerGuid()
        local coupleData = WeddingProxy.Instance:GetPortraitInfo(id)
        local playerData = PlayerTipData.new()
        playerData:SetByWeddingcharData(coupleData, true)
        local tip = FunctionPlayerTip.Me():GetPlayerTip(couplesBg, NGUIUtil.AnchorSide.Left, {-380, 60})
        local data = {
          playerData = playerData,
          funckeys = {
            "Wedding_CallBack",
            "Wedding_MissYou",
            "ShowDetail",
            "SendMessage",
            "InviteMember"
          }
        }
        table.insert(data.funckeys, "EnterHomeRoom")
        tip:SetData(data)
      end
    end)
  else
    self:Hide(self.couplesCt)
  end
end

function Charactor:initView()
  self:AddButtonEvent("strengthBtn", function()
    self.baseAttributeView:clickShowBtn()
    if self.uiPlayerSceneInfo then
      self.uiPlayerSceneInfo:HideTitle()
    end
  end)
  local path = ResourcePathHelper.UIEffect(EffectMap.UI.FlashLight)
  self.effect = Asset_Effect.PlayOn(path, self:FindGO("strengthBtn").transform, self.effectLoadFinish, self)
  self.professionInfoViewRlt = self:FindChild("professionInfoView"):GetComponent(RelateGameObjectActive)
  self.playTw = self:FindChild("strengthBtn"):GetComponent(UIPlayTween)
  local infomationLabel = self:FindChild("NameLabel", self.infomationTog):GetComponent(UILabel)
  infomationLabel.text = ZhString.Charactor_Infomation
  local addPointLabel = self:FindChild("NameLabel", self.addPointTog):GetComponent(UILabel)
  addPointLabel.text = ZhString.Charactor_AddPoint
  local professionLabel = self:FindChild("NameLabel", self.professionTog):GetComponent(UILabel)
  professionLabel.text = ZhString.Charactor_Profession
  local coupleLabel = self:FindComponent("coupleLabel", UILabel)
  coupleLabel.text = ZhString.Wedding_CharactorCoupleLabel
  
  function self.professionInfoViewRlt.disable_Call()
    if self.professionPage then
      self.professionPage:unSelectedProfessionIconCell()
    else
      helplog("if self.professionPage then = nil")
    end
  end
  
  self:RegisterRedTip()
  self:UpdateTitleInfo()
  self:initCouplePortrait()
end

function Charactor:AddListenerEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateTitleInfo)
  self:AddListenEvt(MyselfEvent.JobExpChange, self.UpdateJobSlider)
  self:AddListenEvt(MyselfEvent.BaseExpChange, self.UpdateExpSlider)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.UpdateMyProfession)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleMapChange)
  self:AddListenEvt(ServiceEvent.UserEventDepositCardInfo, self.UpdateMonthCardDate)
  self:AddListenEvt(ServiceEvent.UserEventChangeTitle, self.initTitleData)
  self:AddListenEvt(MyselfEvent.TransformChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.HandleTimelen)
end

function Charactor:initTitleData()
  local titleData = Table_Appellation[Game.Myself.data:GetAchievementtitle()]
  if titleData then
    self:Show(self.UserTitle.gameObject)
    self.UserTitle.text = string.format("[%s]", titleData.Name)
  else
    self:Hide(self.UserTitle.gameObject)
  end
end

function Charactor:toggleStrengthBtn()
  self.playTw:Play(true)
end

function Charactor:AddPages()
  local addPointPage = self:AddSubView("AddPointPage", AddPointPage)
  self:AddListenEvt(XDEUIEvent.CloseCharTitle, function()
    if self.uiPlayerSceneInfo then
      self.uiPlayerSceneInfo:HideTitle()
    end
  end)
  self.professionInfoViewMP = self:AddSubView("ProfessionInfoViewMP", ProfessionInfoViewMP)
  if self.professionInfoViewMP == nil then
    helplog("if self.professionInfoViewMP == nil then")
    return
  end
  if showProfessionPage then
    self.professionPage = self:AddSubView("ProfessionPage", ProfessionPage)
    self.professionPage:AddEventListener(ProfessionPage.ProfessionIconClick, self.professionInfoViewMP.multiProfessionInfo, self.professionInfoViewMP)
  end
  self.infomationPage = self:AddSubView("InfomationPage", InfomationPage)
  self.socialityPage = self:AddSubView("SocialityPage", SocialityPage)
  self.attrSolutionView = self:AddSubView("AttributePointSolutionView", AttributePointSolutionView)
  self.attrSolutionView:AddEventListener(AttributePointSolutionView.SelectCell, addPointPage.selectAddPointSolution, addPointPage)
  self.baseAttributeView = self:AddSubView("BaseAttributeView", BaseAttributeView)
  addPointPage:AddEventListener(AddPointPage.addPointAction, self.addPointAction, self)
  self.playerDetailViewMP = self:AddSubView("PlayerDetailViewMP", PlayerDetailViewMP, "PlayerDetailViewMP_1")
  self.professionInfoViewMP:AddEventListener(ProfessionInfoViewMP.LeftBtnClick, self.playerDetailViewMP.OnClickBtnFromProfessionInfoViewMP, self.playerDetailViewMP)
  self.levelUpAccelerationView = self:AddSubView("LevelUpAccelerationView", LevelUpAccelerationView)
  self.levelUpAccelerationView:Hide()
end

function Charactor:InitTitle()
  self.topTitle = self:FindGO("topTitle")
  self.profeName = self:FindChild("professionNamePointPage"):GetComponent(UILabel)
  self.UserTitle = self:FindChild("UserTitle"):GetComponent(UILabel)
  self.baseExpGO = self:FindGO("baseExp")
  self.baseLevel = self:FindChild("baseLv"):GetComponent(UILabel)
  self.baseExp = self:FindChild("baseSlider"):GetComponent(UISlider)
  self.jobExpGO = self:FindGO("jobExp")
  self.jobLevel = self:FindChild("jobLv"):GetComponent(UILabel)
  self.jobExp = self:FindChild("jobLevelSlider"):GetComponent(UISlider)
  local jobGo = self:FindGO("jobExp")
  self.expTipStick = self:FindComponent("Label", UILabel, jobGo)
  self.battlePoint = self:FindChild("fightPowerLabel"):GetComponent(UILabel)
  self.PlayerName = self:FindGO("PlayerName"):GetComponent(UILabel)
  self.PlayerId = self:FindGO("PlayerId"):GetComponent(UILabel)
  self.monthCardTime = self:FindGO("monthCardTime"):GetComponent(UILabel)
  local fightPowerName = self:FindGO("fightPowerName"):GetComponent(UILabel)
  fightPowerName.text = ZhString.Charactor_PingFen
  self.playerIDGO = self:FindGO("playerID")
  self.playerGUID = self:FindGO("ID"):GetComponent(UILabel)
  self.copyIDBtn = self:FindGO("CopyIDBtn")
  self.playerGUID.text = Game.Myself.data.id
  self:AddClickEvent(self.copyIDBtn, function()
    local result = ApplicationInfo.CopyToSystemClipboard(Game.Myself.data.id)
    if result then
      MsgManager.ShowMsgByID(40200)
    end
  end)
  self.gameTime = self:FindComponent("GameTime", UILabel)
  self.playTime = self:FindComponent("PlayTime", UILabel)
  self.helpButton = self:FindGO("GameTimeHelpButton")
  self:AddClickEvent(self.helpButton, function(go)
    self:OnClickHelpBtn()
  end)
end

function Charactor:InitToggle()
  local togObj = self:FindChild("toggles")
  self.addPointTog = self:FindChild("AddPoint", togObj)
  self:AddOrRemoveGuideId(self.addPointTog, 5)
  self.professionTog = self:FindChild("Profession", togObj)
  self.infomationTog = self:FindGO("Infomation", togObj)
  self.socialityTog = self:FindGO("Sociality", togObj)
  self:AddTabChangeEvent(self.addPointTog, self:FindChild("AddPointPage"), PanelConfig.AddPointPage)
  self:AddTabChangeEvent(self.professionTog, self:FindChild("ProfessionPage"), PanelConfig.ProfessionPage)
  self:AddTabChangeEvent(self.infomationTog, self:FindChild("InfomationPage"), PanelConfig.InfomationPage)
  self:AddTabChangeEvent(self.socialityTog, self:FindChild("SocialityPage"), PanelConfig.SocialityPage)
  if not showProfessionPage then
    self.professionTog:SetActive(false)
  end
  local toggleGrid = togObj:GetComponent(UIGrid)
  toggleGrid:Reposition()
  local infoLongPress = self.infomationTog:GetComponent(UILongPress)
  local addLongPress = self.addPointTog:GetComponent(UILongPress)
  local profLongPress = self.professionTog:GetComponent(UILongPress)
  local socialLongPress = self.socialityTog:GetComponent(UILongPress)
  local longPressEvent = function(obj, state)
    self:PassEvent(TipLongPressEvent.Charactor, {
      state,
      obj.gameObject
    })
  end
  infoLongPress.pressEvent = longPressEvent
  addLongPress.pressEvent = longPressEvent
  profLongPress.pressEvent = longPressEvent
  socialLongPress.pressEvent = longPressEvent
  self:AddEventListener(TipLongPressEvent.Charactor, self.HandleLongPress, self)
  local toggleList = {
    self.addPointTog,
    self.professionTog,
    self.infomationTog,
    self.socialityTog
  }
  for i, v in ipairs(toggleList) do
    local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    icon:SetActive(true)
    local nameLabel = Game.GameObjectUtil:DeepFindChild(v, "NameLabel")
    nameLabel:SetActive(false)
  end
  if self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandler(self.viewdata.viewdata.tab)
    if self.viewdata.viewdata.tab == PanelConfig.InfomationPage.tab and self.viewdata.viewdata.speedUpType then
      self.infomationPage:SelectSpeedUp(self.viewdata.viewdata.speedUpType)
    end
  elseif self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  else
    self:TabChangeHandler(PanelConfig.AddPointPage.tab, true)
  end
end

function Charactor:RegisterRedTip()
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_ADD_POINT, self:FindChild("Background", self.addPointTog), nil, {-11, -10})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_PROFESSION_UP, self:FindChild("Background", self.professionTog), nil, {-11, -10})
end

function Charactor:OnEnter()
  self.super.OnEnter(self)
  self:CameraRotateToMe(false, nil, nil)
  Game.PerformanceManager:LODHigh()
end

function Charactor:OnExit()
  self:CameraReset()
  if self.currentKey == PanelConfig.AddPointPage.tab then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ADD_POINT)
  elseif self.currentKey == PanelConfig.ProfessionPage.tab then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_PROFESSION)
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PROFESSION_UP)
  end
  Game.PerformanceManager:ResetLOD()
  self.super.OnExit(self)
  if self:ObjIsNil(self.effectObj) then
    GameObject.Destroy(self.effectObj)
    self.effectObj = nil
  end
  FunctionPlayerTip.Me():CloseTip()
  self.professionInfoViewRlt = nil
  if self.effect ~= nil then
    self.effect:Destroy()
    self.effect = nil
  end
  TipManager.Instance:CloseTabNameTip()
  self.targetCell:RemoveIconEvent()
end

function Charactor:ShowPage(key)
  if key == "addPointPage" then
    self.addPointTog:GetComponent(UIToggle).startsActive = true
  elseif key == "professionPage" then
    self.professionTog:GetComponent(UIToggle).startsActive = true
  else
    self.addPointTog:GetComponent(UIToggle).startsActive = true
  end
end

function Charactor:addPointAction(addData)
  self.baseAttributeView:showMySelf(addData)
end

function Charactor:TabChangeHandler(key, moveToNext)
  if self.currentKey ~= key then
    local bRet = Charactor.super.TabChangeHandler(self, key)
    self.attrSolutionView:Hide()
    self.levelUpAccelerationView:Hide()
    if self.currentKey == PanelConfig.AddPointPage.tab then
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ADD_POINT)
    elseif self.currentKey == PanelConfig.ProfessionPage.tab then
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_PROFESSION)
      RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_PROFESSION_UP)
    end
    if key ~= PanelConfig.AddPointPage.tab then
      self.attrSolutionView:Hide()
      self.professionInfoViewMP:multiProfessionInfo(nil)
    end
    if key == PanelConfig.ProfessionPage.tab then
      if bRet then
        self.topTitle:SetActive(false)
      end
    else
      self.professionInfoViewMP:multiProfessionInfo(nil)
      self.topTitle:SetActive(true)
    end
    if bRet then
      if self.currentKey then
        local iconSp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite)
        iconSp.color = ColorUtil.TabColor_White
      end
      local iconSp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[key].go, "Icon"):GetComponent(UISprite)
      iconSp.color = ColorUtil.TabColor_DeepBlue
    end
    if bRet then
      self.currentKey = key
    elseif moveToNext then
      self:TabChangeHandler(key + 1, moveToNext)
    end
  end
end

function Charactor:AddCloseButtonEvent()
  Charactor.super.AddCloseButtonEvent(self)
  self:AddOrRemoveGuideId("CloseButton", 8)
end

function Charactor:UpdateTitleInfo()
  self:UpdateExpSlider()
  self:UpdateJobSlider()
  self:UpdateHead()
  self:UpdateMyProfession()
  self:UpdateMonthCardDate()
  local data = ServiceConnProxy.Instance:getData()
  self.PlayerId.text = data and data.accid or 0
  self.PlayerName.text = Game.Myself.data:GetName()
end

function Charactor:UpdateExpSlider()
  local userData = Game.Myself.data.userdata
  local roleExp = userData:Get(UDEnum.ROLEEXP)
  local nowRoleLevel = userData:Get(UDEnum.ROLELEVEL)
  self.baseLevel.text = "Lv" .. tostring(nowRoleLevel)
  local referenceValue = Table_BaseLevel[nowRoleLevel + 1]
  if referenceValue == nil then
    referenceValue = 1
  else
    referenceValue = referenceValue.NeedExp
  end
  self.baseExp.value = roleExp / referenceValue
  self.battlePoint.text = tostring(userData:Get(UDEnum.BATTLEPOINT))
end

function Charactor:UpdateMonthCardDate()
  local leftDay = NewRechargeProxy.Ins:GetMonthCardLeftDays()
  if leftDay then
    self:Show(self.monthCardTime.gameObject)
    self.monthCardTime.text = string.format(ZhString.Charactor_MonthCardTime, leftDay)
  else
    self:Hide(self.monthCardTime.gameObject)
  end
end

function Charactor:UpdateJobSlider()
  local nowJob = Game.Myself.data:GetCurOcc()
  if nowJob == nil then
    return
  end
  local professionid = MyselfProxy.Instance:GetMyProfession()
  local nowJobLevel = nowJob:GetLevelText()
  local userData = Game.Myself.data.userdata
  local cur_max = userData:Get(UDEnum.CUR_MAXJOB) or 0
  local curlv = MyselfProxy.Instance:JobLevel()
  if ISNoviceServerType then
    local depth = ProfessionProxy.GetJobDepth()
    cur_max = depth == 4 and curlv < 220 and 220 or cur_max
  end
  helplog("Server professionid:" .. professionid)
  helplog("Server nowJobLevel:" .. nowJobLevel)
  helplog("Server cur_max:" .. cur_max)
  helplog("Server curlv:" .. curlv)
  if curlv <= 0 or cur_max <= 0 then
    helplog("策划填错了表导致显示不对 请策划检查Table_Class表！！！")
  end
  curlv, cur_max = Occupation.GetMyFixedJobLevelWithMax_Refactory(curlv, cur_max, professionid)
  self.jobLevel.text = string.format("Lv%s/%s", tostring(curlv), cur_max)
  local referenceValue = Table_JobLevel[nowJob.level + 1]
  if MyselfProxy.Instance:IsHero() then
    referenceValue = referenceValue and referenceValue.HeroJobExp
  else
    referenceValue = referenceValue and referenceValue.JobExp
  end
  if referenceValue == nil then
    referenceValue = 1
  end
  self.jobExp.value = nowJob.exp / referenceValue
end

function Charactor:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(Charactor.PlayerHeadCellResId, headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.Const_V3_zero
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self:AddClickEvent(self.headCellObj, function()
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ChangeHeadView
      })
    end)
    self.targetCell:HideHpMp()
  end
  local headData = HeadImageData.new()
  headData:TransByMyself()
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end

function Charactor:clickHeadIcon()
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "PortraitPopUp"
  })
end

function Charactor:UpdateMyProfession()
  local nowOcc = Game.Myself.data:GetCurOcc()
  if nowOcc ~= nil then
    local name = ProfessionProxy.GetProfessionName(nowOcc.profession, MyselfProxy.Instance:GetMySex())
    local equipSkillFamilyId = SkillProxy.Instance:GetEquipMasterSkillFamilyId()
    if equipSkillFamilyId and 0 < equipSkillFamilyId then
      local skillId = equipSkillFamilyId * 1000 + 1
      local config = Table_Skill[skillId]
      local skillName = config and config.NameZh or ""
      name = name .. "——" .. skillName
    end
    self.profeName.text = name
  end
end

function Charactor:HandleMapChange(note)
  if note.type == LoadSceneEvent.FinishLoad and note.body then
    self:CameraRotateToMe()
  end
end

function Charactor:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  local backgroundSp = Game.GameObjectUtil:DeepFindChild(go, "Background"):GetComponent(UISprite)
  TabNameTip.OnLongPress(isPressing, Charactor.TabName[go.name], false, backgroundSp)
end

function Charactor:ShowLevelUpAccelerationView(type)
  self.baseAttributeView:Hide()
  self.levelUpAccelerationView:Show()
  self.levelUpAccelerationView:SetData(type)
end

function Charactor:HandleTimelen(note)
  local data = note.body
  if data then
    self:SetGameTime(data)
  end
end

local BattleTimeStringColor = {
  [1] = "[41c419]%s[-]",
  [2] = "[ffc945]%s[-]",
  [3] = "[cf1c0f]%s[-]"
}

function Charactor:SetGameTime(data)
  local battleTimeMgr = BattleTimeDataProxy.Instance
  local timeLen = battleTimeMgr:Timelen()
  local timeTotal = battleTimeMgr:TotalTimeLen()
  local color = battleTimeMgr:GetStatus()
  local playTimeLen = battleTimeMgr:UsedPlayTime()
  local playTotalTimeLen = battleTimeMgr:TotalPlayTime()
  local gameTime_str = ISNoviceServerType and ZhString.Charactor_GameTime_DailyValidKillCount or ZhString.Charactor_GameTime
  self.gameTime.text = string.format(gameTime_str, string.format(BattleTimeStringColor[color], timeLen), timeTotal)
  local str = battleTimeMgr:UseDailyPlayTime() and ZhString.Charactor_PlayTime_Daily or ZhString.Charactor_PlayTime
  self.playTime.text = string.format(str, playTimeLen, playTotalTimeLen)
end

function Charactor:OnClickHelpBtn()
  local datas = {
    Table_Help[GameConfig.Setting.GametimeHelpId],
    Table_Help[GameConfig.Setting.PlaytimeHelpId]
  }
  if nil == next(datas) then
    return
  end
  TipsView.Me():ShowTip(SettingViewHelp, datas, "SettingViewHelp")
end
