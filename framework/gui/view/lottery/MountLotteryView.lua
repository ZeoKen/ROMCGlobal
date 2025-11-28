autoImport("MountLotteryDetailCell")
autoImport("MountItemTabCell")
MountLotteryView = class("MountLotteryView", ContainerView)
MountLotteryView.ViewType = UIViewType.NormalLayer
local TabConfig = {
  [1] = ZhString.MountLottery_Round1,
  [2] = ZhString.MountLottery_Round2,
  [3] = ZhString.MountLottery_Round3
}
local LuckyCatID = 806011
local CardID = 10022
local tempV3 = LuaVector3()
local tempRot = LuaQuaternion()
local RideConfig = GameConfig.RideLottery
local tempNum = 1
local currentRound

function MountLotteryView:OnEnter()
  self.exited = false
  self.mask1:ResetToBeginning()
  self.mask1:PlayForward()
  ServiceItemProxy.Instance:CallQueryRideLotteryInfo()
  self.cameraLT = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self:NormalCameraFaceTo()
    MountLotteryProxy.Instance:ResetLastClick()
  end, self)
  FunctionSceneFilter.Me():StartFilter(GameConfig.FilterType.PhotoFilter.Self)
  Game.GUISystemManager:AddMonoUpdateFunction(self.MonoUpdate, self)
  ServiceWeatherProxy.Instance:SetWeatherEnable(false)
  Game.SetWeatherAnimationEnable(false)
  self:Show(self.closeBtn)
  self.call_lock = false
  self:UpdatePicUrl()
end

local ViewPort = Vector3(0.35, 0.17, 7.5)
local Rotation = Vector3(0, 40, 0)

function MountLotteryView:NormalCameraFaceTo()
  local npcdata = MountLotteryProxy.Instance:GetNpcModel()
  local myTrans = npcdata and npcdata.completeTransform
  local func = function()
  end
  if myTrans then
    self:CameraFaceTo(myTrans, ViewPort, Rotation, 0, nil, func)
  end
end

function MountLotteryView:OnExit()
  self:ResetView()
end

function MountLotteryView:ResetView()
  self:CameraReset()
  self.stopUpdate = true
  MountLotteryProxy.Instance:RemoveNPC()
  MountLotteryProxy.Instance:RemoveCards()
  MountLotteryProxy.Instance:Clear()
  self.exited = true
  if self.cameraLT ~= nil then
    self.cameraLT:Destroy()
    self.cameraLT = nil
  end
  FunctionSceneFilter.Me():EndFilter(GameConfig.FilterType.PhotoFilter.Self)
  Game.GUISystemManager:ClearMonoUpdateFunction(self)
  ServiceWeatherProxy.Instance:SetWeatherEnable(true)
  Game.SetWeatherAnimationEnable(true)
  PictureManager.Instance:UnLoadUI("mounts_bg_popo", self.tipbg)
  FunctionBGMCmd.Me():StopUIBgm()
  if self.extraData then
    ReusableTable.DestroyAndClearTable(self.extraData)
  end
end

function MountLotteryView:OnDestroy()
  if not self.exited then
    self:ResetView()
  end
end

function MountLotteryView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self.isLocked = true
  self.isinit = false
  self:SetCat()
  self.currentCost = {}
  self.stopUpdate = false
end

