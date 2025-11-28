PostcardView = class("PostcardView", ContainerView)
PostcardView.ViewType = UIViewType.NormalLayer
autoImport("PopupGridList")
autoImport("MaterialItemCell")
autoImport("PostcardStyleSelectCell")
autoImport("PostcardTargetSelectPopup")
local USAGE = {
  Sender = 1,
  Receiver = 2,
  Operate = 3,
  Gift = 4
}
local StyleLayoutCfg = {
  [1] = {
    AllOffset = {0, 0},
    TitleOffset = {0, 0}
  },
  [2] = {
    AllOffset = {-115, -18},
    TitleOffset = {60, 0}
  }
}

function PostcardView:OnEnter()
  PostcardView.super.OnEnter(self)
  self.usageType = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.usageType
  if not self.usageType then
    self.usageType = USAGE.Operate
  end
  self:ResetContext()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.pendingSelectTarget then
    self.context.flag_PendingSelectTarget = true
  end
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.callback then
    self.callback = self.viewdata.viewdata.callback
  end
  self:RefreshView()
end

function PostcardView:OnExit()
  TimeTickManager.Me():ClearTick(self)
  if self.send_quickContentTabs then
    self.send_quickContentTabs:Destroy()
    self.send_quickContentTabs = nil
  end
  if self.context.backTexureName then
    PictureManager.Instance:UnloadPostcardTexture(self.context.backTexureName, self.common_backTex)
  end
  self:FrontTex_Dispose()
  if self.context.pcData.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL then
    self:Receiver_DoSavePostcard()
  end
  if self.usageType == USAGE.Sender then
    PostcardProxy.Instance:ClearSendPostcardData()
  elseif self.usageType == USAGE.Receiver then
    if self.context.pcData:Query_IsTempReceive() and not self.context.pcData.pending_save then
      PostcardProxy.Instance:ReceiveCards_Del(self.context.pcData)
    end
  elseif self.usageType == USAGE.Gift and self.callback ~= nil then
    self.callback()
  end
  self.callback = nil
  local tex = self.send_screenShotTex.mainTexture
  if tex then
    self.send_screenShotTex.mainTexture = nil
    Object.DestroyImmediate(tex)
  end
  PostcardView.super.OnExit(self)
  PostcardView.ViewType = UIViewType.NormalLayer
end

function PostcardView:Init()
  self:FindObj()
  self:AddEvents()
  self:initScreenShotData()
end

