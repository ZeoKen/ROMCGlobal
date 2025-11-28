autoImport("CreateRoleHairStyleCell")
autoImport("CreateRoleEyeStyleCell")
autoImport("CreateRoleColorCell")
autoImport("CreateRoleGenderCell")
autoImport("CreateRoleRaceCell")
autoImport("CreateRoleDressTabCell")
autoImport("FunctionMaskWord")
autoImport("UIBlackScreen")
autoImport("UIRoleSelect")
autoImport("UIModelRolesList")
autoImport("WeGameHelper")
autoImport("WaitEnterBord")
autoImport("FunctionCreateRole_v3")
autoImport("FunctionADBuiltInTyrantdb")
CreateRoleView_v3 = class("CreateRoleView_v3", BaseView)
CreateRoleView_v3.ViewType = UIViewType.MainLayer
local CreateRoleTrackEventNames = {
  Enter = "#crole_enter",
  Stay_0_10 = "#crole_stay_0_10",
  Stay_10_120 = "#crole_stay_10_120",
  Stay_120_Plus = "#crole_stay_120_plus",
  Change_Sex = "#crole_click_change_sex",
  Fail_1 = "#crole_fail_1",
  Fail_2 = "#crole_fail_2",
  Fail_3 = "#crole_fail_3",
  Fail_4 = "#crole_fail_4",
  Fail_5_Plus = "#crole_fail_5_plus",
  Fail_Empty_Name = "#crole_fail_empty_name",
  Fail_Illegal_Name_1 = "#crole_fail_illegal_name_1",
  Fail_Illegal_Name_2 = "#crole_fail_illegal_name_2",
  Fail_Illegal_Name_3 = "#crole_fail_illegal_name_3",
  Fail_Illegal_Name_4 = "#crole_fail_illegal_name_4",
  Fail_Illegal_Name_5_Plus = "#crole_fail_illegal_name_5_plus",
  Success = "#crole_success"
}

function CreateRoleView_v3:Init()
  Buglylog("CreateRoleView_v3:Init")
  self:FindObjs()
  self:AddEvt()
  self.waitEnterBord = WaitEnterBord.new(self:FindGO("WaitEnterBord"))
end

