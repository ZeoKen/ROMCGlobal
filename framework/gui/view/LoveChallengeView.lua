LoveChallengeView = class("LoveChallengeView", ContainerView)
LoveChallengeView.ViewType = UIViewType.NormalLayer
local textureNameMap = {
  begin_bg = "lovechallenge_begin_bg",
  begin_bg2 = "lovechallenge_begin_bg2",
  over_bg = "lovechallenge_over_bg",
  over_txt_bg = "lovechallenge_over_txt_bg"
}
local lovechallengeChooseSpriteMap = {
  [1] = {
    iconName = "love_icon_quantou"
  },
  [2] = {
    iconName = "love_icon_jiandao"
  },
  [3] = {
    iconName = "love_icon_bu"
  },
  [4] = {
    iconName = "love_icon_renshu"
  }
}
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()

function LoveChallengeView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function LoveChallengeView:FindObjs()
  self.receivePage = self:FindGO("ReceivePage")
  self.beginTitle = self:FindGO("Title", self.receivePage):GetComponent(UILabel)
  self.begin_HelpBtn = self:FindGO("HelpBtn", self.receivePage)
  self.begin_ToName = self:FindGO("ToName", self.receivePage):GetComponent(UILabel)
  self.begin_ToDo = self:FindGO("ToDo", self.receivePage):GetComponent(UILabel)
  self.begin_Penalty = self:FindGO("Penalty", self.receivePage):GetComponent(UILabel)
  self.begin_ConfirmBtn = self:FindGO("ConfirmBtn", self.receivePage)
  self.begin_RefuseBtn = self:FindGO("RefuseBtn", self.receivePage)
  self.beginTitle.text = ZhString.LoveChallenge_Title
  self.begin_ToDo.text = ZhString.LoveChallenge_ChallengeToDo
  self.begin_Penalty.text = ZhString.LoveChallenge_Penalty
  self.begin_CountdownLabel = self:FindGO("CountdownLabel", self.receivePage):GetComponent(UILabel)
  local begin_Tips = self:FindGO("TipLabel", self.receivePage):GetComponent(UILabel)
  begin_Tips.text = ZhString.LoveChallenge_CatIsWatchingU
  self.choosePage = self:FindGO("ChoosePage")
  self.choose_Title = self:FindGO("Title", self.choosePage):GetComponent(UILabel)
  self.choose_ToName = self:FindGO("ToName", self.choosePage):GetComponent(UILabel)
  self.choose_ToNameStr1 = self:FindGO("ToStr1", self.choosePage):GetComponent(UILabel)
  self.choose_ToNameStr2 = self:FindGO("ToStr2", self.choosePage):GetComponent(UILabel)
  self.choose_ToDo = self:FindGO("ToDo", self.choosePage):GetComponent(UILabel)
  self.choose_Penalty = self:FindGO("Penalty", self.choosePage):GetComponent(UILabel)
  self.choose_HelpBtn = self:FindGO("HelpBtn", self.choosePage)
  self.choose_ConfirmBtn = self:FindGO("ConfirmBtn", self.choosePage)
  self.choose_CountdownLabel = self:FindGO("CountdownLabel", self.choosePage):GetComponent(UILabel)
  self.choose_Title.text = ZhString.LoveChallenge_Title
  self.choose_ToDo.text = ZhString.LoveChallenge_FailToDo
  self.choose_Penalty.text = ZhString.LoveChallenge_Penalty
  local choose_Tips = self:FindGO("TipLabel", self.choosePage):GetComponent(UILabel)
  choose_Tips.text = ZhString.LoveChallenge_CatIsWatchingU
  self.choose_Y = self:FindGO("Y", self.choosePage)
  local y_Icon = self:FindGO("Icon", self.choose_Y):GetComponent(UISprite)
  local y_ActionLabel = self:FindGO("ActionLabel", self.choose_Y):GetComponent(UILabel)
  y_ActionLabel.text = ZhString.LoveChallenge_Scissors
  self.choose_O = self:FindGO("O", self.choosePage)
  local o_Icon = self:FindGO("Icon", self.choose_O):GetComponent(UISprite)
  local o_ActionLabel = self:FindGO("ActionLabel", self.choose_O):GetComponent(UILabel)
  o_ActionLabel.text = ZhString.LoveChallenge_Rock
  self.choose_Five = self:FindGO("Five", self.choosePage)
  local five_Icon = self:FindGO("Icon", self.choose_Five):GetComponent(UISprite)
  local five_ActionLabel = self:FindGO("ActionLabel", self.choose_Five):GetComponent(UILabel)
  five_ActionLabel.text = ZhString.LoveChallenge_Paper
  self.choose_Concede = self:FindGO("Concede", self.choosePage)
  local concade_Icon = self:FindGO("Icon", self.choose_Concede):GetComponent(UISprite)
  local concade_ActionLabel = self:FindGO("ActionLabel", self.choose_Concede):GetComponent(UILabel)
  concade_ActionLabel.text = ZhString.LoveChallenge_Concede
  self.chooseIcon = {
    o_Icon,
    y_Icon,
    five_Icon,
    concade_Icon
  }
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:PlayUIEffect(EffectMap.UI.Lovechallenge_Choose, self.chooseSymbol)
  self.resultPage = self:FindGO("ResultPage")
  self.loseMark = self:FindGO("LoseMark", self.resultPage)
  self.loseMark_TweenRot = self.loseMark:GetComponent(TweenRotation)
  self.result_Tips = self:FindGO("TipsLabel", self.resultPage):GetComponent(UILabel)
  self.result_ConfirmBtn = self:FindGO("ConfirmBtn", self.resultPage)
  local winnerPart = self:FindGO("WinnerPart", self.resultPage)
  self.winner_Icon = self:FindGO("Icon", winnerPart):GetComponent(UISprite)
  self.winner_Name = self:FindGO("WinnerName", winnerPart):GetComponent(UILabel)
  self.winner_effectHandler = self:FindGO("WinnerEffectHandler", winnerPart)
  self.result_Tips.text = ZhString.LoveChallenge_WaitResult
  local loserPart = self:FindGO("LoserPart")
  self.loser_Icon = self:FindGO("Icon", loserPart):GetComponent(UISprite)
  self.loser_Name = self:FindGO("LoserName", loserPart):GetComponent(UILabel)
  for objName, _ in pairs(textureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.boli1 = self:FindGO("Boli1")
  self.boli1_tweenScale = self.boli1:GetComponent(TweenScale)
  self.boli1_tweenPos = self.boli1:GetComponent(TweenPosition)
  self.boli2 = self:FindGO("Boli2")
  self.boli2_tweenPos = self.boli2:GetComponent(TweenPosition)
  self.boli2_effectHandler = self:FindGO("boliEffectContainer", self.boli2)
  self:PlayUIEffect(EffectMap.UI.Lovechallenge_BoliHeart, self.boli2_effectHandler)
  self:PlayUIEffect(EffectMap.UI.LoveChallenge_BoliBody, self.boli2_effectHandler)
  self.receivePage_TweenPos = self.receivePage:GetComponent(TweenPosition)
  self.receivePage_TweenScale = self.receivePage:GetComponent(TweenScale)
  self.choosePage_TweenScale = self.choosePage:GetComponent(TweenScale)
  self.resultPage_TweenScale = self.resultPage:GetComponent(TweenScale)
end

function LoveChallengeView:AddViewEvts()
  self:AddClickEvent(self.begin_ConfirmBtn, function()
    self.boli1_tweenPos.from = LuaGeometry.GetTempVector3(-278, 222, 0)
    self.boli1_tweenPos.to = LuaGeometry.GetTempVector3(755, 676, 0)
    self.boli1_tweenPos:ResetToBeginning()
    self.boli1_tweenPos:PlayForward()
    self.receivePage_TweenScale:ResetToBeginning()
    self.receivePage_TweenScale:PlayForward()
    TimeTickManager.Me():ClearTick(self, 1)
    ServiceMessCCmdProxy.Instance:CallInviteeProcessLoveConfessionMessCCmd(true, self.inviterID)
    TimeTickManager.Me():CreateOnceDelayTick(200, function(owner, deltaTime)
      self.boli1:SetActive(false)
      self.pageIndex = 2
      self:RefreshPage()
    end, self, 6)
  end)
  self:AddClickEvent(self.begin_RefuseBtn, function()
    ServiceMessCCmdProxy.Instance:CallInviteeProcessLoveConfessionMessCCmd(false, self.inviterID)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.choose_Y, function()
    self.chooseSymbol.transform:SetParent(self.choose_Y.transform)
    self.chooseSymbol.transform.localPosition = LuaGeometry.Const_V3_zero
    self.chooseIndex = 2
    self:SetChoose(2)
  end)
  self:AddClickEvent(self.choose_O, function()
    self.chooseSymbol.transform:SetParent(self.choose_O.transform)
    self.chooseSymbol.transform.localPosition = LuaGeometry.Const_V3_zero
    self.chooseIndex = 1
    self:SetChoose(1)
  end)
  self:AddClickEvent(self.choose_Five, function()
    self.chooseSymbol.transform:SetParent(self.choose_Five.transform)
    self.chooseSymbol.transform.localPosition = LuaGeometry.Const_V3_zero
    self.chooseIndex = 3
    self:SetChoose(3)
  end)
  self:AddClickEvent(self.choose_Concede, function()
    self.chooseSymbol.transform:SetParent(self.choose_Concede.transform)
    self.chooseSymbol.transform.localPosition = LuaGeometry.Const_V3_zero
    self.chooseIndex = 4
    self:SetChoose(4)
  end)
  self:AddClickEvent(self.choose_ConfirmBtn, function()
    xdlog("出拳！", self.chooseIndex, self.inviterID)
    self.chooseFinish = true
    MiniGameProxy.Instance:SetMyChoose(self.chooseIndex)
    ServiceMessCCmdProxy.Instance:CallFingerGuessLoveConfessionMessCCmd(self.chooseIndex, self.inviterID)
    self.pageIndex = 3
    self:RefreshPage()
    self.resultPage_TweenScale:ResetToBeginning()
    self.resultPage_TweenScale:PlayForward()
  end)
  self:AddClickEvent(self.result_ConfirmBtn, function()
    xdlog("告白")
    self:DoConfession()
    self:CloseSelf()
  end)
  self:RegistShowGeneralHelpByHelpID(35271, self.begin_HelpBtn)
  self:RegistShowGeneralHelpByHelpID(35271, self.choose_HelpBtn)
end

function LoveChallengeView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.MessCCmdFingerLoseLoveConfessionMessCCmd, self.handleResult, self)
end

