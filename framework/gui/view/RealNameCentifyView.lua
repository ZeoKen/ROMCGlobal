autoImport("HomePersonalPictureItemDropCell")
RealNameCentifyView = class("RealNameCentifyView", BaseView)
RealNameCentifyView.ViewType = UIViewType.PopUpLayer
NeedCentifyState = {
  None = 0,
  RealName = 1,
  Phone = 2,
  All = 3
}
local ID_LENGTH = 18

function RealNameCentifyView:Init()
  self:InitData()
  self:InitView()
  self:MapEvent()
end

function RealNameCentifyView:InitData()
  self:GetRCodeData()
  self.rcode = self.rcodeDataList and self.rcodeDataList[1] and self.rcodeDataList[1].CodeID or 86
end

function RealNameCentifyView:InitView()
  self.nameInput = self:FindComponent("NameInput", UIInput)
  self.idInput = self:FindComponent("IdInput", UIInput)
  self.phoneInput = self:FindComponent("PhoneInput", UIInput)
  self.codeInput = self:FindComponent("CodeInput", UIInput)
  self.rcodeLabel = self:FindComponent("RCodeLabel", UILabel)
  self.rcodeLabel.text = "+" .. tostring(self.rcode)
  self:AddClickEvent(self:FindGO("RCode"), function()
    self:ShowItemTabDrop()
  end)
  self.itemDrop = self:FindGO("ItemDrop")
  self.itemDropBgSprite = self.itemDrop:GetComponent(UISprite)
  self.itemDropClose = self:FindComponent("ItemDrop", CloseWhenClickOtherPlace)
  self.itemDropScrollView = self:FindComponent("ScrollView", UIScrollView)
  self.itemDropPanel = self:FindComponent("ScrollView", UIPanel)
  self.itemDropGrid = self:FindComponent("DropListTable", UIGrid)
  self.itemDropList = UIGridListCtrl.new(self.itemDropGrid, HomePersonalPictureItemDropCell, "HomePersonalPictureItemDropCell")
  self.itemDropBar = self:FindComponent("veticalBar", UISprite, self.itemDrop)
  
  function self.itemDropClose.callBack(go)
    self:HideItemTabDrop()
  end
  
  self.itemDropList:AddEventListener(MouseEvent.MouseClick, self.DropItemClick, self)
  self.codeBtnText = self:FindComponent("CodeBtnText", UILabel)
  self.codeBtnText.text = ZhString.RealNameCentify_GetCode
  self.waitingMask = self:FindGO("WaitingMask")
  self.topObj = self:FindGO("Top")
  self.nameObj = self:FindGO("NameObj")
  self.phoneObj = self:FindGO("PhoneObj")
  self.btnObj = self:FindGO("BtnObj")
  self.confirmButton = self:FindGO("ConfirmButton")
  self:AddClickEvent(self.confirmButton, function(go)
    self:DoConfirm()
  end)
  self.cancelButton = self:FindGO("CancelButton")
  self:AddClickEvent(self.cancelButton, function(go)
    self:DoCancel()
  end)
  self.getCodeButton = self:FindGO("GetCodeButton")
  self.getCodeUIButton = self.getCodeButton:GetComponent(UIButton)
  self.getCodeUIButton.isEnabled = true
  self:AddClickEvent(self.getCodeButton, function(go)
    self:DoGetCode()
  end)
end

function RealNameCentifyView:InitShowView()
  if self.checkState == NeedCentifyState.RealName then
    self.topObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.nameObj:SetActive(true)
    self.phoneObj:SetActive(false)
    self.nameObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.btnObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  elseif self.checkState == NeedCentifyState.Phone then
    self.topObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.nameObj:SetActive(false)
    self.phoneObj:SetActive(true)
    self.phoneObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.btnObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.getCodeUIButton.isEnabled = true
    self:SetTextureWhite(self.getCodeButton, ColorUtil.ButtonLabelBlue)
  elseif self.checkState == NeedCentifyState.All then
    self.topObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 80, 0)
    self.nameObj:SetActive(true)
    self.phoneObj:SetActive(true)
    self.nameObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.phoneObj.transform.localPosition = LuaGeometry.GetTempVector3(0, -160, 0)
    self.btnObj.transform.localPosition = LuaGeometry.GetTempVector3(0, -160, 0)
  else
    local c = coroutine.create(function()
      Yield(WaitForSeconds(0.1))
      self:OnPassClose()
    end)
    coroutine.resume(c)
  end
