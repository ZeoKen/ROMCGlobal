autoImport("PlayerRefluxItemCell")
autoImport("PlayerRefluxLoginItemCell")
PlayerRefluxView = class("PlayerRefluxView", BaseView)
PlayerRefluxView.ViewType = UIViewType.NormalLayer
local bgName = "reflux_bg_01"
local proxy
local funkey = {"ShowDetail"}
local tipData = {}

function PlayerRefluxView:Init()
  proxy = PlayerRefluxProxy.Instance
  self:FindObj()
  self:AddEvents()
  self:InitData()
end

function PlayerRefluxView:FindObj()
  self.bg = self:FindComponent("Bg", UITexture)
  local titleRoot = self:FindGO("titleRoot")
  self.titleLable = self:FindComponent("titleLable", UILabel, titleRoot)
  self.timeLable = self:FindComponent("timeLable", UILabel)
  local inviteCodeRoot = self:FindGO("InviteCodeRoot")
  self.inviteCodeLaber = self:FindComponent("inviteNumberLaber", UILabel, inviteCodeRoot)
  local recordRoot = self:FindGO("recordRoot")
  self.recallLable = self:FindComponent("recallLable", UILabel, recordRoot)
  self.playerNameRoot = self:FindGO("invitationBg")
  self.playerName = self:FindComponent("playerName", UILabel, recordRoot)
  self.clickUrl = self:FindComponent("playerName", UILabelClickUrl, recordRoot)
  local recogrid = self:FindComponent("recoredGrid", UIGrid, recordRoot)
  self.recoredGrid = UIGridListCtrl.new(recogrid, PlayerRefluxItemCell, "PlayerRefluxItemCell")
  self.recoredGrid:AddEventListener(MouseEvent.MouseClick, self.ClickPreviewRewardItem, self)
  local loginRecordroot = self:FindGO("loginRecordroot")
  self.loginTitleLable = self:FindComponent("titleLable", UILabel, loginRecordroot)
  self.loginNumLable = self:FindComponent("loginNumLable", UILabel, loginRecordroot)
  self.loginInfoLable = self:FindComponent("loginInfo", UILabel, loginRecordroot)
  local loginGridRoot = self:FindComponent("loginGrid", UIGrid, loginRecordroot)
  self.loginGrid = UIGridListCtrl.new(loginGridRoot, PlayerRefluxLoginItemCell, "PlayerRefluxLoginItemCell")
  self.loginGrid:AddEventListener(MouseEvent.MouseClick, self.ClickPreviewRewardItem, self)
  self.firstShareRoot = self:FindGO("firstShareRoot")
  self.firstShareIcon = self:FindComponent("icon", UISprite, self.firstShareRoot)
  self.firstShareLable = self:FindComponent("num", UILabel, self.firstShareRoot)
  self.closeButton = self:FindGO("Closebutton")
  self.tipButton = self:FindGO("tipBtn", titleRoot)
  self:RegistShowGeneralHelpByHelpID(35087, self.tipButton)
  self.copyButton = self:FindGO("copyButton", inviteCodeRoot)
  self.shareButton = self:FindGO("shareButton", inviteCodeRoot)
  self.lableTweenInfos = {}
  local timeLableScrol = self:FindComponent("timeScrol", UIPanel)
  self.lableTweenInfos[1] = {}
  self.lableTweenInfos[1].lable = self.timeLable
  self.lableTweenInfos[1].maxwidth = timeLableScrol.width
  self.lableTweenInfos[1].pos = self.timeLable.transform.localPosition
  self.lableTweenInfos[1].pivot = self.timeLable.pivot
  self.lableTweenInfos[1].tweenPosition = self.timeLable:GetComponent(TweenPosition)
  local recallLableScrol = self:FindComponent("recallLableScrol", UIPanel, recordRoot)
  self.lableTweenInfos[2] = {}
  self.lableTweenInfos[2].lable = self.recallLable
  self.lableTweenInfos[2].maxwidth = recallLableScrol.width
  self.lableTweenInfos[2].pos = self.recallLable.transform.localPosition
  self.lableTweenInfos[2].pivot = self.recallLable.pivot
  self.lableTweenInfos[2].tweenPosition = self.recallLable:GetComponent(TweenPosition)
  local playerNameScrol = self:FindComponent("playerNameScrol", UIPanel, recordRoot)
  self.lableTweenInfos[3] = {}
  self.lableTweenInfos[3].lable = self.playerName
  self.lableTweenInfos[3].maxwidth = playerNameScrol.width
  self.lableTweenInfos[3].pos = self.playerName.transform.localPosition
  self.lableTweenInfos[3].pivot = self.playerName.pivot
  self.lableTweenInfos[3].tweenPosition = self.playerName:GetComponent(TweenPosition)
