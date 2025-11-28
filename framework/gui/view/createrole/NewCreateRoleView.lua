autoImport("MakeRole")
autoImport("HairStyleCell")
autoImport("HeadwearCell")
autoImport("FunctionMaskWord")
autoImport("UIBlackScreen")
autoImport("UIRoleSelect")
autoImport("UIModelRolesList")
autoImport("WeGameHelper")
autoImport("WaitEnterBord")
autoImport("NewCreateRoleRoulette")
autoImport("NewCreateRoleProfSelectCell")
NewCreateRoleView = class("NewCreateRoleView", BaseView)
NewCreateRoleView.ViewType = UIViewType.MainLayer
local sexSelectEffect = "Eff_GenderChoice_ui"
local sexSelectFx
local startAngleOffset = -11.25
local isAlphaPreview = true

function NewCreateRoleView:Init()
  Buglylog("NewCreateRoleView:Init")
  self:InitData()
  self:FindObjs()
  self:AddEvt()
  self.waitEnterBord = WaitEnterBord.new(self:FindGO("WaitEnterBord"))
  self:CreateProfRoulette()
  self:CalibrateViewPortOfUICamera()
end

function NewCreateRoleView:InitData()
end

function NewCreateRoleView:FindObjs()
  self.topBord = self:FindGO("SexSelect")
  self.maleSelect = {}
  self.maleSelect.go = self:FindGO("Male", self.topBord)
  self.maleSelect.fxHolder = self:FindGO("FxHolder", self.maleSelect.go)
  self.maleSelect.icon = self:FindComponent("icon", UISprite, self.maleSelect.go)
  self.maleSelect.select = self:FindGO("select", self.maleSelect.go)
  self:AddClickEvent(self.maleSelect.go, function(go)
    self:DoSelectSex(ProtoCommon_pb.EGENDER_MALE)
  end)
  self.femaleSelect = {}
  self.femaleSelect.go = self:FindGO("Female", self.topBord)
  self.femaleSelect.fxHolder = self:FindGO("FxHolder", self.femaleSelect.go)
  self.femaleSelect.icon = self:FindComponent("icon", UISprite, self.femaleSelect.go)
  self.femaleSelect.select = self:FindGO("select", self.femaleSelect.go)
  self:AddClickEvent(self.femaleSelect.go, function(go)
    self:DoSelectSex(ProtoCommon_pb.EGENDER_FEMALE)
  end)
  self:PlayUIEffect(sexSelectEffect, self.gameObject, false, function(go)
    sexSelectFx = go
    sexSelectFx.gameObject:SetActive(false)
  end)
  self.bottomBord = self:FindGO("Bottom")
  self.goNameInput = self:FindGO("NameInput", self.goBottom)
  self.nameInput = self.goNameInput:GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.nameInput, 12)
  SkipTranslatingInput(self.nameInput)
  self.nameInputLabel = self:FindGO("Label", self.nameInput.gameObject):GetComponent(UILabel)
  self:AddClickEvent(self:FindGO("TipBtn", self.goBottom), function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CreateTipPanel
    })
  end)
  self.ReturnButton = self:FindGO("ReturnBtn")
  self.ReturnButtonBC = self.ReturnButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.ReturnButton, function(go)
    self:OnReturnButton()
  end)
  self.leftBord = self:FindGO("ProfSelect")
  local roulette = self:FindGO("VirtualRoulette", self.leftBord)
  self.roulette_rotateTrans = self:FindGO("plate", roulette).transform
  self.roulette_centerTrans = self:FindGO("spliceBg", roulette).transform
  self.roulette_inputArea = self:FindComponent("InputArea", UIWidget, self.leftBord.transform.parent.gameObject)
  self.pageDot = {}
  table.insert(self.pageDot, self:FindGO("pageDot1"))
  table.insert(self.pageDot, self:FindGO("pageDot2"))
  table.insert(self.pageDot, self:FindGO("pageDot3"))
  self.rightBord = self:FindGO("ProfDetail")
  self.profDetail_Icon = self:FindComponent("profIcon", UISprite, self.rightBord)
  self.profDetail_Name = self:FindComponent("profName", UILabel, self.rightBord)
  self.abilityPolygon = self:FindChild("PowerPolygo", self.ProfDetail):GetComponent(PolygonSprite)
  self.abilityPolygon:ReBuildPolygon()
  self.abilityPolygonDots = {}
  local fixAttrDots = self:FindGO("fixAttrDots")
  table.insert(self.abilityPolygonDots, self:FindGO("Str", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Int", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Vit", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Agi", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Dex", fixAttrDots).transform:GetChild(0))
  table.insert(self.abilityPolygonDots, self:FindGO("Luk", fixAttrDots).transform:GetChild(0))
  local hairSelect = self:FindGO("HairSelect")
  self.profDetail_hairLeftBtn = self:FindGO("leftBtn", hairSelect)
  self.profDetail_hairRightBtn = self:FindGO("rightBtn", hairSelect)
  self.profDetail_hairName = self:FindComponent("hairName", UILabel, hairSelect)
  self:AddClickEvent(self.profDetail_hairLeftBtn, function(go)
    self:DoChangeHair(-1)
  end)
  self:AddClickEvent(self.profDetail_hairRightBtn, function(go)
    self:DoChangeHair(1)
  end)
  local hairColorSelect = self:FindGO("HairColorSelect")
  self.profDetail_hairColorLeftBtn = self:FindGO("leftBtn", hairColorSelect)
  self.profDetail_hairColorRightBtn = self:FindGO("rightBtn", hairColorSelect)
  self.profDetail_hairColorName = self:FindComponent("hairColorName", UILabel, hairColorSelect)
  self.profDetail_hairColorBg = self:FindComponent("hairColorBg", UISprite, hairColorSelect)
  self:AddClickEvent(self.profDetail_hairColorLeftBtn, function(go)
    self:DoChangeHairColor(-1)
  end)
  self:AddClickEvent(self.profDetail_hairColorRightBtn, function(go)
    self:DoChangeHairColor(1)
  end)
  self:AddButtonEvent("EnterGameBtn", function(go)
    self:TryEnterGame()
    ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(213)
  end, {hideClickSound = false})
  self.objEffectEnterGame = self:FindGO("EnterGameBtn")
  self:PlayUIEffect(EffectMap.UI.GenderChoice_jinru, self.objEffectEnterGame)
  local uiAnimSpeedFactor = GameConfig.CreateRole.UIAnimSpeedFactor or 1
  self.lt_tw_a = self.ReturnButton:GetComponent(TweenAlpha)
  self.lt_tw_a.duration = self.lt_tw_a.duration / uiAnimSpeedFactor
  self.lt_tw_p = self.ReturnButton:GetComponent(TweenPosition)
  self.lt_tw_p.duration = self.lt_tw_p.duration / uiAnimSpeedFactor
  self.l_tw_a = self.leftBord:GetComponent(TweenAlpha)
  self.l_tw_a.duration = self.l_tw_a.duration / uiAnimSpeedFactor
  self.l_tw_p = self.leftBord:GetComponent(TweenPosition)
  self.l_tw_p.duration = self.l_tw_p.duration / uiAnimSpeedFactor
  self.t_tw_a = self.topBord:GetComponent(TweenAlpha)
  self.t_tw_a.duration = self.t_tw_a.duration / uiAnimSpeedFactor
  self.t_tw_p = self.topBord:GetComponent(TweenPosition)
  self.t_tw_p.duration = self.t_tw_p.duration / uiAnimSpeedFactor
  self.r_tw_a = self.rightBord:GetComponent(TweenAlpha)
  self.r_tw_a.duration = self.r_tw_a.duration / uiAnimSpeedFactor
  self.r_tw_p = self.rightBord:GetComponent(TweenPosition)
  self.r_tw_p.duration = self.r_tw_p.duration / uiAnimSpeedFactor
  self.b_tw_a = self.bottomBord:GetComponent(TweenAlpha)
  self.b_tw_a.duration = self.b_tw_a.duration / uiAnimSpeedFactor
  self.b_tw_p = self.bottomBord:GetComponent(TweenPosition)
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
  self.goHideBtn = self:FindGO("AnchorHideBtn")
  self.btnLeft = self:FindGO("btnLeft", self.goHideBtn)
  self.btnRight = self:FindGO("btnRight", self.goHideBtn)
  self:AddClickEvent(self.btnLeft, function(go)
    if FunctionNewCreateRole.Me().isFadeAnim then
      return
    end
    self:ClickSelectProf(3)
  end)
  self:AddClickEvent(self.btnRight, function(go)
    if FunctionNewCreateRole.Me().isFadeAnim then
      return
    end
    self:ClickSelectProf(15)
  end)
