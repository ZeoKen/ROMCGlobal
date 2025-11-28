RoleChangeNamePopUp = class("RoleChangeNamePopUp", BaseView)
RoleChangeNamePopUp.ViewType = UIViewType.PopUpLayer
local btnState = {"com_btn_13", "com_btn_1"}

function RoleChangeNamePopUp:Init()
  self.forceReset = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.force
  self:InitPopUp()
  self:MapEvent()
  self.nameInput.characterLimit = GameConfig.System.namesize_max
  self:CheckInputValid()
end

function RoleChangeNamePopUp:InitPopUp()
  self.maskType = GameConfig.MaskWord.ChangeName
  self.nameInput = self:FindComponent("NameInput", UIInput)
  self.confirmButton = self:FindGO("ConfirmButton")
  local cancelButton = self:FindGO("CancelButton")
  self.cancelButtonSpr = cancelButton:GetComponent(UISprite)
  self.cancelButtonLab = self:FindComponent("Label", UILabel, cancelButton)
  self.cancelButtonBox = cancelButton:GetComponent(BoxCollider)
  self:AddClickEvent(self.confirmButton, function(go)
    self:TryChangeName()
  end)
  self.cancelButtonBox.enabled = not self.forceReset
  self.cancelButtonSpr.spriteName = self.forceReset and btnState[1] or btnState[2]
  self.cancelButtonLab.effectStyle = self.forceReset and UILabel.Effect.None or UILabel.Effect.Outline
  self:AddClickEvent(cancelButton, function(go)
    self:CloseSelf()
  end)
  SkipTranslatingInput(self.nameInput)
end

function RoleChangeNamePopUp:CheckInputValid()
  self:AddSelectEvent(self.nameInput, function(go, state)
    if state and FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_USER) then
      self.nameInput.isSelected = false
    end
  end)
end

function RoleChangeNamePopUp:TryChangeName()
  local name = self.nameInput.value
  if ContainsSpecialCharacters(name) then
    MsgManager.ShowMsgByID(1005)
    self:ShowChangeError()
    return
  end
  if name == "" then
    MsgManager.ShowMsgByIDTable(1006)
    self:ShowChangeError()
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.namesize_min or length > GameConfig.System.namesize_max then
    MsgManager.ShowMsgByIDTable(1007)
    self:ShowChangeError()
    return
  end
  if string.find(name, " ") or string.find(name, "　") then
    MsgManager.ShowMsgByIDTable(1005)
    self:ShowChangeError()
    return
  end
  if not (not FunctionMaskWord.Me():CheckMaskWord(name, self.maskType) and StringUtil.CheckTextValidForDisplay(name)) or not StringUtil.HasCharacter(name, self.nameInput.label) then
    MsgManager.ShowMsgByIDTable(1005)
    self:ShowChangeError()
    return
  end
  if name == Game.Myself.data.name then
    MsgManager.ShowMsgByIDTable(1005)
    self:ShowChangeError()
    return
  end
  self:DoChangeName(name)
end

function RoleChangeNamePopUp:ShowChangeError()
  self.nameInput.label.color = ColorUtil.NGUILabelRed
end

function RoleChangeNamePopUp:DoChangeName(name)
  if self.waitRecv == true then
    return
  end
  self.waitRecv = true
  name = RemoveSpecialChara(name)
  ServiceNUserProxy.Instance:CallUserRenameCmd(name, nil, self.forceReset)
end

function RoleChangeNamePopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.NUserUserRenameCmd, self.HandleError)
end

function RoleChangeNamePopUp:HandleError(note)
  self.waitRecv = false
  local errorCode = note.body.code
  if errorCode == SceneUser2_pb.ERENAME_SUCCESS then
    MsgManager.ShowMsgByIDTable(2702)
    local myselfid = Game.Myself and Game.Myself.data and Game.Myself.data.id
    if myselfid then
      MyselfProxy.Instance.roleNameValid[myselfid] = false
    end
    self:CloseSelf()
    return
  end
  if errorCode == SceneUser2_pb.ERENAME_CONFLICT then
    MsgManager.ShowMsgByIDTable(1009)
    self:ShowChangeError()
  elseif errorCode == SceneUser2_pb.ERENAME_CD then
    MsgManager.ShowMsgByIDTable(2701)
    self:ShowChangeError()
  elseif errorCode == 3 then
    MsgManager.ShowMsgByIDTable(2604)
    self:ShowChangeError()
  elseif errorCode == 4 then
    MsgManager.ShowMsgByIDTable(2654)
    self:ShowChangeError()
  end
end
