autoImport("MainViewAimMonsterCell")
MainViewAutoAimMonster = class("MainViewAutoAimMonster", SubView)
local MaxAfkDuration
local _SqrDistance = LuaVector3.Distance_Square
local _BattleTimeData

function MainViewAutoAimMonster:Init()
  _BattleTimeData = BattleTimeDataProxy.Instance
  if not ISNoviceServerType then
    MaxAfkDuration = GameConfig.Afk and math.ceil(GameConfig.Afk.max_battle_time / 60) or 900
  else
    MaxAfkDuration = GameConfig.Afk and GameConfig.Afk.max_battle_time or 10000
  end
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:RegisterGuide()
  self:InitShow()
end

function MainViewAutoAimMonster:FindObj()
  local BeforePanel = self:FindGO("BeforePanel")
  local Anchor_DownRight = self:FindGO("Anchor_DownRight", BeforePanel)
  self.autoAimMonster = self:LoadPreferb("view/MainViewAutoAimMonster", Anchor_DownRight, true)
  self.autoFightBtn = self:FindGO("AutoBattleButton")
  self.autoFightBg = self:FindComponent("Sprite", UISprite, self.autoFightBtn)
  self.autoFight = self:FindGO("Auto", self.autoFightBtn)
  self.autoAim = self:FindGO("AutoAim", self.autoFightBtn)
  self.autoBattleBtnSps = self:FindComponent("AutoBattleBg", UISprite, self.autoFightBtn)
  self.autoFightTip = self:FindComponent("Label", UILabel, self.autoFightBtn)
  self.selectTargetBtn = self:FindGO("SelectTargetBtn")
  self.bgGo = self:FindGO("Bg", self.autoAimMonster)
  self.bg = self.bgGo:GetComponent(UISprite)
  self.afkBgGo = self:FindGO("AfkBg", self.autoAimMonster)
  self.afkBg = self.afkBgGo:GetComponent(UISprite)
  self.contentTable = self:FindGO("Content", self.autoAimMonster):GetComponent(UITable)
  self.toggleRow1Go = self:FindGO("ToggleRow1", self.autoAimMonster)
  self.protectToggle = self:FindGO("ProtectToggle", self.toggleRow1Go):GetComponent(UIToggle)
  self.stayToggle = self:FindGO("StayToggle", self.toggleRow1Go):GetComponent(UIToggle)
  self.toggleRow2Go = self:FindGO("ToggleRow2")
  self.sweepBtn = self:FindGO("SweepBtn", self.toggleRow2Go)
  self.sweepCheckmark = self:FindGO("Checkmark", self.sweepBtn)
  self.afkRow1Go = self:FindGO("AfkRow1", self.autoAimMonster)
  self.afkToggleGo = self:FindGO("AfkToggle", self.afkRow1Go)
  self.afkToggle = self.afkToggleGo:GetComponent("UIToggle")
  self.afkBuyGo = self:FindGO("BuyLabel", self.afkRow1Go)
  self.afkBuyLabel = self.afkBuyGo:GetComponent(UILabel)
  self.afkBuyLabel.text = ISNoviceServerType and ZhString.Afk_Novice_Lock or ZhString.Afk_BuyMonthCard
  self.afkTimeGo = self:FindGO("TimeLabel", self.afkRow1Go)
  self.afkTimeLabel = self.afkTimeGo:GetComponent(UILabel)
  self.afkRowFollowerGO = self:FindGO("AfkRowFollower", self.autoAimMonster)
  self.afkRowFollower = self.afkRowFollowerGO:GetComponent(UIWidget)
  self.afkRow2Go = self:FindGO("AfkRow2", self.afkRowFollowerGO)
  self.descLabel = self:FindGO("DescLabel", self.afkRow2Go):GetComponent(UILabel)
  self.descLabel.text = ISNoviceServerType and ZhString.Afk_SetTip_Unit or ZhString.Afk_SetTip
  self.afkDurationInput = self:FindGO("AfkDurationInput", self.afkRow2Go):GetComponent(UIInput)
  self.unitLabel = self:FindGO("UnitLabel", self.afkRow2Go):GetComponent(UILabel)
  self.unitLabel.text = ISNoviceServerType and ZhString.Afk_Novice_Unit or ZhString.Afk_Unit
  self.afkRow3Go = self:FindGO("AfkRow3", self.afkRowFollowerGO)
  self.afkStartGo = self:FindGO("AfkStartBtn", self.afkRow3Go)
  self.afkRowPlaceholderGO = self:FindGO("AfkRowPlaceholder", self.autoAimMonster)
  self.afkRowPlaceholder = self.afkRowPlaceholderGO:GetComponent(UIWidget)
  self.fullAfkRowHeight = self.afkRowPlaceholder.height
  self.selectTargetTime = 0
  self.lastCheckPos = LuaVector3.Zero()
  local titleGroup = self:FindGO("TitleGroup")
  self.autoHealingSetBtn = self:FindGO("autoHealingSetBtn", titleGroup)
