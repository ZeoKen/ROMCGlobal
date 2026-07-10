local BaseCell = autoImport("BaseCell")
autoImport("BagItemCell")
autoImport("BattlePassUpgradeDescCell")
BattlePassNewUpgradeCardCell = class("BattlePassNewUpgradeCardCell", BaseCell)
BattlePassNewUpgradeCardEvent = {
  ClickBuy = "BattlePassNewUpgradeCardEvent_ClickBuy"
}
local TitleSubTitleSeparator = string.char(194, 183)
local RewardItemScale = 0.8

function BattlePassNewUpgradeCardCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function BattlePassNewUpgradeCardCell:FindObjs()
  self.bgTex = self.gameObject:GetComponent(UITexture)
  self.title = self:FindComponent("Title", UILabel)
  self.subTitle = self:FindComponent("SubTitle", UILabel)
  self.rebateBg = self:FindGO("RebateBg")
  self.rebate = self:FindComponent("Rebate", UILabel)
  self.buyBtn = self:FindGO("BuyBtn")
  self.price = self:FindComponent("Price", UILabel)
  self.priceIcon = self:FindComponent("PriceIcon", UISprite, self.buyBtn)
  self.tip = self:FindComponent("Tip", UILabel)
  local content = self:FindComponent("Content", UIGrid)
  if content then
    self.contentList = UIGridListCtrl.new(content, BattlePassUpgradeDescCell, "BattlePassNewUpgradeDescCell")
  end
  local rewardGrid = self:FindComponent("Grid", UIGrid)
  if rewardGrid then
    self.rewardList = UIGridListCtrl.new(rewardGrid, BagItemCell, "BagItemCell")
    self.rewardList:AddEventListener(MouseEvent.MouseClick, self.HandleRewardClick, self)
  end
end

function BattlePassNewUpgradeCardCell:AddEvts()
  if self.buyBtn then
    self:AddClickEvent(self.buyBtn, function()
      self:PassEvent(BattlePassNewUpgradeCardEvent.ClickBuy, self)
    end)
  end
end

function BattlePassNewUpgradeCardCell:SetData(data)
  self.data = data
  local hasData = data and data.info ~= nil
  self.gameObject:SetActive(hasData == true)
  if not hasData then
    self:SetBgTex(nil)
    return
  end
  self:SetBgTex(data.bgTexName)
  self:SetTitle(data.title or data.info.Name or "")
  self:SetPrice(data.price or "", data.priceItemId)
  self:SetRebate(data.rebate)
  if self.buyBtn then
    self:SetButtonEnable(self.buyBtn, data.enable == true, ColorUtil.ButtonLabelOrange)
  end
  self:SetTip(data.tipText, data.tipActive == true)
  self:SetContentList(data.descDatas)
  self:SetRewardList(data.rewardDatas)
end

function BattlePassNewUpgradeCardCell:SetContentList(datas)
  if self.contentList then
    self.contentList:ResetDatas(datas or {})
  end
end

function BattlePassNewUpgradeCardCell:SetRewardList(datas)
  if self.rewardList then
    self.rewardList:ResetDatas(datas or {})
    local cells = self.rewardList:GetCells()
    for i = 1, #cells do
      cells[i].gameObject.transform.localScale = LuaGeometry.GetTempVector3(RewardItemScale, RewardItemScale, RewardItemScale)
    end
  end
end

function BattlePassNewUpgradeCardCell:SetBgTex(texName)
  if not self.bgTex or self.bgTexName == texName then
    return
  end
  if self.bgTexName then
    PictureManager.Instance:UnloadBattlePassTexture(self.bgTexName, self.bgTex)
    self.bgTexName = nil
  end
  if texName and texName ~= "" then
    self.bgTexName = texName
    PictureManager.Instance:SetBattlePassTexture(texName, self.bgTex)
  end
end

function BattlePassNewUpgradeCardCell:SetTip(text, active)
  if not self.tip then
    return
  end
  self.tip.text = text or ""
  self.tip.gameObject:SetActive(active == true)
end

function BattlePassNewUpgradeCardCell:SetRebate(rebate)
  if not self.rebate then
    return
  end
  if BranchMgr.IsJapan() then
    if self.rebateBg then
      self.rebateBg:SetActive(false)
    end
    return
  end
  if rebate then
    self.rebate.text = string.format(ZhString.BattlePassUpgradeView_Rebate, rebate)
    if self.rebateBg then
      self.rebateBg:SetActive(true)
    end
  elseif self.rebateBg then
    self.rebateBg:SetActive(false)
  end
end

function BattlePassNewUpgradeCardCell:SetTitle(text)
  text = text or ""
  local titleText = text
  local subTitleText = ""
  local splitStart, splitEnd = string.find(text, TitleSubTitleSeparator, 1, true)
  if splitStart then
    titleText = string.sub(text, 1, splitStart - 1)
    subTitleText = string.sub(text, splitEnd + 1)
  end
  self:SetLabel(self.title, titleText)
  self:SetLabel(self.subTitle, subTitleText)
  if self.subTitle then
    self.subTitle.gameObject:SetActive(splitStart ~= nil)
  end
end

function BattlePassNewUpgradeCardCell:SetLabel(label, text)
  if label then
    label.text = text or ""
  end
end

function BattlePassNewUpgradeCardCell:SetPrice(text, priceItemId)
  self:SetLabel(self.price, text)
  self:SetPriceIcon(priceItemId)
end

function BattlePassNewUpgradeCardCell:SetPriceIcon(priceItemId)
  if not self.priceIcon then
    return
  end
  local itemData = priceItemId and Table_Item and Table_Item[priceItemId]
  local icon = itemData and itemData.Icon
  self.priceIcon.gameObject:SetActive(icon ~= nil)
  if icon then
    IconManager:SetItemIcon(icon, self.priceIcon)
  end
end

function BattlePassNewUpgradeCardCell:HandleRewardClick(cellctl)
  self:PassEvent(MouseEvent.MouseClick, cellctl)
end

function BattlePassNewUpgradeCardCell:OnCellDestroy()
  self:SetBgTex(nil)
  BattlePassNewUpgradeCardCell.super.OnCellDestroy(self)
end
