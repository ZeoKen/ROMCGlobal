autoImport("MyWarbandMemberCell")
WarbandSignupPopUp = class("WarbandSignupPopUp", ContainerView)
WarbandSignupPopUp.ViewType = UIViewType.PopUpLayer
local EMPTY_TEX = "12pvp_bg_pic0"
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
local warbandProxy

function WarbandSignupPopUp:Init()
  warbandProxy = WarbandProxy.Instance
  self.filterType = GameConfig.MaskWord.WarbandName
  self:FindObj()
  self:AddUIEvt()
  self:AddEvent()
  self:InitView()
  self:InitShow()
end

function WarbandSignupPopUp:FindObj()
  self.root = self:FindGO("Root")
  self.emptyRoot = self:FindGO("EmptyRoot")
  self.creatBtn = self:FindGO("CreatBtn", self.emptyRoot)
  self.creatLab = self:FindComponent("CreatLab", UILabel, self.creatBtn)
  self.emptyTip = self:FindComponent("EmptyTip", UILabel, self.emptyRoot)
  self.emptyTexture = self:FindComponent("EmptyTexture", UITexture, self.emptyRoot)
  PictureManager.Instance:SetPVP(EMPTY_TEX, self.emptyTexture)
  self.leaveBtn = self:FindComponent("LeaveBtn", UISprite, self.root)
  self.leaveBtnLab = self:FindComponent("Label", UILabel, self.leaveBtn.gameObject)
  self.kickBtn = self:FindComponent("KickBtn", UISprite, self.root)
  self.kickLab = self:FindComponent("Label", UILabel, self.kickBtn.gameObject)
  self.signupBtn = self:FindComponent("SignupBtn", UISprite, self.root)
  self.hasSignupLab = self:FindComponent("hasSignup", UILabel, self.root)
  self.hasSignupLab.text = ZhString.Warband_hasSignup
  self.signupLab = self:FindComponent("Label", UILabel, self.signupBtn.gameObject)
  self.preparedBtn = self:FindGO("PreparedBtn", self.root)
  self.unpreparedBtn = self:FindComponent("UnPreparedBtn", UISprite, self.root)
  self.UnpreparedLab = self:FindComponent("Label", UILabel, self.unpreparedBtn.gameObject)
  self.signupTip = self:FindComponent("SignupTip", UILabel, self.signupBtn.gameObject)
  self.title = self:FindComponent("TitleLab", UILabel)
  self.memberGrid = self:FindComponent("Grid", UIGrid, self.root)
  self.nameInput = self:FindComponent("NameInput", UIInput, self.root)
  self.nameInputColider = self:FindComponent("NameInput", BoxCollider)
  self.nameInput.characterLimit = GameConfig.System.warname_max * 2
  self.editBtn = self:FindGO("EditBtn", self.nameInput.gameObject)
  self.fixedName = self:FindComponent("FixedName", UILabel, self.root)
  self.fixedName.text = ZhString.Warband_Signup_FixedWarbandName
  self.emptyTip.text = ZhString.Warband_Signup_empty
  self.title.text = ZhString.Warband_Signup_title
  self.signupTip.text = ZhString.Warband_Signup_RoleNumLimited
  self.creatLab.text = ZhString.Warband_Signup_CreatWarband
  self.signupLab.text = ZhString.Warband_Signup_ConfirmSignUp
  self.teamScoreGO = self:FindGO("TeamScoreBg", self.root)
  if self.teamScoreGO then
    self.teamScoreLabel = self:FindComponent("TeamScore", UILabel, self.root)
  end
end

function WarbandSignupPopUp:InitShow()
  if self.teamScoreGO then
    self.teamScoreGO:SetActive(true)
    self.teamScoreLabel.text = string.format(ZhString.CupMode_TeamScore, warbandProxy:GetTeamScore())
  end
end

