autoImport("SkillCell")
autoImport("SkillBaseContentPage")
autoImport("ShortCutSkillDragCell")
autoImport("SkillContentPage")
autoImport("BeingSkillContentPage")
autoImport("PvpTalentContentPage")
autoImport("FourthSkillContentPage")
autoImport("HeroSkillContentPage")
SkillView = class("SkillView", ContainerView)
SkillView.ViewType = UIViewType.NormalLayer
local GOCameraType = Game.GameObjectType.Camera
local AutoShortcutIndex = {
  [SceneSkill_pb.ESKILLSHORTCUT_AUTO] = 1,
  [SceneSkill_pb.ESKILLSHORTCUT_AUTO_2] = 2
}
local ResetSkillConig = GameConfig.ResetSkill[2]

function SkillView:GetShowHideMode()
  return PanelShowHideMode.ActiveAndDeactive
end

function SkillView:Init(viewObj)
  self:FindObjs()
  self.contentView = self:AddSubView("SkillContent", SkillContentPage)
  self.beingContentView = self:AddSubView("BeingSkillContentPage", BeingSkillContentPage)
  self.pvpTalentContentView = self:AddSubView("PvpTalentContentPage", PvpTalentContentPage)
  self.fourthSkillContentView = self:AddSubView("FourthSkillContentPage", FourthSkillContentPage)
  self.heroSkillContentView = self:AddSubView("HeroSkillContentPage", HeroSkillContentPage)
  self.togViewMap = {
    [self.pvpTalentSkillToggle] = self.pvpTalentContentView,
    [self.beingSkillToggle] = self.beingContentView,
    [self.fourthSkillToggle] = self.fourthSkillContentView,
    [self.heroSkillToggle] = self.heroSkillContentView
  }
  self:InitShortCuts()
  self:InitAutoShortCuts()
  self.shortcutSwitchIndex = 1
  self:SwitchShortCutTo(ShortCutProxy.SwitchList[self.shortcutSwitchIndex])
  self:InitTopToggles()
  self:CheckNeedShowProfessToggle()
  self:AddViewListener()
  self:RegisterGuide()
  self:InitAutoSkillSwitcher()
  local currentauto = ShortCutProxy.Instance:GetCurrentAuto()
  self.autoshortcutSwitchIndex = AutoShortcutIndex[currentauto]
  self:SwitchAutoShortCutTo(ShortCutProxy.AutoList[self.autoshortcutSwitchIndex])
end

function SkillView:InitTabChangeHandler()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  elseif self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.tab then
    self:TabChangeHandler(self.viewdata.viewdata.tab)
  else
    self:TabChangeHandler(PanelConfig.CharactorAdventureSkill.tab)
  end
end

function SkillView:OnEnter()
  SaveInfoProxy.Instance:CheckHasInfo(SaveInfoEnum.Branch)
  local viewdata = self.viewdata.viewdata
  if viewdata ~= nil then
    self.multiSaveId = viewdata.saveId
    self.multiSaveType = viewdata.saveType
    SkillProxy.Instance:SetMultiSave(self.multiSaveId, self.multiSaveType)
    if viewdata.allowedSkillTip then
      SkillTip.SetForbidFunc(true)
      for i = 1, #viewdata.allowedSkillTip do
        SkillTip.FuncForbidMap[viewdata.allowedSkillTip[i]] = nil
      end
    end
  else
    self.multiSaveId = nil
    self.multiSaveType = nil
  end
  if self.upLeftWidget ~= nil then
    self.upLeftWidget:UpdateAnchors()
  end
  if self.upRightWidget ~= nil then
    self.upRightWidget:UpdateAnchors()
  end
  self:InitTabChangeHandler()
  self:RefreshShortCuts()
  local profess = SkillProxy.Instance:GetMyProfession()
  self:UpdateTopByProfess(profess)
  self:UpdateTopToggles(profess)
  self:RegisterRedTip()
  self:UpdateTipLabel()
  self:RefreshAutoShortCuts()
  FunctionCDCommand.Me():StartCD(SkillCountdownRefresher)
  local myClass = MyselfProxy.Instance:GetMyProfession()
  local mySolution = ProfessionProxy.Instance:GetSkillPointSolution(myClass)
  local showRec = mySolution and 0 < #mySolution and not self.multiSaveId and not self.multiSaveType
  self.recommendBtn:SetActive(showRec)
  self.resetBtn:SetActive(showRec)
  if self:IsHeroProfess(profess) then
    self.contentView.hasProfessSkill = false
  else
    self.contentView.hasProfessSkill = true
  end
  SkillView.super.OnEnter(self)
end

function SkillView:OnExit()
  SkillProxy.Instance:SetMultiSave()
  local tip = TipsView.Me().currentTip
  if tip and tip.SetCheckClick then
    tip:SetCheckClick(nil)
  end
  SkillTip.SetForbidFunc()
  local _FunctionCDCommand = FunctionCDCommand.Me()
  if not _FunctionCDCommand:TryDestroy(SkillCountdownRefresher) then
    FunctionCDCommand.Me():StopCD(SkillCountdownRefresher)
  end
  SkillView.super.OnExit(self)
  ResourceManager.Instance:GC()
