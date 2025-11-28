autoImport("UIMapMapListCell")
autoImport("UITeleportAreaCell")
autoImport("UITeleportWorldCell")
autoImport("UIListItemViewControllerTransmitTeammate")
autoImport("UIModelKaplaTransmit")
UIMapMapList = class("UIMapMapList", ContainerView)
UIMapMapList.ViewType = UIViewType.NormalLayer
local vec3 = LuaVector3.New(0, 0, 0)
local gReusableArray = {}
local SortAreaFunc = function(l, r)
  if l.sortId == r.sortId then
    return l.id < r.id
  else
    return l.sortId < r.sortId
  end
end
UIMapMapList.E_TransmitType = {Single = 0, Team = 1}
UIMapMapList.transmitType = nil
UIMapMapList.AutoChoose = nil

function UIMapMapList:Init()
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
  self.listCtrl = UIGridListCtrl.new(self.uiGrid, UIMapMapListCell, "UIMapAreaListCell")
  self.teammateListCtrl = UIGridListCtrl.new(self.teammateUIGrid, UIListItemViewControllerTransmitTeammate, "UIListItemTransmitTeammate")
  self.areaListCtrl = UIGridListCtrl.new(self.areaGrid, UITeleportAreaCell, "UITeleportAreaCell")
  self.areaListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickAreaCell, self)
  self.worldListCtrl = UIGridListCtrl.new(self.worldGrid, UITeleportWorldCell, "UITeleportWorldCell")
  self.worldListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickWorldCell, self)
  self:InitData()
  self:LoadView(true)
  self:ListenTeamEvent()
  self:ListenServer()
  self:ListenCustomEvent()
end

function UIMapMapList:GetGameObjects()
  self.transScrollList = self:FindGO("ScrollList").transform
  self.transRoot = self:FindGO("Root", self.transScrollList.gameObject).transform
  self.uiGrid = self.transRoot.gameObject:GetComponent(UIGrid)
  self.goMyTeam = self:FindGO("MyTeam")
  self.goTeammateScrollList = self:FindGO("ScrollList", self.goMyTeam)
  self.goTeammateRoot = self:FindGO("Root", self.goTeammateScrollList)
  self.teammateUIGrid = self.goTeammateRoot:GetComponent(UIGrid)
  self.goBTNInviteFollow = self:FindGO("BTN_InviteFollow", self.goMyTeam)
  self.goTutorial = self:FindGO("Tutorial")
  self.goTutorialLab = self:FindGO("Lab", self.goTutorial)
  self.labTutorial = self.goTutorialLab:GetComponent(UILabel)
  self.labNpcName = self:FindComponent("NPCName", UILabel)
  self.goNoListItem = self:FindGO("NoListItem", self.goTeammateScrollList)
  self.left_scrollView = self:FindGO("Scroll View", self:FindGO("ScrollList_Left")):GetComponent(UIScrollView)
  self.areaGrid = self:FindGO("areaGrid"):GetComponent(UIGrid)
  self.worldGrid = self:FindGO("worldGrid"):GetComponent(UIGrid)
  self.Purikura = self:FindGO("Purikura")
  if self.Purikura then
    self.Purikura_UITexture = self.Purikura:GetComponent(UITexture)
  end
  self.area_scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
end

function UIMapMapList:InitData()
  self.mapsInfo = {}
  self.worldMaps = {}
  self.activeAreas = {}
  self.curWorld = 1
  local viewdata = self.viewdata and self.viewdata.viewdata
  local npc = viewdata and viewdata.npcdata
  self.purikuraTexture = npc and npc.data.staticData.Purikura or ""
  self.npcName = npc and npc.data.name
  self:InitAreaList()
end

function UIMapMapList:RegisterButtonClickEvent()
  self:AddClickEvent(self.goBTNInviteFollow, function(go)
    self:OnClickForButtonInviteFollow(go)
  end)
  local closeButton = self:FindGO("CloseButton")
  self:AddClickEvent(closeButton, function()
    self:CloseSelf()
  end)
end

function UIMapMapList:ClickAreaCell(cell)
  if self.curCell ~= cell then
    if self.curCell then
      self.curCell:SetChoose(false)
    end
    self.curCell = cell
    self.curCell:SetChoose(true)
  else
    self.curCell = cell
    self.curCell:SetChoose(true)
  end
  self:GetModelSet()
  self.listCtrl:ResetDatas(self.mapsInfo)
  self.area_scrollView:ResetPosition()
end