function WarbandSignupPopUp:AddUIEvt()
  self:AddSelectEvent(self.nameInput, function(go, state)
    if state then
      return
    end
    local myDataName = warbandProxy:GetMyWarbandName()
    if myDataName and myDataName ~= self.nameInput.value then
      self:SetName()
    end
  end)
  self:AddClickEvent(self.leaveBtn.gameObject, function()
    if self.delMode then
      MsgManager.ShowMsgByID(28051)
      return
    end
    local isCaptain = warbandProxy:CheckBandAuthority()
    local hasSignup = warbandProxy:CheckHasSignup()
    if isCaptain then
      if hasSignup then
        warbandProxy:DoDisband()
      else
        warbandProxy:DoLeaveWarband()
      end
    elseif not hasSignup then
      proxy:DoLeaveWarband()
    end
  end)
  self:AddClickEvent(self.kickBtn.gameObject, function()
    if warbandProxy:CheckHasSignup() then
      MsgManager.ShowMsgByID(28054)
      return
    end
    local hasSignup = warbandProxy:CheckHasSignup()
    if warbandProxy.myWarband.memberNum <= 1 or hasSignup then
      return
    end
    self:UpdateKickModel(not self.delMode)
  end)
  self:AddClickEvent(self.signupBtn.gameObject, function()
    if self.delMode then
      return
    end
    warbandProxy:DoSignUp()
  end)
  self:AddClickEvent(self.creatBtn, function()
    warbandProxy:DoCreatWarband()
  end)
  self:AddClickEvent(self.preparedBtn, function()
    if warbandProxy:CheckHasSignup() then
      MsgManager.ShowMsgByID(28054)
      return
    end
    warbandProxy:DoMemberPrepare(true)
  end)
  self:AddClickEvent(self.unpreparedBtn.gameObject, function()
    if warbandProxy:CheckHasSignup() then
      MsgManager.ShowMsgByID(28054)
      return
    end
    warbandProxy:DoMemberPrepare(false)
  end)
end

function WarbandSignupPopUp:UpdateKickModel(var)
  self.delMode = var
  self.kickLab.text = var and ZhString.Warband_Signup_ConfirmKick or ZhString.Warband_Signup_Kick
  if self.memberCtl then
    local cells = self.memberCtl:GetCells()
    if cells then
      for i = 1, #cells do
        cells[i]:SetEditorMode(var)
      end
    end
  end
end

function WarbandSignupPopUp:InitView()
  SkipTranslatingInput(self.nameInput)
  self.memberCtl = UIGridListCtrl.new(self.memberGrid, MyWarbandMemberCell, "MyWarbandMemberCell")
  self.memberCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMember, self)
end

function WarbandSignupPopUp:AddEvent()
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandInfoMatchCCmd, self.UpdateView)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandLeaveMatchCCmd, self.HandleExit)
end

local funkey = {
  "AddFriend",
  "SendMessage",
  "ShowDetail",
  "AddBlacklist"
}

function WarbandSignupPopUp:OnClickMember(cellCtl)
  if cellCtl.data == MyWarbandTeamData.EMPTY then
    FunctionPlayerTip.Me():CloseTip()
    self.nowCell = nil
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamInvitePopUp,
      viewdata = {isWarbandInvite = true}
    })
    return
  end
  if cellCtl ~= self.nowCell then
    if cellCtl.data.id ~= Game.Myself.data.id then
      self.nowCell = cellCtl
      local data = cellCtl.data
      local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.bg, NGUIUtil.AnchorSide.TopRight, {-70, 14})
      local playerData = PlayerTipData.new()
      playerData:SetByWarband(data)
      local tipData = {playerData = playerData, funckeys = funkey}
      playerTip:SetData(tipData)
      playerTip:AddIgnoreBound(cellCtl.portraitCell.gameObject)
      
      function playerTip.closecallback()
        self.nowCell = nil
      end
      
      function playerTip.clickcallback(funcConfig)
        if funcConfig.key == "SendMessage" then
          self:CloseSelf()
        end
      end
    else
      FunctionPlayerTip.Me():CloseTip()
      self.nowCell = nil
    end
  else
    FunctionPlayerTip.Me():CloseTip()
    self.nowCell = nil
  end
end

