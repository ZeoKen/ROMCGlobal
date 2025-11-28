RoguelikeTarotView = class("RoguelikeTarotView", BaseView)
RoguelikeTarotView.ViewType = UIViewType.PopUpLayer
RoguelikeTarotViewStage = {
  Check = RoguelikeCmd_pb.EROGUETAROTPROG_NO_CONFIRM,
  Draw = RoguelikeCmd_pb.EROGUETAROTPROG_CONFIRM,
  Confirm = RoguelikeCmd_pb.EROGUETAROTPROG_SELECT
}
local cardBackTexName, shuffleTickId = "tarot_back", 99999
local tarotMoveDuration, tarotShuffleDuration, tarotRetainedDuration, tarotClickEffectDuration = 1, 2, 1, 0.5
local tarotPosXes, tarotInvisiblePosXes = {
  -350,
  0,
  350
}, {
  -1200,
  1200,
  1200
}
local cardCount, arrayFindIndex, getTempV3 = GameConfig.Roguelike.TarotNum, TableUtility.ArrayFindIndex, LuaGeometry.GetTempVector3
local tarotLabelNormalHeight, tarotLabelMaxHeight, tarotLabelNormalLocalPos = 60, 300, -117
local validColor = LuaColor.New(0.984313725490196, 0.9215686274509803, 0.8156862745098039)
local dungeonIns, picIns, tickIns

function RoguelikeTarotView:Init()
  if not dungeonIns then
    dungeonIns = DungeonProxy.Instance
    picIns = PictureManager.Instance
    tickIns = TimeTickManager.Me()
  end
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function RoguelikeTarotView:FindObjs()
  self.coinIcon = self:FindComponent("Coin", UISprite)
  self.coinLabel = self:FindComponent("CoinLabel", UILabel)
  self.tipLabel = self:FindComponent("TipLabel", UILabel)
  self.refreshNumLabel = self:FindComponent("RefreshNum", UILabel)
  self.redrawNumLabel = self:FindComponent("RedrawNum", UILabel)
  self.redrawBtn = self:FindGO("RedrawBtn")
  self.redrawIcon = self:FindComponent("RedrawIcon", UISprite)
  self.refreshIcon = self:FindComponent("RefreshIcon", UISprite)
  local ctrlParentTrans, child, go = self:FindGO("Controls").transform
  self.stageCtrlGrids = {}
  for i = 1, ctrlParentTrans.childCount do
    child = ctrlParentTrans:GetChild(i - 1)
    self.stageCtrlGrids[tonumber(child.name)] = child:GetComponent(UIGrid)
  end
  self.cardBackParent = self:FindGO("CardBacks")
  self.cardBackGOs, self.cardBackTexes, self.cardBackTweens, self.cardBackEffectContainers = {}, {}, {}, {}
  for i = 1, cardCount do
    child = self.cardBackParent.transform:GetChild(i - 1)
    if child then
      go = child.gameObject
      local key = tonumber(go.name)
      self.cardBackGOs[key] = go
      self.cardBackTexes[key] = child:GetComponent(UITexture)
      self.cardBackTweens[key] = child:GetComponent(TweenRotation)
      self.cardBackEffectContainers[key] = self:FindGO("EffectContainer", go)
    end
  end
  self.cardParent = self:FindGO("Cards")
  self.cardGOs, self.cardLabels, self.cardTweens, self.cardTexes, self.cardTexNames = {}, {}, {}, {}, {}
  self.cardArrows, self.cardArrowBgs, self.cardOrigDescs, self.cardTipLabels = {}, {}, {}, {}
  for i = 1, cardCount do
    child = self.cardParent.transform:GetChild(i - 1)
    if child then
      go = child.gameObject
      local key = tonumber(go.name)
      self.cardGOs[key] = go
      self.cardTexes[key] = self:FindComponent("Tex", UITexture, go)
      self.cardLabels[key] = self:FindComponent("CardLabel", UILabel, go)
      self.cardTweens[key] = child:GetComponent(TweenRotation)
      self.cardTipLabels[key] = self:FindComponent("Tip", UILabel, go)
      self.cardArrowBgs[key] = self:FindComponent("ArrowBg", UISprite, go)
      self.cardArrows[key] = self:FindComponent("Arrow", UISprite, go)
      self:AddClickEvent(self.cardArrows[key].gameObject, function()
        local arrowSp, lab = self.cardArrows[key], self.cardLabels[key]
        if arrowSp.flip == 2 then
          arrowSp.flip = 0
          lab.overflowMethod = 3
          lab.text = self.cardOrigDescs[key]
          if lab.height > tarotLabelMaxHeight then
            lab.overflowMethod = 1
            lab.height = tarotLabelMaxHeight
            UIUtil.WrapLabel(lab)
          end
          lab.transform.localPosition = LuaGeometry.GetTempVector3(0, tarotLabelNormalLocalPos - tarotLabelNormalHeight + lab.height)
        elseif arrowSp.flip == 0 then
          self:SetTarotLabel(key, self.cardOrigDescs[key])
        end
      end)
    end
  end
