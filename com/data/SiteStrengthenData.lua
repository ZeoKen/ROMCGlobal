local config = GameConfig.PosStrenght
local calcEquipStrengthAttr = CommonFun.calcSiteStrengthAttr
local calcGuildStrengthAttr = ItemFun.calcStrengthAttr
local adaperCalcGuildSiteStrengthAttr = function(site, lv)
  local result = {}
  local attrData = calcGuildStrengthAttr(site, lv)
  for attr, v in pairs(attrData) do
    local cell = {attrName = attr, value = v}
    result[#result + 1] = cell
  end
  return result
end
SiteStrengthenData = class("SiteStrengthenData")

function SiteStrengthenData:ctor(t, site, lv)
  self:SetData(t, site, lv)
end

function SiteStrengthenData:SetData(t, site, lv)
  self.type = t
  self.site = site
  self.calcAttrFunc = self.type == SceneItem_pb.ESTRENGTHTYPE_NORMAL and calcEquipStrengthAttr or adaperCalcGuildSiteStrengthAttr
  self.lv = lv
  self.name = config.name and config.name[site] or ""
  self.attrsMap = {}
end

function SiteStrengthenData:IsMax()
  if self.type == SceneItem_pb.ESTRENGTHTYPE_NORMAL then
    if not self.maxLevel or self.maxLevel <= 0 then
      self:SetMaxLevel()
    end
    self.maxLevel = math.max(self.maxLevel, StrengthProxy.Instance:MaxStrengthLevel(self.type))
    return self.lv >= self.maxLevel
  else
    self.maxLevel = StrengthProxy.Instance:MaxStrengthLevel(self.type)
    return self.lv >= self.maxLevel
  end
end

function SiteStrengthenData:SetMaxLevel(max)
  max = max or StrengthProxy.Instance:MaxStrengthLevel(self.type)
  self.maxLevel = max
end

function SiteStrengthenData:SetAttr()
  local attrs = self.calcAttrFunc(self.site, self.lv)
  for i = 1, #attrs do
    self.attrsMap[attrs[i].attrName] = attrs[i].value
  end
end

function SiteStrengthenData:SetNextInfo()
  self.nextAttrsMap = {}
  if not self:IsMax() then
    self.nextLv = self.lv + 1
    local nextAttrs = self.calcAttrFunc(self.site, self.nextLv)
    for i = 1, #nextAttrs do
      self.nextAttrsMap[nextAttrs[i].attrName] = nextAttrs[i].value
    end
  else
    self.nextAttrsMap = nil
  end
end

function SiteStrengthenData:StrengthInfo()
  local effects = {}
  local attrMap = self.attrsMap
  for k, v in pairs(attrMap) do
    local data = {}
    data.name = Table_RoleData[k].VarName
    data.value = v
    table.insert(effects, data)
  end
  return PropUtil.FormatEffects(effects, 1, " +")
end

function SiteStrengthenData:GetUpgradeInfo()
  local result = {}
  if self:IsMax() then
    local lv = {
      name = ZhString.EquipStrength_SiteLv,
      newValue = self.lv,
      isLv = true,
      isMax = true
    }
    result[#result + 1] = lv
    for k, v in pairs(self.attrsMap) do
      result[#result + 1] = {
        name = Table_RoleData[k].PropName,
        newValue = v,
        isMax = true
      }
    end
    return result
  end
  if not self.nextAttrsMap then
    self:SetNextInfo()
  end
  local lv = {
    name = ZhString.EquipStrength_SiteLv,
    oldValue = self.lv,
    newValue = self.nextLv,
    isLv = true
  }
  result[#result + 1] = lv
  for k, v in pairs(self.nextAttrsMap) do
    result[#result + 1] = {
      name = Table_RoleData[k].PropName,
      oldValue = self.attrsMap[k],
      newValue = v
    }
  end
  return result
end

function SiteStrengthenData:GetName()
  return self.name
end

function SiteStrengthenData:UpdateLv(lv)
  self.lv = lv
  if self.type == SceneItem_pb.ESTRENGTHTYPE_NORMAL and self:IsMax() then
    self.lv = math.min(self.maxLevel, lv)
  end
  self:SetAttr()
  self:SetNextInfo()
end

function SiteStrengthenData:GetLv()
  return self.lv or 0
end

function SiteStrengthenData:Clone()
  local d = SiteStrengthenData.new(self.type, self.site)
  d:UpdateLv(self.lv)
  return d
end
