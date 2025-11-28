autoImport("BagCardCell")
ActivitySelfChooseCardCell = class("ActivitySelfChooseCardCell", BagCardCell)

function ActivitySelfChooseCardCell:Init()
  ActivitySelfChooseCardCell.super.Init(self)
  self.mask = self:FindGO("Mask")
  self.effectContainer = self:FindGO("effectContainer")
end

function ActivitySelfChooseCardCell:SetData(data)
  ActivitySelfChooseCardCell.super.SetData(self, data)
  local act_id = data.act_id
  self.itemId = data.staticData.id
  self.isMask = not ActivitySelfChooseProxy.Instance:IsSelfChooseItemHasDrawed(act_id, self.itemId)
  self:SetMask(self.isMask)
end

function ActivitySelfChooseCardCell:SetMask(isMask)
  self.mask:SetActive(isMask)
end

function ActivitySelfChooseCardCell:SetCardAlpha()
end

function ActivitySelfChooseCardCell:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.SelfChooseCardDrawed, self.effectContainer, true)
end
