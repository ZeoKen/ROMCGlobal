autoImport("PlayerRefluxBackCell")
PlayerRefluxBackView = class("PlayerRefluxBackView", BaseView)
PlayerRefluxBackView.ViewType = UIViewType.NormalLayer
local bgName = "reflux_bg_02"
local proxy
local tempVector3 = LuaVector3.Zero()

function PlayerRefluxBackView:Init()
  proxy = PlayerRefluxProxy.Instance
  self:InitView()
  self:AddEvents()
  self:InitData()
end

function PlayerRefluxBackView:InitView()
  self.mask = self:FindGO("mask")
  self.refluxRoot = self:FindGO("Bg")
  self.rootBg = self.refluxRoot:GetComponent("UITexture")
  self.timeLable = self:FindComponent("timeLable", UILabel, self.refluxRoot)
  self.timeLableScrol = self:FindComponent("scrl", UIPanel, self.refluxRoot)
  self.timeLableTweenPosition = self:FindComponent("timeLable", TweenPosition, self.refluxRoot)
  self.timeLableTweenPosition.enabled = false
  local grid = self:FindComponent("recordGrid", UIGrid, self.refluxRoot)
  self.recordGrid = UIGridListCtrl.new(grid, PlayerRefluxBackCell, "PlayerRefluxBackCell")
  self.recordGrid:AddEventListener(MouseEvent.MouseClick, self.ClickPreviewRewardItem, self)
  self.closeButton = self:FindGO("closeButton", self.refluxRoot)
  self.friendButton = self:FindGO("friendButton", self.refluxRoot)
  self.invitationButton = self:FindGO("invitationButton", self.refluxRoot)
  self.tipButton = self:FindGO("TipButton", self.refluxRoot)
  self:RegistShowGeneralHelpByHelpID(35088, self.tipButton)
  self.invitationButtonSp = self:FindComponent("invitationButton", UISprite, self.refluxRoot)
  self.invitationButtonLable = self:FindComponent("Label", UILabel, self.invitationButton)
  self:RegisterRedTipCheck(PlayerRefluxProxy.RedInvite, self.friendButton, 15)
end

function PlayerRefluxBackView:AddEvents()
  self:AddClickEvent(self.closeButton, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.friendButton, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PlayerRefluxView
    })
  end)
  self:AddClickEvent(self.invitationButton, function()
    if self.refluxData and self.refluxData.binduser then
      return
    end
    if self.isRecellEndtime then
      MsgManager.ShowMsgByIDTable(40973)
      return
    end
    local viewData = {
      viewname = "PlayerRefluxPopView",
      data = {
        configData = self.configData,
        inviteCode = true
      }
    }
    self:sendNotification(UIEvent.ShowUI, viewData)
  end)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteRecallLoginAwardCmd, self.HandleRefeshLoginRewardCell)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteBindUserCmd, self.HandleRefeshButton)
  self:AddListenEvt(PlayerRefluxEvent.RefluxBackLoginReward, self.ReceiveAllReward)
end

function PlayerRefluxBackView:InitData()
  self.configData = proxy:GetConfigMap()
  local signRewadrData = self.configData.ReturnSigninReward
  if signRewadrData then
    self.recordGrid:ResetDatas(signRewadrData)
    self:RefeshLoginCell()
  else
    redlog("ReturnInvitation has no index = ", configIndex)
  end
  self.isRecellEndtime = proxy:IsRecellTimeEnd()
  self.refluxData = proxy:GetRefluxData()
  self:RefeshTimeLable()
  self:StartTweenLable()
end

function PlayerRefluxBackView:RefeshTimeLable()
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
  self:UpdateButton()
end

function PlayerRefluxBackView:ReceiveAllReward()
  redlog("======= PlayerRefluxBackView:ReceiveAllReward()=======")
  local childCells = self.recordGrid:GetCells()
  local reward = {}
  for i = 1, #childCells do
    if childCells[i].canReceive then
      table.insert(reward, childCells[i].indexInList)
    end
  end
  if 0 < #reward then
    PlayerRefluxProxy.Instance:CallUserInviteRecallLoginAwardCmd(reward)
  end
end

function PlayerRefluxBackView:RefeshLoginCell()
  local childCells = self.recordGrid:GetCells()
  for i = 1, #childCells do
    childCells[i]:RefeshCell(proxy:GetRecalllogindays(), proxy:GetLoginawarddid())
  end
end

function PlayerRefluxBackView:HandleRefeshLoginRewardCell(data)
  helplog("-------HandleRefeshLoginRewardCell-------")
  if data and data.body and data.body.id then
    self:RefeshLoginCell()
  end
end

function PlayerRefluxBackView:HandleRefeshButton(data)
  helplog("-------HandleRefeshButton-------")
  if data and data.body and data.body.sucess then
    self.refluxData = proxy:GetRefluxData()
    self:UpdateButton()
  end
end

function PlayerRefluxBackView:UpdateButton()
  if self.refluxData then
    if self.refluxData.binduser then
      self.invitationButtonLable.text = ZhString.PlayerRefluxView_BindUser
    else
      self.invitationButtonLable.text = ZhString.PlayerRefluxView_RefluxBackBtn
    end
  end
end

function PlayerRefluxBackView:ClickPreviewRewardItem(cellctl)
  if cellctl and cellctl ~= self.choosePreview then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
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

function PlayerRefluxBackView:CancelChoosePreview()
  self.choosePreview = nil
  self:ShowItemTip()
end

function PlayerRefluxBackView:StartTweenLable()
  local scrolWidth = self.timeLableScrol.width
  if scrolWidth >= self.timeLable.width then
    return
  end
  local tempText = self.timeLable.text
  self.timeLable.pivot = UIWidget.Pivot.Left
  tempVector3[1] = scrolWidth / 2
  self.timeLableTweenPosition.from = tempVector3
  local toX = 0 - scrolWidth / 2 - self.timeLable.width
  tempVector3[1] = toX
  self.timeLableTweenPosition.to = tempVector3
  self.timeLableTweenPosition.duration = 8
  self.timeLableTweenPosition.style = 1
  self.timeLableTweenPosition.enabled = true
  self.timeLableTweenPosition:ResetToBeginning()
  self.timeLableTweenPosition:PlayForward()
end

function PlayerRefluxBackView:OnExit()
  PictureManager.Instance:UnloadPlayerRefluxTexture(bgName, self.rootBg)
end

function PlayerRefluxBackView:OnEnter()
  PictureManager.Instance:SetPlayerRefluxTexture(bgName, self.rootBg)
end
