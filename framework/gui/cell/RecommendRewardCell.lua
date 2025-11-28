autoImport("ItemCell")
RecommendRewardCell = class("RecommendRewardCell", ItemCell)

function RecommendRewardCell:Init()
  local itemCellObjName = "Common_ItemCell"
  local itemContainer = self:FindGO("ItemContainer")
  local itemCell = self:FindGO(itemCellObjName)
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", itemContainer)
    go.name = itemCellObjName
  end
  self:AddClickEvent(itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local getReward = self:FindGO("SelectBtn")
  self:AddClickEvent(getReward, function()
    local reward = BagProxy.Instance:GetItemByStaticID(self.giftStaticId, Game.Config_Wallet and Game.Config_Wallet[self.giftStaticId] and BagProxy.BagType.Wallet or nil)
    if not reward then
      LogUtility.ErrorFormat("Cannot find item with static id = {0}!", self.giftStaticId)
      MsgManager.ShowMsgByID(3554, self.giftStaticData.NameZh)
      return
    end
    ServiceItemProxy.Instance:CallItemUse(reward, nil, self.useCount, self.rewardId)
    self:sendNotification(RecommendRewardEvent.Close)
  end)
  self.refinelvEx = self:FindGO("refineLVEx"):GetComponent(UILabel)
  RecommendRewardCell.super.Init(self)
end

function RecommendRewardCell:SetData(data)
  RecommendRewardCell.super.SetData(self, data)
  self.rewardId = data.staticData.id
  self.num = data.num
  self.useCount = data.useCount
  self.refine_lv = data.refine_lv
  self.giftStaticId = data.giftStaticId
  if self.refine_lv then
    self.refinelvEx.text = "+" .. self.refine_lv
    self.refinelvEx.gameObject:SetActive(true)
  else
    self.refinelvEx.gameObject:SetActive(false)
  end
  self:UpdateMyselfInfo()
end
