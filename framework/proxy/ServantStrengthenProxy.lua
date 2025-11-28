ServantStrengthenProxy = class("ServantStrengthenProxy", pm.Proxy)
ServantStrengthenProxy.Instance = nil
ServantStrengthenProxy.NAME = "ServantStrengthenProxy"
autoImport("ServantStrengthenData")
local EquipSite_Fushou = 1
local EquipSite_Kuijia = 2
local EquipSite_Pijian = 3
local EquipSite_Xiezi = 4
local EquipSite_Shipin1 = 5
local EquipSite_Shipin2 = 6
local EquipSite_Wuqi = 7
local EquipSite_Toushi = 8
local EquipSite_Lianbu = 9
local EquipSite_Zuibu = 10
local EquipSite_Beibu = 11
local EquipSite_Weibu = 12
local AllEquipSites = {
  EquipSite_Wuqi,
  EquipSite_Fushou,
  EquipSite_Kuijia,
  EquipSite_Pijian,
  EquipSite_Xiezi,
  EquipSite_Shipin1,
  EquipSite_Shipin2,
  EquipSite_Toushi,
  EquipSite_Lianbu,
  EquipSite_Zuibu,
  EquipSite_Beibu,
  EquipSite_Weibu
}
local ArrayPushBack = TableUtility.ArrayPushBack
local Servant_type = {
  Upgrade = "Upgrade",
  RefineFour = "RefineFour",
  RefineSix = "RefineSix",
  Enchant = "Enchant",
  SewingStrengthen = "SewingStrengthen",
  SewingRefine = "SewingRefine",
  Enhance = "Enhance",
  GvGPvPPray = "GvGPvPPray",
  Astrolabe = "Astrolabe",
  GuildPray = "GuildPray",
  PeakLevel = "PeakLevel",
  Replace = "Replace"
}

function ServantStrengthenProxy:ctor(proxyName, data)
  self.proxyName = proxyName or ServantStrengthenProxy.NAME
  if ServantStrengthenProxy.Instance == nil then
    ServantStrengthenProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function ServantStrengthenProxy:Init()
  self.calls = {}
  self:InitHandles()
  self.Data = {}
end

local handles = {}

function ServantStrengthenProxy:InitHandles()
  handles[Servant_type.Upgrade] = self.Upgrade
  handles[Servant_type.RefineFour] = self.RefineFour
  handles[Servant_type.RefineSix] = self.RefineSix
  handles[Servant_type.Enchant] = self.Enchant
  handles[Servant_type.SewingStrengthen] = self.SewingStrengthen
  handles[Servant_type.SewingRefine] = self.SewingRefine
  handles[Servant_type.Enhance] = self.Enhance
  handles[Servant_type.GvGPvPPray] = self.GvGPvPPray
  handles[Servant_type.Astrolabe] = self.Astrolabe
  handles[Servant_type.GuildPray] = self.GuildPray
  handles[Servant_type.PeakLevel] = self.PeakLevel
  handles[Servant_type.Replace] = self.Replace
  self:InitCall(handles)
end

function ServantStrengthenProxy:InitCall(handles)
  local handle
  if not Table_ServantStrengthen then
    return
  end
  for k, config in pairs(Table_ServantStrengthen) do
    handle = handles[config.Appear]
    if nil ~= handle then
      self.calls[config.Appear] = handle
    end
  end
end

function ServantStrengthenProxy:_getCall(type)
  local typeCfg = Servant_type[type]
  return typeCfg and self.calls[type]
end

function ServantStrengthenProxy:Call(staticData)
  if nil == staticData then
    return
  end
  local call = self:_getCall(staticData.Appear)
  if nil == call then
    return
  end
  call(self, staticData)
end

function ServantStrengthenProxy:GetData()
  TableUtility.ArrayClear(self.Data)
  if not Table_ServantStrengthen then
    return
  end
  for k, v in pairs(Table_ServantStrengthen) do
    self:Call(v)
  end
  local profession = MyselfProxy.Instance:GetMyProfession()
  helplog("my profession: ", profession)
  return self.Data
end

function ServantStrengthenProxy:Upgrade(cfg)
end