function LoveChallengeView:InitDatas()
  local viewdata = self.viewdata.viewdata
  self.pageIndex = viewdata and viewdata.page or 2
  self.inviterID = viewdata and viewdata.inviterID or Game.Myself.data.id
  self.inviterName = viewdata and viewdata.inviterName
  self.chooseIndex = 1
end

function LoveChallengeView:InitShow()
  self:RefreshPage()
end

function LoveChallengeView:TweenPage(index)
end

function LoveChallengeView:RefreshPage()
  if self.pageIndex == 1 then
    self.receivePage:SetActive(true)
    self.choosePage:SetActive(false)
    self.resultPage:SetActive(false)
    self:SetBeginPage()
  elseif self.pageIndex == 2 then
    self.receivePage:SetActive(false)
    self.choosePage:SetActive(true)
    self.resultPage:SetActive(false)
    self:ShowChoosePage()
  elseif self.pageIndex == 3 then
    self.receivePage:SetActive(false)
    self.choosePage:SetActive(false)
    self.resultPage:SetActive(true)
    self:WaitResult()
  end
end

function LoveChallengeView:SetBeginPage()
  xdlog("接收页")
  local oppoID, oppoName = MiniGameProxy.Instance:GetOppoInfo()
  self.begin_ToName.text = oppoName
  self.beginEndTime = MiniGameProxy.Instance:GetInviteEndStamp()
  if not self.beginEndTime then
    redlog("没有起始时间")
    return
  end
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 1000, self.updateBeginCountdown, self, 1)
  self.boli1:SetActive(true)
  self.boli1_tweenPos.from = LuaGeometry.GetTempVector3(-678, 542, 0)
  self.boli1_tweenPos.to = LuaGeometry.GetTempVector3(-278, 222, 0)
  self.boli1_tweenPos:ResetToBeginning()
  self.boli1_tweenPos:PlayForward()
  self.boli2:SetActive(false)
  self.receivePage_TweenPos:ResetToBeginning()
  self.receivePage_TweenPos:PlayForward()
