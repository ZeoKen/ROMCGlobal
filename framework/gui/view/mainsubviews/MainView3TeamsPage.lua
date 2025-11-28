autoImport("MainView3TeamsScoreCell")
autoImport("MainView3TeamsTeamBoardCell")
autoImport("MainView3TeamsOBTeamBoardCell")
MainView3TeamsPage = class("MainView3TeamsPage", SubView)
local ComboStr = {
  [1] = ZhString.Triple_OneKill,
  [2] = ZhString.Triple_DoubleKill,
  [3] = ZhString.Triple_TripleKill,
  [4] = ZhString.Triple_FourKill,
  [5] = ZhString.Triple_FiveKill
}
local KillBoardBg = {
  [ETRIPLECAMP.ETRIPLE_CAMP_RED] = "pvp_bottom_1",
  [ETRIPLECAMP.ETRIPLE_CAMP_YELLOW] = "pvp_bottom_3",
  [ETRIPLECAMP.ETRIPLE_CAMP_BLUE] = "pvp_bottom_2",
  [ETRIPLECAMP.ETRIPLE_CAMP_GREEN] = "pvp_bottom_5"
}
local KillBoardHeadIconFrame = {
  [ETRIPLECAMP.ETRIPLE_CAMP_RED] = "pvp_bottom_7",
  [ETRIPLECAMP.ETRIPLE_CAMP_YELLOW] = "pvp_bottom_12",
  [ETRIPLECAMP.ETRIPLE_CAMP_BLUE] = "pvp_bottom_6",
  [ETRIPLECAMP.ETRIPLE_CAMP_GREEN] = "pvp_bottom_11"
}
local defeatBgName = "pvp_bottom_4"
local killBoardEffect = "ufx_pvp_3v3v3_kill_prf"
local OriginalHeight = 145
local extendHeight = {208, 200}

function MainView3TeamsPage:Init()
  self:InitView()
  self:InitData()
  self:FindObjs()
  self:AddListener()
end

function MainView3TeamsPage:InitView()
  local parent = self:FindGO("3TeamsPageRoot")
  self:ReLoadPerferb("view/MainView3TeamsPage")
  self.trans:SetParent(parent.transform, false)
  local parentPanel = Game.GameObjectUtil:FindCompInParents(parent, UIPanel)
  if parentPanel then
    local panel = self.gameObject:GetComponent(UIPanel)
    panel.depth = parentPanel.depth + 1
  end
end

function MainView3TeamsPage:FindObjs()
  self.scoreBoard = self:FindGO("ScoreBoard")
  self.remainTimeLabel = self:FindComponent("Title", UILabel, self.scoreBoard)
  local scoreGrid = self:FindComponent("ScoreGrid", UIGrid, self.scoreBoard)
  self.scoreListCtrl = UIGridListCtrl.new(scoreGrid, MainView3TeamsScoreCell, "MainView3TeamsScoreCell")
  self.detailBtn = self:FindGO("DetailButton", self.scoreBoard)
  self:AddClickEvent(self.detailBtn, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TripleTeamsDetailPopUp
    })
  end)
  self.killBoard = self:FindGO("KillBoard")
  self.killBoardTweener = self.killBoard:GetComponent(TweenScale)
  self.defeatTex = self:FindComponent("defeat", UITexture, self.killBoard)
  self.comboLabel = self:FindComponent("combo", UILabel, self.killBoard)
  self.comboTweener = self.comboLabel.gameObject:GetComponent(TweenScale)
  self.comboBgTweener = self:FindComponent("bg", TweenScale, self.killBoard)
  self.killerBg = self:FindComponent("KillerBg", UISprite, self.killBoard)
  self.killerNameLabel = self:FindComponent("name", UILabel, self.killerBg.gameObject)
  self.killerHeadIcon = self:FindGO("headIcon", self.killerBg.gameObject)
  self.killerHeadIconFrame = self:FindComponent("headIconFrame", UISprite, self.killerBg.gameObject)
  self.sufferBg = self:FindComponent("SufferBg", UISprite, self.killBoard)
  self.sufferNameLabel = self:FindComponent("name", UILabel, self.sufferBg.gameObject)
  self.sufferHeadIcon = self:FindGO("headIcon", self.sufferBg.gameObject)
  self.sufferHeadIconFrame = self:FindComponent("headIconFrame", UISprite, self.sufferBg.gameObject)
  self.effectContainer = self:FindGO("effectContainer")
  self.teamBoard = self:FindGO("TeamBoard")
  self.moveRoot = self:FindGO("MoveRoot", self.teamBoard)
  local showBtn = self:FindGO("btnShow", self.moveRoot)
  self:AddClickEvent(showBtn, function()
    self:OnTeamBoardShowBtnClick()
  end)
  self.teamBoardShowBtnArrow = self:FindComponent("arrow", UISprite, showBtn)
  self.teamBoardShowBtnArrow.flip = 1
  self.settingBtnGO = self:FindGO("SettingBtn")
  self.tipGO = self:FindGO("TipBg")
  self.tipLabel = self:FindComponent("Tip", UILabel, self.tipGO)
  local winScore = GameConfig.Triple and GameConfig.Triple.MaxScore
  self.tipLabel.text = string.format(ZhString.Triple_WinTip, winScore)
  self:AddClickEvent(self.settingBtnGO, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SetView
    })
  end)
  local teamsGrid = self:FindComponent("ListParent", UIGrid, self.teamBoard)
  local bg = self:FindComponent("bg", UISprite)
  local bg_1 = self:FindComponent("bg_1", UISprite)
  if not PvpObserveProxy.Instance:IsRunning() then
    self.teamsListCtrl = UIGridListCtrl.new(teamsGrid, MainView3TeamsTeamBoardCell, "MainView3TeamsTeamBoardCell")
    self.settingBtnGO:SetActive(false)
    self.tipGO:SetActive(true)
    bg.height = OriginalHeight
    bg_1.height = OriginalHeight
  else
    self.teamsListCtrl = UIGridListCtrl.new(teamsGrid, MainView3TeamsOBTeamBoardCell, "MainView3TeamsTeamBoardCell")
    self.settingBtnGO:SetActive(true)
    self.tipGO:SetActive(false)
    bg.height = extendHeight[1]
    bg_1.height = extendHeight[2]
  end
  self.killBoard:SetActive(false)