end

function RoguelikeTarotView:InitView()
  self.moveTweens = {}
  self.refreshNumLabel.text = GameConfig.Roguelike.RefreshTarotGroupCoin
  self.redrawNumLabel.text = GameConfig.Roguelike.TarotSelectAgainCoin
  local iconName = Table_Item[DungeonProxy.RoguelikeCoinId].Icon
  IconManager:SetItemIcon(iconName, self.coinIcon)
  IconManager:SetItemIcon(iconName, self.redrawIcon)
  IconManager:SetItemIcon(iconName, self.refreshIcon)
end

function RoguelikeTarotView:AddEvents()
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd, self.UpdateMyCoin)
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRogueTarotInfoCmd, self.OnTarotInfo)
  self:AddListenEvt(PVEEvent.Roguelike_Shutdown, self.CloseSelf)
  local tarotOperate = function(key, index)
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(26266)
      return
    end
    ServiceRoguelikeCmdProxy.Instance:CallRogueTarotOperateCmd(RoguelikeCmd_pb["EROGUETAROTOPETATE_" .. key] or 0, index)
  end
  self:AddButtonEvent("DrawBtn", function()
    tarotOperate("CONFIRM_THREE")
  end)
  self:AddButtonEvent("RefreshBtn", function()
    if not self:CheckRefreshCoin() then
      MsgManager.ShowMsgByID(2)
      return
    end
    tarotOperate("RE_THREE")
  end)
  self:AddButtonEvent("ConfirmBtn", function()
    tarotOperate("CONFIRM_TAROT")
  end)
  self:AddButtonEvent("RedrawBtn", function()
    if not self:CheckRedrawCoin() then
      MsgManager.ShowMsgByID(2)
      return
    end
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(26266)
      return
    end
    self:UpdateStage(RoguelikeTarotViewStage.Draw)
  end)
  for i, tex in pairs(self.cardBackTexes) do
    self:AddClickEvent(tex.gameObject, function()
      if not self.isSelecting then
        return
      end
      tarotOperate("SELECT", i)
      self.cardBackClickTime = ServerTime.CurClientTime()
      self:PlayUIEffect(EffectMap.UI.TarotClick, self.cardBackEffectContainers[i], true)
    end)
  end
end

function RoguelikeTarotView:OnEnter()
  RoguelikeTarotView.super.OnEnter(self)
  if not Game.MapManager:IsPVEMode_Roguelike() then
    LogUtility.Error("You're trying to open RoguelikeTarotView outside the roguelike map!!")
    self:CloseSelf()
  end
  self:UpdateMyCoin()
  for _, tex in pairs(self.cardBackTexes) do
    picIns:SetRoguelikeTarot(cardBackTexName, tex)
  end
  self:OnTarotInfo()
end