end

function NewCreateRoleView:AddEvt()
  self:AddListenEvt(NewCreateRoleAnimationCtrlEvent.AnimEnd, self.OnCameraAnimEndShowUI)
  self:AddListenEvt(FunctionNewCreateRoleEvent.Enter, self.OnCreateRoleEnterShowLeftUI)
  self:AddListenEvt(FunctionNewCreateRoleEvent.ModelLoadCanOperation, self.OnCreateRoleModelLoadedBeginShow)
  self:AddListenEvt(ServiceEvent.UserRecvRoleInfo, self.OnResponseCreateRoleSuccess)
  self:AddListenEvt(ServiceEvent.Error, self.OnResponseCreateRoleFail)
  self:AddListenEvt(FunctionNetError.BackToLogin, self.OnBackToLogin)
  self:AddListenEvt(ServiceEvent.ConnNetDown, self.OnReceiveNetOff)
  self:AddListenEvt(XDEUIEvent.CreateBack, self.OnReturnButton)
  EventManager.Me():AddEventListener(CreateRoleViewEvent.PlayerMapChange, self.OnPlayerMapChangeForCreateRole, self)
  EventManager.Me():AddEventListener(AppStateEvent.BackToLogo, self.OnExit, self)
end

function NewCreateRoleView:OnEnter()
  NewCreateRoleView.super.OnEnter(self)
  self.roleIndex = self.viewdata.index or 2
  if self.roleIndex then
    UIModelRolesList.Ins():SetEmptyIndex(self.roleIndex)
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:OnReturnButton()
  end)
  self.lastRouletteAngle = nil
  self.lastInPage = nil
  if self.ProfRoulette then
    self.ProfRoulette:Enable()
    self.ProfRoulette:SetRotateAngle(startAngleOffset)
  end
  self:OnCameraAnimBeginHideUI()
