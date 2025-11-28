OldPlayerOverSeaPanel = class("OldPlayerOverSeaPanel", ContainerView)
autoImport("OldPlayerOverSeaCell")
autoImport("InvitePlayerOverSeaCell")
autoImport("RememberLoginUtil")
autoImport("ClientTimeUtil")
autoImport("InviteItemCell")
OldPlayerOverSeaPanel.ViewType = UIViewType.NormalLayer
local tipData = {}

function OldPlayerOverSeaPanel:Init()
  self:initView()
  self:addViewEventListener()
  self:addListEventListener()
  self:AddEvts()
end

function OldPlayerOverSeaPanel:initView()
  self.invitation = GameConfig.RecommendAct[self.viewdata.viewdata.recommendActid]
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.Main = self:FindGO("Main")
  self.Invitation = self:FindGO("Invitation")
  self.InviteRecord = nil
  local Title = self:FindGO("Title", self.Main):GetComponent(UILabel)
  Title.text = self.invitation.ActivityName
  local adata = FunctionActivity.Me():GetActivityData(ActivityCmd_pb.GACTIVITY_RECOMMEND)
  if adata ~= nil then
    local activityStart = adata.whole_starttime
    local activityEnd = adata.whole_endtime
    local startTime = ClientTimeUtil.GetOSDateTime(os.date("%Y-%m-%d %H:%M:%S", activityStart))
    local endTime = ClientTimeUtil.GetOSDateTime(os.date("%Y-%m-%d %H:%M:%S", activityEnd))
    local TimeLbl = self:FindGO("TimeLbl", self.Main):GetComponent(UILabel)
    TimeLbl.text = RememberLoginUtil:GetTimeDate(startTime, endTime, ZhString.RememberLoginView_OpenTime)
  end
  if self.invitation.SpecialAward ~= nil then
    local ExtraBonus = self:FindGO("ExtraBonus", self.Main)
    ExtraBonus:SetActive(true)
    local itemCellGO = self:FindGO("ActiveItemCell", ExtraBonus)
    itemCellGO:SetActive(true)
    local spreward = ItemUtil.GetRewardItemIdsByTeamId(self.invitation.SpecialAward[10000])
    if spreward then
      local cell = InviteItemCell.new(itemCellGO)
      local itemdata = ItemData.new("active", spreward[1].id)
      itemdata.num = spreward[1].num
      cell:SetData(itemdata)
      cell:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
    end
    local getBtnExtraBonus = self:FindGO("GetBtn", ExtraBonus)
    self:AddClickEvent(getBtnExtraBonus, function()
      helplog("getBtnExtraBonus ==== ")
      ServiceActivityCmdProxy.Instance:CallUserInviteAwardCmd({10000}, ReturnActivityProxy.Instance.recommendactData.id)
      helplog("getBtnExtraBonus ==== ")
    end)
  else
    local ExtraBonus = self:FindGO("ExtraBonus", self.Main)
    ExtraBonus:SetActive(false)
  end
  local OldPlayerOverSeaTable = self:FindGO("OldPlayerOverSeaTable", self.Main):GetComponent(UIGrid)
  self.oldPlayerListCtl = UIGridListCtrl.new(OldPlayerOverSeaTable, OldPlayerOverSeaCell, "OldPlayerOverSeaCell")
  self.oldPlayerListCtl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.oldPlayerListCtl:ResetDatas(self.invitation.TargetAward)
  self.Main_InviteCodeLbl = self:FindGO("InviteCodeLbl", self.Main):GetComponent(UILabel)
  self.Main_CopyBtn = self:FindGO("CopyBtn", self.Main)
  self.Main_InviteLogBtn = self:FindGO("InviteLogBtn", self.Main)
  self.Main_ShareBtn = self:FindGO("ShareBtn", self.Main)
  self.Main_HelpTipBtn = self:FindGO("HelpTip", self.Main)
  self.FirstRewardTips = self:FindGO("FirstRewardTips", self.Main)
  self.FirstRewardTips:SetActive(false)
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", self.Main):GetComponent(UISprite)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", self.Main):GetComponent(UILabel)
  local spreward = ItemUtil.GetRewardItemIdsByTeamId(self.invitation.SpecialAward[10001])
  if spreward then
    local data = ItemData.new("FirstRewardIcon", spreward[1].id)
    IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
    FirstRewardCountLbl.text = "x" .. spreward[1].num
  end
  self.Invitation_NoRecordLbl = self:FindGO("NoRecordLbl", self.Invitation)
  self.Invitation_Title = self:FindGO("Title", self.Invitation):GetComponent(UILabel)
  self.Invitation_InviteSVGO = self:FindGO("InviteScrollView", self.Invitation)
  self.Invitation_InviteSV = self.Invitation_InviteSVGO:GetComponent(UIScrollView)
  local inviteTabel = self:FindGO("InviteTabel", self.Invitation_InviteSVGO):GetComponent(UIGrid)
  self.inviteListCtl = UIGridListCtrl.new(inviteTabel, InvitePlayerOverSeaCell, "InvitePlayerOverSeaCell")
  self.Invitation:SetActive(false)
  self:UserInviteRet()
  ServiceActivityCmdProxy.Instance:CallUserInviteCmd()
end

function OldPlayerOverSeaPanel:addViewEventListener()
  self:AddButtonEvent("cancel", function()
    self:CloseSelf()
  end)
end

