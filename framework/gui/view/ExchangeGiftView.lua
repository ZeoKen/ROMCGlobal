autoImport("GiftMatSubmitCell")
ExchangeGiftView = class("ExchangeGiftView", ContainerView)
ExchangeGiftView.ViewType = UIViewType.NormalLayer
local PACKAGE_MATERIAL = GameConfig.PackageMaterialCheck.donate or {
  1,
  6,
  7,
  8,
  9,
  17
}
local CELL_PREFAB_NAME = "ExchangeMatSubmitCell"
local tempVector3 = LuaVector3.Zero()

function ExchangeGiftView:loadCellPfb()
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

function ExchangeGiftView:Init()
  self:FindObjs()
  self:MapListenEvt()
  self:InitView()
end

function ExchangeGiftView:FindObjs()
  self.name = self:FindComponent("Name", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.container = self:FindGO("Container")
  self.submitCountLab = self:FindComponent("SubmitCount", UILabel)
  local go = self:loadCellPfb()
  if nil == go then
    return
  end
  self.MatSubmitCell = GiftMatSubmitCell.new(go)
  self.MatSubmitCell:SetChoosed(0.9, true)
  self.MatSubmitCell:SetMobileScreenAdaptionEnabled(false)
  self.MatSubmitCell.gameObject:AddComponent(CloseWhenClickOtherPlace)
  self.closecomp = self.MatSubmitCell.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:_showClickMat(false)
  end
  
  self.MatSubmitCell:AddEventListener(GuildBuildingEvent.SubmitMaterial, self.OnSubmit, self)
  self.MatSubmitCell:AddEventListener(GuildBuildingEvent.OnClickItemIcon, self.OnClickItem, self)
  self.MatSubmitCell:AddEventListener(GuildBuildingEvent.OnClickIcon, self.ShowDonateItemInfo, self)
  self.MatSubmitCell.gameObject:SetActive(false)
end

function ExchangeGiftView:MapListenEvt()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdataUI)
  self:AddListenEvt(ServiceEvent.SceneUser3ActivityExchangeGiftsQueryUserCmd, self.UpdataUI)
  self:AddListenEvt(ServiceEvent.SceneUser3ActivityExchangeGiftsRewardUserCmd, self.HandleDonate)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.HandleClose)
  self:AddListenEvt(ServiceUserProxy.RecvLogin, self.HandleClose)
end

function ExchangeGiftView:UpdateSubmitTime()
  self.submitTime = DonateProxy.Instance:GetExchangeCount(self.activityID)
  self.submitCountLab.text = string.format(ZhString.GuildBuilding_Submit_Count, self.submitTime, self.limitTime)
end

function ExchangeGiftView:HandleDonate(note)
  if note.body.success then
    ServiceSceneUser3Proxy.Instance:CallActivityExchangeGiftsQueryUserCmd(self.activityID)
  end
  self:UpdateSubmitTime()
end

function ExchangeGiftView:HandleClose(note)
  self:CloseSelf()
end

function ExchangeGiftView:InitView()
  if nil == self.wrapHelper then
    local wrapConfig = {
      wrapObj = self.container,
      pfbNum = 5,
      cellName = "GuildBuildingMatSubmitCell",
      control = GiftMatSubmitCell,
      dir = 2
    }
    self.wrapHelper = WrapCellHelper.new(wrapConfig)
    self.wrapHelper:AddEventListener(MouseEvent.MouseClick, self.ReadyChoose, self)
  end
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ExchangeGiftView:ReadyChoose(cellCtl)
  local data = cellCtl and cellCtl.data
  if data then
    self:_showClickMat(false)
    self.clickCell = cellCtl.gameObject
    self.MatSubmitCell:SetData(data)
    self:_showClickMat(true)
  end
end

function ExchangeGiftView:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function ExchangeGiftView:_showClickMat(flag)
  if self.clickCell then
    self.clickCell:SetActive(not flag)
  end
  if self.MatSubmitCell then
    self.MatSubmitCell.gameObject:SetActive(flag)
  end
  if flag then
    self:ShowDonateItemInfo(self.MatSubmitCell)
  else
    TipManager.Instance:CloseItemTip()
  end