function WarbandSignupPopUp:UpdateView()
  self:UpdateKickModel(false)
  local hasWarband = warbandProxy:IHaveWarband()
  local hasAuth = warbandProxy:CheckBandAuthority()
  local isready = warbandProxy:CheckImReady()
  local hasSignup = warbandProxy:CheckHasSignup()
  if not hasWarband then
    self.root:SetActive(false)
    self.emptyRoot:SetActive(true)
    self.preparedBtn:SetActive(false)
    self.unpreparedBtn.gameObject:SetActive(false)
    self.kickBtn.gameObject:SetActive(false)
    self.editBtn:SetActive(false)
    return
  end
  self.root:SetActive(true)
  self.emptyRoot:SetActive(false)
  self.preparedBtn:SetActive(not hasAuth and not isready)
  self.leaveBtnLab.text = hasSignup and hasAuth and ZhString.CupMode_CancelRegister or ZhString.CupMode_LeaveTeam
  self.unpreparedBtn.gameObject:SetActive(not hasAuth and isready)
  self.signupBtn.gameObject:SetActive(hasAuth and not hasSignup)
  self.hasSignupLab.gameObject:SetActive(hasSignup)
  self.kickBtn.gameObject:SetActive(hasAuth)
  self.editBtn:SetActive(hasAuth and not hasSignup)
  self.nameInput.value = warbandProxy:GetMyWarbandName()
  self.nameInputColider.enabled = hasAuth and not hasSignup
  self:UpdateMember()
end

local BTN_SP = {
  "com_btn_1",
  "com_btn_2s",
  "com_btn_13s",
  "com_btn_0"
}
local redOutLineColor = Color(0.49411764705882355, 0.027450980392156862, 0.01568627450980392, 1)
local memberData = {}

function WarbandSignupPopUp:UpdateMember()
  memberData = warbandProxy:GetMyWarbandViewMember()
  redlog("memberData lengthL : ", #memberData)
  self.memberCtl:ResetDatas(memberData)
  local hasSignup = warbandProxy:CheckHasSignup()
  local signupValid = warbandProxy:CheckSignupTimeValid()
  local isCaptain = warbandProxy:CheckBandAuthority()
  local cankick = warbandProxy.myWarband.memberNum > 1 and not hasSignup
  self.kickBtn.spriteName = cankick and BTN_SP[1] or BTN_SP[3]
  self.kickLab.effectColor = cankick and ColorUtil.ButtonLabelBlue or GRAY_LABEL_COLOR
  if isCaptain then
    self.leaveBtn.spriteName = BTN_SP[4]
    self.leaveBtnLab.effectColor = redOutLineColor
  else
    self.leaveBtn.spriteName = hasSignup and BTN_SP[3] or BTN_SP[4]
    self.leaveBtnLab.effectColor = hasSignup and GRAY_LABEL_COLOR or redOutLineColor
  end
  self.unpreparedBtn.spriteName = hasSignup and BTN_SP[3] or BTN_SP[4]
  self.UnpreparedLab.effectColor = hasSignup and GRAY_LABEL_COLOR or redOutLineColor
  local isfull = warbandProxy:CheckFull()
  local signupvalid = isfull and warbandProxy:CheckSignupTimeValid()
  self.signupBtn.spriteName = signupvalid and BTN_SP[2] or BTN_SP[3]
  self.signupLab.effectColor = signupvalid and ColorUtil.ButtonLabelOrange or GRAY_LABEL_COLOR
  self.signupTip.gameObject:SetActive(not isfull)
end

function WarbandSignupPopUp:SetName()
  local name = self.nameInput.value
  if StringUtil.IsEmpty(name) then
    MsgManager.ShowMsgByIDTable(1006)
    self.nameInput.value = warbandProxy:GetMyWarbandName()
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, self.filterType) then
    MsgManager.ShowMsgByIDTable(2604)
    self.nameInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.warname_min or length > GameConfig.System.warname_max then
    MsgManager.ShowMsgByIDTable(28065)
    self.nameInput.label.color = ColorUtil.NGUILabelRed
    return
  end
  warbandProxy:DoChangeName(self.nameInput.value)
end

function WarbandSignupPopUp:HandleExit()
  self:CloseSelf()
end

function WarbandSignupPopUp:OnEnter()
  WarbandSignupPopUp.super.OnEnter(self)
  self:UpdateView()
end

function WarbandSignupPopUp:OnExit()
  WarbandSignupPopUp.super.OnExit(self)
  FunctionPlayerTip.Me():CloseTip()
end
