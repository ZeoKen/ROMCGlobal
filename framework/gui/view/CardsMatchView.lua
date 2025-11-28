CardsMatchView = class("CardsMatchView", ContainerView)
CardsMatchView.ViewType = UIViewType.NormalLayer
autoImport("MatchingCardCell")

function CardsMatchView:Init()
  self.challengeFilterData = 99
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end

local BonusTime = 3
local CardGameType = MiniGameCmd_pb.EMINIGAMETYPE_CARD_PAIR
local TipItemType = MiniGameCmd_pb.EASSISTTYPE_TIPS
local AddTimeTtemType = MiniGameCmd_pb.EASSISTTYPE_ADDTIME
local green = {
  LuaColor.New(0.6196078431372549, 0.8980392156862745, 0.43529411764705883),
  LuaColor.New(0.9176470588235294, 0.9607843137254902, 0.8392156862745098)
}
local red = {
  LuaColor.New(1, 1.5378700499807765E-5),
  LuaColor.New(1, 0.7254901960784313, 0.7254901960784313)
}

function CardsMatchView:FindObjs()
  self.cardGrid = self:FindGO("cardGrid"):GetComponent(UIGrid)
  self.cardGridCtrl = UIGridListCtrl.new(self.cardGrid, MatchingCardCell, "MatchingCardCell")
  self.countdown = self:FindGO("countdown"):GetComponent(UILabel)
  self.leftRound = self:FindGO("leftRound"):GetComponent(UILabel)
  self.lvinfo = self:FindGO("lvinfo"):GetComponent(UILabel)
  self.challengeInfo = self:FindGO("challengeInfo"):GetComponent(UILabel)
  self.recordinfo = self:FindGO("recordinfo", self.challengeInfo.gameObject):GetComponent(UILabel)
  self.challengeInfo.text = ZhString.MiniGame_ChallengeInfoLabel
  self.normalInfo = self:FindGO("normalInfo"):GetComponent(UILabel)
  self.normalInfo.text = ZhString.MiniGame_NormalInfoLabel
  self.leftContainer = self:FindGO("leftContainer"):GetComponent(UILabel)
  self.effectContainer = self:FindGO("effectContainer")
  self.timeEffectContainer = self:FindGO("timeEffectContainer")
  local effectPath = ResourcePathHelper.EffectUI("Eff_TimeBeat_LittleGame")
  self.timerGo = self:LoadPreferb_ByFullPath(effectPath, self.timeEffectContainer)
  self.timerGo:SetActive(false)
  self.timeEffctLabel = self:FindGO("+3s", self.timerGo):GetComponent(UILabel)
  self.timeEffctLabel.effectStyle = UILabel.Effect.Shadow
  self.timeAnimator = self.timerGo:GetComponent(Animator)
  self.itemCount = self:FindGO("itemCount"):GetComponent(UILabel)
  self.itemCount.text = "0"
  self.nextPanel = self:FindGO("nextPanel")
  self.nextPanel:SetActive(false)
  self.nextBtn = self:FindGO("nextBtn"):GetComponent(UIButton)
  self:AddClickEvent(self.nextBtn.gameObject, function()
    if not self.inPause then
      return
    end
    ServiceMiniGameCmdAutoProxy:CallMiniGameNextRound(CardGameType)
  end)
  self.itemContainer = self:FindGO("itemContainer")
  self:AddClickEvent(self.itemContainer, function()
    if self.inPause then
      return
    end
    itemCount = MiniGameProxy.Instance:GetItemList(CardGameType, TipItemType) or {}
    count = 0
    for i = 1, #itemCount do
      count = count + itemCount[i].count
    end
    if count <= 0 then
      return
    end
    self:LockCall()
    ServiceMiniGameCmdAutoProxy:CallMiniGameUseAssist(CardGameType, TipItemType)
  end)
  self:AddButtonEvent("CloseButton", function()
    MsgManager.ConfirmMsgByID(41103, function()
      ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, true, 0, 0, 0, true)
      self:ShowResult(false)
      self:CloseSelf()
    end)
  end)
end

function CardsMatchView:AddEvts()
  self.cardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickCardCell, self)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNtfGameOverCmd, self.EndGame)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.OnPlayerMapChange)
  self:AddListenEvt(ServiceEvent.MiniGameCmdMiniGameNextRound, self.HandleNextRound)
