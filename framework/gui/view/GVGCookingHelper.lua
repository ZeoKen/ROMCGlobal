GVGCookingHelper = class("GVGCookingHelper")
local GameConfig_GvgRimConfig = GameConfig.GvgRimConfig

function GVGCookingHelper.Me()
  if nil == GVGCookingHelper.me then
    GVGCookingHelper.me = GVGCookingHelper.new()
  end
  return GVGCookingHelper.me
end

function GVGCookingHelper:ctor()
  self.m_npcTid = 826505
  self.m_npcUid = 82650500
  self.m_itemId = 6957
end

function GVGCookingHelper:DoConstruct(asArray)
end

function GVGCookingHelper:DoDeconstruct()
  self:removeNpc()
  GVGCookingHelper.me = nil
end

function GVGCookingHelper:updateCookingInfo(value)
  local nowSeason = GvgProxy.Instance:NowSeason()
  GameConfig_GvgRimConfig = GameConfig.GvgRimConfig.SeasonSpecial and GameConfig.GvgRimConfig.SeasonSpecial[nowSeason] or GameConfig.GvgRimConfig
  self.m_cookingInfo = {}
  self.m_cookingInfo.m_ingredients = value.info.ingredients
  self.m_cookingInfo.m_heat = value.info.heat
  self.m_cookingInfo.m_seasoning = value.info.seasoning
  self.m_cookingInfo.m_endtime = value.info.endtime
  self.m_cookingInfo.m_ingreditem = value.info.ingreditem
  self.m_cookingInfo.m_maxstar = value.info.maxstar or 5
  self.m_cookingLog = value.log
  local maxIngredPoint = GameConfig_GvgRimConfig.IngredPoint or 1000
  self.m_cookingInfo.m_IngredFull = maxIngredPoint <= self.m_cookingInfo.m_ingredients
  local maxHeatPoint = GameConfig_GvgRimConfig.HeatPoint or 1000
  self.m_cookingInfo.m_HeatFull = maxHeatPoint <= self.m_cookingInfo.m_heat
  local maxSeasoningPoint = GameConfig_GvgRimConfig.SeasoningPoint or 1000
  self.m_cookingInfo.m_SeasoningFull = maxSeasoningPoint <= self.m_cookingInfo.m_seasoning
  self.m_cookingInfo.m_TotalPointFull = self:getCurValue() >= GameConfig_GvgRimConfig.star_point[self.m_cookingInfo.m_maxstar]
  if self:isInGvGMap() then
    self:createNpc()
  else
    self:removeNpc()
  end
  if self.m_creature ~= nil and self.m_roleTopUI ~= nil then
    self.m_roleTopUI:UpdateGvGCookingInfo(self.m_creature)
  end
  EventManager.Me():PassEvent(GVGCookingEvent.UpdateInfo)
end

function GVGCookingHelper:createNpc()
  if self.m_creature == nil then
    local data = {}
    data.npcID = self.m_npcTid
    data.id = self.m_npcUid
    data.uniqueid = self.m_npcUid
    local posConfig = GameConfig.GvgRimConfig.pos
    data.pos = {
      x = posConfig[1] * 1000,
      y = posConfig[2] * 1000,
      z = posConfig[3] * 1000
    }
    data.datas = {}
    data.attrs = {}
    data.mounts = {}
    local staticData = Table_Npc[data.npcID]
    data.staticData = staticData
    if staticData.NameZh ~= nil then
      data.name = staticData.NameZh
    end
    data.searchrange = 0
    self.m_creature = NSceneNpcProxy.Instance:Add(data, NNpc)
    if staticData then
      if staticData.ShowName then
        self.m_creature.data.userdata:Set(UDEnum.SHOWNAME, staticData.ShowName)
      end
      if staticData.Scale then
        self.m_creature:Server_SetScaleCmd(staticData.Scale, true)
      end
    end
    self.m_creature.assetRole:SetColliderEnable(true)
    if self.m_roleTopUI == nil then
      self.m_roleTopUI = self.m_creature:GetSceneUI().roleTopUI
      self.m_roleTopUI:UpdateGvGCookingInfo(self.m_creature)
    end
    FunctionVisitNpc.Me():RegisterVisitShow(self.m_npcUid, nil, self.onVisitNpc, self)
    self.m_creature:RegisterWeakObserver(self)
    EventManager.Me():PassEvent(GVGCookingEvent.CreateCookingNpc)
  end
end

function GVGCookingHelper:getNpc()
  return self.m_creature
