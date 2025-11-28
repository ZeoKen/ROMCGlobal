autoImport("SingleGiftRewardCell")
SingleGiftRewardView = class("SingleGiftRewardView", BaseView)
SingleGiftRewardView.ViewType = UIViewType.PopUpLayer
local nameTextureMap = {BgTexture = "hezi_bg"}
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

function SingleGiftRewardView:Init()
  self:FindObjs()
  self:InitShow()
  self:InitData()
  self:AddListenEvts()
end

function SingleGiftRewardView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
end

function SingleGiftRewardView:FindObjs()
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.giftInfo = self:FindGO("GiftInfo")
  self.giftInfo:SetActive(false)
  for name, _ in pairs(nameTextureMap) do
    self[name] = self:FindComponent(name, UITexture)
  end
  self.cat = self:FindComponent("Cat", UITexture)
  self.confirmBtn = self:FindGO("ConfirmButton")
  self.confirmBtnGrey = self:FindGO("ConfirmButtonGrey")
end

function SingleGiftRewardView:InitShow()
  self.listCtrl = UIGridListCtrl.new(self.grid, SingleGiftRewardCell, "SingleGiftRewardCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
  self.listCtrl:AddEventListener(SingleGiftRewardCell.CellClick, self.OnCellClick, self)
  self:AddClickEvent(self.confirmBtn, function()
    local reward = BagProxy.Instance:GetItemByStaticID(self.giftStaticId, Game.Config_Wallet and Game.Config_Wallet[self.giftStaticId] and BagProxy.BagType.Wallet or nil)
    if not reward then
      LogUtility.ErrorFormat("Cannot find item with static id = {0}!", self.giftStaticId)
      MsgManager.ShowMsgByID(3554, self.giftStaticData.NameZh)
      return
    end
    if self.selectedReward then
      ServiceItemProxy.Instance:CallItemUse(reward, nil, 1, self.selectedReward)
      self:CloseSelf()
    end
  end)
  self:SetConfirmBtnState(self.selectedReward ~= nil)
end

function SingleGiftRewardView:InitData()
  local viewData = self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("Cannot find viewData while initializing SingleGiftRewardView!")
    return
  end
  self.giftStaticId = viewData.gift
  self.giftStaticData = Table_Item[self.giftStaticId]
  local headwears = Game.HeadwearBoxItems[self.giftStaticId]
  if not (self.giftStaticId and self.giftStaticData and headwears) or not next(headwears) then
    LogUtility.Error("Cannot find valid viewData while initializing SingleGiftRewardView!")
    return
  end
  self.rewards = {}
  local myGender = MyselfProxy.Instance:GetMySex()
  local configEquipGender = Game.Config_EquipGender
  for i = 1, #headwears do
    local itemId = headwears[i]
    local config = Table_HeadwearRepair[itemId]
    if config then
      if myGender == 2 and configEquipGender[itemId] then
        itemId = configEquipGender[itemId]
      end
      self.rewards[i] = {itemId, 1}
    end
  end
  if GameConfig.HeadwearBoxExtraItems and GameConfig.HeadwearBoxExtraItems.ExtraItem then
    local extraItems = GameConfig.HeadwearBoxExtraItems.ExtraItem[self.giftStaticData.Quality]
    if extraItems then
      for i = 1, #extraItems do
        local extra = extraItems[i]
        self.rewards[#self.rewards + 1] = {
          extra[1],
          extra[2]
        }
      end
    end
  end
end

function SingleGiftRewardView:OnEnter()
  SingleGiftRewardView.super.OnEnter(self)
  self:sendNotification(UIEvent.CloseUI, UIViewType.TipLayer)
  if #self.rewards <= 4 then
    self.grid.pivot = UIWidget.Pivot.Center
    self.scrollView.contentPivot = UIWidget.Pivot.Center
    self.grid.cellWidth = 145
  else
    self.grid.pivot = UIWidget.Pivot.Left
    self.scrollView.contentPivot = UIWidget.Pivot.Left
    self.grid.cellWidth = 131.2
  end
  self.listCtrl:ResetDatas(self.rewards)
  self.scrollView:ResetPosition()
  self:LoadTextures()
end

function SingleGiftRewardView:OnExit()
  self:UnloadTextures()
  TimeTickManager.Me():ClearTick(self)
  SingleGiftRewardView.super.OnExit(self)
end

function SingleGiftRewardView:OnMouseClick(cellCtl)
  self:ShowGiftTip(cellCtl and cellCtl.rewardId, cellCtl.icon, cellCtl.gameObject)
end

function SingleGiftRewardView:OnCellClick(cellCtrl)
  self.selectedReward = cellCtrl.rewardId
  local cells = self.listCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell ~= cellCtrl then
      cell:SelectCell(false)
    end
  end
  self:SetConfirmBtnState(self.selectedReward ~= nil)
end

function SingleGiftRewardView:LoadTextures()
  for compName, texName in pairs(nameTextureMap) do
    PictureManager.Instance:SetUI(texName, self[compName])
  end
end

function SingleGiftRewardView:UnloadTextures()
  for compName, texName in pairs(nameTextureMap) do
    PictureManager.Instance:UnLoadUI(texName, self[compName])
  end
end

function SingleGiftRewardView:GetGiftCountFromBag()
  return BagProxy.Instance:GetItemNumByStaticID(self.giftStaticId)
end

local tipData = {
  ignoreBounds = {}
}
local tipOffset = {0, -160}

function SingleGiftRewardView:ShowGiftTip(sId, stick, ignoreBound)
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

function SingleGiftRewardView:SetConfirmBtnState(state)
  self.confirmBtn:SetActive(state)
  self.confirmBtnGrey:SetActive(not state)
end
