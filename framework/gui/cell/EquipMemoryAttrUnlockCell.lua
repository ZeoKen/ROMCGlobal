EquipMemoryAttrUnlockCell = class("EquipMemoryAttrUnlockCell", BaseCell)

function EquipMemoryAttrUnlockCell:Init()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.targetAttrName = self:FindGO("TargetAttrName"):GetComponent(UILabel)
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
    local getBuffDescByStage = function(buffIds, stageIndex)
      if not buffIds then
        return nil
      end
      local targetBuffIds
      if type(buffIds) == "table" then
        if buffIds[stageIndex] ~= nil then
          targetBuffIds = buffIds[stageIndex]
        elseif buffIds[0] ~= nil then
          targetBuffIds = buffIds[0]
        else
          targetBuffIds = buffIds[1]
        end
      end
      local buffId
      if type(targetBuffIds) == "table" then
        buffId = next(targetBuffIds) and targetBuffIds[next(targetBuffIds)]
      else
        buffId = targetBuffIds
      end
      local buffData = buffId and Table_Buffer[buffId]
      local desc = buffData and buffData.Dsc and OverSea.LangManager.Instance():GetLangByKey(buffData.Dsc)
      if type(desc) == "string" then
        desc = string.gsub(desc, "%[AttrValue%]", "")
      end
      return desc
    end
    local stageIndexCurrent = data and data.excess_lv or 0
    local stageIndexTarget = data.excess_stage
    local curDesc = staticData and getBuffDescByStage(staticData.BuffID, stageIndexCurrent)
    local targetDesc = staticData and stageIndexTarget and getBuffDescByStage(staticData.BuffID, stageIndexTarget) or nil
    if (not curDesc or curDesc == "") and staticData then
      curDesc = staticData.WaxDesc
    end
    self.attrName.text = curDesc or ""
    local isBreakthroughStage = data and (data.excess_stage ~= nil or data.isExcessMode == true) and true or false
    if targetDesc and targetDesc ~= "" and targetDesc ~= curDesc then
      self.targetAttrName.gameObject:SetActive(true)
      self.targetAttrName.text = targetDesc
    else
      self.targetAttrName.gameObject:SetActive(false)
      self.targetAttrName.text = ""
    end
    self.attrName.width = isBreakthroughStage and 160 or 380
    local curH = self.attrName.printedSize.y
    local tarH = self.targetAttrName.gameObject.activeSelf and self.targetAttrName.printedSize.y or 0
    local height = math.max(curH, tarH)
    self.bg.height = height + 20
    local color = attrConfig.Color or "attack"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
  else
    self.attrName.text = ""
    self.targetAttrName.gameObject:SetActive(false)
    self.targetAttrName.text = ""
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