function MountLotteryView:FindObjs()
  self.moneyRoot = self:FindGO("MoneyRoot")
  self.money = self:FindGO("Money", self.moneyRoot):GetComponent(UILabel)
  self.lotteryPanel = self:FindGO("LotteryPanel")
  self.coverPanel = self:FindGO("CoverPanel")
  self.togglegrid = self:FindGO("ToggleRoot"):GetComponent(UIGrid)
  self.togCtl = UIGridListCtrl.new(self.togglegrid, MountItemTabCell, "MountItemTabCell")
  self.togCtl:AddEventListener(MouseEvent.MouseClick, self.ClickTab, self)
  self.itemsv = self:FindGO("ItemScrollview"):GetComponent(UIScrollView)
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
  self.lotteryBtn = self:FindGO("LotteryBtn")
  self.lotteryBtnLabel = self:FindGO("Label", self.lotteryBtn):GetComponent(UILabel)
  self.lotterycost = self:FindGO("Cost"):GetComponent(UILabel)
  self.lotteryIcon = self:FindGO("LotteryIcon", self.lotteryBtn):GetComponent(UISprite)
  self.focusFrame = self:FindGO("ClickArea")
  local detailContainer = self:FindGO("DetailContainer")
  local wrapConfig = ReusableTable.CreateTable()
  TableUtility.TableClear(wrapConfig)
  wrapConfig.wrapObj = detailContainer
  wrapConfig.pfbNum = 7
  wrapConfig.cellName = "MountLotteryDetailCell"
  wrapConfig.control = MountLotteryDetailCell
  wrapConfig.dir = 1
  self.detailHelper = WrapCellHelper.new(wrapConfig)
  self.detailHelper:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  ReusableTable.DestroyAndClearTable(wrapConfig)
  self.Background = self:FindGO("CoverBackground"):GetComponent(UITexture)
  self.currency = self:FindGO("currency"):GetComponent(UISprite)
  self.token = self:FindGO("token"):GetComponent(UISprite)
  self.currencyLabel = self:FindGO("currencyLabel"):GetComponent(UILabel)
  self.tokenLabel = self:FindGO("tokenLabel"):GetComponent(UILabel)
  self.tip = self:FindGO("Tip")
  self.tiplabel = self:FindGO("Label", self.tip):GetComponent(UILabel)
  self.tipbg = self:FindGO("TipTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("mounts_bg_popo", self.tipbg)
  self.mask1 = self:FindGO("Mask1"):GetComponent(TweenAlpha)
  self.mask1:ResetToBeginning()
  self.closeBtn = self:FindGO("CloseButton")
  self.extraBonusRoot = self:FindGO("ExtraBonusRoot"):GetComponent(UIWidget)
  self:PlayUIEffect(EffectMap.UI.BoliBubble_paopao, self.extraBonusRoot, false, function(obj, args, effect)
    self.bubblePfb = effect
    self.boliTexture = self:FindGO("BoliTexture", self.bubblePfb):GetComponent(UISprite)
    self:AddClickEvent(self.boliTexture.gameObject, function()
      self:GetExtraBonus()
    end)
    self.countlabel = self:FindGO("Label", self.bubblePfb):GetComponent(UILabel)
  end)
  self.buySkinBtn = self:FindGO("BuySkin")
  self.exchangeBtn = self:FindGO("Exchange")
  self.exchangeBtn:SetActive(false)
  self.buySkinBtn:SetActive(false)
  self.skinTip = self:FindGO("skinTip")
  local skinlabel = self:FindGO("skinlabel"):GetComponent(UILabel)
  skinlabel.text = ZhString.MountLottery_SkinTip
  self.skinTip:SetActive(false)
  self.toggleExchange = false
  self:HideExtraBonus()
  self.lotteryTenBtn = self:FindGO("LotteryTenBtn")
  self.lotteryTenCost = self:FindGO("Cost", self.lotteryTenBtn):GetComponent(UILabel)
  self.currentCount = self:FindGO("currentCount"):GetComponent(UILabel)
  self.currentCount.text = ""
  self.btnGrid = self:FindGO("BtnGrid"):GetComponent(UIGrid)
  self.lotteryTenIcon = self:FindGO("LotteryIcon", self.lotteryTenBtn):GetComponent(UISprite)
  local moneyIcon = self:FindGO("MoneyIcon", self.moneyRoot):GetComponent(UISprite)
  local money = Table_Item[GameConfig.MoneyId.Lottery]
  if money and money.Icon then
    IconManager:SetItemIcon(money.Icon, moneyIcon)
    IconManager:SetItemIcon(money.Icon, self.lotteryIcon)
    IconManager:SetItemIcon(money.Icon, self.lotteryTenIcon)
  end
end

function MountLotteryView:AddEvts()
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
  self:AddClickEvent(self.lotteryBtn, function()
    if not self.call_lock then
      if self.toggleExchange then
        local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.MountLottery)
        local flag = MountLotteryProxy.Instance.isFinished
        if MyselfProxy.Instance:GetLottery() < self.currentCost[2] and self.currentCost[1] == GameConfig.MoneyId.Lottery then
          MsgManager.ConfirmMsgByID(3551, function()
            FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
          end)
        else
          self:Hide(self.closeBtn)
          self.skipanim = true
          ServiceItemProxy.Instance:CallExecRideLotteryCmd(self.RideConfig.LastBuySkin, not flag, isSkip)
        end
      else
        local round = MountLotteryProxy.Instance:GetCurrentRound()
        local lotteryConfig = self.RideConfig.LotteryCost[round]
        if MountLotteryProxy.Instance.isNewRound and lotteryConfig.FirstFree == 1 then
          self:Lottery()
        else
          OverseaHostHelper:GachaUseComfirm(self.lotterycost.text, function()
            self:Lottery()
          end)
        end
      end
    else
      MsgManager.ShowMsgByID(49)
    end
  end)
  self:AddClickEvent(self:FindGO("DetailBtn"), function()
    self:ShowDetail(true)
  end)
  self:AddClickEvent(self:FindGO("DetailReturnBtn"), function()
    self:ShowDetail(false)
  end)
  self:AddDragEvent(self.focusFrame, function(obj, delta)
    local cr = Game.GameObjectUtil:DeepFind(self.npcmodel.completeTransform.gameObject, "CardRoot")
    if not Slua.IsNull(cr) and MountLotteryProxy.Instance.isCreate then
      self.startRotate = true
      self.currentAngleY = cr.transform.localRotation.eulerAngles.y
      self.currentAngleX = cr.transform.localRotation.eulerAngles.x
      self.currentAngleZ = cr.transform.localRotation.eulerAngles.z
      self.targetAngleY = self.currentAngleY - delta.x
    end
  end)
  self:AddClickEvent(self.focusFrame, function(obj, delta)
    local ray = Camera.main:ScreenPointToRay(Input.mousePosition)
    local hits = Physics.RaycastAll(ray, 10000, 1 << Game.ELayer.Accessable)
    if hits then
      for i = 1, #hits do
        local obj = hits[i].collider.gameObject:GetComponent(LuaGameObjectClickable)
        if Slua.IsNull(obj) == false then
          tempNum = tonumber(obj.gameObject.name)
          if tempNum == self.RideConfig.LastBuySkin then
            self:OnClickGiftModel()
            break
          end
          self.currentCard = tempNum
          MountLotteryProxy.Instance:OnClickCard(self.currentCard)
          break
        end
      end
    end
  end)
  local help = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(2200, help)
  self:AddClickEvent(self.buySkinBtn, function()
    self.exchangeBtn:SetActive(true)
    self.toggleExchange = true
    self.buySkinBtn:SetActive(false)
    self.lotteryBtnLabel.text = ZhString.MountLottery_Buy
    self.lotterycost.text = self.RideConfig.SkinCostItem[2]
    local iconsp = Table_Item[self.RideConfig.SkinCostItem[1]].Icon
    IconManager:SetItemIcon(iconsp, self.lotteryIcon)
    MountLotteryProxy.Instance:HideCards()
    MountLotteryProxy.Instance:FinishLottery()
    MountLotteryProxy.Instance:SetGift(true)
  end)
  self:AddClickEvent(self.exchangeBtn, function()
    self.buySkinBtn:SetActive(true)
    self.toggleExchange = false
    self.exchangeBtn:SetActive(false)
    self:UpdateTip()
    self:UpdateCost()
    MountLotteryProxy.Instance:ResetToNormal()
    MountLotteryProxy.Instance:SetGift(false)
    MountLotteryProxy.Instance:LoadCards()
  end)
  self:AddClickEvent(self.lotteryTenBtn, function()
    if not self.call_lock then
      OverseaHostHelper:GachaUseComfirm(self.lotteryTenCost.text, function()
        self:LotteryTen()
      end)
    end
  end)