function PostcardView:FindObj()
  self.Layer_Front = self:FindComponent("_FrontLayer", UIPanel)
  self.Layer_Behind = self.gameObject:GetComponent(UIPanel)
  self.theScale = self:FindGO("theScale")
  self.ctBack = self:FindGO("ctBack").transform
  self.ctFront = self:FindGO("ctFront").transform
  self.switchBtn = self:FindGO("switchBtn")
  self:AddClickEvent(self.switchBtn, function()
    self:On_switchBtn()
  end)
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.Part_Common = self:FindGO("CommonPart")
  self.common_toNameLb = self:FindComponent("toName", UILabel, self.Part_Common)
  self.common_contentLb = self:FindComponent("ContentInputLabel", UILabel)
  self.common_contentSv = self:FindComponent("ContentScrollView", UIScrollView, self.Part_Common)
  self.common_frontTex = self:FindComponent("frontTex", UITexture)
  self.common_backTex = self:FindComponent("backTex", UITexture)
  self.common_fromInfo = self:FindGO("fromInfo")
  self.common_fromNameLb = self:FindComponent("fromName", UILabel, self.Part_Common)
  self.common_officalMark = self:FindGO("officalMark", self.Part_Common)
  self.common_oper_mask = self:FindGO("operMask", self.Part_Common)
  self.Part_Send = self:FindGO("SendPart")
  self.Part_Send_Edit = self:FindGO("_Edit", self.Part_Send)
  self.Part_Send_Result = self:FindGO("_Result", self.Part_Send)
  self.send_closeBtn = self:FindGO("Close", self.Part_Send)
  self:AddClickEvent(self.send_closeBtn, function()
    self:On_send_closeBtn()
  end)
  self.send_editTitleBtn = self:FindGO("EditTitleBtn")
  self:AddClickEvent(self.send_editTitleBtn, function()
    self:On_send_editTitleBtn()
  end)
  self.send_contentInput = self:FindComponent("ContentInput", UIInput)
  if self.send_contentInput then
    self.send_contentInput.characterLimit = GameConfig.Postcard.WordLimit
    EventDelegate.Set(self.send_contentInput.onChange, function()
      self:Sender_ContentInputOnChange()
    end)
  end
  self.send_contentCountLb = self:FindComponent("ContentCountTip", UILabel)
  self.send_quickContentTabs = PopupGridList.new(self:FindGO("QuickContentTab"), function(self, data)
    self:Sender_QuickContentTabClick(data)
  end, self, self.Layer_Behind.depth + 10, nil, 1)
  self.send_openStyleBtn = self:FindGO("OpenStyleButton")
  self:AddClickEvent(self.send_openStyleBtn, function()
    self:On_send_openStyleBtn()
  end)
  self.send_styleSelectWidget = self:FindGO("StyleSelectWidget")
  self.send_styleSelectSv = self:FindComponent("ContentScrollView", UIScrollView, self.send_styleSelectWidget)
  self.send_styleSelectGrid = self:FindComponent("ContentContainer", UIGrid, self.send_styleSelectWidget)
  self.send_styleSelectList = UIGridListCtrl.new(self.send_styleSelectGrid, PostcardStyleSelectCell, "PostcardStyleSelectCell")
  self.send_styleSelectList:AddEventListener(MouseEvent.MouseClick, self.On_ClickPostcardStyleSelectCell, self)
  self.send_styleSelectOKBtn = self:FindGO("OKBtn", self.send_styleSelectWidget)
  self:AddClickEvent(self.send_styleSelectOKBtn, function()
    self:On_send_styleSelectOKBtn()
  end)
  self.send_EditTipLb = self:FindComponent("EditTip", UILabel, self.Part_Send)
  self.send_sendBtn = self:FindGO("SendBtn", self.Part_Send)
  self:AddClickEvent(self.send_sendBtn, function()
    self:On_send_sendBtn()
  end)
  self.send_sendFinish = self:FindGO("SendFinish", self.Part_Send)
  local _layer = self:FindGO("_Layer", self.Part_Send)
  self.send_sendFinish = self:LoadPreferb_ByFullPath(ResourcePathHelper.EffectUI("ufx_ui_mxp_get_prf"), _layer)
  self.send_sendFinish.transform.localPosition = LuaGeometry.GetTempVector3()
  self.send_sendFinishConfirmBtn = self:FindGO("ConfirmBtn", self.Part_Send)
  self:AddClickEvent(self.send_sendFinishConfirmBtn, function()
    self:On_send_sendFinishConfirmBtn()
  end)
  self.send_sendAnimLayer = self:FindGO("_SendAnimLayer")
  self.send_screenShotTex = self:FindComponent("Texture", UITexture, self.send_sendAnimLayer)
  local x, y = UIManagerProxy.Instance:GetMyMobileScreenSize()
  self.send_screenShotTex.width = x
  self.send_screenShotTex.height = y
  self.Part_Receive = self:FindGO("ReceivePart")
  self.receive_operGrid = self:FindComponent("operGrid", UIGrid, self.Part_Receive)
  self.receive_closeBtn = self:FindGO("CloseBtn", self.Part_Receive)
  self:AddClickEvent(self.receive_closeBtn, function()
    self:On_receive_closeBtn()
  end)
  self.receive_saveBtn = self:FindGO("SaveBtn", self.Part_Receive)
  self.receive_saveBtn_Lb = self:FindComponent("Label", UILabel, self.receive_saveBtn)
  self:AddClickEvent(self.receive_saveBtn, function()
    self:On_receive_saveBtn()
  end)
  self.receive_giftBtn = self:FindGO("giftBtn", self.Part_Receive)
  self:AddClickEvent(self.receive_giftBtn, function()
    self:On_receive_giftBtn()
  end)
  self.receive_giftBtn:SetActive(false)
  self.receive_giftItemContainer = self:FindGO("ItemContainer", self.receive_giftBtn)
  self.receive_giftPreview = self:FindGO("giftPreview", self.Part_Receive)
  self.receive_rewardTipGrid = self:FindComponent("RewardGrid", UIGrid, self.receive_giftPreview)
  self.receive_rewardTipItemCtrl = UIGridListCtrl.new(self.receive_rewardTipGrid, MaterialItemCell, "MaterialItemCell")
  self.receive_rewardTipItemCtrl:AddEventListener(MouseEvent.MouseClick, self.On_ClickReceiveRewardTipCell, self)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.receive_giftPreview_Close = self:FindGO("thebigclose", self.receive_giftPreview)
  self:AddClickEvent(self.receive_giftPreview_Close, function()
    self.receive_giftPreview:SetActive(false)
  end)
  self.Part_Operate = self:FindGO("OperatePart")
  self.operate_btnTable = self:FindComponent("btnTable", UITable, self.Part_Operate)
  self.operate_savePicBtn = self:FindGO("confirmBtn", self.operate_btnTable.gameObject)
  self:AddClickEvent(self.operate_savePicBtn, function()
    self:On_operate_savePicBtn()
  end)
  self.operate_delBtn = self:FindGO("delBtn", self.operate_btnTable.gameObject)
  self:AddClickEvent(self.operate_delBtn, function()
    self:On_operate_delBtn()
  end)
  self.operate_closeBtn = self:FindGO("closeBtn", self.operate_btnTable.gameObject)
  self:AddClickEvent(self.operate_closeBtn, function()
    self:On_operate_closeBtn()
  end)
  self._Offset_All_1 = self:FindGO("_Offset_All_1")
  self._Offset_All_2 = self:FindGO("_Offset_All_2")
  self._Offset_Title_1 = self:FindGO("_Offset_Title_1")
  self._Offset_Title_2 = self:FindGO("_Offset_Title_2")
  self._AnimTween = {}
  local tween = self.theScale:GetComponentsInChildren(TweenTransform, true)
  for _, v in pairs(tween) do
    v.duration = GameConfig.Postcard.AnimDuration or 0.4
    v:ResetToBeginning()
    v.enabled = false
    TableUtility.ArrayPushBack(self._AnimTween, v)
  end
  self._AnimTween[1]:SetOnFinished(function()
    self:_AnimShowHideButtons(true)
  end)
  self._SendFinishAnimTween = {}
  tween = self.send_sendAnimLayer:GetComponentsInChildren(UITweener, true)
  for _, v in pairs(tween) do
    v.duration = GameConfig.Postcard.Anim2Duration or 0.4
    v:ResetToBeginning()
    v.enabled = false
    TableUtility.ArrayPushBack(self._SendFinishAnimTween, v)
  end
  self._SendFinishAnimTween[1]:SetOnFinished(function()
    self.send_sendAnimLayer:SetActive(false)
  end)
  self._SendFinishAnimTween2 = {}
  tween = self.Part_Send_Result:GetComponentsInChildren(UITweener, true)
  for _, v in pairs(tween) do
    v.duration = GameConfig.Postcard.Anim4Duration or 0.4
    v:ResetToBeginning()
    v.enabled = false
    TableUtility.ArrayPushBack(self._SendFinishAnimTween2, v)
  end