end

function MainViewAutoAimMonster:AddButtonEvt()
  local closeButton = self:FindGO("CloseButton", self.autoAimMonster)
  self:AddClickEvent(closeButton, function(go)
    self:SelfClose()
  end)
  self:AddButtonEvent("autoHealingSetBtn", function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.SetAutoHealingView
    })
  end)
  self.closecomp = self.autoAimMonster:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:SelfClose()
  end
  
  self:AddOrRemoveGuideId(self.autoFightBtn, 150)
  self:AddClickEvent(self.autoFightBtn, function()
    if self:IsShowView() then
      self:SelfClose()
    else
      local myself = Game.Myself
      local isHanding, handowner = myself:IsHandInHand()
      local isAuto = Game.AutoBattleManager.on
      if not isHanding or handowner == true then
        if isAuto then
          self.isSweep = false
          Game.AutoBattleManager:AutoBattleOff()
          myself:Client_SetAutoBattle(false)
          myself:Client_SetAutoEndlessTowerSweep(self.isSweep)
          self:ClearChooseAll()
        elseif myself:Client_GetFollowLeaderID() ~= 0 then
          Game.AutoBattleManager:AutoBattleOn()
        elseif SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.SkillId) then
          self:ShowView(true)
          ServiceLoginUserCmdProxy.Instance:CallOfflineDetectPosEvent(281)
        end
      end
    end
  end)
  local autoFightLongPress = self.autoFightBtn:GetComponent(UILongPress)
  
  function autoFightLongPress.pressEvent(obj, state)
    if state and SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.SkillId) then
      self:ShowView(true)
    end
  end
  
  self:AddClickEvent(self.sweepBtn, function()
    if Game.Myself:Client_GetFollowLeaderID() ~= 0 then
      MsgManager.ShowMsgByID(3433)
      return
    end
    self.isSweep = not self.isSweep
    self:UpdateSweepCheckmark(self.isSweep)
    if self.isSweep then
      self:SelfClose()
    end
  end)
  self:AddClickEvent(self.selectTargetBtn, function()
    self:DoSelectTarget()
  end)
  self:AddClickEvent(self.stayToggle.gameObject, function(go)
    Game.Myself:Client_SetAutoBattleStanding(self.stayToggle.value)
  end)
  self:AddClickEvent(self.afkToggleGo, function()
    self:OnAfkToggleClicked()
  end)
  self:AddClickEvent(self.afkBuyGo, function()
    self:OnAfkBuyClicked()
  end)
  EventDelegate.Add(self.afkDurationInput.onChange, function()
    self:OnAfkDurationChanged()
  end)
  self:AddClickEvent(self.afkStartGo, function()
    self:OnStartAfkClicked()
  end)
end

function MainViewAutoAimMonster:AddViewEvt()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.UpdateInfo)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.UpdateInfo)
  self:AddDispatcherEvt(AutoBattleManagerEvent.StateChanged, self.HandleStateChanged)
  self:AddDispatcherEvt(AutoBattleManagerEvent.RefreshStatus, self.HandleRefreshStatus)
  self:AddListenEvt(GuideEvent.ShowAutoFightBubble, self.HandleGuideBubbleTip)
  self:AddListenEvt(SkillEvent.SkillUpdate, self.UpdateSkill)
  self:AddListenEvt(PVPEvent.TeamTwelve_ShutDown, self.StopTwevelPVPTick)
  self:AddListenEvt(ServiceEvent.UserAfkCmdRetAfkUserAfkCmd, self.OnRecvAfkResult)
  self:AddListenEvt(ServiceEvent.NUserBattleTimelenUserCmd, self.OnRecvBattleTime)
  self:AddListenEvt(MyselfEvent.ExitSniperMode, self.OnExitSniperMode)
  self:AddListenEvt(PVEEvent.DemoRaid_Launch, self.OnDemoRaidLaunch)
  self:AddListenEvt(PVEEvent.DemoRaidRaid_Shutdown, self.OnDemoRaidShutdown)
  self:AddListenEvt(HotKeyEvent.AimMonsterSelectTarget, self.DoSelectTarget)
  self:AddListenEvt(HotKeyEvent.OpenAutoBattleConfig, self.DoShowView)
