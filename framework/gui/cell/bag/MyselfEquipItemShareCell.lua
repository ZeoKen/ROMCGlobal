autoImport("BaseItemCell")
autoImport("ItemCardShareSmallCell")
MyselfEquipItemShareCell = class("MyselfEquipItemShareCell", BaseItemCell)
local MaxRefine = 15
local equipTypeCfg, equipPosCdCfg = GameConfig.EquipType, GameConfig.EquipPosCD
local myselfIns

function MyselfEquipItemShareCell:ctor(obj, index, isfashion, viceEquip)
  self.isViceEquip = viceEquip == true
  if not myselfIns then
    myselfIns = MyselfProxy.Instance
  end
  if index then
    self.index = index
  else
    LogUtility.Warning("index is nil while initializing MyselfEquipItemShareCell!")
  end
  MyselfEquipItemShareCell.super.ctor(self, obj)
  self.isfashion = isfashion or false
  if self.index then
    local spname
    if index == 5 or index == 6 then
      spname = "bag_equip_6"
    else
      spname = "bag_equip_" .. self.index
    end
    self.symbol = self:FindComponent("Symbol", UISprite)
    IconManager:SetUIIcon(spname, self.symbol)
    self.symbol:MakePixelPerfect()
  end
  self.itemRoot = self:FindGO("ItemRoot")
  self.siteRoot = self:FindGO("SiteRoot")
  self.noEffect = self:FindGO("NoEffect")
  self.offForbid = self:FindGO("OffForbid")
  self.siteStrenthenLv = self:FindComponent("StrengthenLv", UILabel)
  self.siteStrenthenLv2 = self:FindComponent("StrengthenLv2", UILabel)
  self.forbidColdDown = self:FindComponent("ForbidColdDown", UISprite)
  self.extraInfo = self:FindGO("extraInfo")
  if not self.isViceEquip then
    self.extraInfoLeft = self:FindGO("left", self.extraInfo)
    self.extraInfoRight = self:FindGO("right", self.extraInfo)
    if index < 7 then
      self:Show(self.extraInfoLeft)
      self:Hide(self.extraInfoRight)
    elseif index < 13 then
      self:Show(self.extraInfoRight)
      self:Hide(self.extraInfoLeft)
    else
      self:Hide(self.extraInfoLeft)
      self:Hide(self.extraInfoRight)
    end
    return
  end
end

function MyselfEquipItemShareCell:SetData(data)
  MyselfEquipItemShareCell.super.SetData(self, data)
  if self.isPureSite then
    return
  end
  self:UpdateMyselfInfo()
  if data and data.staticData then
    local equipType = data.equipInfo.equipData.EquipType
    local config = equipTypeCfg[equipType]
    if config then
      local site = config.site
      local isPosRight = false
      for k, v in pairs(site) do
        if v == data.index then
          isPosRight = true
        end
      end
      if isPosRight == false and self.invalid then
        self:SetActive(self.invalid, true)
      end
    end
    if self.isfashion and not Slua.IsNull(self.noEffect) then
      self.noEffect:SetActive(not self:IsEffective())
    end
    if data.equipInfo and data.equipInfo.strengthlv > 0 then
      self.siteStrenthenLv.text = data.equipInfo.strengthlv
    else
      self.siteStrenthenLv.text = ""
    end
    self:UpdateStrengthLevelByPlayer()
    self:UpdateRefineLevelByPlayer()
    self:Hide(self.symbol)
    if self.siteStrenthenLv2 then
      self.siteStrenthenLv2.text = ""
    end
  else
    local isInStrengthView = StrengthProxy.Instance:IsPackageStrengthenShow()
    local lv = StrengthProxy.Instance:GetStrengthLvByPos(SceneItem_pb.ESTRENGTHTYPE_NORMAL, self.index)
    if lv == nil or lv == 0 or not isInStrengthView then
      self.siteStrenthenLv.text = ""
    else
      self.siteStrenthenLv.text = lv
    end
    if self.siteStrenthenLv2 then
      local lv2 = StrengthProxy.Instance:GetStrengthLvByPos(SceneItem_pb.ESTRENGTHTYPE_GUILD, self.index)
      if lv2 == nil or lv2 == 0 or not isInStrengthView then
        self.siteStrenthenLv2.text = ""
      else
        self.siteStrenthenLv2.text = lv2
      end
    end
    self:Show(self.symbol)
  end
  self:UpdateEquipUpgradeTip()
  self:UpdateExtraInfo()
end

ItemTipInactiveColorStr = "[717782]"

