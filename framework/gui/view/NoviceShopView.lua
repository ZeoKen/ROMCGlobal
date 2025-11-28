autoImport("NoviceShopItemCell")
autoImport("NoviceShopRewardCell")
NoviceShopView = class("NoviceShopView", ContainerView)
NoviceShopView.ViewType = UIViewType.NormalLayer
local proxy
local DepositConfig = GameConfig.FirstDeposit
local fovMin, fovMax = 35, 65
local cameraConfig = {
  position = LuaVector3.New(1.28, 1.18, -2.34),
  rotation = LuaQuaternion.Euler(7.12, -28.5, 0),
  fieldOfView = 45,
  backScale = LuaVector3.New(16, 9, 1)
}

function NoviceShopView:Init()
  if not proxy then
    proxy = NoviceShopProxy.Instance
  end
  self:InitObjEvents()
  self:AddViewEvts()
  self:InitView()
end

function NoviceShopView:OnEnter()
  NoviceShopView.super.OnEnter(self)
  self:RequestQueryChargeCnt()
  RedTipProxy.Instance:SeenNew(NoviceShopProxy.RedTipID)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDate, self, 1)
end

function NoviceShopView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function NoviceShopView:OnExit()
  NoviceShopView.super.OnExit(self)
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function NoviceShopView:InitObjEvents()
  self.titleLabel = self:FindComponent("Title", UILabel, self:FindGO("BgGroup"))
  self.moneyGroupGO = self:FindGO("MoneyGroup")
  local moneyIcon = self:FindComponent("MoneyIcon", UISprite, self.moneyGroupGO)
  local moneyIconName = Table_Item[GameConfig.MoneyId.Lottery].Icon
  IconManager:SetItemIcon(moneyIconName, moneyIcon)
  self.moneyLabel = self:FindComponent("MoneyLabel", UILabel, self.moneyGroupGO)
  self.addMoneyGO = self:FindGO("AddMoneyButton", self.moneyGroupGO)
  self:AddClickEvent(self.addMoneyGO, function()
    MsgManager.ConfirmMsgByID(3551, function()
      FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TDeposit, FunctionNewRecharge.InnerTab.Deposit_ROB)
    end)
  end)
  self.itemGroupGO = self:FindGO("ItemGroup")
  self.itemListCtrl = ListCtrl.new(self:FindComponent("Container", UIGrid, self.itemGroupGO), NoviceShopItemCell, "NoviceShopItemCell")
  self.itemListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnItemCellClicked, self)
  self.itemListCells = self.itemListCtrl:GetCells()
  self.periodGroupGO = self:FindGO("PeriodGroup")
  self.periodTitle = self:FindGO("PeriodTitle"):GetComponent(UILabel)
  self.periodTitle.text = ZhString.NoviceShop_PeriodLabel
  self.periodLabel = self:FindGO("PeriodLabel", self.periodGroupGO):GetComponent(UILabel)
  self.helpBtnGO = self:FindGO("HelpButton", self.periodGroupGO)
  self:TryOpenHelpViewById(35041, nil, self.helpBtnGO, self:CheckValidTime())
  self.shopView = self:FindGO("ShopView")
  self.shopNormalMark = self:FindGO("shopNormalMark")
  self.shopTab = self:FindGO("shopTab"):GetComponent(UIToggle)
  EventDelegate.Set(self.shopTab.onChange, function()
    if self.shopTab.value then
      self:ClearView()
      self:ShowShopList(true)
      self:ShowRewardView(false)
    end
    self.rewardNormalMark:SetActive(self.shopTab.value)
    self.shopNormalMark:SetActive(not self.shopTab.value)
  end)
  self.rewardCells = {}
  for i = 1, 6 do
    local cellGO = self:FindGO("NoviceShopRewardCell" .. i)
    self.rewardCells[i] = NoviceShopRewardCell.new(cellGO)
    self.rewardCells[i]:AddEventListener(MouseEvent.MouseClick, self.OnRewardCellClicked, self)
  end
  self.rewardView = self:FindGO("RewardView")
  self.rewardNormalMark = self:FindGO("rewardNormalMark")
  self.rewardTab = self:FindGO("rewardTab"):GetComponent(UIToggle)
  EventDelegate.Set(self.rewardTab.onChange, function()
    if self.rewardTab.value then
      self:ClearView()
      self:ShowShopList(false)
      self:ShowRewardView(true)
    end
    self.shopNormalMark:SetActive(self.rewardTab.value)
    self.rewardNormalMark:SetActive(not self.rewardTab.value)
  end)
  if proxy:UpdateaRewardTip() then
    redlog("UpdateRedTip")
    self:RegisterRedTipCheck(NoviceShopProxy.RedTipID, self.rewardTab.gameObject, 42)
  else
    redlog("RemoveWholeTip")
  end
  self.previewTexture = self:FindGO("previewTexture"):GetComponent(UITexture)
  self:AddDragEvent(self.previewTexture.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self.fovScrollBar = self:FindGO("FovScrollBar")
  self.fovScrollBarCtrl = self:FindComponent("BackGround", UICustomScrollBar, self.fovScrollBar)
  EventDelegate.Add(self.fovScrollBarCtrl.onChange, function()
    if not self.fovScrollBarCtrl.isDragging or not self.uiModelCell then
      return
    end
    local value = 1 - self.fovScrollBarCtrl.value
    cameraConfig.fieldOfView = (fovMax - fovMin) * value + fovMin
    self.uiModelCell:_SetCameraConfig(cameraConfig)
  end)
  local help = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(35237, help)
  self.depositGroupGO = self:FindGO("DepositGroup")
  self.depositLabel = self:FindGO("DepositLabel"):GetComponent(UILabel)
  local mask = self:FindGO("BlackMask"):GetComponent(UISprite)
  mask.height = Screen.height * 2
  mask.width = Screen.width * 2
end

function NoviceShopView:UpdateDeposit()
  if BranchMgr.IsChina() then
    self.depositLabel.text = string.format(ZhString.NoviceShop_CurrentAccumulated, proxy:GetCurrencyType(), proxy:GetAccumulatedDeposit())
  else
    self.depositLabel.text = string.format(ZhString.NoviceShop_CurrentAccumulated_Oversea, proxy:GetCurrencyType(), proxy:GetAccumulatedDeposit())
  end
end

function NoviceShopView:CheckValidTime()
  if not proxy:CheckValidTime() then
    MsgManager.ShowMsgByID(40973)
    return false
  end
  return true
end

function NoviceShopView:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function NoviceShopView:ClearView()
end

function NoviceShopView:ShowShopList(b)
  self.shopView:SetActive(b == true)
  if b then
    local items = proxy:GetShopItems()
    self.itemListCtrl:ResetDatas(items)
  end
end

function NoviceShopView:ShowRewardView(b)
  self.rewardView:SetActive(b == true)
  if b then
    self:UpdateRewardCells()
    self:UpdateModel()
  end
end

function NoviceShopView:UpdateRewardCells()
  for i = 1, 6 do
    self.rewardCells[i]:SetData(i)
  end
end

function NoviceShopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnMyDataChange)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RefreshView)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdataShopGotItem)
  self:AddListenEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.RefreshView)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshView)
