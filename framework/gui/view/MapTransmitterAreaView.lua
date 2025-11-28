autoImport("MapTransmitterButton")
MapTransmitterAreaView = class("MapTransmitterAreaView", ContainerView)
MapTransmitterAreaView.ViewType = UIViewType.NormalLayer
MapTransmitterAreaView.colorLabTransmitActive = LuaColor(0, 0.10588235294117647, 0.35294117647058826, 1)

function MapTransmitterAreaView:Init()
  self.transmitterButtons = {}
  self.mapsize = {}
  self.objMapIndicates = {}
  self.objMiniMapSymbols = {}
  self:FindObjs()
  self:AddEvts()
  self:LoadView()
end

function MapTransmitterAreaView:FindObjs()
  self.labTutorial = self:FindComponent("labTutorial", UILabel)
  self.labNpcName = self:FindComponent("NPCName", UILabel)
  self.texMap = self:FindComponent("texMap", UITexture)
  self.objTransmitterDetail = self:FindGO("TransmitterDetail")
  self.labtarMapName = self:FindComponent("labMapName", UILabel, self.objTransmitterDetail)
  self.labTarTransmitterName = self:FindComponent("labTransmitterName", UILabel, self.objTransmitterDetail)
  self.sprTarTransmitterIcon = self:FindComponent("sprTransmitterIcon", UISprite, self.objTransmitterDetail)
  self.labCannotTransmitTip = self:FindComponent("labCannotTransmitTip", UILabel, self.objTransmitterDetail)
  self.objBtnTransmit = self:FindGO("btnTransmit")
  self.colBtnTransmit = self.objBtnTransmit:GetComponent(Collider)
  self.sprBtnTransmit = self.objBtnTransmit:GetComponent(UISprite)
  self.labBtnTransmit = self:FindComponent("Label", UILabel, self.objBtnTransmit)
  self.objCurrent = self:FindGO("CurrentPos", self.objTransmitterDetail)
  self.objHelpPopUp = self:FindGO("HelpPopUp")
end

function MapTransmitterAreaView:AddEvts()
  self:AddClickEvent(self.objBtnTransmit, function()
    self:ClickTransmit()
  end)
  self:AddClickEvent(self:FindGO("btnClose"), function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("btnHelp"), function()
    self:ClickHelp()
  end)
  self:AddClickEvent(self:FindGO("btnClose", self.objHelpPopUp), function()
    self:CloseHelp()
  end)
  self:AddClickEvent(self:FindGO("Mask", self.objHelpPopUp), function()
    self:CloseHelp()
  end)
end

