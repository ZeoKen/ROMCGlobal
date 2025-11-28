GLandChallengeView = class("GLandChallengeView", ContainerView)
GLandChallengeView.ViewType = UIViewType.PopUpLayer
autoImport("GLandPersonalRankCell")
autoImport("GLandChallengeCell")
autoImport("GLandStatusCombineView")
GLandChallengeView.BrotherView = GLandStatusCombineView

function GLandChallengeView:Init()
  self:FindObjs()
  self:MapEvent()
  self:InitData()
  self:InitShow()
end

function GLandChallengeView:FindObjs()
  self.title = self:FindComponent("Title", UILabel)
  self.restStatus = self:FindGO("RestStatus")
  self.activeStatus = self:FindGO("ActiveStatus")
  self.seasonName = self:FindGO("SeasonName", self.restStatus):GetComponent(UILabel)
  self.rankName_rest = self:FindGO("RankName", self.restStatus):GetComponent(UILabel)
  self.rankIcon_rest = self:FindGO("RankIcon", self.restStatus):GetComponent(UISprite)
  local curSeason_TextGO = self:FindGO("CurSeasonTxt", self.restStatus)
  self.seasonTxt_1 = self:FindGO("txt_1", curSeason_TextGO):GetComponent(UISprite)
  self.seasonTxt_2 = self:FindGO("txt_2", curSeason_TextGO):GetComponent(UISprite)
  self.rankIcon_active = self:FindGO("RankIcon", self.activeStatus):GetComponent(UISprite)
  self.rankName_active = self:FindGO("RankName", self.activeStatus):GetComponent(UILabel)
  self.excellentRoot = self:FindGO("ExcellentRoot")
  self.excellentIcon = self:FindGO("ExcellentIcon", self.excellentRoot):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[913000].Icon, self.excellentIcon)
  self.excellentIcon:MakePixelPerfect()
  self.excellentIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.5, 0.5, 0.5)
  self.challengeNum = self:FindGO("ChallengeNum", self.activeStatus):GetComponent(UILabel)
  self.rankScrollView = self:FindGO("RankScrollView", self.activeStatus):GetComponent(UIScrollView)
  self.sliderBg = self:FindGO("SliderBg", self.activeStatus):GetComponent(UISprite)
  self.sliderFore = self:FindGO("SliderFore", self.activeStatus):GetComponent(UISprite)
  self.sliderGrid = self:FindGO("SliderGrid", self.activeStatus):GetComponent(UIGrid)
  self.rankListCtrl = UIGridListCtrl.new(self.sliderGrid, GLandPersonalRankCell, "GLandPersonalRankCell")
  self.rankListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleCallRecvReward, self)
  self.taskRoot = self:FindGO("TaskRoot")
  self.taskScrollView = self:FindGO("TaskScrollView", self.taskRoot):GetComponent(UIScrollView)
  self.taskGrid = self:FindGO("TaskGrid", self.taskRoot):GetComponent(UIGrid)
  self.taskListCtrl = UIGridListCtrl.new(self.taskGrid, GLandChallengeCell, "GLandChallengeCell")
  self.taskListCtrl:AddEventListener(MouseEvent.DoubleClick, self.HandleShowItemTip, self)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.extraTipLabel = self:FindGO("ExtraTipLabel"):GetComponent(UILabel)
  self.goToBtn = self:FindGO("GoToBtn")
  self:AddClickEvent(self.goToBtn, function()
    if self.unlockShopTip then
      MsgManager.FloatMsg(nil, self.unlockShopTip)
      return
    end
    MsgManager.ConfirmMsgByID(43577, function()
      if Game.MapManager:IsInGuildMap() then
        FuncShortCutFunc.Me():CallByID(1058)
      else
        ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
        local shortCutID = 1058
        FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function(shortCutID)
          FuncShortCutFunc.Me():CallByID(shortCutID)
        end, shortCutID)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.PopUpLayer)
        GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
        self:CloseSelf()
      end
    end)
  end)
  self:InitGoToBtn()
  self.sliderEffectContainer = self:FindGO("SliderEffectContainer")