end

local selfRotate = 10
local selfDeltaAngle = 10
local effectPath = "Common/flowinglight_tail"
local deltaAngle
local tempRotX = 1
local tempRotY = 1
local tempRotZ = 1
local PartIndexBody = Asset_Role.PartIndex.Body

function MountLotteryView:MonoUpdate(time, deltaTime)
  if self.stopUpdate then
    return
  end
  if not Slua.IsNull(self.npcmodel) and MountLotteryProxy.Instance.isCreate then
    local cr = Game.GameObjectUtil:DeepFind(self.npcmodel.completeTransform.gameObject, "CardRoot")
    if self.isLocked and self.npcmodel ~= nil and self.npcmodel:GetPartObject(PartIndexBody) ~= nil and self.isinit then
      MountLotteryProxy.Instance:StartSetting()
      self.isLocked = false
    end
    if Slua.IsNull(cr) then
      return
    elseif self.startRotate and not NumberUtility.AlmostEqualAngle(self.currentAngleY, self.targetAngleY) then
      deltaAngle = self.turnspeed * deltaTime
      self.currentAngleY = NumberUtility.MoveTowardsAngle(self.currentAngleY, self.targetAngleY, deltaAngle)
      LuaVector3.Better_Set(tempV3, self.currentAngleX, self.currentAngleY, self.currentAngleZ)
      LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
      cr.transform.localRotation = tempRot
      if NumberUtility.AlmostEqualAngle(self.currentAngleY, self.targetAngleY) then
        self.currentAngleY = self.targetAngleY
        self.startRotate = false
      end
    else
      tempRotX = cr.transform.localRotation.eulerAngles.x
      tempRotY = cr.transform.localRotation.eulerAngles.y
      tempRotZ = cr.transform.localRotation.eulerAngles.y
      LuaVector3.Better_Set(tempV3, 0, tempRotY - 0.5, 0)
      LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
      cr.transform.localRotation = tempRot
    end
  end
