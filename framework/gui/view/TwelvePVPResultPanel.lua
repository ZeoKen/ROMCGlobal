autoImport("ResultInfoCell")
TwelvePVPResultPanel = class("TwelvePVPResultPanel", BaseView)
TwelvePVPResultPanel.ViewType = UIViewType.NormalLayer
local InfoList = {}
local WinBG = "pvp_bg_decorative"
local WinEffectMap = {
  [1] = {
    top = EffectMap.UI.ufx_12v12_up_blue,
    side = EffectMap.UI.ufx_12v12_right
  },
  [2] = {
    top = EffectMap.UI.ufx_12v12_up_red,
    side = EffectMap.UI.ufx_12v12_left
  }
}
local CloseTime = GameConfig.TwelvePvp.CloseTime or 30
local lefttime = 0
local isFinal, camp
local IsFinalResult = function()
  local _proxy = TwelvePvPProxy.Instance
  return _proxy:CheckFinalResult()
end

function TwelvePVPResultPanel:Init()
  self:FindObjects()
  self:AddListEventListener()
end

function TwelvePVPResultPanel:OnEnter()
  TipManager.Instance:CloseItemTip()
  self:ShowUI()
end

function TwelvePVPResultPanel:FindObjects()
  self.detailBtn = self:FindGO("DetailButton")
  self:AddClickEvent(self.detailBtn, function(go)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TwelvePVP_PersonalInfoPopUp
    })
  end)
  self.exitBtn = self:FindGO("ExitButton")
  self:AddClickEvent(self.exitBtn, function(go)
    self:CloseUI()
  end)
  local detailBtnTA = self.detailBtn:GetComponent(TweenAlpha)
  self:AddTweens(detailBtnTA)
  local detailLTA = self:FindGO("Label", self.detailBtn):GetComponent(TweenAlpha)
  self:AddTweens(detailLTA)
  local exitBtnTA = self.exitBtn:GetComponent(TweenAlpha)
  self:AddTweens(detailLTA)
  self.dec = self:FindGO("dec"):GetComponent(UITexture)
  PictureManager.Instance:SetPVP(WinBG, self.dec)
  local decTA = self.dec.gameObject:GetComponent(TweenAlpha)
  self:AddTweens(decTA)
  local leftGO = self:FindGO("Left")
  local leftBGTH = self:FindGO("leftBG", leftGO):GetComponent(TweenHeight)
  self:AddTweens(leftBGTH)
  local leftLineTTA = self:FindGO("linespT", leftGO):GetComponent(TweenAlpha)
  self:AddTweens(leftLineTTA)
  local leftlineTTP = self:FindGO("linespT", leftGO):GetComponent(TweenPosition)
  self:AddTweens(leftlineTTP)
  local leftLineBTA = self:FindGO("linespB", leftGO):GetComponent(TweenAlpha)
  self:AddTweens(leftLineBTA)
  local rightGO = self:FindGO("Right")
  local rightBGTH = self:FindGO("rightBG", rightGO):GetComponent(TweenHeight)
  self:AddTweens(rightBGTH)
  local rightLineTTA = self:FindGO("linespT", rightGO):GetComponent(TweenAlpha)
  self:AddTweens(rightLineTTA)
  local rightLineTTP = self:FindGO("linespT", rightGO):GetComponent(TweenPosition)
  self:AddTweens(rightLineTTP)
  local rightLineBTA = self:FindGO("linespB", rightGO):GetComponent(TweenAlpha)
  self:AddTweens(rightLineBTA)
  self.leftResult = self:FindGO("leftResultInfo")
  self.leftResultInfoCell = ResultInfoCell.new(self.leftResult)
  self.leftResult:SetActive(false)
  self.rightResult = self:FindGO("rightResultInfo")
  self.rightResultInfoCell = ResultInfoCell.new(self.rightResult)
  self.rightResult:SetActive(false)
  self.topEffectContainer = self:FindGO("TopEffect")
  self.topEffectTA = self.topEffectContainer:GetComponent(TweenPosition)
  self:AddTweens(self.topEffectTA)
  self.midEffectContainer = self:FindGO("MidEffect")
  self.topEffectTA:SetOnFinished(function()
    self:ShowResult()
  end)
  self.leftEffContainer = self:FindGO("leftEffContainer")
  self.rightEffContainer = self:FindGO("rightEffContainer")
  self:PlayTweens(true)
  self.exitLabel = self:FindGO("exitLabel"):GetComponent(UILabel)
  local gridTP = self:FindGO("Grid"):GetComponent(TweenPosition)
  self:AddTweens(gridTP)
end

function TwelvePVPResultPanel:AddTweens(tween)
  if not tween then
    return
  end
  if not self.tweens then
    self.tweens = {}
  end
  self.tweens[#self.tweens + 1] = tween
end

function TwelvePVPResultPanel:PlayTweens(isInit)
  if not self.tweens then
    return
  end
  if not isInit then
    for i = 1, #self.tweens do
      self.tweens[i]:PlayForward()
    end
  else
    for i = 1, #self.tweens do
      self.tweens[i]:PlayReverse()
    end
  end
end

function TwelvePVPResultPanel:ClearTweens()
  if self.tweens then
    for i = 1, #self.tweens do
      self.tweens[i] = nil
    end
  end
end

function TwelvePVPResultPanel:ShowUI()
  local isFinal, winCamp = IsFinalResult()
  local effectConfig = WinEffectMap[winCamp]
  if effectConfig then
    self:PlayUIEffect(effectConfig.top, self.topEffectContainer, false, function()
      self:PlayTweens()
    end)
  end
end

function TwelvePVPResultPanel:ShowResult()
  local isFinal, winCamp = IsFinalResult()
  local effectConfig = WinEffectMap[winCamp]
  if effectConfig then
    if winCamp == 1 then
      self:PlayUIEffect(effectConfig.side, self.rightEffContainer)
    elseif winCamp == 2 then
      self:PlayUIEffect(effectConfig.side, self.leftEffContainer)
    end
  end
  local resultdata = TwelvePvPProxy.Instance:GetCampResult(1)
  if resultdata then
    self.rightResultInfoCell:SetData(resultdata)
    self.rightResult:SetActive(true)
  end
  resultdata = TwelvePvPProxy.Instance:GetCampResult(2)
  if resultdata then
    self.leftResultInfoCell:SetData(resultdata)
    self.leftResult:SetActive(true)
  end
  if not self.timetick then
    self.exitLabel.text = string.format(ZhString.TwelvePVP_Exit, CloseTime)
    self.endTime = ServerTime.CurServerTime() / 1000 + CloseTime
    self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, 11)
  end
end

function TwelvePVPResultPanel:UpdateCountDown()
  lefttime = self.endTime - ServerTime.CurServerTime() / 1000
  if 0 < lefttime then
    self.exitLabel.text = string.format(ZhString.TwelvePVP_Exit, lefttime)
  else
    self:ClearTick()
    self:CloseUI()
  end
end

function TwelvePVPResultPanel:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 11)
    self.timeTick = nil
  end
end

function TwelvePVPResultPanel:AddListEventListener()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.CloseSelf)
end

function TwelvePVPResultPanel:CloseUI()
  ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
  self:CloseSelf()
end

function TwelvePVPResultPanel:OnExit()
  PictureManager.Instance:UnLoadPVP(WinBG, self.dec)
  self:ClearTweens()
  self:ClearTick()
  TwelvePVPResultPanel.super.OnExit(self)
end
