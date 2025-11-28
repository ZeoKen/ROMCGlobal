autoImport("AccumulativeShopRewardCell")
AccumulativeShopView = class("AccumulativeShopView", ContainerView)
AccumulativeShopView.ViewType = UIViewType.NormalLayer
local proxy
local DepositConfig = GameConfig.AccumDeposit
local fovMin, fovMax = 35, 65
AccumulativeShopView.cameraConfig = {
  position = LuaVector3.New(1.28, 1.61, -2.34),
  rotation = LuaQuaternion.Euler(7.12, -28.5, 0),
  fieldOfView = 45,
  backScale = LuaVector3.New(16, 9, 1)
}

function AccumulativeShopView:Init()
  if not proxy then
    proxy = AccumulativeShopProxy.Instance
  end
  self:InitObjEvents()
  self:AddViewEvts()
  self:InitView()
end

function AccumulativeShopView:OnEnter()
  AccumulativeShopView.super.OnEnter(self)
  self:RequestQueryChargeCnt()
  RedTipProxy.Instance:SeenNew(AccumulativeShopProxy.RedTipID)
  self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateDate, self, 1)
end

function AccumulativeShopView:RequestQueryChargeCnt()
  ServiceUserEventProxy.Instance:CallQueryChargeCnt()
end

function AccumulativeShopView:OnExit()
  AccumulativeShopView.super.OnExit(self)
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end

function AccumulativeShopView:InitObjEvents()
  self.titleLabel = self:FindComponent("Title", UILabel, self:FindGO("BgGroup"))
  self.periodGroupGO = self:FindGO("PeriodGroup")
  self.periodTitle = self:FindGO("PeriodTitle"):GetComponent(UILabel)
  self.periodTitle.text = ZhString.NoviceShop_PeriodLabel
  self.periodLabel = self:FindGO("PeriodLabel", self.periodGroupGO):GetComponent(UILabel)
  self.helpBtnGO = self:FindGO("HelpButton", self.periodGroupGO)
  self.rewardCells = {}
  for i = 1, 6 do
    local cellGO = self:FindGO("AccumulativeShopRewardCell" .. i)
    self.rewardCells[i] = AccumulativeShopRewardCell.new(cellGO)
    self.rewardCells[i]:AddEventListener(MouseEvent.MouseClick, self.OnRewardCellClicked, self)
  end
  self.rewardView = self:FindGO("RewardView")
  if proxy:UpdateaRewardTip() then
    redlog("UpdateRedTip")
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
    if not self.fovScrollBarCtrl or Slua.IsNull(self.fovScrollBarCtrl) then
      return
    end
    if not self.fovScrollBarCtrl.isDragging or not self.uiModelCell then
      return
    end
    local value = 1 - self.fovScrollBarCtrl.value
    AccumulativeShopView.cameraConfig.fieldOfView = (fovMax - fovMin) * value + fovMin
    self.uiModelCell:_SetCameraConfig(AccumulativeShopView.cameraConfig)
  end)
  local help = self:FindGO("HelpButton")
  self:RegistShowGeneralHelpByHelpID(35254, help)
  self.depositGroupGO = self:FindGO("DepositGroup")
  self.depositLabel = self:FindGO("DepositLabel"):GetComponent(UILabel)
  local mask = self:FindGO("BlackMask"):GetComponent(UISprite)
  mask.height = Screen.height * 2
  mask.width = Screen.width * 2
  self.AdLabel = self:FindGO("AdLabel"):GetComponent(UILabel)
  self.ADSprite = self:FindGO("ADSprite")
end

function AccumulativeShopView:UpdateDeposit()
  if BranchMgr.IsChina() then
    self.depositLabel.text = string.format(ZhString.AccumulativeShop_CurrentAccumulated, proxy:GetCurrencyType(), proxy:GetAccumulatedDeposit())
  else
    self.depositLabel.text = string.format(ZhString.AccumulativeShop_CurrentAccumulated_Oversea, proxy:GetCurrencyType(), proxy:GetAccumulatedDeposit())
  end
end

function AccumulativeShopView:CheckValidTime()
  if not proxy:CheckValidTime() then
    MsgManager.ShowMsgByID(40973)
    return false
  end
  return true
end

function AccumulativeShopView:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function AccumulativeShopView:ClearView()
end

function AccumulativeShopView:ShowShopList(b)
end

function AccumulativeShopView:ShowRewardView(b)
  self.rewardView:SetActive(b == true)
  if b then
    self:UpdateRewardCells()
    self:UpdateModel()
  end
end

function AccumulativeShopView:UpdateRewardCells()
  for i = 1, 6 do
    self.rewardCells[i]:SetData(i)
  end
end

function AccumulativeShopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.OnMyDataChange)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RefreshView)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdataShopGotItem)
  self:AddListenEvt(ServiceEvent.SceneUser3AccumDepositInfo, self.RefreshView)
  self:AddListenEvt(ServiceEvent.SceneUser3AccumDepositReward, self.RefreshView)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshView)
end

function AccumulativeShopView:RecvQueryShopConfig()
  self:InitView()
end

function AccumulativeShopView:UpdataShopGotItem()
  self:InitView()
end

function AccumulativeShopView:InitView()
  self:UpdateTitle()
  self:UpdateDeposit()
  self:UpdateDate()
  self:ShowRewardView(true)
end

function AccumulativeShopView:UpdateTitle()
  self.titleLabel.text = DepositConfig and DepositConfig.ActivityName
end

function AccumulativeShopView:RefreshView()
  self:UpdateRewardCells()
end

function AccumulativeShopView:UpdateMoney()
end

local day, hour, min, sec
local DAY_SECOND = 86400
local HOUR_SECOND = 3600

function AccumulativeShopView:UpdateDate()
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
    self:sendNotification(AccumulativeShop.RefreshBtn)
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

function AccumulativeShopView:OnMyDataChange()
  self:UpdateMoney()
end

function AccumulativeShopView:OnItemCellClicked(cell)
end

function AccumulativeShopView:OnRewardCellClicked(cell)
end

function AccumulativeShopView:UpdateModel()
  UIMultiModelUtil.Instance:RemoveModels()
  self.model = nil
  local npcid = proxy:GetNPCID()
  self:ShowNpcModel(npcid)
  local adtext = proxy:GetADText()
  redlog("UpdateModel", adtext)
  if adtext and adtext ~= "" then
    self.AdLabel.text = adtext
    self.ADSprite:SetActive(true)
  else
    self.ADSprite:SetActive(false)
  end
end

function AccumulativeShopView:ShowNpcModel(npcid)
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
  UIModelUtil.Instance:SetNpcModelTexture(self.previewTexture, sdata.id, AccumulativeShopView.cameraConfig, function(rolePart, dataID)
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
  UIModelUtil.Instance:SetCellTransparent(self.previewTexture)
end