end

function RealNameCentifyView:DoGetCode()
  local phoneInput_value = self.phoneInput.value
  if string.len(phoneInput_value) == 0 or not self.rcode then
    MsgManager.ShowMsgByIDTable(40505)
    return
  end
  if self.codeExpireTick then
    TimeTickManager.Me():ClearTick(self)
    self.codeExpireTick = nil
  end
  self.codeExpireTime = (GameConfig.RealNameCentifyCodeExpire or 60) + ServerTime.CurClientTime() / 1000
  self.codeExpireTick = TimeTickManager.Me():CreateTick(0, 300, self.UpdateCodeExpire, self)
  self.getCodeUIButton.isEnabled = false
  self:SetTextureGrey(self.getCodeButton)
  FunctionLogin.Me():GetMobileVerifyCode(phoneInput_value, self.rcode, function(status, content)
    self:GetPhoneVerifyCodeResponseHandler(status, content)
  end)
end

function RealNameCentifyView:UpdateCodeExpire()
  local leftTime = self.codeExpireTime - ServerTime.CurClientTime() / 1000
  if leftTime < 0 then
    self.getCodeUIButton.isEnabled = true
    self:SetTextureWhite(self.getCodeButton, ColorUtil.ButtonLabelBlue)
    self.codeBtnText.text = ZhString.RealNameCentify_GetCode
    if self.codeExpireTick then
      TimeTickManager.Me():ClearTick(self)
      self.codeExpireTick = nil
    end
  else
    self.codeBtnText.text = math.floor(leftTime)
  end
end

function RealNameCentifyView:DoConfirm()
  if self.waittingRealName or self.waittingPhone then
    MsgManager.ShowMsgByIDTable(952)
    return
  end
  local needRealName = self.checkState & NeedCentifyState.RealName
  local needPhoneNum = self.checkState & NeedCentifyState.Phone
  local idInput_value = self.idInput.value
  local nameInput_value = self.nameInput.value
  self.phoneInput_value = self.phoneInput.value
  local codeInput_value = self.codeInput.value
  if needRealName ~= 0 then
    if string.len(idInput_value) ~= ID_LENGTH then
      MsgManager.ShowMsgByIDTable(1075)
      return
    end
    if string.len(nameInput_value) == 0 then
      MsgManager.ShowMsgByIDTable(40507)
      return
    end
  end
  if needPhoneNum ~= 0 then
    if string.len(self.phoneInput_value) == 0 or not self.rcode then
      MsgManager.ShowMsgByIDTable(40505)
      return
    end
    if string.len(codeInput_value) == 0 then
      MsgManager.ShowMsgByIDTable(40506)
      return
    end
  end
  if needRealName ~= 0 then
    local test_address, test_privateMode
    if not FunctionLogin.Me():getSdkEnable() then
      test_address = NetConfig.PrivateAuthServerUrl
      test_privateMode = true
    end
    local realnameurl = FunctionLogin.Me():GetRealNameCentifyUrl(nameInput_value, idInput_value)
    FunctionLogin.Me():requestGetUrlHost(realnameurl, function(status, content)
      self:RealNameResponseHandler(status, content)
    end, test_address, test_privateMode)
    self.waittingRealName = true
  end
  if needPhoneNum ~= 0 then
    FunctionLogin.Me():BindMobile(self.phoneInput_value, self.rcode, codeInput_value, function(status, content)
      self:PhoneCentifyResponseHandler(status, content)
    end)
    self.waittingPhone = true
  end
  self:UpdateWaitting()
end

function RealNameCentifyView:GetPhoneVerifyCodeResponseHandler(status, param)
  if status == NetConfig.ResponseCodeOk then
    MsgManager.ShowMsgByID(40508)
  else
    MsgManager.ShowMsgByIDTable(40509)
    helplog("获取验证码失败！")
  end
end

function RealNameCentifyView:PhoneCentifyResponseHandler(status, param)
  self.waittingPhone = nil
  self:UpdateWaitting()
  if status == NetConfig.ResponseCodeOk then
    MsgManager.ShowMsgByIDTable(40510)
    FunctionLogin.Me():setPhoneNum(self.rcode .. self.phoneInput_value)
    self.checkState = self.checkState - NeedCentifyState.Phone
    self:CheckCentify()
  else
    MsgManager.ShowMsgByIDTable(40503)
    helplog("绑定手机失败！")
  end