function CreateRoleView_v3:FindObjs()
  self.mask = self:FindComponent("MaskFade", UISprite)
  self.mask.gameObject:SetActive(false)
  self.leftTopPanel = self:FindGO("LeftTopPanel")
  self.ReturnButton = self:FindGO("ReturnBtn", self.leftTopPanel)
  self:AddClickEvent(self.ReturnButton, function(go)
    self:OnReturnButton()
  end)
  self.leftPanel = self:FindGO("LeftPanel")
  self.raceTabs = {}
  local normalTabGO = self:FindGO("TabNormal", self.leftPanel)
  local normalIcon = self:FindComponent("Icon", UISprite, normalTabGO)
  IconManager:SetNewProfessionIcon("icon_1_0", normalIcon)
  self.raceTabs[1] = CreateRoleRaceCell.new(normalTabGO)
  self:AddClickEvent(normalTabGO, function()
    self:ChangeRace(1)
  end)
  if not ProfessionProxy.IsDoramForbidden() then
    local doramTabGO = self:FindGO("TabDoram", self.leftPanel)
    local doramIcon = self:FindComponent("Icon", UISprite, doramTabGO)
    IconManager:SetNewProfessionIcon("icon_15_0", doramIcon)
    self.raceTabs[2] = CreateRoleRaceCell.new(doramTabGO)
    self:AddClickEvent(doramTabGO, function()
      self:ChangeRace(2)
    end)
  else
    self.leftPanel:SetActive(false)
  end
  self.leftBottomPanel = self:FindGO("LeftBottomPanel")
  self.genderTabs = {}
  local maleGO = self:FindGO("Male", self.leftBottomPanel)
  self:AddClickEvent(maleGO, function()
    self:ChangeGender(1)
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Change_Sex)
  end)
  self.genderTabs[1] = CreateRoleGenderCell.new(maleGO)
  local femaleGO = self:FindGO("Female", self.leftBottomPanel)
  self:AddClickEvent(femaleGO, function()
    self:ChangeGender(2)
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Change_Sex)
  end)
  self.genderTabs[2] = CreateRoleGenderCell.new(femaleGO)
  self.bottomPanel = self:FindGO("BottomPanel")
  self.goNameInput = self:FindGO("NameInput", self.bottomPanel)
  self.nameInput = self.goNameInput:GetComponent(UIInput)
  local max_size = GameConfig.System.namesize_max or 99
  UIUtil.LimitInputCharacter(self.nameInput, max_size)
  SkipTranslatingInput(self.nameInput)
  self.nameInputLabel = self:FindGO("Label", self.nameInput.gameObject):GetComponent(UILabel)
  self.rightPanel = self:FindGO("RightPanel")
  self.dressTable = self:FindComponent("DressingTable", UITable, self.rightPanel)
  self.dressTabTween = self:FindComponent("DressingTable", UIPlayTween, self.rightPanel)
  self.dressTabs = {}
  local hairTabGO = self:FindGO("TabHair", self.rightPanel)
  self.dressTabs[1] = CreateRoleDressTabCell.new(hairTabGO)
  self:AddClickEvent(hairTabGO, function()
    self:OnDressTabClicked(1)
  end)
  local eyeTabGO = self:FindGO("TabEye", self.rightPanel)
  self.dressTabs[2] = CreateRoleDressTabCell.new(eyeTabGO)
  self:AddClickEvent(eyeTabGO, function()
    self:OnDressTabClicked(2)
  end)
  self.createRoleBtn = self:FindGO("CreateRoleBtn")
  self:AddButtonEvent("CreateRoleBtn", function(go)
    if FunctionCreateRole_v3.Me():IsDoramSelected() then
      MsgManager.ConfirmMsgByID(297, function()
        self:TryEnterGame()
        ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(213)
      end)
    else
      self:TryEnterGame()
      ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(213)
    end
  end, {hideClickSound = false})
  self.hairStyleCtrl = ListCtrl.new(self:FindComponent("HairStyleWrap", UIGrid, hairTabGO), CreateRoleHairStyleCell, "CreateRoleHairStyleCell")
  self.hairStyleCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHairStyleCellClicked, self)
  self.hairStyleCtrl:SetDisableDragIfFit()
  self.hairStyleCtrl.disableDragPfbNum = 12
  self.hairColorCtrl = ListCtrl.new(self:FindComponent("HairColorWrap", UIGrid, hairTabGO), CreateRoleColorCell, "CreateRoleColorCell")
  self.hairColorCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHairColorCellClicked, self)
  self.hairColorCtrl:SetDisableDragIfFit()
  self.hairColorCtrl.disableDragPfbNum = 8
  self.eyeStyleCtrl = ListCtrl.new(self:FindComponent("EyeStyleWrap", UIGrid, eyeTabGO), CreateRoleEyeStyleCell, "CreateRoleHairStyleCell")
  self.eyeStyleCtrl:AddEventListener(MouseEvent.MouseClick, self.OnEyeStyleCellClicked, self)
  self.eyeStyleCtrl:SetDisableDragIfFit()
  self.eyeStyleCtrl.disableDragPfbNum = 12
  self.eyeColorCtrl = ListCtrl.new(self:FindComponent("EyeColorWrap", UIGrid, eyeTabGO), CreateRoleColorCell, "CreateRoleColorCell")
  self.eyeColorCtrl:AddEventListener(MouseEvent.MouseClick, self.OnEyeColorCellClicked, self)
  self.eyeColorCtrl:SetDisableDragIfFit()
  self.eyeColorCtrl.disableDragPfbNum = 8
  self.dressingPanels = {
    self:FindComponent("ContentPanel", UIPanel, hairTabGO),
    self:FindComponent("ContentPanel", UIPanel, eyeTabGO)
  }
  self.stylePageCtrls = {
    self.hairStyleCtrl,
    self.eyeStyleCtrl
  }
  self.colorPageCtrls = {
    self.hairColorCtrl,
    self.eyeColorCtrl
  }
  self:OnDressTabClicked(1)
  self.midPanel = self:FindGO("MidPanel")
  self:AddDragEvent(self.midPanel, function(go, vec2)
    self:RotateRole(-vec2.x)
  end)
  local uiAnimSpeedFactor = GameConfig.CreateRole.UIAnimSpeedFactor or 1
  self.lt_tw_a = self.leftTopPanel:GetComponent(TweenAlpha)
  self.lt_tw_a.duration = self.lt_tw_a.duration / uiAnimSpeedFactor
  self.lt_tw_p = self.leftTopPanel:GetComponent(TweenPosition)
  self.lt_tw_p.duration = self.lt_tw_p.duration / uiAnimSpeedFactor
  self.l_tw_a = self.leftPanel:GetComponent(TweenAlpha)
  self.l_tw_a.duration = self.l_tw_a.duration / uiAnimSpeedFactor
  self.l_tw_p = self.leftPanel:GetComponent(TweenPosition)
  self.l_tw_p.duration = self.l_tw_p.duration / uiAnimSpeedFactor
  self.lb_tw_a = self.leftBottomPanel:GetComponent(TweenAlpha)
  self.lb_tw_a.duration = self.lb_tw_a.duration / uiAnimSpeedFactor
  self.lb_tw_p = self.leftBottomPanel:GetComponent(TweenPosition)
  self.lb_tw_p.duration = self.l_tw_p.duration / uiAnimSpeedFactor
  self.r_tw_a = self.rightPanel:GetComponent(TweenAlpha)
  self.r_tw_a.duration = self.r_tw_a.duration / uiAnimSpeedFactor
  self.r_tw_p = self.rightPanel:GetComponent(TweenPosition)
  self.r_tw_p.duration = self.r_tw_p.duration / uiAnimSpeedFactor
  self.b_tw_a = self.bottomPanel:GetComponent(TweenAlpha)
  self.b_tw_a.duration = self.b_tw_a.duration / uiAnimSpeedFactor
  self.b_tw_p = self.bottomPanel:GetComponent(TweenPosition)
  self.b_tw_p.duration = self.b_tw_p.duration / uiAnimSpeedFactor
  self.goNetworkTip = self:FindGO("NetworkTip", self.gameObject)
  self.goBTNCloseNetworkTip = self:FindGO("BTN_Close", self.goNetworkTip)
  self.labNetworkTipContent = self:FindGO("Content", self.goNetworkTip):GetComponent(UILabel)
  self.labNetworkTipContent.text = ZhString.StartGamePanel_WaitingLabel
  self.goNetworkTip:SetActive(false)
  self:AddClickEvent(self.goBTNCloseNetworkTip, function()
    self.timerForCheckTimeout:StopTick()
    MsgManager.ConfirmMsgByID(1028, function()
      self:OnClickForButtonBackLogin()
    end, function()
      self.timerForCheckTimeout:StartTick()
    end)
  end)