end

function SkillView:OnShow()
  SkillView.super.OnShow(self)
  local camera = Game.GameObjectManagers[GOCameraType]
  if camera ~= nil then
    camera:ActiveMainCamera(false)
  end
end

function SkillView:OnHide()
  SkillView.super.OnHide(self)
  local camera = Game.GameObjectManagers[GOCameraType]
  if camera ~= nil then
    camera:ActiveMainCamera(true)
  end
end

function SkillView:OnDestroy()
  self.shortCutList:Destroy()
  self.autoShortCutList:Destroy()
  SkillView.super.OnDestroy(self)
end

function SkillView:AddViewListener()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.RefreshSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateMasterSkill, self.RefreshSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateMasterSkillEquip, self.RefreshSkills)
  self:AddListenEvt(ServiceEvent.SkillUpdateInheritSkillCmd, self.RefreshSkills)
  self:AddListenEvt(MyselfEvent.MyProfessionChange, self.RefreshProfess)
end

function SkillView:FindObjs()
  local l_objBottom = self:FindGO("SelfBottom")
  self.l_objBottom = l_objBottom
  self.objBottomLeft = self:FindGO("SelfBottomLeft", l_objBottom)
  self.shortCutGrid = self:FindGO("ShortCutGrid", self.objBottomLeft):GetComponent(UIGrid)
  self.autoShortCutGrid = self:FindGO("AutoShortCutGrid", self.objBottomLeft):GetComponent(UIGrid)
  self.shortCutArea = self:FindGO("ShortCutArea", l_objBottom):GetComponent(UIWidget)
  local l_objUpRight = self:FindGO("SelfUpRight", self:FindGO("SelfUp"))
  self.skillToggleGrid = self:FindGO("SkillToggleGrid", l_objUpRight):GetComponent(UIGrid)
  self.commonSkillToggle = self:FindGO("CommonToggle", l_objUpRight):GetComponent(UIToggle)
  self.professSkillToggle = self:FindGO("ProfessToggle", l_objUpRight):GetComponent(UIToggle)
  self.beingSkillToggle = self:FindGO("BeingToggle", l_objUpRight):GetComponent(UIToggle)
  self.pvpTalentSkillToggle = self:FindGO("PvpTalentToggle", l_objUpRight):GetComponent(UIToggle)
  self.fourthSkillToggle = self:FindGO("FourthSkillToggle", l_objUpRight):GetComponent(UIToggle)
  self.heroSkillToggle = self:FindGO("HeroSkillToggle", l_objUpRight):GetComponent(UIToggle)
  self.closeBtn = self:FindGO("CloseButton", l_objUpRight)
  local l_objUpLeft = self:FindGO("SelfUpLeft", self:FindGO("SelfUp"))
  self.profess = self:FindGO("Profess", l_objUpLeft)
  self.professIcon = self:FindGO("ProfessIcon", l_objUpLeft):GetComponent(UISprite)
  self.professIconBG = self:FindGO("CareerBg", l_objUpLeft):GetComponent(UISprite)
  self.professNameLabel = self:FindGO("ProfessName", l_objUpLeft):GetComponent(UILabel)
  self.professLevelLabel = self:FindGO("ProfessLevel", l_objUpLeft):GetComponent(UILabel)
  self.professSkillPoint = self:FindGO("CostedPointBg", l_objUpLeft)
  self.currentProfessSkillPoints = self:FindGO("CostedPointLabel", l_objUpLeft):GetComponent(UILabel)
  self.labSkillPoints = self:FindComponent("SkillPoints", UILabel, l_objUpLeft)
  self.commonIcon = self:FindGO("CommonSkill", l_objUpLeft)
  self.upLeftWidget = l_objUpLeft:GetComponent(UIWidget)
  self.upRightWidget = l_objUpRight:GetComponent(UIWidget)
  local l_objBottomRight = self:FindGO("SelfBottomRight", self:FindGO("SelfBottom"))
  self.tipLabel = self:FindGO("TipLabel", l_objBottomRight)
  self.recommendBtn = self:FindGO("RecommendBtn")
  self:AddClickEvent(self.recommendBtn, function()
    redlog("JumpPanel SkillRecommendPopUp")
    GameFacade.Instance:sendNotification(SkillRecommendEvent.ResetPreset)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SkillRecommendPopUp
    })
  end)
  self.resetBtn = self:FindGO("ResetBtn")
  self:AddClickEvent(self.resetBtn, function()
    self:DoResetSkill()
  end)
  self.innerBg = self:FindGO("InnerBg")
  self.innerBg2 = self:FindGO("InnerBg2")
  self.maskCollider = self:FindGO("MaskCollider")
  self:AddClickEvent(self.maskCollider, function()
    MsgManager.ShowMsgByID(49)
  end)
  self:SetMaskColliderOn(false)
end

