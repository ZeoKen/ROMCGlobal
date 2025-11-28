autoImport("ExpRaidShopItemCell")
autoImport("ExpRaidBuyItemCell")
autoImport("HappyShop")
ExpRaidShopView = class("ExpRaidShopView", HappyShop)

function ExpRaidShopView:FindObjs()
  ExpRaidShopView.super.FindObjs(self)
  self:FindOtherObjs()
end

function ExpRaidShopView:FindOtherObjs()
  self:InitInRaidLabelCell()
end

function ExpRaidShopView:InitInRaidLabelCell()
  local go = self:LoadCellPfb("ExpRaidShopInRaidLabelCell")
  go.transform:SetParent(self.moneySprite[2].gameObject.transform, false)
  self.inRaidLabel = go:GetComponent(UILabel)
end

function ExpRaidShopView:InitBuyItemCell()
  local go = self:LoadCellPfb("HappyShopBuyItemCell")
  self.buyCell = ExpRaidBuyItemCell.new(go)
  self.buyCell:AddCloseWhenClickOtherPlaceCallBack(self)
end

function ExpRaidShopView:AddEvts()
  function self.ItemScrollView.onDragStarted()
    self.selectGo = nil
    
    self.buyCell.gameObject:SetActive(false)
    TipsView.Me():HideCurrent()
  end
end

function ExpRaidShopView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateExpRaidScore)
  self:AddListenEvt(ServiceEvent.SessionShopBuyShopItem, self.RecvBuyShopItem)
end

function ExpRaidShopView:InitShow()
  self:_InitShow(ExpRaidShopItemCell)
end

function ExpRaidShopView:_InitShow(cellControl)
  self.tipData = {}
  self.tipData.funcConfig = {}
  local itemContainer = self:FindGO("shop_itemContainer")
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = 6,
    cellName = "ShopItemCell",
    control = cellControl,
    dir = 1,
    disableDragIfFit = true
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemWrapHelper:AddEventListener(HappyShopEvent.SelectIconSprite, self.HandleClickIconSprite, self)
end

function ExpRaidShopView:OnEnter()
  ExpRaidShopView.super.super.OnEnter(self)
  self:HandleCameraQuestStart()
  self:InitUI()
end

function ExpRaidShopView:OnExit()
  self:CameraReset()
  if self.buyCell then
    self.buyCell:Exit()
  end
  TipsView.Me():HideCurrent()
  ExpRaidShopView.super.super.OnExit(self)
end

function ExpRaidShopView:InitUI()
  self:UpdateShopInfo()
  self:UpdateExpRaidScore()
  self:UpdateDesc()
  self:DeactivateNoUseObjs()
  self.ItemScrollView.gameObject:SetActive(true)
  self.buyCell.gameObject:SetActive(false)
  self.inRaidLabel.text = ZhString.ExpRaid_ShopInRaidLabel
  for _, sprite in pairs(self.moneySprite) do
    IconManager:SetUIIcon("exp_integral", sprite)
    sprite.gameObject:SetActive(true)
  end
end

function ExpRaidShopView:DeactivateNoUseObjs()
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
  if self.customToggleRoot then
    self.customToggleRoot:SetActive(false)
  end
  if self.searchToggle then
    self.searchToggle:SetActive(false)
  end
end

function ExpRaidShopView:HandleClickItem(cellctl)
  self:_SetChoose(cellctl)
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

function ExpRaidShopView:_SetChoose(cellctl)
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
end

function ExpRaidShopView:HandleClickIconSprite(cellctl)
  self.tipData.itemdata = cellctl.data
  self:ShowItemTip(self.tipData, self.LeftStick)
  self.buyCell.gameObject:SetActive(false)
  self.selectGo = nil
end

function ExpRaidShopView:HandleCameraQuestStart()
  local npc = self:GetShopNpc()
  if npc and npc.assetRole then
    self:CameraFaceTo(npc.assetRole.completeTransform, CameraConfig.HappyShop_ViewPort, CameraConfig.HappyShop_Rotation)
  end
end

function ExpRaidShopView:UpdateShopInfo(isReset)
  local data = self:GetShopItemData()
  if data then
    self.itemWrapHelper:UpdateInfo(data)
  else
    LogUtility.Error("ExpRaidShopView.UpdateShopInfo:data is nil")
  end
  if isReset == nil then
    isReset = true
  end
  if isReset then
    self.itemWrapHelper:ResetPosition()
  end
end

function ExpRaidShopView:UpdateExpRaidScore()
  self.moneyLabel[1].text = ExpRaidProxy.Instance:GetExpRaidScore()
  self.moneyLabel[2].text = ExpRaidProxy.Instance:GetExpRaidScoreInRaid()
end

function ExpRaidShopView:UpdateBuyItemInfo(data)
  if data then
    self.buyCell:SetData(data)
    TipsView.Me():HideCurrent()
  end
end

function ExpRaidShopView:UpdateDesc()
  self.descLab.text = ZhString.HappyShop_defaultDesc
end

function ExpRaidShopView:RecvBuyShopItem(note)
  self:UpdateShopInfo(false)
end

function ExpRaidShopView:GetShopNpc()
  return ExpRaidProxy.Instance:GetShopNpc()
end

function ExpRaidShopView:GetShopItemData()
  return ExpRaidProxy.Instance:GetShopItemDataOfCurrentNpc()
end
