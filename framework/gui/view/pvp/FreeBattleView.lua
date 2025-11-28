autoImport("FreeBattleDungeonCell")
FreeBattleView = class("FreeBattleView", SubView)
local freeBattleView_Path = ResourcePathHelper.UIView("FreeBattleView")
local pwsCfg = GameConfig.PvpTeamRaid_Relax
local relaxCfg = GameConfig.TwelvePvp.RelaxMode
local T_PVP_TYPE
local multiPvpTexName = "pvp_dungeon_7046"
local Color_Gray = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 1)
local Color_White = Color(1, 1, 1, 1)
local Color_blue = Color(0.19215686274509805, 0.4235294117647059, 0.7333333333333333, 1)
local JP_Eu_TexUp = "pvp_bg_06"

function FreeBattleView:Init()
  self:InitPvpType()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function FreeBattleView:InitPvpType()
  self.pvpType = PvpProxy.Type.FreeBattle
end

function FreeBattleView:FindObjs()
  self:LoadSubView()
  local gridDungeon = self:FindComponent("dungeonGrid", UIGrid, self.objRoot)
  self.listDungeon = UIGridListCtrl.new(gridDungeon, FreeBattleDungeonCell, "FreeBattleDungeonCell")
  self.objBtnMatch = self:FindGO("MatchBtn", self.objRoot)
  self.colBtnMatch = self.objBtnMatch:GetComponent(BoxCollider)
  self.sprBtnMatch = self:FindComponent("BG", UISprite, self.objBtnMatch)
  self.objEnableMatchBtnLabel = self:FindGO("enableLabel", self.objBtnMatch)
  self.objDisableMatchBtnLabel = self:FindGO("disableLabel", self.objBtnMatch)
  self.matchGrid = self:FindComponent("MatchBtnGroup", UIGrid, self.objRoot)
  self:_initDiffServerMatch()
  self.free6v6Tex = self:FindComponent("Free6v6Tex", UITexture)
  self.practiseModelTex = self:FindComponent("PractiseModelTex", UITexture)
  self.free6v6ModelTog = self:FindComponent("Free6v6ModelBtn", UIToggle)
  self.free6v6ModelName = self:FindComponent("Free6v6ModelName", UILabel, self.free6v6ModelTog.gameObject)
  self.free6v6ModelName.text = ZhString.TwelvePVP6V6_TabName
  self.practiseModelBtn = self:FindComponent("PractiseModelBtn", UIToggle)
  self.practiseModelName = self:FindComponent("PractiseName", UILabel, self.practiseModelBtn.gameObject)
  self.practiseModelName.text = ZhString.TwelvePVPRelax_TabName
  self.multiPvpTex = self:FindComponent("12pvpTex", UITexture)
  self.DungeonPanel = self:FindGO("DungeonPanel")
  self.upGridObj = self:FindGO("FreeBattleGrid")
  self.jp_Eu_Tex = self:FindComponent("JpEuTexture", UITexture, self.objRoot)
  PictureManager.Instance:SetPVP(JP_Eu_TexUp, self.jp_Eu_Tex)
  local pvp12Open = not GameConfig.SystemForbid.TwelvePvpForbid
  if BranchMgr.IsJapan() or BranchMgr.IsEU() then
    self.jp_Eu_Tex.gameObject:SetActive(not pvp12Open)
    self.upGridObj:SetActive(pvp12Open)
    if not pvp12Open then
      self.roomID, self.pwsConfig = next(pwsCfg)
      T_PVP_TYPE = PvpProxy.Type.FreeBattle
      self.DungeonPanel:SetActive(self.free6v6ModelTog.value)
      self.multiPvpTex.gameObject:SetActive(not self.free6v6ModelTog.value)
      self:UpdateView()
      self:RefreshDungeonList()
      self.listDungeon:ResetPosition()
    end
  else
    self.jp_Eu_Tex.gameObject:SetActive(false)
    self.upGridObj:SetActive(true)
    self.practiseModelBtn:GetComponent(Collider).enabled = pvp12Open
    self.practiseModelTex.color = pvp12Open and Color_White or Color_Gray
    self.practiseModelName.color = pvp12Open and Color_blue or Color_Gray
  end
  self:FindRoomObj()
end

function FreeBattleView:FindRoomObj()
  self.createRoomBtnGO = self:FindGO("CreateRoomBtn", self.objRoot)
  self.createRoomLabel = self:FindComponent("Label", UILabel, self.createRoomBtnGO)
  self.roomListBtnGO = self:FindGO("RoomListBtn", self.objRoot)
end

function FreeBattleView:_initDiffServerMatch()
  self.onlyMatchMyServerObj = self:FindGO("OnlyMatchMyServer", self.objRoot)
  self.onlyMatchMyServerTog = self:FindComponent("Tog", UIToggle, self.onlyMatchMyServerObj)
  self.onlyMatchMyServerLab = self:FindComponent("Label", UILabel, self.onlyMatchMyServerObj)
  self.onlyMatchMyServerLab.text = ZhString.TeamFindPopUp_OnlyMatchMyServer
  self.onlyMatchMyServerTog.value = false
  self.onlyMatchMyServerTip = self:FindGO("Tip", self.onlyMatchMyServerObj)
  self:RegistShowGeneralHelpByHelpID(101, self.onlyMatchMyServerTip)