function SkillView:DoResetSkill()
  local skillp = SkillProxy.Instance:GetUsedPoints() or 0
  if skillp <= 0 then
    MsgManager.ShowMsgByID(43103)
    return
  end
  local itemData = BagProxy.Instance:GetItemByStaticID(ResetSkillConig.ItemID)
  if itemData then
    MsgManager.ConfirmMsgByID(43100, function()
      ServiceSkillProxy.Instance:CallResetSkill(SceneSkill_pb.ERESETSKILLTYPE_FIGHTER, SceneSkill_pb.ERESETSKILLCASTTYPE_ITEM)
      return
    end, nil, nil)
  else
    local zeny = MyselfProxy.Instance:GetROB()
    if zeny >= ResetSkillConig.MoneyCount then
      local data = Table_Sysmsg[43101]
      local text = data and data.Text or ""
      local str = string.format(text, ResetSkillConig.MoneyCount)
      UIUtil.PopUpConfirmYesNoView("", str, function()
        ServiceSkillProxy.Instance:CallResetSkill(SceneSkill_pb.ERESETSKILLTYPE_FIGHTER, SceneSkill_pb.ERESETSKILLCASTTYPE_MONEY)
      end, nil, nil, data.button, data.buttonF)
    else
      MsgManager.ShowMsgByID(43102)
    end
  end
end

function SkillView:RegisterGuide()
  self:AddOrRemoveGuideId(self.closeBtn, 31)
  self:AddOrRemoveGuideId(self.commonSkillToggle.gameObject, 100)
end

function SkillView:RegisterRedTip()
  if self.multiSaveId == nil then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_SKILL_POINT, self.professSkillToggle.gameObject, 10, {-10, -5})
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_FOURTH_SKILL_POINT, self.fourthSkillToggle.gameObject, 10, {-10, -5})
    local _RedTipProxy = RedTipProxy.Instance
    if _RedTipProxy:InRedTip(SceneTip_pb.EREDSYS_PEAK_LEVEL) then
      MsgManager.ConfirmMsgByID(3430, function()
        _RedTipProxy:SeenNew(SceneTip_pb.EREDSYS_PEAK_LEVEL)
      end)
    elseif _RedTipProxy:InRedTip(SceneTip_pb.EREDSYS_PEAK_NEW_LEVEL) then
      MsgManager.ConfirmMsgByID(3430, function()
        _RedTipProxy:SeenNew(SceneTip_pb.EREDSYS_PEAK_NEW_LEVEL)
      end)
    end
  end
end

function SkillView:InitTopToggles()
  self:AddTabChangeEvent(self.commonSkillToggle.gameObject, nil, PanelConfig.CharactorAdventureSkill)
  self:AddTabChangeEvent(self.professSkillToggle.gameObject, nil, PanelConfig.CharactorProfessSkill)
  self:AddTabChangeEvent(self.beingSkillToggle.gameObject, nil, PanelConfig.CharactorBeingSkill)
  self:AddTabChangeEvent(self.pvpTalentSkillToggle.gameObject, nil, PanelConfig.CharactorPvpTalentSkill)
  self:AddTabChangeEvent(self.fourthSkillToggle.gameObject, nil, PanelConfig.CharactorFourthSkill)
  self:AddTabChangeEvent(self.heroSkillToggle.gameObject, nil, PanelConfig.CharactorHeroSkill)
  for key, tabData in pairs(self.coreTabMap) do
    tabData.go:GetComponent(UILongPress).pressEvent = function(obj, state)
      self:HandleLongPress(state, obj.gameObject)
    end
  end
  self:AddOrRemoveGuideId(self.fourthSkillToggle.gameObject, 1009)
end

function SkillView:_SetToggleWidth(toggle, width)
  local widget = toggle.gameObject:GetComponent(UIWidget)
  if widget then
    widget.width = width
  end
  widget = self:FindComponent("Background", UISprite, toggle.gameObject)
  if widget then
    widget.width = width
  end
  widget = self:FindComponent("Checkmark", UISprite, toggle.gameObject)
  if widget then
    widget.width = width + 10
  end
end

function SkillView:UpdateTopToggles(profess)
  local talentPoint = Game.Myself.data.userdata:Get(UDEnum.TALENT_POINT) or 0
  if 0 < talentPoint then
    self:Show(self.pvpTalentSkillToggle)
  else
    self:Hide(self.pvpTalentSkillToggle)
  end
  if ProfessionProxy.Instance:GetDepthByClassId(profess) > 4 then
    self:Show(self.fourthSkillToggle)
  else
    self:Hide(self.fourthSkillToggle)
  end
  local myClassConfig = Table_Class[profess]
  if myClassConfig and myClassConfig.TypeBranch == 62 then
    if self.multiSaveId ~= nil and self.beingContentView:GetSelectSkillBeingData() == nil then
      self:Hide(self.beingSkillToggle)
      self.skillToggleGrid:Reposition()
      return
    end
    self:Show(self.beingSkillToggle)
    self:Hide(self.heroSkillToggle)
    self:Show(self.professSkillToggle)
    self.beingContentView:InitBeings()
  elseif self:IsHeroProfess(profess) then
    self:Show(self.heroSkillToggle)
    self:Hide(self.professSkillToggle)
    self:Hide(self.beingSkillToggle)
  else
    self:Hide(self.beingSkillToggle)
    self:Hide(self.heroSkillToggle)
    self:Show(self.professSkillToggle)
  end
  self.skillToggleGrid:Reposition()