end

function CardsMatchView:OnPlayerMapChange()
  ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, true, 0, 0, 0, true)
  self:CloseSelf()
end

function CardsMatchView:HandleNextRound(note)
  local endtime = note and note.body and note.body.endtime
  self:SetItemCount()
  if note and note.body then
    if not note.body.carduseflag then
      self:StartRound()
      self:ResumeCountDown(endtime)
      itemCount = MiniGameProxy.Instance:GetItemList(CardGameType, AddTimeTtemType) or {}
      count = 0
      for i = 1, #itemCount do
        count = count + itemCount[i].effect
      end
      if count > 0 then
        self:PlayAddTimeEffect(count)
      end
      itemCount = MiniGameProxy.Instance:GetItemList(CardGameType, TipItemType) or {}
      self.lastcount = 0
      for i = 1, #itemCount do
        self.lastcount = self.lastcount + itemCount[i].count
      end
    else
      self:CancelLockCall()
      itemCount = MiniGameProxy.Instance:GetItemList(CardGameType, TipItemType) or {}
      count = 0
      for i = 1, #itemCount do
        count = count + itemCount[i].count
      end
      if not self.lastcount then
        self.lastcount = count
        self:QuickTip()
      elseif self.lastcount > count then
        self:QuickTip()
        self.lastcount = count
      end
    end
  end
end

local itemCount = {}
local count

function CardsMatchView:SetItemCount()
  itemCount = MiniGameProxy.Instance:GetItemList(CardGameType, TipItemType) or {}
  count = 0
  for i = 1, #itemCount do
    count = count + itemCount[i].count
  end
  self.itemCount.text = count
end

function CardsMatchView:InitShow()
  self.difficulty = self.viewdata.viewdata.difficulty
  self.challengeMode = self.difficulty >= self.challengeFilterData
  self.currentRecord = 0
  local isCleared = MiniGameProxy.Instance:IsCleared(CardGameType)
  self.currentmode = 0
  if isCleared and self.challengeMode then
    self.currentmode = MiniGameCmd_pb.EMINIGAMEMODE_CHALLENGE
    self.leftContainer.text = ZhString.MiniGame_LeftInfoLabel2
  else
    self.currentmode = MiniGameCmd_pb.EMINIGAMEMODE_NORMAL
    self.leftContainer.text = ZhString.MiniGame_LeftInfoLabel1
  end
  self.endTime = self.viewdata.viewdata.endtime
  self:StartCountDown()
  self:SetItemCount()
  self.firstCheck = {}
  self.record = MiniGameProxy.Instance:GetChallengeRecord(CardGameType)
  self:SetInfo()
end

function CardsMatchView:StartRound(endtime)
  self.inPause = false
  self:ShowNextPanel(false)
  local cardDatas = MiniGameProxy.Instance:GetCard(self.currentRound + 1)
  self.cardGrid.maxPerLine = Table_MiniGame_CardPairs[self.difficulty] and Table_MiniGame_CardPairs[self.difficulty].row_column[1] or 3
  self.cardGridCtrl:ResetDatas(cardDatas)
  self.totalMatches = #cardDatas * 0.5
  self.matchCount = 0
  self.lastCardCell = nil
  self:SetRound()
  if not self.visitedMap then
    self.visitedMap = {}
  else
    TableUtility.TableClear(self.visitedMap)
  end
  local childCells = self.cardGridCtrl:GetCells()
  for i = 1, #childCells do
    childCells[i]:PlayShow()
    self.visitedMap[i] = 0
  end
end

function CardsMatchView:SetRound()
  if self.challengeMode then
    self.leftRound.text = string.format("%d", self.currentRecord)
  else
    self.leftRound.text = string.format("%d", self.totalRound - self.currentRound)
  end
end

function CardsMatchView:SetInfo()
  if self.challengeMode then
    self.normalInfo.gameObject:SetActive(false)
    self.challengeInfo.gameObject:SetActive(true)
    self.recordinfo.text = self.record > self.currentRecord and self.record or self.currentRecord
  else
    self.normalInfo.gameObject:SetActive(true)
    self.challengeInfo.gameObject:SetActive(false)
    self.lvinfo.text = string.format("Lv.%d", self.difficulty)
  end