end

function PostcardView:AddEvents()
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.OnHandleQueryUserInfo)
  self:AddListenEvt(ServiceEvent.PhotoCmdSendPostcardCmd, self.OnRecvSendPostcardCmd)
  self:AddListenEvt(FunctionPostcardTex.DlEvent.PhotoDonwloadSucc, self.PersonalThumbnailPhDlCpCallback)
  self:AddListenEvt(FunctionPostcardTex.DlEvent.PhotoDonwloadFailed, self.PersonalThumbnailPhDlErCallback)
  self:AddListenEvt(FunctionPostcardTex.DlEvent.PhotoDonwloadTerminated, self.PersonalThumbnailPhDlErCallback)
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.On_TargetSelectPopup_UpdateList)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.On_TargetSelectPopup_UpdateList)
end

function PostcardView:On_switchBtn()
  if self.hintOnShow ~= nil then
    self.hintOnShow = nil
    if self.hintGO then
      self.hintGO.gameObject:SetActive(false)
    end
  end
  self:SwitchFrontBack(nil, true)
end

function PostcardView:On_send_editTitleBtn()
  if not self.targetSelectPopup then
    self.targetSelectPopup = self:AddSubView("PostcardTargetSelectPopup", PostcardTargetSelectPopup)
  end
  self.targetSelectPopup:Show()
  self.targetSelectPopup:UpdateOnSelectTab()
end

function PostcardView:On_send_openStyleBtn()
  self.send_styleSelectWidget:SetActive(true)
  self:_Sender_RefreshStyleSelectWidget()
end

function PostcardView:On_send_styleSelectOKBtn()
  self.send_styleSelectWidget:SetActive(false)
end

function PostcardView:On_send_sendBtn()
  MsgManager.ConfirmMsgByID(43365, function()
    self:Sender_DoSendPostcard()
  end, nil, nil)
end

function PostcardView:On_send_closeBtn()
  if self.send_contentInput.value and #self.send_contentInput.value > 0 then
    MsgManager.ConfirmMsgByID(43366, function()
      self:CloseSelf()
    end, nil, nil)
  else
    self:CloseSelf()
  end
end

function PostcardView:On_send_sendFinishConfirmBtn()
  self:CloseSelf()
end

function PostcardView:On_receive_closeBtn()
  self:CloseSelf()
end

function PostcardView:On_receive_saveBtn()
  local needKeep = false
  if self.context.pcData:Query_IsTempReceive() and self.context.pcData:Query_CheckSaved() then
  elseif self.usageType == USAGE.Receiver then
    needKeep = self:Receiver_DoSavePostcard()
  elseif self.usageType == USAGE.Gift then
    needKeep = self:Gift_DoSavePostcard()
  end
  if not needKeep then
    self:CloseSelf()
  end
end

function PostcardView:On_receive_giftBtn()
  local rewardTeamids = self.context.pcData.reward
  self:_Receive_ShowGiftRewardTip(rewardTeamids)
end

function PostcardView:_Receive_ShowGiftRewardTip(datas)
  if not datas or #datas <= 0 then
    return
  end
  self.receive_giftPreview:SetActive(true)
  self.receive_rewardTipItemDatas = self.receive_rewardTipItemDatas or {}
  local rData
  for i = 1, #datas do
    rData = datas[i]
    if rData then
      self.receive_rewardTipItemDatas[i] = self.receive_rewardTipItemDatas[i] or ItemData.new()
      self.receive_rewardTipItemDatas[i]:ResetData(MaterialItemCell.MaterialType.Material, rData[1])
      self.receive_rewardTipItemDatas[i].num = rData[2]
      self.receive_rewardTipItemDatas[i].rewardIndex = i
    end
  end
  for i = #datas + 1, #self.receive_rewardTipItemDatas do
    self.receive_rewardTipItemDatas[i] = nil
  end
  self.receive_rewardTipItemCtrl:ResetDatas(self.receive_rewardTipItemDatas)
end

