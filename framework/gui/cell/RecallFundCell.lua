autoImport("UIAutoScrollCtrl")
RecallFundCell = class("RecallFundCell", CoreView)

function RecallFundCell:ctor(obj)
  RecallFundCell.super.ctor(self, obj)
  self:Init()
  self:AddGameObjectComp()
end

function RecallFundCell:Init()
  self.funcBtnGO = self:FindGO("FuncBtn")
  self:AddClickEvent(self.funcBtnGO, function()
    self:OnClickClaimReward()
  end)
  self.funcLabel = self:FindComponent("Label", UILabel, self.funcBtnGO)
  self.funcBtnDisabledGO = self:FindGO("FuncBtnDIsabled")
  self.finishGO = self:FindGO("FinishSymbol")
  self.conditionScroll = self:FindComponent("ConditionPanel", UIScrollView)
  self.conditionLabel = self:FindComponent("ConditionLabel", UILabel, self.conditionScroll.gameObject)
  self.conditionLabelCtrl = UIAutoScrollCtrl.new(self.conditionScroll, self.conditionLabel, 8, 40)
  self:SetPanelDepthByParent(self.conditionScroll.gameObject, 1)
  self.itemIcon = self:FindComponent("ItemIcon", UISprite)
  self.itemNumLabel = self:FindComponent("ItemNum", UILabel)
  self:AddClickEvent(self.itemIcon.gameObject, function()
    local itemData = self.data and self.data.staticData
    local itemID = itemData and itemData.Reward and itemData.Reward.id
    if itemID then
      local rewardData = ItemData.new("ItemReward", itemID)
      if rewardData then
        local tipData = ReusableTable.CreateTable()
        tipData.itemdata = rewardData
        self:ShowItemTip(tipData, self.itemIcon, NGUIUtil.AnchorSide.Left, {-200, 0})
        ReusableTable.DestroyAndClearTable(tipData)
      end
    end
  end)
end

function RecallFundCell:OnEnable()
  RecallFundCell.super.OnEnable(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Start(false, true)
  end
end

function RecallFundCell:OnDisable()
  RecallFundCell.super.OnDisable(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Stop(true)
  end
end

function RecallFundCell:OnDestroy()
  RecallFundCell.super.OnDestroy(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Destroy()
  end
end

function RecallFundCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.funcLabel.text = ZhString.RecallIntegration_Fund_TakeReward or "领取"
  self.conditionLabel.text = string.format(ZhString.ReturnActivityPanel_LoginDays or "登录%d天", data.day)
  if self.gameObject.activeInHierarchy then
    self.conditionLabel:ProcessText()
    if self.conditionLabelCtrl then
      self.conditionLabelCtrl:Start(false, true)
    end
  end
  local staticData = data.staticData
  if staticData and staticData.Reward then
    local reward = staticData.Reward[1]
    local itemConfig = Table_Item[reward[1]]
    IconManager:SetItemIcon(itemConfig and itemConfig.Icon or "item_151", self.itemIcon)
    self.itemNumLabel.text = "x" .. (reward[2] or 1)
  else
    IconManager:SetItemIcon("item_151", self.itemIcon)
    self.itemNumLabel.text = "x1"
  end
  if data.status == 3 then
    self.finishGO:SetActive(true)
    self.funcBtnGO:SetActive(false)
    self.funcBtnDisabledGO:SetActive(false)
  elseif data.status == 2 then
    self.finishGO:SetActive(false)
    self.funcBtnGO:SetActive(true)
    self.funcBtnDisabledGO:SetActive(false)
  else
    self.finishGO:SetActive(false)
    self.funcBtnGO:SetActive(false)
    self.funcBtnDisabledGO:SetActive(true)
  end
end

function RecallFundCell:OnClickClaimReward()
  if not self.data then
    redlog("RecallFundCell:OnClickClaimReward 数据无效")
    return
  end
  local day = self.data.day
  local canClaim = self.data.canClaim
  if not canClaim then
    redlog("RecallFundCell:OnClickClaimReward 基金不可领取", day)
    return
  end
  xdlog("RecallFundCell:OnClickClaimReward 请求领取基金奖励", day)
  if RecallFundProxy.Instance then
    RecallFundProxy.Instance:RequestClaimReward(day)
  else
    redlog("RecallFundProxy未初始化，无法领取奖励")
  end
end
