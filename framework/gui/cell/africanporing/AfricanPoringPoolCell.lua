autoImport("ItemCell")
AfricanPoringPoolCell = class("AfricanPoringPoolCell", ItemCell)

function AfricanPoringPoolCell:Init()
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(UICellEvent.OnCellClicked, self)
  end)
  self.itemContainerGO = self:FindGO("ItemContainer")
  self.itemContainerWidget = self.itemContainerGO:GetComponent(UIWidget)
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainerGO)
  LuaGameObject.SetLocalPositionGO(obj, 0, 0, 0)
  AfricanPoringPoolCell.super.Init(self)
  self.selectedGO = self:FindGO("Selected")
  self.resetEffectGO = self:FindGO("ResetEffect")
  self.resetEffectHandle = self:FindComponent("ufx_boli_turntable_rest_prf", EffectHandle, self.resetEffectGO)
  self.ssrGO = self:FindGO("SsrIcon")
  self.ownedGO = self:FindGO("Owned")
  self.ssrGO:SetActive(false)
  self:SetSelected(false)
  self:ShowResetEffect(false)
  self:ShowReward(nil)
  self:SetOwned(false)
end

function AfricanPoringPoolCell:SetData(data)
  self.cellData = data
  if data then
    local selectedReward = data.selectedReward
    if selectedReward then
      self:ShowReward(selectedReward)
    else
      self:ShowReward(nil)
    end
    self:SetOwned(data:IsPoolHit())
  end
end

function AfricanPoringPoolCell:PlayResetAnim()
  self.resetEffectHandle:Restore()
end

function AfricanPoringPoolCell:ShowResetEffect(b)
  self.resetEffectGO:SetActive(not not b)
end

function AfricanPoringPoolCell:ShowReward(rewardData)
  if rewardData then
    self.itemContainerGO:SetActive(true)
    local itemData = rewardData:GetItemData()
    AfricanPoringPoolCell.super.SetData(self, itemData)
    self:HideBgSp()
  else
    self.itemContainerGO:SetActive(false)
  end
end

function AfricanPoringPoolCell:SetSelected(b)
  if b then
    self.selectedGO:SetActive(true)
  else
    self.selectedGO:SetActive(false)
  end
end

function AfricanPoringPoolCell:SetOwned(b)
  if b then
    self.ownedGO:SetActive(true)
    self.itemContainerWidget.alpha = 0.5
  else
    self.ownedGO:SetActive(false)
    self.itemContainerWidget.alpha = 1
  end
end