function PostcardView:On_operate_savePicBtn()
  local result = PermissionUtil.Access_SavePicToMediaStorage()
  if result and self.common_frontTex.mainTexture then
    local picName = PersonalPictureDetailPanel.picNameName
    local path = PathUtil.GetSavePath(PathConfig.PhotographPath) .. "/" .. picName
    ScreenShot.SaveJPG(self.common_frontTex.mainTexture, path, 100)
    path = path .. ".jpg"
    FunctionSaveToDCIM.Me():TrySavePicToDCIM(path)
  end
end

function PostcardView:On_operate_delBtn()
  MsgManager.ConfirmMsgByID(43369, function()
    PostcardTestMe.Me():CallDelPostcardCmd(self.context.pcData.id)
    self:CloseSelf()
  end, nil)
end

function PostcardView:On_operate_closeBtn()
  self:CloseSelf()
end

function PostcardView:On_ClickPostcardStyleSelectCell(cell)
  if self.context.pcData.style ~= cell.data.ID then
    self.context.pcData.style = cell.data.ID
    self:_Sender_RefreshStyleSelectWidgetSelected()
    self:_Common_LoadCardBack()
    self:_Common_ResetStyleLayout()
  end
end

function PostcardView:On_ClickReceiveRewardTipCell(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {300, -100})
  end
end

function PostcardView:OnHandleQueryUserInfo(note)
  if self.usageType == USAGE.Sender then
    return
  end
  local data = note.body and note.body.data
  if self.context.pcData.sender == data.guid then
    self.context.pcData:Receive_SetSenderData(data)
    self:_Common_UpdateFromInfo()
  end
end

function PostcardView:OnRecvSendPostcardCmd(note)
  self:StartSendFinishAnim()
end

function PostcardView:_PreSendFinishAnim()
  if self.usageType ~= USAGE.Sender then
    return
  end
  self.common_oper_mask:SetActive(false)
  self.Part_Send_Edit:SetActive(false)
  self:_Common_UpdateFromInfo()
  self:_Common_UpdateTextColor(true)
end

function PostcardView:_PostSendFinishAnim()
  if self.usageType ~= USAGE.Sender then
    return
  end
  self.Part_Send_Result:SetActive(true)
  self.common_fromInfo:SetActive(true)
  self.send_sendFinishConfirmBtn:SetActive(true)
  self.send_sendFinish:SetActive(true)
end

function PostcardView:On_TargetSelectPopup_UpdateList()
  if self.targetSelectPopup then
    self.targetSelectPopup:TryUpdateFriendList()
  end
end

function PostcardView:PersonalThumbnailPhDlCpCallback(note)
  local data = note.body
  local my_id = self.context.pcData.temp_receive_id or self.context.pcData.id
  if data.id ~= my_id then
    return
  end
  if data.is_thumb then
    self:FrontTex_TryLoadThumbTex(true)
  else
    self:FrontTex_TryLoadFullTex(true)
  end
end

function PostcardView:PersonalThumbnailPhDlErCallback(note)
  local data = note.body
  local my_id = self.context.pcData.temp_receive_id or self.context.pcData.id
  if data.id ~= my_id then
    return
  end
  if data.is_thumb then
    self:FrontTex_TryLoadThumbTex(false)
  else
    self:FrontTex_TryLoadFullTex(false)
  end
end

function PostcardView:ResetContext()
  self:Common_ResetContext()
  if self.usageType == USAGE.Sender then
    self:Sender_ResetContext()
  elseif self.usageType == USAGE.Receiver then
    self:Receiver_ResetContext()
  elseif self.usageType == USAGE.Operate then
    self:Operate_ResetContext()
  elseif self.usageType == USAGE.Gift then
    self:Gift_ResetContext()
  end
end

function PostcardView:RefreshView()
  self:Common_RefreshView()
  if self.usageType == USAGE.Sender then
    self:Sender_RefreshView()
  elseif self.usageType == USAGE.Receiver then
    self:Receiver_RefreshView()
  elseif self.usageType == USAGE.Operate then
    self:Operate_RefreshView()
  elseif self.usageType == USAGE.Gift then
    self:Gift_RefreshView()
  end
end

function PostcardView:Common_ResetContext()
  self.context = {}
  self.context.flag_LoadFrontTex = nil
  self.context.flag_FetchSenderData = nil
  self.context.flag_DoSavePostcard = nil
  self.context.flag_DoSendPostcard = nil
end

function PostcardView:Common_RefreshView()
  self.theScale.transform.localScale = LuaGeometry.Const_V3_one
  self.Part_Common:SetActive(true)
  self.common_fromInfo:SetActive(true)
  self.switchBtn:SetActive(true)
  self.common_oper_mask:SetActive(false)
  self:_Common_UpdateTextColor(true)
  self:_Common_LoadCardFront()
  self:_Common_LoadCardBack()
  self:_Common_ResetStyleLayout()
  self:SwitchFrontBack(false)
end

