autoImport("PrestigeShopView")
autoImport("ExpRaidShopItemCell")
autoImport("ExpRaidBuyItemCell")
ExpRaidPrestigeShopView = class("ExpRaidPrestigeShopView", PrestigeShopView)
ExpRaidPrestigeShopView.ViewType = UIViewType.NormalLayer

function ExpRaidPrestigeShopView:FindObjs()
  ExpRaidPrestigeShopView.super.FindObjs(self)
  self:InitInRaidLabelCell()
end

function ExpRaidPrestigeShopView:InitInRaidLabelCell()
  local go = self:LoadCellPfb("ExpRaidShopInRaidLabelCell")
  go.transform:SetParent(self.moneySprite[2].gameObject.transform, false)
  self.inRaidLabel = go:GetComponent(UILabel)
end

function ExpRaidPrestigeShopView:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = ExpRaidBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
end

function ExpRaidPrestigeShopView:AddViewEvts()
  ExpRaidPrestigeShopView.super.AddViewEvts(self)
  
  function self.ItemScrollView.onDragStarted()
    self.selectGo = nil
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
  
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateExpRaidScore)
end

function ExpRaidPrestigeShopView:InitShow()
  self.npcid = 6887
  self.tipData = {}
  self.tipData.funcConfig = {}
  local itemContainer = self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 6,
    cellName = "ShopItemCell",
    control = ExpRaidShopItemCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
end

function ExpRaidPrestigeShopView:handleCameraQuestStart()
  local npc = self:GetShopNpc()
  if npc and npc.assetRole then
    self:CameraFaceTo(npc.assetRole.completeTransform, CameraConfig.HappyShop_ViewPort, CameraConfig.HappyShop_Rotation)
  end
end

function ExpRaidPrestigeShopView:InitUI()
  self:UpdateShopInfo(true)
  self:UpdateExpRaidScore()
  self:SetPrestigeInfo()
  self:SetGifting()
  self:SetDescLable()
  self:DeactivateNoUseObjs()
  self.ItemScrollView.gameObject:SetActive(true)
  self.buyCell.gameObject:SetActive(false)
  self.inRaidLabel.text = ZhString.ExpRaid_ShopInRaidLabel
  for _, sprite in pairs(self.moneySprite) do
    IconManager:SetUIIcon("exp_integral", sprite)
    sprite.gameObject:SetActive(true)
  end
  if self.giftCtrl then
    local cells = self.giftCtrl:GetCells()
    for _, v in pairs(cells) do
      v:SetChoose(false)
    end
  end
end

function ExpRaidPrestigeShopView:UpdateShopInfo(isReset)
  local data = self:GetShopItemData()
  if data then
    self.itemWrapHelper:UpdateInfo(data)
  else
    LogUtility.Error("ExpRaidPrestigeShopView.UpdateShopInfo:data is nil")
  end
  if isReset == true then
    self.itemWrapHelper:ResetPosition()
  end
end

function ExpRaidPrestigeShopView:UpdateExpRaidScore()
  self.moneyLabel[1].text = ExpRaidProxy.Instance:GetExpRaidScore()
  self.moneyLabel[2].text = ExpRaidProxy.Instance:GetExpRaidScoreInRaid()
end

function ExpRaidPrestigeShopView:UpdateBuyItemInfo(data)
  if data then
    self.buyCell:SetData(data)
    TipsView.Me():HideCurrent()
  end
end

function ExpRaidPrestigeShopView:DeactivateNoUseObjs()
  if self.specialRoot then
    self.specialRoot:SetActive(false)
  end
  if self.skipBtn then
    self.skipBtn.gameObject:SetActive(false)
  end
  if self.toggleRoot then
    self.toggleRoot:SetActive(false)
  end
  if self.showtoggle then
    self.showtoggle:SetActive(false)
  end
  if self.servantExp then
    self.servantExp:SetActive(false)
  end
  if self.screenRoot then
    self.screenRoot:SetActive(false)
  end
  if self.searchToggle then
    self.searchToggle:SetActive(false)
  end
end

function ExpRaidPrestigeShopView:HandleClickItem(cellctl)
  if self.selectedCellCtl ~= cellctl then
    if self.selectedCellCtl then
      self.selectedCellCtl:SetChoose(false)
    end
    cellctl:SetChoose(true)
    self.selectedCellCtl = cellctl
  end
  if self.selectGo == cellctl.gameObject then
    self.selectGo = nil
    return
  end
  self.selectGo = cellctl.gameObject
  local data = cellctl.data
  if not data then
    return
  end
  if ExpRaidProxy.Instance:CheckIsShopItemUnlocked(data) then
    self:UpdateBuyItemInfo(data)
  else
    local desc = Table_ExpRaidshop[data.staticData.id].MenuDes
    if desc and desc ~= "" then
      MsgManager.ShowMsg(nil, string.format(ZhString.ExpRaid_ShopLockedDescFormat, desc), 1)
    end
  end
end

function ExpRaidPrestigeShopView:HandleClickIconSprite(cellctl)
  self.tipData.itemdata = cellctl.data
  self:ShowItemTip(self.tipData, self.LeftStick)
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function ExpRaidPrestigeShopView:RecvBuyShopItem(note)
  redlog("RecvBuyShopItem")
  self:UpdateShopInfo()
end

function ExpRaidPrestigeShopView:GetShopNpc()
  local data = self.viewdata.viewdata
  return data and data.npcdata
end

function ExpRaidPrestigeShopView:GetShopItemData()
  return ExpRaidProxy.Instance:GetAllShopItemDatas()
end

function ExpRaidPrestigeShopView:GetPrestigeDataBySelfNPC()
  return ExpRaidPrestigeShopView.super.GetPrestigeDataBySelfNPC(self, false)
end