end

function CreateRoleView_v3:AddEvt()
  self:AddListenEvt(FunctionNewCreateRoleEvent.ModelLoadCanOperation, self.OnCreateRoleModelLoadedBeginShow)
  self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.OnResponseCreateRoleSuccess)
  self:AddListenEvt(ServiceEvent.Error, self.OnResponseCreateRoleFail)
  self:AddListenEvt(FunctionNewCreateRoleEvent.ESYSTEMMSG_ID_TEXT_ADVERTISE, self.OnResponseCreateRoleFail)
  self:AddListenEvt(FunctionNetError.BackToLogin, self.OnBackToLogin)
  self:AddListenEvt(ServiceEvent.ConnNetDown, self.OnReceiveNetOff)
  self:AddListenEvt(XDEUIEvent.CreateBack, self.OnReturnButton)
  EventManager.Me():AddEventListener(CreateRoleViewEvent.PlayerMapChange, self.OnPlayerMapChangeForCreateRole, self)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
end

function CreateRoleView_v3:UpdateCamera()
end

function CreateRoleView_v3:RotateRole(delta)
  FunctionCreateRole_v3.Me():RotateRole(delta)
end

function CreateRoleView_v3:OnEnter()
  CreateRoleView_v3.super.OnEnter(self)
  self.mask.gameObject:SetActive(false)
  FunctionCreateRole_v3.Me():Launch()
  self:UpdateView()
  self.roleIndex = self.viewdata.index or 2
  if self.roleIndex then
    UIModelRolesList.Ins():SetEmptyIndex(self.roleIndex)
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:OnReturnButton()
  end)
  self:StartUserBehaviourTrack()
end

