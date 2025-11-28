autoImport("MaterialItemNewCell")
autoImport("CrowdfundingRewardCell")
CrowdfundingActView = class("CrowdfundingActView", BaseView)
CrowdfundingActView.ViewType = UIViewType.NormalLayer
local texObjStaticNameMap = {
  RightBg = "activity_Cat-backyard_bg",
  PReward1 = "activity_Cat-backyard_icon_gift-box",
  PReward2 = "activity_Cat-backyard_icon_gift-box",
  PReward3 = "activity_Cat-backyard_icon_gift-box",
  PReward4 = "activity_Cat-backyard_icon_gift-box",
  PReward5 = "activity_Cat-backyard_icon_gift-box"
}
local catAnimNames = {
  Idle = "idle",
  Jump = "jump",
  Eat = "eat"
}
local waypointPositions = {
  {-224, -150},
  {-383, 40},
  {-235, 146},
  {-38, 42},
  {112, 218},
  [0] = {-20, -276}
}
local rewardCellCount, pRewardCount = 5, 5
local picIns, actIns, serverIns, tickManager

function CrowdfundingActView:Init()
  if not picIns then
    picIns = PictureManager.Instance
    actIns = CrowdfundingActProxy.Instance
    serverIns = ServiceActivityCmdProxy.Instance
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddEvts()
end

function CrowdfundingActView:InitData()
  local viewData = self.viewdata.viewdata
  if viewData and viewData.id then
    self.id = viewData.id
    self.cfg = GameConfig.DonationActivity[self.id]
    CrowdfundingActProxy.Instance:Query(self.id)
  else
    LogUtility.Error("Wrong gActivity id while initializing CrowdfundingActView!")
  end
  self.tipData = {
    funcConfig = _EmptyTable,
    itemdata = ItemData.new()
  }
  self.isShowRewardPartLeft = false
end

function CrowdfundingActView:FindObjs()
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  self.leftBgSp = self:FindComponent("LeftBg1", UISprite)
  self.leftBg2Trans = self:FindGO("LeftBg2").transform
  self.title = self:FindComponent("Title", UILabel)
  self.titleProjection = self:FindComponent("TitleProjection", UILabel)
  self.summary = self:FindComponent("Summary", UILabel)
  self.rewardParent = self:FindGO("Rewards")
  self.globalProgress = self:FindComponent("GlobalProgress", UILabel)
  self.arrow = self:FindComponent("Arrow", UISprite)
  self.arrowRedTip = self:FindGO("RedTipCell", self.arrow.gameObject)
  self.timeLabel = self:FindComponent("Time", UILabel)
  self.totalLabel = self:FindComponent("Total", UILabel)
  self.pRewardEffContainer = self:FindGO("PRewardEffContainer")
  self.ownLabel = self:FindComponent("Own", UILabel)
  self.actionBtn = self:FindGO("ActionBtn")
  self.unavailableBtn = self:FindGO("UnavailableBtn")
  self.gpContainer = self:FindGO("GetPathContainer")
  self.pRewardTip = self:FindGO("PersonalRewardTip")
  self.pRewardTipLabel = self:FindComponent("PersonalRewardTipLabel", UILabel)
  self.catParent = self:FindGO("CatContainer")
  self.achievedPopup = self:FindGO("AchievedPopup")
  self.achievedLabel = self:FindComponent("AchievedLabel", UILabel)
  self:RegistShowGeneralHelpByHelpID(35090, self:FindGO("HelpButton"))
end

function CrowdfundingActView:InitView()
  self:SetTitle(self.cfg.activityName)
  actIns:SetShowingActivity(self.id)
  self.rewardCells = {}
  for i = 1, rewardCellCount do
    self.rewardCells[i] = CrowdfundingRewardCell.new(self:FindGO("Reward" .. i))
    self.rewardCells[i]:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardCell, self)
  end
  self.pRewardBoxes, self.pProgressTips, self.pProgressLabels, self.pRewardEffects = {}, {}, {}, {}
  for i = 1, pRewardCount do
    self.pRewardBoxes[i] = self:FindGO("PReward" .. i)
    self.pProgressTips[i] = self:FindGO("PProgressTip" .. i)
    self.pProgressLabels[i] = self:FindComponent("Label", UILabel, self.pProgressTips[i])
  end
  local iconName, icon = Table_Item[self.cfg.item].Icon
  self.itemIcons = {}
  for i = 1, 10 do
    icon = self:FindComponent("Icon" .. i, UISprite)
    if icon then
      IconManager:SetItemIcon(iconName, icon)
      self.itemIcons[i] = icon
    else
      break
    end
  end
  self:Update()