end

function NewCreateRoleView:OnExit()
  Buglylog("NewCreateRoleView:OnExit")
  NewCreateRoleView.super.OnExit(self)
  if self.ProfRoulette then
    self.ProfRoulette:Disable()
    self.ProfRoulette:Destroy()
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  self:CloseTimeTickForFindMainCamera()
  self:CloseTimeTickForCheckTimeout()
  TimeTickManager.Me():ClearTick(self)
  ServicePlayerProxy.mapChangeForCreateRole = false
  EventManager.Me():RemoveEventListener(CreateRoleViewEvent.PlayerMapChange, self.OnPlayerMapChangeForCreateRole, self)
  self.lastRouletteAngle = nil
  self.lastInPage = nil
  if self.maskFadeLeanTween ~= nil then
    LeanTween.cancel(self.mask.gameObject)
    self.maskFadeLeanTween = nil
  end
  if self.waitEnterBord ~= nil then
    self.waitEnterBord:OnDestroy()
    self.waitEnterBord = nil
  end
  FunctionNewCreateRole.Me():Reset()
  FunctionNewCreateRole.Me():ClearInitStatus()
  LoginRoleSelector.Ins():ClearAllEffect()
end

function NewCreateRoleView:UpdateProfView()
  self:UpdateView_Gender()
  self:UpdateView_ProfAttrPloy()
  self:UpdateView_Hair()
end

function NewCreateRoleView:ShowReturnButton(animed)
  if animed then
    self.lt_tw_a.enabled = true
    self.lt_tw_a:PlayForward()
    self.lt_tw_p.enabled = true
    self.lt_tw_p:PlayForward()
  else
    self.lt_tw_a:Sample(1, true)
    self.lt_tw_a.enabled = false
    self.lt_tw_p:Sample(1, true)
    self.lt_tw_p.enabled = false
  end
end

function NewCreateRoleView:HideReturnButton(animed)
  if animed then
    self.lt_tw_a.enabled = true
    self.lt_tw_a:PlayReverse()
    self.lt_tw_p.enabled = true
    self.lt_tw_p:PlayReverse()
  else
    self.lt_tw_a:Sample(0, true)
    self.lt_tw_a.enabled = false
    self.lt_tw_p:Sample(0, true)
    self.lt_tw_p.enabled = false
  end
end

function NewCreateRoleView:ShowLeftUI(animed)
  if animed then
    self.lt_tw_a.enabled = true
    self.lt_tw_a:PlayForward()
    self.lt_tw_p.enabled = true
    self.lt_tw_p:PlayForward()
    self.l_tw_a.enabled = true
    self.l_tw_a:PlayForward()
    self.l_tw_p.enabled = true
    self.l_tw_p:PlayForward()
  else
    self.lt_tw_a:Sample(1, true)
    self.lt_tw_a.enabled = false
    self.lt_tw_p:Sample(1, true)
    self.lt_tw_p.enabled = false
    self.l_tw_a:Sample(1, true)
    self.l_tw_a.enabled = false
    self.l_tw_p:Sample(1, true)
    self.l_tw_p.enabled = false
  end
end

function NewCreateRoleView:HideLeftUI(animed)
  if animed then
    self.lt_tw_a.enabled = true
    self.lt_tw_a:PlayReverse()
    self.lt_tw_p.enabled = true
    self.lt_tw_p:PlayReverse()
    self.l_tw_a.enabled = true
    self.l_tw_a:PlayReverse()
    self.l_tw_p.enabled = true
    self.l_tw_p:PlayReverse()
  else
    self.lt_tw_a:Sample(0, true)
    self.lt_tw_a.enabled = false
    self.lt_tw_p:Sample(0, true)
    self.lt_tw_p.enabled = false
    self.l_tw_a:Sample(0, true)
    self.l_tw_a.enabled = false
    self.l_tw_p:Sample(0, true)
    self.l_tw_p.enabled = false
  end
end