function UIMapMapList:ClickWorldCell(cell)
  if self.curWorld == cell.data.id then
    return
  end
  if self.curWorldCell ~= cell then
    if self.curWorldCell then
      self.curWorldCell:SetChoose(false)
    end
    self.curWorldCell = cell
    self.curWorldCell:SetChoose(true)
  else
    self.curWorldCell = cell
  end
  self.curWorld = cell.data.id
  local targetList = self.activeAreas[self.curWorld]
  table.sort(targetList, function(x, y)
    return SortAreaFunc(x, y)
  end)
  self.curCell = nil
  self.areaListCtrl:ResetDatas(targetList)
  self.left_scrollView:ResetPosition()
  local cells = self.areaListCtrl:GetCells()
  local foundSuc = false
  if UIMapMapList.AutoChoose then
    for i = 1, #cells do
      local lvRange = cells[i].data.LvRange
      if lvRange and lvRange[UIMapMapList.AutoChoose] then
        self:ClickAreaCell(cells[i])
        TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
          local panel = self.left_scrollView.panel
          local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.curCell.gameObject.transform)
          local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
          offset = Vector3(0, offset.y, 0)
          self.left_scrollView:MoveRelative(offset)
        end, self, 1)
        foundSuc = true
        break
      end
    end
  end
  if not foundSuc then
    self:ClickAreaCell(cells[1])
  end
end

function UIMapMapList:GetWorldMapList()
  local worldList = GameConfig.WorldMapArea
  if worldList then
    TableUtility.ArrayClear(self.worldMaps)
    for _, v in pairs(worldList) do
      if self:GetWorldTeleportAvailable(v.id) then
        table.insert(self.worldMaps, v)
      end
    end
    table.sort(self.worldMaps, function(x, y)
      return self:Sort(x, y)
    end)
  else
    redlog("GameConfig中未添加世界大陆")
  end
end

function UIMapMapList:GetWorldTeleportAvailable(id)
  local activeMaps = WorldMapProxy.Instance.activeMaps
  for mapid, _ in pairs(activeMaps) do
    local mapInfo = Table_Map[mapid]
    if mapInfo then
      local worldID = mapInfo.World or 1
      if worldID == id and mapInfo.MoneyType ~= 2 then
        redlog("当前世界ID" .. id .. "激活传送")
        return true
      end
    end
  end
  redlog("当前世界ID" .. id .. "未激活传送")
  return false
end

function UIMapMapList:GetAreaList()
  TableUtility.ArrayClear(self.activeAreas)
  local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
  local activeMaps = WorldMapProxy.Instance.activeMaps
  for mapid, _ in pairs(activeMaps) do
    local mapInfo = Table_Map[mapid]
    local worldID = mapInfo and mapInfo.World or 1
    if mapInfo and worldID == self.curWorld then
      local couldTransmit = mapInfo.MoneyType ~= 2 or amIMonthlyVIP
      if couldTransmit then
        local areaID = mapInfo.Range
        if areaID ~= nil and not self:AlreadyInitedArea(areaID) then
          local areaInfo = Table_ItemType[areaID]
          local text = areaInfo and string.format(ZhString.CapraTransmission_Area, areaInfo.Name) or ""
          table.insert(self.activeAreas, {id = areaID, name = text})
        end
      end
    end
  end
end

function UIMapMapList:InitAreaList()
  local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
  local activeMaps = WorldMapProxy.Instance.activeMaps
  if not Table_MapTransport then
    return
  end
  for i = 1, #Table_MapTransport do
    local single = Table_MapTransport[i]
    local areaValid = false
    local targetWorld = 1
    local areaData = {
      id = single.id,
      name = single.ZoneName
    }
    local top_lv = single.StickTopLevel
    if top_lv and top_lv < MyselfProxy.Instance:RoleLevel() then
      areaData.sortId = 0
    else
      areaData.sortId = single.id
    end
    local mapIDs = single.MapID
    if mapIDs and 0 < #mapIDs then
      for j = 1, #mapIDs do
        local mapID = mapIDs[j]
        local mapInfo = Table_Map[mapID]
        if mapInfo then
          targetWorld = mapInfo and mapInfo.World or 1
          if not self.activeAreas[targetWorld] then
            self.activeAreas[targetWorld] = {}
          end
          local mapActive = activeMaps[mapID]
          local couldTransmit = mapInfo and mapInfo.MoneyType ~= 2 or amIMonthlyVIP
          if mapActive and couldTransmit then
            areaValid = true
          end
          local levelRange = mapInfo.LvRange
          if levelRange[1] and levelRange[2] then
            if not areaData.LvRange then
              areaData.LvRange = {}
            end
            for i = levelRange[1], levelRange[2] do
              if not areaData.LvRange[i] then
                areaData.LvRange[i] = 1
              end
            end
          end
        else
          redlog("Map表缺少地图ID", mapID)
        end
      end
    end
    if areaValid then
      table.insert(self.activeAreas[targetWorld], areaData)
    end
  end
