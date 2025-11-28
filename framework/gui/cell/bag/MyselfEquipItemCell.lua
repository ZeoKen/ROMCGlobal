local MaxRefine = 15
local equipTypeCfg, equipPosCdCfg = GameConfig.EquipType, GameConfig.EquipPosCD
local myselfIns
local viceBg = "anying_icon_bg"
local comBg = "com_icon_bottom3"
local siteUnlockConfig = GameConfig.ShadowEquip and GameConfig.ShadowEquip.PosUnlock
autoImport("BaseItemCell")
MyselfEquipItemCell = class("MyselfEquipItemCell", BaseItemCell)

function MyselfEquipItemCell:ctor(obj, index, isfashion, viceEquip, fromSaveData)
  self.isViceEquip = viceEquip == true
  if not myselfIns then
    myselfIns = MyselfProxy.Instance
  end
  if index then
    self.index = index
  else
    LogUtility.Warning("index is nil while initializing MyselfEquipItemCell!")
  end
  MyselfEquipItemCell.super.ctor(self, obj)
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
    if viceEquip and siteUnlockConfig and siteUnlockConfig[index] then
      self.siteMenu = siteUnlockConfig[index].UnlockMenu
    end
  end
  self.itemRoot = self:FindGO("ItemRoot")
  self.itemBg = self:FindComponent("Background", UISprite, self.itemRoot)
  self.itemEmptyBg = self:FindComponent("Empty", UISprite, self.itemRoot)
  self.siteRoot = self:FindGO("SiteRoot")
  self.noEffect = self:FindGO("NoEffect")
  self.offForbid = self:FindGO("OffForbid")
  self.siteUnlockSp = self:FindGO("SiteUnlock")
  local siteUnlockSp2 = self:FindGO("Invalid (1)", self.siteUnlockSp)
  if self.siteUnlockSp and siteUnlockSp2 then
    local validspr = self.siteUnlockSp:GetComponent(UISprite)
    local validspr2 = siteUnlockSp2:GetComponent(UISprite)
    IconManager:SetUIIcon("icon_24", validspr)
    IconManager:SetUIIcon("icon_24", validspr2)
  end
  self.quenchPerLab = self:FindComponent("QuenchPerLab", UILabel, self.quenchRoot)
  self.quenchPerLab.gameObject:SetActive(self.isViceEquip == true)
  self.fromSaveData = fromSaveData
  self.siteStrenthenLv = self:FindComponent("StrengthenLv", UILabel)
  self.siteStrenthenLv2 = self:FindComponent("StrengthenLv2", UILabel)
  self.forbidColdDown = self:FindComponent("ForbidColdDown", UISprite)
  self.coldDown4EquipEffectGO = self:FindGO("ColdDown4EquipEffectGO")
  self.coldDown4EquipEffect = self:FindComponent("ColdDown4EquipEffect", UISprite)
  self:AddCellClickEvent()
  self:AddCellDoubleClickEvt()
end

function MyselfEquipItemCell:_resetViceEquipBg()
  local _spriteName
  local quality = self.data and self.data.staticData and self.data.staticData.Quality or 1
  if quality == 1 then
    _spriteName = comBg
  elseif quality == 2 then
    _spriteName = "refine_bg_green"
  elseif quality == 3 then
    _spriteName = "refine_bg_blue"
  elseif quality == 4 then
    _spriteName = "refine_bg_purple"
  elseif quality == 5 then
    _spriteName = "refine_bg_orange"
  elseif quality == 6 then
    _spriteName = "refine_bg_red"
  end
  if self.itemBg.spriteName == _spriteName then
    return
  end
  if _spriteName ~= comBg then
    self.itemBg.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
    self.itemEmptyBg.atlas = RO.AtlasMap.GetAtlas("NEWUI_Equip")
  else
    self.itemBg.atlas = RO.AtlasMap.GetAtlas("NewCom")
    self.itemEmptyBg.atlas = RO.AtlasMap.GetAtlas("NewCom")
  end
  self.itemBg.spriteName = _spriteName
  self.itemEmptyBg.spriteName = _spriteName
end

function MyselfEquipItemCell:_resetViceSiteLockState()
  if ItemUtil.HasMappingPos(self.index) and self.isViceEquip then
    self.viceForbidden = FunctionUnLockFunc.CheckForbiddenByFuncState("vice_equip_forbidden", self.index)
  else
    self.viceForbidden = BagProxy.Instance:CheckForbiddenByNoviceServer(self.index)
  end
  local siteLock = self.siteMenu and not FunctionUnLockFunc.Me():CheckCanOpen(self.siteMenu) and not self.fromSaveData
  if siteLock or self.viceForbidden and self.isViceEquip then
    self:Show(self.siteUnlockSp)
  else
    self:Hide(self.siteUnlockSp)
  end
end

function MyselfEquipItemCell:UpdateQuench()
  if not self.quenchPerLab then
    return
  end
  if not self.isViceEquip then
    return
  end
  self.quenchPerLab.text = self.data and self.data.HasQuench and self.data:HasQuench() and self.data:GetQuenchPer() .. "%" or ""