function MyselfEquipItemShareCell:UpdateExtraInfo()
  if self.isViceEquip then
    return
  end
  local extra
  local offset = 0
  if self.index < 7 then
    extra = self.extraInfoLeft
    offset = -35
  else
    if self.index < 13 then
      extra = self.extraInfoRight
      offset = 35
    else
    end
  end
  if extra then
    local enchantInfo = self.data and self.data.enchantInfo
    local sb = LuaStringBuilder.CreateAsTable()
    local showFullAttr = self.data and self.data.showFullAttr or false
    local equipBuffUpSource = self.data and self.data.equipBuffUpSource or nil
    if enchantInfo then
      local combineEffects, combineEffect, buffData, isWork = enchantInfo:GetCombineEffects(), LuaStringBuilder.CreateAsTable()
      for i = 1, #combineEffects do
        combineEffect = combineEffects[i]
        buffData = combineEffect and combineEffect.buffData
        if buffData then
          if 0 < sb:GetCount() then
            sb:Append("\n")
          end
          isWork = combineEffect.isWork or showFullAttr
          if not isWork and equipBuffUpSource and BlackSmithProxy.CheckShowRefineBuffUpLevel(self.data, equipBuffUpSource) then
            local withLimitBuffUpLv, withoutLimitBuffUpLv = self.data:GetRefineBuffUpLevel(equipBuffUpSource)
            isWork = EnchantInfo.CombineEffectWorkPredicate(combineEffect, (BlackSmithProxy.CalculateBuffUpLevel(self.data.equipInfo.refinelv, BlackSmithProxy.Instance:MaxRefineLevelByData(self.data.staticData), withLimitBuffUpLv, withoutLimitBuffUpLv)))
          end
          if isWork then
            sb:Append(OverSea.LangManager.Instance():GetLangByKey(buffData.BuffName))
          else
            sb:Append(OverSea.LangManager.Instance():GetLangByKey(buffData.BuffName))
            sb:Append("(")
            sb:Append(combineEffect.WorkTip)
            sb:Append(")[-][/c]")
          end
        end
      end
    end
    local showExtraInfo = false
    local lbl = self:FindGO("lbl", extra):GetComponent(UILabel)
    if 0 < sb:GetCount() then
      lbl.text = sb:ToString()
      showExtraInfo = true
    else
      lbl.text = ""
    end
    sb:Destroy()
    local cardSlotNum = self.data and self.data.cardSlotNum or 0
    if cardSlotNum and 0 < cardSlotNum then
      local equipCards = self.data.equipedCardInfo
      local cardroot = self:FindGO("cardroot", extra)
      for i = 1, cardSlotNum do
        if equipCards[i] then
          showExtraInfo = true
          local cardGO = self:LoadPreferb("cell/ItemCardCell", cardroot)
          local cardCell = ItemCardShareSmallCell.new(cardGO)
          cardCell:SetData(equipCards[i])
          cardGO.transform.localPosition = LuaGeometry.GetTempVector3((i - 1) * offset, 0, 0)
          cardGO.transform.localScale = LuaGeometry.GetTempVector3(0.4, 0.4, 0.4)
          cardGO:SetActive(true)
        end
      end
    end
    if showExtraInfo then
      self:Show(self.extraInfo)
    else
      self:Hide(self.extraInfo)
    end
  end
end

function MyselfEquipItemShareCell:ResetShadowEquipLockState()
  if self.isViceEquip then
    self.viceForbidden = BagProxy.Instance:CheckForbiddenByNoviceServer(self.index)
    local siteLock = self.siteMenu and not FunctionUnLockFunc.Me():CheckCanOpen(self.siteMenu) and not self.fromSaveData
    if siteLock or self.viceForbidden then
      self:Show(self.siteUnlockSp)
    else
      self:Hide(self.siteUnlockSp)
    end
  end
end

function MyselfEquipItemShareCell:ShowPureSite(active)
  self:addGuideButtonId()
  if nil == self.normalItem or nil == self.empty then
    return
  end
  self.isPureSite = active
  if active and self.index <= StrengthProxy.MaxPos then
    local lv = StrengthProxy.Instance:GetStrengthLvByPos(SceneItem_pb.ESTRENGTHTYPE_NORMAL, self.index)
    self:UpdateSiteStrengthenLv(lv)
    self:Show(self.symbol)
  else
    self.siteStrenthenLv.text = ""
    if self.data and self.data.staticData then
      self:Hide(self.symbol)
    else
      self:Show(self.symbol)
    end
  end
  self.itemRoot:SetActive(not active)
end

function MyselfEquipItemShareCell:UpdateSiteStrengthenLv(level)
  self.siteStrenthenLv.text = 0 < level and level or ""
end

function MyselfEquipItemShareCell:IsEffective()
  if self.data then
    local roleEquipBag = BagProxy.Instance:GetRoleEquipBag()
    local equip = roleEquipBag:GetEquipBySite(self.index)
    if equip then
      return equip.equipInfo.equipData.Type == self.data.equipInfo.equipData.Type
    end
  end
  return true
end

function MyselfEquipItemShareCell:GetCD()
  local onCdTime = self:GetEquipPosOnCdTime()
  if onCdTime then
    return onCdTime
  end
  if self.data == nil then
    local stateTime = myselfIns:GetEquipPos_StateTime(self.index, self.isViceEquip)
    if stateTime and stateTime.offendtime then
      local delta = ServerTime.ServerDeltaSecondTime(stateTime.offendtime * 1000)
      if 0 < delta then
        return delta
      end
    end
  end
  return MyselfEquipItemShareCell.super.GetCD(self)