end

function CrowdfundingActView:AddEvts()
  self:AddClickEvent(self.arrow.gameObject, function()
    self.isShowRewardPartLeft = not self.isShowRewardPartLeft
    self:UpdateLeft()
  end)
  self:AddClickEvent(self.actionBtn, function()
    local num = self:GetItemNum()
    if 0 < num then
      if self.actionBtnEnabled then
        serverIns:CallGlobalDonationActivityDonateCmd(num)
      else
        LogUtility.Info("ActionBtn is disabled.")
      end
    else
      self:ShowGetPathOfItem()
    end
  end)
  self:AddClickEvent(self.itemIcons[1].gameObject, function()
    self:ShowItemTip(self.cfg.item, self.itemIcons[1])
  end)
  for i = 1, pRewardCount do
    self:AddClickEvent(self.pRewardBoxes[i], function()
      self:OnClickPRewardBox(i)
    end)
  end
  self:AddButtonEvent("ConfirmBtn", function()
    self.achievedPopup:SetActive(false)
  end)
  self:AddListenEvt(ServiceEvent.ActivityCmdStartGlobalActCmd, self.OnRecvGlobalAct)
  self:AddListenEvt(ServiceEvent.ActivityCmdGlobalDonationActivityDonateCmd, self.OnRecvDonate)
  self:AddListenEvt(ServiceEvent.ActivityCmdGlobalDonationActivityAwardCmd, self.OnRecvAward)
  self:AddListenEvt(ServiceEvent.ActivityCmdGlobalDonationActivityInfoCmd, self.OnRecvQuery)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(ItemEvent.BarrowUpdate, self.OnItemUpdate)
end

function CrowdfundingActView:OnEnter()
  CrowdfundingActView.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  tickManager:CreateTick(100, 1000, self.CheckParticipate, self)
end

function CrowdfundingActView:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  tickManager:ClearTick(self)
  actIns:ClearShowingActivity()
  CrowdfundingActView.super.OnExit(self)
end

function CrowdfundingActView:OnRecvGlobalAct()
  if not actIns:CheckActivityValid(self.id) then
    self:CloseSelf()
  end
end

function CrowdfundingActView:OnRecvDonate()
  self:Update()
end

function CrowdfundingActView:OnRecvAward()
  self:Update()
end

function CrowdfundingActView:OnRecvQuery()
  self.curCatPosIndex = nil
  self:Update()
end

function CrowdfundingActView:OnItemUpdate()
  self:UpdateOwn()
end

function CrowdfundingActView:OnClickRewardCell(cell)
  if cell.activate.activeSelf then
    local map = actIns:GetNowAvailableRewardIdMap(true)
    for id, _ in pairs(map) do
      serverIns:CallGlobalDonationActivityAwardCmd(ActivityCmd_pb.EGLOBALDONATIONACT_AWARD_GLOBAL, id)
    end
  else
    self:ShowItemTip(cell.rewardItemId, cell.icon, NGUIUtil.AnchorSide.Right)
  end
end

function CrowdfundingActView:OnClickPRewardItemCell(cell)
  if not cell.data then
    return
  end
  self:ShowItemTip(cell.data.staticData.id, cell.icon)
end

function CrowdfundingActView:OnClickPRewardBox(index)
  if not self.actionBtnEnabled then
    return
  end
  if self.pRewardEffects[index] then
    local map = actIns:GetNowAvailableRewardIdMap(false)
    for id, _ in pairs(map) do
      if id <= index then
        serverIns:CallGlobalDonationActivityAwardCmd(ActivityCmd_pb.EGLOBALDONATIONACT_AWARD_PERSONAL, id)
      end
    end
  else
    self:ShowPRewardTip(index)
  end
end

function CrowdfundingActView:Update()
  self:UpdateLeft()
  self:UpdateRight()
  self:UpdateAchieved()
  self:UpdateCat()
  self.pRewardTip:SetActive(false)