function RoguelikeTarotView:OnExit()
  tickIns:ClearTick(self)
  for _, tex in pairs(self.cardBackTexes) do
    picIns:UnLoadRoguelikeTarot(cardBackTexName, tex)
  end
  for i, name in pairs(self.cardTexNames) do
    picIns:UnLoadRoguelikeTarot(name, self.cardTexes[i])
  end
  RoguelikeTarotView.super.OnExit(self)
end

function RoguelikeTarotView:OnTarotInfo()
  self:UpdateStage()
end

function RoguelikeTarotView:UpdateMyCoin()
  if not dungeonIns.roguelikeRaid then
    LogUtility.Warning("Cannot find roguelikeRaid")
    return
  end
  self.coinLabel.text = dungeonIns.roguelikeRaid.coinCount
  self.refreshNumLabel.color = self:CheckRefreshCoin() and ColorUtil.NGUIWhite or ColorUtil.Red
  self.redrawNumLabel.color = self:CheckRedrawCoin() and ColorUtil.NGUIWhite or ColorUtil.Red
end

function RoguelikeTarotView:UpdateStage(stage)
  stage = stage or dungeonIns.roguelikeTarotStage
  if stage == RoguelikeCmd_pb.EROGUETAROTPROG_DONE then
    helplog("RoguelikeTarot is done")
    self:CloseSelf()
    return
  end
  local exStage, allTarotIds, unlockedTarotDatas = self.stage, dungeonIns.roguelikeTarotIds, dungeonIns.roguelikeUnlockedTarotDatas
  self.stage = stage
  helplog("Updating Stage", stage, exStage, allTarotIds and #allTarotIds, unlockedTarotDatas and #unlockedTarotDatas)
  self.tipLabel.text = ZhString["Roguelike_TarotTip" .. tostring(self.stage)] or ""
  for key, grid in pairs(self.stageCtrlGrids) do
    grid.gameObject:SetActive(key == stage)
  end
  tickIns:ClearTick(self)
  self:InterruptTweens()
  if stage == RoguelikeTarotViewStage.Check then
    for i = 1, cardCount do
      self:UpdateTarot(i, allTarotIds and allTarotIds[i])
      self:SetTarotPos(i, true, false)
      self:SetTarotPos(i, false, true)
    end
  elseif stage == RoguelikeTarotViewStage.Draw then
    if exStage == RoguelikeTarotViewStage.Confirm then
      local curIndex, x
      for i = 1, cardCount do
        x = LuaGameObject.GetLocalPosition(self.cardGOs[i].transform)
        if x == 0 then
          curIndex = i
          break
        end
      end
      if curIndex then
        local animed, uIndex = ReusableTable.CreateTable()
        for _, uData in pairs(unlockedTarotDatas) do
          uIndex = uData.index
          self:UpdateTarot(uIndex, uData.id)
          self:SetTarotGrey(uIndex, true)
          self:CardMoveIn(uIndex, uIndex == curIndex and function()
            self.isSelecting = true
          end)
          animed[uIndex] = true
        end
        for i = 1, cardCount do
          if not animed[i] then
            self:CardBackMoveIn(i)
          end
        end
        ReusableTable.DestroyAndClearTable(animed)
      else
        LogUtility.Warning("Cannot get last selected tarot")
      end
    else
      for i = 1, cardCount do
        self:UpdateTarot(i, allTarotIds and allTarotIds[i])
        self:SetTarotPos(i, true, false)
        self:SetTarotPos(i, false, true)
      end
      tickIns:CreateOnceDelayTick(tarotRetainedDuration * 1000, function(self)
        local arr = ReusableTable.CreateArray()
        for i = 1, cardCount do
          arr[i] = i
        end
        self:CardsTurnOver(arr, function()
          self:Shuffle(function()
            self.isSelecting = true
          end)
        end)
        ReusableTable.DestroyAndClearArray(arr)
      end, self)
    end
  elseif stage == RoguelikeTarotViewStage.Confirm then
    self.isSelecting = nil
    self.stageCtrlGrids[stage].gameObject:SetActive(false)
    for i = 1, cardCount do
      self:SetTarotPos(i, true, true)
      self:SetTarotPos(i, false, false)
    end
    local unlockedTarotCount = unlockedTarotDatas and #unlockedTarotDatas or 0
    local index = self:GetLastSelectedTarotIndex(unlockedTarotDatas)
    if 0 < index then
      local uIndex
      for _, uData in pairs(unlockedTarotDatas) do
        uIndex = uData.index
        self:UpdateTarot(uIndex, uData.id)
        if uIndex ~= index then
          self:SetTarotPos(uIndex, true, false)
          self:SetTarotPos(uIndex, false, true)
          self:SetTarotGrey(uIndex, true)
          self:CardMoveOut(uIndex)
        end
      end
      for i = 1, cardCount do
        if i ~= index then
          self:CardBackMoveOut(i)
        end
      end
      local arr = ReusableTable.CreateArray()
      table.insert(arr, index)
      self:CardsTurnOver(arr, function()
        self:Move(self.cardGOs[index], 0, function()
          local flag = unlockedTarotCount < cardCount
          self.redrawBtn:SetActive(flag)
          self.stageCtrlGrids[self.stage].gameObject:SetActive(true)
          tickIns:CreateOnceDelayTick(16, function(self)
            self.stageCtrlGrids[self.stage]:Reposition()
          end, self)
          if flag then
            self.tipLabel.text = ZhString.Roguelike_TarotTip3_2
          end
        end)
      end)
      ReusableTable.DestroyAndClearArray(arr)
    else
      LogUtility.Warning("Cannot get last selected tarot")
      TableUtil.Print(unlockedTarotDatas)
    end
  end
end

function RoguelikeTarotView:UpdateTarot(cardIndex, tarotId)
  if not cardIndex or cardIndex <= 0 or cardIndex > #self.cardTexes then
    return
  end
  local sData = Table_RoguelikeTarot[tarotId]
  if not sData then
    LogUtility.WarningFormat("Cannot find tarot data of id = {0} from RoguelikeTarot", tarotId)
    return
  end
  local tex = self.cardTexes[cardIndex]
  if self.cardTexNames[cardIndex] then
    picIns:UnLoadRoguelikeTarot(self.cardTexNames[cardIndex], tex)
    self.cardTexNames[cardIndex] = nil
  end
  picIns:SetRoguelikeTarot(sData.Art, tex)
  self.cardTexNames[cardIndex] = sData.Art
  self:SetTarotLabel(cardIndex, sData.Desc)
  self:SetTarotTip(cardIndex, tarotId)
  self:SetTarotGrey(cardIndex, false)
end

function RoguelikeTarotView:SetTarotLabel(index, text)
  self.cardOrigDescs[index] = text
  local lab, arrow = self.cardLabels[index], self.cardArrows[index]
  arrow.flip = 2
  lab.overflowMethod = 1
  lab.height = tarotLabelNormalHeight
  lab.text = text
  lab.transform.localPosition = LuaGeometry.GetTempVector3(0, tarotLabelNormalLocalPos)
  local bWrap = UIUtil.WrapLabel(lab)
  arrow.gameObject:SetActive(not bWrap)
end

function RoguelikeTarotView:SetTarotTip(cardIndex, tarotId)
  if not cardIndex or cardIndex <= 0 or cardIndex > #self.cardTexes then
    return
  end
  local sData, tipText = Table_RoguelikeTarot[tarotId], ""
  if sData then
    local itemMaxLevel = DungeonProxy.GetRoguelikeItemMaxLevel(sData.ItemID)
    if 0 < itemMaxLevel and itemMaxLevel == dungeonIns:GetRoguelikeItemNumByStaticId(sData.ItemID) then
      tipText = ZhString.Roguelike_TarotMaxLevel
    end
  end
  local hasText = not StringUtil.IsEmpty(tipText)
  self.cardTipLabels[cardIndex].gameObject:SetActive(hasText)
  if hasText then
    self.cardTipLabels[cardIndex].text = tipText
  end
end

function RoguelikeTarotView:SetTarotGrey(cardIndex, flag)
  if not cardIndex or cardIndex <= 0 or cardIndex > #self.cardTexes then
    return
  end
  self.cardTexes[cardIndex].color = flag and LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1) or LuaGeometry.GetTempColor()
  self.cardLabels[cardIndex].color = flag and LuaGeometry.GetTempColor() or validColor
  self.cardArrowBgs[cardIndex].gameObject:SetActive(not flag)
  if flag then
    self.cardTipLabels[cardIndex].gameObject:SetActive(false)
  end