end

function LoveChallengeView:updateBeginCountdown()
  local timeLeft = self.beginEndTime - ServerTime.CurServerTime() / 1000
  if timeLeft < 0 then
    TimeTickManager.Me():ClearTick(self, 1)
    xdlog("倒计时结束  自动关闭结束")
    self:CloseSelf()
  else
    self.begin_CountdownLabel.text = string.format(ZhString.LoveChallenge_Countdown, math.floor(timeLeft))
  end
end

function LoveChallengeView:ShowChoosePage()
  xdlog("ShowChoosePage")
  self.chooseFinish = false
  local oppoID, oppoName = MiniGameProxy.Instance:GetOppoInfo()
  self.choose_ToName.text = oppoName
  if self.inviterID == Game.Myself.data.id then
    self.choose_ToNameStr1.text = ZhString.LoveChallenge_OppoRecvStr1
    self.choose_ToNameStr2.text = ZhString.LoveChallenge_OppoRecvStr2
  else
    self.choose_ToNameStr1.text = ZhString.LoveChallenge_RecvChallengeStr1
    self.choose_ToNameStr2.text = ZhString.LoveChallenge_RecvChallengeStr2
  end
  local width1 = self.choose_ToNameStr1.printedSize.x
  local width2 = self.choose_ToNameStr2.printedSize.x
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.choose_ToName.transform))
  tempVector3[1] = (width1 - width2) / 2
  self.chooseTimeLeft = 60
  TimeTickManager.Me():ClearTick(self, 2)
  TimeTickManager.Me():CreateTick(0, 1000, self.updateChooseCountdown, self, 2)
  self.choosePage_TweenScale:ResetToBeginning()
  self.choosePage_TweenScale:PlayForward()
  self.boli2:SetActive(true)
  self.boli2_tweenPos:ResetToBeginning()
  self.boli2_tweenPos:PlayForward()