end

function CrowdfundingActView:UpdateLeft()
  self.leftBgSp.height = self.isShowRewardPartLeft and 576 or 160
  self.leftBg2Trans.localPosition = LuaGeometry.GetTempVector3(0, self.isShowRewardPartLeft and -293 or 123)
  self.summary.gameObject:SetActive(not self.isShowRewardPartLeft)
  self.rewardParent:SetActive(self.isShowRewardPartLeft)
  self.arrow.flip = self.isShowRewardPartLeft and 1 or 0
  if self.isShowRewardPartLeft then
    self:UpdateRewards()
  else
    self:UpdateSummary()
  end
  self:UpdateGlobalProgress()
end

function CrowdfundingActView:UpdateRight()
  local isParticipate = actIns:ParticipatePredicate()
  if isParticipate then
    self.timeLabel.text = actIns:GetParticipateTimeText()
  else
    local _, endTime = actIns.activityMap[self.id]:GetDuringTime()
    local endDate = os.date("*t", endTime)
    self.timeLabel.text = string.format(self.cfg.showingtext, endDate.month, endDate.day, endDate.hour, endDate.min)
  end
  self.actionBtn:SetActive(isParticipate)
  self.unavailableBtn:SetActive(not isParticipate)
  self.totalLabel.text = actIns:GetPersonalDonate()
  self:UpdateOwn()
  local awardedMap, availableMap, data, isShow = actIns:GetInfo("personalAwardedIdMap"), actIns:GetNowAvailableRewardIdMap(false)
  local needEffectMap = ReusableTable.CreateTable()
  for i = 1, pRewardCount do
    data = self.cfg.personalreward[i]
    isShow = data ~= nil and (not awardedMap or not awardedMap[i])
    self.pProgressTips[i]:SetActive(isShow)
    self.pProgressLabels[i].text = data.processnum
    self.pRewardBoxes[i]:SetActive(isShow)
    if isShow and availableMap[i] then
      needEffectMap[i] = true
    end
  end
  self:UpdatePRewardEffects(needEffectMap)
  ReusableTable.DestroyAndClearTable(needEffectMap)
end

function CrowdfundingActView:UpdateRewards()
  local cfg = self.cfg.globalreward
  for i = 1, rewardCellCount do
    self.rewardCells[i]:SetData(cfg[i])
  end
end

function CrowdfundingActView:UpdateSummary()
  local isCleared = actIns:GetGlobalProgress() >= 100
  self.summary.text = isCleared and self.cfg.completetext or self.cfg.donatingtext
end

function CrowdfundingActView:UpdateGlobalProgress()
  self.globalProgress.text = string.format(ZhString.CrowdfundingAct_GlobalProgress, actIns:GetGlobalProgress())
  local map = actIns:GetNowAvailableRewardIdMap(true)
  self.arrowRedTip:SetActive(next(map) ~= nil)
end

function CrowdfundingActView:UpdateOwn()
  self.ownLabel.text = self:GetItemNum()
end

function CrowdfundingActView:UpdatePRewardEffects(needEffectMap)
  local effectPRewardIdMap = ReusableTable.CreateTable()
  local count = 0
  for pRewardId, _ in pairs(needEffectMap) do
    count = count + 1
    effectPRewardIdMap[count] = pRewardId
  end
  redlog("UpdatePRewardEffects")
  TableUtil.Print(effectPRewardIdMap)
  self.effects = self.effects or {}
  TableUtility.TableClear(self.pRewardEffects)
  local updateActionBtnEnabled = function()
    if self.animIndexQ and not self.animIndexQ:Empty() then
      return
    end
    self.actionBtnEnabled = count - #self.effects <= 0
  end
  local updateEffectPos = function(assetEffect, pRewardId)
    assetEffect:ResetLocalPositionXYZ(LuaGameObject.GetLocalPosition(self.pRewardBoxes[pRewardId].transform))
    self.pRewardEffects[pRewardId] = assetEffect
  end
  updateActionBtnEnabled()
  for i = 1, count do
    local pRewardId = effectPRewardIdMap[i]
    if self.effects[i] then
      updateEffectPos(self.effects[i], pRewardId)
    else
      self:PlayUIEffect(EffectMap.UI.GlowHint9, self.pRewardEffContainer, false, function(obj, args, assetEffect)
        if not self then
          assetEffect:Destroy()
          return
        end
        self.effects[i] = assetEffect
        updateEffectPos(assetEffect, pRewardId)
        updateActionBtnEnabled()
      end)
    end
  end
  for i = count + 1, #self.effects do
    self.effects[i]:Destroy()
    self.effects[i] = nil
  end
  ReusableTable.DestroyAndClearTable(effectPRewardIdMap)