end

function RoguelikeTarotView:Move(go, targetPosX, onFinished)
  if not go then
    LogUtility.WarningFormat("Cannot call Move function with go == nil!!")
    return
  end
  targetPosX = targetPosX or 0
  local t = TweenPosition.Begin(go, tarotMoveDuration, getTempV3(targetPosX), false)
  t.method = 0 < arrayFindIndex(tarotInvisiblePosXes, targetPosX) and 1 or 2
  if onFinished then
    t:SetOnFinished(onFinished)
  end
  if arrayFindIndex(self.moveTweens, t) == 0 then
    TableUtility.ArrayPushBack(self.moveTweens, t)
  end
end

local checkIndex = function(index)
  if not index or index > cardCount or index <= 0 then
    LogUtility.WarningFormat("Invalid index: {0}", index)
    return false
  end
  return true
end

function RoguelikeTarotView:CardBackMoveIn(index, onFinished)
  if not checkIndex(index) then
    return
  end
  self:Move(self.cardBackGOs[index], tarotPosXes[index], onFinished)
end

function RoguelikeTarotView:CardBackMoveOut(index, onFinished)
  if not checkIndex(index) then
    return
  end
  self:Move(self.cardBackGOs[index], tarotInvisiblePosXes[index], onFinished)
end

function RoguelikeTarotView:CardMoveIn(index, onFinished)
  if not checkIndex(index) then
    return
  end
  self:Move(self.cardGOs[index], tarotPosXes[index], onFinished)
