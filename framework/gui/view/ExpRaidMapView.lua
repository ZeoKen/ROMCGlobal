ExpRaidMapView = class("ExpRaidMapView", BaseView)
ExpRaidMapView.ViewType = UIViewType.InterstitialLayer
local expIns

function ExpRaidMapView:Init()
  if not expIns then
    expIns = ExpRaidProxy.Instance
  end
  self:AddListenEvts()
  self:FindObjs()
  self:InitShow()
  self:AddEvents()
end

function ExpRaidMapView:AddListenEvts()
  self:AddListenEvt(PVEEvent.ExpRaid_Launch, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.MatchCCmdNtfMatchInfoCCmd, self.UpdateMatchingBtn)
  self:AddListenEvt(ServiceEvent.MatchCCmdTeamPwsPreInfoMatchCCmd, self.UpdateMatchingBtn)
  self:AddListenEvt(ServiceEvent.FuBenCmdTeamExpQueryInfoFubenCmd, self.OnExpQueryInfo)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.OnBattleTimelen)
end

function ExpRaidMapView:FindObjs()
  self.timesLeftLabel = self:FindComponent("TimesLeftLabel", UILabel)
  self.mapBgTex = self:FindComponent("MapBg", UITexture)
  self.contentParentTrans = self:FindComponent("Content", Transform)
  self.matchingBtn = self:FindGO("MatchingBtn")
  self.matchingCountdown = self:FindComponent("CountdownCircle", UISprite, self.matchingBtn)
  self.raidDataArray = expIns:GetExpRaidDataArray()
  self.raidIdCellArr = {}
  self.raidIdCellMap = {}
  local cellGO
  for i = 1, #self.raidDataArray do
    cellGO = self:FindGO("ExpRaidMapCell" .. i)
    if not cellGO then
      LogUtility.ErrorFormat("Cannot find ExpRaidMapCell{0}", i)
      return
    end
    self:SetOutlineOfCellActive(cellGO, false)
    TableUtility.ArrayPushBack(self.raidIdCellArr, cellGO)
    self.raidIdCellMap[self.raidDataArray[i].id] = cellGO
  end
  self:RegistShowGeneralHelpByHelpID(928, self:FindGO("HelpButton"))
end

function ExpRaidMapView:InitShow()
  self.timesLeftLabel.text = ""
  self.contentParentTrans.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  local selfLevel = MyselfProxy.Instance:RoleLevel()
  local isShow, cell, lvLabel, recommendLv
  for i = 1, #self.raidDataArray do
    local raidData = self.raidDataArray[i]
    isShow = selfLevel >= raidData.Level
    cell = self.raidIdCellMap[raidData.id]
    cell:SetActive(isShow)
    lvLabel = self:FindComponent("LvLabel", UILabel, cell)
    recommendLv = raidData.RecommendLv
    if not recommendLv or not next(recommendLv) then
      LogUtility.WarningFormat("Cannot find RecommendLv of ExpRaid id={0}", raidData.id)
      return
    end
    lvLabel.text = string.format(ZhString.ExpRaid_MapCellLvLabel, recommendLv[1], recommendLv[2] or 0)
  end
  self:SelectCell(expIns:GetRaidIdWithSuitableLevel(selfLevel))
  self:UpdateMatchingBtn()
end

function ExpRaidMapView:AddEvents()
  for id, cell in pairs(self.raidIdCellMap) do
    self:AddClickEvent(cell, function()
      self:SelectCell(id)
      self:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ExpRaidDetailView,
        viewdata = id
      })
    end)
  end
  self:AddClickEvent(self.matchingBtn, function()
    local status, etype = PvpProxy.Instance:GetCurMatchStatus()
    if status then
      if status.isprepare then
        MatchPreparePopUp.Show(etype)
      elseif status.ismatch then
        TeamPwsMatchPopUp.Show(etype)
      end
    else
      LogUtility.Error("未找到匹配状态信息！")
      self:UpdateMatchingBtn()
    end
  end)
end

function ExpRaidMapView:OnEnter()
  ExpRaidMapView.super.OnEnter(self)
  self.mapBgTexName = "fb_map"
  PictureManager.Instance:SetMap(self.mapBgTexName, self.mapBgTex)
  self:LoadMapCellTextures()
  if self.matchingBtn then
    self.exTeamPwsMatchPopUpAnchor = TeamPwsMatchPopUp.Anchor
    self.exMatchPreparePopUpAnchor = MatchPreparePopUp.Anchor
    TeamPwsMatchPopUp.Anchor = self.matchingBtn.transform
    MatchPreparePopUp.Anchor = self.matchingBtn.transform
  end
  BattleTimeDataProxy.QueryBattleTimelenUserCmd()
end

function ExpRaidMapView:OnExit()
  PictureManager.Instance:UnLoadMap(self.mapBgTexName, self.mapBgTex)
  self:UnloadMapCellTextures()
  if self.matchingBtn then
    TeamPwsMatchPopUp.Anchor = self.exTeamPwsMatchPopUpAnchor
    MatchPreparePopUp.Anchor = self.exMatchPreparePopUpAnchor
  end
  TipsView.Me():HideCurrent()
  TimeTickManager.Me():ClearTick(self)
  self:sendNotification(ExpRaidEvent.MapViewClose)
  ExpRaidMapView.super.OnExit(self)
