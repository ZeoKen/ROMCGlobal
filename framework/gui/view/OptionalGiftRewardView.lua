autoImport("OptionalGiftRewardCell")
OptionalGiftRewardView = class("OptionalGiftRewardView", BaseView)
OptionalGiftRewardView.ViewType = UIViewType.PopUpLayer
local nameTextureMap = {
  Decorate1 = "reward_bg_decorate1",
  Decorate2 = "reward_bg_decorate2",
  Decorate3Left = "reward_bg_decorate3",
  Decorate3Right = "reward_bg_decorate3",
  CloseButtonBg = "reward_bg_close"
}
local _PACKAGECHECK = {
  1,
  2,
  4,
  6,
  7,
  8,
  9,
  12,
  17
}

function OptionalGiftRewardView:Init()
  self:FindObjs()
  self:InitShow()
  self:InitData()
  self:AddListenEvts()
end

function OptionalGiftRewardView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function OptionalGiftRewardView:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.giftInfo = self:FindGO("GiftInfo")
  self.giftSp = self:FindComponent("GiftIcon", UISprite)
  self.giftCountLabel = self:FindComponent("GiftCountLabel", UILabel)
  for name, _ in pairs(nameTextureMap) do
    self[name] = self:FindComponent(name, UITexture)
  end
  self.cat = self:FindComponent("Cat", UITexture)
end