end

function MainViewAutoAimMonster:InitShow()
  self.isShowSweep = nil
  self.isSweep = false
  local container = self:FindGO("Container", self.contentTable.gameObject)
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 20,
    cellName = "MainViewAimMonsterCell",
    control = MainViewAimMonsterCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  self.itemWrapHelper:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  EventManager.Me():AddEventListener(MainViewAimMonsterCellEvent.BossCellHasSet, self.HandleBossCellHasSet, self)
  self:UpdateAutoBattle()
  local isProtect, isStay = false, false
  self.save_str = LocalSaveProxy.Instance:GetMainViewAutoAimMonster()
  local history = string.split(self.save_str, "_")
  if #history == 2 then
    isProtect = history[1]
  end
  self.protectToggle.value = tonumber(isProtect) == 1
  self.stayToggle.value = tonumber(isStay) == 1
  self:UpdateSkill()
  self:UpdateAfkPanel()
  self:ShowView(false)
  self:QueryBattleTime()
  self:RegisterHotKeyTips()
end

function MainViewAutoAimMonster:RegisterHotKeyTips()
  local parent = self:FindComponent("openSelect", UISprite, self.selectTargetBtn)
  Game.HotKeyTipManager:RegisterHotKeyTip(14, parent, NGUIUtil.AnchorSide.Top)
  Game.HotKeyTipManager:RegisterHotKeyTip(15, self.autoFightBg, NGUIUtil.AnchorSide.TopLeft, {12, -14})
end

function MainViewAutoAimMonster:HandleBossCellHasSet(param)
  if self:IsShowView() and not AAAManager.Me():IsCmiOn() then
    AAAManager.Me():StartCmi()
  end
end

function MainViewAutoAimMonster:OnExit()
  EventManager.Me():RemoveEventListener(MainViewAimMonsterCellEvent.BossCellHasSet, self.HandleBossCellHasSet, self)
  self.afkDurationInput = nil
  MainViewAutoAimMonster.super.OnExit(self)
end

local infoList = {}
local mvpMiniIndexMap = {}

function MainViewAutoAimMonster:UpdateInfo()
  if not self:IsShowView() then
    return
  end
  if Game.MapManager:IsPvPMode_TeamTwelve() then
    return
  end
  local functionMonster = FunctionMonster.Me()
  local _, hasMvpOrMini = functionMonster:FilterMonsterStaticInfo()
  if not hasMvpOrMini then
    AAAManager.Me():ClearCmi()
  end
  TableUtility.ArrayClear(infoList)
  TableUtility.ArrayShallowCopy(infoList, functionMonster:SortMonsterStaticInfo())
  if not next(mvpMiniIndexMap) then
    self:ShuffleMvpMini(infoList)
  else
    self:MaintainMvpMiniIndex(infoList)
  end
  local all = AutoAimMonsterData.new()
  all:SetId(0)
  all.showToggle = true
  TableUtility.ArrayPushFront(infoList, all)
  self.itemWrapHelper:UpdateInfo(infoList)
  if #infoList <= 5 then
    self.itemWrapHelper:ResetPosition()
  end
  self:UpdateAutoBattle()
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  for i = 2, #cellCtls do
    local id = cellCtls[i].data and cellCtls[i].data:GetId() or 0
    if self.currentIds and self.currentIds[id] then
      cellCtls[i]:SetChoose(true)
    else
      cellCtls[i]:SetChoose(false)
    end
  end
  self:UpdateSweep()
  self:UpdateSweepCheckmark(self.isSweep)
end

function MainViewAutoAimMonster:IsChooseAll()
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  if cellCtls and 0 < #cellCtls then
    return cellCtls[1]:GetChooseValue()
  end
  return false
end

function MainViewAutoAimMonster:SetChooseAll(chooseAll)
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  if cellCtls and 0 < #cellCtls then
    cellCtls[1]:SetChoose(chooseAll)
  end
