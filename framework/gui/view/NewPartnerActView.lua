autoImport("NewPartnerActCell")
NewPartnerActView = class("NewPartnerActView", BaseView)
NewPartnerActView.ViewType = UIViewType.NormalLayer
local bgName = "reflux_bg_02"
local proxy
local tempVector3 = LuaVector3.Zero()

function NewPartnerActView:Init()
  proxy = NewPartnerActProxy.Instance
  self:InitView()
  self:AddEvents()
  self:InitData()
end

function NewPartnerActView:InitView()
  self.mask = self:FindGO("mask")
  self.refluxRoot = self:FindGO("Bg")
  self.rootBg = self.refluxRoot:GetComponent("UITexture")
  self.timeLable = self:FindComponent("timeLable", UILabel, self.refluxRoot)
  self.timeLableScrol = self:FindComponent("scrl", UIPanel, self.refluxRoot)
  self.timeLableTweenPosition = self:FindComponent("timeLable", TweenPosition, self.refluxRoot)
  self.timeLableTweenPosition.enabled = false
  local grid = self:FindComponent("recordGrid", UIGrid, self.refluxRoot)
  self.recordGrid = UIGridListCtrl.new(grid, NewPartnerActCell, "PlayerRefluxBackCell")
  self.recordGrid:AddEventListener(MouseEvent.MouseClick, self.ClickPreviewRewardItem, self)
  self.closeButton = self:FindGO("closeButton", self.refluxRoot)
  self.friendButton = self:FindGO("friendButton", self.refluxRoot)
  self.invitationButton = self:FindGO("invitationButton", self.refluxRoot)
  self.tipButton = self:FindGO("TipButton", self.refluxRoot)
  self.invitationButtonSp = self:FindComponent("invitationButton", UISprite, self.refluxRoot)
  self.invitationButtonLable = self:FindComponent("Label", UILabel, self.invitationButton)
  self:RegisterRedTipCheck(PlayerRefluxProxy.RedInvite, self.friendButton, 15)
end

function NewPartnerActView:AddEvents()
  self:AddClickEvent(self.closeButton, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.friendButton, function()
    local recommendActCfg = GameConfig.RecommendAct
    local recommendActCfgID
    if recommendActCfg then
      for k, v in pairs(recommendActCfg) do
        local isOpen = ReturnActivityProxy.Instance:IsRecommendActOpen(k)
        if isOpen then
          recommendActCfgID = k
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
            view = PanelConfig.OldPlayerOverSeaPanel,
            viewdata = {recommendActid = recommendActCfgID}
          })
        end
      end
    end
  end)
  self:AddClickEvent(self.invitationButton, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.InviteCodePopOverSeaView,
      viewdata = {
        BindReward = self.configData.SpecialAward[10000]
      }
    })
  end)
  self:RegistShowGeneralHelpByHelpID(35088, self.tipButton)
  self:AddListenEvt(ServiceEvent.ActivityCmdNewPartnerCmd, self.HandleRefeshLoginRewardCell)
  self:AddListenEvt(ServiceEvent.ActivityCmdUserInviteBindUserCmd, self.HandleRefeshButton)
end

function NewPartnerActView:InitData()
  self.configData = proxy:GetConfigMap()
  local signRewadrData = self.configData.TargetAward
  if signRewadrData then
    self.recordGrid:ResetDatas(signRewadrData)
    self:RefeshLoginCell()
  else
    redlog("ReturnInvitation has no index = ", configIndex)
  end
  self.isRecellEndtime = proxy:IsRecellTimeEnd()
  self:RefeshTimeLable()
  self:StartTweenLable()
end

function NewPartnerActView:RefeshTimeLable()
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

function NewPartnerActView:RefeshLoginCell()
  local childCells = self.recordGrid:GetCells()
  for i = 1, #childCells do
    childCells[i]:RefeshCell(proxy:GetLoginawarddid())
  end
end

function NewPartnerActView:HandleRefeshLoginRewardCell(data)
  helplog("-------HandleRefeshLoginRewardCell-------")
  self:RefeshLoginCell()
end

function NewPartnerActView:HandleRefeshButton(data)
  helplog("-------HandleRefeshButton-------")
  if data and data.body and data.body.sucess then
    self:UpdateButton()
  end
end

function NewPartnerActView:UpdateButton()
end

function NewPartnerActView:ClickPreviewRewardItem(cellctl)
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

function NewPartnerActView:CancelChoosePreview()
  self.choosePreview = nil
  self:ShowItemTip()
end

function NewPartnerActView:StartTweenLable()
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

function NewPartnerActView:OnExit()
  PictureManager.Instance:UnloadPlayerRefluxTexture(bgName, self.rootBg)
end

function NewPartnerActView:OnEnter()
  PictureManager.Instance:SetPlayerRefluxTexture(bgName, self.rootBg)
end