end

function GLandChallengeView:MapEvent()
  self:AddListenEvt(ServiceEvent.SceneUser3GvgExcellectQueryUserCmd, self.HandleQueryData)
  self:AddListenEvt(ServiceEvent.SceneUser3GvgExcellectRewardUserCmd, self.HandleRecvReward)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgTaskUpdateGuildCmd, self.HandleTaskUpdate)
  self:AddListenEvt(ServiceEvent.FuBenCmdGvgDataSyncCmd, self.HandleUpdateExtra)
end

function GLandChallengeView:InitData()
  local _gvgProxy = GvgProxy.Instance
  self.nowSeason = _gvgProxy:NowSeason()
  self.isOnFire = _gvgProxy:GetGvgOpenFireState() or false
  self.nextSeasonBeginTime = _gvgProxy.next_season_begintime
  self.isInLeisure = _gvgProxy:IsGvgInLeisureMode() or false
  self.rewardid = _gvgProxy:GetExcellentRewardid() or 999
  xdlog("面板数据", self.nowSeason)
  local multiRewardData = ActivityEventProxy.Instance:GetRewardByType(AERewardType.NewGVGPersonal)
  if multiRewardData and multiRewardData:GetMultiple() and multiRewardData:GetMultiple() > 0 then
    self.multiple_reward = multiRewardData:GetMultiple()
  end
  xdlog("翻倍数据", self.multiple_reward)
  if not self.lastExcellent then
    local _lastExcellent = PlayerPrefs.GetInt(LocalSaveProxy.SAVE_KEY.GLandChallenge_LastExcellentNum, 0)
    local curExcellent = Game.Myself.data.userdata:Get(UDEnum.EXCELLECT) or 0
    if _lastExcellent > curExcellent then
      _lastExcellent = 0
      PlayerPrefs.SetInt(LocalSaveProxy.SAVE_KEY.GLandChallenge_LastExcellentNum, 0)
    else
      PlayerPrefs.SetInt(LocalSaveProxy.SAVE_KEY.GLandChallenge_LastExcellentNum, curExcellent)
    end
    self.lastExcellent = _lastExcellent
  end
  self:InitSeasonRankMap()
end

function GLandChallengeView:InitGoToBtn()
  local config = Table_GuildBuilding[1001]
  local cond = config and config.LevelUpCond
  if cond and cond.guildlv then
    local myGuildData = GuildProxy.Instance.myGuildData
    local myGuildLv = myGuildData and myGuildData.level or 0
    if myGuildLv < cond.guildlv then
      self.unlockShopTip = string.format(ZhString.GvgLandChallengeView_ShopUnlockTip, cond.guildlv)
    end
  end
end

function GLandChallengeView:InitSeasonRankMap()
  if not Table_GuildGvgProgressReward then
    return
  end
  if not self.rankMap then
    self.rankMap = {}
  else
    TableUtility.TableClear(self.rankMap)
  end
  local curExcellent = Game.Myself.data.userdata:Get(UDEnum.EXCELLECT)
  for _id, _info in pairs(Table_GuildGvgProgressReward) do
    self.rankMap[_info.Excellent] = _id
  end
  self.curRank = GvgProxy.Instance:GetExcellentRank()
  xdlog("当前段位", self.curRank)
end

function GLandChallengeView:InitShow()
  self:UpdateLeftNode()
  self:UpdateTask()
end