function MapTransmitterAreaView:LoadView()
  local viewData = self.viewdata.viewdata
  self.curNpcID = viewData.npcID
  self.curMapID = Game.MapManager:GetMapID()
  self.tarMapID = viewData.selectID
  self.isSameMap = self.curMapID == self.tarMapID
  self.curMapGroup = viewData.mapGroup
  local curNpcData = Table_Npc[self.curNpcID]
  if curNpcData then
    self.labTutorial.text = DialogUtil.GetDialogData(curNpcData.DefaultDialog).Text
    self.labNpcName.text = curNpcData.NameZh
  end
  local mapData = Table_Map[self.tarMapID]
  self.curMapName = mapData.NameZh
  self.labtarMapName.text = mapData.NameZh
  PictureManager.Instance:SetMiniMap("Scene" .. mapData.NameEn, self.texMap)
  self.mapsize.x = self.texMap.width
  self.mapsize.y = self.texMap.height
  local fName = "Scene_" .. mapData.NameEn
  local sceneInfo = autoImport(fName)
  ClearTableFromG(fName)
  local mapInfo = sceneInfo.MapInfo
  mapInfo = mapInfo.MinPos and mapInfo or mapInfo[0]
  self.sceneSize = mapInfo.Size
  self.sceneMinPos = mapInfo.MinPos
  self:CreateExitPoints()
  self:CreateQuestFocus()
  local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.EffectUI(EffectMap.UI.MapIndicates), self:FindGO("tsfTargetPointIconRoot").transform)
  local sps = UIUtil.GetAllComponentsInChildren(obj, UITexture)
  for i = 1, #sps do
    sps[i].depth = 4 + sps[i].depth % 10
  end
  obj.name = "TargetPointEffect"
  obj:SetActive(true)
  self.objMapIndicates[#self.objMapIndicates + 1] = obj
  local curIsMainTransfer, isAllActivated = false, true
  local activePoints = WorldMapProxy.Instance.activeTransmitterPoints
  local transferPoint, transferID, found
  local mapDatas = WorldMapProxy.Instance:GetTransmitterMapByGroup(self.curMapGroup)
  for mapID, transfers in pairs(mapDatas) do
    if not self.isSameMap or mapID == self.curMapID then
      for i = 1, #transfers do
        transferPoint = transfers[i]
        transferID = transferPoint.id
        if activePoints[transferID] ~= 1 then
          isAllActivated = false
          if found then
            break
          end
        end
        if tostring(transferPoint.NpcID) == tostring(self.curNpcID) then
          self.curTransferID = transferID
          curIsMainTransfer = transferPoint.NpcType == 0
          found = true
          if mapID ~= self.curMapID then
            LogUtility.Warning("Table_DeathTransferMap中的MapID(%s)和当前MapID(%s)不一致！", tostring(mapID), tostring(self.curMapID))
          end
          if not isAllActivated then
            break
          end
        end
      end
    end
  end
  if not found then
    LogUtility.Error("Cannot Find Transmitter NPC: %s", tostring(self.curNpcID))
    return
  end
  local cellState, tarIsMainTransfer, buttonData, button
  for mapID, transfers in pairs(mapDatas) do
    if mapID == self.tarMapID then
      for i = 1, #transfers do
        transferPoint = transfers[i]
        transferID = transferPoint.id
        tarIsMainTransfer = transferPoint.NpcType == 0
        if activePoints[transferID] == 1 then
          if isAllActivated or self.isSameMap and (curIsMainTransfer or tarIsMainTransfer) or not self.isSameMap and curIsMainTransfer and tarIsMainTransfer then
            cellState = MapTransmitterButton.E_State.Activated
          else
            cellState = MapTransmitterButton.E_State.Disable
          end
        else
          cellState = MapTransmitterButton.E_State.Unactivated
        end
        buttonData = {
          staticdata = transferPoint,
          isCurrent = self.curTransferID == transferID,
          state = cellState
        }
        button = self:CreateTransmitterButton()
        button.trans.localPosition = self:ScenePosToMap(transferPoint.Position)
        button:SetData(buttonData)
        self.transmitterButtons[#self.transmitterButtons + 1] = button
        if self.isSameMap then
          if self.curTransferID == transferID then
            self:ClickTransmitterButton(button)
          end
        elseif tarIsMainTransfer then
          self:ClickTransmitterButton(button)
        end
      end
      break
    end
  end
  if not self.curButton and 0 < #self.transmitterButtons then
    self:ClickTransmitterButton(self.transmitterButtons[1])
  end
end

function MapTransmitterAreaView:CreateTransmitterButton()
  local button = MapTransmitterButton.new(Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("MapTransmitterButton")))
  button.name = tostring(npcID)
  button.trans:SetParent(self.texMap.transform, false)
  button:AddEventListener(MouseEvent.MouseClick, self.ClickTransmitterButton, self)
  return button
end

function MapTransmitterAreaView:CreateExitPoints()
  if self.isSameMap then
  end
  local exitList = Game.MapManager:GetExitPointArray(self.tarMapID)
  if not exitList then
    return
  end
  local table_Map = Table_Map
  for i = 1, #exitList do
    local v = exitList[i]
    if v and v.ID and v.position then
      local exitData = MiniMapData.CreateAsTable(v.ID, v.position, parama)
      exitData:SetPos(v.position[1], v.position[2], v.position[3])
      local active = Game.AreaTrigger_ExitPoint:IsInvisible(v.ID) == false
      exitData:SetParama("active", active)
      if v.nextSceneID == 0 then
        exitData:SetParama("active", false)
      elseif v.nextSceneID ~= nil then
        exitData:SetParama("nextSceneID", v.nextSceneID)
        local nextMapData = table_Map[v.nextSceneID]
        exitData:SetParama("Symbol", nextMapData and nextMapData.IsDangerous and "map_gateway1" or "map_gateway")
      end
      self:CreateExitPointObj(exitData)
    end
  end
end

function MapTransmitterAreaView:CreateExitPointObj(data)
  local symbolObj = Game.AssetManager_UI:CreateAsset(MiniMapWindow.MiniMapSymbolPath, self.texMap.transform)
  if self:ObjIsNil(symbolObj) then
    LogUtility.Error("Create Exit Point Failed")
    return
  end
  local sprite = symbolObj:GetComponent(UISprite)
  IconManager:SetMapIcon(data:GetParama("Symbol"), sprite)
  sprite:MakePixelPerfect()
  sprite.depth = 4
  symbolObj.gameObject:SetActive(data:GetParama("active"))
  symbolObj.transform.localPosition = self:ScenePosToMap(data.pos)
  self.objMiniMapSymbols[#self.objMiniMapSymbols + 1] = symbolObj
end

function MapTransmitterAreaView:CreateQuestFocus()
  if not self.isSameMap then
    return
  end
  local datas = WorldMapProxy.Instance:GetCurQuestPosDatas()
  local obj, sps
  local path = ResourcePathHelper.EffectUI(EffectMap.UI.MapIndicates)
  for questId, pos in pairs(datas) do
    obj = Game.AssetManager_UI:CreateAsset(path, self.texMap.transform)
    sps = UIUtil.GetAllComponentsInChildren(obj, UITexture)
    for i = 1, #sps do
      sps[i].depth = 5 + sps[i].depth % 10
    end
    obj.name = tostring(questId)
    obj:SetActive(true)
    obj.transform.localPosition = self:ScenePosToMap(pos)
    self.objMapIndicates[#self.objMapIndicates + 1] = obj
  end
end

local scenePos_mapPos = LuaVector3.Zero()

function MapTransmitterAreaView:ScenePosToMap(pos)
  local mapPct = math.clamp((pos[1] - self.sceneMinPos.x) / self.sceneSize.x, 0, 1)
  scenePos_mapPos[1] = mapPct * self.mapsize.x - self.mapsize.x / 2
  mapPct = math.clamp((pos[3] - self.sceneMinPos.y) / self.sceneSize.y, 0, 1)
  scenePos_mapPos[2] = mapPct * self.mapsize.y - self.mapsize.y / 2
  return scenePos_mapPos
end

function MapTransmitterAreaView:Sort(x, y)
  if x == nil then
    return true
  elseif y == nil then
    return false
  else
    return x.id < y.id
  end
end

function MapTransmitterAreaView:ClickTransmitterButton(button)
  if self.curButton then
    self.curButton:Select(false)
  end
  self.curButton = button
  self.curButton:Select(true)
  local config = GameConfig.Transmitter[self.curMapGroup]
  self.labTarTransmitterName.text = button.npcName
  if config then
    IconManager:SetMapIcon(button.isMain and config.IconBig or config.IconSmall, self.sprTarTransmitterIcon)
  end
  self.objBtnTransmit:SetActive(not button.isCurrent)
  self.objCurrent:SetActive(button.isCurrent)
  if not button.isCurrent then
    self.colBtnTransmit.enabled = button.state == MapTransmitterButton.E_State.Activated
    if button.state == MapTransmitterButton.E_State.Activated then
      self:SetTextureWhite(self.sprBtnTransmit)
      self.labBtnTransmit.effectColor = MapTransmitterAreaView.colorLabTransmitActive
    else
      self:SetTextureGrey(self.sprBtnTransmit)
      self.labBtnTransmit.effectColor = Color.gray
    end
  end
  if button.state == MapTransmitterButton.E_State.Unactivated then
    self.labTarTransmitterName.color = Color.gray
    self:SetTextureGrey(self.sprTarTransmitterIcon)
    if config then
      self.labCannotTransmitTip.text = string.format(ZhString.MapTransmmiter_UnactivatedTip, button.isMain and config.MainTransmitter or config.SubTransmitter)
    else
      self.labCannotTransmitTip.text = ""
    end
  else
    self.labTarTransmitterName.color = Color.white
    self:SetTextureWhite(self.sprTarTransmitterIcon)
    if button.state == MapTransmitterButton.E_State.Disable and not button.isCurrent then
      self.labCannotTransmitTip.text = string.format(ZhString.MapTransmmiter_DisableTip, self.curMapName, tostring(config and config.TransmitterType))
    else
      self.labCannotTransmitTip.text = ""
    end
  end
end

function MapTransmitterAreaView:ClickTransmit()
  if not self.curButton or self.curButton.state ~= MapTransmitterButton.E_State.Activated or self.curButton.isCurrent then
    return
  end
  ServiceNUserProxy.Instance:CallUseDeathTransferCmd(self.curTransferID, self.curButton.id)
  self:CloseSelf()
end

function MapTransmitterAreaView:ClickHelp()
  self.isHelpShow = true
  self.objHelpPopUp:SetActive(true)
end

function MapTransmitterAreaView:CloseHelp()
  self.isHelpShow = false
  self.objHelpPopUp:SetActive(false)
end

function MapTransmitterAreaView:RecycleUI()
  local path = ResourcePathHelper.EffectUI(EffectMap.UI.MapIndicates)
  for i = 1, #self.objMapIndicates do
    if not Slua.IsNull(self.objMapIndicates[i]) then
      Game.GOLuaPoolManager:AddToUIPool(path, self.objMapIndicates[i])
    end
  end
  TableUtility.TableClear(self.objMapIndicates)
  path = MiniMapWindow.MiniMapSymbolPath
  for i = 1, #self.objMiniMapSymbols do
    if not Slua.IsNull(self.objMiniMapSymbols[i]) then
      Game.GOLuaPoolManager:AddToUIPool(path, self.objMiniMapSymbols[i])
    end
  end
  TableUtility.TableClear(self.objMiniMapSymbols)
end

function MapTransmitterAreaView:OnEnter()
  MapTransmitterAreaView.super.OnEnter(self)
end

function MapTransmitterAreaView:OnExit()
  local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), self.curNpcID)
  if npc then
    npc.assetRole:PlayAction_Simple(GameConfig.Transmitter.ExitAnimName)
  end
  self:RecycleUI()
  PictureManager.Instance:UnLoadMiniMap()
  MapTransmitterAreaView.super.OnExit(self)
end