end

function RealNameCentifyView:RealNameResponseHandler(status, param)
  if status == FunctionLogin.AuthStatus.OherError then
    local order = param
    if order.IsOverTime then
      MsgManager.ShowMsgByIDTable(1016)
    end
    self.waittingRealName = false
    self:UpdateWaitting()
    return
  end
  local content = param
  local result
  local isCall = pcall(function()
    result = StringUtil.Json2Lua(content)
    if result == nil and status == NetConfig.ResponseCodeOk then
      result = json.decode(content)
    end
  end)
  if result and result.data then
    ServiceLoginUserCmdProxy.Instance:CallRealAuthorizeUserCmd(result.data)
  end
end

function RealNameCentifyView:UpdateWaitting()
  self.waitingMask:SetActive(self.waittingRealName or self.waittingPhone or false)
end

function RealNameCentifyView:DoCancel()
  self:CloseSelf()
end

function RealNameCentifyView:MapEvent()
  self:AddListenEvt(ServiceEvent.LoginUserCmdRealAuthorizeUserCmd, self.HandleRealAuthorizeServer)
end

function RealNameCentifyView:HandleRealAuthorizeServer(note)
  if not self.waittingRealName then
    return
  end
  local success = note.body.authorized
  self.waittingRealName = false
  self:UpdateWaitting()
  if success then
    MsgManager.ShowMsgByIDTable(40511)
    self.checkState = self.checkState - NeedCentifyState.RealName
    self:CheckCentify()
  else
    MsgManager.ShowMsgByIDTable(45012)
  end
end

function RealNameCentifyView:CheckCentify()
  if self.checkState <= NeedCentifyState.None then
    self:OnPassClose()
  else
    self:InitShowView()
  end
end

function RealNameCentifyView:GetRCodeData()
  if not self.rcodeDataList then
    self.rcodeDataList = {}
    for _, v in ipairs(Table_PhoneCode) do
      table.insert(self.rcodeDataList, {
        Name = v.Name,
        CodeID = v.CodeID
      })
    end
  end
  return self.rcodeDataList
end

function RealNameCentifyView:ShowItemTabDrop()
  self.itemDrop:SetActive(true)
  self.itemDropList:ResetDatas(self:GetRCodeData())
  local heightCount = #self.rcodeDataList > 5 and 5 or #self.rcodeDataList
  local gridHeight = self.itemDropGrid.cellHeight * heightCount
  self.itemDropBgSprite.height = gridHeight + 48
  self.itemDropBar.height = gridHeight + 40
  self.itemDropPanel:SetRect(self.itemDropPanel.baseClipRegion.x, self.itemDropPanel.baseClipRegion.y, self.itemDropPanel.baseClipRegion.z, gridHeight + 8)
  self.itemDrop.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(10, -230 + gridHeight / 2, 0)
  self.itemDropList:Layout()
  self.itemDropScrollView:ResetPosition()
end

function RealNameCentifyView:HideItemTabDrop()
  self.itemDrop:SetActive(false)
end

function RealNameCentifyView:DropItemClick(cell)
  if self.selectTabData ~= cell.data then
    self.selectTabData = cell.data
    self.rcode = self.selectTabData.CodeID
    self.rcodeLabel.text = "+" .. tostring(self.rcode)
  end
  self:HideItemTabDrop()
end

function RealNameCentifyView:OnPassClose()
  self.waitingMask:SetActive(false)
  MsgManager.ShowMsgByID(40502)
  if self.callback then
    self.callback(self.callbackParam)
  end
  self:CloseSelf()
end

function RealNameCentifyView:OnEnter()
  RealNameCentifyView.super.OnEnter(self)
  local viewdata = self.viewdata and self.viewdata.viewdata
  if viewdata then
    self.callback = viewdata.callback
    self.callbackParam = viewdata.callbackParam
    self.checkState = viewdata.state or NeedCentifyState.None
  end
  self:InitShowView()
end

function RealNameCentifyView:OnExit()
  RealNameCentifyView.super.OnExit(self)
  if self.codeExpireTick then
    TimeTickManager.Me():ClearTick(self)
    self.codeExpireTick = nil
  end
  self.waittingRealName = nil
  self.waittingPhone = nil
end
