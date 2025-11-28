LeisureModelView = class("LeisureModelView", SubView)
local view_Path = ResourcePathHelper.UIView("LeisureModelView")
local PVPTYPE
local TOTAL_WEEKCOIN = GameConfig.TwelvePvp.CoinWeekMax or 30
local ActivityID

function LeisureModelView:Init()
  local matchRaidID = GameConfig.TwelvePvp and GameConfig.TwelvePvp.MatchConfig and GameConfig.TwelvePvp.MatchConfig.Leisure_MatchRaidID or 101001
  self.raidConfig = Table_MatchRaid[matchRaidID]
  PVPTYPE = PvpProxy.Type.TwelvePVPBattle
  ActivityID = GameConfig.TwelvePvp and GameConfig.TwelvePvp.ActivityID or 725
  self:FindObjs()
  self:AddUIEvts()
  self:AddViewEvts()
end

function LeisureModelView:UpdateView()
  self:UpdateMatchBtn()
end

function LeisureModelView:FindObjs()
  self:LoadPrafab()
  self.matchBtn = self:FindGO("MatchBtn", self.objRoot)
  self.matchSp = self.matchBtn:GetComponent(UISprite)
  self.colBtnMatch = self.matchBtn:GetComponent(BoxCollider)
  self.matchBtnLabel = self:FindComponent("Label", UILabel, self.matchBtn)
  self.rewardDetail = self:FindGO("RewardDetail", self.objRoot)
  self.ownLab = self:FindComponent("OwnLab", UILabel, self.objRoot)
  self.iconSp = self:FindComponent("Icon", UISprite, self.ownLab.gameObject)
  IconManager:SetItemIcon("item_5924", self.iconSp)
  self.raidTex = self:FindComponent("RaidTex", UITexture, self.objRoot)
  PictureManager.Instance:SetPVP("pvp_dungeon_7046", self.raidTex)
  self.raidDesc = self:FindComponent("RaidDesc", UILabel, self.raidTex.gameObject)
  self.raidDesc.text = ZhString.TwelvePVP_TabName
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("Num", UILabel, self.multiplySymbol)
  self:UpdateOwnLab()
  self:_initDiffServerMatch()
  self.freeFireTipBtn = self:FindGO("FreeFireBtn", self.objRoot)
  if self.freeFireTipBtn then
    self:RegistShowGeneralHelpByHelpID(32599, self.freeFireTipBtn)
  end
end

function LeisureModelView:_initDiffServerMatch()
  self.onlyMatchMyServerObj = self:FindGO("OnlyMatchMyServer")
  self.onlyMatchMyServerTog = self:FindComponent("Tog", UIToggle, self.onlyMatchMyServerObj)
  self.onlyMatchMyServerLab = self:FindComponent("Label", UILabel, self.onlyMatchMyServerObj)
  self.onlyMatchMyServerLab.text = ZhString.TeamFindPopUp_OnlyMatchMyServer
  self.onlyMatchMyServerTog.value = false
  self.onlyMatchMyServerTip = self:FindGO("Tip", self.onlyMatchMyServerObj)
  self:RegistShowGeneralHelpByHelpID(101, self.onlyMatchMyServerTip)
end

function LeisureModelView:LoadPrafab()
  self.objRoot = self:FindGO("LeisureModelView")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.objRoot, true)
  obj.name = "LeisureModelView"
end

function LeisureModelView:AddUIEvts()
  self:AddClickEvent(self.matchBtn, function(go)
    self:OnMatchBtn()
  end)
  self:AddClickEvent(self.rewardDetail, function(go)
    self:OnRewardDetail()
  end)
end