end

function SkillView:TabChangeHandler(key)
  if self.coreTabMap then
    if key == PanelConfig.CharactorProfessSkill.tab then
      local myProfess = SkillProxy.Instance:GetMyProfession()
      if self:IsHeroProfess(myProfess) then
        key = PanelConfig.CharactorHeroSkill.tab
      end
    end
    local tabObj = self.coreTabMap[key]
    if type(tabObj.check) == "table" and tabObj.check.id and not FunctionUnLockFunc.Me():CheckCanOpenByPanelId(tabObj.check.id, true) then
      if tabObj.tog ~= self.commonSkillToggle then
        self.commonSkillToggle.value = true
      end
      return tabObj
    end
    tabObj.tog.value = true
    self.selectKey = key
    if self.contentView:IsEditMode() then
      self.professSkillToggle.value = true
      self.contentView:ConfirmEditMode(self.SwitchToCurrentKey, self)
    else
      local isConfirmStatus = false
      for toggle, contentPage in pairs(self.togViewMap) do
        if contentPage:IsEditMode() then
          toggle.value = true
          contentPage:ConfirmEditMode(self.SwitchToCurrentKey, self)
          isConfirmStatus = true
        end
      end
      if not isConfirmStatus then
        self:SwitchToCurrentKey()
      end
    end
    if key ~= PanelConfig.CharactorPvpTalentSkill.tab then
      self:SwitchBG(1)
      self:ActiveBottom(true)
    end
    return tabObj
  end
  return nil
end

function SkillView:SwitchToCurrentKey()
  local tabObj = self.coreTabMap[self.selectKey]
  local curToggle = tabObj and tabObj.tog
  for toggle, contentPage in pairs(self.togViewMap) do
    if toggle == curToggle then
      toggle.value = true
    end
    contentPage:Switch(toggle == curToggle)
  end
  if self.togViewMap[curToggle] then
    self.contentView:Switch(false)
  elseif tabObj then
    self:ConfirmShowMineContent(tabObj)
  else
    LogUtility.Error("Cannot find tab with key: " .. tostring(self.selectKey))
    self:ConfirmShowCommon()
  end
end

function SkillView:ConfirmShowMineContent(tabObj)
  tabObj.tog.value = true
  if tabObj.tog == self.commonSkillToggle then
    if self.contentView:IsEditMode() then
      self.professSkillToggle.value = true
    end
    self:ShowCommon()
  elseif tabObj.tog == self.professSkillToggle then
    self:ShowProfess(true)
  end
end

function SkillView:ShowCommon()
  self.contentView:Switch(true)
  if not self.contentView.ShowingCommon then
    self.contentView:ConfirmEditMode(self.ConfirmShowCommon, self)
  end
end

function SkillView:ConfirmShowCommon()
  self.contentView:Switch(true)
  self.commonSkillToggle.value = true
  self:Hide(self.profess)
  self.contentView:ShowCommon()
end

function SkillView:ShowProfess(force)
  self.contentView:Switch(true)
  if self.contentView.ShowingCommon or force then
    self:Show(self.profess)
    self.contentView:ShowProfess()
  end
end

function SkillView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function(go)
    if self.contentView.switch then
      self.contentView:ConfirmEditMode(self.CloseSelf, self)
    else
      for toggle, contentPage in pairs(self.togViewMap) do
        if contentPage.switch then
          contentPage:ConfirmEditMode(self.CloseSelf, self)
        end
      end
    end
  end)
end

function SkillView:CloseSelf()
  local cells = self.autoShortCutList:GetCells()
  local hasAttackTypeSkill, skillData
  for i = 1, #cells do
    skillData = cells[i].data
    if skillData and skillData.staticData then
      local config = Table_SkillMould[skillData.sortID * 1000 + 1]
      if config and config.Atktype and config.Atktype == 1 then
        hasAttackTypeSkill = true
        break
      end
    end
  end
  if hasAttackTypeSkill then
    SkillView.super.CloseSelf(self)
  elseif self.multiSaveId ~= nil then
    SkillView.super.CloseSelf(self)
  else
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(1711)
    if dont == nil then
      local confirmHandler = function()
        SkillView.super.CloseSelf(self)
      end
      MsgManager.DontAgainConfirmMsgByID(1711, confirmHandler, nil, nil)
    else
      SkillView.super.CloseSelf(self)
    end
  end
end

function SkillView:InitSwitchShortCut()
  self.skillShortCutSwitchIcon = self:FindChild("SwitchIcon"):GetComponent(UIMultiSprite)
  self.skillShortCutSwtichBtn = self:FindChild("SkillShortCutSwitch")
  self:AddButtonEvent("SkillShortCutSwitch", function()
    self:TryGetNextSwitchID()
    self:SwitchShortCutTo(self.shortcutSwitchID)
  end)