end

function FreeBattleView:LoadSubView()
  self.objRoot = self:FindGO("FreeBattleView")
  local obj = self:LoadPreferb_ByFullPath(freeBattleView_Path, self.objRoot, true)
  obj.name = "FreeBattleView"
end

function FreeBattleView:AddBtnEvts()
  self:AddClickEvent(self:FindGO("RuleBtn", self.objRoot), function()
    self:ClickButtonRule()
  end)
  self:AddClickEvent(self.objBtnMatch, function()
    self:ClickButtonMatch()
  end)
  if self.createRoomBtnGO then
    self:AddClickEvent(self.createRoomBtnGO, function()
      local roomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
      if roomData then
        if roomData.pvptype ~= self.pvpType then
          MsgManager.ShowMsgByID(475)
          return
        end
        local config = PvpCustomRoomProxy.GetRoomPopup(roomData.pvptype)
        if config then
          GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {view = config})
        end
      else
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.TeamPwsCreateRoomPopup,
          viewdata = {
            type = self.pvpType
          }
        })
      end
    end)
  end
  if self.roomListBtnGO then
    self:AddClickEvent(self.roomListBtnGO, function()
      PvpCustomRoomProxy.Instance:ClearRoomList()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TeamPwsCustomRoomListPopup,
        viewdata = {
          etype = self.pvpType
        }
      })
    end)
  end
end

function FreeBattleView:AddViewEvts()
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateView)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateView)
  self.listDungeon:AddEventListener(MouseEvent.MouseClick, self.SelectDungeon, self)
  self:AddDispatcherEvt(CustomRoomEvent.OnCurrentRoomChanged, self.UpdateCustomRoomButton)
end

function FreeBattleView:InitShow()
  PictureManager.Instance:SetPVP("12pvp_bg_pic4", self.free6v6Tex)
  PictureManager.Instance:SetPVP("12pvp_bg_pic5", self.practiseModelTex)
  PictureManager.Instance:SetPVP(multiPvpTexName, self.multiPvpTex)
  self:UpdateCustomRoomButton()
  self:UpdateView()
end

function FreeBattleView:UpdateView()
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
end

function FreeBattleView:RefreshDungeonList()
  self.listDungeon:ResetDatas(self.pwsConfig.RaidMaps)
  self.selectCell = nil
  local cells = self.listDungeon:GetCells()
  if cells and 0 < #cells then
    self:SelectDungeon(cells[1])
  end
end

function FreeBattleView:SelectDungeon(cell)
  if self.selectCell then
    if self.selectCell.id == cell.id then
      return
    end
    self.selectCell:Select(false)
  end
  self.selectCell = cell
  self.selectCell:Select(true)
  TeamProxy.Instance:SetDiffServerJoinRoomStatus(self.onlyMatchMyServerObj, self.onlyMatchMyServerTog, self.onlyMatchMyServerTip, self:SupportDiffServer(), not self.btnMatchEnable)
end

function FreeBattleView:ClickButtonRule()
  local helpID = self.free6v6ModelTog.value and PanelConfig.FreeBattleView.id or 929
  local desc = Table_Help[helpID] and Table_Help[helpID].Desc or ZhString.Help_RuleDes
  TipsView.Me():ShowGeneralHelp(desc)
end

function FreeBattleView:ClickButtonMatch()
  if not self.selectCell or self.disableClick then
    return
  end
  local pvpcheckvalid = self.free6v6ModelTog.value and PvpProxy.Instance:CheckPwsMatchValid(true, self.selectCell.id) or PvpProxy.Instance:CheckMatchValid()
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

function FreeBattleView:SupportDiffServer()
  if not self.selectCell then
    return false
  end
  local raidId = self.selectCell.id
  return TeamProxy.Instance:CheckRaidIdSupportDiffServer(raidId) and not TeamProxy.Instance:ForbiddenByMatchRaidID(self.pwsConfig.matchid)
end

function FreeBattleView:CallMatch()
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

function FreeBattleView:OnExit()
  PictureManager.Instance:UnLoadPVP("12pvp_bg_pic4", self.free6v6Tex)
  PictureManager.Instance:UnLoadPVP("12pvp_bg_pic5", self.practiseModelTex)
  PictureManager.Instance:UnLoadPVP(multiPvpTexName, self.multiPvpTex)
  PictureManager.Instance:UnLoadPVP(JP_Eu_TexUp, self.jp_Eu_Tex)
  if self.ltDisableClick then
    self.ltDisableClick:Destroy()
    self.ltDisableClick = nil
  end
  FreeBattleView.super.OnExit(self)
end

function FreeBattleView:UpdateCustomRoomButton()
  if not self.createRoomLabel then
    return
  end
  local myRoomData = PvpCustomRoomProxy.Instance:GetCurrentRoomData()
  if myRoomData and myRoomData.pvptype == self.pvpType then
    self.createRoomLabel.text = ZhString.PvpCustomRoom_MyRoom
  else
    self.createRoomLabel.text = ZhString.PvpCustomRoom_CreateRoom
  end
end

function FreeBattleView:OnTabDisabled()
end