end

function MountLotteryView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.ItemQueryRideLotteryInfo, self.HandleUpdateLotteryInfo)
  self:AddListenEvt(MountLotteryEvent.NewRound, self.UpdateNewRound)
  self:AddListenEvt(MountLotteryEvent.FinishRound, self.DisplayFinishRound)
  self:AddListenEvt(MountLotteryEvent.EndAll, self.EndAll)
  self:AddListenEvt(ServiceEvent.ItemRideLotteyPickInfoCmd, self.UpdateExtraBonus)
  self:AddListenEvt(MountLotteryEvent.BackToCards, self.BackToCards)
  self:AddListenEvt(LotteryEvent.MagicPictureComplete, self.HandlePicture)
  self:AddListenEvt(MountLotteryEvent.ActivityClose, self.CloseSelf)
end

function MountLotteryView:InitConfig(note)
  if not note or not note.body then
    return false
  end
  local linegroup = self:GetCurrentLineGroup()
  if not linegroup then
    return false
  end
  local batch = note.body.batch
  local configkey = linegroup * 10 + batch
  if not configkey then
    return false
  end
  local configIndex = GameConfig.RideLotteryConfig[configkey]
  if not configIndex then
    return false
  end
  self.RideConfig = RideConfig[configIndex]
  if not self.RideConfig then
    return false
  end
  self.turnspeed = self.RideConfig.turnspeed or 200
  currentRound = MountLotteryProxy.Instance.currentRound
  self.batchCount = self.RideConfig.BatchCount[currentRound]
  FunctionBGMCmd.Me():PlayUIBgm(self.RideConfig.BGM, 0)
  self.tiplabel.text = self.RideConfig.TokenTip
  self.hideExtra = self.RideConfig.HideExtraBonus
  local leftcount = MountLotteryProxy.Instance:GetCurrentRoundLeft()
  self.currentCount.text = string.format(ZhString.MountLottery_CountTip, TabConfig[currentRound], leftcount)
  return true
end

function MountLotteryView:GetCurrentLineGroup()
  local serverData = FunctionLogin.Me():getCurServerData()
  if not serverData then
    return false
  end
  return serverData.linegroup or 1
end

function MountLotteryView:InitShow()
  self:UpdateMoney()
  self:UpdateSkip()
  if not self.tabDatas then
    self.tabDatas = {}
  else
    TableUtility.TableClear(self.tabDatas)
  end
  for i = 1, #TabConfig do
    local data = {
      index = i,
      text = TabConfig[i]
    }
    table.insert(self.tabDatas, data)
  end
  self.togCtl:ResetDatas(self.tabDatas)
  self:ShowDetail(true)
  self.currentSelect = MountLotteryProxy.Instance:GetCurrentRound()
  self:UpdateCost()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self:UpdateTip()
  local cells = self.togCtl:GetCells()
  if cells then
    for k, v in pairs(cells) do
      if k == self.currentSelect then
        v:SetTog(true)
      else
        v:SetTog(false)
      end
    end
  end
  self:SetItemList()
  self:ShowDetail(false)
  self.lastClick = nil
  if self.hideExtra then
    self:HideExtraBonus()
  end
end

