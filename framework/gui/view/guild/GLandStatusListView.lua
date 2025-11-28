local E_Trace = {
  TransferInvalid = 0,
  InLobby = 1,
  TransferValid = 2
}
GLandStatusListView = class("GLandStatusListView", ContainerView)
GLandStatusListView.ViewType = UIViewType.PopUpLayer
autoImport("GLandStatusCombineView")
GLandStatusListView.BrotherView = GLandStatusCombineView
autoImport("GLandStatusListCell")
autoImport("PopupCombineCell")
local _BaseNum = 10000
local _GetRealGroupId = function(id)
  if id >= _BaseNum * 10000 then
    return math.floor(id / 10000)
  elseif id >= _BaseNum * 1000 then
    return math.floor(id / 1000)
  elseif id >= _BaseNum * 100 then
    return math.floor(id / 100)
  elseif id >= _BaseNum * 10 then
    return math.floor(id / 10)
  end
end

function GLandStatusListView:Init()
  self:MapEvent()
  self:InitUI()
end

function GLandStatusListView:InitUI()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.GLandStatusListView_Title
  self.grid = self:FindComponent("AllCityGrid", UIGrid)
  self.listCtl = UIGridListCtrl.new(self.grid, GLandStatusListCell, "GLandStatusListCell")
  self.listCtl:AddEventListener(GLandStatusList_CellEvent_Trace, self.DoTrace, self)
  self.allTabObj = self:FindGO("AllTab")
  self.recommendTabObj = self:FindGO("RecommendTab")
  self.recommendGrid = self:FindComponent("RecommendCityGrid", UIGrid)
  self.recommendListCtl = UIGridListCtrl.new(self.recommendGrid, GLandStatusListCell, "GLandStatusListCell")
  self.recommendListCtl:AddEventListener(GLandStatusList_CellEvent_FriendState, self.DoTraceFriend, self)
  self.recommendListCtl:AddEventListener(GLandStatusList_CellEvent_Trace, self.DoTrace, self)
  self.cityTable = self:FindComponent("CityTable", UITable)
  self.recommendTabLab = self:FindComponent("RecommendTabLab", UILabel)
  self.recommendTabLab.text = ZhString.GLandStatusListView_Recommend
  self.allTabLab = self:FindComponent("AllTabLab", UILabel)
  self.allTabLab.text = ZhString.GLandStatusListView_All
  self.popUp = self:FindGO("PopUp")
  self.popUpCtl = PopupCombineCell.new(self.popUp, PopupCombineCellType.GVGLand)
  self.popUpCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickFilter, self)
  local fiterConfig = GvgProxy.Instance:GetGLandGroupZoneFilter()
  if not next(fiterConfig) then
    GvgProxy.Instance:DoQueryGvgZoneGroup()
  else
    self.popUpCtl:SetData(fiterConfig)
  end
  if GvgProxy.Instance:GetGvgOpenFireState() then
    local updateComp = self.gameObject:GetComponent(UpdateDelegate)
    updateComp = updateComp or self.gameObject:AddComponent(UpdateDelegate)
    updateComp.enabled = true
    self.updateComp = updateComp
    
    function self.updateComp.listener(go)
      self:OnUpdate(go)
    end
  end
end

function GLandStatusListView:OnExit()
  GLandStatusListView.super.OnExit(self)
  if not Game.GameObjectUtil:ObjectIsNULL(self.updateComp) then
    self.updateComp.listener = nil
  end
  ServiceGuildCmdProxy.Instance:CallQueryGCityShowInfoGuildCmd(nil, nil, GuildCmd_pb.ECITYINFOQUERYTYPE_UI_CLOSE)
end

function GLandStatusListView:OnUpdate()
  if not GvgProxy.Instance:GetGvgOpenFireState() and not Game.GameObjectUtil:ObjectIsNULL(self.updateComp) then
    self.updateComp.enabled = false
    self:InitQueryGCity()
  end
end

function GLandStatusListView:UpdateByGvgZone()
  local fiterConfig = GvgProxy.Instance:GetGLandGroupZoneFilter()
  self.popUpCtl:SetData(fiterConfig)
  self:InitQueryGCity()
end

function GLandStatusListView:OnClickFilter()
  if self.groupid == self.popUpCtl.goal then
    return
  end
  self.groupid = self.popUpCtl.goal
  self:DoQuery()
end

