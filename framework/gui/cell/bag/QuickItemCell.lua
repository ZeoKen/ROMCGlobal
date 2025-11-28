autoImport("BaseItemCell")
QuickItemCell = class("QuickItemCell", BaseItemCell)
local tempV3 = LuaVector3()
local MaxRefine = 15
local _ArrayIndex = TableUtil.ArrayIndexOf
local _HpConfigID = GameConfig.QuickItemTip.HpItemIds
local _SpConfigID = GameConfig.QuickItemTip.SpItemIds
local _HpPer = GameConfig.QuickItemTip.HpPct / 100
local _SpPer = GameConfig.QuickItemTip.SpPct / 100
local _HpSpTipEffectLv = GameConfig.QuickItemTip.Level
local _MAX = math.max
local _EquipPosCD = GameConfig.EquipPosCD

function QuickItemCell:Init()
  QuickItemCell.super.Init(self)
  self.tipEffect = self:FindGO("TipEffect")
  self.coldDown4EquipEffect = self:FindComponent("ColdDown4EquipEffect", UISprite)
  self.tipEffect:SetActive(true)
  self:SetDefaultBgSprite(RO.AtlasMap.GetAtlas("NewCom"), "com_icon_bottom2")
  self.effectShowed = false
end

function QuickItemCell:SetData(data)
  self.data = data
  self.quickItemSite = nil
  if data and data.staticData then
    self.gameObject:SetActive(true)
    QuickItemCell.super.SetData(self, data)
    self:SetIconDark(data.id == "Shadow")
    self:RefreshNumLab()
    self:UpdateMyselfInfo()
    local staticId = data.staticData.id
    self.isSp, self.isHp = 0 ~= _ArrayIndex(_SpConfigID, staticId), 0 ~= _ArrayIndex(_HpConfigID, staticId)
  else
    self.isSp, self.isHp = false, false
    self.gameObject:SetActive(false)
    if self.cdCtrl and self.cdCtrl:IsRefreshing(self) then
      self.cdCtrl:Remove(self)
    end
  end
  self:UpdateHpSpTipEffect()
  self:UpdateRefineLv()
end

function QuickItemCell:_getSite()
  if not self.quickItemSite then
    if self.data and self.data.id ~= "Shadow" and self.data.staticData then
      self.quickItemSite = RoleEquipBagData.GetEquipSiteByItemid(self.data.staticData.id)
    else
      self.quickItemSite = 0
    end
  end
  return self.quickItemSite
end

function QuickItemCell:_getCdTimeByEquipPos()
  local site = self:_getSite()
  if site and site ~= 0 then
    local cd = MyselfProxy.Instance:GetEquipPosOnCdTime(site)
    if cd then
      return cd
    end
  end
  return nil
end

function QuickItemCell:_getEffectCdTimeByEquipPos()
  if self.data.equiped == 0 then
    return
  end
  local site = self:_getSite()
  if site and site ~= 0 then
    local cd, max_cd = MyselfProxy.Instance:GetEquipPosEffectTime(site)
    if cd then
      return cd, max_cd
    end
  end
  return nil
end

function QuickItemCell:GetCD()
  local ef_cd = self:_getEffectCdTimeByEquipPos()
  if ef_cd then
    return ef_cd
  end
  local cd = self:_getCdTimeByEquipPos()
  if cd then
    return cd
  end
  return QuickItemCell.super.GetCD(self)
end

function QuickItemCell:GetMaxCD()
  local ef_cd, ef_time = self:_getEffectCdTimeByEquipPos()
  if ef_cd and ef_time then
    return ef_time
  end
  local cd = self:_getCdTimeByEquipPos()
  if cd then
    local maxcd = _EquipPosCD[self.quickItemSite]
    if maxcd then
      return maxcd
    end
  end
  return QuickItemCell.super.GetMaxCD(self)
end

function QuickItemCell:RefreshCD(f)
  local ef_cd = self:_getEffectCdTimeByEquipPos()
  if ef_cd then
    self.coldDown4EquipEffect.fillAmount = f
    self.coldDown.fillAmount = 1
    return
  end
  self.coldDown4EquipEffect.fillAmount = 0
  local cd = self:_getCdTimeByEquipPos()
  if cd then
    self.coldDown.fillAmount = f
    return cd <= 0
  end
  return QuickItemCell.super.RefreshCD(self, f)
end

function QuickItemCell:ClearCD()
  QuickItemCell.super.ClearCD(self)
  self.coldDown4EquipEffect.fillAmount = 0
end

function QuickItemCell:SetActiveSymbol(active)
  if not active and nil ~= BagProxy.Instance.roleEquip:GetItemByGuid(self.data.id) then
    active = true
  end
  QuickItemCell.super.SetActiveSymbol(self, active)
  self:UpdateRefineLv()
end

function QuickItemCell:UpdateHpSpTipEffect()
  local needShow = false
  local needCheck = self.isSp or self.isHp
  if needCheck and self.data and self.data.num > 0 and self.data.id ~= "Shadow" and MyselfProxy.Instance:RoleLevel() < _HpSpTipEffectLv then
    local props = Game.Myself.data.props
    if self.isHp then
      needShow = _HpPer > props:GetPropByName("Hp"):GetValue() / _MAX(props:GetPropByName("MaxHp"):GetValue(), 1)
    else
      needShow = _SpPer > props:GetPropByName("Sp"):GetValue() / _MAX(props:GetPropByName("MaxSp"):GetValue(), 1)
    end
  end
  if self.effectShowed ~= needShow then
    self.effectShowed = needShow
    if needShow then
      if nil == self.hpSpEffect then
        self.hpSpEffect = self:LoadPreferb_ByFullPath(ResourcePathHelper.Effect("UI/45Click_icon"), self.tipEffect)
      end
      self.hpSpEffect:SetActive(true)
    elseif nil ~= self.hpSpEffect then
      self.hpSpEffect:SetActive(false)
    end
  end
end

function QuickItemCell:RefreshNumLab()
  self.numLabGO = self:FindGO("NumLabel", self.item)
  if self.numLabGO then
    self.numLabTrans = self.numLabGO.transform
    LuaVector3.Better_Set(tempV3, 40.2, -43.2, 0)
    self.numLabTrans.localPosition = tempV3
  end
end

function QuickItemCell:UpdateRefineLv()
  if self.data and self.data.equipInfo then
    local active = BagProxy.Instance.roleEquip:GetItemByGuid(self.data.id)
    if not active then
      return
    end
    local getFunc = BlackSmithProxy.GetRefineBuffUpLevel
    local index = BagProxy.Instance:GetRoleBagSite(self.data.id)
    if index then
      local withLimitBuffUpLv, withoutLimitBuffUpLv, withExtraLimitBuffUpLv = getFunc(index, playerId, 1), getFunc(index, playerId, 0), getFunc(index, playerId, 2)
      local refinelv = self.data.equipInfo.refinelv or 0
      local maxRefineLv = BlackSmithProxy.Instance:MaxRefineLevelByData(self.data.staticData)
      if PvpProxy.Instance:IsFreeFire() then
        refinelv = MaxRefine
      end
      local capLv = BlackSmithProxy.Instance:GetEquipCapLevel(index, playerId)
      refinelv = BlackSmithProxy.CalculateBuffUpLevel(refinelv, maxRefineLv, withLimitBuffUpLv, withoutLimitBuffUpLv, capLv, withExtraLimitBuffUpLv)
      self:UpdateRefineLevel(refinelv, 0 < withLimitBuffUpLv + withoutLimitBuffUpLv + withExtraLimitBuffUpLv)
    end
  end
end