function NewCreateRoleView:ShowRightUI(animed)
  if animed then
    self.t_tw_a.enabled = true
    self.t_tw_a:PlayForward()
    self.t_tw_p.enabled = true
    self.t_tw_p:PlayForward()
    self.r_tw_a.enabled = true
    self.r_tw_a:PlayForward()
    self.r_tw_p.enabled = true
    self.r_tw_p:PlayForward()
    self.b_tw_a.enabled = true
    self.b_tw_a:PlayForward()
    self.b_tw_p.enabled = true
    self.b_tw_p:PlayForward()
  else
    self.t_tw_a:Sample(1, true)
    self.t_tw_a.enabled = false
    self.t_tw_p:Sample(1, true)
    self.t_tw_p.enabled = false
    self.r_tw_a:Sample(1, true)
    self.r_tw_a.enabled = false
    self.r_tw_p:Sample(1, true)
    self.r_tw_p.enabled = false
    self.b_tw_a:Sample(1, true)
    self.b_tw_a.enabled = false
    self.b_tw_p:Sample(1, true)
    self.b_tw_p.enabled = false
  end
end

function NewCreateRoleView:HideRightUI(animed)
  if animed then
    self.t_tw_a.enabled = true
    self.t_tw_a:PlayReverse()
    self.t_tw_p.enabled = true
    self.t_tw_p:PlayReverse()
    self.r_tw_a.enabled = true
    self.r_tw_a:PlayReverse()
    self.r_tw_p.enabled = true
    self.r_tw_p:PlayReverse()
    self.b_tw_a.enabled = true
    self.b_tw_a:PlayReverse()
    self.b_tw_p.enabled = true
    self.b_tw_p:PlayReverse()
  else
    self.t_tw_a:Sample(0, true)
    self.t_tw_a.enabled = false
    self.t_tw_p:Sample(0, true)
    self.t_tw_p.enabled = false
    self.r_tw_a:Sample(0, true)
    self.r_tw_a.enabled = false
    self.r_tw_p:Sample(0, true)
    self.r_tw_p.enabled = false
    self.b_tw_a:Sample(0, true)
    self.b_tw_a.enabled = false
    self.b_tw_p:Sample(0, true)
    self.b_tw_p.enabled = false
  end
end

function NewCreateRoleView:SelectSexMale()
  self:SelectSexGo(self.maleSelect, true)
  self:SelectSexGo(self.femaleSelect, false)
end

function NewCreateRoleView:SelectSexFemale()
  self:SelectSexGo(self.femaleSelect, true)
  self:SelectSexGo(self.maleSelect, false)
end

function NewCreateRoleView:SelectSexGo(go, select)
  if select then
    go.select:SetActive(true)
    go.icon.transform.localScale = LuaGeometry.Const_V3_one
    go.icon.alpha = 1
    if sexSelectFx then
      sexSelectFx.gameObject:SetActive(true)
      sexSelectFx.transform.parent = go.fxHolder.transform
      sexSelectFx.transform.localPosition = LuaVector3.Zero()
      sexSelectFx.transform.localScale = LuaVector3.One()
    end
  else
    go.select:SetActive(false)
    go.icon.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 0.7)
    go.icon.alpha = 0.4
  end
end

function NewCreateRoleView:DoSelectSex(sex)
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  if sex == curGender then
    return
  end
  if sex == ProtoCommon_pb.EGENDER_MALE then
    self:SelectSexMale()
  else
    self:SelectSexFemale()
  end
  self.profDetail_Name.text = ProfessionProxy.GetProfessionName(self.selectOnProf, sex)
  FunctionNewCreateRole.Me():SwitchGender(self.selectOnProf, sex)
  self:UpdateView_Hair()
end

function NewCreateRoleView:UpdateView_Gender()
  if not self.selectOnProfData.maleID or not self.selectOnProfData.femaleID then
    self.topBord:SetActive(false)
    return
  end
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  if curGender == ProtoCommon_pb.EGENDER_MALE then
    self:SelectSexMale()
  else
    self:SelectSexFemale()
  end
  self.topBord:SetActive(true)
end

PolygonColor = {
  [1] = {polygonColorOut = "FDFF51", polygonColorIn = "FFA200"},
  [2] = {polygonColorOut = "4EFF90", polygonColorIn = "00A463"},
  [3] = {polygonColorOut = "FFA800", polygonColorIn = "FF4200"},
  [4] = {polygonColorOut = "359CFF", polygonColorIn = "0740CE"},
  [5] = {polygonColorOut = "FF5B3C", polygonColorIn = "F5242B"},
  [6] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [7] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [8] = {polygonColorOut = "FDFF51", polygonColorIn = "FFA200"},
  [9] = {polygonColorOut = "4EFF90", polygonColorIn = "00A463"},
  [10] = {polygonColorOut = "FFA800", polygonColorIn = "FF4200"},
  [11] = {polygonColorOut = "359CFF", polygonColorIn = "0740CE"},
  [12] = {polygonColorOut = "FF5B3C", polygonColorIn = "F5242B"},
  [13] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [14] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [15] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [16] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [17] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"},
  [18] = {polygonColorOut = "E76DFF", polygonColorIn = "871FF1"}
}

