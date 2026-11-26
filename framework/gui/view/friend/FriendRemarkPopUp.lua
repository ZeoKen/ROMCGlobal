FriendRemarkPopUp = class("FriendRemarkPopUp", ContainerView)
FriendRemarkPopUp.ViewType = UIViewType.PopUpLayer

function FriendRemarkPopUp:Init()
  self.data = self.viewdata.viewdata
  self.originalRemark = self.data.remark or ""
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function FriendRemarkPopUp:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.contentInput = self.contentLabel.gameObject:GetComponent(UIInput)
  if self.contentInput == nil then
    self.contentInput = UIUtil.GetComponentInParents(self.contentLabel.gameObject, UIInput)
  end
  self.confirmLabel = self:FindComponent("ConfirmLabel", UILabel)
  self.cancelLabel = self:FindComponent("CancelLabel", UILabel)
end

function FriendRemarkPopUp:InitView()
  self.title.text = ZhString.Friend_RemarkTitle
  self.confirmLabel.text = ZhString.UniqueConfirmView_Confirm
  self.cancelLabel.text = ZhString.UniqueConfirmView_CanCel
  self.contentInput.defaultText = ZhString.Friend_RemarkInputHint
  self.maskType = GameConfig.MaskWord.ChangeName
  self.remarkMax = GameConfig.Social and GameConfig.Social.remark_max or 12
  self.contentInput.characterLimit = self.remarkMax
  EventDelegate.Set(self.contentInput.onChange, function()
    self:LimitInput()
  end)
  self.contentInput.value = self.originalRemark
  SkipTranslatingInput(self.contentInput)
  self:RefreshInputLabel()
end

function FriendRemarkPopUp:RefreshInputLabel()
  local value = self.contentInput.value
  self.contentInput.label.supportEncoding = true
  if value ~= "" then
    local hint = ZhString.Friend_RemarkValueHint
    if not BranchMgr.IsChina() then
      hint = OverSea.LangManager.Instance():GetLangByKey(hint)
    end
    self.contentInput.label.text = string.format(hint, value)
  end
end

function FriendRemarkPopUp:GetRemarkLength(value)
  local length = 0
  for character in string.gmatch(value, "[%z\001-\127�-�][�-�]*") do
    length = length + (1 < #character and 2 or 1)
  end
  return length
end

function FriendRemarkPopUp:LimitInput()
  if self.limitChanging then
    return
  end
  local value = self.contentInput.value
  local length = StringUtil.getTextLen(value)
  while 0 < length and self:GetRemarkLength(value) > self.remarkMax do
    length = length - 1
    value = StringUtil.getTextByIndex(value, 1, length)
  end
  if value ~= self.contentInput.value then
    self.limitChanging = true
    self.contentInput.value = value
    self.limitChanging = false
  end
end

function FriendRemarkPopUp:AddEvents()
  self:AddListenEvt(ServiceEvent.SessionSocialityModifyFriendRemark, self.HandleModifyFriendRemark)
  self:AddButtonEvent("ConfirmBtn", function()
    self:Confirm()
  end)
  self:AddButtonEvent("CancelBtn", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self:AddSelectEvent(self.contentInput, function(_, state)
    if state then
      self.contentInput.label.supportEncoding = false
      self.contentInput.label.text = self.contentInput.value
    else
      self:RefreshInputLabel()
    end
  end)
end

function FriendRemarkPopUp:IsValid(value)
  if value == "" then
    return true
  end
  if self:GetRemarkLength(value) > self.remarkMax then
    return false
  end
  if ContainsSpecialCharacters(value) or string.find(value, " ") or string.find(value, "　") or string.find(value, "[\r\n]") then
    return false
  end
  if FunctionMaskWord.Me():CheckMaskWord(value, self.maskType) then
    return false
  end
  return StringUtil.CheckTextValidForDisplay(value) and StringUtil.HasCharacter(value, self.contentInput.label)
end

function FriendRemarkPopUp:Confirm()
  local value = self.contentInput.value
  if not self:IsValid(value) then
    self.contentInput.label.color = ColorUtil.NGUILabelRed
    MsgManager.FloatMsg("", ZhString.Friend_RemarkInvalid)
    return
  end
  if value == self.originalRemark then
    self:CloseSelf()
    return
  end
  if value == "" and self.originalRemark ~= "" then
    MsgManager.ConfirmMsgWithCustomText(ZhString.Friend_RemarkTitle, ZhString.Friend_RemarkClearConfirm, function()
      self:Submit("")
    end, function()
      self.contentInput.value = self.originalRemark
      self:RefreshInputLabel()
    end, nil, ZhString.Friend_RemarkClearConfirmButton, ZhString.UniqueConfirmView_CanCel)
    return
  end
  self:Submit(value)
end

function FriendRemarkPopUp:Submit(value)
  if self.waitRecv then
    return
  end
  self.waitRecv = true
  if not FriendProxy.Instance:SetFriendRemark(self.data.guid, value) then
    self.waitRecv = false
  end
end

function FriendRemarkPopUp:HandleModifyFriendRemark(note)
  local data = note.body
  if not self.waitRecv or data == nil or data.charid ~= self.data.guid then
    return
  end
  self.waitRecv = false
  redlog("HandleModifyFriendRemark", tostring(data.success))
  if data.success then
    self:CloseSelf()
  else
    self.contentInput.label.color = ColorUtil.NGUILabelRed
    MsgManager.FloatMsg("", ZhString.Friend_RemarkModifyFailed)
  end
end