end

function RoguelikeTarotView:CardMoveOut(index, onFinished)
  if not checkIndex(index) then
    return
  end
  self:Move(self.cardGOs[index], tarotInvisiblePosXes[index], onFinished)
end

function RoguelikeTarotView:CardsTurnOver(cardIndices, onFinished)
  if type(cardIndices) ~= "table" then
    return
  end
  local indexCount, card, cardBack, cardPosX, cardBackPosX = #cardIndices
  for i = 1, indexCount do
    local index, setOnFinished = cardIndices[i], i == indexCount and onFinished ~= nil
    card, cardBack = self.cardGOs[index], self.cardBackGOs[index]
    if card and cardBack then
      cardPosX, cardBackPosX = card.transform.localPosition.x, cardBack.transform.localPosition.x
      if 0 < arrayFindIndex(tarotPosXes, cardPosX) and 0 < arrayFindIndex(tarotInvisiblePosXes, cardBackPosX) then
        self:TweenPlay(self.cardTweens[index], false, function()
          self:SetTarotPos(index, true, true)
          self:SetTarotPos(index, false, false)
          self:TweenPlay(self.cardBackTweens[index], false, function()
            if setOnFinished then
              onFinished()
            end
          end)
        end)
      elseif 0 < arrayFindIndex(tarotInvisiblePosXes, cardPosX) and 0 < arrayFindIndex(tarotPosXes, cardBackPosX) then
        local action = function(self)
          self:TweenPlay(self.cardBackTweens[index], true, function()
            self:SetTarotPos(index, true, false)
            self:SetTarotPos(index, false, true)
            self:TweenPlay(self.cardTweens[index], true, function()
              if setOnFinished then
                onFinished()
              end
            end)
          end)
        end
        if self.cardBackClickTime then
          local deltaT = ServerTime.CurClientTime() - self.cardBackClickTime
          if deltaT < tarotClickEffectDuration * 1000 then
            tickIns:CreateOnceDelayTick(deltaT, action, self)
          else
            action(self)
          end
          self.cardBackClickTime = nil
        else
          action(self)
        end
      else
        LogUtility.WarningFormat("TurnOver failed with index == {0}", index)
      end
    else
      LogUtility.WarningFormat("Cannot find card or card back with index == {0}", index)
    end
  end
