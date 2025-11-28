RewardEffectCell = class("RewardEffectCell", ItemCell)
local TabConfig = {
  [1] = "bag_tx_2",
  [2] = "bag_tx_1"
}

function RewardEffectCell:Init()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  self.objInUse = self:FindGO("InUse")
  self.emptyPart = self:FindGO("Eye")
  self.emptyIcon = self:FindComponent("EmptyIcon", UISprite)
  self.limitTimeFlag = self:FindGO("FlagSp")
  RewardEffectCell.super.Init(self)
  self:AddCellClickEvent()
end

function RewardEffectCell:SetData(data)
  if data then
    self.effectData = data
    self.isused = data.isused
    local config = Table_UserEffectInfo[data.id]
    local itemdata
    if config and data.id ~= 0 then
      itemdata = ItemData.new("reward", config.Item)
      self.objInUse:SetActive(data.isused == true)
      self.limitTimeFlag:SetActive(data.endtime and 0 < data.endtime or data.end_gvg_season and 0 < data.end_gvg_season or false)
      self.emptyPart:SetActive(false)
    else
      itemdata = ItemData.new("reward", 0)
      self.objInUse:SetActive(false)
      self.limitTimeFlag:SetActive(false)
      self.emptyPart:SetActive(true)
      local spName = TabConfig[data.tabType]
      IconManager:SetUIIcon(spName, self.emptyIcon)
      self.emptyIcon:MakePixelPerfect()
    end
    RewardEffectCell.super.SetData(self, itemdata)
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end

function RewardEffectCell:SetChoose(id)
  self.chooseId = id
end

function RewardEffectCell:UpdateChoose()
  if self.itemId and self.itemId == self.chooseId then
    self.chooseImg:SetActive(true)
  else
    self.chooseImg:SetActive(false)
  end
end
