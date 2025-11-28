EquipMemoryAttrUnlockCell = class("EquipMemoryAttrUnlockCell", BaseCell)

function EquipMemoryAttrUnlockCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.colorSymbol = self:FindGO("ColorSymbol"):GetComponent(UISprite)
  self.unlockTip = self:FindGO("UnlockTip"):GetComponent(UILabel)
  self.unlockLvTip = self:FindGO("UnlockLvTip"):GetComponent(UILabel)
  self.lockSymbol = self:FindGO("LockSymbol")
  self.newSymbol = self:FindGO("NewSymbol")
  self.jumpSymbol = self:FindGO("JumpBtn")
  self:AddCellClickEvent()
end

function EquipMemoryAttrUnlockCell:SetData(data)
  self.data = data
  local attrId = data.id
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    self.unlockLvTip.gameObject:SetActive(false)
    self.unlockTip.gameObject:SetActive(false)
    self.lockSymbol:SetActive(false)
    self.colorSymbol.gameObject:SetActive(true)
    self.newSymbol:SetActive(false)
    local level = 1
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    self.attrName.text = staticData and staticData.WaxDesc
    local height = self.attrName.printedSize.y
    self.bg.height = height + 20
    local color = attrConfig.Color or "attack"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
  else
    self.attrName.text = ""
    self.lockSymbol:SetActive(true)
    self.colorSymbol.gameObject:SetActive(false)
    local canUnlock = data.canUnlock or false
    if canUnlock then
      self.jumpSymbol:SetActive(data.isFourth or false)
      self.unlockTip.gameObject:SetActive(true)
      if data.text and data.text ~= "" then
        self.unlockTip.text = data.text
      else
        self.unlockTip.text = string.format(ZhString.EquipMemory_AttrResetUnlockTip2, data.unlockLv)
      end
      self.unlockLvTip.gameObject:SetActive(false)
      self.newSymbol:SetActive(true)
    else
      self.unlockTip.gameObject:SetActive(false)
      self.unlockLvTip.gameObject:SetActive(true)
      self.unlockLvTip.text = string.format(ZhString.EquipMemory_AttrResetUnlockTip, data.unlockLv)
      self.newSymbol:SetActive(false)
    end
    self.bg.height = 46
  end
end