end

function MainViewAutoAimMonster:ClearChooseAll()
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  if cellCtls and 0 < #cellCtls then
    cellCtls[1]:SetChoose(false)
  end
end

function MainViewAutoAimMonster:ClearChooseOthers()
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  for i = 2, #cellCtls do
    cellCtls[i]:SetChoose(false)
  end
end

function MainViewAutoAimMonster:StopAutoBattle()
  self.isSweep = false
  Game.AutoBattleManager:AutoBattleOff()
  local myself = Game.Myself
  myself:Client_SetAutoBattle(false)
  myself:Client_SetAutoEndlessTowerSweep(false)
  self:UpdateSweepCheckmark(self.isSweep)
end

function MainViewAutoAimMonster:HandleClickItem(cellctl)
  if SkillProxy.Instance:GetRandomSkillID() ~= nil then
    MsgManager.ShowMsgByID(41155)
    return
  end
  if cellctl.data then
    local value = cellctl:GetChooseValue()
    local newValue = not value
    cellctl:SetChoose(newValue)
    local currentId = cellctl.data:GetId()
    if currentId == 0 then
      if newValue then
        Game.Myself:Client_AutoBattleLost()
        Game.AutoBattleManager:AutoBattleOn()
        self:ClearChooseOthers()
        if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance:GetCurrentEquipedAutoSkills()) then
          MsgManager.DontAgainConfirmMsgByID(1712)
        end
      else
        self:StopAutoBattle()
      end
    else
      local myself = Game.Myself
      if self:IsChooseAll() then
        self:ClearChooseAll()
      end
      if value then
        myself:Client_UnSetAutoBattleLockID(currentId)
      elseif myself:Client_GetFollowLeaderID() ~= 0 then
        MsgManager.ShowMsgByID(1713)
      else
        MsgManager.FloatMsg(nil, string.format(ZhString.AutoAimMonster_Tip, cellctl.name.text))
        myself:Client_SetAutoBattleLockID(currentId)
        myself:Client_SetAutoBattle(true)
      end
      local monster = Table_Monster[currentId]
      if monster and (monster.Type == "MVP" or monster.Type == "MINI") then
        AAAManager.Me():Rcmc()
      end
    end
    Game.Myself:Client_SetAutoBattleProtectTeam(self.protectToggle.value)
    Game.Myself:Client_SetAutoBattleStanding(self.stayToggle.value)
  end
end

function MainViewAutoAimMonster:HandleStateChanged()
  self:UpdateAutoBattle()
  self:UpdateSweepState()
end

function MainViewAutoAimMonster:HandleRefreshStatus()
  if self:IsShowView() then
    self:UpdateInfo()
  else
    self:UpdateAutoBattle()
  end
end

function MainViewAutoAimMonster:ShowView(isShow)
  self.autoAimMonster:SetActive(isShow)
  if isShow then
    self:UpdateAfkPanel()
    if not Game.MapManager:IsPvPMode_TeamTwelve() then
      self:QueryBattleTime()
      self:UpdateInfo()
    else
      self:UpdateTwelvePVPMonsterInfo()
    end
  else
    self:StopTwevelPVPTick()
    AAAManager.Me():ClearCmi()
    TableUtility.TableClear(mvpMiniIndexMap)
  end
end

function MainViewAutoAimMonster:OffAutoAim()
  self.currentIds = nil
end

function MainViewAutoAimMonster:IsShowView()
  return self.autoAimMonster and self.autoAimMonster.activeSelf
end

function MainViewAutoAimMonster:SelfClose()
  self:ShowView(false)
  if self.currentIds and next(self.currentIds) then
    for currentId, _ in pairs(self.currentIds) do
      self:NotifyGuideQuestState(currentId)
    end
  end
  self:SetBubbleTipActive(true)
  local protect, stay
  if self.protectToggle.value then
    protect = 1
  else
    protect = 0
  end
  if self.stayToggle.value then
    stay = 1
  else
    stay = 0
  end
  local str = protect .. "_" .. stay
  if str ~= self.save_str then
    LocalSaveProxy.Instance:SetMainViewAutoAimMonster(str)
  end
  if self.isShowSweep then
    local _Myself = Game.Myself
    if _Myself:Client_GetFollowLeaderID() == 0 and self.isSweep ~= _Myself:Client_GetAutoEndlessTowerSweep() then
      local _AutoBattleManager = Game.AutoBattleManager
      if self.isSweep then
        _AutoBattleManager:AutoBattleOn()
      else
        _AutoBattleManager:AutoBattleOff()
      end
      _Myself:Client_SetAutoEndlessTowerSweep(self.isSweep)
    end
  end