end

function SkillView:TryGetNextSwitchID()
  self.shortcutSwitchIndex = self.shortcutSwitchIndex + 1
  if self.shortcutSwitchIndex > #ShortCutProxy.SwitchList then
    self.shortcutSwitchIndex = 1
  end
  local id = ShortCutProxy.SwitchList[self.shortcutSwitchIndex]
  local funcEnable = ShortCutProxy.Instance:ShortCutListIsEnable(id)
  if funcEnable then
    self.shortcutSwitchID = id
  else
    self:TryGetNextSwitchID()
  end
end

function SkillView:SwitchShortCutTo(id)
  if id ~= nil then
    self.shortcutSwitchID = id
    self.skillShortCutSwitchIcon.CurrentState = self.shortcutSwitchIndex - 1
    self:RefreshShortCuts()
  end
end

function SkillView:InitAutoSkillSwitcher()
  self.autoSkillShortCutSwitchBtn = self:FindGO("AutoSkillShortCutSwitch")
  if self.autoSkillShortCutSwitchBtn then
    self.autoskillShortCutSwitchIcon = self:FindChild("AutoSwitchIcon", self.autoSkillShortCutSwitchBtn):GetComponent(UIMultiSprite)
    self:AddButtonEvent("AutoSkillShortCutSwitch", function()
      self:TryGetNextAutoSwitchID()
      self:SwitchAutoShortCutTo(self.autoshortcutSwitchID)
    end)
  end
end

function SkillView:TryGetNextAutoSwitchID()
  self.autoshortcutSwitchIndex = self.autoshortcutSwitchIndex + 1
  if self.autoshortcutSwitchIndex > #ShortCutProxy.AutoList then
    self.autoshortcutSwitchIndex = 1
  end
  local id = ShortCutProxy.AutoList[self.autoshortcutSwitchIndex]
  local funcEnable = ShortCutProxy.Instance:AutoShortCutListIsEnable()
  if funcEnable then
    self.autoshortcutSwitchID = id
  else
    self:TryGetNextAutoSwitchID()
  end
end

function SkillView:SwitchAutoShortCutTo(id)
  if id ~= nil then
    self.autoshortcutSwitchID = id
    ShortCutProxy.Instance:SetCurrentAuto(id)
    ServiceSkillProxy.Instance:CallChangeAutoShortCutCmd(id)
    self.autoskillShortCutSwitchIcon.CurrentState = self.autoshortcutSwitchIndex - 1
    self:RefreshAutoShortCuts()
  end
end

function SkillView:HandleShortCutSwitchActive(note)
  local funcEnable = false
  local _ShortCutEnum = ShortCutProxy.ShortCutEnum
  local _ShortCutProxy = ShortCutProxy.Instance
  local _SaveInfoProxy = SaveInfoProxy.Instance
  local ID1 = _ShortCutEnum.ID1
  for k, v in pairs(_ShortCutEnum) do
    if v ~= ID1 then
      if self.multiSaveId == nil then
        funcEnable = _ShortCutProxy:ShortCutListIsEnable(v)
      else
        local saveData = _SaveInfoProxy:GetSkillData(self.multiSaveId, self.multiSaveType)
        if saveData ~= nil then
          funcEnable = saveData:ShortCutListIsEnable(v)
        end
      end
      if funcEnable then
        break
      end
    end
  end
  if funcEnable then
    self:SetActive(self.skillShortCutSwtichBtn, true)
  else
    self:SetActive(self.skillShortCutSwtichBtn, false)
    if self.shortcutSwitchID ~= ID1 then
      self:SwitchShortCutTo(ID1)
    end
  end
end

function SkillView:InitShortCuts()
  self:InitSwitchShortCut()
  self.shortCutList = UIGridListCtrl.new(self.shortCutGrid, ShortCutSkillDragCell, "ShortCutSkillDragCell")
  self.shortCutList:AddEventListener(DragDropEvent.SwapObj, self.SwapSkill, self)
  self.shortCutList:AddEventListener(DragDropEvent.DropEmpty, self.TakeOffSkill, self)
  self.shortCutList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
end

function SkillView:InitAutoShortCuts()
  self.autoShortCutList = UIGridListCtrl.new(self.autoShortCutGrid, AutoShortCutSkillDragCell, "ShortCutSkillDragCell")
  self.autoShortCutList:AddEventListener(DragDropEvent.SwapObj, self.SwapSkill, self)
  self.autoShortCutList:AddEventListener(DragDropEvent.DropEmpty, self.TakeOffSkill, self)
  self.autoShortCutList:AddEventListener(MouseEvent.MouseClick, self.ShowTipHandler, self)
end

function SkillView:ShowTipHandler(cell)
  local skilldata = cell.data and cell.data.staticData
  if not skilldata then
    return
  end
  self.tipdata = {}
  self.tipdata.data = cell.data
  TipsView.Me():ShowTip(SkillTip, self.tipdata, "SkillTip")