function PostcardView:_Common_ResetStyleLayout()
  local styleCfg = GameConfig.Postcard.Styles[self.context.pcData.style]
  if self.context.layoutStyle ~= styleCfg.Layout then
    self.context.layoutStyle = styleCfg.Layout
    local layoutCfg = StyleLayoutCfg[self.context.layoutStyle]
    self._Offset_All_1.transform.localPosition = LuaGeometry.GetTempVector3(layoutCfg.AllOffset[1], layoutCfg.AllOffset[2], 0)
    self._Offset_All_2.transform.localPosition = LuaGeometry.GetTempVector3(layoutCfg.AllOffset[1], layoutCfg.AllOffset[2], 0)
    self._Offset_Title_1.transform.localPosition = LuaGeometry.GetTempVector3(layoutCfg.TitleOffset[1], layoutCfg.TitleOffset[2], 0)
    self._Offset_Title_2.transform.localPosition = LuaGeometry.GetTempVector3(layoutCfg.TitleOffset[1], layoutCfg.TitleOffset[2], 0)
  end
end

function PostcardView:_Common_LoadCardFront()
  if self.context.flag_LoadFrontTex then
    return
  end
  self:FrontTex_Load()
  self.context.flag_LoadFrontTex = true
end

function PostcardView:_Common_LoadCardBack()
  local styleCfg = GameConfig.Postcard.Styles[self.context.pcData.style]
  if self.context.backTexureName ~= styleCfg.Tex then
    if self.context.backTexureName then
      PictureManager.Instance:UnloadPostcardTexture(self.context.backTexureName, self.common_backTex)
    end
    self.context.backTexureName = styleCfg.Tex
    PictureManager.Instance:SetPostcardTexture(self.context.backTexureName, self.common_backTex)
  end
end

function PostcardView:_Common_UpdateToNameLb()
  self.common_toNameLb.text = Game.Myself.data.name
end

function PostcardView:_Common_UpdateFromInfo()
  local from_official = self.context.pcData.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL
  self.common_officalMark:SetActive(from_official)
  if not from_official then
    local senderName = self.context.pcData:Receive_GetSenderName()
    if not senderName and not self.context.flag_FetchSenderData then
      self.context.flag_FetchSenderData = true
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.context.pcData.sender)
    end
    self.common_fromNameLb.text = senderName
  else
    self.common_fromNameLb.text = self.context.pcData.senderName or ZhString.Postcard_OfficialName
  end
end

function PostcardView:_Common_UpdateContent()
  self.common_contentLb.text = self.context.pcData.content
end

function PostcardView:_Common_UpdateTextColor(isSent)
  if isSent then
    self.common_toNameLb.color = LuaColor.Black()
    self.common_contentLb.color = LuaColor.Black()
  else
    self.common_toNameLb.color = LuaColor.New(0.2549019607843137, 0.34901960784313724, 0.6666666666666666, 1)
    self.common_contentLb.color = LuaColor.New(0.5725490196078431, 0.5725490196078431, 0.5725490196078431, 1)
  end
end

function PostcardView:Sender_ResetContext()
  self.context.pcData = PostcardProxy.Instance:GetSendPostcardData()
  self.context.pcData.type = EPOSTCARDTYPE.EPOSTCARD_PLAYER
  self.context.pcData.sender = Game.Myself.data.id
  self.context.pcData.senderName = Game.Myself.data.name
  self.context.pcData.url = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.url
  self.context.pcData.source = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.source
  self.context.direct_local_path = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.local_path
end

function PostcardView:Sender_RefreshView()
  self.Part_Send:SetActive(true)
  self.Part_Receive:SetActive(false)
  self.Part_Operate:SetActive(false)
  self.common_fromInfo:SetActive(true)
  self:_Common_UpdateFromInfo()
  self:_Common_UpdateTextColor(false)
  self.send_contentInput.value = nil
  self.send_sendBtn:SetActive(true)
  self.send_sendFinishConfirmBtn:SetActive(false)
  self.send_sendFinish:SetActive(false)
  self:_Sender_UpdateToNameLb()
  self:_Sender_UpdateContentCountLb()
  self:_Sender_RefreshQuickContentTabs()
  self:_Sender_RefreshStyleSelectWidget()
  self:Sender_RefreshSendBtnStatus()
  if self.context.flag_PendingSelectTarget then
    self.theScale:SetActive(false)
    if not self.targetSelectPopup then
      self.targetSelectPopup = self:AddSubView("PostcardTargetSelectPopup", PostcardTargetSelectPopup)
    end
    self.targetSelectPopup:Show()
    self.targetSelectPopup:UpdateOnSelectTab()
  end
end

function PostcardView:_Sender_UpdateContentCountLb()
  local limit = GameConfig.Postcard.WordLimit
  local input = self.send_contentInput.value
  self.send_contentCountLb.text = (input and OverseaHostHelper:GetStringLength(input) or 0) .. "/" .. limit
end

function PostcardView:_Sender_UpdateToNameLb()
  local targetName = self.context.pcData:Send_GetTargetName()
  self.common_toNameLb.text = targetName
end

function PostcardView:_Sender_RefreshQuickContentTabs()
  local list = {}
  for i = 1, #GameConfig.Postcard.GWordTemplates do
    list[#list + 1] = {
      id = #list + 1,
      Name = GameConfig.Postcard.GWordTemplates[i],
      forceHideRedTip = true
    }
  end
  self.send_quickContentTabs:SetData(list, true, true)
