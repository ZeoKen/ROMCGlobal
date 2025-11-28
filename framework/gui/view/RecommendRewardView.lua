autoImport("RecommendRewardCell")
RecommendRewardView = class("RecommendRewardView", BaseView)
RecommendRewardView.ViewType = UIViewType.PopUpLayer
local nameTextureMap = {
  Decorate1 = "reward_bg_decorate1",
  Decorate2 = "reward_bg_decorate2",
  Decorate3Left = "reward_bg_decorate3",
  Decorate3Right = "reward_bg_decorate3",
  CloseButtonBg = "reward_bg_close"
}

function RecommendRewardView:Init()
  self:FindObjs()
  self:InitShow()
  self:InitData()
  self:AddListenEvts()
end

function RecommendRewardView:AddListenEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.OnItemUpdate)
  self:AddListenEvt(RecommendRewardEvent.Close, self.CloseSelf)
end

function RecommendRewardView:FindObjs()
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.giftInfo = self:FindGO("GiftInfo")
  self.giftSp = self:FindComponent("GiftIcon", UISprite)
  self.giftCountLabel = self:FindComponent("GiftCountLabel", UILabel)
  for name, _ in pairs(nameTextureMap) do
    self[name] = self:FindComponent(name, UITexture)
  end
  self.cat = self:FindComponent("Cat", UITexture)
  self.noTips = self:FindGO("noTips")
  self.RecommendReward = {}
  for i = 1, 4 do
    self.RecommendReward[i] = self:FindGO("RecommendReward_" .. i)
    self.RecommendReward[i]:SetActive(false)
  end
end