end

function SkillView:SwapSkill(obj)
  local source = obj.data.source
  local target = obj.data.target
  redlog("SkillView:SwapSkill", source and source.data.id, target and target.data.id)
  if self.contentView:IsEditMode() and (source.class == SkillCell or source.class == MasterSkillCell) then
    MsgManager.ShowMsgByIDTable(608)
    return
  end
  if target:IsLocked(self.shortcutSwitchID) then
    return
  end
  if source.class == AutoShortCutSkillDragCell and source:IsLocked(self.shortcutSwitchID) then
    return
  end
  if source ~= nil and target ~= nil and self:_CheckPosUnequal(source.data, target.data) then
    local targetType = self:GetShotCutType(target.class)
    local sourceType = self:GetShotCutType(source.class)
    local targetPos
    local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
    local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
    if targetType ~= sourceType and (sourceType == shortCutAuto or targetType == shortCutAuto or sourceType == shortCutAuto2 or targetType == shortCutAuto2) and (source ~= nil and source.data.staticData and source.data.staticData.AutoCondition_Groove == 1 or target ~= nil and target.data.staticData and target.data.staticData.AutoCondition_Groove == 1) then
      MsgManager.ShowMsgByIDTable(1950)
      return
    end
    if targetType == SceneSkill_pb.ESKILLSHORTCUT_AUTO or targetType == SceneSkill_pb.ESKILLSHORTCUT_AUTO_2 then
      targetPos = target.data:GetPosInShortCutGroup(targetType)
    else
      targetPos = target.data:GetPosInShortCutGroup(targetType)
      if sourceType == shortCutAuto and (target.data == nil or target.data.staticData == nil) and self:CheckAutoIsLast() then
        return
      end
    end
    if targetType ~= sourceType then
      if targetType ~= shortCutAuto and sourceType ~= shortCutAuto or source.data.staticData == nil or target.data.staticData == nil then
        TipManager.Instance:CloseBubbleTip(BubbleID.SkillFirstTimeOverFlow)
      end
      local normalAtkSkillID = Game.Myself.data:GetAttackSkillIDAndLevel()
      if normalAtkSkillID and (targetType == shortCutAuto and target.data and target.data.staticData and target.data.staticData.id == normalAtkSkillID or sourceType == shortCutAuto and source.data and source.data.staticData and source.data.staticData.id == normalAtkSkillID) then
        MsgManager.ConfirmMsgByID(1710, function()
          ServiceSkillProxy.Instance:CallEquipSkill(source.data.id, targetPos, source.data.sourceId, sourceType, targetType)
        end)
        return
      end
    end
    ServiceSkillProxy.Instance:CallEquipSkill(source.data.id, targetPos, source.data.sourceId, sourceType, targetType)
  end
end

function SkillView:_CheckPosUnequal(source, target)
  if source ~= nil and target ~= nil then
    local _ShortCutEnum = ShortCutProxy.ShortCutEnum
    for k, v in pairs(_ShortCutEnum) do
      if source:GetPosInShortCutGroup(v) ~= target:GetPosInShortCutGroup(v) then
        return true
      end
    end
    local shortCutAuto = ShortCutProxy.SkillShortCut.Auto
    local shortCutAuto2 = ShortCutProxy.SkillShortCut.Auto2
    return source:GetPosInShortCutGroup(shortCutAuto) ~= target:GetPosInShortCutGroup(shortCutAuto) or source:GetPosInShortCutGroup(shortCutAuto2) ~= target:GetPosInShortCutGroup(shortCutAuto2)
  end
  return false
end

function SkillView:CheckAutoIsLast()
  if SkillProxy.Instance:GetEquipedAutoSkillNum() <= 1 then
    MsgManager.ShowMsgByIDTable(1951)
    return true
  end
  return false
end

function SkillView:TakeOffSkill(obj)
  local data = obj.data
  if data ~= nil then
    if data.class == AutoShortCutSkillDragCell then
      if self:CheckAutoIsLast() then
        return
      end
      if data:IsLocked(self.shortcutSwitchID) then
        return
      end
      local normalAtkSkillID = Game.Myself.data:GetAttackSkillIDAndLevel()
      if normalAtkSkillID then
        local skillData = data.data
        if skillData and skillData.staticData and skillData.staticData.id == normalAtkSkillID then
          MsgManager.ConfirmMsgByID(1710, function()
            TipManager.Instance:CloseBubbleTip()
            ServiceSkillProxy.Instance:TakeOffSkill(skillData.id, skillData.sourceId, self:GetShotCutType(data.class))
          end)
          return
        end
      end
    end
    TipManager.Instance:CloseBubbleTip()
    ServiceSkillProxy.Instance:TakeOffSkill(data.data.id, data.data.sourceId, self:GetShotCutType(data.class))
  end
end

