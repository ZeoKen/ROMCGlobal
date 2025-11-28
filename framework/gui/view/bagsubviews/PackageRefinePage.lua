PackageRefinePage = class("PackageRefinePage", SubView)
PackageRefinePage.PfbPath = "part/EquipRefineBord"
autoImport("EquipRefineBord")

function PackageRefinePage:Init()
  self:MapEvent()
end

function PackageRefinePage:MapEvent()
  self:AddListenEvt(ServiceEvent.ItemEquipRefine, self.RecvRefineResult)
  self:AddListenEvt(ServiceEvent.ItemEquipRepair, self.RecvRefineResult)
  self:AddListenEvt(ItemEvent.EquipUpdate, self.RecEquipUpdate)
end

function PackageRefinePage:RecvRefineResult(note)
  if self.bord_Control == nil then
    return
  end
  local nowItem = self.bord_Control:GetNowItemData()
  if nowItem == nil then
    return
  end
  self.bordDirty = true
end

function PackageRefinePage:RecEquipUpdate(note)
  if self.bordDirty ~= true then
    return
  end
  if self.bord_Control == nil then
    return
  end
  self.bord_Control:Refresh()
  self.bordDirty = false
end

function PackageRefinePage:Show()
  if not self.initView then
    self.initView = true
    self.bord = self:FindGO("RefineParent")
    self:LoadPreferb(self.PfbPath, self.bord, true)
    self.bord_Control = EquipRefineBord.new(self.bord)
    self.bord_Control:SetEmptyStyle(1)
    self.bord_Control:ActiveTitle(false)
    self.bord_Control:AddEventListener(EquipRefineBord_Event.DoRefine, self.DoRefineCall, self)
    self.bord_Control:AddEventListener(EquipRefineBord_Event.DoRepair, self.DoRepairCall, self)
  end
  local equipCell = self.container:GetChooseEquip()
  if equipCell then
    self:SetRefineEquip(equipCell.data)
  else
    self:SetRefineEquip(nil)
  end
  if self.bord then
    self.bord:SetActive(true)
  end
end

function PackageRefinePage:DoRefineCall(control)
end

function PackageRefinePage:DoRepairCall()
end

function PackageRefinePage:SetRefineEquip(equip)
  if self.bord_Control == nil then
    return
  end
  self.bord_Control:SetTargetItem(equip)
end

function PackageRefinePage:Hide()
  if self.bord then
    self.bord:SetActive(false)
  end
  if self.bord_Control then
    self.bord_Control:SetTargetItem(nil)
  end
end
