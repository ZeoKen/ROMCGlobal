TreasuryRechargeView = class("TreasuryRechargeView", ContainerView)
TreasuryRechargeView.ViewType = UIViewType.BuildingLayer
local textObjNameMap = {
  BoxTexture = "Treasury_coin_01",
  BoxTexture2 = "Treasury_coin_02",
  BoxTexture3 = "Treasury_coin_03",
  BoxTexture4 = "Treasury_coin_04",
  BoxTexture5 = "Treasury_coin_05",
  BoxTexture6 = "Treasury_coin_06",
  BoxTexture7 = "Treasury_coin_07",
  BoxTexture8 = "Treasury_coin_08",
  BoxTexture9 = "Treasury_coin_09",
  MainBGTexture = "Treasury_bg_bottom_02",
  Star1 = "Treasury_bg_star_01",
  Star2_1 = "Treasury_bg_star_02",
  Star2_2 = "Treasury_bg_star_02",
  Star3 = "Treasury_bg_star_03",
  MoonTexture = "Midsummer_bg_moon"
}
local tempPos = LuaVector3()
local maxWaveDegree = 15

function TreasuryRechargeView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function TreasuryRechargeView:FindObjs()
  self.anchor_Left = self:FindGO("Anchor_Left")
  self.keyIcon = self:FindGO("KeyIcon", self.anchor_Left):GetComponent(UISprite)
  self.keyLabel = self:FindGO("KeyLabel", self.anchor_left):GetComponent(UILabel)
  local config = GameConfig.BoliGold
  for i = 1, 4 do
    local label = self:FindGO("TitleLabel" .. i):GetComponent(UILabel)
    label.text = config and config["Text" .. i]
  end
  local leftBoxTip = self:FindGO("LeftBoxTip"):GetComponent(UILabel)
  leftBoxTip.text = ZhString.Treasury_LeftReward
  local treasureGridGO = self:FindGO("TreasureGrid")
  self.treasureGrid = treasureGridGO:GetComponent(UIGrid)
  self.treasureList = {}
  for i = 1, 8 do
    local treasure = {}
    treasure.go = self:FindGO("Treasure" .. i, treasureGridGO)
    treasure.icon = treasure.go:GetComponent(GradientUISprite)
    IconManager:SetItemIcon(Table_Item[151].Icon, treasure.icon)
    treasure.icon.isGradient = false
    treasure.label = self:FindGO("Label", treasure.go):GetComponent(UILabel)
    treasure.check = self:FindGO("Check", treasure.go)
    self.treasureList[i] = treasure
  end
  local treasureListBg = self:FindGO("TreasureListBg")
  self.totalGainLabel = self:FindGO("TotalGainLabel"):GetComponent(UILabel)
  self.totalGainLabel.text = ZhString.Treasury_TotalGain
  self.totalGainCount = self:FindGO("TotalGainCount"):GetComponent(UILabel)
  self.totalGainIcon = self:FindGO("icon", treasureListBg):GetComponent(GradientUISprite)
  IconManager:SetItemIcon(Table_Item[151].Icon, self.totalGainIcon)
  self.totalGainIcon.isGradient = false
  self.funcPart = self:FindGO("FuncPart")
  self.gotoBtn = self:FindGO("GotoBtn")
  self.moreRechrgeLabel = self:FindGO("MoreRecharge"):GetComponent(UILabel)
  self.moreRechrgeLabel.text = ZhString.Treasury_MoreRecharge
  self.moreRechargeIcon = self:FindGO("icon", self.funcPart):GetComponent(GradientUISprite)
  IconManager:SetItemIcon(Table_Item[151].Icon, self.moreRechargeIcon)
  self.moreRechargeIcon.isGradient = false
  self.nextStepLabel = self:FindGO("NextStepLabel"):GetComponent(UILabel)
  self.canGainTip = self:FindGO("CanGainTip"):GetComponent(UILabel)
  self.canGainLabel = self:FindGO("CanGainLabel"):GetComponent(UILabel)
  self.allFinishPart = self:FindGO("AllFinishPart")
  self.allFinishLabel = self:FindGO("AllFinishLabel", self.allFinishPart):GetComponent(UILabel)
  self.allFinishLabel.text = ZhString.Treasury_AllGot
  self.anchor_Center = self:FindGO("Anchor_Center")
  self.mainTitleLabel = self:FindGO("MainTitle", self.anchor_Center):GetComponent(UILabel)
  self.mainTitleLabel.text = config and config.ActivityName
  self.timeLabel = self:FindGO("TimeLabel", self.anchor_Center):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpButton")
  self.mainPart = self:FindGO("MainPart", self.anchor_Center)
  self.boxList = {}
  for i = 1, 8 do
    local box = {}
    box.go = self:FindGO("Box" .. i)
    box.texture = box.go:GetComponentInChildren(UITexture)
    box.effectContainer = self:FindGO("effectContainer", box.go)
    box.tweenRot = box.go:GetComponentInChildren(TweenRotation)
    box.tweenPos = box.go:GetComponentInChildren(TweenPosition)
    self:AddDragEvent(box.go, function(obj, delta)
      self:TryDragBox(obj, delta, i)
    end)
    self:AddPressEvent(box.go, function(obj, state)
      self:TryShowDragTip(state, obj, i)
    end)
    self.boxList[i] = box
  end
  self.dragTipLabel = self:FindGO("DragTip"):GetComponent(UILabel)
  self.dragTipLabel.text = ZhString.Treasury_DragTip
  self.dragTipPart = self:FindGO("DragTipPart")
  self.handTween = self:FindGO("Hand", self.dragTipPart):GetComponent(TweenPosition)
  self.dragTipBg = self:FindGO("Bg", self.dragTipPart):GetComponent(UISprite)
  self.canGetLabel = self:FindGO("CanGetLabel"):GetComponent(UIRichLabel)
  self.canGetLabel = SpriteLabel.new(self.canGetLabel, nil, 40, 40, true)
  self.dragTipPart:SetActive(false)
  self.anchor_Right = self:FindGO("Anchor_Right")
  self.freeGiftBtn = self:FindGO("FreeGiftBtn")
  for obj, _ in pairs(textObjNameMap) do
    self[obj] = self:FindComponent(obj, UITexture)
  end
  self.maskCollider = self:FindGO("MaskCollider"):GetComponent(BoxCollider)
  self.maskCollider.enabled = false