end

function MainView3TeamsPage:AddListener()
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdSyncTripleComboKillFuBenCmd, self.HandleComboKill)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdSyncTripleFireInfoFuBenCmd, self.HandleCampScoreChange)
  self:AddDispatcherEvt(SceneUserEvent.SceneAddRoles, self.HandleTeamMembersChange)
  self:AddDispatcherEvt(SceneUserEvent.SceneRemoveRoles, self.HandleTeamMembersChange)
  self:AddDispatcherEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddRobots)
  self:AddDispatcherEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveRobots)
  self:AddDispatcherEvt(ServiceEvent.NUserUserNineSyncCmd, self.HandleTeamMemberDataChange)
  self:AddDispatcherEvt(CreatureEvent.Hiding_Change, self.HandleTeamMemberHidingChange)
  self:AddDispatcherEvt(MyselfEvent.DeathStatus, self.HandleMyselfDeath)
  self:AddDispatcherEvt(PlayerEvent.DeathStatusChange, self.HandlePlayerDeath)
  self:AddDispatcherEvt(ServiceEvent.FuBenCmdObserverAttachFubenCmd, self.HandleAttachPlayer)
end

function MainView3TeamsPage:InitData()
  self.comboInfoQueue = {}
  self.headDatas = {}
  self.comboShowTime = 0
  self.minInterval = GameConfig.Triple.MinComboShowInterval
  self.maxInterval = GameConfig.Triple.MaxComboShowInterval
end

function MainView3TeamsPage:OnEnter()
  MainView3TeamsPage.super.OnEnter(self)
  PictureManager.Instance:SetTriplePvpTexture(defeatBgName, self.defeatTex)
  local remainTime = PvpProxy.Instance:GetTripleEndTime() - math.floor(ServerTime.CurServerTime() / 1000)
  self.countdown = TimeTickManager.Me():CreateTick(0, 1000, function()
    if remainTime < 0 then
      self:ClearCountdown()
      return
    end
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(remainTime)
    self.remainTimeLabel.text = string.format(ZhString.Triple_RemainTime, min, sec)
    remainTime = remainTime - 1
    self:OnKillBoardShow()
  end, self)
  self:UpdateScoreBoard()
  self:InitTeamBoard()
  for charid, _ in pairs(PvpProxy.Instance.tripleCampUserInfo) do
    local player = SceneCreatureProxy.FindCreature(charid)
    if player then
      local sceneUI = player:GetSceneUI()
      if sceneUI then
        sceneUI.roleBottomUI:HandleChangeTitle(player)
      end
      local headData = HeadImageData.new()
      headData:TransByLPlayer(player)
      self.headDatas[charid] = headData
    end
  end
end

function MainView3TeamsPage:OnExit()
  PictureManager.Instance:UnloadTriplePvpTexture(defeatBgName, self.defeatTex)
  self:ClearCountdown()
  TableUtility.ArrayClear(self.comboInfoQueue)
  TableUtility.TableClear(self.headDatas)
  self.comboShowTime = 0
  MainView3TeamsPage.super.OnExit(self)
end