end

function ExpRaidMapView:OnBattleTimelen(note)
  self.battleTimelenReceived = true
  self:TryCheckBattleTimelenAndRemainingTimes()
end

function ExpRaidMapView:SelectCell(id)
  if self.selectedCellId then
    if id == self.selectedCellId then
      return
    end
    local selectedCell = self.raidIdCellMap[self.selectedCellId]
    selectedCell.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    self:SetOutlineOfCellActive(selectedCell, false)
  end
  if not self.raidIdCellMap[id] then
    LogUtility.WarningFormat("Cannot find ExpRaidCell with id:{0}", id)
    return
  end
  self.selectedCellId = id
  self.raidIdCellMap[id].transform.localScale = LuaGeometry.GetTempVector3(1.2, 1.2, 1.2)
  self:SetOutlineOfCellActive(self.raidIdCellMap[id], true)
end

function ExpRaidMapView:SetOutlineOfCellActive(cellGO, isActive)
  local outlineGO = self:FindGO("Outline", cellGO)
  outlineGO:SetActive(isActive)
end

function ExpRaidMapView:UpdateMatchingBtn()
  self.matchingBtn:SetActive(expIns:CheckIsMatching())
  local matchStatus = PvpProxy.Instance:GetCurMatchStatus()
  if not matchStatus then
    if self.tick then
      self:ClearTick()
    end
    return
  end
  self.matchingCountdown.gameObject:SetActive(matchStatus.isprepare or false)
  if matchStatus.isprepare and not self.tick then
    self.startPrepareTime = PvpProxy.Instance:GetTeamPwsPreStartTime()
    if self.startPrepareTime then
      self.tick = TimeTickManager.Me():CreateTick(0, 33, self.UpdateCountdown, self)
    else
      self.matchingCountdown.fillAmount = 0
    end
  end
end

function ExpRaidMapView:UpdateCountdown()
  local curTime = (ServerTime.CurServerTime() - self.startPrepareTime) / 1000
  local leftTime = math.max(GameConfig.teamPVP.Countdown - curTime, 0)
  self.matchingCountdown.fillAmount = leftTime / GameConfig.teamPVP.Countdown
  if leftTime == 0 then
    self:ClearTick()
  end
end

function ExpRaidMapView:OnExpQueryInfo()
  local remainingCount, totalCount = expIns:GetExpRaidTimesLeft()
  self.timesLeftLabel.text = string.format(ZhString.ExpRaid_TimesLeft, remainingCount, totalCount)
  self.expRaidTimesReceived = true
  self:TryCheckBattleTimelenAndRemainingTimes()
end

function ExpRaidMapView:ClearTick()
  TimeTickManager.Me():ClearTick(self)
  self.tick = nil
end

function ExpRaidMapView:TryCheckBattleTimelenAndRemainingTimes()
  if not self.battleTimelenReceived or not self.expRaidTimesReceived then
    return
  end
  if not expIns:CheckBattleTimelenAndRemainingTimes() then
    MsgManager.ShowMsgByID(28021)
  end
end

local mapCellTexNames = {
  "fb_building_forest",
  "fb_building_seabed",
  "fb_building_desert",
  "fb_building_MountainRange",
  "fb_building_AncientCity",
  "fb_building_BellTower",
  "fb_building_ToyIsland",
  "fb_building_JunoField"
}
local mapCellTexOutlineNameSuffix = "_select"
local loadMapCellTextures = function(i, tex, texOutline)
  PictureManager.Instance:SetExpRaid(mapCellTexNames[i], tex)
  PictureManager.Instance:SetExpRaid(mapCellTexNames[i] .. mapCellTexOutlineNameSuffix, texOutline)
  tex:MakePixelPerfect()
  texOutline:MakePixelPerfect()
end

function ExpRaidMapView:LoadMapCellTextures()
  self:_ForEachTexOfMapCell(loadMapCellTextures)
end

local unloadMapCellTextures = function(i, tex, texOutline)
  PictureManager.Instance:UnLoadExpRaid(mapCellTexNames[i], tex)
  PictureManager.Instance:UnLoadExpRaid(mapCellTexNames[i] .. mapCellTexOutlineNameSuffix, texOutline)
  tex:MakePixelPerfect()
  texOutline:MakePixelPerfect()
end

function ExpRaidMapView:UnloadMapCellTextures()
  self:_ForEachTexOfMapCell(unloadMapCellTextures)
end

function ExpRaidMapView:_ForEachTexOfMapCell(action)
  local cellGO, tex, texOutline
  for i = 1, #self.raidIdCellArr do
    cellGO = self.raidIdCellArr[i]
    tex = self:FindComponent("Tex", UITexture, cellGO)
    texOutline = self:FindComponent("Outline", UITexture, cellGO)
    if not tex or not texOutline then
      LogUtility.ErrorFormat("Cannot find texture component of ExpRaidCell{0}", i)
      return
    end
    action(i, tex, texOutline)
  end
end