function OptionalGiftRewardView:InitShow()
  self.listCtrl = UIGridListCtrl.new(self.grid, OptionalGiftRewardCell, "OptionalGiftRewardCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
  self.listCtrl:AddEventListener(OptionalGiftRewardCell.InputChange, self.OnCellInputChange, self)
  self:AddButtonEvent("ConfirmButton", function()
    local reward = BagProxy.Instance:GetItemByStaticID(self.giftStaticId, Game.Config_Wallet and Game.Config_Wallet[self.giftStaticId] and BagProxy.BagType.Wallet or nil)
    if not reward then
      LogUtility.ErrorFormat("Cannot find item with static id = {0}!", self.giftStaticId)
      MsgManager.ShowMsgByID(3554, self.giftStaticData.NameZh)
      return
    end
    local callCount = 0
    for i = 1, #self.selectedStaticIds do
      if 0 < self.selectedCounts[i] then
        ServiceItemProxy.Instance:CallItemUse(reward, nil, self.selectedCounts[i], self.selectedStaticIds[i])
        callCount = callCount + 1
      end
    end
    if 0 < callCount then
      self:CloseSelf()
    end
  end)
  self.giftInfoLabel = SpriteLabel.new(self.giftInfo, nil, nil, nil, true)
end

function OptionalGiftRewardView:InitData()
  local viewData = self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("Cannot find viewData while initializing OptionalGiftRewardView!")
    return
  end
  self.giftStaticId = viewData.gift
  self.giftStaticData = Table_Item[self.giftStaticId]
  self.rewards = viewData.reward
  if not (self.giftStaticId and self.giftStaticData and self.rewards) or not next(self.rewards) then
    LogUtility.Error("Cannot find valid viewData while initializing OptionalGiftRewardView!")
    return
  end
end

function OptionalGiftRewardView:OnEnter()
  OptionalGiftRewardView.super.OnEnter(self)
  self:sendNotification(UIEvent.CloseUI, UIViewType.TipLayer)
  if #self.rewards <= 5 then
    self.grid.pivot = UIWidget.Pivot.Center
    self.gridTrans.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  else
    self.grid.pivot = UIWidget.Pivot.Left
    self.gridTrans.localPosition = LuaGeometry.GetTempVector3(-316, 0, 0)
  end
  self.listCtrl:ResetDatas(self.rewards)
  self:LoadTextures()
  self:OnItemUpdate()
end

function OptionalGiftRewardView:OnExit()
  self:UnloadTextures()
  TimeTickManager.Me():ClearTick(self)
  OptionalGiftRewardView.super.OnExit(self)
end

function OptionalGiftRewardView:OnItemUpdate()
  self.giftMultipleMaxCount = Table_UseItem[self.giftStaticId] and Table_UseItem[self.giftStaticId].UseMultiple or -1
  self.giftCount = self:GetGiftCountFromBag()
  if self.giftMultipleMaxCount > 0 and self.giftCount > self.giftMultipleMaxCount then
    self.giftCount = self.giftMultipleMaxCount
  end
  self.selectedStaticIds = self.selectedStaticIds or {}
  self.selectedCounts = self.selectedCounts or {}
  TableUtility.ArrayClear(self.selectedStaticIds)
  TableUtility.ArrayClear(self.selectedCounts)
  self:UpdateSelected()
end

function OptionalGiftRewardView:OnCellInputChange(cellCtl)
  local rewardId, selectCount = cellCtl.rewardId, cellCtl:GetCurSelectCount()
  local index = TableUtility.ArrayFindIndex(self.selectedStaticIds, rewardId)
  if 0 < index then
    self.selectedCounts[index] = selectCount
  else
    TableUtility.ArrayPushBack(self.selectedStaticIds, rewardId)
    TableUtility.ArrayPushBack(self.selectedCounts, selectCount)
    index = #self.selectedStaticIds
  end
  local totalSelectedCount = 0
  for _, count in pairs(self.selectedCounts) do
    totalSelectedCount = totalSelectedCount + count
  end
  if totalSelectedCount > self.giftCount then
    local finalCount = self.selectedCounts[index] - (totalSelectedCount - self.giftCount)
    self.selectedCounts[index] = finalCount
    cellCtl.countInput.value = finalCount
    if 0 < self.giftMultipleMaxCount and totalSelectedCount > self.giftMultipleMaxCount then
      MsgManager.ShowMsgByID(1281)
    end
  else
    cellCtl.countInput.value = cellCtl:GetCurSelectCount()
  end
  self:UpdateSelected()
end

function OptionalGiftRewardView:OnMouseClick(cellCtl)
  self:ShowGiftTip(cellCtl and cellCtl.rewardId, cellCtl.icon, cellCtl.gameObject)
end

function OptionalGiftRewardView:UpdateSelected()
  local totalSelectedCount = 0
  for _, count in pairs(self.selectedCounts) do
    totalSelectedCount = totalSelectedCount + count
  end
  self.giftInfoLabel:SetText(string.format(ZhString.OptionalGiftRewardView_GiftInfoFormat, self.giftStaticId, totalSelectedCount, self.giftStaticId, self:GetGiftCountFromBag()))
  local cells = self.listCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:UpdateInputByRestCount(self.giftCount - totalSelectedCount)
  end
end

function OptionalGiftRewardView:LoadTextures()
  for compName, texName in pairs(nameTextureMap) do
    PictureManager.Instance:SetUI(texName, self[compName])
  end
  PictureManager.Instance:SetRecall("recall_bg_cat", self.cat)
end

function OptionalGiftRewardView:UnloadTextures()
  for compName, texName in pairs(nameTextureMap) do
    PictureManager.Instance:UnLoadUI(texName, self[compName])
  end
  PictureManager.Instance:UnLoadRecall("recall_bg_cat", self.cat)
end

function OptionalGiftRewardView:GetGiftCountFromBag()
  return BagProxy.Instance:GetItemNumByStaticID(self.giftStaticId)
end

local tipData = {
  ignoreBounds = {}
}
local tipOffset = {0, -160}

function OptionalGiftRewardView:ShowGiftTip(sId, stick, ignoreBound)
  if not sId or not stick then
    self:ShowItemTip()
    return
  end
  local tempV3 = LuaGeometry.GetTempVector3(LuaGameObject.GetPosition(stick.gameObject.transform))
  local isGoRight
  if tempV3.x == 0 then
    isGoRight = 1
  else
    isGoRight = tempV3.x / math.abs(tempV3.x)
  end
  tipData.itemdata = ItemData.new("Tip", sId)
  local itemCount = BagProxy.Instance:GetItemNumByStaticID(sId, _PACKAGECHECK)
  local petData = PetProxy.Instance:GetPetDataByEggID(sId)
  if petData then
    local petID = petData.id
    if Table_Pet[petID] then
      local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
      if myPetInfo then
        local petid = myPetInfo.petid
        if petid == petID then
          itemCount = itemCount + 1
        end
      end
    end
  end
  tipData.itemdata:SetItemNum(itemCount)
  tipData.itemdata.showCount = true
  tipData.ignoreBounds[1] = ignoreBound
  tipOffset[1] = -210 * isGoRight
  self:ShowItemTip(tipData, stick, 0 < isGoRight and NGUIUtil.AnchorSide.Left or NGUIUtil.AnchorSide.Right, tipOffset)
end
