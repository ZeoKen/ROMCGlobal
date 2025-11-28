autoImport("BaseTip")
SkillTip = class("SkillTip", BaseTip)
SkillTip.MinHeight = 250
SkillTip.MaxHeight = 512
local sb = LuaStringBuilder.new()
local SkillDamageType = GameConfig.SkillDamageType
local damageSB = LuaStringBuilder.new()
local markSB = LuaStringBuilder.new()
local GetSP = function(skillInfo, creature)
  return SkillProxy.Instance:GetSP(skillInfo, creature)
end

function SkillTip:Init()
  self.calPropAffect = true
  self:FindObjs()
  self.closecomp = self.gameObject:GetComponent(CustomTouchUpCall)
  
  function self.closecomp.call(go)
    self:CloseSelf()
  end
end

function SkillTip:SetCheckClick(func)
  if self.closecomp then
    function self.closecomp.check()
      return func ~= nil and func() or false
    end
  end
end

function SkillTip:GetCreature()
  if self.data and self.data:IsNotMyselfSkill() then
    return
  end
  return Game.Myself
end

function SkillTip:FindObjs()
  self.topAnchor = self:FindGO("Top"):GetComponent(UIWidget)
  self.centerBg = self:FindGO("CenterBg"):GetComponent(UIWidget)
  self.scrollView = self:FindGO("ScrollView"):GetComponent(UIPanel)
  self.scroll = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  self:AddToUpdateAnchors(self:FindGO("TopBound"):GetComponent(UIWidget))
  self:AddToUpdateAnchors(self:FindGO("BottomBound"):GetComponent(UIWidget))
  self:AddToUpdateAnchors(self.topAnchor)
  self:AddToUpdateAnchors(self.centerBg)
  self:AddToUpdateAnchors(self.scrollView)
  self:FindTitleUI()
  self:FindCurrentUI()
  self:FindNextUI()
  self:FindFunc()
end

