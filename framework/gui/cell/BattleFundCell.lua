autoImport("UIAutoScrollCtrl")
BattleFundCell = class("BattleFundCell", CoreView)

function BattleFundCell:ctor(obj)
  BattleFundCell.super.ctor(self, obj)
  self:Init()
  self:AddGameObjectComp()
end

function BattleFundCell:Init()
  self.funcBtnGO = self:FindGO("FuncBtn")
  self:AddClickEvent(self.funcBtnGO, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.funcLabel = self:FindComponent("Label", UILabel, self.funcBtnGO)
  self.funcBtnDisabledGO = self:FindGO("FuncBtnDIsabled")
  self.finishGO = self:FindGO("FinishSymbol")
  self.freeBgGO = self:FindGO("FreeBG")
  self.purchasedBgGO = self:FindGO("PurchasedBG")
  self.conditionScroll = self:FindComponent("ConditionPanel", UIScrollView)
  self.conditionLabel = self:FindComponent("ConditionLabel", UILabel, self.conditionScroll.gameObject)
  self.conditionLabelCtrl = UIAutoScrollCtrl.new(self.conditionScroll, self.conditionLabel, 8, 40)
  self:SetPanelDepthByParent(self.conditionScroll.gameObject, 1)
  self.itemIcon = self:FindComponent("ItemIcon", UISprite)
  self.itemNumLabel = self:FindComponent("ItemNum", UILabel)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    local itemData = self.data and self.data.rewardItems and self.data.rewardItems[1]
    local itemID = self.data and self.data.itemId
    local itemData = ItemData.new("ItemReward", itemID)
    if itemData then
      local tipData = ReusableTable.CreateTable()
      tipData.itemdata = itemData
      self:ShowItemTip(tipData, self.itemIcon, NGUIUtil.AnchorSide.Left, {-200, 0})
      ReusableTable.DestroyAndClearTable(tipData)
    end
  end)
end

function BattleFundCell:OnEnable()
  BattleFundCell.super.OnEnable(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Start(false, true)
  end
end

function BattleFundCell:OnDisable()
  BattleFundCell.super.OnDisable(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Stop(true)
  end
end

function BattleFundCell:OnDestroy()
  BattleFundCell.super.OnDestroy(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Destroy()
  end
end

local RewardState = BattleFundData.RewardState

function BattleFundCell:SetData(data)
  self.data = data
  if data.free then
    self.freeBgGO:SetActive(true)
    self.purchasedBgGO:SetActive(false)
    self.funcLabel.text = ZhString.BattleFundTakeFreeReward
    self.conditionLabel.text = string.format(ZhString.ReturnActivityPanel_LoginDays, self.data.day)
  elseif data.ResetDepositReward then
    self.freeBgGO:SetActive(true)
    self.purchasedBgGO:SetActive(false)
    self.funcLabel.text = ZhString.BattleFundTakeReward
    self.conditionLabel.text = ZhString.BattleFundTakeResetDepositReward
  else
    self.freeBgGO:SetActive(false)
    self.purchasedBgGO:SetActive(true)
    self.funcLabel.text = ZhString.BattleFundTakeReward
    self.conditionLabel.text = string.format(ZhString.ReturnActivityPanel_LoginDays, self.data.day)
  end
  if self.gameObject.activeInHierarchy then
    self.conditionLabel:ProcessText()
    if self.conditionLabelCtrl then
      self.conditionLabelCtrl:Start(false, true)
    end
  end
  local itemConfig = Table_Item[data and data.itemId]
  IconManager:SetItemIcon(itemConfig and itemConfig.Icon or "item_151", self.itemIcon)
  self.itemNumLabel.text = "x" .. data.itemNum
  if data.state == RewardState.UnTaken then
    self.finishGO:SetActive(false)
    self.funcBtnGO:SetActive(true)
    self.funcBtnDisabledGO:SetActive(false)
  elseif data.state == RewardState.Taken then
    self.finishGO:SetActive(true)
    self.funcBtnGO:SetActive(false)
    self.funcBtnDisabledGO:SetActive(false)
  elseif data.state == RewardState.CannotTake then
    self.finishGO:SetActive(false)
    self.funcBtnGO:SetActive(false)
    self.funcBtnDisabledGO:SetActive(true)
  end
end