end

function TreasuryRechargeView:AddViewEvts()
  self:AddClickEvent(self.gotoBtn, function()
    MsgManager.ConfirmMsgByID(41164, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
      self:CloseSelf()
    end)
  end)
  self:AddClickEvent(self.freeGiftBtn, function()
    TreasuryRechargeProxy.Instance:CallBoliGoldGetFreeReward()
  end)
  self:RegistShowGeneralHelpByHelpID(35256, self.helpBtn)
end

function TreasuryRechargeView:AddMapEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3BoliGoldGetReward, self.handleGetReward, self)
  self:AddListenEvt(ServiceEvent.SceneUser3BoliGoldInfo, self.RefreshPage, self)
  self:AddListenEvt(ServiceEvent.SceneUser3BoliGoldGetFreeReward, self.handleGetFreeReward, self)
end

function TreasuryRechargeView:InitDatas()
  self.deltaX = 0
  self.deltaY = 0
  self.actId = TreasuryRechargeProxy.Instance.actId
end

function TreasuryRechargeView:InitShow()
  self:InitGotRewards()
  self:InitTime()
  self:RefreshFreeGift()
  self:RefreshBoxes()
end

function TreasuryRechargeView:RefreshPage()
  self:RefreshBoxes()
end

function TreasuryRechargeView:InitGotRewards()
  self.staticData = Table_BoliGold[self.actId]
  if not self.staticData then
    return
  end
  local rewardPool = self.staticData.RewardPool
  local result = {}
  for i = 1, #rewardPool do
    local rewardCount = rewardPool[i].reward[2]
    table.insert(result, rewardCount)
  end
  table.sort(result, function(l, r)
    return l < r
  end)
  for i = 1, 8 do
    if result[i] then
      self.treasureList[i].label.text = result[i] and "x" .. result[i]
    else
      self.treasureList[i].go:SetActive(false)
    end
  end
  self.depositCount = #result
end