function GLandChallengeView:UpdateLeftNode()
  if not self.curRank then
    return
  end
  self.restStatus:SetActive(self.isInLeisure)
  self.activeStatus:SetActive(not self.isInLeisure)
  if self.isInLeisure then
    self.timeLabel.text = ZhString.GvgLandChallengeView_InLeisureMode
    self.seasonName.text = string.format(ZhString.GvgLandChallengeView_CurSeason, self.nowSeason)
    local excellentConfig = GameConfig.ExcellentRankName and GameConfig.ExcellentRankName[self.curRank]
    self.rankName_rest.text = excellentConfig and excellentConfig.name
    self.rankIcon_rest.spriteName = "guildwar_icon_0" .. self.curRank
    self.rankIcon_rest:MakePixelPerfect()
    self.rankIcon_rest.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.68, 0.68, 0.68)
    if self.nowSeason > 10 then
      local first, second = math.modf(self.nowSeason / 10)
      self.seasonTxt_1.spriteName = "12pvp_txt_" .. first
      self.seasonTxt_2.spriteName = "12pvp_txt_" .. second
    else
      self.seasonTxt_1.spriteName = "12pvp_txt_" .. self.nowSeason
      self.seasonTxt_2.gameObject:SetActive(false)
    end
    self.extraTipLabel.gameObject:SetActive(false)
  else
    if self.isOnFire then
      local citytype = GvgProxy.Instance.cityType
      local config = GameConfig.GVGConfig.citytype_data[citytype]
      if config then
        local rate = config.user_task_rate - 1
        if 0 < rate then
          self.extraTipLabel.gameObject:SetActive(true)
          self.extraTipLabel.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_PersonalRate, rate * 100)
        else
          self.extraTipLabel.gameObject:SetActive(false)
        end
      else
        self.extraTipLabel.gameObject:SetActive(false)
      end
    else
      self.extraTipLabel.gameObject:SetActive(false)
    end
    local leftWeek = GvgProxy.Instance:GetLeftWeek()
    if leftWeek == 0 then
      self.timeLabel.text = ZhString.GvgLandChallengeView_SeasonEnd
    else
      self.timeLabel.text = string.format(ZhString.GvgLandChallengeView_InBattleMode_Week, leftWeek)
    end
    local excellentConfig = GameConfig.ExcellentRankName and GameConfig.ExcellentRankName[self.curRank]
    self.rankName_active.text = excellentConfig and excellentConfig.name
    self.rankIcon_active.spriteName = "guildwar_icon_0" .. self.curRank
    self.rankIcon_active:MakePixelPerfect()
    self.rankIcon_active.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.68, 0.68, 0.68)
    local curExcellent = Game.Myself.data.userdata:Get(UDEnum.EXCELLECT)
    self.challengeNum.text = string.format(ZhString.GvgLandChallengeView_ExcellentNum, Table_Item[913000].NameZh, curExcellent)
    local scoreList = {}
    for _excellent, _id in pairs(self.rankMap) do
      table.insert(scoreList, {id = _id, Excellent = _excellent})
    end
    table.sort(scoreList, function(l, r)
      local l_excellent = l.Excellent or 0
      local r_excellent = r.Excellent or 0
      if l_excellent ~= r_excellent then
        return l_excellent < r_excellent
      end
    end)
    table.insert(scoreList, 1, {id = 0, Excellent = 0})
    self.rankListCtrl:ResetDatas(scoreList)
    self.sliderBg.width = 90 * (#scoreList - 1)
    self.hasReward = false
    local curIndex = 1
    local targetIndex = 1
    local cells = self.rankListCtrl:GetCells()
    for i = 1, #cells do
      if cells[i].data and cells[i].data.Excellent and cells[i].data.Excellent <= self.lastExcellent then
        if curIndex < cells[i].indexInList then
          curIndex = cells[i].indexInList
        end
        cells[i]:SetRewarded(cells[i].data.id <= self.rewardid)
        cells[i]:SetCanRecv(cells[i].data.id > self.rewardid)
        cells[i]:SetReachProcess(true)
      else
        cells[i]:SetRewarded(false)
        cells[i]:SetCanRecv(false)
        cells[i]:SetReachProcess(false)
      end
      if cells[i].data and cells[i].data.Excellent and curExcellent >= cells[i].data.Excellent and targetIndex < cells[i].indexInList then
        targetIndex = cells[i].indexInList
      end
    end
    local offset = self.lastExcellent - cells[curIndex].data.Excellent
    if 0 < offset and cells[curIndex + 1] then
      self.sliderFore.width = 90 * (curIndex - 1) + 90 * offset / (cells[curIndex + 1].data.Excellent - cells[curIndex].data.Excellent)
    else
      self.sliderFore.width = 90 * (curIndex - 1)
    end
    local targetCell = cells and cells[targetIndex + 1] or cells[targetIndex]
    if targetCell then
      local panel = self.rankScrollView.panel
      local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, targetCell.gameObject.transform)
      local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
      offset = Vector3(0, offset.y, 0)
      self.rankScrollView:MoveRelative(offset)
    end
    TimeTickManager.Me():ClearTick(self, 2)
    TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      if curExcellent > self.lastExcellent then
        local effectOnCell = cells and cells[targetIndex - 3] or cells[1]
        if effectOnCell and not self.sliderEff then
          self.sliderEffectContainer.transform.position = effectOnCell.gameObject.transform.position
          local pos = self.sliderEffectContainer.transform.localPosition
          self.sliderEffectContainer.transform.localPosition = LuaGeometry.GetTempVector3(22.73, pos[2], 0)
          self.sliderEff = self:PlayUIEffect(EffectMap.UI.GLandChallenge_SliderShine, self.sliderEffectContainer)
        end
      end
      for i = 1, #cells do
        if cells[i].data and cells[i].data.Excellent and cells[i].data.Excellent > self.lastExcellent and cells[i].data.Excellent <= curExcellent then
          cells[i]:PlayAchieveEffect()
        end
      end
      for i = 1, #cells do
        if cells[i].data and cells[i].data.Excellent and cells[i].data.Excellent <= curExcellent then
          if cells[i].data.id > self.rewardid then
            self.hasReward = true
          end
          cells[i]:SetRewarded(cells[i].data.id <= self.rewardid)
          cells[i]:SetCanRecv(cells[i].data.id > self.rewardid)
          cells[i]:SetReachProcess(true)
        else
          cells[i]:SetRewarded(false)
          cells[i]:SetCanRecv(false)
          cells[i]:SetReachProcess(false)
        end
      end
      local offset = curExcellent - cells[targetIndex].data.Excellent
      if 0 < offset and cells[targetIndex + 1] then
        self.sliderFore.width = 90 * (targetIndex - 1) + 90 * offset / (cells[targetIndex + 1].data.Excellent - cells[targetIndex].data.Excellent)
      else
        self.sliderFore.width = 90 * (targetIndex - 1)
      end
      self.lastExcellent = curExcellent
    end, self, 2)
  end