function SkillTip:AddToUpdateAnchors(uirect)
  if self.anchors == nil then
    self.anchors = {}
  end
  self.anchors[#self.anchors + 1] = uirect
end

function SkillTip:UpdateAnchors()
  if self.anchors then
    for i = 1, #self.anchors do
      self.anchors[i]:ResetAndUpdateAnchors()
    end
  end
end

function SkillTip:FindTitleUI()
  self.container = self:FindGO("Container")
  if self.container ~= nil then
    self.containerTrans = self.container.transform
  end
  local l_objBG = self:FindGO("Bg")
  self.bg = l_objBG:GetComponent(UISprite)
  self:AddToUpdateAnchors(self:FindComponent("Sprite", UIWidget, l_objBG))
  self.labelContainer = self:FindGO("Labels")
  self.icon = self:FindGO("SkillIcon"):GetComponent(UISprite)
  self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
  self.skillLevel = self:FindGO("SkillLevel"):GetComponent(UILabel)
  self.skillType = self:FindGO("SkillType"):GetComponent(UILabel)
end

function SkillTip:FindCurrentUI()
  self.currentInfo = self:FindGO("CurrentInfo"):GetComponent(UILabel)
  local specialInfoGO = self:FindGO("SpecialInfo")
  if specialInfoGO then
    self.specialInfo = specialInfoGO:GetComponent(UILabel)
  end
  self.currentCD = self:FindGO("CurrentCD"):GetComponent(UILabel)
  self.useCount = self:FindGO("UsedCount"):GetComponent(UILabel)
  self.currentDamageType = self:FindGO("CurrentDamageType"):GetComponent(UILabel)
  self.markInfo = self:FindGO("MarkInfo"):GetComponent(UILabel)
  self.labels = self.labels or {}
  local padding = 15
  self.labels[#self.labels + 1] = {
    label = self.currentInfo,
    paddingY = padding
  }
  if self.markInfo then
    self.labels[#self.labels + 1] = {
      label = self.markInfo,
      paddingY = padding
    }
  end
  if self.specialInfo then
    self.labels[#self.labels + 1] = {
      label = self.specialInfo,
      paddingY = padding
    }
  end
  self.labels[#self.labels + 1] = {
    label = self.useCount,
    paddingY = 0
  }
  self.labels[#self.labels + 1] = {
    label = self.currentDamageType,
    paddingY = 0
  }
  self.labels[#self.labels + 1] = {
    label = self.currentCD,
    paddingY = padding
  }
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
end

function SkillTip:FindNextUI()
  self.sperator = self:FindGO("Sperate"):GetComponent(UILabel)
  self.condition = self:FindGO("Condition"):GetComponent(UILabel)
  self.nextInfo = self:FindGO("NextInfo"):GetComponent(UILabel)
  self.nextCD = self:FindGO("NextCD"):GetComponent(UILabel)
  self.nextDamageType = self:FindGO("NextDamageType"):GetComponent(UILabel)
  self.labels = self.labels or {}
  local padding = 15
  self.labels[#self.labels + 1] = {
    label = self.sperator,
    paddingY = 0
  }
  self.labels[#self.labels + 1] = {
    label = self.condition,
    paddingY = padding
  }
  self.labels[#self.labels + 1] = {
    label = self.nextInfo,
    paddingY = padding
  }
  self.labels[#self.labels + 1] = {
    label = self.nextDamageType,
    paddingY = 0
  }
  self.labels[#self.labels + 1] = {
    label = self.nextCD,
    paddingY = 0
  }
end

function SkillTip:_HandleSpecials()
  local specialText = self:HandleRunSpecials()
  if specialText == nil then
    self:Hide(self.specialInfo.gameObject)
  else
    self:Show(self.specialInfo.gameObject)
    self.specialInfo.text = specialText
  end
end

function SkillTip:CloseSelf()
  TimeTickManager.Me():ClearTick(self)
  TipsView.Me():HideCurrent()
end

function SkillTip:GetCondition(skillData, nextID)
  return ConditionUtil.GetSkillConditionStr(not self.data.learned and skillData or Table_Skill[nextID], true, nil, nil, self.data.profession)
end

function SkillTip:SetData(data)
  if self.data ~= nil then
    self:CheckSpecialModified()
  end
  self.data = data.data
  local skillData = self.data:GetExtraStaticData() or self.data.staticData
  self:UpdateCurrentInfo(skillData)
  self:ShowHideFunc()
  local _MyselfProxy = MyselfProxy.Instance
  local nextID = self.data:GetNextID(_MyselfProxy:HasJobBreak(), skillData, _MyselfProxy:HasJobNewBreak(), true)
  if nextID and self.data.profession ~= 1 or not self.data.learned then
    self:Show(self.condition.gameObject)
    if self.data.learned then
      self.sperator.text = ZhString.SkillTip_NextLevelSperator
      self:Show(self.sperator.gameObject)
      self:Show(self.nextInfo.gameObject)
      self:Show(self.nextCD.gameObject)
      self:Show(self.nextDamageType.gameObject)
      local nextData = Table_Skill[nextID]
      local desc
      if self.data:IsHeroFeatureSkill() then
        desc = self:GetHeroDesc(nextData, self.data:getLevel() + 1)
      else
        desc = self:GetDesc(nextData)
      end
      self.nextInfo.text = desc
      self.nextCD.text = self:GetCD(nextData)
      self.nextDamageType.text = self:GetDamageType(nextData)
    else
      self:Hide(self.nextInfo.gameObject)
      self:Hide(self.nextCD.gameObject)
      self:Hide(self.sperator.gameObject)
      self:Hide(self.nextDamageType.gameObject)
    end
    if self.data.ignoreCondition then
      self.condition.text = ""
    else
      self.condition.text = self:GetCondition(skillData, nextID)
    end
  else
    self:Hide(self.sperator.gameObject)
    self:Hide(self.nextInfo.gameObject)
    self:Hide(self.nextCD.gameObject)
    self:Hide(self.nextDamageType.gameObject)
    self:Show(self.condition.gameObject)
    if skillData.Cost == 0 or self.data.profession == 1 then
      self.condition.text = ZhString.SkillTip_CannotLevelUpSperator
    else
      self.condition.text = ZhString.SkillTip_LevelMaxSperator
    end
  end
  if self.condition.text == "" or self.condition.text == nil then
  end
  local layoutHeight = self:Layout()
  local height = math.max(math.min(layoutHeight + 190, SkillTip.MaxHeight), SkillTip.MinHeight)
  self.bg.height = height
  self:UpdateAnchors()
  self.scroll:ResetPosition()
  self.skillInfo = nil
  self.closecomp.enabled = false
  self.closecomp.enabled = true
end

function SkillTip:UpdateCurrentInfo(skillData)
  skillData = skillData or self.data.staticData
  IconManager:SetSkillIconByProfess(skillData.Icon, self.icon, MyselfProxy.Instance:GetMyProfessionType(), true)
  self.skillName.text = skillData.NameZh
  UIUtil.WrapLabel(self.skillName)
  local infoData = skillData
  sb:Clear()
  if self:CheckReplace(skillData) then
    infoData = Table_Skill[self.data:GetReplaceID()]
    if not self.data:ReplaceSkillDesc() then
      sb:AppendLine(OverSea.LangManager.Instance():GetLangByKey(infoData.NameZh))
    end
  end
  local desc = self:GetDesc(infoData)
  if self.data:IsHeroFeatureSkill() then
    desc = self:GetHeroDesc(skillData, self.data:getLevel())
  end
  sb:Append(desc)
  self.currentInfo.text = sb:ToString():gsub("＋", "+")
  local marktype = skillData.Logic_Param and skillData.Logic_Param.markType
  if skillData.id == 2421001 then
    marktype = 2
  elseif skillData.id == 2420001 then
    marktype = 1
  end
  self.markInfo.text = self:GetSkillMarks(marktype) or ""
  self.currentDamageType.text = self:GetDamageType(infoData) or ""
  self.currentCD.text = self:GetCD(infoData)
  if self.data.learned then
    if self.data:GetExtraLevel() == 0 then
      self.skillLevel.text = "Lv." .. skillData.Level
    else
      self.skillLevel.text = string.format(ZhString.SkillView_LevelExtra, self.data.level, self.data:GetExtraLevel())
    end
  else
    local level = 1
    if self.data.ignoreCondition then
      level = skillData.Level
    end
    if self.data:GetExtraLevel() == 0 then
      self.skillLevel.text = "Lv." .. level
    else
      self.skillLevel.text = string.format(ZhString.SkillView_LevelExtra, level, self.data:GetExtraLevel())
    end
  end
  self.skillLevel:UpdateAnchors()
  if self.data.maxTimes and 0 < self.data.maxTimes then
    self:Show(self.useCount.gameObject)
    self:UpdateUseTimes()
    if self.data.leftTimes < self.data.maxTimes then
      TimeTickManager.Me():CreateTick(0, 1000, self.UpdateUseTimes, self)
    else
      TimeTickManager.Me():ClearTick(self)
    end
  else
    TimeTickManager.Me():ClearTick(self)
    self:Hide(self.useCount.gameObject)
  end
  self.skillType.text = GameConfig.SkillType[skillData.SkillType].name
  local specialType = skillData.Logic_Param and skillData.Logic_Param.special_type
  if not StringUtil.IsEmpty(specialType) then
    self.upgradeBtn:SetActive(true)
  else
    self.upgradeBtn:SetActive(false)
  end
end

function SkillTip:UpdateUseTimes()
  local deltaTime = ServerTime.ServerDeltaSecondTime(self.data.timeRecoveryStamp)
  if 0 < deltaTime and self.data.leftTimes < self.data.maxTimes then
    self.useCount.text = string.format(ZhString.SkillTip_LeftValuesRefresh, self.data.leftTimes, self.data.maxTimes, DateUtil.ParseHHMMSSBySeconds(deltaTime) .. "秒")
  else
    self.useCount.text = string.format(ZhString.SkillTip_LeftValues, self.data.leftTimes, self.data.maxTimes)
  end
end

function SkillTip:GetCD(skillData)
  self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
  local strArr = {}
  local str = ""
  local range = self:GetSkillParam(skillData, "Launch_Range", nil, self.skillInfo.GetLaunchRange, ZhString.SkillTip_LaunchRange)
  if range then
    strArr[#strArr + 1] = range
  end
  local castStr = self:GetCastTime(skillData)
  if castStr and castStr ~= "" then
    strArr[#strArr + 1] = self:GetCastTime(skillData)
  end
  local realcd = self.skillInfo:GetCD(self:GetCreature())
  if realcd then
    if skillData.Logic_Param and skillData.Logic_Param.real_cd then
      strArr[#strArr + 1] = self:GetSkillParam(skillData, "Logic_Param", "real_cd", self.skillInfo.GetLogicRealCD, ZhString.SkillTip_CDTime)
    else
      strArr[#strArr + 1] = self:GetSkillParam(skillData, "CD", nil, self.skillInfo.GetCD, ZhString.SkillTip_CDTime, 2)
    end
  end
  local realDelayCD = self.skillInfo:GetDelayCD(self:GetCreature())
  if realDelayCD then
    strArr[#strArr + 1] = self:GetSkillParam(skillData, "DelayCD", nil, self.skillInfo.GetDelayCD, ZhString.SkillTip_DelayCDTime, 2)
  end
  local cost = self:GetCost(skillData)
  if cost ~= "" then
    strArr[#strArr + 1] = cost
  end
  for i = 1, #strArr do
    str = str .. strArr[i] .. (i ~= #strArr and "\n" or "")
  end
  return str
end

function SkillTip:GetDamageType(skilldata)
  if not skilldata or not SkillDamageType then
    return
  end
  local damageType = skilldata.DamageType
  if damageType and 0 < damageType then
    if damageSB == nil then
      damageSB = LuaStringBuilder.CreateAsTable()
    else
      damageSB:Clear()
    end
    damageSB:Append(ZhString.SkillTip_DamageType)
    for index, desc in pairs(SkillDamageType) do
      if 0 < BitUtil.bandOneZero(damageType, index - 1) then
        if 1 < damageSB:GetCount() then
          damageSB:Append(ZhString.ItemTip_ChAnd)
        end
        damageSB:Append(desc)
      end
    end
    local str = damageSB:ToString()
    damageSB:RemoveLast()
    damageSB:Clear()
    return str
  end
end

function SkillTip:GetSkillMarks(marktype)
  if not marktype then
    return nil
  end
  local marks = SkillProxy.Instance:GetSkillMark(marktype)
  if marks then
    if markSB == nil then
      markSB = LuaStringBuilder.CreateAsTable()
    else
      markSB:Clear()
    end
    if marktype == 1 then
      markSB:Append(ZhString.SkillMark_Sun)
    else
      markSB:Append(ZhString.SkillMark_Moon)
    end
    local n, mark, sname = #marks
    for i = 1, n do
      mark = marks[i]
      sname = nil
      if mark.epro and mark.epro > 0 then
        sname = Table_Class[mark.epro] and Table_Class[mark.epro].NameZh
      elseif mark.npcid and 0 < mark.npcid then
        sname = OverSea.LangManager.Instance():GetLangByKey(Table_Monster[mark.npcid] and Table_Monster[mark.npcid].NameZh or "")
      end
      if sname then
        if i <= n and 1 < markSB:GetCount() then
          markSB:Append(ZhString.ItemTip_ChAnd)
        end
        markSB:Append(sname)
      end
    end
    local str = markSB:ToString()
    markSB:RemoveLast()
    markSB:Clear()
    return str
  end
end

function SkillTip:GetDynamicSkillInfo(id)
  local creature = self:GetCreature()
  return creature and creature.data:GetDynamicSkillInfo(id)
end

local itemCostTmp = {}

function SkillTip:GetCost(skillData)
  sb:Clear()
  self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
  local costStr, spcost, hpcost
  local realSp = GetSP(self.skillInfo, self:GetCreature())
  if realSp then
    spcost = self:_GetSkillParam(SkillProxy.Instance:GetOriginSP(skillData), GetSP, ZhString.SkillTip_SPCost, 0)
  end
  if spcost then
    sb:AppendLine(spcost)
  end
  local realHp = self.skillInfo:GetHP(self:GetCreature())
  if realHp then
    hpcost = self:GetSkillParam(skillData, "SkillCost", "hp", self.skillInfo.GetHP, ZhString.SkillTip_HPCost, 0)
  end
  if hpcost then
    sb:AppendLine(hpcost)
  end
  local dynamicSkillInfo = self:GetDynamicSkillInfo(skillData.id)
  local dynamicAllSkillInfo = SkillProxy.Instance:GetDynamicAllSkillInfo()
  local isNoBuff = dynamicSkillInfo ~= nil and dynamicSkillInfo:GetIsNoBuff()
  local isNoItem = dynamicAllSkillInfo ~= nil and dynamicAllSkillInfo:GetIsNoItem()
  local costs = SkillProxy.Instance:GetOriginSpecialCost(skillData)
  local needItem = ""
  TableUtility.TableClear(itemCostTmp)
  if 0 < #costs then
    local item, buff, specialCost
    for i = 1, #costs do
      specialCost = costs[i]
      if specialCost.itemID then
        itemCostTmp[specialCost.itemID] = 1
        needItem = self:_FormatItemCostDesc(needItem, specialCost.itemID, dynamicSkillInfo, specialCost.num, isNoItem)
      end
      if specialCost.buffID and not isNoBuff then
        buff = Table_Buffer[specialCost.buffID]
        needItem = self:_FormatBuffCostDesc(needItem, specialCost.buffID, dynamicSkillInfo, specialCost.num, isNoBuff)
      end
    end
    if dynamicSkillInfo ~= nil and dynamicSkillInfo:HasItemCostChange() then
      for k, v in pairs(dynamicSkillInfo.costs) do
        if itemCostTmp[k] == nil then
          needItem = self:_FormatItemCostDesc(needItem, k, dynamicSkillInfo, 0, isNoItem)
        end
      end
    end
    if needItem ~= "" then
      sb:AppendLine(string.format(ZhString.SkillTip_NeedSpecialCost, needItem))
    end
  elseif dynamicSkillInfo ~= nil and dynamicSkillInfo:HasItemCostChange() then
    local handled = false
    for k, v in pairs(dynamicSkillInfo.costs) do
      if itemCostTmp[k] == nil then
        handled = true
        needItem = self:_FormatItemCostDesc(needItem, k, dynamicSkillInfo, 0, isNoItem)
      end
    end
    if handled then
      sb:AppendLine(string.format(ZhString.SkillTip_NeedSpecialCost, needItem))
    end
  end
  sb:RemoveLast()
  costStr = sb:ToString()
  sb:Clear()
  return costStr
end

function SkillTip:_FormatItemCostDesc(str, itemID, dynamicSkillInfo, originNum, isNoItem)
  local item = Table_Item[itemID]
  if item then
    local changed = originNum
    if isNoItem then
      changed = 0
    elseif dynamicSkillInfo then
      changed = dynamicSkillInfo:GetItemNewCost(item.id, changed)
    end
    local msg
    if changed == originNum then
      msg = string.format(ZhString.SkillTip_ItemCost.normal, item.NameZh, originNum)
    else
      local delta = changed - originNum
      if delta < 0 then
        msg = ZhString.SkillTip_ItemCost.buff
      else
        msg = ZhString.SkillTip_ItemCost.debuff
        delta = "+" .. tostring(delta)
      end
      msg = string.format(msg, item.NameZh, originNum, delta)
    end
    if str == "" then
      str = msg
    else
      str = str .. ZhString.SkillTip_NeedSpecialSplit .. msg
    end
  end
  return str
end

function SkillTip:_FormatBuffCostDesc(str, buffID, dynamicSkillInfo, originNum, isNoBuff)
  local buff = Table_Buffer[buffID]
  if buff then
    local changed = originNum
    if isNoBuff then
      changed = 0
    elseif dynamicSkillInfo then
      changed = dynamicSkillInfo:GetBuffNewCost(buffID, changed)
    end
    local msg
    if changed == originNum then
      msg = string.format(ZhString.SkillTip_BuffCost.normal, buff.BuffName, changed)
    else
      local delta = changed - originNum
      if delta < 0 then
        msg = ZhString.SkillTip_ItemCost.buff
      else
        msg = ZhString.SkillTip_ItemCost.debuff
        delta = "+" .. tostring(delta)
      end
      msg = string.format(msg, buff.BuffName, originNum, delta)
    end
    if str == "" then
      str = msg
    else
      str = str .. ZhString.SkillTip_NeedSpecialSplit .. msg
    end
  end
  return str
end

local roundOff = function(num, n)
  if 0 < n then
    local scale = math.pow(10, n - 1)
    return math.floor(num / scale + 0.5) * scale
  elseif n < 0 then
    local scale = math.pow(10, n)
    return math.floor(num / scale + 0.5) * scale
  elseif n == 0 then
    return num
  end
end
local fact = 1000

function SkillTip:_Float1(value, _fact)
  local res = math.abs(value)
  res = roundOff(res, 1) / _fact
  res = math.floor(res * 100) / 100
  if value < 0 then
    return -res
  end
  return res
end

function SkillTip:GetSkillParam(skillData, orignParam1, orignParam2, fixFunc, originZhString, floatX)
  local originValue = skillData[orignParam1]
  if orignParam2 and originValue then
    originValue = originValue[orignParam2]
  end
  return self:_GetSkillParam(originValue, fixFunc, originZhString, floatX)
end

function SkillTip:_GetSkillParam(originValue, fixFunc, originZhString, floatX)
  if floatX == nil then
    floatX = 1
  end
  local aroundZero = 1 / math.pow(10, floatX)
  local realValue
  if fixFunc ~= nil and self.calPropAffect then
    realValue = fixFunc(self.skillInfo, self:GetCreature())
  else
    realValue = originValue
  end
  if originValue or realValue then
    originValue = originValue or 0
    if 0 < realValue or 0 < originValue then
      if 0 < floatX then
        originValue = roundOff(originValue, -3)
        realValue = roundOff(realValue, -3)
      end
      local fixed = roundOff(realValue - originValue, -3)
      if originValue == realValue or aroundZero > math.abs(fixed) then
        return string.format(originZhString.normal, originValue)
      else
        fixed = realValue * fact - originValue * fact
        local signal = ""
        local msg = originZhString.buff
        if fixed < 0 and fixed / fact + originValue < 0 then
          msg = originZhString.buff
          fixed = -originValue
        elseif 0 < fixed then
          msg = originZhString.debuff
          signal = "+"
        end
        return string.format(msg, originValue, signal, self:_Float1(fixed, fact))
      end
    end
  end
  return nil
end

function SkillTip:GetCastTime(skillData)
  self.skillInfo = Game.LogicManager_Skill:GetSkillInfo(skillData.id)
  local leadType = skillData.Lead_Type
  if leadType and leadType.type then
    if leadType.type == SkillCastType.SubSkill and self.skillInfo:HasSubSkill() then
      local skillid = SkillProxy.Instance:GetCastSubSkillID(self:GetCreature(), skillData)
      if skillid ~= nil then
        local data = Table_Skill[skillid]
        if data ~= nil then
          local str = self:_GetMagicCastTime(data)
          if str ~= nil then
            return str
          end
          local castTime = SkillInfo.GetCastTime(self:GetCreature(), data)
          if castTime == 0 then
            return ""
          end
          return string.format(ZhString.SkillTip_CastTime.normal, castTime)
        end
      end
    else
      return self:_GetMagicCastTime(skillData)
    end
  end
end

function SkillTip:_GetMagicCastTime(staticData)
  local leadType = staticData.Lead_Type
  if leadType and leadType.type and leadType.type == SkillCastType.Magic then
    local castTime = leadType.CCT + leadType.FCT + SkillInfo.Get_Origin_CTChange(self:GetCreature(), staticData)
    local realCastTime = SkillInfo.GetCastTime(self:GetCreature(), staticData)
    if not self.calPropAffect then
      realCastTime = castTime
    end
    castTime = roundOff(castTime, -3)
    if castTime == 0 then
      return ""
    end
    realCastTime = roundOff(realCastTime, -3)
    local delta = realCastTime - castTime
    if realCastTime == castTime or math.abs(delta) < 0.1 then
      return string.format(ZhString.SkillTip_CastTime.normal, castTime)
    else
      local signal = ""
      local msg
      delta = realCastTime * fact - castTime * fact
      if 0 < delta then
        msg = ZhString.SkillTip_CastTime.debuff
        signal = "+"
      else
        msg = ZhString.SkillTip_CastTime.buff
      end
      return string.format(msg, castTime, signal, self:_Float1(delta, fact))
    end
  end
end

function SkillTip:Layout()
  local label, lastLabel
  lastLabel = self.labels[1]
  local height = lastLabel.label.height
  local pos
  local labelHeight = height
  local lastLabelHeight
  for i = 2, #self.labels do
    if self.labels[i - 1].label.gameObject.activeSelf then
      lastLabel = self.labels[i - 1]
      pos = lastLabel.label.transform.localPosition
      lastLabelHeight = labelHeight
    end
    label = self.labels[i]
    if label.label.gameObject.activeSelf then
      label.label.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, pos.y - lastLabelHeight - lastLabel.paddingY, pos.z)
      labelHeight = label.label.height
      if label.label.text == "" or label.label.text == nil then
        labelHeight = 0
      end
      height = height + labelHeight + lastLabel.paddingY
    end
  end
  return height
end

function SkillTip:OnEnter()
end

function SkillTip:OnExit()
  self:CheckSpecialModified()
  local _EventManager = EventManager.Me()
  _EventManager:RemoveEventListener(ServiceEvent.SkillMultiSkillOptionUpdateSkillCmd, self.HandleSkillOptionUpdate, self)
  _EventManager:RemoveEventListener(SkillEvent.SkillUpdate, self.HandleSkillUpdate, self)
  return true
end

function SkillTip:DestroySelf()
  GameObject.DestroyImmediate(self.gameObject)
end

local _heroSeparator = "[HeroLvSeparator]"
local _addLine = [[


]]
local _descColor = "[c][000000]%s[-][/c]"
local _descUnlockColor = "[c][979797]%s[-][/c]"
local _descLv = "Lv.%s %s"

function SkillTip:GetHeroDesc(staticData, heroFeatureLv)
  local heroSkillDesc = self:GetDesc(staticData)
  local result = ""
  local descs = string.split(heroSkillDesc, _heroSeparator)
  if #descs == 3 then
    local _proIns = ProfessionProxy.Instance
    local midLv, maxLv = _proIns:GetMidHeroFeatureLv(), _proIns:GetMaxHeroFeatureLv()
    local desc, desc2, desc3
    desc = descs[1]
    desc2 = string.format(_descLv, midLv, descs[2])
    desc2 = heroFeatureLv < midLv and string.format(_descUnlockColor, desc2) or desc2
    desc3 = string.format(_descLv, maxLv, descs[3])
    desc3 = heroFeatureLv < maxLv and string.format(_descUnlockColor, desc3) or desc3
    local totalDesc = desc .. _addLine .. desc2 .. _addLine .. desc3 .. "\n"
    result = string.format(_descColor, totalDesc)
  end
  local attrEffect = GameConfig.Bell_AttrEffect and GameConfig.Bell_AttrEffect[staticData.id // 1000]
  if attrEffect then
    result = result .. "\n"
    local attrConfig, tempDesc, tempParam = attrEffect[1], "", 0
    local attrFunc = attrConfig.attrFunc
    for i = 1, #attrEffect do
      attrConfig = attrEffect[i]
      attrFunc = attrConfig.attrFunc
      tempParam = CommonFun.calcBuffValue(Game.Myself.data, nil, attrFunc.type, attrFunc.a, attrFunc.b, attrFunc.c, attrFunc.d)
      tempDesc = string.format(attrConfig.desc, tempParam)
      result = result .. "\n" .. tempDesc
    end
  end
  return result
end

function SkillTip:GetDesc(data)
  local desc = ""
  local config
  for i = 1, #data.Desc do
    config = data.Desc[i]
    if Table_SkillDesc[config.id] and Table_SkillDesc[config.id].Desc then
      if config.params then
        desc = desc .. string.format(Table_SkillDesc[config.id].Desc, unpack(config.params)) .. (i ~= #data.Desc and "\n" or "")
      else
        desc = desc .. Table_SkillDesc[config.id].Desc .. (i ~= #data.Desc and "\n" or "")
      end
    end
  end
  return desc
end

local groupSpecials = {}
local debug = false

function SkillTip:HandleRunSpecials(selectID)
  local ReusableTable = ReusableTable
  local sb
  local specials = AstrolabeProxy.Instance:GetSkill_SpecialEffect(self.data.sortID)
  if specials then
    local config, selectEnable
    if self.specialCheck then
      selectEnable = self.specialCheck.activeSelf
    else
      selectEnable = self.data:GetEnableSpecialEffect()
    end
    if selectID == nil then
      local selectCell = self:_GetSelectedSpecialCell()
      if selectCell then
        selectID = selectCell.data.id
      end
    end
    TableUtility.TableClear(groupSpecials)
    local sameGrp, notselect
    for k, v in pairs(specials) do
      config = Table_RuneSpecial[k]
      if config and config.Type ~= 3 then
        notselect = not selectEnable or selectID ~= k
        if sb == nil then
          sb = LuaStringBuilder.CreateAsTable()
        end
        if config.Group == nil or config.Type == 2 then
          self:_HandleSameSpecialEffect(sb, config, v, notselect)
        else
          sameGrp = groupSpecials[config.Group]
          if sameGrp == nil then
            sameGrp = ReusableTable.CreateArray()
            groupSpecials[config.Group] = sameGrp
            sameGrp[1] = config
            sameGrp[2] = ReusableTable.CreateArray()
            TableUtility.ArrayShallowCopy(sameGrp[2], config.SkillTipParm)
            local params = sameGrp[2]
            for i = 1, #params do
              params[i] = params[i] * v
            end
          else
            local params = sameGrp[2]
            for i = 1, #params do
              params[i] = params[i] + config.SkillTipParm[i] * v
            end
          end
        end
      end
    end
    for k, v in pairs(groupSpecials) do
      if sb == nil then
        sb = LuaStringBuilder.CreateAsTable()
      end
      self:_HandleSameGroupSpecialEffect(sb, v[1], v[2], notselect)
      ReusableTable.DestroyArray(v[2])
      ReusableTable.DestroyArray(v)
      groupSpecials[k] = nil
    end
    if debug then
      if sb then
        sb:AppendLine("\n下面是旧的\n")
      end
      for k, v in pairs(specials) do
        config = Table_RuneSpecial[k]
        local Runetip = config.Runetip
        if Table_RuneSpecialDesc then
          Runetip = Table_RuneSpecialDesc[Runetip].Text
        end
        if config then
          if sb == nil then
            sb = LuaStringBuilder.CreateAsTable()
          end
          if config.Type == 1 then
            sb:AppendLine(config.RuneName .. "：")
            sb:AppendLine(self:_GetRuneSpecialDes(Runetip, config.SkillTipParm, v))
          elseif config.Type == 2 then
            if not selectEnable or selectID ~= k then
              sb:Append("[c][b2b2b2]")
            end
            sb:AppendLine(config.RuneName .. "：")
            sb:AppendLine(self:_GetRuneSpecialDes(Runetip, config.SkillTipParm, v))
            if not selectEnable or selectID ~= k then
              sb:Append("[-][/c]")
            end
          end
        end
      end
    end
  end
  if sb then
    sb:RemoveLast()
    local str = sb:ToString()
    sb:Destroy()
    return str
  end
  return nil
end

function SkillTip:_HandleSameSpecialEffect(sb, config, count, notselect)
  local Runetip = config.Runetip
  if Table_RuneSpecialDesc then
    Runetip = Table_RuneSpecialDesc[Runetip].Text
  end
  if config.Type == 1 then
    sb:AppendLine(config.RuneName .. "：")
    sb:AppendLine(self:_GetRuneSpecialDes(Runetip, config.SkillTipParm, count))
  elseif config.Type == 2 then
    if notselect then
      sb:Append("[c][b2b2b2]")
    end
    sb:AppendLine(config.RuneName .. "：")
    sb:AppendLine(self:_GetRuneSpecialDes(Runetip, config.SkillTipParm, count))
    if notselect then
      sb:Append("[-][/c]")
    end
  end
end

function SkillTip:_HandleSameGroupSpecialEffect(sb, config, params, notselect)
  local Runetip = config.Runetip
  if Table_RuneSpecialDesc then
    Runetip = Table_RuneSpecialDesc[Runetip].Text
  end
  if config.Type == 1 then
    sb:AppendLine(config.RuneName .. "：")
    sb:AppendLine(string.format(Runetip, unpack(params)))
  elseif config.Type == 2 then
    if notselect then
      sb:Append("[c][b2b2b2]")
    end
    sb:AppendLine(config.RuneName .. "：")
    sb:AppendLine(string.format(Runetip, unpack(params)))
    if notselect then
      sb:Append("[-][/c]")
    end
  end
end

local tmpParamArray = {}

function SkillTip:_GetRuneSpecialDes(str, param, count)
  if param then
    if count == nil then
      count = 1
    end
    for i = 1, #param do
      tmpParamArray[i] = param[i] * count
    end
    str = string.format(str, unpack(tmpParamArray))
    TableUtility.ArrayClear(tmpParamArray)
  end
  return str
end

function SkillTip:CheckReplace(skillData)
  local data = self.data
  if data == nil then
    return false
  end
  local replaceid = data:GetReplaceID()
  if replaceid == nil or replaceid <= 0 then
    return false
  end
  return skillData.SkillType == SkillType.Function or data:GetReplaceSkill() ~= nil or data:ReplaceSkillDesc()
end

function SkillTip:OnUpgradeBtnClick()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.SpecialSkillUpgradeView,
    viewdata = self.data
  })
  self:CloseSelf()
end