end

function CardsMatchView:OnEnter()
  MiniGameProxy.Instance.isInCardGame = true
  CardsMatchView.super.OnEnter(self)
end

local currentCellIndex = 0
local lastcellIndex = 0

function CardsMatchView:ClickCardCell(cell)
  if self.call_lock or self.inPause then
    return
  end
  if cell then
    currentCellIndex = cell:GetIndex()
    if not self.firstCheck[currentCellIndex] then
      self.firstCheck[currentCellIndex] = true
    end
    if cell:IsMatched() or cell:GetChooseState() then
      return
    end
    if self.lastCardCell then
      lastcellIndex = self.lastCardCell:GetIndex()
      if lastcellIndex == currentCellIndex then
        return
      end
    end
    self.visitedMap[currentCellIndex] = self.visitedMap[currentCellIndex] + 1
    if self.lastCardCell and self.lastCardCell:GetCardId() == cell:GetCardId() and self.lastCardCell:GetChooseState() and not cell:GetChooseState() then
      self.lastCardCell:SetMatched(true)
      cell:SetMatched(true)
      self.matchCount = self.matchCount + 1
      self:ChangeEndTime(BonusTime)
      if self.challengeMode then
        self.currentRecord = self.currentRecord + 1
        self:SetRound()
        self:SetInfo()
      end
      if not self.timerGo.activeInHierarchy then
        self.timerGo:SetActive(true)
      end
      self:PlayAddTimeEffect(BonusTime)
      ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, false, BonusTime, 0)
      if not self:CheckComplete() then
        self.lastCardCell = nil
      end
    elseif self.lastCardCell then
      self:LockCall()
      if self.visitedMap[currentCellIndex] > 1 or lastcellIndex and self.visitedMap[lastcellIndex] and self.visitedMap[lastcellIndex] > 1 then
        self:ChangeEndTime(-BonusTime)
        ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, false, 0, BonusTime)
        if self.timerGo and not self.timerGo.activeInHierarchy then
          self.timerGo:SetActive(true)
        end
        self:PlayMinusTimeEffect(-BonusTime)
        if self.endTime and self.endTime < ServerTime.CurServerTime() / 1000 then
          ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, true, 0, 0, 0, true)
          return
        end
      end
      self.timeTickId = self.timeTickId == nil and 100 or self.timeTickId + 1
      TimeTickManager.Me():ClearTick(self, self.timeTickId)
      TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
        if not self.lastCardCell then
          return
        end
        if self.lastCardCell and self.lastCardCell ~= cell then
          self.lastCardCell:SetChooseState()
          self.lastCardCell:PlayFlipEffect()
          self.lastCardCell = nil
        end
        cell:SetChooseState()
        self:CancelLockCall()
        cell:PlayFlipEffect()
      end, self, self.timeTickId)
    else
      self.lastCardCell = cell
    end
    cell:SetChooseState()
  end
end

function CardsMatchView:PlayAddTimeEffect(time)
  if not self.timeEffctLabel then
    return
  end
  self.timeEffctLabel.text = string.format("+%d", time)
  self.timeEffctLabel.color = green[1]
  self.timeEffctLabel.effectColor = green[2]
  self.timeAnimator:Play("Eff_TimeBeat_LittleGame_UP", -1, 0)
end

function CardsMatchView:PlayMinusTimeEffect(time)
  if not self.timeEffctLabel then
    return
  end
  self.timeEffctLabel.text = string.format("%d", time)
  self.timeEffctLabel.color = red[1]
  self.timeEffctLabel.effectColor = red[2]
  self.timeAnimator:Play("Eff_TimeBeat_LittleGame_UP", -1, 0)
end

function CardsMatchView:LockCall()
  if self.call_lock then
    return
  end
  self.call_lock = true
end

function CardsMatchView:CancelLockCall()
  if not self.call_lock then
    return
  end
  self.call_lock = false
end

function CardsMatchView:StartCountDown()
  local config = Table_MiniGame_CardPairs[self.difficulty]
  self.cdTick = TimeTickManager.Me():CreateTick(0, 1, self.UpdateCountDown, self, 1)
  self.totalRound = config.Deck
  self.currentRound = 0
  self:StartRound()
end