function LeisureModelView:UpdateOwnLab()
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(AERewardType.TwelvePvP)
  local own, total = MyselfProxy.Instance:GetTwelvePvpCoin()
  local multiply = rewardInfo and rewardInfo:GetMultiple()
  if multiply and 1 < multiply then
    total = TOTAL_WEEKCOIN * multiply
    self.multiplySymbol_label.text = "*" .. tostring(multiply)
    self.multiplySymbol:SetActive(true)
  else
    total = TOTAL_WEEKCOIN
    self.multiplySymbol:SetActive(false)
  end
  self.ownLab.text = string.format(ZhString.TwelvePVP_OwnTip, own, total)
end

function LeisureModelView:OnRewardDetail()
  ServiceFuBenCmdProxy.Instance:CallTwelvePvpQuestQueryCmd()
end

function LeisureModelView:OnEnter()
  LeisureModelView.super.OnEnter(self)
end

function LeisureModelView:OnExit()
  LeisureModelView.super.OnExit(self)
end

function LeisureModelView:OnDestroy()
  LeisureModelView.super.OnDestroy(self)
end

local COLOR = {
  Color(0 / 255, 0.33725490196078434, 0.08627450980392157, 1),
  Color(0.4980392156862745, 0.4980392156862745, 0.4980392156862745, 1)
}

function LeisureModelView:UpdateMatchBtn()
  local x = TeamPwsView.InOtherGameMode()
  local btnMatchEnable = FunctionActivity.Me():IsActivityRunning(ActivityID)
  if btnMatchEnable then
    local matchStatus = PvpProxy.Instance:GetMatchState(PVPTYPE)
    local freeBattleMatchStatus = PvpProxy.Instance:GetMatchState(PVPTYPE)
    if matchStatus and matchStatus.ismatch or freeBattleMatchStatus and freeBattleMatchStatus.ismatch or TeamPwsView.InOtherGameMode() or PvpProxy.Instance.inviteMap then
      btnMatchEnable = false
    end
  end
  self.colBtnMatch.enabled = btnMatchEnable
  if btnMatchEnable then
    self:SetTextureWhite(self.matchSp)
  else
    self:SetTextureGrey(self.matchSp)
  end
  self.matchBtnLabel.effectColor = btnMatchEnable and COLOR[1] or COLOR[2]
  local serverMerge = self:SupportDiffServer()
  TeamProxy.Instance:SetDiffServerJoinRoomStatus(self.onlyMatchMyServerObj, self.onlyMatchMyServerTog, self.onlyMatchMyServerTip, serverMerge, not btnMatchEnable)
end

function LeisureModelView:SupportDiffServer()
  local raidId = self.raidConfig.RaidConfigID
  return TeamProxy.Instance:CheckRaidIdSupportDiffServer(raidId) and not TeamProxy.Instance:ForbiddenByMatchRaidID(self.raidConfig.id)
end

function LeisureModelView:OnMatchBtn()
  if not TeamProxy.Instance:CheckMatchValid(self.raidConfig) then
    return
  end
  if not PvpProxy.Instance:CheckMatchValid() then
    return
  end
  local raidCfgId = self.raidConfig.RaidConfigID
  local _teamPy = TeamProxy.Instance
  if _teamPy:ForbiddenByRaidID(raidCfgId) or _teamPy:ForbiddenByMatchRaidID(self.raidConfig.id) then
    MsgManager.ShowMsgByID(42041)
    return
  end
  ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PVPTYPE, raidCfgId, nil, true, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, self.onlyMatchMyServerTog.value)
  self.container:CloseSelf()
end

function LeisureModelView:AddViewEvts()
  self:AddListenEvt(MyselfEvent.TwelvePvpCoinChange, self.UpdateOwnLab)
  self:AddListenEvt(ServiceEvent.MatchCCmdJoinRoomCCmd, self.RecvJoinRoom)
  self:AddListenEvt(LoadSceneEvent.FinishLoad, self.UpdateMatchBtn)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateMatchBtn)
end

function LeisureModelView:RecvJoinRoom(note)
  local data = note.body
  if data and data.type == PVPTYPE and data.ret then
    self.container:CloseSelf()
  end
end
