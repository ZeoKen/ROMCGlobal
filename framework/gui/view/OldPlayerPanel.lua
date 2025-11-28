OldPlayerPanel = class("OldPlayerPanel", ContainerView)
autoImport("InviteItemCell")
autoImport("InvitePlayerCell")
autoImport("RememberLoginUtil")
autoImport("ClientTimeUtil")
OldPlayerPanel.ViewType = UIViewType.NormalLayer
local tipData = {}

function OldPlayerPanel:Init()
  self:initView()
  self:addViewEventListener()
  self:addListEventListener()
  self:AddEvts()
end

function OldPlayerPanel:initView()
  self.invitation = GameConfig.Invitation[self.viewdata.viewdata.invitationid]
  self.tipData = {}
  self.tipData.funcConfig = {}
  local returnTime = GameConfig.Return.Feature[self.invitation.ReturnActivityId]
  self.Main = self:FindGO("Main")
  self.Invitation = self:FindGO("Invitation")
  self.InviteRecord = nil
  local Title = self:FindGO("Title", self.Main):GetComponent(UILabel)
  Title.text = self.invitation.ActivityName
  local adata = FunctionActivity.Me():GetActivityData(ActivityCmd_pb.GACTIVITY_USERRETURN_INVITE)
  if adata ~= nil then
    local activityStart = adata.whole_starttime
    local activityEnd = adata.whole_endtime
    local startTime = ClientTimeUtil.GetOSDateTime(os.date("%Y-%m-%d %H:%M:%S", activityStart))
    local endTime = ClientTimeUtil.GetOSDateTime(os.date("%Y-%m-%d %H:%M:%S", activityEnd))
    local TimeLbl = self:FindGO("TimeLbl", self.Main):GetComponent(UILabel)
    TimeLbl.text = RememberLoginUtil:GetTimeDate(startTime, endTime, ZhString.RememberLoginView_OpenTime)
  end
  self.RewardNodes = {}
  for i = 1, 3 do
    self.RewardNodes[i] = self:FindGO("Reward" .. i, self.Main)
  end
  local idx = 1
  for k, v in pairs(self.invitation.InvitationReward) do
    if self.RewardNodes[idx] ~= nil then
      local stageLbl = self:FindGO("StageLbl", self.RewardNodes[idx]):GetComponent(UILabel)
      stageLbl.text = string.format(ZhString.ReturnActivityPanel_BindPlayer, k)
      local getReward = self:FindGO("GetBtn", self.RewardNodes[idx])
      local getBtnSprite = self:FindGO("Bg", getReward):GetComponent(UISprite)
      getBtnSprite.color = ColorUtil.NGUIShaderGray
      self:AddClickEvent(getReward, function()
        if ReturnActivityProxy.Instance.userReturnInviteData.invitenum >= k then
          local awardid = {k}
          ServiceActivityCmdProxy.Instance:CallUserReturnInviteAwardCmd(awardid)
        end
      end)
      for i = 1, 3 do
        if v[i] ~= nil then
          local itemCellGO = self:FindGO("ActiveItemCell" .. i, self.RewardNodes[idx])
          itemCellGO:SetActive(true)
          local cell = InviteItemCell.new(itemCellGO)
          local data = ItemData.new("active", v[i][1])
          data.num = v[i][2]
          cell:SetData(data)
          cell:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
        else
          local itemCellGO = self:FindGO("ActiveItemCell" .. i, self.RewardNodes[idx])
          itemCellGO:SetActive(false)
        end
      end
    end
    idx = idx + 1
  end
  self.Main_InviteCodeLbl = self:FindGO("InviteCodeLbl", self.Main):GetComponent(UILabel)
  self.Main_CopyBtn = self:FindGO("CopyBtn", self.Main)
  self.Main_InviteLogBtn = self:FindGO("InviteLogBtn", self.Main)
  self.Main_ShareBtn = self:FindGO("ShareBtn", self.Main)
  self.Main_HelpTipBtn = self:FindGO("HelpTip", self.Main)
  self.FirstRewardTips = self:FindGO("FirstRewardTips", self.Main)
  self.FirstRewardTips:SetActive(false)
  local FirstRewardIcon = self:FindGO("FirstRewardIcon", self.Main):GetComponent(UISprite)
  local data = ItemData.new("FirstRewardIcon", self.invitation.ShareReward[1][1])
  IconManager:SetItemIcon(data.staticData.Icon, FirstRewardIcon)
  local FirstRewardCountLbl = self:FindGO("FirstRewardCountLbl", self.Main):GetComponent(UILabel)
  FirstRewardCountLbl.text = "x" .. self.invitation.ShareReward[1][2]
  self.Invitation_NoRecordLbl = self:FindGO("NoRecordLbl", self.Invitation)
  self.Invitation_Title = self:FindGO("Title", self.Invitation):GetComponent(UILabel)
  self.Invitation_InviteSVGO = self:FindGO("InviteScrollView", self.Invitation)
  self.Invitation_InviteSV = self.Invitation_InviteSVGO:GetComponent(UIScrollView)
  local inviteTabel = self:FindGO("InviteTabel", self.Invitation_InviteSVGO):GetComponent(UIGrid)
  self.inviteListCtl = UIGridListCtrl.new(inviteTabel, InvitePlayerCell, "InvitePlayerCell")
  self.Invitation:SetActive(false)
  self:UserReturnInviteRet()
  ServiceActivityCmdProxy.Instance:CallUserReturnInviteCmd()