function CardsMatchView:ResumeCountDown(endtime)
  if not self.cdTick and endtime then
    self.endTime = endtime
    self.cdTick = TimeTickManager.Me():CreateTick(0, 1, self.UpdateCountDown, self, 1)
  end
end

function CardsMatchView:UpdateCountDown()
  self.leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
  self.countdown.text = string.format("%ss", math.ceil(self.leftTime))
  if self.leftTime == 0 then
    self:LockCall()
    self:CheckComplete(true)
  end
end

function CardsMatchView:StopCountdown()
  if self.cdTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.cdTick = nil
  end
end

function CardsMatchView:ShowPause()
  self.inPause = true
  self:StopCountdown()
  self:ShowNextPanel(true)
end

function CardsMatchView:ShowNextPanel(b)
  self.nextPanel:SetActive(b)
end

function CardsMatchView:ChangeEndTime(deltaTime)
  self.endTime = self.endTime + deltaTime
  self.timeEffctLabel.text = string.format("%ds", deltaTime)
  self:UpdateCountDown()
end

function CardsMatchView:OnExit()
  if self.timeTickId then
    TimeTickManager.Me():ClearTick(self, self.timeTickId)
    self.timeTickId = nil
    redlog("self.optLT = nil")
  end
  self:StopCountdown()
  local childCells = self.cardGridCtrl:GetCells()
  for i = 1, #childCells do
    childCells[i]:OnDestroy()
  end
  MiniGameProxy.Instance.isInCardGame = false
  self:sendNotification(UIEvent.CloseUI, UIViewType.ConfirmLayer)
  ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, true, 0, 0, 0, true)
  CardsMatchView.super.OnExit(self)
end

function CardsMatchView:CheckComplete(isFinish)
  if self.matchCount >= self.totalMatches then
    self.currentRound = self.currentRound + 1
    self:SetInfo()
    if self.currentmode == MiniGameCmd_pb.EMINIGAMEMODE_NORMAL and self.currentRound >= self.totalRound then
      ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, true)
      self:SetRound()
      self:StopCountdown()
      return true
    else
      self:ShowPause()
      ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, false, 0, 0, 0, false, true)
    end
  elseif isFinish then
    ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, true, 0, 0, 0, true)
    self:ShowResult(false)
    self:StopCountdown()
  end
  return false
end

function CardsMatchView:EndGame(note)
  if note then
    resultNote = note.body
    if resultNote and resultNote.type == EMINIGAMETYPE.EMINIGAMETYPE_CARD_PAIR then
      self:ShowResult(resultNote.result == EMINIGAMEOVERRESULT.EMINIGAME_OVER_WIN)
    end
  end
end

function CardsMatchView:ShowResult(result)
  local data = {}
  data.result = result and 1 or 2
  data.simply = true
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIVictoryView,
    viewdata = data
  })
end

function CardsMatchView:QuickTip()
  local childCells = self.cardGridCtrl:GetCells()
  if not self.lastCardCell then
    for i = 1, #childCells do
      local cell = childCells[i]
      if not cell:GetChooseState() then
        self.lastCardCell = cell
        cell:SetChooseState()
        cell:SetMatched(true)
        break
      end
    end
  end
  if self.lastCardCell then
    for i = 1, #childCells do
      local cell = childCells[i]
      if self.lastCardCell:GetCardId() == cell:GetCardId() and self.lastCardCell:GetChooseState() and not cell:GetChooseState() then
        self.lastCardCell:SetMatched(true)
        cell:SetMatched(true)
        cell:SetChooseState()
        self.matchCount = self.matchCount + 1
        self:ChangeEndTime(BonusTime)
        if self.challengeMode then
          self.currentRecord = self.currentRecord + 1
          self:SetRound()
          self:SetInfo()
        end
        if not self.timerGo.activeInHierarchy then
          self.timerGo:SetActive(true)
        end
        self:PlayAddTimeEffect(BonusTime)
        ServiceMiniGameCmdAutoProxy:CallMiniGameAction(self.currentmode, CardGameType, self.difficulty, MiniGameCmd_pb.EMINIGAME_ERROR_NONE, false, BonusTime, 0)
        if not self:CheckComplete() then
          self.lastCardCell = nil
        end
        return
      end
    end
  end
end