end

function RoguelikeTarotView:Shuffle(onFinished)
  for i = 1, cardCount do
    self:SetTarotPos(i, true, true)
    self:SetTarotPos(i, false, false)
  end
  tickIns:ClearTick(self, shuffleTickId)
  self.onShuffleFinished, self.shuffleTime, self.shuffleDeltaInterval = onFinished, 0, 16
  self.shuffleDeltas = self.shuffleDeltas or {}
  for i = 1, cardCount do
    self.shuffleDeltas[i] = Game.Myself.data:GetRandom() * 0.75 + 30
  end
  tickIns:CreateTick(0, self.shuffleDeltaInterval, self._Shuffle, self, shuffleTickId)
end

local shuffleStepAction = function(go, deltaX)
  local transform = go.transform
  local x, halfWidth = LuaGameObject.GetLocalPosition(transform), tarotInvisiblePosXes[#tarotInvisiblePosXes]
  transform.localPosition = getTempV3((x + halfWidth + deltaX) % (halfWidth * 2) - halfWidth)
end

function RoguelikeTarotView:_Shuffle(interval)
  self.shuffleTime = self.shuffleTime + interval / 1000
  if self.shuffleTime > tarotShuffleDuration then
    tickIns:ClearTick(self, shuffleTickId)
    for i = 1, cardCount do
      self:Move(self.cardBackGOs[i], tarotInvisiblePosXes[#tarotInvisiblePosXes], function()
        self:CardBackMoveIn(i, i == cardCount and self.onShuffleFinished)
      end)
    end
  end
  for i = 1, cardCount do
    shuffleStepAction(self.cardBackGOs[i], self.shuffleDeltas[i] * interval / self.shuffleDeltaInterval)
    self.shuffleDeltas[i] = self.shuffleDeltas[i] * (1 - 0.3 / ApplicationInfo.GetTargetFrameRate())
  end
end

local interruptTweens = function(tweens)
  for _, t in pairs(tweens) do
    t.enabled = false
  end
end

function RoguelikeTarotView:InterruptTweens()
  interruptTweens(self.cardTweens)
  interruptTweens(self.cardBackTweens)
  interruptTweens(self.moveTweens)
end

local _tweenPlay = function(tween, isForward)
  if isForward ~= false then
    tween:PlayForward()
  else
    tween:PlayReverse()
  end
end

function RoguelikeTarotView:TweenPlay(tween, isForward, onFinished)
  if not tween then
    LogUtility.Error("Cannot get tween while calling TweenPlay")
    return
  end
  _tweenPlay(tween, isForward)
  tween:ResetToBeginning()
  tween:SetOnFinished(onFinished)
  _tweenPlay(tween, isForward)
end

function RoguelikeTarotView:GetLastSelectedTarotIndex(unlockedTarotDatas)
  if type(unlockedTarotDatas) ~= "table" or not next(unlockedTarotDatas) then
    return 0
  end
  return unlockedTarotDatas[#unlockedTarotDatas].index
end

function RoguelikeTarotView:SetTarotPos(index, isCardBack, isVisible)
  if not checkIndex(index) then
    return
  end
  if isVisible == nil then
    isVisible = true
  end
  local arr = isCardBack and self.cardBackGOs or self.cardGOs
  local x = isVisible and tarotPosXes[index] or tarotInvisiblePosXes[index]
  arr[index].transform.localPosition = getTempV3(x)
end

function RoguelikeTarotView:CheckRefreshCoin()
  return (dungeonIns:CheckRoguelikeCoin(GameConfig.Roguelike.RefreshTarotGroupCoin))
end

function RoguelikeTarotView:CheckRedrawCoin()
  return (dungeonIns:CheckRoguelikeCoin(GameConfig.Roguelike.TarotSelectAgainCoin))
end