function CreateRoleView_v3:OnExit()
  Buglylog("CreateRoleView_v3:OnExit")
  CreateRoleView_v3.super.OnExit(self)
  self:StopUserBehaviourTrack()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  TimeTickManager.Me():ClearTick(self)
  ServicePlayerProxy.mapChangeForCreateRole = false
  EventManager.Me():RemoveEventListener(CreateRoleViewEvent.PlayerMapChange, self.OnPlayerMapChangeForCreateRole, self)
  EventManager.Me():RemoveEventListener(CreateRoleViewEvent.BackToLogo, self.OnExit, self)
  if self.maskFadeLeanTween ~= nil then
    LeanTween.cancel(self.mask.gameObject)
    self.maskFadeLeanTween = nil
  end
  if self.waitEnterBord ~= nil then
    self.waitEnterBord:OnDestroy()
    self.waitEnterBord = nil
  end
  FunctionCreateRole_v3.Me():Shutdown()
  LoginRoleSelector.Ins():ClearAllEffect()
end

function CreateRoleView_v3:ChangeRace(index)
  if FunctionCreateRole_v3.Me():ChangeRace(index) then
    self:UpdateView()
  end
end

function CreateRoleView_v3:ChangeGender(index)
  if FunctionCreateRole_v3.Me():ChangeGender(index) then
    self:UpdateView()
  end
end

function CreateRoleView_v3:OnDressTabClicked(index)
  if self.selectedDressTab == index then
    index = index + 1
    if index > #self.dressTabs then
      index = 1
    end
  end
  for i, v in ipairs(self.dressTabs) do
    v:SetSelected(index == i)
  end
  local forward = self.dressTabTween:Play(index ~= 1)
  self:TweenPanels(index)
  self.stylePageCtrls[index]:Layout()
  self.colorPageCtrls[index]:Layout()
  self.selectedDressTab = index
  FunctionCreateRole_v3.Me():ChangeDressingTab(index)
end

function CreateRoleView_v3:TweenPanels(selectedIndex)
  for i, panel in ipairs(self.dressingPanels) do
    LeanTween.cancel(panel.gameObject)
    local clipOffset = panel.clipOffset
    local toOffsetY = selectedIndex == i and 0 or 440
    LeanTween.value(panel.gameObject, function(val)
      clipOffset.y = val
      panel.clipOffset = clipOffset
    end, clipOffset.y, toOffsetY, 0.2)
  end
end

function CreateRoleView_v3:InvalidatePanelClip()
  for _, v in ipairs(self.dressingPanels) do
    v:Invalidate(true)
  end
end

function CreateRoleView_v3:StartPanelRefreshTimer()
  if not self.refreshPanelTimer then
    self.refreshPanelTimer = TimeTickManager.Me():CreateTick(16, 16, function()
      self:InvalidatePanelClip()
    end, self)
  end
end

function CreateRoleView_v3:StopPanelRefreshTimer()
  if self.refreshPanelTimer then
    self.refreshPanelTimer:Destroy()
    self.refreshPanelTimer = nil
  end
end

function CreateRoleView_v3:OnHairStyleCellClicked(cell)
  if FunctionCreateRole_v3.Me():ChangeHairStyle(cell.data.id) then
    self:UpdateHairStylePanel()
    self:UpdateHairColorPanel()
  end
end

function CreateRoleView_v3:OnHairColorCellClicked(cell)
  if FunctionCreateRole_v3.Me():ChangeHairColor(cell.data.id) then
    self:UpdateHairColorPanel()
  end
end

function CreateRoleView_v3:OnEyeStyleCellClicked(cell)
  if FunctionCreateRole_v3.Me():ChangeEyeStyle(cell.data.id) then
    self:UpdateEyeStylePanel()
    self:UpdateEyeColorPanel()
  end
end

function CreateRoleView_v3:OnEyeColorCellClicked(cell)
  if FunctionCreateRole_v3.Me():ChangeEyeColor(cell.data.id) then
    self:UpdateEyeStylePanel()
    self:UpdateEyeColorPanel()
  end
end

function CreateRoleView_v3:UpdateView()
  self:UpdateRaceTabs()
  self:UpdateGenderTabs()
  self:UpdateHairStylePanel()
  self:UpdateHairColorPanel()
  self:UpdateEyeStylePanel()
  self:UpdateEyeColorPanel()
end

function CreateRoleView_v3:UpdateRaceTabs()
  local ctrl = FunctionCreateRole_v3.Me()
  for i, tab in ipairs(self.raceTabs) do
    tab:SetSelected(i == ctrl.selectedRaceIndex)
  end