end

function GLandChallengeView:UpdateTask()
  local result = {}
  local tasks = GvgProxy.Instance:GetGroupTasks() or {}
  local groupTask = GameConfig.GVGConfig and GameConfig.GVGConfig.GvgTask
  for _, _taskInfo in pairs(groupTask) do
    local isFinish = GvgProxy.Instance:CheckGroupTaskIsFinish(_taskInfo.taskid)
    result[#result + 1] = {
      type = 2,
      taskid = _taskInfo.taskid,
      progress = tasks[_taskInfo.taskid] or 0,
      isInLeisure = self.isInLeisure,
      isFinish = isFinish
    }
  end
  local infoDatas = GvgProxy.Instance.questInfoData
  for i = 1, #GvgProxy.GvgQuestListp do
    local single = GvgProxy.GvgQuestListp[i]
    local isFinish = GvgProxy.Instance:CheckPersonalTaskIsFinish(single)
    result[#result + 1] = {
      type = 1,
      key = single,
      value = infoDatas[single] or 0,
      isInLeisure = self.isInLeisure,
      isFinish = isFinish
    }
  end
  table.sort(result, function(l, r)
    local l_isFinish = l.isFinish and 1 or 0
    local r_isFinish = r.isFinish and 1 or 0
    if l_isFinish ~= r_isFinish then
      return l_isFinish < r_isFinish
    end
    local l_isGroup = l.type == 2 and 1 or 0
    local r_isGroup = r.type == 2 and 1 or 0
    if l_isGroup ~= r_isGroup then
      return l_isGroup > r_isGroup
    end
  end)
  self.taskListCtrl:ResetDatas(result)