function MountLotteryView:UpdateTip()
  local ticketNum = BagProxy.Instance:GetAllItemNumByStaticID(self.RideConfig.DiscountTicket)
  local icon = Table_Item[self.RideConfig.DiscountTicket].Icon
  local moneyIcon = Table_Item[GameConfig.MoneyId.Lottery].Icon
  if ticketNum and 0 < ticketNum then
    self:Show(self.tip)
    IconManager:SetItemIcon(icon, self.currency)
    IconManager:SetItemIcon(moneyIcon, self.token)
    self.currencyLabel.text = "X" .. tostring(ticketNum)
    self.tokenLabel.text = "X" .. tostring(ticketNum)
  else
    self:Hide(self.tip)
  end
end

function MountLotteryView:UpdateMoney()
  if self.money ~= nil then
    self.money.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
  end
end

function MountLotteryView:HandleItemUpdate(note)
end

function MountLotteryView:UpdateCost()
  local round = MountLotteryProxy.Instance:GetCurrentRound()
  local lotteryConfig = self.RideConfig.LotteryCost[round]
  local cost = lotteryConfig.cost or {}
  local ticketNum = BagProxy.Instance:GetAllItemNumByStaticID(self.RideConfig.DiscountTicket)
  local unitprice = cost[2] - ticketNum > 0 and cost[2] - ticketNum or 0
  self.lotteryBtnLabel.text = ZhString.MountLottery_Lott
  show = MountLotteryProxy.Instance.needLotteryTenBtn
  local leftcount = MountLotteryProxy.Instance:GetCurrentRoundLeft()
  self.currentCount.text = string.format(ZhString.MountLottery_CountTip, TabConfig[currentRound], leftcount)
  local totalprice = 0 < cost[2] * 10 - ticketNum and cost[2] * 10 - ticketNum or 0
  if MountLotteryProxy.Instance.isNewRound and lotteryConfig.FirstFree == 1 then
    self.lotterycost.text = ZhString.MountLottery_Free
    self.currentCost[2] = 0
    self:Hide(self.tip)
    self.lotteryTenBtn:SetActive(false)
  else
    self.lotterycost.text = tostring(unitprice)
    self.currentCost[2] = cost[2] - ticketNum > 0 and cost[2] - ticketNum or 0
    self.lotteryTenCost.text = totalprice
    self:UpdateTip()
    self.lotteryTenBtn:SetActive(show)
  end
  self.btnGrid:Reposition()
  self.currentCost[1] = cost[1]
end

function MountLotteryView:ClickTab(cell)
  local data = cell.data
  if data == nil then
    return
  end
  self.currentSelect = data.index
  self:SetItemList()
end

function MountLotteryView:HandleUpdateLotteryInfo(note)
  if not self.isinit then
    if self:InitConfig(note) then
      self.isinit = true
    end
    self:InitShow()
  end
  currentRound = MountLotteryProxy.Instance.currentRound
  if note and note.body.update == false then
    self:SetItemList()
  else
    self.batchCount = self.RideConfig.BatchCount[currentRound]
    self:AutoRefillCard()
    self.currentCard = nil
    local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.MountLottery)
    self.showdata = note and note.body and note.body.skinid
    if not self.showdata or self.showdata == 0 then
      if #note.body.infos > 1 then
        self:ShowLotteryResult(note.body.infos)
        self.call_lock = false
        self:Show(self.closeBtn)
      else
        self.showdata = note.body.infos[1].itemid
        if MountLotteryProxy.Instance.skipanimation then
          self:ShowAward()
          self.call_lock = false
          self:Show(self.closeBtn)
        elseif not isSkip and not self.skipanim then
          MountLotteryProxy.Instance:PlayLotteryAnimation()
          TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
            self:ShowAward()
            self.call_lock = false
            self:Show(self.closeBtn)
          end, self)
        else
          TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
            self:ShowAward()
            self.call_lock = false
            self:Show(self.closeBtn)
          end, self)
        end
      end
    else
      TimeTickManager.Me():CreateOnceDelayTick(6000, function(owner, deltaTime)
        self:ShowAward()
        self:Show(self.closeBtn)
      end, self)
      MountLotteryProxy.Instance:PlayBuyGiftAnim()
    end
    ServiceItemProxy.Instance:CallQueryRideLotteryInfo()
  end
  if MountLotteryProxy.Instance.showGift then
    self.lotteryBtnLabel.text = ZhString.MountLottery_Buy
    self.lotterycost.text = self.RideConfig.SkinCostItem[2]
    local iconsp = Table_Item[self.RideConfig.SkinCostItem[1]].Icon
    IconManager:SetItemIcon(iconsp, self.lotteryIcon)
    self.currentCost = self.RideConfig.SkinCostItem
    self:Hide(self.tip)
    self.skinTip:SetActive(true)
  else
    self:UpdateCost()
  end
  local show = MountLotteryProxy.Instance:CheckShowSkin()
  if show then
    self.buySkinBtn:SetActive(true)
    self.exchangeBtn:SetActive(false)
    self.toggleExchange = false
    self.skinTip:SetActive(true)
  else
    self.buySkinBtn:SetActive(false)
    self.exchangeBtn:SetActive(false)
    self.skinTip:SetActive(false)
  end