function SkillView:GetShotCutType(class)
  if class == ShortCutSkillDragCell then
    return self.shortcutSwitchID
  elseif class == AutoShortCutSkillDragCell then
    return self.autoshortcutSwitchID
  else
    return SceneSkill_pb.ESKILLSHORTCUT_MIN
  end
end

function SkillView:CheckNeedShowProfessToggle()
  local myProfess = profess or MyselfProxy.Instance:GetMyProfession()
  local professTree = ProfessionProxy.Instance:GetProfessionTreeByClassId(myProfess)
end

function SkillView:ProcessCurrentJobLevelAndCustomJobId(jobid, jobLevel)
  local currentJobId = MyselfProxy.Instance:GetMyProfession()
  if jobid < currentJobId then
    if jobid == 1 then
      return 10
    elseif jobid ~= 1 then
      if jobid % 10 == 1 then
        return 40
      elseif jobid % 10 == 2 then
        return 40
      elseif jobid % 10 == 3 then
        return 70
      elseif jobid % 10 == 4 then
        return 60
      elseif jobid % 10 == 5 then
        return 220
      else
        helplog("服务器发了错误的东西！！")
      end
    end
    return 0
  elseif jobid == currentJobId then
    local jobLevelConfig = Table_JobLevel[jobLevel]
    if jobLevelConfig and jobLevelConfig.MasterLv and 0 < jobLevelConfig.MasterLv then
      jobLevel = jobLevel - jobLevelConfig.ShowLevel
    end
    return ProfessionProxy:GetThisJobLevelForClient(jobid, jobLevel)
  elseif jobid > currentJobId then
    return 1
  end
end

function SkillView:UpdateTopByProfess(myProfess, isMaster)
  local config = Table_Class[myProfess]
  IconManager:SetNewProfessionIcon(config.icon, self.professIcon)
  local jobLevel
  local jobLv = self:GetJobLevel()
  if isMaster then
    local jobLevelConfig = Table_JobLevel[jobLv]
    if jobLevelConfig and jobLevelConfig.MasterLv and jobLevelConfig.MasterLv > 0 then
      jobLevel = jobLevelConfig.ShowLevel
    else
      jobLevel = 0
    end
  else
    jobLevel = self:ProcessCurrentJobLevelAndCustomJobId(myProfess, jobLv)
  end
  self.professLevelLabel.text = string.format("Lv.%s", jobLevel)
  local name = ProfessionProxy.GetProfessionName(myProfess, MyselfProxy.Instance:GetMySex())
  self.professNameLabel.text = name
  local iconColor = ColorUtil["CareerIconBg" .. config.Type]
  if iconColor == nil then
    iconColor = ColorUtil.CareerIconBg1
  end
  self.professIconBG.color = iconColor
end

function SkillView:ShowProfessSkillPoints(isShow)
  self.professSkillPoint:SetActive(isShow)
end

function SkillView:UpdateProfessSkillPoints(curPoints, totalPoints)
  self.currentProfessSkillPoints.text = string.format("%s/%s", curPoints, totalPoints or SkillProxy.UNLOCKPROSKILLPOINTS)
end

function SkillView:UpdateSkillSimulatePoints(points)
  self.labSkillPoints.text = string.format(ZhString.SkillView_LeftSkillPointText, points)
end

function SkillView:UpdateTipLabel()
  self.tipLabel:SetActive(self.multiSaveId == nil)
end

function SkillView:RefreshPoints()
  self.leftPointsLabel.text = string.format(ZhString.SkillView_LeftSkillPointText, Game.Myself.data.userdata:Get(UDEnum.SKILL_POINT))
end

function SkillView:ShowDefaultProfessionInfo(isShow)
  self.upLeftWidget.gameObject:SetActive(isShow == true)
end

function SkillView:ShowDefaultShortCutSkills(isShow)
  self.objBottomLeft:SetActive(isShow == true)
end

function SkillView:CheckNeedShowOverFlow(levelUpSkillIDs)
  if FunctionFirstTime.Me():IsFirstTime(FunctionFirstTime.SkillOverFlow) then
    local cells = self.shortCutList:GetCells()
    local equipedNum = 0
    for i = 1, #cells do
      if cells[i].data and cells[i].data.staticData then
        equipedNum = equipedNum + 1
      end
    end
    local skillProxy = SkillProxy.Instance
    local skillType
    if equipedNum >= ShortCutProxy.Instance:GetUnLockSkillMaxIndex() then
      local flag = false
      for i = 1, #levelUpSkillIDs do
        skillType = Table_Skill[levelUpSkillIDs[i]].SkillType
        if not GameConfig.SkillType[skillType].isPassive and skillProxy:GetEquipedSkillBySort(math.floor(levelUpSkillIDs[i] / 1000)) == false then
          flag = true
          break
        end
      end
      if flag then
        FunctionFirstTime.Me():DoneFirstTime(FunctionFirstTime.SkillOverFlow)
        TipManager.Instance:ShowBubbleTipById(BubbleID.SkillFirstTimeOverFlow, self.shortCutArea, nil, {275, -20})
      end
    end
  end
end

