EquipMemoryAttrChangeCell = class("EquipMemoryAttrChangeCell", BaseCell)

function EquipMemoryAttrChangeCell:Init()
  self.attrName = self:FindComponent("AttrName", UILabel)
  self.attrValue = self:FindComponent("AttrValue", UILabel)
  self.curLv = self:FindGO("CurLv"):GetComponent(UILabel)
  self.curWax = self:FindGO("Wax", self.curLv.gameObject):GetComponent(UIMultiSprite)
  self.colorSymbol = self:FindGO("ColorSymbol"):GetComponent(UISprite)
  self.lvUpPreviewTip = self:FindGO("LvUpPreviewTip"):GetComponent(UILabel)
  self.waxLvUpPreviewTip = self:FindGO("WaxPreviewLvUp")
  self.maxLvTip = self:FindGO("MaxLvTip"):GetComponent(UILabel)
  self.lvUpTip = self:FindGO("LvUpTip"):GetComponent(UILabel)
  self.waxLvUpTip = self:FindGO("WaxLvUp"):GetComponent(UIMultiSprite)
  self.arrow = self:FindGO("Arrow")
  self.detailBg = self:FindGO("DetailBg"):GetComponent(UISprite)
  self.detailGrid = self:FindGO("DetailGrid"):GetComponent(UITable)
  self.effectName = self:FindGO("EffectName"):GetComponent(UILabel)
  self.effectCurValue = self:FindGO("CurValue"):GetComponent(UILabel)
  self.effectTargetValue = self:FindGO("TargetValue"):GetComponent(UILabel)
  self.effectArrow = self:FindGO("Arrow", self.detailGrid.gameObject)
  self.waxDesc = self:FindGO("WaxDesc"):GetComponent(UILabel)
  self.folderState = false
  self:AddCellClickEvent()
end

local _Seperator = "[AttrValue]"

function EquipMemoryAttrChangeCell:SetData(data)
  if data then
    self.gameObject:SetActive(true)
    self.data = data
    local level = data.curValue
    self.curLv.text = level
    local waxLevel = data.waxLevel or 0
    self.curWax.gameObject:SetActive(0 < waxLevel)
    self.curWax.CurrentState = 2 < level and 1 or 0
    local targetLevel = data.targetValue
    local memoryLevel = data.memoryLevel
    local nextStepLv = data.nextStepLv
    if level == targetLevel then
      if level == 1 or nextStepLv and nextStepLv - memoryLevel <= 5 then
        self.lvUpTip.gameObject:SetActive(false)
        self.maxLvTip.gameObject:SetActive(false)
        self.lvUpPreviewTip.gameObject:SetActive(true)
        self.lvUpPreviewTip.text = string.format(ZhString.EquipMemory_AttrLvUpTip, nextStepLv)
        self.waxLvUpPreviewTip:SetActive(0 < waxLevel)
      elseif level == 3 then
        self.lvUpTip.gameObject:SetActive(false)
        self.maxLvTip.gameObject:SetActive(false)
        self.lvUpPreviewTip.gameObject:SetActive(false)
      else
        self.lvUpTip.gameObject:SetActive(false)
        self.maxLvTip.gameObject:SetActive(true)
        self.lvUpPreviewTip.gameObject:SetActive(false)
        self.maxLvTip.text = string.format(ZhString.EquipMemory_MaxAttrLvUpTip, nextStepLv)
      end
    else
      self.lvUpTip.gameObject:SetActive(true)
      self.maxLvTip.gameObject:SetActive(false)
      self.lvUpPreviewTip.gameObject:SetActive(false)
      self.lvUpTip.text = targetLevel
      self.lvUpTip.color = (not level or level < targetLevel) and LuaGeometry.GetTempVector4(0.25098039215686274, 0.5882352941176471, 0, 1) or LuaGeometry.GetTempVector4(0.7686274509803922, 0.03137254901960784, 0.0392156862745098, 1)
      self.waxLvUpTip.gameObject:SetActive(0 < waxLevel)
      self.waxLvUpTip.CurrentState = 2 < targetLevel and 1 or 0
    end
    self.curLv.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(memoryLevel == 30 and 144 or 0, 0, 0)
    local attrId = data.id
    local attrConfig = Game.ItemMemoryEffect[attrId]
    if attrConfig then
      local buffName
      local _level = level == 0 and 1 or level
      local color = attrConfig.Color or "red"
      self.colorSymbol.spriteName = GameConfig.EquipMemory.AttrTypeIcon and GameConfig.EquipMemory.AttrTypeIcon[color].Icon
      local attrInfo = ItemUtil.GetMemoryEffectInfo(attrId)
      if attrInfo then
        self.attrName.text = attrInfo[_level].BuffName or "???"
        if attrInfo[_level].FormatStr then
          self.effectName.text = string.gsub(attrInfo[_level].FormatStr, "%[.-]", "")
        end
        if not targetLevel or _level == targetLevel then
          self.effectArrow:SetActive(false)
          self.effectCurValue.text = ""
          self.effectTargetValue.text = attrInfo[_level].AttrValue[1]
          self.effectTargetValue.color = LuaGeometry.GetTempVector4(0.3176470588235294, 0.30980392156862746, 0.4823529411764706, 1)
        else
          self.effectArrow:SetActive(true)
          self.effectCurValue.text = attrInfo[_level].AttrValue[1]
          self.effectTargetValue.text = attrInfo[targetLevel].AttrValue[1]
          self.effectTargetValue.color = LuaGeometry.GetTempVector4(0.25098039215686274, 0.5882352941176471, 0, 1)
        end
      end
      local waxInfo = ItemUtil.GetMemoryWaxDesc(attrId, waxLevel)
      if waxInfo and 0 < waxLevel then
        local waxDesc = waxInfo and waxInfo[waxLevel] or ""
        if waxDesc ~= "" then
          waxDesc = string.format(ZhString.EquipMemory_WaxProcess, waxLevel) .. "\n" .. waxDesc
        end
        if waxLevel < 3 then
          local staticId = attrConfig.level and attrConfig.level[3]
          local staticData = staticId and Table_ItemMemoryEffect[staticId]
          local maxEffect = staticData and staticData.WaxDesc
          if maxEffect and maxEffect ~= "" then
            waxDesc = waxDesc .. "\n" .. string.format(ZhString.EquipMemory_WaxProcessMaxEffect, maxEffect)
          end
        end
        if waxDesc ~= "" then
          self.waxDesc.text = waxDesc
        end
      end
    end
    self.arrow.transform.localRotation = Quaternion.Euler(0, 0, self.folderState and -90 or 0)
    self.detailGrid.gameObject:SetActive(self.folderState)
    self.detailBg.gameObject:SetActive(self.folderState)
  else
    self.gameObject:SetActive(false)
  end
end

function EquipMemoryAttrChangeCell:SwitchFolderState()
  self.folderState = not self.folderState
  self.detailGrid.gameObject:SetActive(self.folderState)
  self.detailBg.gameObject:SetActive(self.folderState)
  self.arrow.transform.localRotation = Quaternion.Euler(0, 0, self.folderState and -90 or 0)
  if self.folderState then
    local size = NGUIMath.CalculateRelativeWidgetBounds(self.detailGrid.transform)
    self.detailBg.height = size.size.y + 26
  end
end