end

function MountLotteryView:Show(target)
  if not Slua.IsNull(target) then
    MountLotteryView.super.Show(self, target)
  end
end

function MountLotteryView:Hide(target)
  if not Slua.IsNull(target) then
    MountLotteryView.super.Hide(self, target)
  end
end

function MountLotteryView:EndAll()
  self:Hide(self.lotteryBtn)
  MountLotteryProxy.Instance:HideCards()
  MountLotteryProxy.Instance:PlayDone()
end

function MountLotteryView:SetItemList()
  local datas = MountLotteryProxy.Instance:GetLotteryItemsByIndex(self.currentSelect)
  if not datas then
    return
  end
  table.sort(datas, function(l, r)
    return l.id < r.id
  end)
  self.detailHelper:UpdateInfo(datas)
  self.detailHelper:ResetPosition()
end

function MountLotteryView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function MountLotteryView:JumpZenyShop()
  FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
end

function MountLotteryView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(SKIPTYPE.MountLottery, self.skipBtn, NGUIUtil.AnchorSide.Top, {120, 50})
end

function MountLotteryView:UpdateSkip()
  local isfirst = FunctionFirstTime.me:IsFirstTime(FunctionFirstTime.MountLottery)
  self.skipBtn.gameObject:SetActive(not isfirst)
end

function MountLotteryView:ShowDetail(isShow)
  self.lotteryPanel:SetActive(isShow)
  self.coverPanel:SetActive(not isShow)
end

function MountLotteryView:Lottery()
  if self.lastClick == self.currentCard and self.lastClick then
    return
  end
  if not self.currentCard then
    self:RandomClick()
  end
  local isfinish = MountLotteryProxy.Instance.totalGot > MountLotteryProxy.Instance.Maximum
  local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.MountLottery)
  local choose = MountLotteryProxy.Instance:GetChooseIDs()
  local cflag = 0
  local randomlist = {}
  currentRound = MountLotteryProxy.Instance.currentRound
  self.batchCount = self.RideConfig.BatchCount[currentRound]
  if self.batchCount > 13 then
    for i = 1, self.batchCount do
      if choose[i] then
        cflag = cflag + 1
      end
    end
  end
  if self.currentCard and not isfinish then
    if self.currentCost then
      if MyselfProxy.Instance:GetLottery() < self.currentCost[2] and self.currentCost[1] == GameConfig.MoneyId.Lottery then
        MountLotteryProxy.Instance:ResetToNormal()
        MsgManager.ConfirmMsgByID(3551, function()
          FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
        end)
      else
        self:Hide(self.closeBtn)
        if self.batchCount - cflag < 12 then
          ServiceItemProxy.Instance:CallExecRideLotteryCmd(self.currentCard, isfinish, isSkip)
        else
          ServiceItemProxy.Instance:CallExecRideLotteryCmd(self.batchCount - cflag, isfinish, isSkip)
        end
        self.lastClick = self.currentCard
        self.call_lock = true
      end
    end
  elseif MountLotteryProxy.Instance.showGift then
    local flag = MountLotteryProxy.Instance.isFinished
    if MyselfProxy.Instance:GetLottery() < self.currentCost[2] and self.currentCost[1] == GameConfig.MoneyId.Lottery then
      MsgManager.ConfirmMsgByID(3551, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
      end)
    else
      self:Hide(self.closeBtn)
      self.skipanim = true
      ServiceItemProxy.Instance:CallExecRideLotteryCmd(self.RideConfig.LastBuySkin, not flag, isSkip)
    end
  else
    MsgManager.ShowMsgByIDTable(38300)
  end
end