end

function OldPlayerPanel:addViewEventListener()
  self:AddButtonEvent("cancel", function()
    self:CloseSelf()
  end)
end

function OldPlayerPanel:addListEventListener()
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
      ServiceActivityCmdProxy.Instance:CallUserReturnInviteRecordCmd(nil, self.viewdata.viewdata.invitationid)
    end
  end)
  self:AddClickEvent(self.Main_ShareBtn, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.OldPlayerShareView,
      viewdata = {
        InviteCode = self.Main_InviteCodeLbl.text,
        inviteID = self.viewdata.viewdata.invitationid
      }
    })
  end)
  self:TryOpenHelpViewById(35222, nil, self.Main_HelpTipBtn)
end

function OldPlayerPanel:AddEvts()
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInviteCmd, self.UserReturnInviteRet)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInviteRecordCmd, self.UserReturnInviteRecordRet)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnInviteAwardCmd, self.UserReturnInviteAwardRet)
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.HandleQueryUserInfo)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserReturnShareAwardCmd, self.UserReturnShareAwardRet)
end

function OldPlayerPanel:UserReturnShareAwardRet(data)
  self:UpdateInvitePlayer()
end

function OldPlayerPanel:UserReturnInviteRet(data)
  self.Main_InviteCodeLbl.text = ReturnActivityProxy.Instance.userReturnInviteData.code
  self:UpdateInvitePlayer()
end

function OldPlayerPanel:UserReturnInviteRecordRet(data)
  self.Invitation:SetActive(true)
  self.inviteListCtl:ResetDatas(ReturnActivityProxy.Instance.userReturnInviteData.records)
  self.Main.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(275, -9, 0)
end

function OldPlayerPanel:UserReturnInviteAwardRet(data)
  self:UpdateInvitePlayer()
end

function OldPlayerPanel:HandleQueryUserInfo(note)
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

function OldPlayerPanel:UpdateInvitePlayer()
  if ReturnActivityProxy.Instance.userReturnInviteData.got_share_reward ~= nil and ReturnActivityProxy.Instance.userReturnInviteData.got_share_reward then
    self.FirstRewardTips:SetActive(false)
  else
    self.FirstRewardTips:SetActive(true)
  end
  if ReturnActivityProxy.Instance.userReturnInviteData.invitenum > 0 then
    self.Invitation_NoRecordLbl:SetActive(false)
  else
    self.Invitation_NoRecordLbl:SetActive(true)
  end
  self.Invitation_Title.text = string.format(ZhString.ReturnActivityPanel_InvitePlayer, ReturnActivityProxy.Instance.userReturnInviteData.invitenum)
  local idx = 1
  for k, v in pairs(self.invitation.InvitationReward) do
    if self.RewardNodes[idx] ~= nil then
      local getBtn = self:FindGO("GetBtn", self.RewardNodes[idx])
      local getedFlag = self:FindGO("GetedFlag", self.RewardNodes[idx])
      if ReturnActivityProxy.Instance.userReturnInviteData.invitenum >= tonumber(k) then
        if ReturnActivityProxy.Instance.userReturnInviteData.awardid ~= nil then
          if ReturnActivityProxy.Instance.userReturnInviteData.awardid[k] ~= nil then
            getBtn:SetActive(false)
            getedFlag:SetActive(true)
          else
            local getBtnSprite = self:FindGO("Bg", getBtn):GetComponent(UISprite)
            getBtnSprite.color = ColorUtil.NGUIWhite
            local getBtnLbl = self:FindGO("Label", getBtn):GetComponent(UILabel)
            getBtnLbl.effectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882)
            getBtn:SetActive(true)
            getedFlag:SetActive(false)
          end
        else
          local getBtnSprite = self:FindGO("Bg", getBtn):GetComponent(UISprite)
          getBtnSprite.color = ColorUtil.NGUIWhite
          local getBtnLbl = self:FindGO("Label", getBtn):GetComponent(UILabel)
          getBtnLbl.effectColor = Color(0.6235294117647059, 0.30980392156862746, 0.03529411764705882)
          getBtn:SetActive(true)
          getedFlag:SetActive(false)
        end
      else
        local getBtnSprite = self:FindGO("Bg", getBtn):GetComponent(UISprite)
        getBtnSprite.color = ColorUtil.NGUIShaderGray
        local getBtnLbl = self:FindGO("Label", getBtn):GetComponent(UILabel)
        getBtnLbl.effectColor = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
        getBtn:SetActive(true)
        getedFlag:SetActive(false)
      end
    end
    idx = idx + 1
  end