function NewCreateRoleView:UpdateView_ProfAttrPloy()
  local cfg = Table_Class[self.selectOnProf]
  IconManager:SetProfessionIcon(self.selectOnProfData.icon, self.profDetail_Icon)
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  self.profDetail_Name.text = ProfessionProxy.GetProfessionName(self.selectOnProf, curGender)
  if self.lps ~= nil then
    for k, v in pairs(self.lps) do
      GameObject.DestroyImmediate(v)
    end
  end
  local initAttris = cfg.InitialAttr
  if initAttris ~= nil and 0 < #initAttris then
    local v = {}
    for i = 1, #initAttris do
      v[i] = initAttris[i].value / 100
      local value = v[i] * 79
      self.abilityPolygon:SetLength(i - 1, value)
      self.abilityPolygonDots[i].localPosition = LuaGeometry.GetTempVector3(value, 0, 0)
    end
    self.lps = NGUIUtil.DrawAbilityPolygon(self.abilitypoint, self.abilityline, 80, v)
  end
end

NewCreateRoleView.selectHair = nil
NewCreateRoleView.selectHairColor = nil

function NewCreateRoleView:DoChangeHair(index_delta)
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  local curHair = FunctionNewCreateRole.Me():GetStashHair(self.selectOnProf, curGender)
  local len = #self.selectHairList
  curHair = curHair + index_delta
  curHair = curHair < 1 and len + curHair or curHair
  curHair = len < curHair and curHair - len or curHair
  self:ChangeHair(curHair)
end

function NewCreateRoleView:DoChangeHairColor(index_delta)
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  local curHairColor = FunctionNewCreateRole.Me():GetStashHairColor(self.selectOnProf, curGender)
  local len = #self.selectHairColorList
  curHairColor = curHairColor + index_delta
  curHairColor = curHairColor < 1 and len + curHairColor or curHairColor
  curHairColor = len < curHairColor and curHairColor - len or curHairColor
  self:ChangeHairColor(curHairColor)
end

function NewCreateRoleView:ChangeHair(index, dontChangeModel)
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  FunctionNewCreateRole.Me():SwitchHair(self.selectOnProf, curGender, index, dontChangeModel)
  self.profDetail_hairName.text = string.format(ZhString.LoginRole_HairStylePrefix, index)
end

function NewCreateRoleView:ChangeHairColor(index)
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  FunctionNewCreateRole.Me():SwitchHairColor(self.selectOnProf, curGender, index)
  local hairColor = Table_HairColor[index]
  self.profDetail_hairColorName.text = hairColor.NameZh
  local hasC, resultC = ColorUtil.TryParseHexString(hairColor.CreateRoleColor)
  self.profDetail_hairColorBg.color = resultC
end

function NewCreateRoleView:UpdateView_Hair()
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  local curHair = FunctionNewCreateRole.Me():GetStashHair(self.selectOnProf, curGender)
  local curHairColor = FunctionNewCreateRole.Me():GetStashHairColor(self.selectOnProf, curGender)
  self.selectHairList = FunctionNewCreateRole.Me():GetHairList(self.selectOnProfData.id, curGender)
  self.selectHairColorList = FunctionNewCreateRole.Me():GetHairColorList(self.selectOnProfData.id, curGender)
  self:ChangeHair(curHair, true)
  self:ChangeHairColor(curHairColor)
end

function NewCreateRoleView:IsRedName(id)
  for i = 1, #GameConfig.CreateRoleFail.RedName do
    if GameConfig.CreateRoleFail.RedName[i] == id then
      return true
    end
  end
  return false
end

function NewCreateRoleView:DisableInput()
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, false)
  for i = 1, #colliders do
    local v = colliders[i]
    if v.gameObject.name ~= "BTN_Close" then
      v.enabled = false
    end
  end
end

function NewCreateRoleView:EnableInput()
  local colliders = GameObjectUtil.Instance:GetAllComponentsInChildren(self.gameObject, BoxCollider, false)
  for i = 1, #colliders do
    local v = colliders[i]
    v.enabled = true
  end
end

function NewCreateRoleView:TryEnterGame()
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