end

function PlayerRefluxView:AddEvents()
  function self.clickUrl.callback(url)
    if url ~= nil and self.refluxData.inviteuserid ~= nil then
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.refluxData.inviteuserid)
    end
  end
  
  self:AddClickEvent(self.closeButton, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.copyButton, function()
    local result = ApplicationInfo.CopyToSystemClipboard(self.inviteCode)
    if result then
      MsgManager.ShowMsgByID(40200)
    end
  end)
  self:AddClickEvent(self.shareButton, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    if self.isRecellEndtime then
      MsgManager.ShowMsgByIDTable(40973)
      return
    end
    local viewData = {
      viewname = "PlayerRefluxShareView",
      inviteCode = self.inviteCode
    }
    self:sendNotification(UIEvent.ShowUI, viewData)
  end)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteInviteLoginAwardCmd, self.RefeshLoginRewardCell)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteInviteAwardCmd, self.HandleInviteAward)
  self:AddListenEvt(PlayerRefluxEvent.ShareRelfuxPic, self.HandelShareSucess)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteShareAwardCmd, self.HandelGetShareReward)
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.HandleQueryUserInfo)
  self:AddListenEvt(PlayerRefluxEvent.InviteLoginAward, self.ReceiveAllReward)
end

function PlayerRefluxView:InitData()
  self.refluxData = proxy:GetRefluxData()
  self.isRecellEndtime = proxy:IsRecellTimeEnd()
  if self.refluxData then
    self.inviteCodeLaber.text = self.refluxData.invitecode
    self.loginNumLable.text = self.refluxData.invitelogindays or 0
    self.inviteCode = self.refluxData.invitecode
    if self.refluxData.inviteusername ~= "" then
      self.playerName.text = string.format(ZhString.PlayerRefluxView_RefluxInvited, self.refluxData.inviteuserid, self.refluxData.inviteusername)
    else
      self.playerName.text = ZhString.PlayerRefluxView_Complete
    end
    if self.refluxData.sharawarded or self.isRecellEndtime then
      self.firstShareRoot:SetActive(false)
    else
      self.firstShareRoot:SetActive(true)
    end
  end
  self.configData = proxy:GetConfigMap()
  self:RefeshTimeLable()
  if self.configData then
    local rewardData = {}
    local tempTable = {}
    if self.configData.InvitationReward then
      for k, v in pairs(self.configData.InvitationReward) do
        tempTable = {}
        tempTable.Item = v
        tempTable.isGetReward = self.refluxData.inviteawarded
        table.insert(rewardData, tempTable)
      end
      self.recoredGrid:ResetDatas(rewardData)
    end
    rewardData = {}
    if self.configData.ActivitySigninReward then
      for k, v in pairs(self.configData.ActivitySigninReward) do
        tempTable = {}
        tempTable.Item = v.Item
        tempTable.index = k
        tempTable.inviteawardid = self.refluxData.inviteawardid
        tempTable.invitelogindays = self.refluxData.invitelogindays
        table.insert(rewardData, tempTable)
      end
      table.sort(rewardData, function(a, b)
        return a.index < b.index
      end)
      self.loginGrid:ResetDatas(rewardData)
    end
    if self.configData.ShareReward then
      local itemId = self.configData.ShareReward[1][1]
      local itemData = Table_Item[itemId]
      if itemData and itemData.Icon then
        IconManager:SetItemIcon(itemData.Icon, self.firstShareIcon)
      end
      local num = self.configData.ShareReward[1][2]
      self.firstShareLable.text = num
    end
  end
  self:ShowBindPanel()
  self:ShowTweenLable()
end

function PlayerRefluxView:RefeshTimeLable()
  local startDate = proxy:GetAcSatrtTime()
  local endDate = proxy:GetAcEndTime()
  local recellTimeData = proxy:GetRecellEndTime()
  local textLa = ""
  if self.isRecellEndtime then
    textLa = string.format(self.configData.ShowingText, endDate.month, endDate.day, endDate.hour, endDate.min)
    self.timeLable.text = textLa
  else
    self.timeLable.text = string.format(ZhString.TimePeriodFormat3, startDate.month, startDate.day, startDate.hour, startDate.min, recellTimeData.month, recellTimeData.day, recellTimeData.hour, recellTimeData.min)
  end
end

function PlayerRefluxView:ShowBindPanel()
  if self.refluxData and self.refluxData.inviteusername ~= "" and self.refluxData.inviteawarded == false then
    local viewData = {
      viewname = "PlayerRefluxPopView",
      data = {
        configData = self.configData,
        inviteCode = false,
        playerName = self.refluxData.inviteusername,
        playerId = self.refluxData.inviteuserid
      }
    }
    self:sendNotification(UIEvent.ShowUI, viewData)
  end