function GLandStatusListView:DoTraceFriend(cell)
  local traceResult = self:DoTrace(cell, true)
  if traceResult == E_Trace.TransferValid then
    GvgProxy.Instance:NeedMoveToCity(true, cell.data.IsMyCity and cell.data:IsMyCity())
  elseif traceResult == E_Trace.InLobby then
    Game.MapManager:TryMoveToGvGCity(cell.data.IsMyCity and cell.data:IsMyCity())
  end
end

local posV3 = LuaVector3(0, 0, 0)

function GLandStatusListView:DoTrace(cell, friend_state)
  local interval_time = GameConfig.GvgNewConfig.transport_interval or 5
  local cur_time = ServerTime.CurServerTime() / 1000
  if self.sendtime and interval_time > cur_time - self.sendtime then
    MsgManager.ShowMsgByID(2247)
    return E_Trace.TransferInvalid
  end
  local curRaidID = Game.MapManager:GetRaidID()
  if not Game.MapManager:IsInGVG() and curRaidID ~= 0 then
    MsgManager.ShowMsgByIDTable(2240)
    return E_Trace.TransferInvalid
  end
  local cityid = cell.data_cityid
  local staticCity = GvgProxy.GetStrongHoldStaticData(cityid)
  if staticCity and staticCity.RaidId == curRaidID then
    MsgManager.ShowMsgByIDTable(2245)
    return E_Trace.TransferInvalid
  end
  local city2RaidId = staticCity and staticCity.LobbyRaidID or 0
  local groupid = cell.data_groupid
  if curRaidID == city2RaidId and GvgProxy.Instance:CheckIsCurMapGvgGroupID(groupid) then
    if not friend_state then
      MsgManager.ShowMsgByIDTable(2245)
    end
    return E_Trace.InLobby
  end
  self.sendtime = cur_time
  GvgProxy.Instance:Debug("[NewGVG] CallGvgReqEnterCityGuildCmd groupid|cityid ", groupid, cityid)
  ServiceGuildCmdProxy.Instance:CallGvgReqEnterCityGuildCmd(groupid, cityid)
  redlog("CallGvgReqEnterCityGuildCmd", groupid, cityid)
  return E_Trace.TransferValid
end

function GLandStatusListView:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGCityShowInfoGuildCmd, self.UpdateInfo)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGvgZoneGroupGuildCCmd, self.UpdateByGvgZone)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgRoadblockModifyGuildCmd, self.OnRoadBlockModified)
  self:AddListenEvt(GVGEvent.GVG_TraceToCity, self.CloseSelf)
end

function GLandStatusListView:UpdateInfo(note)
  local data = note.body
  local groupid = data.groupid
  local landInfos = GvgProxy.Instance:Get_GLandStatusInfos(groupid)
  for _, city in pairs(landInfos) do
    city:SetTop(false)
  end
  self.listCtl:ResetDatas(landInfos, true)
  local recommendList = {}
  if not GvgProxy.Instance:CheckInSettleTime() then
    for _, city in pairs(landInfos) do
      if city:IsRecommendCity() then
        city:SetTop(true)
        recommendList[#recommendList + 1] = city
      end
    end
    table.sort(recommendList, function(a, b)
      return a.sort_type < b.sort_type
    end)
  end
  if 0 < #recommendList then
    self:Show(self.recommendTabObj)
    self:Show(self.recommendGrid.gameObject)
    self:Show(self.allTabObj)
    self.recommendListCtl:ResetDatas(recommendList)
  else
    self:Hide(self.recommendTabObj)
    self:Hide(self.recommendGrid.gameObject)
    self:Hide(self.allTabObj)
  end
  self.cityTable:Reposition()
end

function GLandStatusListView:OnEnter()
  GLandStatusListView.super.OnEnter(self)
  self:InitQueryGCity()
end

function GLandStatusListView:InitQueryGCity()
  self.groupid = self.popUpCtl.goal
  self:DoQuery()
end

function GLandStatusListView:DoQuery()
  if not self.groupid then
    return
  end
  local groupid = _GetRealGroupId(self.groupid)
  GvgProxy.Instance:Debug("[NewGVG] CallQueryGCityShowInfoGuildCmd :", groupid)
  ServiceGuildCmdProxy.Instance:CallQueryGCityShowInfoGuildCmd(nil, groupid, GuildCmd_pb.ECITYINFOQUERYTYPE_UI_OPEN)
end

function GLandStatusListView:OnRoadBlockModified(note)
  if note.body and note.body.ret then
    self:InitQueryGCity()
  end
end
