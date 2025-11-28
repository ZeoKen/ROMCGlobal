autoImport("MapTransmitterCell")
MapTransmitterView = class("MapTransmitterView", ContainerView)
MapTransmitterView.ViewType = UIViewType.NormalLayer
MapTransmitterView.E_TransmitGroup = {DeathKingdom = 1, Institute = 2}
MapTransmitterView.transmitGroup = nil

function MapTransmitterView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitList()
  self.activeAreas = {}
  self:InitData()
end

function MapTransmitterView:FindObjs()
  self.labTutorial = self:FindComponent("labTutorial", UILabel)
  self.labNpcName = self:FindComponent("NPCName", UILabel)
end

function MapTransmitterView:AddEvts()
  self:AddClickEvent(self:FindGO("btnClose"), function()
    self:ClickBtnClose()
  end)
end

function MapTransmitterView:AddViewEvts()
end

function MapTransmitterView:InitList()
  self.listCtrl = UIGridListCtrl.new(self:FindComponent("gridMaps", UIGrid), MapTransmitterCell, "MapTransmitterCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMapCell, self)
end

function MapTransmitterView:InitData()
  self.curNpcID = self.viewdata.viewdata.params
  TableUtility.ArrayClear(self.activeAreas)
  MapTransmitterView.transmitGroup = WorldMapProxy.Instance:GetTransmitGroupByNpcId(self.curNpcID)
  if not MapTransmitterView.transmitGroup then
    LogUtility.Error(string.format("没有找到NpcID:%s 的传送group！", tostring(self.curNpcID)))
    self:CloseSelf()
    return
  end
  local curMapID = Game.MapManager:GetMapID()
  local mapDatas = WorldMapProxy.Instance:GetTransmitterMapByGroup(MapTransmitterView.transmitGroup)
  for mapID, transfers in pairs(mapDatas) do
    local mapData = Table_Map[mapID]
    if mapData and not self:IsMapBannedByFuncState(mapID) then
      self.activeAreas[#self.activeAreas + 1] = {
        id = mapID,
        name = mapData.CallZh,
        isCurrent = mapID == curMapID
      }
    else
      printRed("Cannot Find Map Data With ID: %s", mapID)
    end
  end
  local curNpcData = Table_Npc[self.curNpcID]
  if curNpcData then
    self.labTutorial.text = DialogUtil.GetDialogData(curNpcData.DefaultDialog).Text
    self.labNpcName.text = curNpcData.NameZh
  end
  table.sort(self.activeAreas, function(x, y)
    return self:Sort(x, y)
  end)
  self.listCtrl:ResetDatas(self.activeAreas)
end

function MapTransmitterView:ClickMapCell(cell)
  local viewdata = {
    selectID = cell.id,
    npcID = self.curNpcID,
    mapGroup = MapTransmitterView.transmitGroup
  }
  FunctionNpcFunc.JumpPanel(PanelConfig.MapTransmitterAreaView, viewdata)
  self:CloseSelf()
end

function MapTransmitterView:Sort(x, y)
  if x == nil then
    return true
  elseif y == nil then
    return false
  else
    return x.id < y.id
  end
end

function MapTransmitterView:ClickBtnClose()
  local npc = NSceneNpcProxy.Instance:FindNearestNpc(Game.Myself:GetPosition(), self.curNpcID)
  if npc then
    npc.assetRole:PlayAction_Simple(GameConfig.Transmitter.ExitAnimName)
  end
  self:CloseSelf()
end

function MapTransmitterView:IsMapBannedByFuncState(mapid)
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

function MapTransmitterView:OnEnter()
  MapTransmitterView.super.OnEnter(self)
end

function MapTransmitterView:OnExit()
  PictureManager.Instance:UnLoadTransmitterScene()
  MapTransmitterView.super.OnExit(self)
end
