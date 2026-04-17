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
  if self.jumpSymbol then
    self.jumpSymbol:SetActive(false)
  end
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  if self.chooseSymbol then
    self.chooseSymbolSprite = self.chooseSymbol:GetComponent(UISprite)
  end
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.canExcess = self:FindGO("CanExcess")
  self.excessBg = self:FindGO("ExcessBg")
  self.excessBgSprite = self.excessBg:GetComponent(UISprite)
  self:AddCellClickEvent()
end

function EquipMemoryAttrUnlockCell:SetChoose(bool)
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(bool)
  end
end

function EquipMemoryAttrUnlockCell:SetData(data)
  self.data = data
  if self.chooseSymbol then
    self.chooseSymbol:SetActive(false)
  end
  if self.excessBg then
    self.excessBg:SetActive(false)
  end
  if self.canExcess then
    self.canExcess:SetActive(false)
  end
  if self.jumpSymbol then
    self.jumpSymbol:SetActive(false)
  end
  local canClick = data.canBreakthrough == true or data.canUnlock == true
  if self.boxCollider then
    self.boxCollider.enabled = canClick
  end
  if self.bg then
    self.bg.alpha = 1
  end
  local canBreakthrough = data.canBreakthrough == true
  if self.excessBg then
    self.excessBg:SetActive(canBreakthrough)
  end
  if self.canExcess then
    self.canExcess:SetActive(canBreakthrough)
  end
  if canBreakthrough then
    self.attrName.width = 260
  else
    self.attrName.width = 380
  end
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
    local buffIds = staticData and staticData.BuffID or {}
    local waxBuffIds = staticData and staticData.WaxBuffID or {}
    local excessWaxBuffIds = staticData and staticData.ExcessWaxBuffID or {}
    local isSpecialAttr = (not buffIds or type(buffIds) == "table" and next(buffIds) == nil) and waxBuffIds and type(waxBuffIds) == "table" and next(waxBuffIds) ~= nil
    local curDesc, targetDesc
    if isSpecialAttr then
      local waxDescKey = staticData and staticData.WaxDesc or ""
      local baseDesc = OverSea.LangManager.Instance():GetLangByKey(waxDescKey) or waxDescKey
      if 0 < stageIndexCurrent then
        local getExcessWaxBuffDesc = function(excessWaxBuffIds, stageIndex)
          if not excessWaxBuffIds then
            return nil
          end
          local targetBuffIds
          if type(excessWaxBuffIds) == "table" then
            if excessWaxBuffIds[stageIndex] ~= nil then
              targetBuffIds = excessWaxBuffIds[stageIndex]
            elseif excessWaxBuffIds[0] ~= nil then
              targetBuffIds = excessWaxBuffIds[0]
            else
              targetBuffIds = excessWaxBuffIds[1]
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
        local excessDesc = getExcessWaxBuffDesc(excessWaxBuffIds, stageIndexCurrent)
        if baseDesc and baseDesc ~= "" then
          if excessDesc and excessDesc ~= "" then
            self.attrName.text = baseDesc .. "\n" .. excessDesc
          else
            self.attrName.text = baseDesc
          end
        elseif excessDesc and excessDesc ~= "" then
          self.attrName.text = excessDesc
        else
          self.attrName.text = ""
        end
      else
        self.attrName.text = baseDesc or ""
      end
    else
      curDesc = staticData and getBuffDescByStage(staticData.BuffID, stageIndexCurrent)
      targetDesc = staticData and stageIndexTarget and getBuffDescByStage(staticData.BuffID, stageIndexTarget) or nil
      if (not curDesc or curDesc == "") and staticData then
        local fallbackWaxDesc = staticData.WaxDesc or ""
        curDesc = OverSea.LangManager.Instance():GetLangByKey(fallbackWaxDesc) or fallbackWaxDesc
      end
      self.attrName.text = curDesc or ""
    end
    local curH = self.attrName.printedSize.y
    self.bg.height = curH + 20
    if self.chooseSymbolSprite then
      self.chooseSymbolSprite.height = self.bg.height + 8
    end
    if self.excessBgSprite then
      self.excessBgSprite.height = self.bg.height + 12
    end
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
    if self.chooseSymbolSprite then
      self.chooseSymbolSprite.height = self.bg.height + 8
    end
    if self.excessBgSprite then
      local isSelected = self.chooseSymbol and self.chooseSymbol.activeSelf
      if isSelected then
        self.excessBgSprite.height = self.bg.height + 12
      else
        self.excessBgSprite.height = self.bg.height
      end
    end
  end
end
