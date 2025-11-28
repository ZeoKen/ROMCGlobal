autoImport("DisneyQTEMemberCell")
autoImport("BaseQTEView")
DisneyQTEView = class("DisneyQTEView", BaseQTEView)
local teamProxy

function DisneyQTEView:Init()
  DisneyQTEView.super.Init(self)
  self:AddEvents()
  if Game.IsLocalEditorGame then
    DisneyStageProxy.Instance:ResetQTEStat()
  end
  self.tickMg = TimeTickManager.Me()
end

function DisneyQTEView:FindObjs()
  DisneyQTEView.super.FindObjs(self)
  self.memberGrid = self:FindComponent("MemberGrid", UIGrid)
  self.teamCtl = UIGridListCtrl.new(self.memberGrid, DisneyQTEMemberCell, "DisneyQTEMemberCell")
  self.opResultEffectHolder = self:FindGO("FxHolder")
end

function DisneyQTEView:AddEvents()
  self:AddListenEvt(ServiceEvent.NUserUserActionNtf, self.Team_SyncPlayPlotNpcAction)
  self:AddListenEvt(ServiceEvent.SceneUserActionNtf, self.Team_SyncPlayPlotNpcAction)
  self:AddListenEvt(ServiceEvent.SessionTeamEnterTeam, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamExchangeLeader, self.UpdateTeamMember)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamDataUpdate, self.UpdateTeamMember)
  self:AddListenEvt(TeamEvent.MemberOffline, self.UpdateTeamMember)
  EventManager.Me():AddEventListener(AppStateEvent.Pause, self.OnAppPauseQuitStage, self)
end

function DisneyQTEView:OnEnter()
  DisneyQTEView.super.OnEnter(self)
  teamProxy = TeamProxy.Instance
  self.teamMemberCharId2PlayerIndex = {}
  self:UpdateTeamMember()
  self.tickMg:CreateTick(0, 5000, self.UpdateTeamMember, self)
end

function DisneyQTEView:OnExit()
  EventManager.Me():RemoveEventListener(AppStateEvent.Pause, self.OnAppPauseQuitStage, self)
  self.tickMg:ClearTick(self)
  DisneyQTEView.super.OnExit(self)
end

function DisneyQTEView:QTEResultCallBack(result, params)
  local rank = (type(result) == "number" and result or result and 2 or 0) + 1
  redlog("DisneyQTEView", rank)
  DisneyStageProxy.Instance:ClientCountingQTEScore(Game.Myself.data.id, 1, rank)
  self:PlayComboEffect()
  local fx_x, fx_y
  if params.point then
    fx_x, fx_y = params.point:GetPos()
  end
  self:PlayResultEffect(rank, fx_x or 0, (fx_y or 0) + 100)
  local qte_ordinal = params.cfg.order_id
  params = params and params.cfg and params.cfg.callback_params
  if not params then
    return
  end
  local succeed = result and result ~= false
  local paramsLen = #params
  local actionId, action
  if 1 < paramsLen then
    actionId = succeed and params[1] or params[2]
    action = Table_ActionAnime[actionId]
    action = action and action.Name
    Game.Myself:Client_PlayAction(action)
    ServiceNUserProxy.Instance:CallUserActionNtf(Game.Myself.data.id, actionId, SceneUser2_pb.EUSERACTIONTYPE_MIN, qte_ordinal)
  end
  self:Myself_SyncPlayPlotNpcAction(params, succeed)
end