end

function PostcardView:_Sender_RefreshStyleSelectWidget()
  self.send_styleSelectList:ResetDatas(GameConfig.Postcard.Styles)
  self:_Sender_RefreshStyleSelectWidgetSelected()
end

function PostcardView:_Sender_RefreshStyleSelectWidgetSelected()
  local cells = self.send_styleSelectList:GetCells()
  for i = 1, #cells do
    if cells[i].data.ID == self.context.pcData.style then
      cells[i]:SetSelected(true)
    else
      cells[i]:SetSelected(false)
    end
  end
end

function PostcardView:Sender_SetTarget(data)
  if data then
    self.context.pcData:Send_SetTargetData(data)
    self:_Sender_UpdateToNameLb()
  end
  self:Sender_RefreshSendBtnStatus()
  if self.context.flag_PendingSelectTarget then
    self.theScale:SetActive(true)
    self.context.flag_PendingSelectTarget = false
  end
end

local lastHeightOver

function PostcardView:Sender_ContentInputOnChange()
  local heightOver = self.common_contentLb.height > 150
  if lastHeightOver ~= heightOver then
    lastHeightOver = heightOver
    if lastHeightOver then
      self.common_contentSv.contentPivot = UIWidget.Pivot.BottomLeft
    else
      self.common_contentSv.contentPivot = UIWidget.Pivot.TopLeft
    end
    self.common_contentSv:ResetPosition()
  elseif lastHeightOver then
    self.common_contentSv:ResetPosition()
  end
  if OverseaHostHelper:GetStringLength(self.send_contentInput.value) > GameConfig.Postcard.WordLimit then
    MsgManager.ShowMsgByID(28010)
  end
  self:_Sender_UpdateContentCountLb()
  self:Sender_RefreshSendBtnStatus()
end

function PostcardView:Sender_QuickContentTabClick(data)
  if OverseaHostHelper:GetStringLength(data.Name) > GameConfig.Postcard.WordLimit then
    MsgManager.ShowMsgByID(28010)
  else
    self.send_contentInput.value = data.Name
  end
  self:_Sender_UpdateContentCountLb()
  self:Sender_RefreshSendBtnStatus()
end

function PostcardView:Sender_RefreshSendBtnStatus()
  if self.context.pcData.targetData == nil then
    self.send_EditTipLb.text = ZhString.Postcard_Tip_NeedTarget
    UIUtil.TempSetButtonStyle(10, self.send_sendBtn)
  elseif OverseaHostHelper:GetStringLength(self.send_contentInput.value) == 0 then
    self.send_EditTipLb.text = ZhString.Postcard_Tip_NeedContent
    UIUtil.TempSetButtonStyle(10, self.send_sendBtn)
  else
    self.send_EditTipLb.text = ""
    UIUtil.TempSetButtonStyle(12, self.send_sendBtn)
  end
end

function PostcardView:Sender_DoSendPostcard()
  if self.context.flag_DoSendPostcard then
    return
  end
  self.context.pcData.content = string.gsub(self.send_contentInput.value or "", "|", "")
  local info = self.context.pcData:ToPostcardItem()
  PostcardTestMe.Me():CallSendPostcardCmd(info, self.context.pcData.targetData.guid)
  self.context.flag_DoSendPostcard = true
  self.send_sendBtn:SetActive(false)
  self.common_oper_mask:SetActive(true)
  self:_PreSendFinishAnim()
end

function PostcardView:Receiver_ResetContext()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.postcard then
    self.context.pcData = PostcardData.Clone(self.viewdata.viewdata.postcard)
    PostcardProxy.Instance:ReceiveCards_Add(self.context.pcData)
  end
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.questData then
    self.context.questData = self.viewdata.viewdata.questData
  end
end

function PostcardView:Receiver_RefreshView()
  self.Part_Send:SetActive(false)
  self.Part_Receive:SetActive(true)
  self.Part_Operate:SetActive(false)
  self:_Common_UpdateToNameLb()
  self:_Common_UpdateFromInfo()
  self:_Common_UpdateContent()
  self:Receiver_FirstTimeHint()
  self:Receiver_UpdateOperBtns()
  self:SwitchFrontBack(true)
end

function PostcardView:Receiver_DoSavePostcard()
  if self.usageType ~= USAGE.Receiver then
    return
  end
  if self.context.flag_DoSavePostcard then
    return
  end
  local savefunc = function(the_replace_del_postcard_id)
    if the_replace_del_postcard_id then
      PostcardTestMe.Me():CallDelPostcardCmd(the_replace_del_postcard_id)
    end
    if self.context.questData then
      QuestProxy.Instance:notifyQuestState(self.context.questData.scope, self.context.questData.id, self.context.questData.staticData.FinishJump)
    else
      PostcardProxy.Instance:ReceiveCards_Save(self.context.pcData)
    end
    self.context.flag_DoSavePostcard = true
    self:CloseSelf()
  end
  if self.context.pcData.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL then
    savefunc()
  else
    local saveExceed = PostcardProxy.Instance:Query_GetSaveCount() >= GameConfig.Postcard.CardSaveLimit
    if saveExceed then
      MsgManager.ConfirmMsgByID(43374, function()
        PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
        local viewdata = {
          ShowMode = PersonalPicturePanel.ShowMode.ReplaceMode,
          initialTab = PersonalPicturePanel.Album.PostcardAlbum,
          callback = savefunc
        }
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.PersonalPicturePanel,
          viewdata = viewdata
        })
      end, nil)
      return true
    else
      savefunc()
    end
  end
