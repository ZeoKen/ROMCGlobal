NoviceRewardSubView = class("NoviceRewardSubView", SubView)
autoImport("NoviceShopRewardCellType2")
local viewPath = ResourcePathHelper.UIView("NoviceRewardSubView")
local proxy
local DepositConfig = GameConfig.FirstDeposit
local fovMin, fovMax = 35, 65
local cameraConfig = {
  position = LuaVector3.New(1.28, 1.18, -2.34),
  rotation = LuaQuaternion.Euler(7.12, -28.5, 0),
  fieldOfView = 45,
  backScale = LuaVector3.New(16, 9, 1)
}
local tempVector3 = LuaVector3.Zero()

function NoviceRewardSubView:Init()
  if self.inited then
    return
  end
  if not proxy then
    proxy = NoviceShopProxy.Instance
  end
  self:FindObjs()
  self:AddViewEvts()
  self:InitView()
  self.inited = true
end

function NoviceRewardSubView:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container, true)
  obj.name = "NoviceRewardSubView"
end

function NoviceRewardSubView:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("NoviceRewardSubView")
  self.grid = self:FindComponent("rewardTable", UIGridEx)
  self.rewardListCtrl = ListCtrl.new(self.grid, NoviceShopRewardCellType2, "NoviceShopRewardCellType2")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnRewardCellClicked, self)
  self.rewardListCtrl:SetEmptyDatas(6)
  self.rewardCells = self.rewardListCtrl:GetCells()
  self.previewTexture = self:FindGO("previewTexture"):GetComponent(UITexture)
  self:AddDragEvent(self.previewTexture.gameObject, function(go, delta)
    self:RotateRoleEvt(go, delta)
  end)
  self.depositGroupGO = self:FindGO("DepositGroup")
  self.depositLabel = self:FindGO("DepositLabel"):GetComponent(UILabel)
  self.depositStr1 = self:FindGO("String1"):GetComponent(UILabel)
  self.depositStr2 = self:FindGO("String2"):GetComponent(UILabel)
  self.depositStr1.text = ZhString.NoviceShop_RechargeMore1
  self.depositStr2.text = ZhString.NoviceShop_RechargeMore2
  self.bgTexture = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.titleBgTexture = self:FindGO("QWS_Botttom15"):GetComponent(UITexture)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  local str = GameConfig.FirstDeposit.RechargeTips or ""
  self.tipLabel.text = str
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
  self.decorate04 = self:FindGO("Accumulative_Decorate_04"):GetComponent(UITexture)
end

function NoviceRewardSubView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.RecvQueryShopConfig)
  self:AddListenEvt(ServiceEvent.NUserUpdateShopGotItem, self.UpdataShopGotItem)
  self:AddListenEvt(ServiceEvent.SceneUser3FirstDepositInfo, self.RefreshPage)
  self:AddListenEvt(ServiceEvent.UserEventQueryChargeCnt, self.RefreshPage)
end

function NoviceRewardSubView:InitView()
  self:UpdateDeposit()
  self:RefreshRewardPage()
end

function NoviceRewardSubView:RefreshPage()
  self:RefreshRewardPage()
end

function NoviceRewardSubView:RefreshRewardPage()
  self:UpdateRewardCells()
  self:UpdateModel()
end

function NoviceRewardSubView:UpdateDeposit()
  local priceFormat
  if BranchMgr.IsChina() then
    priceFormat = "%d"
  else
    priceFormat = "%.2f"
  end
  local accumlatedDeposit = proxy:GetAccumulatedDeposit()
  local accumlatedNextStep = proxy:GetAccumulatedNextStep()
  if not accumlatedNextStep then
    if BranchMgr.IsChina() then
      self.depositLabel.text = string.format(ZhString.NoviceShop_CurrentAccumulated, proxy:GetCurrencyType(), proxy:GetAccumulatedDeposit())
    else
      self.depositLabel.text = string.format(ZhString.NoviceShop_CurrentAccumulated_Oversea, proxy:GetCurrencyType(), proxy:GetAccumulatedDeposit())
    end
    self.depositStr1.text = ""
    self.depositStr2.text = ""
  else
    local priceStr = proxy:GetCurrencyType() .. string.format(priceFormat, accumlatedNextStep - accumlatedDeposit)
    self.depositLabel.text = priceStr
  end
  local bd = NGUIMath.CalculateRelativeWidgetBounds(self.depositLabel.transform)
  local width = bd.size.x
  local width1 = self.depositStr1.printedSize.x
  local width2 = self.depositStr2.printedSize.x
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.depositLabel.transform))
  tempVector3[1] = (width1 - width2) / 2
  self.depositLabel.transform.localPosition = tempVector3
end

function NoviceRewardSubView:UpdateRewardCells()
  for i = 1, 6 do
    self.rewardCells[i]:SetData(i)
  end
end

function NoviceRewardSubView:RecvQueryShopConfig()
  self:InitView()
end

function NoviceRewardSubView:UpdataShopGotItem()
  self:InitView()
end

function NoviceRewardSubView:UpdateModel()
  UIMultiModelUtil.Instance:RemoveModels()
  self.model = nil
  local npcid = proxy:GetNPCID()
  self:ShowNpcModel(npcid)
end

function NoviceRewardSubView:ShowNpcModel(npcid)
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

function NoviceRewardSubView:RotateRoleEvt(go, delta)
  if self.model then
    local deltaAngle = -delta.x * 360 / 400
    self.model:RotateDelta(deltaAngle)
  end
end

function NoviceRewardSubView:OnEnter()
  NoviceRewardSubView.super.OnEnter(self)
  PictureManager.Instance:SetUI("Noviceactivity_bg5_bottom_01", self.bgTexture)
  PictureManager.Instance:SetSevenRoyalFamiliesTexture("Sevenroyalfamilies_bg_bottom15", self.titleBgTexture)
  PictureManager.Instance:SetAccumulativeTexture("Accumulative_bg_decorate_04", self.decorate04)
  self.container:TimeLeftCountDown(NoviceShopProxy.Instance:GetEndDate())
end

function NoviceRewardSubView:OnExit()
  NoviceRewardSubView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI("Noviceactivity_bg5_bottom_01", self.bgTexture)
  PictureManager.Instance:UnloadSevenRoyalFamiliesTexture("Sevenroyalfamilies_bg_bottom15", self.titleBgTexture)
  PictureManager.Instance:UnloadAccumulativeTexture("Accumulative_bg_decorate_04", self.decorate04)
end