end

function UIMapMapList:GetModelSet()
  TableUtility.ArrayClear(self.mapsInfo)
  self.areaID = self.curCell and self.curCell.data.id or 1
  local amIMonthlyVIP = NewRechargeProxy.Ins:AmIMonthlyVIP()
  local transportConfig = Table_MapTransport[self.areaID]
  local mapIDs = transportConfig and transportConfig.MapID
  if mapIDs and 0 < #mapIDs then
    for i = 1, #mapIDs do
      local mapInfo = Table_Map[mapIDs[i]]
      if mapInfo.Money and not self:IsMapBannedByFuncState(mapIDs[i]) then
        local couldTransmit = mapInfo.MoneyType ~= 2 or amIMonthlyVIP
        if couldTransmit then
          table.insert(self.mapsInfo, mapInfo)
        end
      end
    end
  end
  self.teammatesID = UIModelKaplaTransmit.Ins():GetTeammates()
end

function UIMapMapList:LoadView(init)
  self:ShowNpcPurikura()
  self:GetWorldMapList()
  self.worldListCtrl:ResetDatas(self.worldMaps)
  local worldCells = self.worldListCtrl:GetCells()
  local curMapWorldID = Game.MapManager:GetWorldID()
  self.curWorld = curMapWorldID
  if worldCells[curMapWorldID] then
    worldCells[curMapWorldID]:SetChoose(true)
  else
    worldCells[1]:SetChoose(true)
    self.curWorld = 1
  end
  self.curWorldCell = worldCells[curMapWorldID]
  local targetAreaList = self.activeAreas[self.curWorld]
  table.sort(targetAreaList, function(x, y)
    return SortAreaFunc(x, y)
  end)
  self.areaListCtrl:ResetDatas(targetAreaList)
  if init then
    self.areaListCtrl:ResetPosition()
  end
  local cells = self.areaListCtrl:GetCells()
  local foundSuc = false
  if UIMapMapList.AutoChoose then
    local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
    for i = 1, #cells do
      local lvRange = cells[i].data.LvRange
      if lvRange and lvRange[UIMapMapList.AutoChoose] then
        self:ClickAreaCell(cells[i])
        foundSuc = true
        TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
          local panel = self.left_scrollView.panel
          local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, self.curCell.gameObject.transform)
          local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
          offset = Vector3(0, offset.y, 0)
          self.left_scrollView:MoveRelative(offset)
        end, self, 1)
        break
      end
    end
  elseif init then
    TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      self.areaListCtrl:ResetPosition()
    end, self, 1)
  end
  if not foundSuc then
    self:ClickAreaCell(cells[1])
  end
  self:GetModelSet()
  self.listCtrl:ResetDatas(self.mapsInfo)
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
    self:TransmitLayout()
  elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    self:TeamTransmitLayout()
  end
  self.teammateListCtrl:ResetDatas(self.teammatesID)
  self.goNoListItem:SetActive(not self.teammatesID or 1 > #self.teammatesID)
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Single then
    local handInHandPlayerID = UIModelKaplaTransmit.Ins():GetHandInHandPlayerID_Teammate_NotCat()
    if handInHandPlayerID ~= nil then
      local handInHandPlayer = UIModelKaplaTransmit.Ins():GetTeammateDetail(handInHandPlayerID)
      local handInHandPlayerName = handInHandPlayer and handInHandPlayer.name or ""
      self.labTutorial.text = string.format(ZhString.kaplaTransmit_HandInHandTransmitTutorial, handInHandPlayerName)
    else
      self.labTutorial.text = ZhString.KaplaTransmit_SelectTransmitDestination
    end
  elseif UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    self.labTutorial.text = ZhString.KaplaTransmit_TeammateTransmitTutorial
  end
end

function UIMapMapList:OnButtonBackClick(go)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.UIMapAreaList,
    viewdata = self.viewdata.viewdata.areaViewData
  })
end

function UIMapMapList:OnClickForButtonInviteFollow(go)
  if UIModelKaplaTransmit.Ins():AmITeamLeader() then
    self:RequestInviteTeammateFollow()
  else
    MsgManager.ShowMsgByID(351)
  end
end

function UIMapMapList:Sort(x, y)
  if x == nil then
    return true
  elseif y == nil then
    return false
  else
    return x.id < y.id
  end
