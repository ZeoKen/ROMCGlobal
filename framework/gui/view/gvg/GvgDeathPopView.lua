autoImport("UIToggleGroup")
GvgDeathPopView = class("GvgDeathPopView", ContainerView)
GvgDeathPopView.ViewType = UIViewType.ReviveLayer
local TextureBg = "persona_bg_npc"

function GvgDeathPopView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:UpdateView()
  self:StartCountDown()
end

function GvgDeathPopView:OnEnter()
  GvgDeathPopView.super.OnEnter(self)
end

function GvgDeathPopView:OnExit()
  GvgDeathPopView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(TextureBg, self.bgTexture)
  self:StopCountDown()
end

function GvgDeathPopView:FindObjs()
  self.bgTexture = self:FindComponent("Texture", UITexture)
  PictureManager.Instance:SetUI(TextureBg, self.bgTexture)
  self.defeatLab = self:FindComponent("DefeatLab", UILabel)
  self.defeatLab.skipTranslation = true
  self.exitBtnGO = self:FindGO("ExitBtn")
  self:AddClickEvent(self.exitBtnGO, function()
    self:OnReviveClicked()
  end)
  self.countdownLab = self:FindComponent("CountDown", UILabel)
  self.toggleGroupGO = self:FindGO("ToggleGroup")
  local toggleNames = {
    "ToggleStrongHold",
    "ToggleSafeArea"
  }
  self.toggleGroup = UIToggleGroup.new(self.toggleGroupGO, toggleNames, 1, 1414)
  for _, toggle in ipairs(self.toggleGroup.toggles) do
    self:AddClickEvent(toggle.toggle.gameObject, function()
      self:OnToggleClicked()
    end)
  end
  self.safeAreaLab = self:FindComponent("SafeAreaLab", UILabel)
  self.safeAreaLab.text = ZhString.DeathPopView_SafeArea
end

function GvgDeathPopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.ReliveStatus, self.HandleReliveStatus)
  self:AddListenEvt(MyselfEvent.KillNameChange, self.UpdateDeathHint)
end

function GvgDeathPopView:UpdateView()
  self:UpdateByPoint()
  self:UpdateDeathHint()
  self:UpdateCountDown()
end

function GvgDeathPopView:UpdateByPoint()
  if GvgProxy.Instance:IHaveGuildPoint() then
    self:Hide(self.safeAreaLab)
    self:Show(self.toggleGroupGO)
  else
    self:Show(self.safeAreaLab)
    self:Hide(self.toggleGroupGO)
  end
end

function GvgDeathPopView:StartCountDown()
  self.countDownEndTime = GvgProxy.Instance:GetExpelTime() + ServerTime.CurServerTime() / 1000
  if not self.countdownTimer then
    self.countdownTimer = TimeTickManager.Me():CreateTick(0, 1000, function()
      self:UpdateCountDown()
    end, self)
  end
end

function GvgDeathPopView:StopCountDown()
  if self.countdownTimer then
    self.countdownTimer:Destroy()
    self.countdownTimer = nil
  end
end

function GvgDeathPopView:UpdateCountDown()
  local timeLeft = self.countDownEndTime and math.floor(self.countDownEndTime - ServerTime.CurServerTime() / 1000) or 0
  if timeLeft < 0 then
    timeLeft = 0
  end
  self.countdownLab.text = string.format(ZhString.DeathPopView_GVGCountDown, timeLeft)
end

function GvgDeathPopView:OnToggleClicked()
  local selectedIndex = self.toggleGroup:GetSelectedToggleIndex()
  local currentReviveMethod = GvgProxy.Instance:GetReviveMethod()
  if selectedIndex ~= currentReviveMethod then
    ServiceUserEventProxy.Instance:CallSetReliveMethodUserEvent(selectedIndex)
  end
end

function GvgDeathPopView:OnReviveClicked()
  MsgManager.ConfirmMsgByID(105, function()
    ServiceNUserProxy.Instance:CallRelive(SceneUser2_pb.ERELIVETYPE_RETURNSAVE)
  end)
end

function GvgDeathPopView:HandleReliveStatus(note)
  self:CloseSelf()
end

function GvgDeathPopView:UpdateDeathHint()
  local userData = Game.Myself.data.userdata
  local defeat = userData:GetBytes(UDEnum.KILLERNAME) or ""
  self.defeatLab.text = string.format(ZhString.DeathPopView_TitleHintGVG, defeat)
end