end

function MainViewAutoAimMonster:UpdateSkill()
  self.protectToggle.gameObject:SetActive(SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.ProtectSkillId))
  self.stayToggle.gameObject:SetActive(SkillProxy.Instance:HasLearnedSkill(GameConfig.AutoAimMonster.UnmovableSkillId))
end

function MainViewAutoAimMonster:NotifyGuideQuestState(selectId)
  local questList = QuestProxy.Instance:getLockMonsterGuideByMonsterId(selectId)
  if not questList then
    return
  end
  for i = 1, #questList do
    QuestProxy.Instance:notifyQuestState(nil, questList[i])
  end
end

function MainViewAutoAimMonster:UpdateAutoBattle(note)
  local isAuto = Game.AutoBattleManager.on
  if isAuto then
    local lockids = Game.Myself:Client_GetAutoBattleLockIDs()
    if not next(lockids) then
      self:ShowAuto(isAuto, not isAuto)
    else
      self:ShowAuto(not isAuto, isAuto)
    end
    self.currentIds = lockids
  else
    self:ShowAuto(isAuto, isAuto)
    self:OffAutoAim()
    self.currentIds = nil
  end
  self.autoFightTip.text = isAuto and ZhString.MainViewInfoPage_Cancel or ZhString.MainViewInfoPage_Auto
end

function MainViewAutoAimMonster:ShowAuto(isAutoFight, isAutoAim)
  self.autoFight:SetActive(isAutoFight)
  self.autoAim:SetActive(isAutoAim)
  self:SetChooseAll(isAutoFight)
end

function MainViewAutoAimMonster:TryAutoBattleOn()
  Game.AutoBattleManager:AutoBattleOn()
  if not SkillProxy.Instance:HasAttackSkill(SkillProxy.Instance:GetCurrentEquipedAutoSkills()) then
    MsgManager.DontAgainConfirmMsgByID(1712)
  end
end

local anchorOffset = {0, 40}

function MainViewAutoAimMonster:HandleGuideBubbleTip(note)
  local data = note.body
  if data then
    if data.isShow then
      if not self.bubbleId then
        TipManager.Instance:ShowBubbleTipById(data.bubbleId, self.autoBattleBtnSps, NGUIUtil.AnchorSide.Left, anchorOffset, nil, false)
        self.bubbleId = data.bubbleId
      end
    elseif self.bubbleId then
      TipManager.Instance:CloseBubbleTip(self.bubbleId)
      self.bubbleId = nil
    end
  end
end

function MainViewAutoAimMonster:SetBubbleTipActive(b)
  if self.bubbleId then
    TipManager.Instance:SetBubbleTipActive(self.bubbleId, b)
  end
end

function MainViewAutoAimMonster:UpdateSweepState()
  self.isSweep = Game.MapManager:IsEndlessTower()
  if not self.isSweep then
    Game.Myself:Client_SetAutoEndlessTowerSweep(false)
  end
  return self.isSweep
end

function MainViewAutoAimMonster:UpdateSweep()
  local isShow = self:UpdateSweepState()
  if isShow == self.isShowSweep then
    return
  end
  self.isShowSweep = isShow
  self.toggleRow2Go:SetActive(isShow)
  self:UpdateLayout()
end

function MainViewAutoAimMonster:UpdateSweepCheckmark(isShow)
  self.sweepCheckmark:SetActive(isShow)
end

function MainViewAutoAimMonster:IsMonsterMvpOrMini(monsterId)
  local monster = Table_Monster[monsterId]
  return monster and (monster.Type == "MVP" or monster.Type == "MINI")
end

