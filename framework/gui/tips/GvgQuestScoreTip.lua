local _GrayTogLabColor = Color(0.6627450980392157, 0.6509803921568628, 0.6509803921568628, 1)
autoImport("GvgQuestTableCell")
autoImport("GvgGroupQuestTableCell")
autoImport("GvgScoreFixedCell")
autoImport("GvgScoreCell")
GvgQuestScoreTip = class("GvgQuestScoreTip", BaseTip)

function GvgQuestScoreTip:Init()
  GvgQuestScoreTip.super.Init(self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(525, self:FindGO("HelpButton"))
  self:FindQuestObj()
  self:FindScoreObj()
  self:FindTogs()
  EventManager.Me():AddEventListener(ServiceEvent.GuildCmdGvgScoreInfoUpdateGuildCmd, self._UpdateServerScore, self)
end

function GvgQuestScoreTip:FindQuestObj()
  self.questRoot = self:FindGO("QuestRoot")
  self.empty = self:FindGO("empty", self.questRoot)
  local emptyLabel = self:FindComponent("emptyLabel", UILabel, self.empty)
  emptyLabel.text = ZhString.MainViewGvgPage_GvgQuestTip_Empty
  local questRootTableObj = self:FindGO("QuestRootTable", self.questRoot)
  self.questSeparator = self:FindGO("Separator", self.questRootTableObj)
  self.group = self:FindGO("Group", self.questRootTableObj)
  local groupTitle = self:FindGO("Title", self.group):GetComponent(UILabel)
  groupTitle.text = ZhString.MainViewGvgPage_GvgQuestTip_TargetPreview
  local groupGrid = self:FindGO("QuestTable", self.group):GetComponent(UITable)
  self.groupQuestList = UIGridListCtrl.new(groupGrid, GvgQuestTableCell, "GvgQuestTableCell")
  self.rate = self:FindGO("Rate", self.group):GetComponent(UILabel)
  local citytype = GvgProxy.Instance.cityType
  local config = GameConfig.GVGConfig.citytype_data[citytype]
  if config then
    local rate = config.user_task_rate - 1
    if 0 < rate then
      self.rate.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_PersonalRate, rate * 100)
    else
      self.rate.gameObject:SetActive(false)
    end
  else
    self.rate.gameObject:SetActive(false)
  end
end

function GvgQuestScoreTip:FindScoreObj()
  self.scoreRoot = self:FindGO("ScoreRoot")
  local scoreRootTableObj = self:FindGO("ScoreRootTable", self.scoreRoot)
  self.scoreMid = self:FindGO("Mid", scoreRootTableObj)
  local scoreMidTitle = self:FindComponent("Title", UILabel, self.scoreMid)
  scoreMidTitle.text = ZhString.MainViewGvgPage_GvgQuestTip_ScoreMid
  local scoreMidTable = self:FindComponent("ScoreMidTable", UITable, self.scoreMid)
  self.scoreMidList = UIGridListCtrl.new(scoreMidTable, GvgScoreCell, "GvgScoreCell")
  self.scoreAfter = self:FindGO("After", scoreRootTableObj)
  local scoreAfterTitle = self:FindComponent("Title", UILabel, self.scoreAfter)
  scoreAfterTitle.text = ZhString.MainViewGvgPage_GvgQuestTip_ScoreAfter
  local scoreAfterTable = self:FindComponent("ScoreAfterTable", UITable, self.scoreAfter)
  self.scoreAfterList = UIGridListCtrl.new(scoreAfterTable, GvgScoreFixedCell, "GvgScoreCell")
end

function GvgQuestScoreTip:FindTogs()
  self.toggleRoot = self:FindGO("ToggleRoot")
  self.questTogLab = self:FindComponent("QuestTog", UILabel, self.toggleRoot)
  self.scoreTogLab = self:FindComponent("ScoreTog", UILabel, self.toggleRoot)
  self:AddClickEvent(self.questTogLab.gameObject, function()
    self.questTogLab.color = ColorUtil.NGUIWhite
    self.scoreTogLab.color = _GrayTogLabColor
    self:Show(self.questRoot)
    self:Hide(self.scoreRoot)
  end)
  self:AddClickEvent(self.scoreTogLab.gameObject, function()
    self.scoreTogLab.color = ColorUtil.NGUIWhite
    self.questTogLab.color = _GrayTogLabColor
    self:Show(self.scoreRoot)
    self:Hide(self.questRoot)
  end)
end

function GvgQuestScoreTip:UpdateByGVGSeasonState()
  if self.seasonStateSet then
    return
  end
  self.seasonStateSet = true
  self:Show(self.questRoot)
  self:Hide(self.scoreRoot)
end

function GvgQuestScoreTip:SetPos(pos)
  if self.gameObject then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function GvgQuestScoreTip:SetData()
  self:UpdateQuest()
  self:UpdateScore()
  self:UpdateByGVGSeasonState()
end

function GvgQuestScoreTip:UpdateQuest()
  local result = {}
  local tasks = GvgProxy.Instance:GetGroupTasks() or {}
  local isInLeisure = GvgProxy.Instance:IsGvgInLeisureMode() or false
  local groupTask = GameConfig.GVGConfig and GameConfig.GVGConfig.GvgTask
  for _, _taskInfo in pairs(groupTask) do
    local isFinish = GvgProxy.Instance:CheckGroupTaskIsFinish(_taskInfo.taskid)
    result[#result + 1] = {
      type = 2,
      taskid = _taskInfo.taskid,
      progress = tasks[_taskInfo.taskid] or 0,
      isFinish = isFinish,
      isInLeisure = isInLeisure
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
      isFinish = isFinish,
      isInLeisure = isInLeisure
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
  self.groupQuestList:ResetDatas(result)
end

function GvgQuestScoreTip:UpdateScore()
  self:_UpdateServerScore()
  self:_UpdateFixedScore()
end

function GvgQuestScoreTip:_UpdateServerScore()
  local data = GvgProxy.Instance:IsLeisureSeason() and GvgProxy.Instance:GetLeisureBattleInfo() or GvgProxy.Instance:GetBattleInfo()
  self.scoreMidList:ResetDatas(data)
end

function GvgQuestScoreTip:_UpdateFixedScore()
  local data = GvgProxy.Instance:IsLeisureSeason() and GvgProxy.Instance:GetLeisureBattleEndInfo() or GvgProxy.Instance:GetBattleEndInfo()
  self.scoreAfterList:ResetDatas(data)
end

function GvgQuestScoreTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function GvgQuestScoreTip:OnExit()
  EventManager.Me():RemoveEventListener(ServiceEvent.GuildCmdGvgScoreInfoUpdateGuildCmd, self._UpdateServerScore, self)
  self.scoreMidList:RemoveAll()
  return GvgQuestScoreTip.super.OnExit(self)
end

function GvgQuestScoreTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function GvgQuestScoreTip:DestroySelf()
  self.scoreMidList:RemoveAll()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