function TreasuryRechargeView:InitTime()
  local actTime = EnvChannel.IsTFBranch() and self.staticData.TfTime or self.staticData.Time
  local format1 = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local format2 = "%s.%s %s:%s"
  local resultStr = ""
  local startTime = actTime[1]
  local year, month, day, hour, min, sec = startTime:match(format1)
  resultStr = resultStr .. string.format(format2, month, day, hour, min) .. " ~ "
  local endTime = actTime[2]
  year, month, day, hour, min, sec = endTime:match(format1)
  resultStr = resultStr .. string.format(format2, month, day, hour, min)
  self.timeLabel.text = resultStr
  self.endStamp = os.time({
    year = year,
    month = month,
    day = day,
    hour = hour,
    min = min,
    sec = sec
  })
  TimeTickManager.Me():CreateTick(0, 1000, self.RefreshTime, self, 2)
end

function TreasuryRechargeView:RefreshTime()
  if ServerTime.CurServerTime() / 1000 > self.endStamp then
    TimeTickManager.Me():ClearTick(self, 2)
    self:CloseSelf()
  end
end

function TreasuryRechargeView:RefreshFreeGift()
  local hasGotFree = TreasuryRechargeProxy.Instance.hasGotFree
  self.freeGiftBtn:SetActive(not hasGotFree)
end

function TreasuryRechargeView:RefreshGotRewards()
  local restKey = TreasuryRechargeProxy.Instance.restKeyCount
  local curGotRewards = TreasuryRechargeProxy.Instance.gotRewards
  for i = 1, 8 do
    if TableUtility.ArrayFindIndex(curGotRewards, i) > 0 then
      self.treasureList[i].check:SetActive(true)
    else
      self.treasureList[i].check:SetActive(false)
    end
  end
  self.keyLabel.text = restKey .. "/" .. self.depositCount
end

function TreasuryRechargeView:RefreshBoxes()
  local curGotRewards = TreasuryRechargeProxy.Instance.gotRewards
  local selectBoxes = TreasuryRechargeProxy.Instance.selected
  local restKeyCount = TreasuryRechargeProxy.Instance.restKeyCount
  local keyDeposit = self.staticData.KeyDeposit
  local rewardPool = self.staticData.RewardPool
  local totalGot = 0
  self.leftRewardList = {}
  for i = 1, 8 do
    local isGot = 0 < TableUtility.ArrayFindIndex(selectBoxes, i)
    self.boxList[i].go:SetActive(not isGot)
    if not isGot then
      if 0 < restKeyCount then
        if not self.boxList[i].effect then
          self.boxList[i].effect = self:PlayUIEffect(EffectMap.UI.Treasury_ClickValid, self.boxList[i].effectContainer)
        end
      elseif self.boxList[i].effect then
        self.boxList[i].effect:Destroy()
        self.boxList[i].effect = nil
      end
    end
    if 0 < TableUtility.ArrayFindIndex(curGotRewards, i) then
      totalGot = totalGot + rewardPool[i].reward[2]
      self.treasureList[i].check:SetActive(true)
    else
      self.treasureList[i].check:SetActive(false)
      table.insert(self.leftRewardList, rewardPool[i].reward[2])
    end
  end
  self.totalGainCount.text = "x" .. totalGot
  self.keyLabel.text = restKeyCount .. "/" .. self.depositCount
  self.dragTipLabel.gameObject:SetActive(restKeyCount ~= 0)
  self.handTween.gameObject:SetActive(restKeyCount ~= 0)
  local deposit = TreasuryRechargeProxy.Instance.deposit
  local depositList = {}
  for k, v in pairs(keyDeposit) do
    table.insert(depositList, k)
  end
  table.sort(depositList, function(l, r)
    return l < r
  end)
  local reachNextStep = false
  local delta = 0
  for i = 1, #depositList do
    if deposit < depositList[i] then
      delta = depositList[i] - deposit
      reachNextStep = true
      break
    end
  end
  if reachNextStep then
    self.nextStepLabel.text = "x" .. math.ceil(delta) .. ","
    self.funcPart:SetActive(true)
    self.allFinishPart:SetActive(false)
  else
    self.funcPart:SetActive(false)
    self.allFinishPart:SetActive(true)
  end
end

function TreasuryRechargeView:handleGetReward(note)
  local data = note.body
  local recentReward = data.reward
  local rewardInfo = self.staticData.RewardPool and self.staticData.RewardPool[recentReward]
  if rewardInfo then
    local itemData = ItemData.new("Reward", rewardInfo.reward[1])
    itemData.num = rewardInfo.reward[2]
    self:ShowAwardEffect(itemData)
  end
  self:RefreshPage()
end

