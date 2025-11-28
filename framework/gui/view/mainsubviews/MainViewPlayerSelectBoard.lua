autoImport("PlayerSelectCell")
MainViewPlayerSelectBoard = class("MainViewPlayerSelectBoard", SubView)
local tmpDataArray = {}
local vecBoardOpenPos = LuaVector3(220, 0, 0)
local vecArrowOpenEuler = LuaVector3(0, 0, 180)
MainViewPlayerSelectBoard.Empty = "Empty"

function MainViewPlayerSelectBoard:Init()
  self:InitView()
  self:AddViewEvts()
  self:AddBtnEvts()
  self.playerDatas = {}
  self.playerIDsCache = {}
end

function MainViewPlayerSelectBoard:InitView()
  local tsfParent = self:FindGO("Anchor_DownLeft").transform
  self:ReLoadPerferb("view/MainViewPlayerSelectBoard")
  self.trans:SetParent(tsfParent, false)
  self.objMoveRoot = self:FindGO("MoveRoot")
  self.objBtnShow = self:FindGO("btnShow", self.objMoveRoot)
  self.tsfArrow = self:FindGO("Sprite", self.objBtnShow).transform
  self.listPlayers = UIGridListCtrl.new(self:FindComponent("gridPlayers", UIGrid, self.objMoveRoot), PlayerSelectCell, "PlayerSelectCell")
  self.bg2 = self:FindGO("bg2")
  self.playerTab = self:FindGO("playerTab")
  self.enemyTab = self:FindGO("enemyTab")
  self.toggle = true
  self.playerTab:SetActive(self.toggle)
  self.enemyTab:SetActive(not self.toggle)
  self.bg2:SetActive(false)
  self:HideView()
end

function MainViewPlayerSelectBoard:AddViewEvts()
  self:AddListenEvt(PVPEvent.TeamPws_Launch, self.ShowView)
  self:AddListenEvt(PVPEvent.TeamPws_ShutDown, self.HideView)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_Launch, self.ShowView)
  self:AddListenEvt(PVPEvent.TeamPwsOthello_ShutDown, self.HideView)
  self:AddListenEvt(PVPEvent.PVP_DesertWolfFightLaunch, self.ShowView)
  self:AddListenEvt(PVPEvent.PVP_DesertWolfFightShutDown, self.HideView)
  self:AddListenEvt(PVPEvent.TeamTwelve_Launch, self.HandleTeamTwelveLaunch)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.HandleTeamTwelveShutDown)
  self:AddListenEvt(SceneUserEvent.SceneAddRoles, self.RefreshPlayerDatas)
  self:AddListenEvt(SceneUserEvent.SceneRemoveRoles, self.RefreshPlayerDatas)
  self:AddListenEvt(ServiceEvent.NUserUserNineSyncCmd, self.RefreshPlayerDatas)
  self:AddDispatcherEvt(CreatureEvent.Player_CampChange, self.RefreshPlayerDatas)
  self:AddDispatcherEvt(CreatureEvent.Hiding_Change, self.RefreshPlayerDatas)
  self.listPlayers:AddEventListener(MouseEvent.MouseClick, self.ClickPlayerCell, self)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.RefreshPlayerDatas)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.RefreshPlayerDatas)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.RefreshPlayerDatas)
  self:AddListenEvt(ServiceEvent.SessionTeamQueryMemberTeamCmd, self.RefreshPlayerDatas)
  self:AddListenEvt(PlayerEvent.AnonymousStateChange, self.RefreshPlayerDatas)
end

function MainViewPlayerSelectBoard:AddBtnEvts()
  self:AddClickEvent(self.objBtnShow, function()
    self:ShowBoard(not self.isBoardShow)
  end)
  self:AddClickEvent(self.playerTab, function()
    self.toggle = not self.toggle
    self.playerTab:SetActive(self.toggle)
    self.enemyTab:SetActive(not self.toggle)
    if self.toggle == true then
      self:SetGroupMemberDatas()
    else
      self:SetEnemyDatas()
    end
  end)
  self:AddClickEvent(self.enemyTab, function()
    self.toggle = not self.toggle
    self.playerTab:SetActive(self.toggle)
    self.enemyTab:SetActive(not self.toggle)
    if self.toggle == true then
      self:SetGroupMemberDatas()
    else
      self:SetEnemyDatas()
    end
  end)
end