function MainViewAutoAimMonster:MaintainMvpMiniIndex(infoList)
  local firstPageItemCount = math.min(#infoList, 4)
  local newIndex, mvpMiniData, insertIndex
  for mvpMiniId, mvpMiniIndex in pairs(mvpMiniIndexMap) do
    newIndex = -1
    for i = 1, firstPageItemCount do
      if mvpMiniId == infoList[i]:GetId() and infoList[i]:IsShow() then
        newIndex = i
        break
      end
    end
    if 0 < newIndex then
      insertIndex = math.min(mvpMiniIndex, #infoList)
      if insertIndex ~= newIndex then
        mvpMiniData = infoList[newIndex]
        table.remove(infoList, newIndex)
        if insertIndex <= #infoList then
          table.insert(infoList, insertIndex, mvpMiniData)
        else
          table.insert(infoList, mvpMiniData)
          insertIndex = #infoList
        end
      end
    end
  end
  for i = 1, firstPageItemCount do
    local id = infoList[i]:GetId()
    if self:IsMonsterMvpOrMini(id) then
      mvpMiniIndexMap[id] = i
    end
  end
end

function MainViewAutoAimMonster:ShuffleMvpMini(infoList)
  local mvpMiniCount = 0
  local firstPageItemCount = math.min(#infoList, 4)
  local hideCount = 0
  for i = 1, firstPageItemCount do
    if infoList[i]:IsShow() then
      if self:IsMonsterMvpOrMini(infoList[i]:GetId()) then
        mvpMiniCount = mvpMiniCount + 1
      end
    else
      hideCount = hideCount + 1
    end
  end
  firstPageItemCount = firstPageItemCount - hideCount
  for i = 1, mvpMiniCount do
    local insertHeadIndex = mvpMiniCount + 1 - i
    if firstPageItemCount < insertHeadIndex then
      break
    end
    local j = math.random(insertHeadIndex, firstPageItemCount)
    local mvpTemp = infoList[1]
    for k = 1, j - 1 do
      infoList[k] = infoList[k + 1]
    end
    infoList[j] = mvpTemp
  end
  for i = 1, firstPageItemCount do
    local id = infoList[i]:GetId()
    if self:IsMonsterMvpOrMini(id) and infoList[i]:IsShow() then
      mvpMiniIndexMap[id] = i
    end
  end
  return infoList
end

function MainViewAutoAimMonster:UpdateTwelvePVPMonsterInfo()
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return
  end
  if not self.twelveTimeTick then
    self.twelveTimeTick = TimeTickManager.Me():CreateTick(0, 1000, self._UpdateTwelvePVPMonsterInfo, self, 113)
  else
    self:StopTwevelPVPTick()
  end
end

function MainViewAutoAimMonster:StopTwevelPVPTick()
  TimeTickManager.Me():ClearTick(self, 113)
  self.twelveTimeTick = nil
end

local filterRange = GameConfig.TwelvePvp.MonsterSearchRange

function MainViewAutoAimMonster:_UpdateTwelvePVPMonsterInfo()
  if not self:IsShowView() then
    return
  end
  if not Game.MapManager:IsPvPMode_TeamTwelve() then
    return
  end
  local functionMonster = FunctionMonster.Me()
  local _, hasMvpOrMini = functionMonster:FilterTwelvePVPMonsterStaticInfo(filterRange)
  TableUtility.ArrayClear(infoList)
  TableUtility.ArrayShallowCopy(infoList, functionMonster:SortMonsterStaticInfo())
  local all = AutoAimMonsterData.new()
  all:SetId(0)
  TableUtility.ArrayPushFront(infoList, all)
  self.itemWrapHelper:UpdateInfo(infoList)
  if #infoList <= 5 then
    self.itemWrapHelper:ResetPosition()
  end
  self:UpdateAutoBattle()
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cellCtls do
    local id = cellCtls[i].data and cellCtls[i].data:GetId() or 0
    if self.currentIds and self.currentIds[id] then
      cellCtls[i]:SetChoose(true)
    else
      cellCtls[i]:SetChoose(false)
    end
  end
  self:UpdateSweep()
  self:UpdateSweepCheckmark(self.isSweep)
end

function MainViewAutoAimMonster:UpdateAfkPanel(animated)
  local isAfkEnabled = AfkProxy.Instance:IsAfkEnabled()
  self.afkBgGo:SetActive(isAfkEnabled)
  self.afkRow1Go:SetActive(isAfkEnabled)
  self.afkRowPlaceholderGO:SetActive(isAfkEnabled)
  if not isAfkEnabled then
    self.afkRow2Go:SetActive(false)
    self.afkRow3Go:SetActive(false)
    self:UpdateLayout()
    return
  end
  do
    local isDue, remainingTime = MyselfProxy.Instance:GetAfkStatus()
    if isDue then
      self.isAfkOn = false
      self.afkTimeGo:SetActive(false)
      self.afkBuyGo:SetActive(true)
      self.afkBg.alpha = 0.5
    else
      self.afkTimeGo:SetActive(true)
      self.afkBuyGo:SetActive(false)
      local afkRemainingDays = math.ceil(remainingTime / 3600 / 24)
      self.afkTimeLabel.text = string.format(ZhString.Afk_RemainingTimeText, afkRemainingDays)
      if not SceneProxy.Instance:IsCurMapAfk() then
        self.isAfkOn = false
        self.afkBg.alpha = 0.5
      else
        self.afkBg.depth = 1
        self.afkBg.alpha = 1
      end
    end
  end
  local isAfkOn = not not self.isAfkOn
  local lastToggleValue = self.afkToggle.value
  self.afkToggle.value = isAfkOn
  local showAfkDetail = isAfkEnabled and isAfkOn
  LeanTween.cancel(self.afkRowPlaceholderGO)
  if animated and lastToggleValue == isAfkOn then
    local from = isAfkOn and 0 or self.fullAfkRowHeight
    local to = isAfkOn and self.fullAfkRowHeight or 0
    self.afkRowPlaceholder.height = from
    self.afkRow2Go:SetActive(true)
    self.afkRow3Go:SetActive(true)
    LeanTween.value(self.afkRowPlaceholderGO, function(v)
      self.afkRowPlaceholder.height = v
      self:UpdateLayout()
    end, from, to, 0.2):setOnComplete(function()
      self.afkRowPlaceholder.height = showAfkDetail and self.fullAfkRowHeight or 0
      self.afkRow2Go:SetActive(showAfkDetail)
      self.afkRow3Go:SetActive(showAfkDetail)
      self:UpdateLayout()
      self.closecomp:ReCalculateBound()
    end)
  else
    self.afkRowPlaceholder.height = showAfkDetail and self.fullAfkRowHeight or 0
    self.afkRow2Go:SetActive(showAfkDetail)
    self.afkRow3Go:SetActive(showAfkDetail)
    self:UpdateLayout()
    self.closecomp:ReCalculateBound()
  end
end

function MainViewAutoAimMonster:UpdateLayout()
  self.contentTable:Reposition()
  self.afkBg:UpdateAnchors()
  self.bg:UpdateAnchors()
  self.afkRowFollower:UpdateAnchors()
end

function MainViewAutoAimMonster:GetSelectedAfkMonsterIds()
  self.selectedAfkMonsterIds = self.selectedAfkMonsterIds or {}
  local idList = self.selectedAfkMonsterIds
  TableUtility.TableClear(idList)
  local ArrayPushBack = TableUtility.ArrayPushBack
  local cellCtls = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cellCtls do
    local ctl = cellCtls[i]
    if not ctl.data then
      break
    end
    if ctl:GetChooseValue() then
      local id = ctl.data and ctl.data:GetId()
      if id == 0 then
        return nil
      elseif id then
        ArrayPushBack(idList, id)
      end
    end
  end
  return idList
end

function MainViewAutoAimMonster:OnAfkBuyClicked()
  if ISNoviceServerType then
    MsgManager.ShowMsgByID(43493)
    return
  end
  MsgManager.ConfirmMsgByID(41164, function()
    FunctionNewRecharge.Instance():OpenUI(PanelConfig.NewRecharge_TCard)
  end)
end

function MainViewAutoAimMonster:OnAfkToggleClicked()
  local isDue, remainingTime = MyselfProxy.Instance:GetAfkStatus()
  if isDue then
    self.afkToggle.value = false
    self:OnAfkBuyClicked()
    return
  end
  if not SceneProxy.Instance:IsCurMapAfk() then
    self.afkToggle.value = false
    MsgManager.ShowMsgByID(41150)
    return
  end
  self.isAfkOn = self.afkToggle.value
  self:UpdateAfkPanel(true)
end

function MainViewAutoAimMonster:OnStartAfkClicked()
  local duration = self.afkDurationInput.value and tonumber(self.afkDurationInput.value) or 0
  if 0 < duration then
    local inplace = self.stayToggle.value
    local protectTeam = self.protectToggle.value
    local monsterIds = self:GetSelectedAfkMonsterIds()
    local times = ISNoviceServerType and 1 or 60
    if not monsterIds or 0 < #monsterIds then
      MsgManager.ConfirmMsgByID(41147, function()
        ServiceUserAfkCmdProxy.Instance:CallReqAfkUserAfkCmd(duration * times, inplace, protectTeam, monsterIds)
      end, nil, nil)
    else
      MsgManager.ShowMsgByID(41163)
    end
  end
end

function MainViewAutoAimMonster:OnRecvAfkResult(data)
  local body = data and data.body
  if body and body.ret then
    redlog("[afk] 请求成功了！！！")
    Game.Me():BackToLogo()
  else
    redlog("[afk] 请求失败！！！")
    MsgManager.ShowMsgByID(41156)
  end
end

function MainViewAutoAimMonster:OnAfkDurationChanged()
  local duration = self.afkDurationInput.value and tonumber(self.afkDurationInput.value) or 0
  local illegal = false
  if duration > MaxAfkDuration then
    duration = MaxAfkDuration
  elseif duration < 0 then
    duration = 0
  end
  self.afkDurationInput.value = tostring(duration)
end

function MainViewAutoAimMonster:QueryBattleTime()
  if ISNoviceServerType then
    self.afkDurationInput.value = tostring(MaxAfkDuration)
  else
    local lastCallTime = self.lastQueryBattleTime or 0
    if not self.lastQueryBattleTime or UnityUnscaledTime - lastCallTime > 300 then
      self.lastQueryBattleTime = UnityUnscaledTime
      BattleTimeDataProxy.QueryBattleTimelenUserCmd()
    end
  end
end

function MainViewAutoAimMonster:OnRecvBattleTime(data)
  local timelen = _BattleTimeData:Timelen()
  local totalTime = _BattleTimeData:TotalTimeLen()
  if not timelen or not totalTime then
    return
  end
  local timeRemainning = totalTime - timelen
  if timeRemainning < 0 then
    timeRemainning = 0
  end
  if timeRemainning > MaxAfkDuration then
    timeRemainning = MaxAfkDuration
  end
  self.afkDurationInput.value = tostring(timeRemainning)
end

function MainViewAutoAimMonster:OnExitSniperMode()
  Game.Myself:Client_SetAutoBattleStanding(self.stayToggle.value)
end

function MainViewAutoAimMonster:RegisterGuide()
  self:AddOrRemoveGuideId(self.autoHealingSetBtn, 463)
end

function MainViewAutoAimMonster:OnDemoRaidLaunch()
  self.autoFightBtn:SetActive(false)
  self.selectTargetBtn:SetActive(false)
end

function MainViewAutoAimMonster:OnDemoRaidShutdown()
  self.autoFightBtn:SetActive(true)
  self.selectTargetBtn:SetActive(true)
end

function MainViewAutoAimMonster:DoSelectTarget()
  if self.selectTargetTime == nil or ServerTime.CurServerTime() - self.selectTargetTime > AutoBattle.ChangeTargetTime then
    local researchDis = _SqrDistance(self.lastCheckPos, Game.Myself:GetPosition())
    if researchDis > AutoBattle.MoveDistance then
      LuaVector3.Better_SetPos(self.lastCheckPos, Game.Myself:GetPosition())
    end
    local research = researchDis > AutoBattle.MoveDistance or ServerTime.CurServerTime() - self.selectTargetTime > AutoBattle.ResearchTargetTime
    local targetCreature = SceneCreatureProxy.SortTargetCreature(Game.Myself:GetPosition(), AutoBattle.SearchTargetDistance, research)
    local ignoreNoEnemyLocked = Game.Myself.data.ignoreNoEnemyLocked
    if targetCreature and targetCreature:Alive() and (not targetCreature.data:GetNoEnemyLocked() or ignoreNoEnemyLocked) then
      if research and targetCreature == Game.Myself:GetLockTarget() then
        targetCreature = SceneCreatureProxy.SortTargetCreature(Game.Myself:GetPosition(), AutoBattle.SearchTargetDistance, false)
      end
      Game.Myself:Client_LockTarget(targetCreature)
    else
      MsgManager.ShowMsgByID(713)
    end
  end
  self.selectTargetTime = ServerTime.CurServerTime()
end

function MainViewAutoAimMonster:DoShowView()
  local isShow = self:IsShowView()
  self:ShowView(not isShow)
end
