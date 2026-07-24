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
  self.hide = self:FindGO("Hide")
end

function MountFashionCell:SetData(data)
  self.data = data
  self.id = data.id
  self.index = data.index
  self.isHideSwitch = data.isHideSwitch
  if self.isHideSwitch then
    self.mountId = data.mountId
    self.type = data.type
    self.pos = data.pos
    self.defaultStyleId = data.defaultStyleId
    self.isLocked = false
    self.isCanActive = false
    self.isActived = true
    self.isEquiped = MountFashionProxy.Instance:IsMountFashionHidden(self.mountId, self.pos)
    self.sp.CurrentState = 1
    self.icon.gameObject:SetActive(false)
    if self.hide then
      self.hide:SetActive(true)
    end
    self.lockIcon:SetActive(false)
    self.mask:SetActive(false)
    self.equipIcon:SetActive(self.isEquiped)
    self.activeGo:SetActive(false)
    return
  end
  local config = Table_MountFashion[self.id]
  if config then
    self.icon.gameObject:SetActive(true)
    if self.hide then
      self.hide:SetActive(false)
    end
    IconManager:SetItemIconById(config.ItemID, self.icon)
    self.mountId = config.Mount
    self.type = config.Type
    self.pos = config.Pos
    self.defaultStyleId = nil
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
