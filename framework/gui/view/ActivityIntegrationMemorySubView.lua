ActivityIntegrationMemorySubView = class("ActivityIntegrationMemorySubView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("ActivityIntegrationMemorySubView")
local picIns = PictureManager.Instance
local tempVector3 = LuaVector3.Zero()
local decorateTextureNameMap = {
  BgTexture = "spring_book_bg",
  Memory1 = "spring_pjoto_bg",
  Memory2 = "spring_pjoto_bg",
  Memory3 = "spring_pjoto_bg",
  Memory4 = "spring_pjoto_bg",
  SummaryTipBg = "spring_book_txt_reward",
  TreeBg = "spring_tree_bg"
}

function ActivityIntegrationMemorySubView:Init()
  if self.inited then
    return
  end
  self:LoadPrefab()
  self:FindObjs()
  self:AddEvts()
  self.inited = true
end

function ActivityIntegrationMemorySubView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "ActivityIntegrationMemorySubView"
  self.gameObject = obj
end

function ActivityIntegrationMemorySubView:FindObjs()
  self.titleLabel = self:FindGO("TitleLabel", self.gameObject):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self.timeLabel = self:FindGO("TimeLabel", self.gameObject):GetComponent(UILabel)
  self.gotoBtn = self:FindGO("GoToBtn", self.gameObject)
  self.gotoBtn_label = self:FindGO("Label", self.gotoBtn):GetComponent(UILabel)
  self.gotoBtn_boxCollider = self.gotoBtn:GetComponent(BoxCollider)
  self.summaryBtn = self:FindGO("SummaryBtn", self.gameObject)
  self.summaryBtn_BoxCollider = self.summaryBtn:GetComponent(BoxCollider)
  self.summaryBtn_Lock = self:FindGO("Lock", self.summaryBtn)
  self.summaryTipLabel = self:FindGO("SummaryTipLabel", self.gameObject):GetComponent(UILabel)
  self.rewardSymbol = self:FindGO("RewardSymbol", self.summaryBtn)
  self.rewardSymbol:SetActive(false)
  self.root = self:FindGO("Root", self.gameObject)
  self.memoryTexture = {}
  for i = 1, 4 do
    local memoryNode = self:FindGO("Memory" .. i, self.root)
    if memoryNode then
      self:AddClickEvent(memoryNode, function()
        xdlog("点击页签")
        local unlockData = YearMemoryProxy.Instance:GetMemoryStatus(self.version)
        local process = unlockData and unlockData.process or 0
        if process < i then
          return
        end
        local pages = {}
        if 0 < process then
          for i = 1, process do
            table.insert(pages, i)
          end
        end
        RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, i)
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.MemoryPopup,
          viewdata = {
            index = i,
            pages = pages,
            version = self.version,
            activityid = self.activityID
          }
        })
      end)
      local texture = self:FindGO("Texture", memoryNode):GetComponent(UITexture)
      self.memoryTexture[i] = texture
      self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_NEW_YEAR_MEMORY, memoryNode, 30, {-10, -10}, nil, i)
    end
  end
  self:AddClickEvent(self.summaryBtn, function()
    xdlog("年度总结")
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MemoryPopup,
      viewdata = {
        includeSummary = 1,
        version = self.version,
        activityid = self.activityID
      }
    })
  end)
  self:AddClickEvent(self.gotoBtn, function()
    local questData = self.questid and QuestProxy.Instance:getQuestDataByQuestID(self.questid)
    if questData then
      FunctionQuest.Me():executeManualQuest(questData)
      if self.container then
        self.container:CloseSelf()
      end
    end
  end)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  if self.helpBtn then
    self:AddClickEvent(self.helpBtn, function()
      local helpID = self.staticData.HelpID
      self.container:HandleClickHelpBtn(helpID)
    end)
  end
end

function ActivityIntegrationMemorySubView:AddEvts()
  self:AddListenEvt(ServiceEvent.SceneUser3YearMemoryProcessUserCmd, self.RefreshPage, self)
  self:AddListenEvt(ServiceEvent.ActivityCmdYearMemoryActInfoCmd, self.UpdateSummaryBtn, self)
end

function ActivityIntegrationMemorySubView:RefreshPage(id)
  if not self.staticData then
    return
  end
  self.titleLabel.text = self.staticData.TitleName
  local helpID = self.staticData.HelpID
  self.helpBtn:SetActive(helpID ~= nil or false)
  local isTF = EnvChannel.IsTFBranch()
  local duration = isTF and self.staticData.TFDuration or self.staticData.Duration
  self.startTime = duration[1] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[1])
  self.endTime = duration[2] and KFCARCameraProxy.Instance:GetSelfCustomDate(duration[2])
  self.timeLabel.gameObject:SetActive(true)
  TimeTickManager.Me():ClearTick(self, 1)
  TimeTickManager.Me():CreateTick(0, 10000, self.UpdateLeftTime, self)
  self:UpdateSummaryBtn()