end

function PlayerRefluxView:ReceiveAllReward()
  redlog("======= PlayerRefluxBackView:ReceiveAllReward()=======")
  local childCells = self.loginGrid:GetCells()
  local reward = {}
  for i = 1, #childCells do
    if childCells[i].canReceive then
      table.insert(reward, childCells[i].data.index)
    end
  end
  if 0 < #reward then
    PlayerRefluxProxy.Instance:CallUserInviteInviteLoginAwardCmd(reward)
  end
end

function PlayerRefluxView:RefeshLoginRewardCell(data)
  if not data.body or not data.body.id then
    return
  end
  local childCells = self.loginGrid:GetCells()
  for i = 1, #childCells do
    childCells[i]:SetGetRewardDay(proxy:GetInviteawardId())
  end
end

function PlayerRefluxView:RefeshRecoredGridCell()
  local childCells = self.recoredGrid:GetCells()
  for i = 1, #childCells do
    childCells[i]:RefeshCell(proxy:Getinviteawarded())
  end
end

function PlayerRefluxView:HandleInviteAward(data)
  if not data and not data.sucess then
    return
  end
  self:RefeshRecoredGridCell()
end

function PlayerRefluxView:HandelShareSucess()
  helplog("=====PlayerRefluxView:HandelShareScess()=====")
  if self.refluxData.sharawarded == false then
    proxy:CallUserInviteShareAwardCmd()
  end
end

function PlayerRefluxView:HandelGetShareReward(data)
  redlog("----HandelGetShareReward-----")
  self.refluxData = proxy:GetRefluxData()
  if self.refluxData.sharawarded then
    self.firstShareRoot:SetActive(false)
  else
    self.firstShareRoot:SetActive(true)
  end
end

function PlayerRefluxView:HandleQueryUserInfo(note)
  local data = note.body
  if data then
    if self.playerTipData == nil then
      self.playerTipData = PlayerTipData.new()
    end
    self.playerTipData:SetBySocialData(data.data)
    local _FunctionPlayerTip = FunctionPlayerTip.Me()
    _FunctionPlayerTip:CloseTip()
    local playerTip = _FunctionPlayerTip:GetPlayerTip(self.bg, NGUIUtil.AnchorSide.Center, {-174, 100})
    tipData.playerData = self.playerTipData
    tipData.funckeys = funkey
    playerTip:SetData(tipData)
  end
end

function PlayerRefluxView:ClickPreviewRewardItem(cellctl)
  if cellctl and cellctl ~= self.choosePreview then
    local data = cellctl.data
    local stick = cellctl.bgBtn.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChoosePreview()
      end
      local sdata = {
        itemdata = data.itemData,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Right, {200, 0})
    end
    self.choosePreview = cellctl
  else
    self:CancelChoosePreview()
  end
end

function PlayerRefluxView:CancelChoosePreview()
  self.choosePreview = nil
  self:ShowItemTip()
end

function PlayerRefluxView:ShowTweenLable()
  for k, v in pairs(self.lableTweenInfos) do
    self:StartLabelTween(v.lable, v.maxwidth, v.tweenPosition, 1, 5)
  end
end

function PlayerRefluxView:StartLabelTween(_lable, maxwidth, tweenPostion, _style, _duration)
  local lablewidth = _lable.width
  if tweenPostion == nil then
    tweenPostion = _lable.gameObject:GetComponent(TweenPosition)
    if tweenPostion == nil then
      tweenPostion = _lable.gameObject:AddComponent(TweenPosition)
    end
    tweenPostion.enabled = false
  end
  if maxwidth >= lablewidth then
    tweenPostion.enabled = false
    return
  end
  _lable.pivot = UIWidget.Pivot.Left
  tweenPostion.style = _style or 1
  tweenPostion.duration = _duration or 3
  local posY = _lable.transform.localPosition.y
  tweenPostion.from = LuaGeometry.GetTempVector3(maxwidth / 2, posY, 0)
  local toX = 0 - maxwidth / 2 - lablewidth
  tweenPostion.to = LuaGeometry.GetTempVector3(toX, posY, 0)
  tweenPostion.enabled = true
  tweenPostion:ResetToBeginning()
  tweenPostion:PlayForward()
end

function PlayerRefluxView:OnExit()
  self.lableTweenInfos = {}
  PictureManager.Instance:UnloadPlayerRefluxTexture(bgName, self.bg)
end

function PlayerRefluxView:OnEnter()
  PictureManager.Instance:SetPlayerRefluxTexture(bgName, self.bg)
end