function TreasuryRechargeView:handleGetFreeReward()
  self:RefreshFreeGift()
  local freeReward = self.staticData and self.staticData.FreeReward
  if freeReward then
    local itemData = ItemData.new("Reward", freeReward[1])
    itemData.num = freeReward[2]
    self:ShowAwardEffect(itemData)
  end
end

function TreasuryRechargeView:TryDragBox(obj, delta, index)
  self.deltaX = self.deltaX + delta.x
  self.deltaY = self.deltaY + delta.y
  if self.deltaY < -150 then
    redlog("拉了！")
    self:TryShowDragTip(false, obj, index)
    self.deltaY = 0
    if TreasuryRechargeProxy.Instance.restKeyCount == 0 then
      return
    end
    self.maskCollider.enabled = true
    self:TryPlayDropAnimeTween(index)
    TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
      self.maskCollider.enabled = false
      TreasuryRechargeProxy.Instance:CallBoliGoldGetReward(index)
    end, self, 1)
  end
end

function TreasuryRechargeView:TryPlayDropAnimeTween(index)
  local tweenPos = self.boxList[index] and self.boxList[index].tweenPos
  if tweenPos then
    local go = self.boxList[index].go
    local texture = self.boxList[index].texture
    LuaVector3.Better_Set(tempPos, LuaGameObject.GetLocalPosition(texture.gameObject.transform))
    tweenPos.from = tempPos
    tempPos[2] = tempPos[2] - 1000
    tweenPos.to = tempPos
    tweenPos.duration = 0.7
    tweenPos:ResetToBeginning()
    tweenPos:PlayForward()
  end
end

function TreasuryRechargeView:TryShowDragTip(state, obj, index)
  if not obj then
    return
  end
  if state then
    self.handTween:ResetToBeginning()
    self.dragTipPart.transform.position = obj.transform.position
    self.dragTipPart:SetActive(true)
    TweenAlpha.Begin(self.dragTipPart, 0, 0)
    TweenAlpha.Begin(self.dragTipPart, 0.3, 1)
    local minReward = math.min(unpack(self.leftRewardList))
    local maxReward = math.max(unpack(self.leftRewardList))
    local rangeStr = "x" .. minReward .. "~" .. maxReward
    self.canGetLabel:SetText(string.format(ZhString.Treasury_RewardRange, rangeStr))
    self.canGetLabel:SetText(string.format(ZhString.Treasury_RewardRange, rangeStr))
    self.dragTipBg.width = self.canGetLabel.richLabel.printedSize.x + 42
    self.dragTipBg.height = self.canGetLabel.richLabel.printedSize.y + 39
    self.boxList[index].tweenRot:ResetToBeginning()
    self.boxList[index].texture.gameObject.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.boxList[index].tweenRot.enabled = false
  else
    self.dragTipPart:SetActive(false)
    self.deltaY = 0
    local tweenScale = self.deltaX / 10
    if tweenScale > maxWaveDegree then
      tweenScale = maxWaveDegree
    elseif tweenScale < maxWaveDegree * -1 then
      tweenScale = maxWaveDegree * -1
    end
    self.boxList[index].tweenRot.from = LuaGeometry.GetTempVector3(0, 0, tweenScale)
    self.boxList[index].tweenRot.to = LuaGeometry.GetTempVector3(0, 0, tweenScale * -1)
    self.boxList[index].tweenRot:PlayForward()
    self.deltaX = 0
  end
end

function TreasuryRechargeView:ShowAwardEffect(itemData)
  local argumentTable = ReusableTable.CreateTable()
  argumentTable.disableMsg = true
  FloatAwardView.addItemDatasToShow({itemData}, argumentTable)
  ReusableTable.DestroyAndClearTable(argumentTable)
end

function TreasuryRechargeView:OnEnter()
  for obj, texName in pairs(textObjNameMap) do
    if self[obj] then
      PictureManager.Instance:SetUI(texName, self[obj])
    end
  end
  PictureManager.ReFitFullScreen(self.MainBGTexture, 1)
  TreasuryRechargeView.super.OnEnter(self)
end

function TreasuryRechargeView:OnExit()
  for obj, texName in pairs(textObjNameMap) do
    if self[obj] then
      PictureManager.Instance:UnLoadUI(texName, self[obj])
    end
  end
  TimeTickManager.Me():ClearTick(self)
  TreasuryRechargeView.super.OnExit(self)
end
