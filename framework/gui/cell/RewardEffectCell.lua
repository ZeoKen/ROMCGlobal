RewardEffectCell = class("RewardEffectCell", ItemCell)
local TabConfig = {
  [1] = "bag_tx_2",
  [2] = "bag_tx_1",
  [3] = "bag_tx_3"
}
local _RedTip = {
  [1] = SceneTip_pb.EREDSYS_USEREFFECT_TRANSMIT,
  [2] = SceneTip_pb.EREDSYS_USEREFFECT_KILL,
  [3] = SceneTip_pb.EREDSYS_USEREFFECT_RUN
}

function RewardEffectCell:Init()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  self.objInUse = self:FindGO("InUse")
  self.emptyPart = self:FindComponent("Eye", UISprite)
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
      self:Hide(self.emptyPart)
    else
      itemdata = ItemData.new("reward", 0)
      self.objInUse:SetActive(false)
      self.limitTimeFlag:SetActive(false)
      self:Show(self.emptyPart)
      local spName = TabConfig[data.tabType]
      IconManager:SetUIIcon(spName, self.emptyIcon)
      self.emptyIcon:MakePixelPerfect()
    end
    RewardEffectCell.super.SetData(self, itemdata)
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
  local redtip = _RedTip[data.tabType]
  if not redtip then
    return
  end
  if RedTipProxy.Instance:IsNew(redtip, data.id) then
    RedTipProxy.Instance:RegisterUI(redtip, self.emptyPart, 100, {20, 0}, NGUIUtil.AnchorSide.TopLeft, data.id)
  else
    RedTipProxy.Instance:UnRegisterUI(redtip, self.emptyPart)
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
