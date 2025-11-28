RedTipProxy = class("RedTipProxy", pm.Proxy)
RedTipProxy.Instance = nil
RedTipProxy.NAME = "RedTipProxy"
RedTipProxy.UpdateRedTipEvent = "RedTipProxy.UpdateRedTipEvent"
RedTipProxy.UpdateParamEvent = "RedTipProxy.UpdateParamEvent"
RedTipProxy.RemoveRedTipEvent = "RedTipProxy.RemoveRedTipEvent"

function RedTipProxy:ctor(proxyName, data)
  self.proxyName = proxyName or RedTipProxy.NAME
  if RedTipProxy.Instance == nil then
    RedTipProxy.Instance = self
  end
  if data ~= nil then
    self:setData(data)
  end
  self:Init()
end

function RedTipProxy:Init()
  self.groupIDs = {}
  local groups
  for k, v in pairs(Table_RedTip) do
    if v.GroupID then
      groups = self.groupIDs[v.GroupID]
      if groups == nil then
        groups = {}
        self.groupIDs[v.GroupID] = groups
      end
      groups[#groups + 1] = k
    end
  end
  self.redTips = {}
  self.redTipsByMenu = {}
  self.uis = {}
  EventManager.Me():AddEventListener(ServiceEvent.NUserNewMenu, self.HandleMenuOpen, self)
end

function RedTipProxy:HandleMenuOpen(openMenus)
  for i = 1, #openMenus do
    local tips = self.redTipsByMenu[openMenus[i]]
    if tips then
      local tip
      for j = 1, #tips do
        tip = tips[j]
        if openMenus[i] == 6300 then
          FunctionUnLockFunc.Me():UnLockMenu(6300)
        end
        if tip.isBlockByMenu and tip.enable then
          tip:AddReds()
        end
      end
    end
  end
end

function RedTipProxy:GetRedTip(id)
  return self.redTips[id]
end

function RedTipProxy:GetOrCreateRedTip(id)
  local tip = self:GetRedTip(id)
  if tip == nil then
    tip = RedTip.new(id, paramIds)
    if tip.config.MenuID then
      local tips = self.redTipsByMenu[tip.config.MenuID]
      if tips == nil then
        tips = {}
        self.redTipsByMenu[tip.config.MenuID] = tips
      end
      tips[#tips + 1] = tip
    end
    self.redTips[id] = tip
  end
  return tip
end

function RedTipProxy:InRedTip(id)
  local tip = self:GetRedTip(id)
  if tip ~= nil then
    return tip.enable
  end
  return false
end

function RedTipProxy:HasRedTipParam(redTipID)
  local tip = self:GetRedTip(redTipID)
  if tip then
    return tip:HasParamID()
  end
  return false
end

function RedTipProxy:IsNew(tipId, id)
  local tip = self:GetRedTip(tipId)
  if tip and tip.enable then
    return tip:HasParam(id)
  end
  return false
end

function RedTipProxy:SeenNew(tipid, subtipid, guilddate)
  if nil == tipid or nil == Table_RedTip[tipid] then
    redlog("RedTipProxy:SeenNew() tip config is nil")
    return
  end
  local tip = self:GetOrCreateRedTip(tipid)
  if tip.enable and tip.config then
    if guilddate then
      ServiceGuildCmdProxy.Instance:CallRedtipBrowseGuildCmd(tipid, subtipid)
    else
      ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(tipid, subtipid)
    end
  end
end

function RedTipProxy:RemoveWholeTipsByServerData(data)
  for i = 1, #data.redtip do
    self:RemoveWholeTip(data.redtip[i].redsys)
  end
end

function RedTipProxy:RemoveWholeTips(ids)
  for i = 1, #ids do
    self:RemoveWholeTip(ids[i])
  end
end

function RedTipProxy:RemoveAll()
  for k, v in pairs(self.redTips) do
    self:RemoveWholeTip(k)
  end
end

function RedTipProxy:RemoveWholeTip(id)
  if self:InRedTip(id) then
    local tip = self:GetOrCreateRedTip(id)
    tip:SetEnable(false)
    tip:RemoveParams()
    GameFacade.Instance:sendNotification(RedTipProxy.RemoveRedTipEvent, {id = id})
  end
end

function RedTipProxy:RecvGameTipCmd(data)
  if data.opt == SceneTip_pb.ETIPOPT_UPDATE then
    self:UpdateRedTipsByServer(data.redtip)
  elseif data.opt == SceneTip_pb.ETIPOPT_DELETE then
    self:RemoveWholeTipsByServerData(data)
  end
end

function RedTipProxy:UpdateRedTipsByServer(datas)
  for i = 1, #datas do
    self:UpdateRedTipbyServer(datas[i])
  end
end

function RedTipProxy:UpdateRedTipbyServer(data)
  if data.optItem == SceneTip_pb.ETIPITEMOPT_ADD then
    if data.redsys == SceneTip_pb.EREDSYS_FUNCTION_OPENING or data.opt == SceneTip_pb.EREDSYS_PUZZLE or data.redsys == SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK or data.redsys == SceneTip_pb.EREDSYS_MANOR_PARTNER_STORY then
      self:RemoveRedTip(data.redsys)
    end
    self:UpdateRedTip(data.redsys, data.tipid)
  elseif data.optItem == SceneTip_pb.ETIPITEMOPT_DELETE then
    self:RemoveRedTip(data.redsys, data.tipid)
  end
end

function RedTipProxy:UpdateRedTip(id, paramIds)
  if self:InRedTip(id) then
    local tip = self:GetOrCreateRedTip(id)
    tip:AddParams(paramIds)
    GameFacade.Instance:sendNotification(RedTipProxy.UpdateParamEvent, {id = id, paramIds = paramIds})
    return
  end
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  tip:SetEnable(true)
  tip:AddParams(paramIds)
  GameFacade.Instance:sendNotification(RedTipProxy.UpdateRedTipEvent, {id = id, paramIds = paramIds})
end

function RedTipProxy:RemoveRedTip(id, paramIds)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  if tip then
    tip:RemoveParams(paramIds)
  end
end

function RedTipProxy:AddRedTipParam(id, paramId)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  if not tip.enable then
    tip:SetEnable(true)
    GameFacade.Instance:sendNotification(RedTipProxy.UpdateRedTipEvent, {
      id = id,
      paramIds = {paramId}
    })
  end
  tip:AddParam(paramId)
  GameFacade.Instance:sendNotification(RedTipProxy.UpdateParamEvent, {
    id = id,
    paramIds = {paramId}
  })
end

function RedTipProxy:RemoveRedTipParam(id, paramId)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  if tip then
    tip:RemoveParam(paramId)
    if not tip:HasParamID() then
      tip:SetEnable(false)
      GameFacade.Instance:sendNotification(RedTipProxy.RemoveRedTipEvent, {id = id})
    end
  end
end

function RedTipProxy:RegisterUIs(id, uis)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  for i = 1, #uis do
    local uiData = self.uis[uis[i]]
    if not uiData then
      uiData = {
        ui = uis[i],
        red = nil,
        check = ConditionCheck.new()
      }
      self.uis[ui] = uiData
    end
    uiData.check:SetReason(id)
    tip:RegisterUI(uiData)
  end
end

function RedTipProxy:RegisterUIByGroupID(groupID, ui, depth, offset, side)
  local groupIDs = self.groupIDs[groupID]
  if groupIDs then
    for i = 1, #groupIDs do
      self:RegisterUI(groupIDs[i], ui, depth, offset, side)
    end
  end
end

function RedTipProxy:UnRegisterUIByGroupID(groupID, ui)
  local groupIDs = self.groupIDs[groupID]
  if groupIDs then
    for i = 1, #groupIDs do
      self:UnRegisterUI(groupIDs[i], ui)
    end
  end
end

function RedTipProxy:GetRedTipIdsByGroupId(groupID)
  local groupIDs = self.groupIDs[groupID]
  if groupIDs then
    local result = {}
    for i = 1, #groupIDs do
      result[#result + 1] = groupIDs[i]
    end
    return result
  end
end

function RedTipProxy:RegisterUI(id, ui, depth, offset, side, subtipid)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  local uiData = self.uis[ui]
  if not uiData then
    uiData = {
      ui = ui,
      red = nil,
      check = ConditionCheck.new(),
      depth = depth,
      subtipid = subtipid
    }
    self.uis[ui] = uiData
  end
  uiData.offset = offset or {-10, -10}
  uiData.side = side or NGUIUtil.AnchorSide.TopRight
  tip:RegisterUI(uiData)
end

function RedTipProxy:UnRegisterUIs(id, uis)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  for i = 1, #uis do
    tip:UnRegisterUI(uis[i])
    self.uis[uis[i]] = nil
  end
end

function RedTipProxy:UnRegisterUI(id, ui)
  if Table_RedTip[id] == nil then
    return
  end
  local tip = self:GetOrCreateRedTip(id)
  tip:UnRegisterUI(ui)
  self.uis[ui] = nil
end

function RedTipProxy:TestPrint()
  local count = 0
  for k, v in pairs(self.uis) do
    count = count + 1
  end
end

function RedTipProxy:ReCalcUIRedPos(ui)
  local uiData = self.uis[ui]
  if uiData and uiData.red then
    local pos = NGUIUtil.GetAnchorPoint(uiData.red, ui, uiData.side, uiData.offset)
    uiData.red.transform.position = pos
  end
end

RedTip = class("RedTip", EventDispatcher)
RedTip.resID = ResourcePathHelper.UICell("RedTipCell")

function RedTip:ctor(id, params)
  self.enable = false
  self.id = id
  self.config = Table_RedTip[id]
  self.params = {}
  self.uis = {}
  self:AddParams(params)
end

function RedTip:SetEnable(value)
  if self.enable ~= value then
    self.enable = value
    if self.enable then
      self:AddReds()
    else
      self:RemoveReds()
    end
  end
end

function RedTip:AddRed(uiData)
  if self.config and self.config.MenuID and not FunctionUnLockFunc.Me():CheckCanOpen(self.config.MenuID) then
    self.isBlockByMenu = true
    return
  end
  if uiData.subtipid and not self:HasParam(uiData.subtipid) then
    return
  end
  self.isBlockByMenu = false
  uiData.check:SetReason(self.id)
  if uiData.red == nil or Game.GameObjectUtil:ObjectIsNULL(uiData.red) then
    uiData.red = Game.AssetManager_UI:CreateAsset(RedTip.resID, uiData.ui.gameObject):GetComponent(UISprite)
    uiData.red.name = self.id
    UIUtil.ChangeLayer(uiData.red, uiData.ui.gameObject.layer)
    local parentSP = uiData.ui.gameObject:GetComponent(UIWidget)
    if parentSP then
      local pos = NGUIUtil.GetAnchorPoint(uiData.red, parentSP, uiData.side, uiData.offset)
      uiData.red.transform.position = pos
      uiData.red.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
      uiData.red.depth = uiData.depth or parentSP.depth + 10
    else
      error("红点提示，请传入uiwidget的游戏父物体")
    end
  end
end

function RedTip:AddReds()
  for k, v in pairs(self.uis) do
    if not Game.GameObjectUtil:ObjectIsNULL(k) then
      self:AddRed(v)
    else
      RedTipProxy.Instance.uis[k] = nil
      self.uis[k] = nil
    end
  end
end

function RedTip:RemoveRed(uiData)
  if uiData and uiData.red and not Game.GameObjectUtil:ObjectIsNULL(uiData.red) then
    uiData.check:RemoveReason(self.id)
    if uiData.check:HasReason() == false then
      Game.GOLuaPoolManager:AddToUIPool(RedTip.resID, uiData.red.gameObject)
      uiData.red = nil
    end
  end
end

function RedTip:RemoveReds()
  for k, v in pairs(self.uis) do
    if not Game.GameObjectUtil:ObjectIsNULL(k) then
      self:RemoveRed(v)
    else
      RedTipProxy.Instance.uis[k] = nil
      self.uis[k] = nil
    end
  end
end

function RedTip:RegisterUI(uiData)
  self.uis[uiData.ui] = uiData
  if self.enable then
    self:AddRed(uiData)
  end
end

function RedTip:UnRegisterUI(ui)
  local uiData = self.uis[ui]
  if not uiData or not ui then
    return
  end
  self:RemoveRed(uiData)
  self.uis[ui] = nil
end

function RedTip:ChangeRedDepth(ui, _depth)
  local uiData = self.uis[ui]
  if uiData and uiData.red then
    uiData.red.depth = _depth
  end
end

function RedTip:AddParams(params)
  if params then
    TableUtility.TableClear(self.params)
    for i = 1, #params do
      self.params[params[i]] = 1
    end
  end
  self:UpdateUIDatas()
end

function RedTip:AddParam(paramId)
  if paramId then
    self.params[paramId] = 1
  end
  self:UpdateUIDatas()
end

function RedTip:RemoveParam(paramId)
  if paramId then
    self.params[paramId] = nil
  end
  self:UpdateUIDatas()
end

function RedTip:RemoveParams(params)
  if params then
    for i = 1, #params do
      self.params[params[i]] = nil
    end
  elseif self.params then
    for k, v in pairs(self.params) do
      self.params[k] = nil
    end
  end
  self:UpdateUIDatas()
end

function RedTip:UpdateUIDatas()
  for uiObj, uiData in pairs(self.uis) do
    if not Game.GameObjectUtil:ObjectIsNULL(uiObj) then
      if uiData.subtipid then
        if self:HasParam(uiData.subtipid) then
          self:AddRed(uiData)
        else
          self:RemoveRed(uiData)
        end
      end
    else
      RedTipProxy.Instance.uis[uiObj] = nil
      self.uis[uiObj] = nil
    end
  end
end

function RedTip:HasParam(id)
  return self.params[id] ~= nil
end

function RedTip:GetParams()
  return self.params
end

function RedTip:HasParamID()
  return nil ~= self.params and nil ~= next(self.params)
end

function RedTip:TestPrint()
  local count = 0
  for k, v in pairs(self.uis) do
    count = count + 1
  end
end