end

function UIMapMapList:TeamTransmitLayout()
  local localPos = self.transScrollList.localPosition
  LuaVector3.Better_Set(vec3, 427, localPos.y, localPos.z)
  self.transScrollList.localPosition = vec3
  localPos = self.goTeammateScrollList.transform.localPosition
  LuaVector3.Better_Set(vec3, 275, localPos.y, localPos.z)
  self.goTeammateScrollList.transform.localPosition = vec3
end

function UIMapMapList:TransmitLayout()
  local localPos = self.transScrollList.localPosition
  if self.purikuraTexture ~= "" then
    LuaVector3.Better_Set(vec3, 427, localPos.y, localPos.z)
  else
    LuaVector3.Better_Set(vec3, 271, localPos.y, localPos.z)
  end
  self.transScrollList.localPosition = vec3
  self.goMyTeam:SetActive(false)
end

function UIMapMapList:ListenCustomEvent()
  self:AddListenEvt("UIMapMapList.CloseSelf", function()
    self:CloseSelf()
  end)
  self:AddDispatcherEvt(FunctionFollowCaptainEvent.StateChanged, self.OnReceiveFunctionFollowCaptainEventStateChanged)
end

function UIMapMapList:ListenTeamEvent()
  self:AddListenEvt(TeamEvent.MemberEnterTeam, self.OnReceiveMemberEnterTeam)
  self:AddListenEvt(TeamEvent.MemberExitTeam, self.OnReceiveMemberExitTeam)
  self:AddListenEvt(TeamEvent.MemberOffline, self.OnReceiveMemberOffline)
  self:AddListenEvt(TeamEvent.MemberOnline, self.OnReceiveMemberOnline)
end

function UIMapMapList:ListenServer()
  self:AddListenEvt(ServiceEvent.NUserBeFollowUserCmd, self.OnReceiveBeFollowed)
end

function UIMapMapList:OnReceiveMemberEnterTeam()
  self:RefreshTeammateList()
end

function UIMapMapList:OnReceiveMemberExitTeam()
  self:RefreshTeammateList()
end

function UIMapMapList:OnReceiveMemberOffline()
  self:RefreshTeammateList()
end

function UIMapMapList:OnReceiveMemberOnline()
  self:RefreshTeammateList()
end

function UIMapMapList:OnReceiveBeFollowed()
  self:RefreshTeammateList()
end

function UIMapMapList:OnReceiveFunctionFollowCaptainEventStateChanged()
  self:Refresh()
end

function UIMapMapList:RefreshTeammateList()
  self:GetModelSet()
  self.teammateListCtrl:ResetDatas(self.teammatesID)
  self.goNoListItem:SetActive(not self.teammatesID or #self.teammatesID < 1)
end

function UIMapMapList:RequestInviteTeammateFollow()
  if UIMapMapList.transmitType == UIMapMapList.E_TransmitType.Team then
    FunctionTeam.Me():InviteMemberFollow()
  end
end

function UIMapMapList:Refresh()
  self:GetModelSet()
  self:LoadView()
end

function UIMapMapList:ShowNpcPurikura()
  if self.npcName and self.labNpcName then
    self.labNpcName.text = self.npcName
  end
  if self.purikuraTexture and self.purikuraTexture ~= "" then
    PictureManager.Instance:SetNPCLiHui(self.purikuraTexture, self.Purikura_UITexture)
  end
end

function UIMapMapList:OnExit()
  UIMapMapList.super.OnExit(self)
  if self.purukuraTexture and self.purukuraTexture ~= "" then
    PictureManager.Instance:UnLoadNPCLiHui(self.purikuraTexture, self.Purikura_UITexture)
  end
  TimeTickManager.Me():ClearTick(self)
  UIMapMapList.AutoChoose = nil
  FunctionVisitNpc.Me():RemoveDirectDoNpcFuncList(3001)
end

function UIMapMapList:AlreadyInitedArea(id)
  for i = 1, #self.activeAreas do
    if self.activeAreas[i].id == id then
      return true
    end
  end
  return false
end

function UIMapMapList:IsMapBannedByFuncState(mapid)
  local funcstateId = 118
  if FunctionUnLockFunc.checkFuncStateValid(funcstateId) then
    return false
  end
  local bannedMapid = Table_FuncState[funcstateId] and Table_FuncState[funcstateId].MapID
  if not bannedMapid then
    return false
  end
  if TableUtility.ArrayFindIndex(bannedMapid, mapid) > 0 then
    return true
  end
end