function MainViewPlayerSelectBoard:RefreshPlayerDatas()
  if Game.MapManager:IsPVPMode_TeamPws() or Game.MapManager:IsPvpMode_DesertWolf() then
    self:SetEnemyDatas()
  elseif Game.MapManager:IsPvPMode_TeamTwelve() then
    if self.toggle then
      self:SetGroupMemberDatas()
    else
      self:SetEnemyDatas()
    end
  end
end

function MainViewPlayerSelectBoard:SetEnemyDatas()
  if not self.isBoardShow then
    return
  end
  if Game.MapManager:IsPvPMode_TeamTwelve() and self.toggle then
    return
  end
  TableUtility.ArrayClear(tmpDataArray)
  local userMap = NSceneUserProxy.Instance.userMap
  for _, player in pairs(userMap) do
    if player.data and player.data:GetCamp() == RoleDefines_Camp.ENEMY then
      tmpDataArray[#tmpDataArray + 1] = player
    end
  end
  self:SetDatas(tmpDataArray)
end

function MainViewPlayerSelectBoard:HandleTeamTwelveLaunch()
  self.bg2:SetActive(true)
  self:ShowView()
end

function MainViewPlayerSelectBoard:HandleTeamTwelveShutDown()
  self.bg2:SetActive(false)
  self.toggle = true
  self.playerTab:SetActive(self.toggle)
  self.enemyTab:SetActive(not self.toggle)
  self:HideView()
end

function MainViewPlayerSelectBoard:SetGroupMemberDatas()
  if not self.isBoardShow then
    return
  end
  if Game.MapManager:IsPvPMode_TeamTwelve() and not self.toggle then
    return
  end
  TableUtility.ArrayClear(tmpDataArray)
  local userMap = NSceneUserProxy.Instance.userMap
  for _, player in pairs(userMap) do
    if player.data and player.data:GetCamp() == RoleDefines_Camp.FRIEND and not TeamProxy.Instance:IsInMyTeam(player.data.id) then
      tmpDataArray[#tmpDataArray + 1] = player
    end
  end
  self:SetDatas(tmpDataArray)
end

function MainViewPlayerSelectBoard:SetDatas(datas)
  if not self.isBoardShow then
    return
  end
  TableUtility.ArrayClear(self.playerDatas)
  if #self.playerIDsCache > 6 then
    TableUtility.TableClear(self.playerIDsCache)
    redlog("出现错误：PlayerID缓存超过6位，清理所有缓存，玩家重新排序")
  end
  local singleData, index
  for i = 1, math.min(#datas, 6) do
    singleData = datas[i]
    index = TableUtility.ArrayFindIndex(self.playerIDsCache, singleData.data.id)
    if index < 1 then
      index = #self.playerIDsCache + 1
      self.playerIDsCache[index] = singleData.data.id
    end
    self.playerDatas[index] = singleData
  end
  for i = 1, 6 do
    if not self.playerDatas[i] then
      self.playerDatas[i] = MainViewPlayerSelectBoard.Empty
    end
  end
  self.listPlayers:ResetDatas(self.playerDatas)
end

function MainViewPlayerSelectBoard:ClickPlayerCell(cell)
  Game.Myself:Client_LockTarget(cell.data)
end

function MainViewPlayerSelectBoard:ShowBoard(isShow)
  if self.isBoardShow == isShow then
    return
  end
  TweenPosition.Begin(self.objMoveRoot, 0.2, isShow and vecBoardOpenPos or LuaVector3.Zero()).method = 2
  self.tsfArrow.localEulerAngles = isShow and vecArrowOpenEuler or LuaGeometry.GetTempVector3(0, 0, 0)
  self.isBoardShow = isShow
  if isShow then
    self:RefreshPlayerDatas()
  end
end

function MainViewPlayerSelectBoard:ShowView()
  if PvpObserveProxy.Instance:IsRunning() then
    return
  end
  self.gameObject:SetActive(true)
  TableUtility.TableClear(self.playerIDsCache)
  self:RefreshPlayerDatas()
end

function MainViewPlayerSelectBoard:HideView()
  if PvpObserveProxy.Instance:IsRunning() then
    return
  end
  if self.isBoardShow ~= false then
    self.objMoveRoot.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.tsfArrow.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, 0)
    self.isBoardShow = false
  end
  self.gameObject:SetActive(false)
end

function MainViewPlayerSelectBoard:OnEnter()
  MainViewPlayerSelectBoard.super.OnEnter(self)
end