function ServantStrengthenProxy:RefineFour(cfg)
  if Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) > cfg.Appear_Params[1] then
    for i = 1, #AllEquipSites do
      refinelv = Game.Myself.data:GetEquipedRefineLv(AllEquipSites[i])
      if refinelv > cfg.Appear_Params[2] then
        local cellData = ServantStrengthenData.new(cfg)
        ArrayPushBack(self.Data, cellData)
      end
    end
  end
end

function ServantStrengthenProxy:RefineSix(cfg)
  if Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) > cfg.Appear_Params[1] then
    for i = 1, #AllEquipSites do
      refinelv = Game.Myself.data:GetEquipedRefineLv(AllEquipSites[i])
      if cfg.Appear_Params[3] > refinelv and refinelv >= cfg.Appear_Params[2] then
        local cellData = ServantStrengthenData.new(cfg)
        ArrayPushBack(self.Data, cellData)
      end
    end
  end
end

function ServantStrengthenProxy:Enchant(cfg)
  local roleEquip = BagProxy.Instance.roleEquip
  local active = BlackSmithProxy:CanBetter_EquipEnchantInfo()
  for i = 1, #AllEquipSites do
    local equipId = roleEquip:GetCanEnchantEquipID(AllEquipSites[i])
    if equipId then
      local cellData = ServantStrengthenData.new(cfg, equipId, active)
      ArrayPushBack(self.Data, cellData)
    end
  end
end

local isSewingOpen

function ServantStrengthenProxy._IsSewingUnlock()
  isSewingOpen = GuildBuildingProxy.Instance:GetBuildingLevelByType(GuildBuildingProxy.Type.EGUILDBUILDING_MAGIC_SEWING)
  isSewingOpen = isSewingOpen and 0 < isSewingOpen or false
  return isSewingOpen
end

function ServantStrengthenProxy:SewingStrengthen(cfg)
  if ServantStrengthenProxy._IsSewingUnlock() and BagProxy.Instance:GetItemNumByStaticID(cfg.Appear_Params[1]) > 0 then
    local cellData = ServantStrengthenData.new(cfg)
    ArrayPushBack(self.Data, cellData)
  end
end

function ServantStrengthenProxy:SewingRefine(cfg)
  if ServantStrengthenProxy._IsSewingUnlock() and BagProxy.Instance:GetItemNumByStaticID(cfg.Appear_Params[1]) > 0 then
    local cellData = ServantStrengthenData.new(cfg)
    ArrayPushBack(self.Data, cellData)
  end
end

local equipEquips = {}

function ServantStrengthenProxy:Enhance(cfg)
  local roleEquip = BagProxy.Instance.roleEquip
  equipEquips = roleEquip:GetItems() or {}
  for i = 1, #equipEquips do
    local equipInfo = equipEquips[i] and equipEquips[i].equipInfo
    if equipInfo and equipInfo:CanStrength() and equipInfo.strengthlv < Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) then
      local costenough = CostUtil.CheckStrengthCost(equipEquips[i].staticData, equipInfo.strengthlv)
      local cellData = ServantStrengthenData.new(cfg, equipEquips[i].staticData.id, costenough)
      ArrayPushBack(self.Data, cellData)
    end
  end
end

function ServantStrengthenProxy:GvGPvPPray(cfg)
end

function ServantStrengthenProxy:Astrolabe(cfg)
  if BagProxy.Instance:GetItemNumByStaticID(cfg.Appear_Params[1]) > 0 then
    local active = AstrolabeProxy.Instance:CheckCanActive_AnyAstrolabePoint()
    ArrayPushBack(self.Data, ServantStrengthenData.new(cfg, nil, active))
  end
end

function ServantStrengthenProxy:GuildPray(cfg)
end

function ServantStrengthenProxy:PeakLevel(cfg)
  local jobLv = MyselfProxy.Instance:JobLevel()
  if BagProxy.Instance:GetItemNumByStaticID(cfg.Appear_Params[1]) > 0 and jobLv >= cfg.Appear_Params[2] then
    local cellData = ServantStrengthenData.new(cfg)
    ArrayPushBack(self.Data, cellData)
  end
end

function ServantStrengthenProxy:Replace(cfg)
end