function MountLotteryView:SetCat()
  self.npcmodel = MountLotteryProxy.Instance:LoadNPC(LuckyCatID)
end

function MountLotteryView:UpdateNewRound()
  self:ResetCardSet()
  local cells = self.togCtl:GetCells()
  if cells then
    for k, v in pairs(cells) do
      if k == self.currentSelect then
        v:SetTog(true)
      else
        v:SetTog(false)
      end
    end
  end
  MountLotteryProxy.Instance:SwitchRound()
end

function MountLotteryView:ResetCardSet()
  MountLotteryProxy.Instance:ResetCards()
  self.currentSelect = MountLotteryProxy.Instance:GetCurrentRound()
  self:SetItemList()
end

function MountLotteryView:OnClickGiftModel()
  local data = ReusableTable.CreateTable()
  local sdata = ItemData.new("LotteryItem", self.RideConfig.LastBuySkin)
  data.itemdata = sdata
  data.funcConfig = {}
  TipManager.Instance:ShowItemFloatTip(data, self.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  ReusableTable.DestroyAndClearTable(data)
end

function MountLotteryView:ShowAward()
  local sdata = ItemData.new("LotteryItem", self.showdata)
  local args = ReusableTable.CreateTable()
  args.disableMsg = true
  args.leftBtnText = ZhString.FloatAwardView_IntoPackage
  args.hideEquipBtn = true
  FloatAwardView.addItemDatasToShow({sdata}, args)
  ReusableTable.DestroyAndClearTable(args)
end

function MountLotteryView:DisplayFinishRound()
  self:Hide(self.tip)
  MountLotteryProxy.Instance:FinishLottery()
end

function MountLotteryView:CloseSelf()
  MountLotteryProxy.Instance:ResetToNormal()
  self.mask1:ResetToBeginning()
  self.mask1:PlayForward()
  self:CameraReset()
  TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.super.CloseSelf(self)
  end, self)
end

function MountLotteryView:UpdateExtraBonus(note)
  if self.hideExtra then
    return
  end
  if note and note.body then
    if not self.extraData then
      self.extraData = ReusableTable.CreateTable()
    end
    self.extraData.totalnum = note.body.totalnum
    self.extraData.donenum = note.body.donenum
    self.extraData.eItemid = note.body.itemid
    self.extraData.eItemNum = note.body.itemnum
    self.extraData.isDone = note.body.done
    if not self.extraData.isDone then
      self:ShowExtraBonus()
    else
      self:HideExtraBonus()
    end
  end
end

function MountLotteryView:HideExtraBonus()
  self.extraBonusRoot.gameObject:SetActive(false)
end

function MountLotteryView:ShowExtraBonus()
  if self.extraData and not self.extraData.isDone and self.boliTexture ~= nil and self.countlabel ~= nil then
    local id1 = self.extraData.eItemid
    local icon = Table_Item[id1] and Table_Item[id1].Icon or ""
    IconManager:SetItemIcon(icon, self.boliTexture)
    self.boliTexture:MakePixelPerfect()
    self.countlabel.text = string.format("%d/%d", self.extraData.donenum, self.extraData.totalnum)
    self.extraBonusRoot.gameObject:SetActive(true)
  else
    self.extraBonusRoot.gameObject:SetActive(false)
  end
end

function MountLotteryView:GetExtraBonus()
  if not self.extraData then
    return
  end
  if not self.extraData.isDone and self.extraData.donenum >= self.extraData.totalnum then
    ServiceItemProxy.Instance:CallRideLotteyPickItemCmd()
  else
    local itemData = ItemData.new("", self.extraData.eItemid)
    self:ShowAwardItemTip(itemData)
  end
end

function MountLotteryView:ShowAwardItemTip(itemData)
  local data = {
    itemdata = itemData,
    funcConfig = {},
    noSelfClose = false
  }
  self:ShowItemTip(data, self.extraBonusRoot, NGUIUtil.AnchorSide.Right, {210, -220})
end

function MountLotteryView:BackToCards()
  self.buySkinBtn:SetActive(false)
  self.toggleExchange = false
  self.exchangeBtn:SetActive(false)
  self:UpdateTip()
  self:UpdateCost()
  MountLotteryProxy.Instance:ResetToNormal()
  MountLotteryProxy.Instance:SetGift(false)
  MountLotteryProxy.Instance:LoadCards()
end