end

function MyselfEquipItemCell:SetData(data)
  MyselfEquipItemCell.super.SetData(self, data)
  if self.isPureSite then
    return
  end
  self:UpdateMyselfInfo(data)
  if data and data.staticData then
    local equipType = data.equipInfo.equipData.EquipType
    local config = equipTypeCfg[equipType]
    if config then
      local site = config.site
      local isPosRight = false
      if data:IsExtraction() then
        isPosRight = true
      else
        for k, v in pairs(site) do
          if v == data.index then
            isPosRight = true
          end
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
  self:UpdateQuench()
  self:UpdateEquipUpgradeTip()
  self:TrySetEquippedEffectCDCtrl()
  self:_resetViceEquipBg()
  self:_resetViceSiteLockState()
end

function MyselfEquipItemCell:ShowPureSite(active)
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

function MyselfEquipItemCell:UpdateSiteStrengthenLv(level)
  self.siteStrenthenLv.text = 0 < level and level or ""
end

function MyselfEquipItemCell:IsEffective()
  if self.data then
    local roleEquipBag = BagProxy.Instance:GetRoleEquipBag()
    local equip = roleEquipBag:GetEquipBySite(self.index)
    if equip then
      return equip.equipInfo.equipData.Type == self.data.equipInfo.equipData.Type
    end
    local roleEquip = BagProxy.Instance:GetEquipBySite(self.index)
    if not roleEquip then
      return false
    end
  end
  return true
end

function MyselfEquipItemCell:GetCD()
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
  return MyselfEquipItemCell.super.GetCD(self)
end

function MyselfEquipItemCell:GetMaxCD()
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
  return MyselfEquipItemCell.super.GetMaxCD(self)
end

function MyselfEquipItemCell:RefreshCD(f)
  local onCdTime = self:GetEquipPosOnCdTime()
  if self.data == nil then
    self:TrySetShowOffForbid(0 < f and not onCdTime)
    if (Slua.IsNull(self.coldDown4EquipEffectGO) or not self.coldDown4EquipEffectGO.activeInHierarchy) and not Slua.IsNull(self.forbidColdDown) then
      self.forbidColdDown.gameObject:SetActive(true)
    end
    if not Slua.IsNull(self.forbidColdDown) then
      self.forbidColdDown.fillAmount = f
    end
    return f == 0
  else
    self:TrySetShowOffForbid(false)
    if onCdTime then
      if (Slua.IsNull(self.coldDown4EquipEffectGO) or not self.coldDown4EquipEffectGO.activeInHierarchy) and not Slua.IsNull(self.coldDown) then
        self.coldDown.gameObject:SetActive(true)
      end
      if not Slua.IsNull(self.coldDown) then
        self.coldDown.fillAmount = f
      end
      return onCdTime <= 0
    end
    return MyselfEquipItemCell.super.RefreshCD(self, f)
  end
end

function MyselfEquipItemCell:ClearCD()
  self.coldDown.fillAmount = 0
  if self.forbidColdDown then
    self.forbidColdDown.fillAmount = 0
  end
end

function MyselfEquipItemCell:GetEquipPosOnCdTime()
  if self.isViceEquip then
    return nil
  end
  return myselfIns:GetEquipPosOnCdTime(self.index, self.isViceEquip)
end

function MyselfEquipItemCell:TrySetShowOffForbid(isShow)
  isShow = isShow and true or false
  if not Slua.IsNull(self.offForbid) then
    self.offForbid:SetActive(isShow)
  end
end

function MyselfEquipItemCell:UpdateStrengthLevelByPlayer(playerId)
  if BlackSmithProxy.CheckShowStrengthBuffUpLevel(self.data, playerId) then
    local getFunc = BlackSmithProxy.GetStrengthBuffUpLevel
    local withLimitBuffUpLv, withoutLimitBuffUpLv = getFunc(self.index, playerId, 1), getFunc(self.index, playerId, 0)
    local player = playerId and SceneCreatureProxy.FindCreature(playerId) or Game.Myself
    local strengthLv = BlackSmithProxy.CalculateBuffUpLevel(self.data.equipInfo.strengthlv or 0, player.data.userdata:Get(UDEnum.ROLELEVEL), withLimitBuffUpLv, withoutLimitBuffUpLv)
    self:UpdateStrengthLevel(strengthLv, 0 < withLimitBuffUpLv + withoutLimitBuffUpLv)
  end
end

function MyselfEquipItemCell:UpdateRefineLevelByPlayer(playerId)
  if self.data and self.data.staticData and ItemUtil.IsGVGSeasonEquip(self.data.staticData.id) or BlackSmithProxy.CheckShowRefineBuffUpLevel(self.data, playerId) then
    local getFunc = BlackSmithProxy.GetRefineBuffUpLevel
    local withLimitBuffUpLv, withoutLimitBuffUpLv, withExtraLimitBuffUpLv = getFunc(self.index, playerId, 1), getFunc(self.index, playerId, 0), getFunc(self.index, playerId, 2)
    local refinelv = self.data.equipInfo.refinelv or 0
    local capLv = BlackSmithProxy.Instance:GetEquipCapLevel(self.index, playerId)
    local maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(self.data.staticData)
    if PvpProxy.Instance:IsFreeFire() then
      refinelv = MaxRefine
    end
    refinelv = BlackSmithProxy.CalculateBuffUpLevel(refinelv, maxRefineLv, withLimitBuffUpLv, withoutLimitBuffUpLv, capLv, withExtraLimitBuffUpLv)
    self:UpdateRefineLevel(refinelv, 0 < withLimitBuffUpLv + withoutLimitBuffUpLv + withExtraLimitBuffUpLv)
  end