end

function MyselfEquipItemShareCell:GetMaxCD()
  local onCdTime = self:GetEquipPosOnCdTime()
  if onCdTime then
    local maxCd = equipPosCdCfg[self.index]
    if maxCd then
      return maxCd
    end
  end
  if self.data == nil then
    local stateTime = myselfIns:GetEquipPos_StateTime(self.index, self.isViceEquip)
    if stateTime and stateTime.offduration then
      return stateTime.offduration
    end
  end
  return MyselfEquipItemShareCell.super.GetMaxCD(self)
end

function MyselfEquipItemShareCell:RefreshCD(f)
  local onCdTime = self:GetEquipPosOnCdTime()
  if self.data == nil then
    self:TrySetShowOffForbid(0 < f and not onCdTime)
    if self.forbidColdDown then
      self.forbidColdDown.fillAmount = f
    end
    return f == 0
  else
    self:TrySetShowOffForbid(false)
    if onCdTime then
      self.coldDown.fillAmount = f
      return onCdTime <= 0
    end
    return MyselfEquipItemShareCell.super.RefreshCD(self, f)
  end
end

function MyselfEquipItemShareCell:GetEquipPosOnCdTime()
  return myselfIns:GetEquipPosOnCdTime(self.index)
end

function MyselfEquipItemShareCell:TrySetShowOffForbid(isShow)
  isShow = isShow and true or false
  if not Slua.IsNull(self.offForbid) then
    self.offForbid:SetActive(isShow)
  end
end

function MyselfEquipItemShareCell:UpdateStrengthLevelByPlayer(playerId)
  if BlackSmithProxy.CheckShowStrengthBuffUpLevel(self.data, playerId) then
    local getFunc = BlackSmithProxy.GetStrengthBuffUpLevel
    local withLimitBuffUpLv, withoutLimitBuffUpLv = getFunc(self.index, playerId, 1), getFunc(self.index, playerId, 0)
    local player = playerId and SceneCreatureProxy.FindCreature(playerId) or Game.Myself
    local strengthLv = BlackSmithProxy.CalculateBuffUpLevel(self.data.equipInfo.strengthlv or 0, player.data.userdata:Get(UDEnum.ROLELEVEL), withLimitBuffUpLv, withoutLimitBuffUpLv)
    self:UpdateStrengthLevel(strengthLv, 0 < withLimitBuffUpLv + withoutLimitBuffUpLv)
  end
end

function MyselfEquipItemShareCell:UpdateRefineLevelByPlayer(playerId)
  if self.data and self.data.staticData and ItemUtil.IsGVGSeasonEquip(self.data.staticData.id) or BlackSmithProxy.CheckShowRefineBuffUpLevel(self.data, playerId) then
    local getFunc = BlackSmithProxy.GetRefineBuffUpLevel
    local withLimitBuffUpLv, withoutLimitBuffUpLv = getFunc(self.index, playerId, 1), getFunc(self.index, playerId, 0)
    local refinelv = self.data.equipInfo.refinelv or 0
    local maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(self.data.staticData)
    if PvpProxy.Instance:IsFreeFire() then
      refinelv = MaxRefine
    end
    refinelv = BlackSmithProxy.CalculateBuffUpLevel(refinelv, maxRefineLv, withLimitBuffUpLv, withoutLimitBuffUpLv)
    self:UpdateRefineLevel(refinelv, 0 < withLimitBuffUpLv + withoutLimitBuffUpLv)
  end
end

function MyselfEquipItemShareCell:UpdateRefineLevel(refinelv, withBuff)
  if PvpProxy.Instance:IsFreeFire() and refinelv < MaxRefine then
    local maxRefineIndexes = GameConfig.TwelvePvp.FullRefinePos
    if self.index and maxRefineIndexes and TableUtil.HasValue(maxRefineIndexes, self.index) then
      refinelv = MaxRefine
    end
  end
  MyselfEquipItemShareCell.super.UpdateRefineLevel(self, refinelv, withBuff)
end

function MyselfEquipItemShareCell:addGuideButtonId()
  if GameConfig.SpecialGuide_Bag_QuestId == nil or #GameConfig.SpecialGuide_Bag_QuestId <= 0 then
    return
  end
  local questData
  for _, v in ipairs(GameConfig.SpecialGuide_Bag_QuestId) do
    questData = FunctionGuide.Me():checkHasGuide(v)
    if questData ~= nil then
      break
    end
  end
  if questData ~= nil then
    local guideId = questData.params.guideID
    local tbGuide = Table_GuideID[guideId]
    if tbGuide ~= nil and tbGuide.SpecialID == self.index then
      if self.index == 7 then
        self:AddOrRemoveGuideId(self.gameObject, 1003)
      elseif self.index == 5 then
        self:AddOrRemoveGuideId(self.gameObject, 1005)
      end
    end
  end
end