function NewCreateRoleView:DoEnterGame()
  self.name = self.nameInput.value
  if self.name == "" then
    FunctionNetError.Me():ShowErrorById(8)
    self.enter_tryed = false
    return
  end
  self.name = RemoveSpecialChara(self.nameInput.value)
  if string.find(self.name, " ") or string.find(self.name, "　") or not StringUtil.CheckTextValidForDisplay(self.name) then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(7)
    self.enter_tryed = false
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(self.name, GameConfig.MaskWord.PlayerName) then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(7)
    self.enter_tryed = false
    return
  end
  local length = StringUtil.Utf8len(self.name)
  if length < GameConfig.System.namesize_min or length > GameConfig.System.namesize_max then
    self.nameInputLabel.color = ColorUtil.NGUILabelRed
    FunctionNetError.Me():ShowErrorById(9)
    self.enter_tryed = false
    return
  end
  if self.timerForCheckTimeout == nil then
    self.timerForCheckTimeout = TimeTickManager.Me():CreateTick(1000, 1000, self.OnTimeTickForCheckTimeout, self, 2)
  end
  self.timerForCheckTimeout:StartTick()
  NewCreateRoleView.requestTime = 0
  
  function self.requestTimeoutEvent()
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

function NewCreateRoleView:OnTimeTickForCheckTimeout()
  NewCreateRoleView.requestTime = NewCreateRoleView.requestTime + 1
  if NewCreateRoleView.requestTime >= GameConfig.LoginRole.requestOuttime then
    self.timerForCheckTimeout:StopTick()
    if self.requestTimeoutEvent ~= nil then
      self.requestTimeoutEvent()
    end
  end
end

function NewCreateRoleView:RequestCreateRole()
  local defaultName = self.nameInput.value
  defaultName = RemoveSpecialChara(self.nameInput.value)
  local codeUTF8 = LuaUtils.StrToUtf8(defaultName)
  local roleSlotIndex = UIModelRolesList.Ins():GetEmptyIndex()
  local curGender = FunctionNewCreateRole.Me():GetStashGender(self.selectOnProf)
  local curHair = FunctionNewCreateRole.Me():GetStashHair(self.selectOnProf, curGender)
  local curHairColor = FunctionNewCreateRole.Me():GetStashHairColor(self.selectOnProf, curGender)
  self.selectHairList = FunctionNewCreateRole.Me():GetHairList(self.selectOnProfData.id, curGender)
  self.selectHairColorList = FunctionNewCreateRole.Me():GetHairColorList(self.selectOnProfData.id, curGender)
  local selectOnTypeBranch = Table_Class[self.selectOnProf].TypeBranch
  local isSpecialJob = Table_Class[self.selectOnProf].IsSpecialJob
  local baseClassID = Table_Branch[selectOnTypeBranch].base_id
  baseClassID = isSpecialJob == 1 and self.selectOnProf - 2 or self.selectOnProf - 3
  FunctionLogin.Me():createRole(codeUTF8, curGender, baseClassID, self.selectHairList[curHair], self.selectHairColorList[curHairColor], CurrentOccupationBodyColor, roleSlotIndex)
end

function NewCreateRoleView:OnResponseCreateRoleFail(note)
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

function NewCreateRoleView:OnResponseCreateRoleSuccess(note)
  redlog("OnResponseCreateRoleSuccess 1", self.newRoleId)
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

function NewCreateRoleView:CheckCreatedDataByIndex()
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

function NewCreateRoleView:CallSelectAndEnter(newRoleId)
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
    NewCreateRoleView.requestTime = 0
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

function NewCreateRoleView:OnPlayerMapChangeForCreateRole(message)
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
  FunctionNewCreateRole.Me():ClearAnimationModel()
  local tweenStart = 0
  local tweenEnd = 1
  local tweenTime = 1.5
  FunctionNewCreateRole.Me().isFadeAnim = true
  self.maskFadeLeanTween = LeanTween.alphaNGUI(self.mask, tweenStart, tweenEnd, tweenTime)
  self.maskFadeLeanTween:setOnComplete(function()
    self.maskFadeLeanTween = nil
    FunctionNewCreateRole.Me().isFadeAnim = false
    self:EnterInGame()
    ServicePlayerProxy.Instance:MapChange(message)
    if self.waitEnterBord then
      self.waitEnterBord:Active(true)
    end
  end)
end

function NewCreateRoleView:EnterInGame(note)
  local goMainCamera = GameObject.Find("Main Camera")
  if not GameObjectUtil.Instance:ObjectIsNULL(goMainCamera) then
    goMainCamera:SetActive(false)
  end
  self:CloseSelf()
  ResourceManager.Instance.IsAsyncLoadOn = true
  redlog("ResourceManager.Instance.IsAsyncLoadOn =======2======= " .. tostring(ResourceManager.Instance.IsAsyncLoadOn))
  FrameRateSpeedUpChecker.Instance():Open()
end

function NewCreateRoleView:OnBackToLogin()
  Game.Me():BackToLogo()
end

function NewCreateRoleView:OnReceiveNetOff()
  self:CloseMainCamera()
  self:Hide()
end

function NewCreateRoleView:CloseMainCamera()
  local gameObjectMainCamera = GameObject.FindGameObjectWithTag("MainCamera")
  if gameObjectMainCamera then
    local mainCamera = gameObjectMainCamera:GetComponent("Camera")
    mainCamera.enabled = false
  end
