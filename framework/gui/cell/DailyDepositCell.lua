autoImport("UIAutoScrollCtrl")
DailyDepositCell = class("DailyDepositCell", CoreView)

function DailyDepositCell:ctor(obj)
  DailyDepositCell.super.ctor(self, obj)
  self:Init()
  self:AddGameObjectComp()
end

local itemTipOffset = {-210, 0}

function DailyDepositCell:Init()
  self.funcBtnGO = self:FindGO("FuncBtn")
  self:AddClickEvent(self.funcBtnGO, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.funcBtnDisabledGO = self:FindGO("FuncBtnDIsabled")
  self.finishGO = self:FindGO("FinishSymbol")
  local conditionPanel = self:FindComponent("ConditionPanel", UIPanel)
  self:SetPanelDepthByParent(conditionPanel.gameObject, 1)
  self.conditionLabel = self:FindComponent("ConditionLabel", UIRichLabel)
  self.conditionLabelCtrl = UIAutoScrollCtrl.new(conditionPanel:GetComponent(UIScrollView), self.conditionLabel, 8, 40)
  self.conditionSPLabel = SpriteLabel.new(self.conditionLabel, 500, 32, 32)
  self.itemGridGO = self:FindGO("ItemGrid")
  self.itemGrid = self.itemGridGO:GetComponent(UIGrid)
  self.itemGOs = {
    self:FindGO("Item1", self.itemGridGO),
    self:FindGO("Item2", self.itemGridGO),
    self:FindGO("Item3", self.itemGridGO)
  }
  self.itemIcons = {}
  self.itemNumLabels = {}
  for i, itemGO in ipairs(self.itemGOs) do
    self.itemIcons[i] = self:FindComponent("ItemIcon", UISprite, itemGO)
    self.itemNumLabels[i] = self:FindComponent("ItemNum", UILabel, itemGO)
    self:AddClickEvent(itemGO, function()
      local itemData = self.data and self.data.rewardItems and self.data.rewardItems[i]
      if itemData then
        local tipData = ReusableTable.CreateTable()
        tipData.itemdata = itemData
        tipData.funcConfig = {}
        TipManager.Instance:ShowItemFloatTip(tipData, self.itemIcons[i], NGUIUtil.AnchorSide.Left, itemTipOffset)
        ReusableTable.DestroyAndClearTable(tipData)
      end
    end)
  end
end

function DailyDepositCell:OnEnable()
  DailyDepositCell.super.OnEnable(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Start(false, true)
  end
end

function DailyDepositCell:OnDisable()
  DailyDepositCell.super.OnDisable(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Stop(true)
  end
end

function DailyDepositCell:OnDestroy()
  DailyDepositCell.super.OnDestroy(self)
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Destroy()
  end
end

function DailyDepositCell:SetData(data)
  self.data = data
  self.conditionSPLabel:SetText(data.Condition or "")
  self.conditionSPLabel:SetText(data.Condition or "")
  if self.conditionLabelCtrl then
    self.conditionLabelCtrl:Start(true)
  end
  for i, itemIcon in ipairs(self.itemIcons) do
    local itemData = data.rewardItems and data.rewardItems[i]
    if itemData then
      self.itemGOs[i]:SetActive(true)
      IconManager:SetItemIcon(itemData.staticData.Icon, itemIcon)
      self.itemNumLabels[i].text = itemData.num or ""
    else
      self.itemGOs[i]:SetActive(false)
    end
  end
  self.itemGrid:Reposition()
  local RewardState = DailyDepositData.RewardState
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