end

function GLandChallengeView:HandleQueryData()
  self:InitData()
  self:InitShow()
end

function GLandChallengeView:HandleCallRecvReward(cellCtrl)
  if not self.hasReward or cellCtrl.rewarded then
    redlog("无可领取")
    local itemData = cellCtrl and cellCtrl.rewardCell and cellCtrl.rewardCell.data and cellCtrl.rewardCell.data.itemData
    local widget = cellCtrl and cellCtrl.rewardCell and cellCtrl.rewardCell.icon
    self:Func_ShopItemTip(itemData, widget)
  else
    xdlog("请求领奖")
    ServiceSceneUser3Proxy.Instance:CallGvgExcellectRewardUserCmd()
  end
end

function GLandChallengeView:HandleRecvReward()
  xdlog("领奖成功")
  local _gvgProxy = GvgProxy.Instance
  self.rewardid = _gvgProxy:GetExcellentRewardid() or 0
  self.lastExcellent = Game.Myself.data.userdata:Get(UDEnum.EXCELLECT) or 0
  self:UpdateLeftNode()
end

function GLandChallengeView:HandleTaskUpdate()
  self:InitData()
  self:UpdateTask()
end

function GLandChallengeView:HandleShowItemTip(cellCtrl)
  local itemData = cellCtrl and cellCtrl.data
  local widget = cellCtrl.icon
  self:Func_ShopItemTip(itemData, widget)
end

function GLandChallengeView:Func_ShopItemTip(itemData, widget)
  local sdata = {
    itemdata = itemData,
    funcConfig = {}
  }
  local x, y, z = NGUIUtil.GetUIPositionXYZ(widget.gameObject)
  if 0 < x then
    self:ShowItemTip(sdata, widget, NGUIUtil.AnchorSide.Left, {-215, 0})
  else
    self:ShowItemTip(sdata, widget, NGUIUtil.AnchorSide.Right, {280, 0})
  end
end

function GLandChallengeView:HandleUpdateExtra()
  if self.isOnFire then
    local citytype = GvgProxy.Instance.cityType
    local config = GameConfig.GVGConfig.citytype_data[citytype]
    if config then
      local rate = config.user_task_rate - 1
      if 0 < rate then
        self.extraTipLabel.gameObject:SetActive(true)
        self.extraTipLabel.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_PersonalRate, rate * 100)
      else
        self.extraTipLabel.gameObject:SetActive(false)
      end
    else
      self.extraTipLabel.gameObject:SetActive(false)
    end
  else
    self.extraTipLabel.gameObject:SetActive(false)
  end
end

function GLandChallengeView:OnEnter()
  GLandChallengeView.super.OnEnter(self)
  ServiceSceneUser3Proxy.Instance:CallGvgExcellectQueryUserCmd()
  local mercenaryGuildID = GuildProxy.Instance.myMercenaryGuildId
  if mercenaryGuildID and 0 < mercenaryGuildID then
    ServiceGuildCmdProxy.Instance:CallGvgTaskUpdateGuildCmd(nil, mercenaryGuildID)
    ServiceGuildCmdProxy.Instance:CallGvgDataQueryGuildCmd()
  else
    local myGuildID = GuildProxy.Instance.guildId
    if myGuildID and 0 < myGuildID then
      ServiceGuildCmdProxy.Instance:CallGvgTaskUpdateGuildCmd(nil, myGuildID)
      ServiceGuildCmdProxy.Instance:CallGvgDataQueryGuildCmd()
    end
  end
end

function GLandChallengeView:OnExit()
  GLandChallengeView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end