end

function MyselfEquipItemCell:UpdateRefineLevel(refinelv, withBuff)
  if PvpProxy.Instance:IsFreeFire() and refinelv < MaxRefine then
    local maxRefineIndexes = GameConfig.TwelvePvp.FullRefinePos
    if self.index and maxRefineIndexes and TableUtil.HasValue(maxRefineIndexes, self.index) then
      refinelv = MaxRefine
    end
  end
  MyselfEquipItemCell.super.UpdateRefineLevel(self, refinelv, withBuff)
end

function MyselfEquipItemCell:addGuideButtonId()
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

function MyselfEquipItemCell:TrySetEquippedEffectCDCtrl()
  local equipInfo = self.data and self.data.equipInfo
  if not equipInfo or not self.coldDown4EquipEffectGO then
    self.coldDown4EquipEffect.fillAmount = 0
    self.coldDown4EquipEffectGO:SetActive(false)
    self.coldDown.gameObject:SetActive(true)
    self.forbidColdDown.gameObject:SetActive(true)
    return
  end
  local ef_cd, ef_time = MyselfProxy.Instance:GetEquipPosEffectTime(self.index, self.isViceEquip)
  if ef_cd then
    if not self.ef_cdcell then
      self.ef_cdcell = EquippedEffectCDRefresherCell.new(self, self.index, self.isViceEquip, ef_time)
    end
    if not self.cdCtrl2 then
      self.cdCtrl2 = FunctionCDCommand.Me():GetCDProxy(EquippedEffectCDRefresher)
      if not self.cdCtrl2 then
        self.cdCtrl2 = FunctionCDCommand.Me():StartCDProxy(EquippedEffectCDRefresher, 33)
      end
    end
    if 0 < self.ef_cdcell:GetCD() then
      self.cdCtrl2:Add(self.ef_cdcell)
    else
      self.cdCtrl2:Remove(self.ef_cdcell)
    end
  else
    if self.ef_cdcell then
      self.ef_cdcell:Dispose()
      self.ef_cdcell = nil
    end
    self.coldDown4EquipEffect.fillAmount = 0
    self.coldDown4EquipEffectGO:SetActive(false)
    self.coldDown.gameObject:SetActive(true)
    self.forbidColdDown.gameObject:SetActive(true)
  end
end

EquippedEffectCDRefresherCell = class("EquippedEffectCDRefresherCell")

function EquippedEffectCDRefresherCell:ctor(baseCell, index, isViceEquip, ef_time)
  self.baseCell = baseCell
  self.gameObject = 1
  self.index = index
  self.isViceEquip = isViceEquip
  self.ef_time = ef_time
end

function EquippedEffectCDRefresherCell:AddCD()
  if self.baseCell and not Slua.IsNull(self.baseCell.coldDown4EquipEffectGO) then
    self.baseCell.coldDown4EquipEffectGO:SetActive(true)
  end
  if self.baseCell and not Slua.IsNull(self.baseCell.coldDown) then
    self.baseCell.coldDown.gameObject:SetActive(false)
  end
  if self.baseCell and not Slua.IsNull(self.baseCell.forbidColdDown) then
    self.baseCell.forbidColdDown.gameObject:SetActive(false)
  end
end

function EquippedEffectCDRefresherCell:ClearCD()
  if self.baseCell and not Slua.IsNull(self.baseCell.coldDown4EquipEffectGO) then
    self.baseCell.coldDown4EquipEffectGO:SetActive(false)
  end
  if self.baseCell and not Slua.IsNull(self.baseCell.coldDown) then
    self.baseCell.coldDown.gameObject:SetActive(true)
  end
  if self.baseCell and not Slua.IsNull(self.baseCell.forbidColdDown) then
    self.baseCell.forbidColdDown.gameObject:SetActive(true)
  end
end

function EquippedEffectCDRefresherCell:GetCD()
  if self.index then
    local cd = MyselfProxy.Instance:GetEquipPosEffectTime(self.index, self.isViceEquip)
    return cd or 0
  end
end

function EquippedEffectCDRefresherCell:GetMaxCD()
  if self.index then
    return self.ef_time
  end
end

function EquippedEffectCDRefresherCell:RefreshCD(f)
  if self.baseCell and self.baseCell.coldDown4EquipEffect then
    self.baseCell.coldDown4EquipEffect.fillAmount = f
    return f == 0
  end
end

function EquippedEffectCDRefresherCell:Dispose()
  TimeTickManager.Me():ClearTick(self)
end
