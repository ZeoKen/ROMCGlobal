autoImport("SkillTip")
BalanceModeSkillTip = class("BalanceModeSkillTip", SkillTip)
local EnumToTempPos = {
  [1] = 5,
  [2] = 2,
  [3] = 8,
  [4] = 1
}

function BalanceModeSkillTip:FindObjs()
  BalanceModeSkillTip.super.FindObjs(self)
  self:HideUnnecessary()
end

function BalanceModeSkillTip:FindCurrentUI()
  BalanceModeSkillTip.super.FindCurrentUI(self)
  self.skillIcon_Bg = self:FindGO("SkillIconBg"):GetComponent(UISprite)
  self.equipBtn = self:FindGO("EquipBtn")
  self.equipBtn:SetActive(true)
  self.equipBtnLabel = self:FindComponent("Label", UILabel, self.equipBtn)
  self:AddClickEvent(self.equipBtn, function()
    local type = self.data and self.data.type
    local isArtifact = self.data and self.data.isArtifact or false
    local isChoose = self.data and self.data.isChoose or false
    if isChoose then
      if isArtifact then
        SkillProxy.Instance:CallBalanceModeChooseMess(nil, nil, 0)
      elseif self.data.isMemory then
        local index = self.data.isUpgradeMemory and 3 or 2
        local effect = {index = index, effect_id = 0}
        ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[self.data.groupType], effect)
        xdlog("申请移除记忆", EnumToTempPos[self.data.groupType], "index:", index)
      elseif type == 1 then
        SkillProxy.Instance:CallBalanceModeChooseMess(0)
      elseif type == 2 then
        SkillProxy.Instance:CallBalanceModeChooseMess(nil, 0, nil)
      end
    elseif isArtifact then
      SkillProxy.Instance:CallBalanceModeChooseMess(nil, nil, self.data.id)
    elseif self.data.isMemory then
      local index = self.data.isUpgradeMemory and 3 or 2
      local effect = {
        index = index,
        effect_id = self.data.effectId
      }
      ServiceItemProxy.Instance:CallBalanceModeMemorySetItemCmd(EnumToTempPos[self.data.groupType], effect)
      xdlog("申请选择记忆", EnumToTempPos[self.data.groupType], self.data.effectId, "index:", index)
    elseif type == 1 then
      SkillProxy.Instance:CallBalanceModeChooseMess(self.data.id, nil, nil)
    elseif type == 2 then
      SkillProxy.Instance:CallBalanceModeChooseMess(nil, self.data.id, nil)
    end
    self:CloseSelf()
  end)
end

function BalanceModeSkillTip:HideUnnecessary()
  self:Hide(self.nextInfo)
  self:Hide(self.nextCD)
  self:Hide(self.sperator)
  self:Hide(self.useCount)
  self:Hide(self.currentCD)
  self:Hide(self.skillLevel)
  self:Hide(self.useCount)
  self:Hide(self.skillType)
end

function BalanceModeSkillTip:SetData(data)
  self.data = data.data
  self:UpdateCurrentInfo(self.data)
  local layoutHeight = self:Layout()
  local height = math.max(math.min(layoutHeight + 190, SkillTip.MaxHeight), SkillTip.MinHeight)
  self.bg.height = height
  self:UpdateAnchors()
  self.scroll:ResetPosition()
  self:SetConditionLabel()
  self.equipBtnLabel.text = self.data.isChoose and ZhString.SkillTip_UnEquip or ZhString.SkillTip_Equip
end

function BalanceModeSkillTip:SetConditionLabel()
  self.condition.text = ZhString.PetSkillTip_NoUpgrade
end

function BalanceModeSkillTip:UpdateCurrentInfo(data)
  local isArtifact = data.isArtifact or false
  local itemID = data.id
  if data.isMemory then
    if data.isUpgradeMemory then
      itemID = EquipMemoryProxy.PosEnumUpgradeItemID[data.groupType]
    else
      itemID = EquipMemoryProxy.PosEnumItemID[data.groupType]
    end
  end
  local itemData = Table_Item[itemID]
  if itemData then
    IconManager:SetItemIcon(itemData.Icon, self.icon)
    self.icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 0.8)
    self.skillIcon_Bg.enabled = true
  end
  if isArtifact then
    local artifactData = Table_PersonalArtifactCompose[itemID]
    if artifactData then
      local effectIds, effectDesc = artifactData.UniqueEffect
      local str = ""
      for i = 1, #effectIds do
        effectDesc = ItemUtil.getBufferDescById(effectIds[i])
        if not StringUtil.IsEmpty(effectDesc) then
          str = str .. effectDesc
          if i < #effectIds then
            str = str .. "\n"
          end
        end
      end
      self.currentInfo.text = str
    end
    self.skillName.text = itemData.NameZh
  elseif data.isMemory then
    local descStr = ""
    local memoryStaticData = Table_ItemMemoryEffect[data.id]
    xdlog("memoryStaticData", data.id)
    local getBuffDescByStage = function(buffIds, stageIndex, isUpgrade)
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
      local desc = buffData and buffData.Dsc
      if type(desc) == "string" then
        if isUpgrade then
          desc = string.gsub(desc, "(%d+)", function(match)
            local num = tonumber(match)
            return tostring(num * 3)
          end)
        end
        desc = string.gsub(desc, "%[AttrValue%]", "")
      end
      return desc
    end
    if memoryStaticData then
      if memoryStaticData.WaxBuffID and memoryStaticData.WaxBuffID ~= _EmptyTable then
        local buffIds = memoryStaticData.WaxBuffID
        if type(buffIds) == "table" and 0 < #buffIds then
          for i = 1, #buffIds do
            local buffId = buffIds[i]
            local buffData = Table_Buffer[buffId]
            if buffData and buffData.BuffEffect and not buffData.BuffEffect.NoShow then
              local dsc = getBuffDescByStage({buffId}, 0, data.isUpgradeMemory)
              if dsc and dsc ~= "" then
                if descStr ~= "" then
                  descStr = descStr .. "\n"
                end
                descStr = descStr .. dsc
              end
            end
          end
        end
      elseif memoryStaticData.BuffID and memoryStaticData.BuffID ~= _EmptyTable then
        local buffIds = memoryStaticData.BuffID
        local dsc = getBuffDescByStage(buffIds, 0, data.isUpgradeMemory)
        if dsc and dsc ~= "" then
          descStr = descStr .. dsc
        end
      end
    end
    self.currentInfo.text = descStr ~= "" and descStr or ""
    self.skillName.text = memoryStaticData and memoryStaticData.PreviewDesc or ""
  else
    local equipExtraceionInfo = Table_EquipExtraction[itemID]
    if equipExtraceionInfo then
      self.currentInfo.text = equipExtraceionInfo.Dsc
    end
    self.skillName.text = itemData.NameZh
  end
end
