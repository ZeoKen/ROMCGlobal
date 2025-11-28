EquipMemoryAttrCell = class("EquipMemoryAttrCell", BaseCell)

function EquipMemoryAttrCell:Init()
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.attrValue = self:FindComponent("AttrValue", UILabel)
  self.chooseSymbol = self:FindGO("ChooseSymbol"):GetComponent(UISprite)
  self.chooseSymbolBg = self:FindGO("ChooseSymbolBg")
  if self.chooseSymbolBg then
    self.chooseSymbolBg = self.chooseSymbolBg:GetComponent(UISprite)
  end
  self.colorSymbol = self:FindGO("ColorSymbol"):GetComponent(UISprite)
  self.bg = self.gameObject:GetComponent(UISprite)
  self:AddClickEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.sizeContainer = self:FindGO("Container"):GetComponent(UIWidget)
  self.lockSymbol = self:FindGO("LockSymbol")
  self:AddCellClickEvent()
end

function EquipMemoryAttrCell:SetData(data)
  self.data = data
  local level = 1
  self.attrValue.text = level
  local attrId = data.id
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    local buffDesc
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    self.attrName.text = staticData and staticData.WaxDesc
    local color = attrConfig.Color or "attack"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName
    local height = self.attrName.printedSize.y
    self.bg.height = height + 8
    self.chooseSymbol.height = height + 18
    self.sizeContainer.height = height + 18
    self.lockSymbol:SetActive(false)
    self.colorSymbol.gameObject:SetActive(true)
    self.colorSymbol:MakePixelPerfect()
  else
    if data.unlockLv then
      local formatStr = data.unlockTip or ZhString.EquipMemory_AttrResetUnlockTip
      self.attrName.text = string.format(formatStr, data.unlockLv)
    else
      self.attrName.text = data.text or ""
    end
    self.bg.height = 30
    self.chooseSymbol.height = 40
    self.sizeContainer.height = 40
    self.lockSymbol:SetActive(true)
    self.colorSymbol.gameObject:SetActive(false)
  end
  if self.chooseSymbolBg then
    self.chooseSymbolBg:ResetAndUpdateAnchors()
  end
end

function EquipMemoryAttrCell:SetChoose(bool)
  self.chooseSymbol.gameObject:SetActive(bool)
end

function EquipMemoryAttrCell:SetEnable(bool)
  self.bg.alpha = bool and 1 or 0.6
end

EquipMemoryAttrCellType2 = class("EquipMemoryAttrCellType2", EquipMemoryAttrCell)

function EquipMemoryAttrCellType2:SetData(data)
  self.data = data
  local level = 1
  self.attrValue.text = level
  local attrId = data.id
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    self.attrName.text = staticData and staticData.WaxDesc
    local color = attrConfig.Color or "red"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
    local height = self.attrName.printedSize.y
    self.bg.height = height + 20
    self.chooseSymbol.height = height + 25
    self.lockSymbol:SetActive(false)
    self.colorSymbol.gameObject:SetActive(true)
    self.colorSymbol:MakePixelPerfect()
  else
    local formatStr = data.unlockTip or ZhString.EquipMemory_AttrResetUnlockTip
    self.attrName.text = string.format(formatStr, data.unlockLv)
    self.bg.height = 46
    self.chooseSymbol.height = 51
    self.lockSymbol:SetActive(true)
    self.colorSymbol.gameObject:SetActive(false)
  end
  if self.chooseSymbolBg then
    self.chooseSymbolBg:UpdateAnchors()
  end
end

EquipMemoryAttrCellType3 = class("EquipMemoryAttrCellType3", EquipMemoryAttrCell)

function EquipMemoryAttrCellType3:SetData(data)
  self.data = data
  local level = data.level or 1
  self.attrValue.text = level
  local attrId = data.id
  local descStr = ""
  local attrInfo = ItemUtil.GetMemoryEffectInfo(attrId)
  if attrInfo then
    local _formatStr = attrInfo[1] and attrInfo[1].FormatStr
    local _valueList = attrInfo[1] and attrInfo[1].AttrValue
    if _formatStr and _valueList then
      for m in _formatStr:gmatch("[AttrValue]") do
        local _replaceValue = table.remove(_valueList, 1)
        if _replaceValue then
          _formatStr = _formatStr:gsub("%[.-]", _replaceValue * level, 1)
        end
      end
      descStr = descStr .. _formatStr
    end
  else
    redlog("no effect info")
  end
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    if 3 < level then
      level = 3
    end
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local waxBuffId = staticData.WaxBuffID
      if waxBuffId and 0 < #waxBuffId then
        for i = 1, #waxBuffId do
          local buffData = Table_Buffer[waxBuffId[i]]
          if buffData and buffData.BuffEffect and not buffData.BuffEffect.NoShow then
            local dsc = buffData and buffData.Dsc
            if dsc and dsc ~= "" then
              if descStr ~= "" then
                descStr = descStr .. "\n"
              end
              descStr = descStr .. dsc
            end
          end
        end
      end
    end
    local color = attrConfig.Color or "red"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
    self.colorSymbol:MakePixelPerfect()
  end
  if descStr ~= "" then
    self.attrName.text = descStr
  end
  local height = self.attrName.printedSize.y
  self.bg.height = height + 30
  if self.chooseSymbolBg then
    self.chooseSymbolBg:UpdateAnchors()
  end
end

EquipMemoryAttrCellType5 = class("EquipMemoryAttrCellType5", EquipMemoryAttrCell)

function EquipMemoryAttrCellType5:Init()
  EquipMemoryAttrCellType5.super.Init(self)
  self.waxName = self:FindComponent("WaxName", UILabel)
end

function EquipMemoryAttrCellType5:SetData(data)
  self.data = data
  local level = data.level or 1
  self.attrValue.text = level
  local attrId = data.id
  local descStr = ""
  local attrConfig = Game.ItemMemoryEffect[attrId]
  if attrConfig then
    if 3 < level then
      level = 3
    end
    local staticId = attrConfig.level and attrConfig.level[level]
    local staticData = staticId and Table_ItemMemoryEffect[staticId]
    if staticData then
      local waxBuffId = staticData.WaxBuffID
      if waxBuffId and 0 < #waxBuffId then
        self.waxName.text = OverSea.LangManager.Instance():GetLangByKey(staticData.PreviewDesc) .. string.format("(%d/%d)", level, 3)
        for i = 1, #waxBuffId do
          local buffData = Table_Buffer[waxBuffId[i]]
          if buffData and buffData.BuffEffect and not buffData.BuffEffect.NoShow then
            local dsc = buffData and buffData.Dsc
            if dsc and dsc ~= "" then
              if descStr ~= "" then
                descStr = descStr .. "\n"
              end
              descStr = descStr .. dsc
            end
          end
        end
      end
    end
    local color = attrConfig.Color or "red"
    local _iconName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
    self.colorSymbol.spriteName = _iconName .. "s"
    self.colorSymbol:MakePixelPerfect()
  end
  if descStr ~= "" then
    self.attrName.text = descStr
  end
  local height = self.attrName.printedSize.y
  self.bg.height = height + 60
  if self.chooseSymbolBg then
    self.chooseSymbolBg:UpdateAnchors()
  end
end