function DisneyQTEView:UpdateTeamMember()
  if teamProxy.myTeam and nil == teamProxy.myTeam.hireMemberList_dirty then
    ServiceSessionTeamProxy.Instance:CallQueryMemberCatTeamCmd()
  end
  if teamProxy.myTeam then
    local memberlst = teamProxy.myTeam:GetPlayerMemberList(true, true)
    if memberlst then
      local inGameML = {}
      for i = 1, #memberlst do
        if DisneyStageProxy.Instance:GetHeroId(memberlst[i].id) ~= 0 then
          TableUtility.ArrayPushBack(inGameML, memberlst[i])
        end
      end
      self.teamCtl:ResetDatas(inGameML)
      for i = 1, #inGameML do
        local charid = inGameML[i].id
        if TableUtility.ArrayFindIndex(self.teamMemberCharId2PlayerIndex, charid) == 0 then
          table.insert(self.teamMemberCharId2PlayerIndex, charid)
        end
      end
      table.sort(self.teamMemberCharId2PlayerIndex)
    end
  elseif self.teamCtl then
    self.teamCtl:ResetDatas({
      MyselfTeamData.EMPTY_STATE
    })
  end
end

function DisneyQTEView:Myself_SyncPlayPlotNpcAction(params, succeed)
  local playerIndex = TableUtility.ArrayFindIndex(self.teamMemberCharId2PlayerIndex, Game.Myself.data.id)
  if (not playerIndex or playerIndex <= 0) and Game.IsLocalEditorGame then
    playerIndex = 1
  end
  self:SyncPlayPlotNpcAction(playerIndex, params, succeed)
end

function DisneyQTEView:Team_SyncPlayPlotNpcAction(ntfData)
  local data = ntfData.body
  local charid = data.charid
  local type = data.type
  local action = data.value
  local qte_ordinal = data.delay and tonumber(data.delay)
  if type ~= SceneUser2_pb.EUSERACTIONTYPE_MIN then
    redlog("err 1")
    return
  end
  local playerIndex = TableUtility.ArrayFindIndex(self.teamMemberCharId2PlayerIndex, charid)
  if playerIndex == 0 then
    redlog("err 2")
    return
  end
  local params = self.gameControl.orderInfo[qte_ordinal]
  if not params then
    redlog("err 3")
    return
  end
  local idx = TableUtility.ArrayFindIndex(params, action)
  if idx < 1 or 2 < idx then
    redlog("err 4")
    return
  end
  local succeed = idx == 1
  self:SyncPlayPlotNpcAction(playerIndex, params, succeed)
  self:SyncPlayPlotPlayerAction(charid, params, succeed)
end

function DisneyQTEView:SyncPlayPlotPlayerAction(charid, params, succeed)
  local paramsLen = #params
  local player, action
  if 1 < paramsLen then
    action = succeed and params[1] or params[2]
    action = Table_ActionAnime[action]
    action = action and action.Name
    player = SceneCreatureProxy.FindCreature(charid)
    player:Client_PlayAction(action)
  end
end

function DisneyQTEView:SyncPlayPlotNpcAction(playerIndex, params, succeed)
  local plotId = self.gameControl.plotId
  local paramsLen = #params
  local npc_uid, action
  if (paramsLen - 2) % 3 == 0 and plotId then
    for i = 3, paramsLen, 3 do
      npc_uid = params[i] * 10 + playerIndex
      action = succeed and params[i + 1] or params[i + 2]
      action = Table_ActionAnime[action]
      action = action and action.Name
      local target = Game.PlotStoryManager:GetNpcRole(plotId, npc_uid)
      if target then
        target:Server_PlayActionCmd(action)
      end
    end
  end
end

local effectLevel = {
  "WorldMissionIight_miss",
  "WorldMissionIight_good",
  "Combo_Good_Perfect"
}

function DisneyQTEView:PlayResultEffect(lv, x, y)
  local fxName = effectLevel[lv]
  self:PlayUIEffect(fxName, self.opResultEffectHolder, true, function(go)
    go.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(x, y, 0)
  end)
end

function DisneyQTEView:PlayComboEffect()
  local combo = DisneyStageProxy.Instance:GetMyselfCurCombo()
  if combo then
    ComboCtl.Instance:ShowCombo(combo, "Anchor_TopCombo")
  end
end

function DisneyQTEView:OnAppPauseQuitStage()
  FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
    MsgManager.ConfirmMsgByID(42062)
  end)
  ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
end