function MainView3TeamsPage:OnKillBoardShow()
  if #self.comboInfoQueue > 0 then
    if not self.isKillBoardShown or self.comboShowTime >= self.minInterval then
      self:SetKillBoard()
      self:ShowKillBoard()
    end
    self.comboShowTime = self.comboShowTime + 1
  elseif self.isKillBoardShown then
    self.comboShowTime = self.comboShowTime + 1
    if self.comboShowTime >= self.maxInterval then
      self:HideKillBoard()
      self.comboShowTime = 0
    end
  end
end

function MainView3TeamsPage:InitTeamBoard()
  local datas = {}
  local camps = PvpProxy.Instance:GetTripleCampInfos()
  for i = 1, #camps do
    local data = camps[i]
    if data.camp ~= PvpProxy.Instance.myselfCamp then
      datas[#datas + 1] = data
    end
  end
  self.teamsListCtrl:ResetDatas(datas)
  self.isTeamBoardShow = true
end

local scoreSortFunc = function(l, r)
  if l.camp ~= PvpProxy.Instance.myselfCamp and r.camp ~= PvpProxy.Instance.myselfCamp then
    return l.camp > r.camp
  end
  return r.camp == PvpProxy.Instance.myselfCamp
end

function MainView3TeamsPage:UpdateScoreBoard()
  local datas = PvpProxy.Instance:GetTripleCampInfos(scoreSortFunc)
  self.scoreListCtrl:ResetDatas(datas)
end

function MainView3TeamsPage:ClearCountdown()
  if self.countdown then
    TimeTickManager.Me():ClearTick(self)
    self.countdown = nil
  end
end

function MainView3TeamsPage:HandleComboKill(data)
  if data then
    local info = {}
    info.killerInfo = {
      charid = data.killerinfo.charid,
      combo = data.killerinfo.combo or 0
    }
    info.sufferInfo = {
      charid = data.sufferinfo.charid,
      lifeKillNum = data.sufferinfo.lifekillnum or 0
    }
    self.comboInfoQueue[#self.comboInfoQueue + 1] = info
  end
end

function MainView3TeamsPage:HandleCampScoreChange(data)
  redlog("MainView3TeamsPage:HandleCampScoreChange", tostring(data and data.isfinish), tostring(data and data.isrelax))
  if data and data.isfinish then
    if data.isrelax then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TripleTeamsResultPopUp,
        viewdata = {
          winCamp = data.wincamp,
          mvpUserInfo = data.mvpuserinfo
        }
      })
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.TripleTeamsPwsResultPopUp,
        viewdata = {
          winCamp = data.wincamp,
          mvpUserInfo = data.mvpuserinfo
        }
      })
    end
  end
  self:UpdateScoreBoard()
end

function MainView3TeamsPage:HandleTeamMembersChange()
  local cells = self.teamsListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateTeamMembers()
  end
end

function MainView3TeamsPage:HandleAddRobots(npcs)
  local hasRobot = false
  if npcs then
    for i = 1, #npcs do
      if npcs[i].data.detailedType == NpcData.NpcDetailedType.TriplePvpRobot then
        hasRobot = true
        break
      end
    end
  end
  if hasRobot then
    self:HandleTeamMembersChange()
  end
end

function MainView3TeamsPage:HandleRemoveRobots()
  self:HandleTeamMembersChange()
end

function MainView3TeamsPage:HandleTeamMemberDataChange(data)
  if data then
    self:HandleTeamMemberHidingChange(data.guid)
  end
end

function MainView3TeamsPage:HandleTeamMemberHidingChange(guid)
  local user = PvpProxy.Instance:GetTripleUserInfo(guid)
  if user then
    local camp = user.camp
    local cells = self.teamsListCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].camp == camp then
        cells[i]:UpdateTeamMembers()
      end
    end
  end
end

function MainView3TeamsPage:ShowKillBoard()
  self.isKillBoardShown = true
  self.killBoard:SetActive(true)
  self.killBoardTweener:ResetToBeginning()
  self.killBoardTweener:PlayForward()
  self.comboTweener:ResetToBeginning()
  self.comboTweener:PlayForward()
  self.comboBgTweener:ResetToBeginning()
  self.comboBgTweener:PlayForward()
  self:PlayUIEffect(killBoardEffect, self.effectContainer, true)
end

function MainView3TeamsPage:HideKillBoard()
  self.isKillBoardShown = false
  self.killBoard:SetActive(false)
end