end

function CrowdfundingActView:UpdateAchieved()
  local isShow = actIns:GetShowComplete()
  self.achievedPopup:SetActive(isShow)
  if isShow then
    self.achievedLabel.text = string.format(ZhString.CrowdfundingAct_Achieved, os.date(ZhString.CrowdfundingAct_AchievedDate, actIns:GetGlobalCompleteTime()), self.cfg.noticetext or "", Game.Myself.data:GetName(), Table_Item[self.cfg.item].NameZh, actIns:GetPersonalDonate())
    actIns:ClearShowComplete()
    self:PlayUIEffect(EffectMap.UI.Celebrate, self.achievedPopup, true)
  end
end

local getDestPos = function(index)
  local pos = index and waypointPositions[index] or waypointPositions[0]
  return LuaGeometry.GetTempVector3(pos[1], pos[2])
end

function CrowdfundingActView:UpdateCat()
  if not self.cat then
    self:CreateCat()
  end
  local destIndex = self:GetDestIndex()
  local exPDonate = self.pDonate or 0
  self.pDonate = actIns:GetPersonalDonate()
  if self.curCatPosIndex then
    self:PlayCatMoveAnim(destIndex)
    if exPDonate < self.pDonate then
      self:PlayCatEat()
    end
  else
    self.catTrans.localPosition = getDestPos(destIndex)
    self.catTrans.localRotation = LuaGeometry.Const_Qua_identity
    self.curCatPosIndex = destIndex
  end
end

function CrowdfundingActView:CreateCat()
  self.resPath = ResourcePathHelper.Emoji("bgemao")
  self.cat = Game.AssetManager_UI:CreateSceneUIAsset(self.resPath, self.catParent)
  if not self.cat then
    LogUtility.Error("Cannot find cat asset")
    return
  end
  UIUtil.ChangeLayer(self.cat, self.catParent.layer)
  self.catTrans = self.cat.transform
  self.catTrans.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
  self.cat.gameObject:SetActive(true)
  self.catAnimComp = self.cat:GetComponent(SkeletonAnimation)
  self:PlayCatIdle()
  local uiSpine = self.cat:GetComponent(UISpine)
  uiSpine.depth = 20
end

function CrowdfundingActView:TryFlipCat(destIndex)
  local isFlip
  if destIndex then
    if destIndex > self.curCatPosIndex then
      isFlip = 2 < destIndex
    else
      isFlip = destIndex < 3
    end
  end
  self.cat.transform.localEulerAngles = LuaGeometry.GetTempVector3(0, isFlip and 180 or 0)
end

local catPosTween = function(cat, destIndex)
  local tp = TweenPosition.Begin(cat.gameObject, 0.4, getDestPos(destIndex))
  tp.delay = 0.3
end

function CrowdfundingActView:_CatMove()
  local nextDest = self.animIndexQ:Peek()
  self:TryFlipCat(nextDest)
  if self.animIndexQ:Empty() then
    self.actionBtnEnabled = true
  else
    catPosTween(self.cat, nextDest)
    self:PlayCatJump(self._CatMoveCallback)
  end
end

function CrowdfundingActView:_CatMoveCallback()
  self.curCatPosIndex = self.animIndexQ:Pop()
  self:_CatMove()
end

function CrowdfundingActView:PlayCatMoveAnim(destIndex)
  if destIndex == self.curCatPosIndex then
    return
  end
  self.animIndexQ = self.animIndexQ or LuaQueue.new()
  TableUtility.TableClear(self.animIndexQ.container)
  if destIndex > self.curCatPosIndex then
    for i = self.curCatPosIndex + 1, destIndex do
      self.animIndexQ:Push(i)
    end
  else
    for i = self.curCatPosIndex - 1, destIndex, -1 do
      self.animIndexQ:Push(i)
    end
  end
  self.actionBtnEnabled = false
  self:_CatMove()