end

function CreateRoleView_v3:UpdateGenderTabs()
  local ctrl = FunctionCreateRole_v3.Me()
  for i, tab in ipairs(self.genderTabs) do
    tab:SetSelected(i == ctrl.selectedGenderIndex)
  end
end

function CreateRoleView_v3:UpdateHairStylePanel()
  local styles, index = FunctionCreateRole_v3.Me():GetSelectedHairStyleConfigs()
  styles = styles or {}
  self.hairStyleCtrl:ResetDatas(styles)
  local cells = self.hairStyleCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:SetSelected(cell.data.id == index)
  end
end

function CreateRoleView_v3:UpdateHairColorPanel()
  local colors, index = FunctionCreateRole_v3.Me():GetSelectedHairColorConfigs()
  colors = colors or {}
  self.hairColorCtrl:ResetDatas(colors)
  cells = self.hairColorCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:SetSelected(cell.data.id == index)
  end
end

function CreateRoleView_v3:UpdateEyeStylePanel()
  local styles, index = FunctionCreateRole_v3.Me():GetSelectedEyeStyleConfigs()
  styles = styles or {}
  self.eyeStyleCtrl:ResetDatas(styles)
  local cells = self.eyeStyleCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:SetSelected(cell.data.id == index)
  end
end

function CreateRoleView_v3:UpdateEyeColorPanel()
  local colors, index = FunctionCreateRole_v3.Me():GetSelectedEyeColorConfigs()
  colors = colors or {}
  self.eyeColorCtrl:ResetDatas(colors)
  local cells = self.eyeColorCtrl:GetCells()
  for _, cell in ipairs(cells) do
    cell:SetSelected(cell.data.id == index)
  end
end

function CreateRoleView_v3:IsRedName(id)
  for i = 1, #GameConfig.CreateRoleFail.RedName do
    if GameConfig.CreateRoleFail.RedName[i] == id then
      return true
    end
  end
  return false
end

function CreateRoleView_v3:DisableInput()
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, false)
  for i = 1, #colliders do
    local v = colliders[i]
    if v.gameObject.name ~= "BTN_Close" then
      v.enabled = false
    end
  end
end

function CreateRoleView_v3:EnableInput()
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, false)
  for i = 1, #colliders do
    local v = colliders[i]
    v.enabled = true
  end
end

function CreateRoleView_v3:TryEnterGame()
  GameFacade.Instance:sendNotification(XDEUIEvent.CloseCreateRoleTip)
  if self.enter_tryed then
    return
  end
  local afkProxy = AfkProxy.Instance
  if afkProxy.isAfk and not afkProxy.hasQuitAfk then
    MsgManager.ConfirmMsgByID(41149, function()
      afkProxy:SetAfk(false)
      self.enter_tryed = true
      self:DoEnterGame()
      ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(215)
    end)
    return
  end
  self.enter_tryed = true
  self:DoEnterGame()
end

function CreateRoleView_v3:DoEnterGame()
  self.name = self.nameInput.value
  if ContainsSpecialCharacters(self.name) then
    MsgManager.ShowMsgByID(1005)
    self.enter_tryed = false
    self:TrackIllegalName()
    return
  end
  if self.name == "" then
    FunctionNetError.Me():ShowErrorById(8)
    self.enter_tryed = false
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_Empty_Name)
    self:TrackIllegalName()
    return
  end
  self.name = RemoveSpecialChara(self.nameInput.value)
  if string.find(self.name, " ") or string.find(self.name, "　") or not StringUtil.CheckTextValidForDisplay(self.name) then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(7)
    self.enter_tryed = false
    self:TrackIllegalName()
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(self.name, GameConfig.MaskWord.PlayerName) then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(7)
    self.enter_tryed = false
    self:TrackIllegalName()
    return
  end
  local length = StringUtil.Utf8len(self.name)
  if length < GameConfig.System.namesize_min or length > GameConfig.System.namesize_max then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(9)
    self.enter_tryed = false
    self:TrackIllegalName()
    return
  end
  if self.timerForCheckTimeout == nil then
    self.timerForCheckTimeout = TimeTickManager.Me():CreateTick(1000, 1000, self.OnTimeTickForCheckTimeout, self, 2)
  end
  self.timerForCheckTimeout:StartTick()
  CreateRoleView_v3.requestTime = 0
  
  function self.requestTimeoutEvent()
    self:TrackCreateRoleFail()
    self.goBTNCloseNetworkTip:SetActive(true)
  end
  
  self:RequestCreateRole()
  self.flagRequestCreateRole = true
  self:DisableInput()
  self.goNetworkTip:SetActive(true)
  self.goBTNCloseNetworkTip:SetActive(false)
  local serverData = FunctionLogin.Me():getCurServerData()
  local openTime = serverData.opentime or 0
  if openTime > ServerTime.CurServerTime() / 1000 then
    self.enter_tryed = false
  end
  FunctionCheck.Me():SetSysMsg(UnityTime + 20)