function OldPlayerOverSeaPanel:addListEventListener()
  self:AddClickEvent(self.Main_CopyBtn, function()
    MsgManager.ShowMsgByID(40580)
    local result = ApplicationInfo.CopyToSystemClipboard(self.Main_InviteCodeLbl.text)
    helplog("invite code ==== ", self.Main_InviteCodeLbl.text)
  end)
  self:AddClickEvent(self.Main_InviteLogBtn, function()
    if self.Invitation.activeSelf then
      self.Invitation:SetActive(false)
      self.Main.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, -9, 0)
    else
      ServiceActivityCmdProxy.Instance:CallUserReturnInviteRecordCmd(nil, self.viewdata.viewdata.recommendActid)
    end
  end)
  self:AddClickEvent(self.Main_ShareBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.OldPlayerShareOverSeaView,
      viewdata = {
        InviteCode = self.Main_InviteCodeLbl.text,
        inviteID = self.viewdata.viewdata.recommendActid
      }
    })
  end)
  self:TryOpenHelpViewById(35087, nil, self.Main_HelpTipBtn)
end

function OldPlayerOverSeaPanel:AddEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteCmd, self.UserInviteRet)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInviteRecordCmd, self.UserReturnInviteRecordRet)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteAwardCmd, self.UserInviteAwardRet)
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.HandleQueryUserInfo)
end

function OldPlayerOverSeaPanel:UserInviteRet(data)
  self.Main_InviteCodeLbl.text = ReturnActivityProxy.Instance.userInviteData.code
  self:UpdateInvitePlayer()
end

function OldPlayerOverSeaPanel:UserReturnInviteRecordRet(data)
  self.Invitation:SetActive(true)
  self.inviteListCtl:ResetDatas(ReturnActivityProxy.Instance.userInviteData.records)
  self.Main.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(275, -9, 0)
  if #ReturnActivityProxy.Instance.userInviteData.records > 0 then
    self.Invitation_NoRecordLbl:SetActive(false)
    self.FirstRewardTips:SetActive(false)
  else
    self.Invitation_NoRecordLbl:SetActive(true)
    self.FirstRewardTips:SetActive(true)
  end
  self.Invitation_Title.text = string.format(ZhString.ReturnActivityPanel_InvitePlayer, #ReturnActivityProxy.Instance.userInviteData.records)
end

function OldPlayerOverSeaPanel:UserInviteAwardRet(data)
  self:UpdateInvitePlayer()
end

function OldPlayerOverSeaPanel:HandleQueryUserInfo(note)
  local data = note.body
  if data then
    if self.playerTipData == nil then
      self.playerTipData = PlayerTipData.new()
    end
    self.playerTipData:SetBySocialData(data.data)
    local _FunctionPlayerTip = FunctionPlayerTip.Me()
    _FunctionPlayerTip:CloseTip()
    local playerTip = _FunctionPlayerTip:GetPlayerTip(self.bg, NGUIUtil.AnchorSide.Right, {100, 100})
    tipData.playerData = self.playerTipData
    tipData.funckeys = funkey
    playerTip:SetData(tipData)
  end
end

function OldPlayerOverSeaPanel:UpdateInvitePlayer()
  if #ReturnActivityProxy.Instance.userInviteData.records > 0 then
    self.Invitation_NoRecordLbl:SetActive(false)
    self.FirstRewardTips:SetActive(false)
  else
    self.Invitation_NoRecordLbl:SetActive(true)
    self.FirstRewardTips:SetActive(true)
  end
  local state = ReturnActivityProxy.Instance.GetActivityState(10000)
  local ExtraBonus = self:FindGO("ExtraBonus", self.Main)
  local getBtnExtraBonus = self:FindGO("GetBtn", ExtraBonus)
  local getedFlag = self:FindGO("GetedFlag", ExtraBonus)
  if state == EAWARDSTATE.EAWARD_STATE_PROHIBIT then
    local getBtnSprite = self:FindGO("Bg", getBtnExtraBonus):GetComponent(UISprite)
    getBtnSprite.color = ColorUtil.NGUIShaderGray
    local getBtnLbl = self:FindGO("Label", getBtnExtraBonus):GetComponent(UILabel)
    getBtnLbl.effectColor = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
    getBtnExtraBonus:SetActive(true)
    getedFlag:SetActive(false)
  elseif state == EAWARDSTATE.EAWARD_STATE_CANGET then
    local getBtnSprite = self:FindGO("Bg", getBtnExtraBonus):GetComponent(UISprite)
    getBtnSprite.color = ColorUtil.NGUIWhite
    local getBtnLbl = self:FindGO("Label", getBtnExtraBonus):GetComponent(UILabel)
    getBtnLbl.effectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882)
    getBtnExtraBonus:SetActive(true)
    getedFlag:SetActive(false)
  elseif state == EAWARDSTATE.EAWARD_STATE_RECEIVED then
    getBtnExtraBonus:SetActive(false)
    getedFlag:SetActive(true)
  end
  self.Invitation_Title.text = string.format(ZhString.ReturnActivityPanel_InvitePlayer, #ReturnActivityProxy.Instance.userInviteData.records)
  self.oldPlayerListCtl:ResetDatas(self.invitation.TargetAward)
end

function OldPlayerOverSeaPanel:OnClickCell(cell)
  local callback = function()
    self:CancelChooseReward()
  end
  local stick = cell.gameObject:GetComponent(UIWidget)
  local sdata = {
    itemdata = cell.data,
    funcConfig = {},
    callback = callback,
    ignoreBounds = {
      cell.gameObject
    }
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
end

function OldPlayerOverSeaPanel:CancelChooseReward()
  self:ShowItemTip()
end

function OldPlayerOverSeaPanel:HandleClickItem(cell)
  local callback = function()
    self:CancelChooseReward()
  end
  local stick = cell.gameObject:GetComponent(UIWidget)
  local sdata = {
    itemdata = cell.data,
    funcConfig = {},
    callback = callback,
    ignoreBounds = {
      cell.gameObject
    }
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
end