function SkillView:RefreshShortCuts()
  self:HandleShortCutSwitchActive()
  local equipDatas = SkillProxy.Instance:GetCurrentEquipedSkillData(true, self.shortcutSwitchID)
  self.shortCutList:ResetDatas(equipDatas)
  local cells = self.shortCutList:GetCells()
  if cells then
    local data
    local HasJobBreak = MyselfProxy.Instance:HasJobBreak()
    local saveData = SaveInfoProxy.Instance:GetSkillData(self.multiSaveId, self.multiSaveType)
    for i = 1, #cells do
      data = cells[i].data
      if data then
        if self.multiSaveId == nil then
          cells[i]:NeedHide(ShortCutProxy.Instance:SkillIsLocked(i, self.shortcutSwitchID))
        elseif saveData ~= nil then
          cells[i]:NeedHide(saveData:SkillIsLocked(i, self.shortcutSwitchID))
        else
          cells[i]:NeedHide(data == nil or data.staticData == nil)
        end
      end
      if data.staticData == nil or data:HasNextID(HasJobBreak) == false and 1 >= data.staticData.Level then
        cells[i]:Hide(cells[i].level.gameObject)
      end
      if self.multiSaveId ~= nil then
        cells[i].dragDrop:SetDragEnable(false)
      end
      cells[i]:AddGuideId(230 + i)
    end
    self.shortCutList:Layout()
  end
end

function SkillView:RefreshSkills()
  self:RefreshShortCuts()
  self:RefreshAutoShortCuts()
end

function SkillView:RefreshProfess()
  self.contentView:CancelSimulate()
  self:CloseSelf()
end

function SkillView:GetJobLevel()
  if self.multiSaveId ~= nil then
    local level = SaveInfoProxy.Instance:GetJobLevel(self.multiSaveId, self.multiSaveType)
    if level ~= nil then
      return level
    end
  end
  return MyselfProxy.Instance:JobLevel()
end

function SkillView:HandleLongPress(isPressing, go)
  TabNameTip.OnLongPress(isPressing, self:FindComponent("Label", UILabel, go).text, true, self:FindComponent("Icon", UISprite, go), nil, nil)
end

function SkillView:RefreshAutoShortCuts()
  self:HandleAutoShortCutSwitchActive()
  local equipDatas = SkillProxy.Instance:GetEquipedAutoSkillData(true, self.autoshortcutSwitchID)
  self.autoShortCutList:ResetDatas(equipDatas)
  local cells = self.autoShortCutList:GetCells()
  if cells then
    local data
    local HasJobBreak = MyselfProxy.Instance:HasJobBreak()
    local saveData = SaveInfoProxy.Instance:GetSkillData(self.multiSaveId, self.multiSaveType)
    for i = 1, #cells do
      data = cells[i].data
      if data then
        if self.multiSaveId == nil then
          cells[i]:NeedHide(ShortCutProxy.Instance:AutoSkillIsLocked(i))
        elseif saveData ~= nil then
          cells[i]:NeedHide(saveData:AutoSkillIsLocked(i))
        else
          cells[i]:NeedHide(data == nil or data.staticData == nil)
        end
      end
      if data.staticData == nil or data:HasNextID(HasJobBreak) == false and 1 >= data.staticData.Level then
        cells[i]:Hide(cells[i].level.gameObject)
      end
      if self.multiSaveId ~= nil then
        cells[i].dragDrop:SetDragEnable(false)
      end
      cells[i]:AddGuideId(330 + i)
    end
    self.autoShortCutList:Layout()
  end
end

function SkillView:HandleAutoShortCutSwitchActive(note)
  local funcEnable = false
  local _AutoEnum = ShortCutProxy.AutoList
  local _ShortCutProxy = ShortCutProxy.Instance
  local _SaveInfoProxy = SaveInfoProxy.Instance
  local ID1 = _AutoEnum[1]
  for k, v in pairs(_AutoEnum) do
    if v ~= ID1 then
      if self.multiSaveId == nil then
        funcEnable = _ShortCutProxy:AutoShortCutListIsEnable()
      end
      if funcEnable then
        break
      end
    end
  end
  if funcEnable then
    self:SetActive(self.autoSkillShortCutSwitchBtn, true)
    return true
  else
    self:SetActive(self.autoSkillShortCutSwitchBtn, false)
  end
  return false
end

function SkillView:IsHeroProfess(profess)
  local myClassConfig = Table_Class[profess]
  return myClassConfig and myClassConfig.FeatureSkill
end

function SkillView:SwitchBG(type)
  if type == 1 then
    self.innerBg:SetActive(true)
    self.innerBg2:SetActive(false)
  else
    self.innerBg:SetActive(false)
    self.innerBg2:SetActive(true)
  end
end

function SkillView:ActiveBottom(bool)
  self.l_objBottom:SetActive(bool)
end

function SkillView:SetMaskColliderOn(on)
  self.maskCollider:SetActive(on)
end

function SkillView:UpdateRecommendBtn(active)
  self.recommendBtn:SetActive(active)
  self.resetBtn:SetActive(active)
end