end

function PostcardView:Receiver_FirstTimeHint()
  if not LocalSaveProxy.Instance:GetDontShowAgain(GameConfig.Postcard.HideUI_Hint_ID) then
    self.hintGO = self:FindChild("GuideRoot")
    local hintTextLb = self:FindChild("labContent"):GetComponent(UILabel)
    hintTextLb.text = Table_Sysmsg[GameConfig.Postcard.HideUI_Hint_ID].Text
    self.hintGO.gameObject:SetActive(true)
    self.hintOnShow = 1
    LocalSaveProxy.Instance:AddDontShowAgain(GameConfig.Postcard.HideUI_Hint_ID, 0)
  end
end

function PostcardView:Receiver_UpdateOperBtns()
  local hasReward = self.context.pcData.reward and #self.context.pcData.reward > 0
  self.receive_giftBtn:SetActive(hasReward == true)
  local is_official = self.context.pcData.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL
  local is_temp_receive_saved = self.context.pcData:Query_IsTempReceive() and self.context.pcData:Query_CheckSaved()
  if is_temp_receive_saved then
    self.receive_saveBtn_Lb.text = ZhString.Postcard_Btn_Saved
  else
    self.receive_saveBtn_Lb.text = ZhString.Postcard_Btn_Save
  end
  self.receive_closeBtn:SetActive(not is_official and not is_temp_receive_saved)
  self.receive_operGrid:Reposition()
end

function PostcardView:Operate_ResetContext()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.postcard_id then
    self.context.pcData = PostcardProxy.Instance:Query_GetPostcardById(self.viewdata.viewdata.postcard)
  elseif self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.postcard then
    self.context.pcData = self.viewdata.viewdata.postcard
  end
  self.context.readOnly = self.viewdata.viewdata.readOnly
end

function PostcardView:Operate_RefreshView()
  self.theScale.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
  self.Part_Send:SetActive(false)
  self.Part_Receive:SetActive(false)
  self.Part_Operate:SetActive(true)
  self:_Common_UpdateToNameLb()
  self:_Common_UpdateFromInfo()
  self:_Common_UpdateContent()
  if self.context.readOnly then
    self.operate_savePicBtn:SetActive(false)
    self.operate_delBtn:SetActive(false)
  end
  if self.context.pcData.type == EPOSTCARDTYPE.EPOSTCARD_OFFICIAL then
    self.operate_delBtn:SetActive(false)
  end
  self:SwitchFrontBack(true)
end

function PostcardView:Gift_ResetContext()
  if self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.postcard then
    self.context.pcData = PostcardData.Clone(self.viewdata.viewdata.postcard)
  end
end

function PostcardView:Gift_RefreshView()
  self.Part_Send:SetActive(false)
  self.Part_Receive:SetActive(true)
  self.Part_Operate:SetActive(false)
  self:_Common_UpdateToNameLb()
  self:_Common_UpdateFromInfo()
  self:_Common_UpdateContent()
  self:Gift_UpdateOperBtns()
  self:SwitchFrontBack(false)
  self.switchBtn:SetActive(false)
  self:ActiveFrontLayer(false)
end

function PostcardView:Gift_UpdateOperBtns()
  local hasReward = self.context.pcData.reward and #self.context.pcData.reward > 0
  self.receive_giftBtn:SetActive(hasReward == true)
  self.receive_saveBtn_Lb.text = ZhString.Postcard_Btn_Receive
  self.receive_closeBtn:SetActive(false)
  self.receive_operGrid:Reposition()
end

function PostcardView:Gift_DoSavePostcard()
  xdlog("申请领取奖励")
  self:CloseSelf()
end

function PostcardView:SwitchFrontBack(front, useAnim)
  if front ~= nil then
    self.context.flag_showBack = front
  end
  if self.context.flag_showBack then
    if useAnim then
      self:AnimSwitch2Front()
    else
      self.Layer_Front.depth = self.Layer_Behind.depth + 1
    end
    self.context.flag_showBack = nil
  else
    if useAnim then
      self:AnimSwitch2Back()
    else
      self.Layer_Front.depth = self.Layer_Behind.depth - 1
    end
    self.context.flag_showBack = true
  end
end

function PostcardView:AnimSwitch2Back()
  self:_AnimShowHideButtons(false)
  self:_PlayAnimTween()
  TimeTickManager.Me():CreateOnceDelayTick(500 * (GameConfig.Postcard.AnimDuration or 0.4), function(owner, deltaTime)
    self.Layer_Front.depth = self.Layer_Behind.depth - 1
  end, self)
end

