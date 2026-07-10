autoImport("BagItemCell")
PetBagItemCell = class("PetBagItemCell", BagItemCell)
local CDTextTickId = 1001

function PetBagItemCell:SetData(data)
  self:StopCDTextTick()
  PetBagItemCell.super.SetData(self, data)
  if self.showMonsterIcon and type(data) == "table" and data.staticData then
    local cfg = Game.Config_EggPet[data.staticData.id]
    if cfg then
      IconManager:SetNpcMonsterIconByID(cfg.id, self.icon)
    end
  end
  self:UpdatePetCD()
end

function PetBagItemCell:SetShowMonsterIcon(value)
  self.showMonsterIcon = value
end

function PetBagItemCell:UpdatePetCD()
  local cd = self:GetPetCD()
  local hasCD = 0 < cd
  self.hasPetCD = hasCD
  self:ClearCellCD()
  if hasCD then
    self:SetCDText(cd)
    self:StartCDTextTick()
  else
    self:StopCDTextTick()
    self:ClearCDText()
    self:RefreshCurrentPetTipFunc()
  end
end

function PetBagItemCell:GetPetCD()
  local data = self.data
  if type(data) == "table" and data.staticData then
    return FunctionItemFunc.GetPetEggCD(data)
  end
  return 0
end

function PetBagItemCell:SetCDText(cd)
  local label = self:GetPetCDLabel()
  if not label then
    return
  end
  label.gameObject:SetActive(true)
  label.text = string.format("%ds", math.ceil(cd))
end

function PetBagItemCell:ClearCDText()
  local label = self.petCDLabel
  if not label then
    return
  end
  label.text = ""
  label.gameObject:SetActive(false)
end

function PetBagItemCell:GetPetCDLabel()
  if not self then
    return nil
  end
  if not self.petCDLabelInited then
    self.petCDLabelInited = true
    self.petCDLabel = self:FindComponent("PetCDLabel", UILabel)
    if self.petCDLabel then
      self.petCDLabel.gameObject:SetActive(false)
    end
  end
  return self.petCDLabel
end

function PetBagItemCell:ClearCellCD()
  if self.cdCtrl and self.cdCtrl.IsRefreshing and self.cdCtrl:IsRefreshing(self) then
    self.cdCtrl:Remove(self)
    self.cdTextTick = nil
  elseif self.ClearCD then
    self:ClearCD()
  end
end

function PetBagItemCell:StartCDTextTick()
  if self.cdTextTick and self.cdTextTick.isTicking then
    return
  end
  TimeTickManager.Me():ClearTick(self, CDTextTickId)
  self.cdTextTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCDTextTick, self, CDTextTickId)
end

function PetBagItemCell:StopCDTextTick()
  if not self.cdTextTick then
    return
  end
  TimeTickManager.Me():ClearTick(self, CDTextTickId)
  self.cdTextTick = nil
end

function PetBagItemCell:UpdateCDTextTick()
  if not self.gameObject or Slua.IsNull(self.gameObject) or not self.gameObject.activeInHierarchy then
    self:StopCDTextTick()
    return
  end
  local cd = self:GetPetCD()
  if 0 < cd then
    self:SetCDText(cd)
  else
    self.hasPetCD = false
    self:StopCDTextTick()
    self:ClearCDText()
    self:RefreshCurrentPetTipFunc()
  end
end

function PetBagItemCell:RefreshCurrentPetTipFunc()
  local data = self.data
  if type(data) ~= "table" or not data.id then
    return
  end
  local tipsView = TipsView.me
  if not tipsView then
    return
  end
  local tip = tipsView.currentTip
  if not tip then
    return
  end
  local tipCell = tip.cells and tip.cells[1]
  if tipCell and type(tipCell.data) == "table" and tipCell.data.id == data.id then
    tipCell.data = data
    tipCell:UpdateTipFunc(tipCell.funcConfig)
  end
end

function PetBagItemCell:OnCellDestroy()
  self:StopCDTextTick()
  if PetBagItemCell.super.OnCellDestroy then
    PetBagItemCell.super.OnCellDestroy(self)
  end
end
