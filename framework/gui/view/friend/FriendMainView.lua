autoImport("FriendView")
autoImport("TutorMainView")
FriendMainView = class("FriendMainView", ContainerView)
FriendMainView.ViewType = UIViewType.ChatroomLayer
FriendMainView.TabName = {
  [1] = ZhString.FriendMainView_FriendTabName,
  [2] = ZhString.FriendMainView_TutorTabName
}

function FriendMainView:OnEnter()
  FriendMainView.super.OnEnter(self)
  self:TabChangeHandler(PanelConfig.FriendView.tab)
end

function FriendMainView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function FriendMainView:FindObjs()
  self.friendRoot = self:FindGO("FriendRoot")
  self.tutorRoot = self:FindGO("TutorRoot")
  self.listTitle = self:FindGO("ListTitle"):GetComponent(UILabel)
end

function FriendMainView:AddEvts()
  local friendBtn = self:FindGO("FriendBtn")
  self.tutorBtn = self:FindGO("TutorBtn")
  self:AddTabChangeEvent(friendBtn, self.friendRoot, PanelConfig.FriendView)
  if GameConfig.SystemForbid.Tutor then
    friendBtn:SetActive(false)
    self.tutorBtn:SetActive(false)
    local bg = self:FindGO("MainBg"):GetComponent(UISprite)
    bg.leftAnchor.absolute = bg.leftAnchor.absolute + 70
    bg.rightAnchor.absolute = bg.rightAnchor.absolute + 70
  elseif FunctionUnLockFunc.Me():CheckCanOpen(9000) then
    self:AddTabChangeEvent(self.tutorBtn, self.tutorRoot, PanelConfig.TutorView)
    if TutorProxy.Instance:GetFuncState() then
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_APPLY, self.tutorBtn, 2, {-12, -10})
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_TASK, self.tutorBtn, 2, {-12, -10})
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_GROW_REWARD, self.tutorBtn, 2, {-12, -10})
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_TUTOR_BOX, self.tutorBtn, 2, {-12, -10})
    end
  else
    friendBtn:SetActive(false)
    self.tutorBtn:SetActive(false)
    local bg = self:FindGO("MainBg"):GetComponent(UISprite)
    bg.leftAnchor.absolute = bg.leftAnchor.absolute + 70
    bg.rightAnchor.absolute = bg.rightAnchor.absolute + 70
  end
  self.tabIconSpList = {}
  local toggleList, icon = {
    friendBtn,
    self.tutorBtn
  }
  for i, v in ipairs(toggleList) do
    local longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.FriendMainView, {state, i})
    end
    
    icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
    TabNameTip.SwitchShowTabIconOrLabel(icon, Game.GameObjectUtil:DeepFindChild(v, "NameLabel"))
    self.tabIconSpList[#self.tabIconSpList + 1] = icon:GetComponent(UISprite)
  end
  self:AddEventListener(TipLongPressEvent.FriendMainView, self.HandleLongPress, self)
  self:UpdateTutorBtn()
end

function FriendMainView:AddViewEvts()
  if TutorProxy.Instance:GetFuncState() then
    self:AddListenEvt(RedTipProxy.UpdateRedTipEvent, self.UpdateRedTip)
    self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.UpdateRedTip)
  end
  self:AddListenEvt(ServiceEvent.SessionSocialityTutorFuncStateNtfSocialCmd, self.UpdateTutorBtn)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function FriendMainView:InitShow()
  self.friendView = self:AddSubView("FriendView", FriendView)
  self.tutorMainView = self:AddSubView("TutorMainView", TutorMainView)
end

function FriendMainView:TabChangeHandler(key)
  if key == PanelConfig.TutorView.tab then
    self.friendView:CheckFavoriteModeOnExit(function()
      if FriendMainView.super.TabChangeHandler(self, key) then
        self.listTitle.text = ZhString.Tutor_Title
        self:ShowFriend(false)
        self.friendView:ExitMarkingFavoriteMode()
        self.tutorMainView:ChangeView()
        self:SetCurrentTabIconColor(self.coreTabMap[key].go)
      end
    end)
  elseif key == PanelConfig.FriendView.tab and FriendMainView.super.TabChangeHandler(self, key) then
    self.listTitle.text = ZhString.Friend_ListTitle
    self:ShowFriend(true)
    self:SetCurrentTabIconColor(self.coreTabMap[key].go)
  end
end

function FriendMainView:ShowFriend(isShow)
  self.friendRoot:SetActive(isShow)
  self.tutorRoot:SetActive(not isShow)
end

function FriendMainView:UpdateRedTip(note)
  local data = note.body
  if data and data.id == SceneTip_pb.EREDSYS_TUTOR_TASK and self.tutorMainView.lastView ~= nil then
    self.tutorMainView.lastView:UpdateView()
  end
end

function FriendMainView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, FriendMainView.TabName[index], false, self.coreTabMap[index].go:GetComponent(UISprite))
end

function FriendMainView:SetCurrentTabIconColor(currentTabGo)
  TabNameTip.ResetColorOfTabIconList(self.tabIconSpList)
  TabNameTip.SetupIconColorOfCurrentTabObj(currentTabGo)
end

function FriendMainView:UpdateTutorBtn()
  helplog("FriendMainView:UpdateTutorBtn", TutorProxy.Instance:GetFuncState())
  if not TutorProxy.Instance:GetFuncState() or not FunctionUnLockFunc.Me():CheckCanOpen(9000) then
    self.tutorBtn:SetActive(false)
  else
    self.tutorBtn:SetActive(true)
  end
end

function FriendMainView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    if self.friendView then
      self.friendView:CheckFavoriteModeOnExit(function()
        self:CloseSelf()
      end)
    end
  end)
end