function MountLotteryView:AutoRefillCard()
  if self.batchCount == 13 then
    return
  end
  local choose = MountLotteryProxy.Instance:GetChooseIDs()
  local cflag = 0
  local randomlist = {}
  for i = 1, self.batchCount do
    if choose[i] then
      cflag = cflag + 1
    end
  end
  if self.currentCard and cflag < 13 then
    MountLotteryProxy.Instance:AutoRefillCard(self.currentCard)
  end
end

function MountLotteryView:RandomClick()
  if MountLotteryProxy.Instance.showGift then
    self.currentCard = nil
  else
    local choose = MountLotteryProxy.Instance:GetChooseIDs()
    local randomlist = {}
    for i = 13, 1, -1 do
      if not choose[i] then
        table.insert(randomlist, i)
      end
    end
    self.currentCard = randomlist[#randomlist]
    MountLotteryProxy.Instance:OnClickCard(self.currentCard)
  end
end

function MountLotteryView:HandlePicture(note)
  local data = note.body
  if data and self.picUrl == data.picUrl then
    self:UpdatePicture(data.bytes)
  end
end

function MountLotteryView:UpdatePicUrl()
  local list = ActivityEventProxy.Instance:GetLotteryBanner(8)
  if list ~= nil and 0 < #list then
    local picUrl = list[#list]:GetPath()
    if self.picUrl ~= picUrl then
      self.picUrl = picUrl
      local bytes = self:UpdateDownloadPic()
      if bytes then
        self:UpdatePicture(bytes)
      end
    end
  end
end

function MountLotteryView:UpdateDownloadPic()
  if self.picUrl ~= nil then
    return LotteryProxy.Instance:DownloadMagicPicFromUrl(self.picUrl)
  end
end

function MountLotteryView:UpdatePicture(bytes)
  local texture = Texture2D(0, 0, TextureFormat.RGB24, false)
  local ret = ImageConversion.LoadImage(texture, bytes)
  if ret then
    GameObject.DestroyImmediate(self.Background.mainTexture, true)
    self.Background.mainTexture = texture
  end
end

function MountLotteryView:LotteryTen()
  if MountLotteryProxy.Instance:GetCurrentRoundLeft() < 11 then
    return
  end
  if self.lastClick then
    MountLotteryProxy.Instance:OnClickCard(self.lastClick)
  end
  local isfinish = MountLotteryProxy.Instance.totalGot > MountLotteryProxy.Instance.Maximum
  local isSkip = LocalSaveProxy.Instance:GetSkipAnimation(SKIPTYPE.MountLottery)
  local choose = MountLotteryProxy.Instance:GetChooseIDs()
  local cflag = 0
  local tenlist = {}
  currentRound = MountLotteryProxy.Instance.currentRound
  self.batchCount = self.RideConfig.BatchCount[currentRound]
  if self.batchCount > 13 then
    for i = 1, self.batchCount do
      if choose[i] then
        cflag = cflag + 1
      end
    end
  end
  cflag = self.batchCount - cflag
  for i = 1, 11 do
    table.insert(tenlist, cflag)
    cflag = cflag - 1
  end
  if self.currentCost then
    local lotteryConfig = self.RideConfig.LotteryCost[currentRound]
    local cost = lotteryConfig.cost or {}
    local count = 10
    if MountLotteryProxy.Instance.isNewRound and lotteryConfig.FirstFree == 1 then
      count = 9
    end
    local ticketNum = BagProxy.Instance:GetAllItemNumByStaticID(self.RideConfig.DiscountTicket)
    if MyselfProxy.Instance:GetLottery() + ticketNum < cost[2] * count and cost[1] == GameConfig.MoneyId.Lottery then
      MountLotteryProxy.Instance:ResetToNormal()
      MsgManager.ConfirmMsgByID(3551, function()
        FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit)
      end)
    else
      self:Hide(self.closeBtn)
      ServiceItemProxy.Instance:CallExecRideLotteryCmd(1, false, isSkip, true, tenlist)
      self.call_lock = true
    end
  end
end

function MountLotteryView:ShowLotteryResult(updateinfos)
  if not updateinfos or #updateinfos == 0 then
    return
  end
  local itemlist = {}
  for i = 1, #updateinfos do
    local entry = ItemData.new("LotteryItem", updateinfos[i].itemid)
    table.insert(itemlist, entry)
  end
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.MountLotteryResultView,
    viewdata = itemlist
  })
end