end

function CrowdfundingActView:PlayCatIdle()
  self:PlayCatAnim(catAnimNames.Idle)
end

function CrowdfundingActView:PlayCatEat(callback)
  if self.nowPlayingAnimName ~= catAnimNames.Idle then
    return
  end
  self:PlayCatAnim(catAnimNames.Eat, callback)
end

function CrowdfundingActView:PlayCatJump(callback)
  self:PlayCatAnim(catAnimNames.Jump, callback)
end

function CrowdfundingActView:_CatAnimCallback(extraCallback)
  self:PlayCatIdle()
  if extraCallback then
    extraCallback(self)
  end
end

function CrowdfundingActView:PlayCatAnim(animName, callback)
  local isIdle = animName == catAnimNames.Idle
  self.catAnimComp:Reset()
  self.catAnimComp.loop = isIdle
  self.nowPlayingAnimName = animName
  SpineLuaHelper.PlayAnim(self.catAnimComp, animName, not isIdle and function()
    self:_CatAnimCallback(callback)
  end or nil)
end

function CrowdfundingActView:GetDestIndex()
  local rslt, donate, cfg = 0, actIns:GetPersonalDonate(), self.cfg.personalreward
  if 0 < donate then
    for i = 1, #cfg do
      if donate <= cfg[i].processnum and donate > (cfg[i - 1] and cfg[i - 1].processnum or 0) then
        rslt = math.min(i, pRewardCount)
      end
    end
    if rslt == 0 then
      rslt = pRewardCount
    end
  end
  return rslt
end

function CrowdfundingActView:GetItemNum()
  return BagProxy.Instance:GetItemNumByStaticID(self.cfg.item, GameConfig.PackageMaterialCheck.Donation_pack)
end

local pRewardTipOffset = {-40, -70}

function CrowdfundingActView:ShowPRewardTip(index)
  local data = self.cfg.personalreward[index]
  if not data then
    return
  end
  self.pRewardTipLabel.text = string.format(ZhString.CrowdfundingAct_PersonalProgress, data.processnum)
  if not self.pRewardItemCtrl then
    self.pRewardItemCtrl = ListCtrl.new(self:FindComponent("PersonalRewardGrid", UIGrid), MaterialItemNewCell, "MaterialItemNewCell")
    self.pRewardItemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickPRewardItemCell, self)
    self.pRewardItemDatas = {
      ItemData.new()
    }
  end
  self.pRewardItemDatas[1]:ResetData(MaterialItemCell.MaterialType.Material, data.itemid)
  self.pRewardItemDatas[1]:SetItemNum(data.num)
  self.pRewardItemCtrl:ResetDatas(self.pRewardItemDatas)
  self.pRewardTip:SetActive(true)
  local pos = waypointPositions[index]
  self.pRewardTip.transform.localPosition = LuaGeometry.GetTempVector3(pos[1] + pRewardTipOffset[1], pos[2] + pRewardTipOffset[2])
end

function CrowdfundingActView:ShowGetPathOfItem()
  if self.bdt then
    self.bdt:OnExit()
  else
    self.bdt = GainWayTip.new(self.gpContainer)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(self.cfg.item)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  end
end

function CrowdfundingActView:GetPathCloseCall()
  self.bdt = nil
end

function CrowdfundingActView:SetTitle(text)
  text = tostring(text) or ""
  self.title.text = text
  self.titleProjection.text = text
end

local tipOffset = {0, 0}

function CrowdfundingActView:ShowItemTip(itemId, stick, side)
  self.tipData.itemdata:ResetData("Tip", itemId)
  side = side or NGUIUtil.AnchorSide.Left
  tipOffset[1] = side == NGUIUtil.AnchorSide.Left and -220 or 260
  CrowdfundingActView.super.ShowItemTip(self, self.tipData, stick, side, tipOffset)
end

function CrowdfundingActView:CheckParticipate()
  if self.lastCheckParticipate ~= nil then
    local new = actIns:ParticipatePredicate()
    if self.lastCheckParticipate == true and new == false then
      self:CloseSelf()
    end
  end
  self.lastCheckParticipate = actIns:ParticipatePredicate()
end