end

local MainBagType = BagProxy.BagType.MainBag

function ExchangeGiftView:OnSubmit(cellCtl)
  if BagProxy.Instance:CheckBagIsFull(MainBagType) then
    MsgManager.ShowMsgByID(41468)
    return
  end
  self.submitTime = DonateProxy.Instance:GetExchangeCount(self.activityID)
  if self.submitTime >= self.limitTime then
    MsgManager.ShowMsgByID(43550)
    return
  end
  if not cellCtl or not cellCtl.data then
    return
  end
  local data = cellCtl.data
  local itemId = data.require_item.id
  local needNum = data.require_item.count
  local ownCount = BagProxy.Instance:GetItemNumByStaticID(itemId, PACKAGE_MATERIAL)
  local lackCount = needNum - ownCount
  if 0 < lackCount then
    local neededItems = {}
    local neededItem = {id = itemId, count = lackCount}
    table.insert(neededItems, neededItem)
    QuickBuyProxy.Instance:TryOpenView(neededItems)
    return
  end
  local serverItemInfo = NetConfig.PBC and {} or SceneItem_pb.ItemInfo()
  serverItemInfo.id = itemId
  serverItemInfo.count = needNum
  ServiceSceneUser3Proxy.Instance:CallActivityExchangeGiftsRewardUserCmd(self.activityID, serverItemInfo)
end

function ExchangeGiftView:UpdataUI()
  if not self.activityID then
    return
  end
  self.uiMatData = DonateProxy.Instance:GetExchangeGifts(self.activityID) or {}
  self.wrapHelper:UpdateInfo(self.uiMatData)
  local cells = self.wrapHelper:GetCellCtls()
  if cells then
    for i = 1, #cells do
      self:AddIgnoreBounds(cells[i].gameObject)
    end
  end
  self:_showClickMat(false)
  self.name.text = Table_ActPersonalTimer[self.activityID].Name or ""
  local icon = DonateProxy.Instance.bgTex
  IconManager:SetUIIcon(icon, self.icon)
  self:UpdateSubmitTime()
end

function ExchangeGiftView:ShowDonateItemInfo(cellCtl)
  TipManager.Instance:CloseItemTip()
  local targetId = cellCtl.rewardShowItem
  if targetId then
    self.tipData.itemdata = ItemData.new("Reward", targetId)
    self:ShowItemTip(self.tipData, cellCtl.rewardIcon, NGUIUtil.AnchorSide.Center, {400, -50})
  end
end

function ExchangeGiftView:OnEnter()
  self.activityID = self.viewdata.viewdata and self.viewdata.viewdata.activityID
  self.limitTime = DonateProxy.Instance:GetExchangeLimit(self.activityID)
  ExchangeGiftView.super.OnEnter(self)
  FunctionSceneFilter.Me():StartFilter(22)
  self:DoCameraFocus()
  self:UpdataUI()
end

function ExchangeGiftView:OnExit()
  FunctionSceneFilter.Me():EndFilter(22)
  ExchangeGiftView.super.OnExit(self)
  self:CameraReset()
  self.closecomp = nil
end

function ExchangeGiftView:DoCameraFocus()
  local npcdata = self.viewdata.viewdata and self.viewdata.viewdata.npcdata
  local npcTrans = npcdata and npcdata.assetRole and npcdata.assetRole.completeTransform
  if npcTrans then
    local viewPort, rotation = CameraConfig.BifrostMatSubmit_ViewPort, CameraConfig.BifrostMatSubmit_Rotation
    if viewPort and rotation then
      self:CameraFaceTo(npcTrans, viewPort, rotation)
    end
  end
end

function ExchangeGiftView:OnClickItem(cellCtl)
  TipManager.Instance:CloseItemTip()
  local targetId = cellCtl.itemID
  redlog("OnClickItem", targetId)
  if targetId then
    self.tipData.itemdata = ItemData.new("Reward", targetId)
    self.tipData.hideGetPath = true
    self:ShowItemTip(self.tipData, cellCtl.rewardIcon, NGUIUtil.AnchorSide.Center, {400, -50})
  end
end