function RecommendRewardView:InitShow()
  self.listCtrl = UIGridListCtrl.new(self.grid, RecommendRewardCell, "RecommendRewardCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnMouseClick, self)
end

function RecommendRewardView:InitData()
  local viewData = self.viewdata.viewdata
  if not viewData or not next(viewData) then
    LogUtility.Error("Cannot find viewData while initializing RecommendRewardView!")
    return
  end
  self.giftStaticId = viewData.gift
  self.useCount = viewData.useCount or 1
  self.giftStaticData = Table_Item[self.giftStaticId]
  self.rewards = {}
  for k, v in pairs(viewData.reward) do
    self.rewards[k] = {}
    for k1, v1 in pairs(v) do
      self.rewards[k][k1] = v1
    end
  end
  if not (self.giftStaticId and self.giftStaticData and self.rewards) or not next(self.rewards) then
    LogUtility.Error("Cannot find valid viewData while initializing RecommendRewardView!")
    return
  end
  local branch = MyselfProxy.Instance:GetMyProfessionTypeBranch()
  helplog("self branch:", branch)
  local branchList = {}
  for k, v in pairs(Table_Equip_recommend) do
    if v.branch == branch then
      branchList[#branchList + 1] = v
    end
  end
  local branchRecommendData = {}
  local branchRecommendgenre = {}
  if 0 < #branchList then
    for i = 1, #branchList do
      for e = 1, #branchList[i].equip do
        branchRecommendData[#branchRecommendData + 1] = branchList[i].equip[e]
        branchRecommendgenre[#branchRecommendgenre + 1] = branchList[i].genre
      end
      for o = 1, #branchList[i].other do
        branchRecommendData[#branchRecommendData + 1] = branchList[i].other[o]
        branchRecommendgenre[#branchRecommendgenre + 1] = branchList[i].genre
      end
    end
  end
  self.recommendData = {}
  for i = 1, #branchRecommendData do
    local isrecommend = false
    local temp
    local re = 0
    for r = 1, #self.rewards do
      if branchRecommendData[i] == self.rewards[r][1] then
        isrecommend = true
        temp = self.rewards[r]
        re = r
        break
      end
    end
    if isrecommend and #self.recommendData < 4 then
      table.remove(self.rewards, re)
      self.recommendData[#self.recommendData + 1] = temp
    end
  end
  self.recommendGenreData = {}
  for r = 1, #self.recommendData do
    for i = 1, #branchList do
      local isrecommend = false
      for e = 1, #branchList[i].equip do
        if branchList[i].equip[e] == self.recommendData[r][1] then
          isrecommend = true
          break
        end
      end
      if isrecommend == false then
        for o = 1, #branchList[i].other do
          if branchList[i].other[o] == self.recommendData[r][1] then
            isrecommend = true
            break
          end
        end
      end
      if isrecommend then
        if self.recommendGenreData[r] then
          self.recommendGenreData[r] = self.recommendGenreData[r] .. " " .. branchList[i].genre
        else
          self.recommendGenreData[r] = branchList[i].genre
        end
      end
    end
  end
  local offset = {
    [1] = {0, 0},
    [2] = {-200, 400},
    [3] = {-350, 350},
    [4] = {-420, 280}
  }
  for i = 1, #self.recommendData do
    local off = offset[#self.recommendData]
    self.RecommendReward[i]:SetActive(true)
    self.RecommendReward[i].gameObject.transform.localPosition = LuaGeometry.GetTempVector3(off[1] + (i - 1) * off[2], 77.5, 0)
    local itemdata = ItemData.new("recommend", self.recommendData[i][1])
    itemdata.num = self.recommendData[i][2]
    itemdata.refine_lv = self.recommendData[i][3] or self.recommendData[i].refine_lv
    local cell = RecommendRewardCell.new(self.RecommendReward[i])
    cell:SetData(itemdata)
    cell:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
    local typeLbl = self:FindGO("typeLbl", self.RecommendReward[i]):GetComponent(UILabel)
    typeLbl.text = self.recommendGenreData[i]
    local getReward = self:FindGO("SelectBtn", self.RecommendReward[i])
    self:AddClickEvent(getReward, function()
      local reward = BagProxy.Instance:GetItemByStaticID(self.giftStaticId, Game.Config_Wallet and Game.Config_Wallet[self.giftStaticId] and BagProxy.BagType.Wallet or nil)
      if not reward then
        LogUtility.ErrorFormat("Cannot find item with static id = {0}!", self.giftStaticId)
        MsgManager.ShowMsgByID(3554, self.giftStaticData.NameZh)
        return
      end
      ServiceItemProxy.Instance:CallItemUse(reward, nil, self.useCount, self.recommendData[i][1])
      self:CloseSelf()
    end)
  end
  if #self.recommendData == 0 then
    self.noTips.gameObject:SetActive(true)
  else
    self.noTips.gameObject:SetActive(false)
  end
  self.rewarddata = {}
  local validList = {}
  for i = 1, #self.rewards do
    local itemdata = ItemData.new("recommend", self.rewards[i][1])
    itemdata.num = self.rewards[i][2]
    itemdata.refine_lv = self.rewards[i][3] or self.rewards[i].refine_lv
    itemdata.giftStaticId = self.giftStaticId
    itemdata.useCount = self.useCount
    if self:IsItemValid(itemdata) then
      self.rewarddata[#self.rewarddata + 1] = itemdata
    else
      validList[#validList + 1] = itemdata
    end
  end
  for i = 1, #validList do
    self.rewarddata[#self.rewarddata + 1] = validList[i]
  end
  helplog("recommend data count:", #branchRecommendData)
end

function RecommendRewardView:IsItemValid(data)
  if data.equipInfo then
    local isValid, lv, mapManager, bagTypeCfg = true, data.staticData.Level or 0, Game.MapManager, BagProxy.BagType
    if lv > MyselfProxy.Instance:RoleLevel() then
      isValid = false
    elseif bagTypeCfg.RoleEquip == data.bagType or bagTypeCfg.RoleFashionEquip == data.bagType then
      isValid = data:CanIOffEquip()
    elseif data.staticData.Type == 101 then
      isValid = true
    elseif data.equipInfo:IsArtifact() and mapManager:IsPveMode_PveCard() then
      isValid = false
    else
      isValid = data:CanEquip() and TableUtility.ArrayFindIndex(data.equipInfo.equipData.MapForbid, mapManager:GetMapID()) == 0
    end
    if DesertWolfProxy.Instance:IsEquipForbidden(data.equipInfo) then
      isValid = false
    end
    return isValid
  end
  return false
end

function RecommendRewardView:OnEnter()
  RecommendRewardView.super.OnEnter(self)
  self:sendNotification(UIEvent.CloseUI, UIViewType.TipLayer)
  self.listCtrl:ResetDatas(self.rewarddata)
  self:LoadTextures()
  self:OnItemUpdate()
end

function RecommendRewardView:OnExit()
  self:UnloadTextures()
  TimeTickManager.Me():ClearTick(self)
  RecommendRewardView.super.OnExit(self)
end

function RecommendRewardView:OnItemUpdate()
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

function RecommendRewardView:OnCellInputChange(cellCtl)
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

function RecommendRewardView:OnMouseClick(cellCtl)
  self:ShowGiftTip(cellCtl and cellCtl.rewardId, cellCtl.icon, cellCtl.gameObject)
end

function RecommendRewardView:UpdateSelected()
  local totalSelectedCount = 0
  for _, count in pairs(self.selectedCounts) do
    totalSelectedCount = totalSelectedCount + count
  end
end

function RecommendRewardView:LoadTextures()
end

function RecommendRewardView:UnloadTextures()
end

function RecommendRewardView:GetGiftCountFromBag()
  return BagProxy.Instance:GetItemNumByStaticID(self.giftStaticId)
end

local tipData = {
  ignoreBounds = {}
}
local tipOffset = {0, -160}

function RecommendRewardView:ShowGiftTip(sId, stick, ignoreBound)
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
  tipData.itemdata.equipInfo.isFromShop = true
  tipData.ignoreBounds[1] = ignoreBound
  tipOffset[1] = -210 * isGoRight
  self:ShowItemTip(tipData, stick, 0 < isGoRight and NGUIUtil.AnchorSide.Left or NGUIUtil.AnchorSide.Right, tipOffset)
end

function RecommendRewardView:OnClickCell(cell)
  local callback = function()
    self:CancelChooseReward()
  end
  local stick = cell.gameObject:GetComponent(UIWidget)
  local item = cell.data:Clone()
  item.equipInfo.isFromShop = true
  local sdata = {
    itemdata = item,
    funcConfig = {},
    callback = callback,
    ignoreBounds = {
      cell.gameObject
    }
  }
  TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
end

function RecommendRewardView:CancelChooseReward()
  self:ShowItemTip()
end