end

function ActivityIntegrationMemorySubView:UpdateLeftTime()
  if not self.endTime then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeLabel.gameObject:SetActive(false)
  else
    local leftTime = self.endTime - ServerTime.CurServerTime() / 1000
    if 0 < leftTime then
      local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(leftTime)
      if 0 < day then
        timeText = string.format(ZhString.PlayerTip_ExpireTime, day)
        self.timeLabel.text = timeText .. ZhString.PlayerTip_Day
      else
        timeText = string.format("%02d:%02d:%02d", hour, min, sec)
        self.timeLabel.text = string.format(ZhString.PlayerTip_ExpireTime, timeText)
      end
    else
      TimeTickManager.Me():ClearTick(self, 1)
      self.timeLabel.gameObject:SetActive(false)
    end
  end
end

function ActivityIntegrationMemorySubView:UpdateSummaryBtn()
  local actInfo = Table_ActPersonalTimer[self.activityID]
  if actInfo then
    local staticData = YearMemoryProxy.Instance:GetVersionData(self.version)
    local unlockData = YearMemoryProxy.Instance:GetMemoryStatus(self.version)
    local end_process = staticData and staticData.end_process or 5
    local process = unlockData and unlockData.process or 0
    local gottedReward = unlockData and unlockData.gotten_share_reward or false
    local actValid = ActivityIntegrationProxy.Instance:CheckActPersinalActValid(self.activityID)
    if end_process <= process then
      self.summaryBtn_Lock:SetActive(false)
      self.summaryBtn_BoxCollider.enabled = true
      self.summaryTipLabel.gameObject:SetActive(false)
      self.rewardSymbol:SetActive(actValid and not gottedReward)
    else
      self.summaryBtn_Lock:SetActive(true)
      self.summaryBtn_BoxCollider.enabled = false
      self.summaryTipLabel.gameObject:SetActive(true)
      self.summaryTipLabel.text = string.format(ZhString.ActivityIntegration_YearMemoryProcess, process, end_process)
      self.rewardSymbol:SetActive(false)
    end
    self.SummaryTipBg.height = self.summaryTipLabel.printedSize.y + 56
    self.SummaryTipBg.width = self.summaryTipLabel.printedSize.x + 74
    for i = 1, 4 do
      self.memoryTexture[i].gameObject:SetActive(process >= i)
    end
    if Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL) < 25 then
      self:SetTextureGrey(self.gotoBtn)
      self.gotoBtn_boxCollider.enabled = false
      self.gotoBtn_label.text = ZhString.ActivityIntegration_LevelLimit
      return
    end
    local targetProcess = process + 1
    if end_process < targetProcess then
      self.gotoBtn:SetActive(false)
    else
      local info = YearMemoryProxy.Instance:GetIndexsByVersionAndPage(self.version, targetProcess)
      if info then
        local questid = info.quest
        if questid then
          local questData = QuestProxy.Instance:getQuestDataByQuestID(questid)
          if not questData then
            self:SetTextureGrey(self.gotoBtn)
            self.gotoBtn_boxCollider.enabled = false
            self.gotoBtn_label.text = ZhString.ActivityIntegration_UnlockTommorrow
          else
            self.questid = questid
          end
        else
          self:SetTextureGrey(self.gotoBtn)
          self.gotoBtn_boxCollider.enabled = false
          self.gotoBtn_label.text = "没有任务"
        end
      end
    end
  end
end

function ActivityIntegrationMemorySubView:OnEnter(id)
  self.staticData = Table_ActivityIntegration[id]
  if not self.staticData then
    redlog("Table_ActivityIntegration缺少配置", id)
    return
  end
  ActivityIntegrationMemorySubView.super.OnEnter(self)
  self.activityID = self.staticData.Params and self.staticData.Params.ActivityId
  self.version = self.staticData.Params and self.staticData.Params.Year
  self:RefreshPage(id)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  for i = 1, 4 do
    local staticData = YearMemoryProxy.Instance:GetIndexsByVersionAndPage(self.version, i)
    local textureName = staticData and staticData.texture
    if textureName and textureName ~= "" then
      PictureManager.Instance:SetUI(textureName, self.memoryTexture[i])
    end
  end
end

function ActivityIntegrationMemorySubView:OnExit()
  ActivityIntegrationMemorySubView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  YearMemoryProxy.Instance:RefreshFakeRedTip(self.version)
end