end

function CreateRoleView_v3:OnTimeTickForCheckTimeout()
  CreateRoleView_v3.requestTime = CreateRoleView_v3.requestTime + 1
  if CreateRoleView_v3.requestTime >= GameConfig.LoginRole.requestOuttime then
    self.timerForCheckTimeout:StopTick()
    if self.requestTimeoutEvent ~= nil then
      self.requestTimeoutEvent()
    end
  end
end

function CreateRoleView_v3:RequestCreateRole()
  local defaultName = self.nameInput.value
  defaultName = RemoveSpecialChara(self.nameInput.value)
  local codeUTF8 = LuaUtils.StrToUtf8(defaultName)
  local roleSlotIndex = UIModelRolesList.Ins():GetEmptyIndex()
  FunctionCreateRole_v3.Me():SendCreateRoleReq(codeUTF8, roleSlotIndex)
end

function CreateRoleView_v3:OnResponseCreateRoleFail(note)
  redlog("[bt] OnResponseCreateRoleFail")
  local errCode = note and note.body
  if errCode == ErrorUserCmd_pb.REG_ERR_NAME_INVALID or ErrorCode == ErrorUserCmd_pb.REG_ERR_NAME_EMPTY or ErrorCode == ErrorUserCmd_pb.REG_ERR_NAME_OVERMAXLEN or ErrorCode == ErrorUserCmd_pb.REG_ERR_NAME_DUPLICATE then
    self:TrackIllegalName()
  else
    self:TrackCreateRoleFail()
  end
  if self.flagRequestCreateRole then
    self.flagRequestCreateRole = false
    if self.timerForCheckTimeout ~= nil then
      self.timerForCheckTimeout:StopTick()
    end
    self.enter_tryed = false
    self:EnableInput()
    self.goNetworkTip:SetActive(false)
    MsgManager.CloseConfirmMsgByID(1028)
    if self:IsRedName(note.body) then
      self.nameInputLabel.color = ColorUtil.NGUILabelRed
    end
  end
end

function CreateRoleView_v3:OnResponseCreateRoleSuccess(note)
  redlog("[bt] OnResponseCreateRoleSuccess")
  if self.newRoleId then
    local serverData = FunctionLogin.Me():getCurServerData()
    local openTime = serverData.opentime or 0
    if openTime == 0 or openTime < ServerTime.CurServerTime() / 1000 then
      self:CallSelectAndEnter(self.newRoleId)
      return
    else
      self:TweenToSelectRole()
    end
    return
  end
  local data = ServiceUserProxy.Instance:GetNewRoleInfo()
  if data == nil then
    data = self:CheckCreatedDataByIndex()
  end
  if data == nil then
    if self.retryedCount == nil then
      self.retryedCount = 1
    else
      self.retryedCount = self.retryedCount + 1
    end
    if self.retryedCount <= 5 and self.enter_tryed then
      self.enter_tryed = false
      self:TryEnterGame()
      return
    end
  end
  if data == nil then
    return
  end
  if BranchMgr.IsJapan() then
    OverseaHostHelper:AFTrack("名前登録")
  end
  self.newRoleId = data.id
  local serverData = FunctionLogin.Me():getCurServerData()
  local openTime = serverData.opentime or 0
  if openTime == 0 or openTime < ServerTime.CurServerTime() / 1000 then
    self:CallSelectAndEnter(self.newRoleId)
    return
  else
    self:TweenToSelectRole()
  end
end

function CreateRoleView_v3:CheckCreatedDataByIndex()
  local roles = ServiceUserProxy.Instance:GetAllRoleInfos()
  if roles == nil then
    return
  end
  if self.roleIndex == nil then
    return
  end
  for _, role in pairs(roles) do
    if role.id and role.id ~= 0 and self.roleIndex == role.sequence then
      return role
    end
  end