end

function LoveChallengeView:updateChooseCountdown()
  self.chooseTimeLeft = self.chooseTimeLeft - 1
  if self.chooseTimeLeft < 0 then
    self.chooseFinish = true
    TimeTickManager.Me():ClearTick(self, 2)
    xdlog("倒计时结束  自动认输")
    ServiceMessCCmdProxy.Instance:CallFingerGuessLoveConfessionMessCCmd(4, self.inviterID)
    self:CloseSelf()
  else
    self.choose_CountdownLabel.text = string.format(ZhString.LoveChallenge_Countdown, self.chooseTimeLeft)
  end
end

function LoveChallengeView:WaitResult()
  self.startSwitchIcon = 1
  self.result_ConfirmBtn:SetActive(false)
  self.loser_Icon.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(63, -2, 0)
  TimeTickManager.Me():CreateTick(0, 100, function()
    self:SwitchResultIcon()
  end, self, 5)
end

function LoveChallengeView:SwitchResultIcon()
  self.startSwitchIcon = self.startSwitchIcon + 1
  if self.startSwitchIcon > 3 then
    self.startSwitchIcon = 1
  end
  local leftSwitch = self.startSwitchIcon + 1 <= 3 and self.startSwitchIcon + 1 or 1
  local rightSwitch = self.startSwitchIcon <= 3 and self.startSwitchIcon or 1
  self.winner_Icon.spriteName = lovechallengeChooseSpriteMap[leftSwitch].iconName
  self.winner_Icon:MakePixelPerfect()
  self.winner_Icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.loser_Icon.spriteName = lovechallengeChooseSpriteMap[rightSwitch].iconName
  self.loser_Icon:MakePixelPerfect()
  self.loser_Icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