end

function NewCreateRoleView:OnClickForButtonContinueWait()
  self.timerForCheckTimeout:StartTick()
  NewCreateRoleView.requestTime = 0
end

function NewCreateRoleView:OnClickForButtonBackLogin()
  Game.Me():BackToLogo()
end

function NewCreateRoleView:OnReturnButton()
  if self.selectOnProf ~= nil then
    self:ClearProfSelect()
    return
  end
  self:TweenToSelectRole()
end

function NewCreateRoleView:TweenToSelectRole()
  if not (not self.maskFadeLeanTween and self.mask) or self.enter_tryed == true then
    return
  end
  local tweenStart = 0
  local tweenEnd = 1
  local tweenTime = 1.5
  self.maskFadeLeanTween = LeanTween.alphaNGUI(self.mask, tweenStart, tweenEnd, tweenTime)
  FunctionNewCreateRole.Me().isFadeAnim = true
  self.maskFadeLeanTween:setOnComplete(function()
    self.maskFadeLeanTween = nil
    if not BranchMgr.IsJapan() then
      self:GoToSelectRole()
      return
    end
    FunctionNewCreateRole.Me():Shutdown()
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

function NewCreateRoleView:GoToSelectRole()
  FunctionNewCreateRole.Me():Shutdown()
  Game.OpenScene_CharacterChoose(function()
    CSharpObjectForLogin.Ins():Initialize(function()
      local cameraController = CSharpObjectForLogin.Ins():GetCameraController()
      cameraController:GoToSelectRole()
      UIRoleSelect.Ins():Open()
      self:CloseSelf()
    end)
  end)
end

function NewCreateRoleView:CalibrateViewPortOfUICamera()
  if self.tickForFindMainCamera == nil then
    self.tickForFindMainCamera = TimeTickManager.Me():CreateTick(0, 1000, self.OnTimeTickForFindMainCamera, self, 1)
  end
end

function NewCreateRoleView:OnTimeTickForFindMainCamera()
  local goMainCamera = GameObject.Find("Main Camera")
  if goMainCamera ~= nil then
    local mainCamera = goMainCamera:GetComponent(Camera)
    local deviceName = SystemInfo.deviceModel
    if GameConfig.IpadAdaption and GameConfig.IpadAdaption[deviceName] then
      redlog("当前设备是Ipad", GameConfig.IpadAdaption[deviceName])
      mainCamera.fieldOfView = 48
    else
      mainCamera.fieldOfView = 40
    end
    local transCameraUsedForDebugBlink = goMainCamera.transform:Find("CameraUsedForDebugBlink")
    if transCameraUsedForDebugBlink ~= nil then
      local camera = transCameraUsedForDebugBlink:GetComponent(Camera)
      if camera ~= nil then
        local viewPort = camera.rect
        viewPort.x = 0
        viewPort.y = 0
        viewPort.width = 1
        viewPort.height = 1
        camera.rect = viewPort
      end
    end
    self:CloseTimeTickForFindMainCamera()
  end
end

function NewCreateRoleView:CloseTimeTickForFindMainCamera()
  TimeTickManager.Me():ClearTick(self, 1)
  self.tickForFindMainCamera = nil
end

function NewCreateRoleView:CloseTimeTickForCheckTimeout()
  TimeTickManager.Me():ClearTick(self, 2)
  self.timerForCheckTimeout = nil
end

local cellAlpha1 = 0.8
local cellAlpha2 = 0.6

function NewCreateRoleView:CreateProfRoulette()
  local startAngleOffset = -11.25
  local radius = 300
  local segments = #FunctionNewCreateRole.Me().ProfConfig
  local angle = 360 / segments
  self.ProfRoulette = NewCreateRoleRoulette.new(segments, self.roulette_rotateTrans, self.roulette_centerTrans, self.roulette_inputArea, true)
  local profCfg = FunctionNewCreateRole.Me().ProfConfig
  self.ProfRouletteCells = {}
  for i = 1, #profCfg do
    local obj = self:LoadPreferb("cell/NewCreateRoleProfessionCell", self.gameObject)
    local cell = NewCreateRoleProfSelectCell.new(obj)
    cell:SetData(profCfg[i])
    cell:AddEventListener(NewCreateRoleViewEvent.ProfRouletteSelect, self.ClickSelectProf, self)
    self.ProfRoulette:AddMember(cell, cell.gameObject.transform, angle * (i - 1), radius, function(member, roAngle, setAngle, setRadius)
      local range, minExtent = 67.5, 0.2
      local angle = (roAngle + setAngle) % 360
      if 180 < angle then
        angle = 360 - angle
      end
      local alpha = math.min(1, 1 - math.min(angle / range, 1) + minExtent)
      if alpha < 1 and alpha > cellAlpha1 then
        alpha = cellAlpha1
      elseif alpha < cellAlpha2 then
        alpha = cellAlpha2
      end
      member.obj:SetAlpha(alpha)
    end)
    table.insert(self.ProfRouletteCells, cell)
  end
  self.ProfRoulette:AddEventListener(NewCreateRoleRouletteEvent.FirstInput, self.OnProfRouletteFirstInput, self)
  self.ProfRoulette:AddEventListener(NewCreateRoleRouletteEvent.StopSelect, self.OnProfRouletteStopSelect, self)
  self.ProfRoulette:AddEventListener(NewCreateRoleRouletteEvent.StartSelect, self.OnProfRouletteStartSelect, self)
  self.ProfRoulette:AddEventListener(NewCreateRoleRouletteEvent.Rotate, self.OnProfRouletteRotate, self)
  self.ProfRoulette:SetRotateAngle(startAngleOffset)
end

function NewCreateRoleView:ClickSelectProf(id)
  self.goHideBtn:SetActive(false)
  local data = FunctionNewCreateRole.Me().ProfConfig[id]
  if not self.ProfRoulette:ForceMotionToMakeSegmentAngleZero(data.id, nil, 90) then
    return
  end
end

function NewCreateRoleView:OnProfRouletteFirstInput()
  self.goHideBtn:SetActive(false)
end

function NewCreateRoleView:OnProfRouletteStartSelect()
  self.ReturnButtonBC.enabled = false
end

function NewCreateRoleView:OnProfRouletteStopSelect(segment)
  self.ReturnButtonBC.enabled = true
  if segment then
    local id = segment + 1
    self.selectOnProfData = FunctionNewCreateRole.Me().ProfConfig[id]
    self.selectOnProf = self.selectOnProfData.prof
    for i = 1, #self.ProfRouletteCells do
      local cell = self.ProfRouletteCells[i]
      cell:SetOnSelect(cell.prof == self.selectOnProfData.prof)
    end
    FunctionNewCreateRole.Me():SetAnimDestPoint(self.selectOnProfData.MountInfo)
    self:OnCameraAnimBeginHideUI()
    if self.selectOnProf then
      self:UpdateView_Hair()
    end
  end
end

function NewCreateRoleView:OnProfRouletteRotate(angle)
  if self.lastSoundAngle == nil then
    self.lastSoundAngle = angle
  elseif math.abs(self.lastSoundAngle - angle) > 22.5 or FunctionNewCreateRole.Me().clickSound then
    self.lastSoundAngle = angle
    AudioUtil.Play2DRandomSound(AudioMap.Maps.createRoleRoulette)
    FunctionNewCreateRole.Me().clickSound = false
  end
  if angle ~= self.lastRouletteAngle then
    self.lastRouletteAngle = angle
    local inPage = -1
    for k, v in pairs(GameConfig.CreateRole.PageSector) do
      if v[1] < self.lastRouletteAngle and v[2] > self.lastRouletteAngle then
        inPage = k
        break
      end
    end
    if 0 < inPage and self.lastInPage ~= inPage then
      self.lastInPage = inPage
      for i = 1, #self.pageDot do
        self.pageDot[i]:SetActive(false)
      end
      self.pageDot[self.lastInPage]:SetActive(true)
    end
  end
end

function NewCreateRoleView:ClearProfSelect()
  self.selectOnProfData = nil
  self.selectOnProf = nil
  for i = 1, #self.ProfRouletteCells do
    local cell = self.ProfRouletteCells[i]:SetOnSelect(false)
  end
  FunctionNewCreateRole.Me():SetAnimDestPointToOri()
  self:OnCameraAnimBeginHideUI()
end

function NewCreateRoleView:OnCameraAnimBeginHideUI()
  self:HideRightUI(true)
  self:HideReturnButton(true)
end

function NewCreateRoleView:OnCameraAnimEndShowUI()
  self:ShowReturnButton(true)
  if self.selectOnProf then
    self:ShowRightUI(true)
    self:UpdateProfView()
    FunctionNewCreateRole.Me():ShowSelectCurrentRoleModel()
  end
end

function NewCreateRoleView:OnCreateRoleEnterShowLeftUI()
end

function NewCreateRoleView:OnCreateRoleModelLoadedBeginShow()
  local tweenStart = 1
  local tweenEnd = 0
  local tweenTime = 4
  self.mask = self:FindComponent("MaskFade", UISprite)
  FunctionNewCreateRole.Me().isFadeAnim = true
  self.maskFadeLeanTween = LeanTween.alphaNGUI(self.mask, tweenStart, tweenEnd, tweenTime)
  self.maskFadeLeanTween:setOnComplete(function()
    self.maskFadeLeanTween = nil
    FunctionNewCreateRole.Me().isFadeAnim = false
  end)
  TimeTickManager.Me():CreateOnceDelayTick(1500, function()
    self:ShowLeftUI(true)
  end, self, 1001)
end