end

function GVGCookingHelper:ObserverDestroyed(obj)
  if obj == self.m_creature then
    self.m_creature = nil
    self.m_roleTopUI = nil
    self:removeNpc()
  end
end

function GVGCookingHelper:removeNpc()
  if self.m_roleTopUI ~= nil then
    self.m_roleTopUI:RemoveGvGCookingInfo()
    self.m_roleTopUI = nil
  end
  if self.m_creature ~= nil then
    NSceneNpcProxy.Instance:Remove(self.m_npcUid)
    self.m_creature = nil
  end
  EventManager.Me():PassEvent(GVGCookingEvent.RemoveCookingNpc)
end

function GVGCookingHelper:onVisitNpc(note)
  if not GuildProxy.Instance:IHaveGuild() then
    MsgManager.ShowMsgByID(31069)
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GvGCookingView,
    viewdata = nil
  })
end

function GVGCookingHelper:isInGvGMap()
  local mapId = Game.MapManager:GetMapID()
  local mapsConfig = GameConfig.GvgRimConfig.maps
  for _, v in pairs(mapsConfig) do
    if v == mapId then
      return true
    end
  end
  return false
end

function GVGCookingHelper:isEndTime()
  return ServerTime.CurServerTime() / 1000 > self.m_cookingInfo.m_endtime
end

function GVGCookingHelper:getCurValue()
  return self.m_cookingInfo.m_ingredients + self.m_cookingInfo.m_heat + self.m_cookingInfo.m_seasoning
end

function GVGCookingHelper:getCurTotalValue()
  local maxstar = self.m_cookingInfo.m_maxstar
  local config
  local nowSeason = GvgProxy.Instance:NowSeason()
  if nowSeason then
    config = GameConfig.GvgRimConfig.SeasonSpecial and GameConfig.GvgRimConfig.SeasonSpecial[nowSeason]
  end
  config = config or GameConfig.GvgRimConfig
  return config and config.star_point[maxstar] or self:getTotalValue()
end

function GVGCookingHelper:getTotalValue()
  local config
  local nowSeason = GvgProxy.Instance:NowSeason()
  if nowSeason then
    config = GameConfig.GvgRimConfig.SeasonSpecial and GameConfig.GvgRimConfig.SeasonSpecial[nowSeason]
  end
  config = config or GameConfig.GvgRimConfig
  return config.IngredPoint + config.HeatPoint + config.SeasoningPoint
end

function GVGCookingHelper:getCookingInfo()
  return self.m_cookingInfo
end

function GVGCookingHelper:getCookingLog()
  return self.m_cookingLog
end

function GVGCookingHelper:isCanUseCooking(id)
  if self.m_itemId ~= id then
    return true
  end
  local msgs = GameConfig.GvgRimConfig.useResultMsg
  if msgs == nil or #msgs < 3 then
    return true
  end
  if not self:isInGvGMap() then
    MsgManager.ShowMsgByID(msgs[2])
    return false
  end
  if self.m_creature ~= nil then
    MsgManager.ShowMsgByID(msgs[3])
    return false
  end
  return true
end

function GVGCookingHelper:playCookingAction(type)
  if self.m_creature ~= nil then
    local actionName
    if type == 1 then
      local actionData = Table_ActionAnime[506]
      if actionData then
        actionName = actionData.Name
      end
    elseif type == 2 then
      local actionData = Table_ActionAnime[504]
      if actionData then
        actionName = actionData.Name
      end
    elseif type == 3 then
      local actionData = Table_ActionAnime[502]
      if actionData then
        actionName = actionData.Name
      end
    end
    self.m_creature:Logic_PlayAction_Simple(actionName)
  end
end

function GVGCookingHelper:playEatAnim()
  local actionData = Table_ActionAnime[207]
  if actionData then
    Game.Myself:Client_PlayAction(actionData.Name, nil, false)
  end
end

function GVGCookingHelper:getCreatureTrans()
  if self.m_creature == nil then
    return nil
  end
  return self.m_creature.assetRole.completeTransform
end

function GVGCookingHelper:maskCreatureTopFram()
  if self.m_creature == nil then
    return nil
  end
  FunctionPlayerUI.Me():MaskTopFrame(self.m_creature, "GVGCookingHelper")
end

function GVGCookingHelper:unMaskCreatureTopFram()
  if self.m_creature == nil then
    return nil
  end
  FunctionPlayerUI.Me():UnMaskTopFrame(self.m_creature, "GVGCookingHelper")
end
