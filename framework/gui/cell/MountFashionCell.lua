MountFashionCell = class("MountFashionCell", BaseCell)

function MountFashionCell:Init()
  self:FindObjs()
end

function MountFashionCell:FindObjs()
  self:AddCellClickEvent()
  self.sp = self:FindComponent("Item", UIMultiSprite)
  self.lockIcon = self:FindGO("lockFlag")
  self.selectSp = self:FindGO("chooseImg")
  self.equipIcon = self:FindGO("Equiped")
  self.activeGo = self:FindGO("Active")
  self.icon = self:FindComponent("icon", UISprite)
  self.mask = self:FindGO("mask")
end

function MountFashionCell:SetData(data)
  self.id = data.id
  self.index = data.index
  local config = Table_MountFashion[self.id]
  if config then
    IconManager:SetItemIconById(config.ItemID, self.icon)
    self.type = config.Type
    self.pos = config.Pos
    self.isLocked = not FunctionUnLockFunc.Me():CheckCanOpen(config.MenuID)
    self.isCanActive = MountFashionProxy.Instance:IsFashionCanActive(self.id)
    self.isActived = MountFashionProxy.Instance:IsFashionActived(self.id)
    local isGrey = not self.isActived
    self.sp.CurrentState = isGrey and 0 or 1
    self.icon.color = isGrey and ColorUtil.NGUIShaderGray or ColorUtil.NGUIWhite
    local isLocked = not MountFashionProxy.Instance:IsFashionNeedCostMaterial(self.id) and self.isLocked
    self.lockIcon:SetActive(isLocked)
    self.mask:SetActive(isLocked)
    self.isEquiped = MountFashionProxy.Instance:IsEquipedFashion(self.id)
    self.equipIcon:SetActive(self.isEquiped)
    self.activeGo:SetActive(self.isCanActive)
  end
end

function MountFashionCell:SetSelectState(state)
  self.selectSp:SetActive(state)
end
