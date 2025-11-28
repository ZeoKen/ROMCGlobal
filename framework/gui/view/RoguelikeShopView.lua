autoImport("ExpRaidShopView")
autoImport("RoguelikeShopItemCell")
RoguelikeShopView = class("RoguelikeShopView", ExpRaidShopView)

function RoguelikeShopView:FindOtherObjs()
  self:InitRefreshBtn()
end

function RoguelikeShopView:InitRefreshBtn()
  local go = self:LoadCellPfb("RoguelikeShopRefreshCell")
  local refreshCoinIcon = Game.GameObjectUtil:DeepFindChild(go, "Icon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[DungeonProxy.RoguelikeCoinId].Icon, refreshCoinIcon)
  self.refreshCoinLabel = Game.GameObjectUtil:DeepFindChild(go, "Num"):GetComponent(UILabel)
  self.refreshCoinLabel.text = GameConfig.Roguelike.RefreshShopCoins
  self.leftRefreshCountLabel = Game.GameObjectUtil:DeepFindChild(go, "LeftRefreshCount"):GetComponent(UILabel)
  local btn = Game.GameObjectUtil:DeepFindChild(go, "RefreshBtn")
  self:AddClickEvent(btn, function()
    if not DungeonProxy.Instance:CheckRoguelikeCoin(GameConfig.Roguelike.RefreshShopCoins) then
      MsgManager.ShowMsgByID(2)
      return
    end
    if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
      MsgManager.ShowMsgByID(26231)
      return
    end
    DungeonProxy.RefreshRoguelikeShopData()
  end)
end

function RoguelikeShopView:InitBuyItemCell()
end

function RoguelikeShopView:AddEvts()
  function self.ItemScrollView.onDragStarted()
    self.selectedGO = nil
    
    TipsView.Me():HideCurrent()
  end
end

function RoguelikeShopView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeRaidInfoCmd, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.RoguelikeCmdRoguelikeShopDataCmd, self.UpdateShopInfo)
  self:AddListenEvt(RoguelikeEvent.RoomChange, self.CloseSelf)
end

function RoguelikeShopView:InitShow()
  self:_InitShow(RoguelikeShopItemCell)
end

function RoguelikeShopView:OnEnter()
  RoguelikeShopView.super.OnEnter(self)
  DungeonProxy.RequestRoguelikeShopData()
end

function RoguelikeShopView:InitUI()
  self:UpdateCoins()
  self:UpdateDesc()
  self:DeactivateNoUseObjs()
  self.ItemScrollView.gameObject:SetActive(true)
  IconManager:SetItemIcon(Table_Item[DungeonProxy.RoguelikeCoinId].Icon, self.moneySprite[1])
  self.moneySprite[1].gameObject:SetActive(true)
end

function RoguelikeShopView:DeactivateNoUseObjs()
  RoguelikeShopView.super.DeactivateNoUseObjs(self)
  self.moneySprite[2].gameObject:SetActive(false)
end

function RoguelikeShopView:HandleClickItem(cellCtl)
  self:_SetChoose(cellCtl)
  if cellCtl:IsSoldOut() then
    return
  end
  local itemId = cellCtl:GetItemId()
  if itemId <= 0 then
    LogUtility.Error("Invalid ItemId")
    return
  end
  if not TeamProxy.Instance:CheckIHaveLeaderAuthority() then
    MsgManager.ShowMsgByID(26231)
    return
  end
  if not DungeonProxy.Instance:CheckRoguelikeCoin(cellCtl:GetItemCost()) then
    MsgManager.ShowMsgByID(2)
    return
  end
  local costStr = string.format(ZhString.Friend_RecallRewardItem, cellCtl:GetItemCost(), Table_Item[DungeonProxy.RoguelikeCoinId].NameZh)
  MsgManager.ConfirmMsgByID(9630, function()
    DungeonProxy.BuyRoguelikeShopData(itemId)
  end, nil, nil, costStr, cellCtl:GetItemName())
end

function RoguelikeShopView:HandleClickIconSprite(cellctl)
  if not cellctl.data then
    return
  end
  local itemdata = cellctl.data.itemData
  if not itemdata then
    return
  end
  self.tipData.itemdata = itemdata
  self:ShowItemTip(self.tipData, self.LeftStick)
  self.selectedGO = nil
end

function RoguelikeShopView:UpdateCoins()
  local available, coinCount = DungeonProxy.Instance:CheckRoguelikeCoin(GameConfig.Roguelike.RefreshShopCoins)
  self.moneyLabel[1].text = coinCount
  self.refreshCoinLabel.color = available and ColorUtil.NGUIWhite or ColorUtil.Red
end

function RoguelikeShopView:UpdateShopInfo(isReset)
  RoguelikeShopView.super.UpdateShopInfo(self, isReset)
  self.leftRefreshCountLabel.text = string.format(ZhString.RollReward_CountLeftFormat, DungeonProxy.Instance.roguelikeLeftRefreshCount, GameConfig.Roguelike.MaxRefreshShopNum)
end

function RoguelikeShopView:UpdateBuyItemInfo(data)
  if not data then
    return
  end
  TipsView.Me():HideCurrent()
end

function RoguelikeShopView:GetShopNpc()
  return self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.npcdata
end

function RoguelikeShopView:GetShopItemData()
  return DungeonProxy.Instance.roguelikeShopData
end