end

function CreateRoleView_v3:CallSelectAndEnter(newRoleId)
  if self.timerForCheckTimeout ~= nil then
    self.timerForCheckTimeout:StopTick()
  end
  self.enter_tryed = false
  self:EnableInput()
  self.goNetworkTip:SetActive(false)
  MsgManager.CloseConfirmMsgByID(1028)
  self.reciveData = data
  if newRoleId ~= nil and newRoleId ~= 0 then
    if BranchMgr.IsTW() then
      local server = FunctionLogin.Me():getCurServerData()
      local serverID = server ~= nil and server.serverid or 1
      WeGameHelper:trackCreatRole(serverID, 1)
    end
    self:DisableInput()
    self.goNetworkTip:SetActive(true)
    self.goBTNCloseNetworkTip:SetActive(false)
    CreateRoleView_v3.requestTime = 0
    self.timerForCheckTimeout:StartTick()
    
    function self.requestTimeoutEvent()
      self.goBTNCloseNetworkTip:SetActive(true)
    end
    
    ServicePlayerProxy.mapChangeForCreateRole = true
    ServiceUserProxy.Instance:CallSelect(newRoleId)
    UIModelRolesList.Ins():SetSelectedRole(newRoleId)
    if not BranchMgr.IsChina() then
      if BranchMgr.IsTW() or BranchMgr.IsKorea() then
        OverSeas_TW.OverSeasManager.GetInstance():TrackEvent("rt19op")
      else
        OverSeas_TW.OverSeasManager.GetInstance():TrackCreateRole()
      end
    end
  end
end

function CreateRoleView_v3:OnPlayerMapChangeForCreateRole(message)
  if self.timerForCheckTimeout ~= nil then
    self.timerForCheckTimeout:StopTick()
  end
  ServicePlayerProxy.mapChangeForCreateRole = false
  self.goNetworkTip:SetActive(false)
  MsgManager.CloseConfirmMsgByID(1028)
  if self.maskFadeLeanTween ~= nil then
    LeanTween.cancel(self.mask.gameObject)
    self.maskFadeLeanTween = nil
  end
  local tweenStart = 0
  local tweenEnd = 1
  local tweenTime = 1.5
  self.mask.gameObject:SetActive(true)
  self.maskFadeLeanTween = LeanTween.alphaNGUI(self.mask, tweenStart, tweenEnd, tweenTime)
  self.maskFadeLeanTween:setOnComplete(function()
    self.maskFadeLeanTween = nil
    self:EnterInGame()
    ServicePlayerProxy.Instance:MapChange(message)
    if self.waitEnterBord then
      self.waitEnterBord:Active(true)
    end
  end)
end

function CreateRoleView_v3:EnterInGame(note)
  FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Success)
  local goMainCamera = GameObject.Find("Main Camera")
  if not GameObjectUtil.Instance:ObjectIsNULL(goMainCamera) then
    goMainCamera:SetActive(false)
  end
  self:CloseSelf()
  ResourceManager.Instance.IsAsyncLoadOn = true
  redlog("ResourceManager.Instance.IsAsyncLoadOn =======2======= " .. tostring(ResourceManager.Instance.IsAsyncLoadOn))
  FrameRateSpeedUpChecker.Instance():Open()
end

function CreateRoleView_v3:OnBackToLogin()
  Game.Me():BackToLogo()
end

function CreateRoleView_v3:OnReceiveNetOff()
  self:CloseMainCamera()
  self:Hide()
end

function CreateRoleView_v3:CloseMainCamera()
  local gameObjectMainCamera = GameObject.FindGameObjectWithTag("MainCamera")
  if gameObjectMainCamera then
    local mainCamera = gameObjectMainCamera:GetComponent("Camera")
    mainCamera.enabled = false
  end
end

function CreateRoleView_v3:OnReturnButton()
  self:TweenToSelectRole()
end

