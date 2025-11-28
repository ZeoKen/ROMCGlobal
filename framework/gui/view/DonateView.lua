autoImport("BifrostMatSubmitCell")
DonateView = class("DonateView", ContainerView)
DonateView.ViewType = UIViewType.NormalLayer
local PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.donate or {
  1,
  6,
  7,
  8,
  9,
  17
}
local CELL_PREFAB_NAME = "GuildBuildingMatSubmitCell"
local tempVector3 = LuaVector3.Zero()

function DonateView:loadCellPfb()
  local cell = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(CELL_PREFAB_NAME))
  if not cell then
    error("can not find cellpfb: " .. CELL_PREFAB_NAME)
    return
  end
  cell.transform:SetParent(self.gameObject.transform, false)
  tempVector3[2] = 206
  cell.transform.localPosition = tempVector3
  return cell
end

function DonateView:Init()
  self:FindObjs()
  self:MapListenEvt()
  self.limitTime = DonateProxy.Instance:GetDonateTotalCount()
  self:InitView()
end

function DonateView:FindObjs()
  self.name = self:FindComponent("Name", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.container = self:FindGO("Container")
  self.submitCountLab = self:FindComponent("SubmitCount", UILabel)
  local go = self:loadCellPfb()
  if nil == go then
    return
  end
  self.MatSubmitCell = BifrostMatSubmitCell.new(go)
  self.MatSubmitCell:SetChoosed(0.9, true)
  self.MatSubmitCell:SetMobileScreenAdaptionEnabled(false)
  self.MatSubmitCell.gameObject:AddComponent(CloseWhenClickOtherPlace)
  self.MatSubmitCell:AddEventListener(GuildBuildingEvent.SubmitMaterial, self.OnSubmit, self)
  self.MatSubmitCell:AddEventListener(GuildBuildingEvent.OnClickIcon, self.ShowDonateItemInfo, self)
  local closecomp = self.MatSubmitCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function closecomp.callBack(go)
    self:_showClickMat(false)
  end
  
  self.MatSubmitCell.gameObject:SetActive(false)
end

function DonateView:MapListenEvt()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdataUI)
  self:AddListenEvt(ServiceEvent.NUserActivityDonateQueryUserCmd, self.UpdateSubmitTime)
  self:AddListenEvt(ServiceEvent.NUserActivityDonateRewardUserCmd, self.UpdateSubmitTime)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleClose)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleClose)
end

function DonateView:UpdateSubmitTime()
  self.submitTime = DonateProxy.Instance:GetDonateCount()
  self.submitCountLab.text = string.format(ZhString.GuildBuilding_Submit_Count, self.submitTime, self.limitTime)
end

function DonateView:HandleClose(note)
  self:CloseSelf()
end

function DonateView:InitView()
  if nil == self.wrapHelper then
    local wrapConfig = {
      wrapObj = self.container,
      pfbNum = 5,
      cellName = "GuildBuildingMatSubmitCell",
      control = BifrostMatSubmitCell,
      dir = 2
    }
    self.wrapHelper = WrapCellHelper.new(wrapConfig)
    self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ReadyChoose, self)
  end
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function DonateView:ReadyChoose(cellCtl)
  local data = cellCtl and cellCtl.data
  if data then
    self:_showClickMat(false)
    self.clickCell = cellCtl.gameObject
    self:_showClickMat(true)
    self.MatSubmitCell:SetData(data)
  end
end

function DonateView:_showClickMat(flag)
  if self.clickCell then
    self.clickCell:SetActive(not flag)
  end
  if self.MatSubmitCell then
    self.MatSubmitCell.gameObject:SetActive(flag)
  end
  self.container:SetActive(not flag)
end

local MainBagType = BagProxy.BagType.MainBag

function DonateView:OnSubmit(cellCtl)
  if BagProxy.Instance:CheckBagIsFull(MainBagType) then
    MsgManager.ShowMsgByID(41468)
    return
  end
  if not cellCtl or not cellCtl.data then
    return
  end
  local data = cellCtl.data
  local itemId = data.materials.id
  local needNum = data.materials.count
  local ownCount = BagProxy.Instance:GetItemNumByStaticID(itemId, PACKAGE_MATERIAL)
  local lackCount = needNum - ownCount
  if 0 < lackCount then
    local neededItems = {}
    local neededItem = {id = itemId, count = lackCount}
    table.insert(neededItems, neededItem)
    QuickBuyProxy.Instance:TryOpenView(neededItems)
    return
  end
  DonateProxy.Instance:DoDonate(itemId, needNum)
end

function DonateView:UpdataUI()
  if not self.viewActivityDay then
    return
  end
  self.uiMatData = DonateProxy.Instance:GetDonateMatByDay(self.viewActivityDay)
  if not self.uiMatData then
    return
  end
  self.wrapHelper:UpdateInfo(self.uiMatData)
  self:_showClickMat(false)
  self.name.text = DonateProxy.Instance.donateActivityName
  local icon = DonateProxy.Instance.bgTex
  IconManager:SetUIIcon(icon, self.icon)
end

function DonateView:ShowDonateItemInfo(cellCtl)
  local targetId = cellCtl.rewardShowItem
  if targetId then
    self.tipData.itemdata = ItemData.new("Reward", targetId)
    self:ShowItemTip(self.tipData, cellCtl.rewardIcon, NGUIUtil.AnchorSide.Center, {400, -50})
  end
end

function DonateView:OnEnter()
  DonateView.super.OnEnter(self)
  FunctionSceneFilter.Me():StartFilter(22)
  self:DoCameraFocus()
  if DonateProxy.Instance:SetQueryActivityDay() then
    self.viewActivityDay = DonateProxy.Instance.curActivityDay
    self:UpdataUI()
    DonateProxy.Instance:DoQueryDonateTime()
  end
end

function DonateView:OnExit()
  DonateProxy.Instance:ResetParam()
  FunctionSceneFilter.Me():EndFilter(22)
  DonateView.super.OnExit(self)
  self:CameraReset()
end

function DonateView:DoCameraFocus()
  local npcdata = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  local npcTrans = npcdata and npcdata.assetRole and npcdata.assetRole.completeTransform
  if npcTrans then
    local viewPort, rotation = CameraConfig.BifrostMatSubmit_ViewPort, CameraConfig.BifrostMatSubmit_Rotation
    if viewPort and rotation then
      self:CameraFaceTo(npcTrans, viewPort, rotation)
    end
  end
end