end

function LoveChallengeView:handleResult(note)
  self.pageIndex = 3
  self:RefreshPage()
  local data = note.body
  local winner = data.winner
  if winner and winner == Game.Myself.data.id then
    self.confessionFinish = true
    self:CloseSelf()
    return
  end
  TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    self:PlayResult(data)
  end, self, 4)
end

function LoveChallengeView:PlayResult(data)
  TimeTickManager.Me():ClearTick(self, 5)
  self.result_ConfirmBtn:SetActive(true)
  local winnerFinger = data.winnerfinger
  local loserFinger = data.loserfinger
  local winner = data.winner
  local oppoID, oppoName = MiniGameProxy.Instance:GetOppoInfo()
  self.winner_Name.text = oppoName
  self.loser_Name.text = Game.Myself.data:GetName()
  self.winner_Icon.spriteName = lovechallengeChooseSpriteMap[winnerFinger].iconName
  self.loser_Icon.spriteName = lovechallengeChooseSpriteMap[loserFinger].iconName
  self.winner_Icon:MakePixelPerfect()
  self.winner_Icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.loser_Icon:MakePixelPerfect()
  self.loser_Icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 1)
  self.loser_Icon.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(41, 15, 0)
  self.loseMark:SetActive(true)
  self.loseMark_TweenRot:ResetToBeginning()
  self.loseMark_TweenRot:PlayForward()
  self:PlayUIEffect(EffectMap.UI.Lovechallenge_Winner, self.winner_effectHandler)
  self.result_Tips.text = ZhString.LoveChallenge_LoseTip
  self.confessionFinish = false
  xdlog("结果", winnerfinger, loserfinger)
  self.boli2:SetActive(true)
  self:PlayUISound(AudioMap.UI.LoveLetterResult)
end

function LoveChallengeView:SetChoose(index)
  for i = 1, 4 do
    if i == index then
      local targetScale = LuaGeometry.GetTempVector3(0.6, 0.6, 1)
      TweenScale.Begin(self.chooseIcon[i].gameObject, 0.2, targetScale)
    else
      local targetScale = LuaGeometry.GetTempVector3(0.5, 0.5, 1)
      TweenScale.Begin(self.chooseIcon[i].gameObject, 0.2, targetScale)
    end
  end
end

function LoveChallengeView:DoConfession()
  local oppoID, oppoName = MiniGameProxy.Instance:GetOppoInfo()
  local lvuMsg = GameConfig.LoveChallenge and GameConfig.LoveChallenge.ILoveUMsg
  if not lvuMsg then
    return
  end
  local formatStr = lvuMsg[math.random(#lvuMsg)]
  local str = ""
  if string.find(formatStr, "%%s") then
    str = string.format(lvuMsg[math.random(#lvuMsg)], oppoName)
  else
    str = formatStr
  end
  ServiceChatCmdProxy.Instance:CallChatCmd(ChatChannelEnum.Private, str, oppoID, nil, nil, nil, nil, nil, nil)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.ChatRoomPage,
    viewdata = {
      key = "Channel",
      channel = ChatChannelEnum.World
    }
  })
  local data = {
    type = "lovechallenge",
    str = str,
    loveconfession = 2
  }
  GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendSysmsgEvent, data)
  local keyEffect = Table_KeywordAnimation[10]
  GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendKeywordEffect, keyEffect)
end

function LoveChallengeView:OnEnter()
  LoveChallengeView.super.OnEnter(self)
  for objName, texName in pairs(textureNameMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function LoveChallengeView:OnExit()
  LoveChallengeView.super.OnExit(self)
  for objName, texName in pairs(textureNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  if self.pageIndex == 2 and not self.chooseFinish then
    xdlog("未选择直接逃跑")
    ServiceMessCCmdProxy.Instance:CallFingerGuessLoveConfessionMessCCmd(4, self.inviterID)
  end
  if self.pageIndex == 3 and not self.confessionFinish then
    self:DoConfession()
  end
  TimeTickManager.Me():ClearTick(self)
end
