autoImport("FreeBattleView")
MobaPvpFreeModeView = class("MobaPvpFreeModeView", FreeBattleView)
local freeBattleView_Path = ResourcePathHelper.UIView("FreeBattleView")
local T_PVP_TYPE
local mobaPvpTexName = "pvp_dungeon_7205"
local Color_Gray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = Color(1, 1, 1, 1)
local Color_blue = Color(0.19215686274509805, 0.4235294117647059, 0.7333333333333333, 1)
local JP_Eu_TexUp = "pvp_bg_06"

function MobaPvpFreeModeView:Init()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function MobaPvpFreeModeView:FindObjs()
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

function MobaPvpFreeModeView:LoadSubView()
  self.objRoot = self:FindGO("MobaPvpFreeModeView")
  local obj = self:LoadPreferb_ByFullPath(freeBattleView_Path, self.objRoot, true)
  obj.name = "MobaPvpFreeModeView"
end

function MobaPvpFreeModeView:InitShow()
  PictureManager.Instance:SetPVP(mobaPvpTexName, self.multiPvpTex)
  self:UpdateCustomRoomButton()
  self:UpdateView()
end

function MobaPvpFreeModeView:UpdateView()
  local btnMatchEnable = true
  local matchStatus = PvpProxy.Instance:GetMatchState(T_PVP_TYPE)
  local tripleMatchStatus = PvpProxy.Instance:GetMatchState(PvpProxy.Type.TripleRelax)
  if matchStatus and matchStatus.ismatch or tripleMatchStatus and tripleMatchStatus.ismatch or Game.MapManager:IsPVPMode_TeamPws() or PvpProxy.Instance.inviteMap then
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
  T_PVP_TYPE = PvpProxy.Type.TripleRelax
  self.DungeonPanel:SetActive(false)
  self.multiPvpTex.gameObject:SetActive(true)
end

function MobaPvpFreeModeView:ClickButtonMatch()
  if self.disableClick then
    return
  end
  local pvpcheckvalid = PvpProxy.Instance:CheckMatchValid()
  local matchid = GameConfig.Triple and GameConfig.Triple.matchid or 100501
  local valid = TeamProxy.Instance:CheckMatchValid(Table_MatchRaid[matchid]) and pvpcheckvalid
  if valid then
    if TeamProxy.Instance:IHaveTeam() then
      local memberlst = TeamProxy.Instance.myTeam:GetPlayerMemberList(true, true)
      if #memberlst < 3 then
        MsgManager.ConfirmMsgByID(25904, function()
          self:CallMatch()
        end, nil)
        return
      end
    end
    self:CallMatch()
  end
end

function MobaPvpFreeModeView:CallMatch()
  local raidId = GameConfig.Triple and GameConfig.Triple.raidid or 7205
  local matchid = GameConfig.Triple and GameConfig.Triple.matchid or 100501
  if self.disableClick then
    return
  end
  if TeamProxy.Instance:ForbiddenByRaidID(raidId) or TeamProxy.Instance:ForbiddenByMatchRaidID(matchid) then
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

function MobaPvpFreeModeView:OnExit()
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  MobaPvpFreeModeView.super.OnExit(self)
end

function MobaPvpFreeModeView:OnTabEnabled()
  self:UpdateView()
end

function MobaPvpFreeModeView:OnTabDisabled()
end