end

function OldPlayerPanel:OnClickCell(cell)
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

function OldPlayerPanel:CancelChooseReward()
  self:ShowItemTip()
end

function OldPlayerPanel:SharePicture(platform_type, content_title, content_body)
  helplog("OldPlayerPanel SharePicture", platform_type)
  local gmCm = NGUIUtil:GetCameraByLayername("Default")
  local ui = NGUIUtil:GetCameraByLayername("UI")
  self.btnRoot:SetActive(false)
  self.screenShotHelper:Setting(screenShotWidth, screenShotHeight, textureFormat, texDepth, antiAliasing)
  self.screenShotHelper:GetScreenShot(function(texture)
    self.btnRoot:SetActive(true)
    local picName = shotName .. tostring(os.time())
    local path = PathUtil.GetSavePath(PathConfig.TempShare) .. "/" .. picName
    if self.texture ~= nil then
      texture = self.texture
    else
      xdlog("没有获得 texture")
    end
    ScreenShot.SaveJPG(texture, path, 100)
    path = path .. ".jpg"
    helplog("StarView Share path", path)
    if not BranchMgr.IsChina() then
      local overseasManager = OverSeas_TW.OverSeasManager.GetInstance()
      if platform_type ~= "fb" then
        xdlog("startSharePicture", platform_type .. "分享")
        if platform_type == "twitter" then
          content_title = OverseaHostHelper.TWITTER_MSG
        end
        overseasManager:ShareImgWithChannel(path, content_title, OverseaHostHelper.Share_URL, content_body, platform_type, function(msg)
          redlog("msg" .. msg)
          ROFileUtils.FileDelete(path)
          if msg == "1" then
            Debug.Log("success")
          else
            MsgManager.FloatMsgTableParam(nil, ZhString.LineNotInstalled)
          end
        end)
        return
      end
      xdlog("startSharePicture", "fb 分享图片")
      overseasManager:ShareImg(path, content_title, OverseaHostHelper.Share_URL, content_body, function(msg)
        redlog("msg" .. msg)
        ROFileUtils.FileDelete(path)
        if msg == "1" then
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareSuccess)
        else
          MsgManager.FloatMsgTableParam(nil, ZhString.FaceBookShareFailed)
        end
      end)
      return
    end
    SocialShare.Instance:ShareImage(path, content_title, content_body, platform_type, function(succMsg)
      helplog("StarView Share success")
      ROFileUtils.FileDelete(path)
      if platform_type == E_PlatformType.Sina then
        MsgManager.ShowMsgByIDTable(566)
      end
    end, function(failCode, failMsg)
      helplog("StarView Share failure")
      ROFileUtils.FileDelete(path)
      local errorMessage = failMsg or "error"
      if failCode ~= nil then
        errorMessage = failCode .. ", " .. errorMessage
      end
      MsgManager.ShowMsg("", errorMessage, 0)
    end, function()
      helplog("StarView Share cancel")
      ROFileUtils.FileDelete(path)
    end)
  end, gmCm, ui)
end