function CreateRoleView_v3:TweenToSelectRole()
  if not (not self.maskFadeLeanTween and self.mask) or self.enter_tryed == true then
    return
  end
  local tweenStart = 0
  local tweenEnd = 1
  local tweenTime = 1.5
  self.mask.gameObject:SetActive(true)
  self.maskFadeLeanTween = LeanTween.alphaNGUI(self.mask, tweenStart, tweenEnd, tweenTime)
  self.maskFadeLeanTween:setOnComplete(function()
    self.maskFadeLeanTween = nil
    if not BranchMgr.IsJapan() then
      self:GoToSelectRole()
      return
    end
    Game.OpenScene_CharacterChoose(function()
      CSharpObjectForLogin.Ins():Initialize(function()
        GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
          viewname = "StartGamePanel"
        })
        self:CloseSelf()
      end)
    end)
  end)
end

function CreateRoleView_v3:GoToSelectRole()
  Game.OpenScene_CharacterChoose(function()
    CSharpObjectForLogin.Ins():Initialize(function()
      local cameraController = CSharpObjectForLogin.Ins():GetCameraController()
      cameraController:GoToSelectRole()
      UIRoleSelect.Ins():Open()
      self:CloseSelf()
    end)
  end)
end

function CreateRoleView_v3:OnCreateRoleModelLoadedBeginShow()
  local tweenStart = 1
  local tweenEnd = 0
  local tweenTime = 4
  self.mask.gameObject:SetActive(true)
  self.maskFadeLeanTween = LeanTween.alphaNGUI(self.mask, tweenStart, tweenEnd, tweenTime)
  self.maskFadeLeanTween:setOnComplete(function()
    self.maskFadeLeanTween = nil
    self.mask.gameObject:SetActive(false)
  end)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function()
    self:ShowLeftUI(true)
  end, self, 1001)
end

function CreateRoleView_v3:OnClickForButtonContinueWait()
  self.timerForCheckTimeout:StartTick()
  CreateRoleView_v3.requestTime = 0
end

function CreateRoleView_v3:OnClickForButtonBackLogin()
  Game.Me():BackToLogo()
end

function CreateRoleView_v3:StartUserBehaviourTrack()
  self.trackEnterTime = ServerTime.CurServerTime() / 1000
  self.trackLastStayDuration = 0
  self.trackFailTimes = 0
  self.trackIllegalNameTimes = 0
  FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Enter)
  if not self.trackTimer then
    self.trackTimer = TimeTickManager.Me():CreateTick(0, 1000, function()
      self:UpdateUserBehaviourTrack()
    end, self, 2001)
  end
end

function CreateRoleView_v3:StopUserBehaviourTrack()
  if self.trackTimer then
    self.trackTimer:Destroy()
    self.trackTimer = nil
  end
end

function CreateRoleView_v3:UpdateUserBehaviourTrack()
  local stayDuration = ServerTime.CurServerTime() / 1000 - self.trackEnterTime
  if 120 < stayDuration then
    if 120 >= self.trackLastStayDuration then
      FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Stay_120_Plus)
    end
    self:StopUserBehaviourTrack()
  elseif 10 < stayDuration then
    if self.trackLastStayDuration <= 10 then
      FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Stay_10_120)
    end
  elseif 0 < stayDuration and self.trackLastStayDuration <= 0 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Stay_0_10)
  end
  self.trackLastStayDuration = stayDuration
end

function CreateRoleView_v3:TrackCreateRoleFail()
  self.trackFailTimes = self.trackFailTimes and self.trackFailTimes + 1 or 1
  if self.trackFailTimes == 1 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_1)
  elseif self.trackFailTimes == 2 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_2)
  elseif self.trackFailTimes == 3 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_3)
  elseif self.trackFailTimes == 4 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_4)
  elseif self.trackFailTimes >= 5 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_5_Plus)
  end
end

function CreateRoleView_v3:TrackIllegalName()
  self:TrackCreateRoleFail()
  self.trackIllegalNameTimes = self.trackIllegalNameTimes and self.trackIllegalNameTimes + 1 or 1
  if self.trackIllegalNameTimes == 1 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_Illegal_Name_1)
  elseif self.trackIllegalNameTimes == 2 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_Illegal_Name_2)
  elseif self.trackIllegalNameTimes == 3 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_Illegal_Name_3)
  elseif self.trackIllegalNameTimes == 4 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_Illegal_Name_4)
  elseif self.trackIllegalNameTimes >= 5 then
    FunctionADBuiltInTyrantdb.Instance():SendTrackEvent(CreateRoleTrackEventNames.Fail_Illegal_Name_5_Plus)
  end
end
