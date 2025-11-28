autoImport("FreeBattleView")
TeamPwsFreeModeView = class("TeamPwsFreeModeView", FreeBattleView)
local freeBattleView_Path = ResourcePathHelper.UIView("FreeBattleView")
local pwsCfg = GameConfig.PvpTeamRaid_Relax
local relaxCfg = GameConfig.TwelvePvp.RelaxMode
local T_PVP_TYPE
local multiPvpTexName = "pvp_dungeon_7046"
local Color_Gray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = Color(1, 1, 1, 1)
local Color_blue = Color(0.19215686274509805, 0.4235294117647059, 0.7333333333333333, 1)
local JP_Eu_TexUp = "pvp_bg_06"

function TeamPwsFreeModeView:Init()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function TeamPwsFreeModeView:FindObjs()
  self:LoadSubView()
  local gridDungeon = self:FindComponent("dungeonGrid", UIGrid, self.objRoot)
  self.listDungeon = UIGridListCtrl.new(gridDungeon, FreeBattleDungeonCell, "FreeBattleDungeonCell")
  self.objBtnMatch = self:FindGO("MatchBtn", self.objRoot)
  self.colBtnMatch = self.objBtnMatch:GetComponent(BoxCollider)
  self.sprBtnMatch = self:FindComponent("BG", UISprite, self.objBtnMatch)
  self.objEnableMatchBtnLabel = self:FindGO("enableLabel", self.objBtnMatch)
  self.objDisableMatchBtnLabel = self:FindGO("disableLabel", self.objBtnMatch)
  self:_initDiffServerMatch()
  self.multiPvpTex = self:FindComponent("12pvpTex", UITexture, self.objRoot)
  self.DungeonPanel = self:FindGO("DungeonPanel", self.objRoot)
  self.createRoomBtnGO = self:FindGO("CreateRoomBtn", self.objRoot)
  self.createRoomLabel = self:FindComponent("Label", UILabel, self.createRoomBtnGO)
  self.roomListBtnGO = self:FindGO("RoomListBtn", self.objRoot)
  self.createRoomBtnGO:SetActive(false)
  self.roomListBtnGO:SetActive(false)
  self.freeFireTipBtn = self:FindGO("FreeFireBtn", self.objRoot)
  if self.freeFireTipBtn then
    self:RegistShowGeneralHelpByHelpID(32599, self.freeFireTipBtn)
  end
end

function TeamPwsFreeModeView:LoadSubView()
  self.objRoot = self:FindGO("TeamPwsFreeModeView")
  local obj = self:LoadPreferb_ByFullPath(freeBattleView_Path, self.objRoot, true)
  obj.name = "TeamPwsFreeModeView"
end

function TeamPwsFreeModeView:InitShow()
  self:UpdateCustomRoomButton()
  self:UpdateView()
end

function TeamPwsFreeModeView:UpdateView()
  local btnMatchEnable = true
  local matchStatus = PvpProxy.Instance:GetMatchState(T_PVP_TYPE)
  local teamPwsMatchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.TeamPws)
  if matchStatus and matchStatus.ismatch or teamPwsMatchStatus and teamPwsMatchStatus.ismatch or Game.MapManager:IsPVPMode_TeamPws() or PvpProxy.Instance.inviteMap then
    btnMatchEnable = false
  end
  self.colBtnMatch.enabled = btnMatchEnable
  if btnMatchEnable then
    self:SetTextureWhite(self.sprBtnMatch)
  else
    self:SetTextureGrey(self.sprBtnMatch)
  end
  self.objEnableMatchBtnLabel:SetActive(btnMatchEnable)
  self.objDisableMatchBtnLabel:SetActive(not btnMatchEnable)
  self.btnMatchEnable = btnMatchEnable
  TeamProxy.Instance:SetDiffServerJoinRoomStatus(self.onlyMatchMyServerObj, self.onlyMatchMyServerTog, self.onlyMatchMyServerTip, self:SupportDiffServer(), not self.btnMatchEnable)
  self.roomID, self.pwsConfig = next(pwsCfg)
  T_PVP_TYPE = PvpProxy.Type.FreeBattle
  self.DungeonPanel:SetActive(true)
  self.multiPvpTex.gameObject:SetActive(false)
  self:RefreshDungeonList()
  self.listDungeon:ResetPosition()
end

function TeamPwsFreeModeView:ClickButtonMatch()
  if not self.selectCell or self.disableClick then
    return
  end
  local pvpcheckvalid = PvpProxy.Instance:CheckPwsMatchValid(true, self.selectCell.id)
  local valid = TeamProxy.Instance:CheckMatchValid(Table_MatchRaid[self.pwsConfig.matchid]) and pvpcheckvalid
  if valid then
    if TeamProxy.Instance:IHaveTeam() then
      local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      if #memberlst < GameConfig.Team.maxmember then
        MsgManager.ConfirmMsgByID(25904, function()
          self:CallMatch()
        end, nil)
        return
      end
    end
    self:CallMatch()
  end
end

function TeamPwsFreeModeView:CallMatch()
  local raidId = self.selectCell.id
  if not self.selectCell or self.disableClick then
    return
  end
  if TeamProxy.Instance:ForbiddenByRaidID(raidId) or TeamProxy.Instance:ForbiddenByMatchRaidID(self.pwsConfig.matchid) then
    MsgManager.ShowMsgByID(42041)
    return
  end
  if PvpCustomRoomProxy.Instance:GetCurrentRoomData() ~= nil then
    MsgManager.ShowMsgByID(475)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(T_PVP_TYPE, raidId, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.onlyMatchMyServerTog.value)
  self.disableClick = true
  self.ltDisableClick = TimeTickManager.Me():CreateOnceDelayTick(3000, function(owner, deltaTime)
    self.disableClick = false
    self.ltDisableClick = nil
  end, self)
  self.container:CloseSelf()
end

function TeamPwsFreeModeView:OnExit()
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  TeamPwsFreeModeView.super.OnExit(self)
end

function TeamPwsFreeModeView:OnTabEnabled()
  self:UpdateView()
end

function TeamPwsFreeModeView:OnTabDisabled()
end