function MainView3TeamsPage:SetKillBoard()
  local info = table.remove(self.comboInfoQueue, 1)
  if info then
    local killerId = info.killerInfo.charid
    local sufferId = info.sufferInfo.charid
    local tripleKiller = PvpProxy.Instance:GetTripleUserInfo(killerId)
    local tripleSuffer = PvpProxy.Instance:GetTripleUserInfo(sufferId)
    if tripleKiller and tripleSuffer then
      self.killerBg.spriteName = KillBoardBg[tripleKiller.camp]
      self.sufferBg.spriteName = KillBoardBg[tripleSuffer.camp]
      self.killerHeadIconFrame.spriteName = KillBoardHeadIconFrame[tripleKiller.camp]
      self.sufferHeadIconFrame.spriteName = KillBoardHeadIconFrame[tripleSuffer.camp]
      if info.sufferInfo.lifeKillNum >= 3 and info.killerInfo.combo < 6 then
        self.comboLabel.text = ZhString.Triple_EndKill
      elseif info.killerInfo.combo >= 6 then
        self.comboLabel.text = ZhString.Triple_MadKill
      else
        self.comboLabel.text = ComboStr[info.killerInfo.combo]
      end
      if tripleKiller.hideName then
        self.killerNameLabel.text = FunctionAnonymous.Me():GetAnonymousName(tripleKiller.profession)
      else
        self.killerNameLabel.text = tripleKiller.username
      end
      if tripleSuffer.hideName then
        self.sufferNameLabel.text = FunctionAnonymous.Me():GetAnonymousName(tripleSuffer.profession)
      else
        self.sufferNameLabel.text = tripleSuffer.username
      end
      if not self.killerHeadCell then
        self.killerHeadCell = KillBoardHeadCell.new(self.killerHeadIcon)
      end
      local killerHeadData = self.headDatas[killerId]
      if killerHeadData then
        self.killerHeadCell:SetData(killerHeadData)
      end
      if not self.sufferHeadCell then
        self.sufferHeadCell = KillBoardHeadCell.new(self.sufferHeadIcon)
      end
      local sufferHeadData = self.headDatas[sufferId]
      if sufferHeadData then
        self.sufferHeadCell:SetData(sufferHeadData)
      end
    end
  end
end

local TeamBoardHidePosX = -218

function MainView3TeamsPage:OnTeamBoardShowBtnClick()
  self.isTeamBoardShow = not self.isTeamBoardShow
  local pos = self.isTeamBoardShow and LuaGeometry.GetTempVector3(0, 115, 0) or LuaGeometry.GetTempVector3(TeamBoardHidePosX, 115, 0)
  TweenPosition.Begin(self.moveRoot, 0.2, pos)
  self.teamBoardShowBtnArrow.flip = self.isTeamBoardShow and 1 or 0
end

function MainView3TeamsPage:HandleMyselfDeath()
  if Game.Myself:IsDead() then
    self:HandleRoleDeath(Game.Myself)
  end
end

function MainView3TeamsPage:HandlePlayerDeath(player)
  if player and player:IsDead() then
    self:HandleRoleDeath(player)
  end
end

function MainView3TeamsPage:HandleRoleDeath(role)
  if role.assetRole then
    role.assetRole:PlayEffectOneShotOn(EffectMap.Maps.TripleTeamsPlayerDeath, RoleDefines_EP.Bottom)
  end
end

function MainView3TeamsPage:HandleAttachPlayer(data)
  if not PvpObserveProxy.Instance:IsRunning() then
    return
  end
  local attachPlayerId = PvpObserveProxy.Instance:GetAttachPlayer()
  local cells = self:GetCells()
  local listcells = self.teamsListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:UpdateAttach(attachPlayerId)
  end
end

function MainView3TeamsPage:GetCells()
  local cells = {}
  local listcells = self.teamsListCtrl:GetCells()
  for i = 1, #listcells do
    local list = listcells[i]:GetCells()
    for j = 1, #list do
      cells[#cells + 1] = list[j]
    end
  end
  return cells
end

KillBoardHeadCell = class("KillBoardHeadCell", BaseCell)

function KillBoardHeadCell:Init()
  self:FindObjs()
  self:InitHeadIconCell()
end

function KillBoardHeadCell:FindObjs()
  self.professionIcon = self:FindComponent("professionIcon", UISprite)
  self.colorBg = self:FindComponent("colorBg", UISprite)
end

function KillBoardHeadCell:InitHeadIconCell()
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(2)
  self.headIconCell:SetScale(0.7)
end

function KillBoardHeadCell:SetData(data)
  local proData = Table_Class[data.profession]
  if proData then
    IconManager:SetNewProfessionIcon(proData.icon, self.professionIcon)
    local colorKey = "CareerIconBg" .. proData.Type
    local color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
    self.colorBg.color = color
  end
  if data.iconData then
    if data.iconData.type == HeadImageIconType.Avatar then
      self.headIconCell:SetData(data.iconData)
    elseif data.iconData.type == HeadImageIconType.Simple then
      self.headIconCell:SetSimpleIcon(data.iconData.icon, data.iconData.frameType, data.iconData.isMyself)
    end
    self.headIconCell:SetPortraitFrame()
  end
end