end

function NoviceShopView:RecvQueryShopConfig()
  self:InitView()
end

function NoviceShopView:UpdataShopGotItem()
  self:InitView()
end

function NoviceShopView:InitView()
  self:UpdateTitle()
  self:UpdateMoney()
  self:UpdateDeposit()
  self:UpdateDate()
  self.shopTab.value = true
  self:ShowShopList(true)
  self:ShowRewardView(false)
  self.rewardNormalMark:SetActive(self.shopTab.value)
  self.shopNormalMark:SetActive(not self.shopTab.value)
end

function NoviceShopView:UpdateTitle()
  self.titleLabel.text = DepositConfig and DepositConfig.ActivityName
end

function NoviceShopView:RefreshView()
  if self.shopTab.value then
    self:ShowShopList(true)
    self:ShowRewardView(false)
  elseif self.rewardTab.value then
    self:UpdateRewardCells()
  end
end

function NoviceShopView:UpdateMoney()
  self.moneyLabel.text = StringUtil.NumThousandFormat(MyselfProxy.Instance:GetLottery())
end

local day, hour, min, sec
local DAY_SECOND = 86400
local HOUR_SECOND = 3600

function NoviceShopView:UpdateDate()
  local endDate = proxy:GetEndDate() or 0
  local lefttime = endDate - ServerTime.CurServerTime() / 1000
  if 0 < lefttime then
    day, hour, min = ClientTimeUtil.FormatTimeBySec(lefttime)
  else
    if self.timeTick then
      TimeTickManager.Me():ClearTick(self)
      self.timeTick = nil
    end
    proxy:ClearEndDate()
    self:sendNotification(NoviceShop.RefreshBtn)
    self.periodLabel.text = ""
    self.periodTitle.text = ZhString.NoviceShop_End
    return
  end
  min = min ~= 0 and min or 1
  if lefttime >= DAY_SECOND then
    self.periodLabel.text = string.format(ZhString.NoviceShop_LefttimeInDays, day)
  elseif lefttime >= HOUR_SECOND then
    self.periodLabel.text = string.format(ZhString.NoviceShop_LefttimeInHours, hour)
  else
    self.periodLabel.text = string.format(ZhString.NoviceShop_LefttimeInMins, min)
  end
end

function NoviceShopView:OnMyDataChange()
  self:UpdateMoney()
end

function NoviceShopView:OnItemCellClicked(cell)
end

function NoviceShopView:OnRewardCellClicked(cell)
end

function NoviceShopView:UpdateModel()
  UIMultiModelUtil.Instance:RemoveModels()
  self.model = nil
  local npcid = proxy:GetNPCID()
  self:ShowNpcModel(npcid)
end

function NoviceShopView:ShowNpcModel(npcid)
  if not npcid then
    return
  end
  local sdata = Table_Npc[npcid]
  if not sdata then
    return
  end
  local otherScale = 1
  if sdata.Shape then
    otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
  else
    helplog(string.format("Npc:%s Not have Shape", sdata.id))
  end
  if sdata.Scale then
    otherScale = sdata.Scale
  end
  self.modelId = sdata.id
  if self.model then
    self.model:Destroy()
  end
  UIModelUtil.Instance:SetNpcModelTexture(self.previewTexture, sdata.id, nil, function(rolePart, dataID)
    if self.modelId ~= dataID then
      return
    end
    self.uiModelCell = UIModelUtil.Instance:GetUIModelCell(self.previewTexture)
    self.model = rolePart
    if self.model then
      local showPos = sdata.LoadShowPose
      if showPos and #showPos == 3 then
        self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
      end
      if sdata.LoadShowRotate then
        self.model:SetEulerAngleY(sdata.LoadShowRotate)
      end
      if sdata.LoadShowSize then
        otherScale = sdata.LoadShowSize
      end
      self.model:SetScale(otherScale)
    end
  end, sdata.id)
end
