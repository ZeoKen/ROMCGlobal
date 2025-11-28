autoImport("TutorCell")
StudentView = class("StudentView", SubView)
local viewName = "view/StudentView"
local studentFunkey = {
  "InviteMember",
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "Tutor_DeleteStudent",
  "InviteEnterGuild",
  "EnterHomeRoom"
}
local recentStudentFunkey = {
  "InviteMember",
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "InviteEnterGuild",
  "EnterHomeRoom"
}
local tipData = {}
local shield_certificate = GameConfig.Tutor.shield_certificate

function StudentView:FindObj()
  self.myStudent = self:FindGO("MyStudent")
  self.addStudent = self:FindGO("OpenAddStudent")
  self.recentStudent = self:FindGO("RecentStudent")
  self.applyBtn = self:FindGO("ApplyBtn")
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.proficiencyLabel = self:FindComponent("TutorProgressLabel", UILabel)
  self.proficiencyLabel.text = ZhString.Tutor_TutorPoint
  self.proficiencyProgress = self:FindComponent("Progress", UILabel)
  self.proficiencyProgressBar = self:FindComponent("ProgressSlider", UISlider)
  self.tutorProgress = self:FindGO("TutorProgress")
end

function StudentView:AddButtonEvt()
  self:AddClickEvent(self.applyBtn, function()
    self:Apply()
  end)
  local shopBtn = self:FindGO("ShopBtn")
  self:AddClickEvent(shopBtn, function()
    self:Shop()
  end)
  local addBtn = self:FindGO("AddBtn")
  self:AddClickEvent(addBtn, function()
    self:Add()
  end)
  self:AddHelpButtonEvent()
  self:AddClickEvent(self:FindGO("rewardBox"), function()
    local dont = LocalSaveProxy.Instance:GetDontShowAgain(40019)
    if not dont then
      MsgManager.DontAgainConfirmMsgByID(40019, function()
        self:PopUpTutorRewardBox()
      end, nil, nil)
    else
      self:PopUpTutorRewardBox()
    end
  end)
end

function StudentView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateView)
  self:AddListenEvt(ServiceEvent.TutorTutorTaskUpdateBoxCmd, self.UpdateRedTip)
  self:AddListenEvt(ServiceEvent.UserEventQueryFavoriteFriendUserEvent, self.UpdateView)
  self:AddListenEvt(ServiceEvent.UserEventUpdateFavoriteFriendUserEvent, self.UpdateView)
end

function StudentView:InitShow()
  if shield_certificate and shield_certificate == 1 then
    self.tutorProgress:SetActive(false)
  else
    self.tutorProgress:SetActive(true)
  end
  local studentGrid = self:FindGO("StudentGrid"):GetComponent(UIGrid)
  self.studentCtl = UIGridListCtrl.new(studentGrid, TutorCell, "StudentCell")
  self.studentCtl:AddEventListener(FriendEvent.SelectHead, self.ClickStudent, self)
  local recentStudentGrid = self:FindGO("RecentStudentGrid"):GetComponent(UIGrid)
  self.recentStudentCtl = UIGridListCtrl.new(recentStudentGrid, TutorCell, "TutorCell")
  self.recentStudentCtl:AddEventListener(FriendEvent.SelectHead, self.ClickRecentStudent, self)
  self.rewardBox = self:FindGO("rewardBox")
  self.rewardBoxSP = self.rewardBox:GetComponent(UISprite)
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_BOX, self.rewardBox, 6, {-5, -5})
  self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_APPLY, self.applyBtn, 6, {-5, -5})
  self:UpdateView()
end

function StudentView:Apply()
  local data = TutorProxy.Instance:GetApplyList()
  if 0 < #data then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TutorApplyView
    })
  else
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_TUTOR_APPLY)
    MsgManager.ShowMsgByID(3232)
  end
end

function StudentView:Shop()
  FuncShortCutFunc.Me():CallByID(972)
end

function StudentView:Add()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TutorMatchView,
    viewdata = TutorType.Student
  })
  self.container:CloseSelf()
end

function StudentView:UpdateStudent()
  local _TutorProxy = TutorProxy.Instance
  local data = _TutorProxy:GetStudentList()
  local studentCount = #data
  if 0 < studentCount then
    self.studentCtl:ResetDatas(data)
  end
  self.addStudent:SetActive(not _TutorProxy:CheckStudentFull())
end

function StudentView:UpdateRecentStudent()
  local data = TutorProxy.Instance:GetRecentStudentList()
  local isShow = 0 < #data
  if isShow then
    self.recentStudentCtl:ResetDatas(data)
  end
  self.recentStudent:SetActive(isShow)
end

function StudentView:UpdateView()
  self:UpdateStudent()
  self:UpdateRecentStudent()
  self.table:Reposition()
end

function StudentView:ClickStudent(cell)
  local data = cell.data
  if data then
    local playerData = PlayerTipData.new()
    playerData:SetByFriendData(data)
    FunctionPlayerTip.Me():CloseTip()
    local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60})
    tipData.playerData = playerData
    tipData.funckeys = studentFunkey
    playerTip:SetData(tipData)
  end
end

function StudentView:ClickRecentStudent(cell)
  local data = cell.data
  if data then
    local playerData = PlayerTipData.new()
    playerData:SetByFriendData(data)
    FunctionPlayerTip.Me():CloseTip()
    local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cell.headIcon.clickObj, NGUIUtil.AnchorSide.Left, {-380, 60})
    tipData.playerData = playerData
    tipData.funckeys = recentStudentFunkey
    playerTip:SetData(tipData)
  end
end

function StudentView:ChangeView()
  if self.init == nil then
    local preferb = self:LoadPreferb(viewName)
    preferb.transform:SetParent(self.container.tutorRoot.transform, false)
    self.trans = preferb.transform
    self.gameObject = preferb
    local panel = self.container.gameObject:GetComponent(UIPanel)
    local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
    for i = 1, #uipanels do
      uipanels[i].depth = uipanels[i].depth + panel.depth
    end
    self:FindObj()
    self:AddButtonEvt()
    self:AddViewEvt()
    self:InitShow()
    self:UpdateProgress()
    self.init = true
  end
end

function StudentView:UpdateProgress(data)
  if self.gameObject and self.proficiencyProgress and self.proficiencyProgressBar then
    local tutorPoint = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_TUTOR_CERTIFICATE) or 0
    self.proficiencyProgress.text = tutorPoint .. "/" .. (GameConfig.Tutor.max_certificate_num or 0)
    self.proficiencyProgressBar.value = tutorPoint / (GameConfig.Tutor.max_certificate_num or 1)
  end
end

function StudentView:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideHpMp()
    self.targetCell:HideLevel()
  end
  local headData = HeadImageData.new()
  headData:TransByMyself()
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end

function StudentView:UpdateRedTip()
  local datas = TutorProxy.Instance:GetTutorBoxList()
  if datas and 0 < #datas and 0 < datas[1].num then
    RedTipProxy.Instance:UpdateRedTip(SceneTip_pb.EREDSYS_TUTOR_BOX)
  else
    RedTipProxy.Instance:RemoveWholeTip(SceneTip_pb.EREDSYS_TUTOR_BOX)
  end
end

function StudentView:PopUpTutorRewardBox()
  local datas = TutorProxy.Instance:GetTutorBoxList()
  if datas and 0 < #datas then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TutorRewardBoxPopUp
    })
  else
    MsgManager.ShowMsgByID(40020)
  end
end