function PostcardView:AnimSwitch2Front()
  self:_AnimShowHideButtons(false)
  self:_PlayAnimTween()
  TimeTickManager.Me():CreateOnceDelayTick(500 * (GameConfig.Postcard.AnimDuration or 0.4), function(owner, deltaTime)
    self.Layer_Front.depth = self.Layer_Behind.depth + 2
  end, self)
end

function PostcardView:_PlayAnimTween()
  if self.tweenReverse then
    for i = 1, #self._AnimTween do
      self._AnimTween[i].enabled = true
      self._AnimTween[i]:Sample(1, true)
      self._AnimTween[i]:PlayReverse()
    end
    self.tweenReverse = false
  else
    for i = 1, #self._AnimTween do
      self._AnimTween[i].enabled = true
      self._AnimTween[i]:Sample(0, true)
      self._AnimTween[i]:PlayForward()
    end
    self.tweenReverse = true
  end
end

function PostcardView:_AnimShowHideButtons(show)
  self.switchBtn:SetActive(show)
  if self.usageType == USAGE.Sender then
    self.Part_Send:SetActive(show)
  elseif self.usageType == USAGE.Receiver then
    self.Part_Receive:SetActive(show)
  elseif self.usageType == USAGE.Operate then
    self.Part_Operate:SetActive(show)
  end
end

function PostcardView:ActiveFrontLayer(bool)
  self.Layer_Front.gameObject:SetActive(bool)
end

function PostcardView:initScreenShotData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function PostcardView:StartSendFinishAnim()
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.screenShotHelper:Setting(self.screenShotWidth, self.screenShotHeight, self.textureFormat, self.texDepth, self.antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.send_screenShotTex.mainTexture = texture
    self:_PlaySendFinishAnimTween()
    TimeTickManager.Me():CreateOnceDelayTick(1000 * ((GameConfig.Postcard.Anim2Duration or 0.4) + (GameConfig.Postcard.Anim3Duration or 0.4)), function(owner, deltaTime)
      self:_PostSendFinishAnim()
      self:_PlaySendFinishAnimTween2()
    end, self)
  end, ui)
end

function PostcardView:_PlaySendFinishAnimTween()
  for i = 1, #self._SendFinishAnimTween do
    self._SendFinishAnimTween[i].enabled = true
    self._SendFinishAnimTween[i]:Sample(0, true)
    self._SendFinishAnimTween[i]:PlayForward()
  end
end

function PostcardView:_PlaySendFinishAnimTween2()
  for i = 1, #self._SendFinishAnimTween2 do
    self._SendFinishAnimTween2[i].enabled = true
    self._SendFinishAnimTween2[i]:Sample(0, true)
    self._SendFinishAnimTween2[i]:PlayForward()
  end
end

function PostcardView:FrontTex_Load()
  if self.usageType == USAGE.Sender and self.context.direct_local_path then
    local tex = DiskFileManager.Instance:LoadTexture2D(self.context.direct_local_path, (ServerTime.CurServerTime() or -1) / 1000, 100)
    self:FrontTex_SetTex(tex)
    return
  end
  if self.context.pcData:Tex_IsLocalRes() then
    local texName = self.context.pcData:Tex_GetLocalResPath()
    if self.context.frontTexureName ~= texName then
      if self.context.frontTexureName then
        PictureManager.Instance:UnloadPostcardTexture(self.context.frontTexureName, self.common_frontTex)
      end
      self.context.frontTexureName = texName
      PictureManager.Instance:SetPostcardTexture(self.context.frontTexureName, self.common_frontTex)
    end
  else
    self:FrontTex_TryLoadThumbTex()
  end
end

function PostcardView:FrontTex_Dispose()
  if self.context.pcData:Tex_IsLocalRes() then
    if self.context.frontTexureName then
      PictureManager.Instance:UnloadPostcardTexture(self.context.frontTexureName, self.common_frontTex)
    end
  else
    self.context.pcData:Tex_TerminateDl()
    local tex = self.common_frontTex.mainTexture
    if tex then
      self.common_frontTex.mainTexture = nil
      Object.DestroyImmediate(tex)
    end
  end
end

function PostcardView:FrontTex_TryLoadThumbTex(dlResult)
  local tex, dlFull
  if dlResult == true then
    tex = self.context.pcData:Tex_LoadOutTex(true)
    dlFull = true
  elseif dlResult == false then
    dlFull = true
  else
    tex = self.context.pcData:Tex_TryLoadOutOrDl(true)
    dlFull = tex ~= nil
  end
  if tex then
    self:FrontTex_SetTex(tex)
  end
  if dlFull then
    self:FrontTex_TryLoadFullTex()
  end
end

function PostcardView:FrontTex_TryLoadFullTex(dlResult)
  local tex
  if dlResult == true then
    tex = self.context.pcData:Tex_LoadOutTex()
  elseif dlResult == false then
  else
    tex = self.context.pcData:Tex_TryLoadOutOrDl()
  end
  if tex then
    self:FrontTex_SetTex(tex)
  end
end

function PostcardView:FrontTex_SetTex(newTex)
  local tex = self.common_frontTex.mainTexture
  if tex then
    self.common_frontTex.mainTexture = nil
    Object.DestroyImmediate(tex)
  end
  self.common_frontTex.mainTexture = newTex
end
