local baseCell = autoImport("BaseCell")
QuestTraceCell = class("QuestTraceCell", baseCell)
local checkScale = LuaVector3.New(0.8, 0.8, 1)
local lockScale = LuaVector3.New(0.7, 0.7, 1)
local daySec = 86400

function QuestTraceCell:Init()
  self:initView()
end

function QuestTraceCell:initView()
  self.stepName = self:FindComponent("StepName", UILabel)
  self.stepTarget = self:FindComponent("StepTarget", UILabel)
  self.traceScrollViewPanel = self:FindComponent("TraceScrollView", UIPanel)
  self.traceScrollView = self:FindComponent("TraceScrollView", UIScrollView)
  local sv = self:FindGO("preQuestScrollView")
  if sv then
    self.preQuestScrollView = sv:GetComponent(UIPanel)
  end
  self.questComplete = self:FindComponent("questComplete", UISprite)
  self.traceConplete = self:FindComponent("traceConplete", UISprite)
  self.traceMark = self:FindGO("TraceMark")
  self.tracelabel = self:FindGO("Label", self.traceMark)
  self.traceicon = self:FindGO("icon", self.traceMark)
  self.traceMark_BoxCollider = self.traceMark:GetComponent(BoxCollider)
  self.questState = self:FindGO("questState")
  local questStateSP = self.questState:GetComponent(UISprite)
  IconManager:SetArtFontIcon("Rewardtask_txt_1", questStateSP)
  self:AddButtonEvent("TraceMark", function()
    local staticData = Table_Map[Game.MapManager:GetMapID()]
    if staticData ~= nil and WorldMapProxy.Instance:IsCloneMap() then
      ServiceMapProxy.Instance:CallChangeCloneMapCmd(staticData.CloneMap)
      return
    end
    if self.data and self.data.questData then
      if not self.isMainViewTrace then
        EventManager.Me():DispatchEvent(QuestManualEvent.BeforeGoClick, self)
      end
      if QuestProxy.Instance:checkIsShowDirAndDis(self.data.questData) then
        FunctionQuest.Me():executeManualQuest(self.data.questData)
      else
        FunctionQuest.Me():executeQuest(self.data.questData)
      end
    end
    if self.data.gotomode then
      FuncShortCutFunc.Me():CallByID(self.data.gotomode)
    end
  end)
  self.preQuestContainer = self:FindGO("preQuestContainer")
  self.traceContainer = self:FindGO("traceContainer")
  local traceObj = self:FindGO("traceGrid")
  if traceObj then
    self.traceGrid = traceObj:GetComponent(UIGrid)
  end
  local label = self:FindGO("prequestDesc")
  if label then
    self.prequestDesc = label:GetComponent(UILabel)
  end
  if not BranchMgr.IsChina() then
    self.lableTweenInfo = {}
    if self.prequestDesc then
      local prequestDescTween = self.prequestDesc.gameObject:GetComponent(TweenPosition)
      if prequestDescTween == nil then
        prequestDescTween = self.prequestDesc.gameObject:AddComponent(TweenPosition)
        prequestDescTween.enabled = false
      end
      self.preQuestScrollView.gameObject:GetComponent(UIScrollView).enabled = false
      self.lableTweenInfo[1] = {}
      self.lableTweenInfo[1].tween = prequestDescTween
      self.lableTweenInfo[1].maxSize = self.preQuestScrollView.width
      self.lableTweenInfo[1].pos = self.prequestDesc.transform.localPosition
      self.lableTweenInfo[1].label = self.prequestDesc
    end
    if self.stepTarget then
      self.traceScrollView:ResetPosition()
      self.traceScrollView.enabled = false
      local stepTargetTween = self.stepTarget.gameObject:GetComponent(TweenPosition)
      if stepTargetTween == nil then
        stepTargetTween = self.stepTarget.gameObject:AddComponent(TweenPosition)
        stepTargetTween.enabled = false
      end
      self.lableTweenInfo[2] = {}
      self.lableTweenInfo[2].tween = stepTargetTween
      self.lableTweenInfo[2].maxSize = self.traceScrollViewPanel.width
      self.lableTweenInfo[2].pos = self.stepTarget.transform.localPosition
      self.lableTweenInfo[2].label = self.stepTarget
    end
  end
  local tips = self:FindGO("tips")
  if tips then
    self.tips = tips:GetComponent(UILabel)
  end
  self.effectContainer = self:FindGO("EffectContainer")
end

function QuestTraceCell:SetData(data)
  self:OverseaLableStop(2)
  self.data = data
  if data and (data.stepName or data.stepTarget) then
    self.stepName.text = data.stepName
    self.stepTarget.text = data.stepTarget
    if self.traceContainer then
      self.traceContainer:SetActive(true)
    end
    return
  end
  if data and data.gotomode and data.growthId then
    local staticData = Table_Growth[data.growthId]
    self.stepName.text = staticData.maintitle
    self.stepTarget.text = staticData.subtitle
    self.questId = data.questId
    return
  end
  if data and data.gotomode and data.versionGoalID then
    helplog("VersionGoalID", data.versionGoalID)
    local staticData = Table_VersionGoal[data.versionGoalID]
    self.stepName.text = staticData.maintitle
    self.stepTarget.text = string.format(staticData.subtitle, data.process)
    if self.traceContainer then
      self.traceContainer:SetActive(true)
    end
    return
  end
  local isAcceptable = true
  local questData = data.questData
  self.questId = questData and questData.id
  if self.preQuestContainer then
    self.preQuestContainer:SetActive(false)
  end
  if self.traceContainer then
    self.traceContainer:SetActive(false)
  end
  self.stepTarget.text = ""
  if self.tips then
    self.tips.text = ""
  end
  if questData.staticData then
    self.stepName.text = questData.staticData.Name
    local desStr = questData:parseTranceInfo()
    desStr = string.gsub(desStr, "\n", "")
    if questData.type == QuestDataType.QuestDataType_DAILY then
      local dailyData = QuestProxy.Instance:getDailyQuestData(SceneQuest_pb.EOTHERDATA_DAILY)
      local ratio = "0%"
      local exp = "0"
      if dailyData then
        ratio = dailyData.param4 * 100
        ratio = ratio .. "%"
        exp = dailyData.param3
      end
      desStr = string.format(desStr, exp)
      self.stepTarget.text = string.gsub(desStr, "ffff00", "FFA823")
      self.preQuestContainer:SetActive(false)
    end
    local tempdesStr = ""
    local checklevel = ""
    local checkQuest = ""
    local isPrenameAdded = false
    local isCompleteAll = true
    local isLevelComplete = true
    if data.type ~= SceneQuest_pb.EQUESTLIST_ACCEPT then
      local qStaticData = questData.staticData
      local mylv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
      if qStaticData.Level ~= 0 then
        if mylv < qStaticData.Level then
          isLevelComplete = false
        end
        checklevel = string.format(ZhString.QuestManual_Level, qStaticData.Level)
      end
      local myRisk = AdventureDataProxy.Instance:getManualLevel()
      if qStaticData.Risklevel ~= 0 then
        if myRisk < qStaticData.Risklevel then
          isLevelComplete = false
        end
        checklevel = checklevel .. string.format(ZhString.QuestManual_RiskLevel, qStaticData.Risklevel)
      end
      local myjob = Game.Myself.data.userdata:Get(UDEnum.JOBLEVEL)
      if qStaticData.Joblevel ~= 0 then
        if myjob < qStaticData.Joblevel then
          isLevelComplete = false
        end
        checklevel = checklevel .. string.format(ZhString.QuestManual_JobLevel, qStaticData.Joblevel)
      end
      local mycook = Game.Myself.data.userdata:Get(UDEnum.COOKER_LV)
      if qStaticData.CookerLv ~= 0 then
        if mycook < qStaticData.CookerLv then
          isLevelComplete = false
        end
        checklevel = checklevel .. string.format(ZhString.QuestManual_CookerLevel, qStaticData.CookerLv)
      end
      local mytaste = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
      if qStaticData.TasterLv ~= 0 then
        if mytaste < qStaticData.TasterLv then
          isLevelComplete = false
        end
        checklevel = checklevel .. string.format(ZhString.QuestManual_TasterLevel, qStaticData.TasterLv)
      end
      if isLevelComplete then
        preMenu = questData.preMenu
        if preMenu and 0 < #preMenu then
          for i = 1, #preMenu do
            if not FunctionUnLockFunc.Me():CheckCanOpen(preMenu[i]) then
              local config = Table_Menu[preMenu[i]]
              if config and config.text then
                if 1 < i then
                  checklevel = checklevel .. ZhString.QuestManual_QuestNameOr
                end
                checklevel = checklevel .. config.text
                isLevelComplete = false
              end
            end
          end
        end
        mustPreMenu = questData.mustPreMenu
        if mustPreMenu and 0 < #mustPreMenu then
          for i = 1, #mustPreMenu do
            if not FunctionUnLockFunc.Me():CheckCanOpen(mustPreMenu[i]) then
              local config = Table_Menu[mustPreMenu[i]]
              if config and config.text then
                if 1 < i then
                  checklevel = checklevel .. ZhString.QuestManual_QuestNameAdd
                end
                checklevel = checklevel .. config.text
                isLevelComplete = false
              end
            end
          end
        end
      end
      preQuestList = questData.preQuest
      if preQuestList and 0 < #preQuestList then
        isPrenameAdded = true
        checkQuest = checkQuest .. ZhString.QuestManual_NeedToComplete
        for i = 1, #preQuestList do
          local questNameData = QuestManualProxy.Instance:GetQuestNameDataById(preQuestList[i])
          if not questNameData then
            break
          end
          local questName = questNameData.GetQuestName and questNameData:GetQuestName() or ""
          if questName ~= "" then
            if 1 < i then
              checkQuest = checkQuest .. ZhString.QuestManual_QuestNameOr
            end
            checkQuest = checkQuest .. string.format(ZhString.QuestManual_QuestName, questName)
          end
          if questNameData.isComplete and not questNameData:isComplete() then
            isCompleteAll = false
          end
        end
      end
      mustPreQuestList = questData.mustPreQuest
      if mustPreQuestList and 0 < #mustPreQuestList then
        if not isPrenameAdded then
          checkQuest = checkQuest .. ZhString.QuestManual_NeedToComplete
          isPrenameAdded = true
        end
        for i = 1, #mustPreQuestList do
          local questNameData = QuestManualProxy.Instance:GetQuestNameDataById(mustPreQuestList[i])
          if not questNameData then
            break
          end
          local questName = questNameData.GetQuestName and questNameData:GetQuestName() or ""
          if questName ~= "" then
            if 1 < i then
              checkQuest = checkQuest .. ZhString.QuestManual_QuestNameAdd
            end
            checkQuest = checkQuest .. string.format(ZhString.QuestManual_QuestName, questName)
          end
          if questNameData.isComplete and not questNameData:isComplete() then
            isCompleteAll = false
          end
        end
      end
      if isCompleteAll then
        if self.questComplete then
          self.questComplete.spriteName = "com_icon_check"
          self.questComplete:MakePixelPerfect()
          self.questComplete.gameObject.transform.localScale = checkScale
        end
      elseif self.questComplete then
        self.questComplete.spriteName = "com_icon_lock"
        self.questComplete:MakePixelPerfect()
        self.questComplete.gameObject.transform.localScale = lockScale
      end
    end
    if self.preQuestContainer then
      self.preQuestContainer:SetActive(isPrenameAdded)
    end
    if questData.staticData.PreNoShow == 1 then
      self.stepTarget.text = ""
      if self.traceContainer then
        self.traceContainer:SetActive(false)
      end
    elseif not questData.accepttime or 0 >= questData.accepttime then
      if data.type ~= SceneQuest_pb.EQUESTLIST_ACCEPT then
        if checklevel ~= "" then
          self.stepTarget.text = string.gsub(checklevel, "ffff00", "FFA823")
          if self.traceConplete then
            self.traceConplete.gameObject:SetActive(true)
            if isLevelComplete then
              self.traceConplete.spriteName = "com_icon_check"
              self.traceConplete:MakePixelPerfect()
              self.traceConplete.gameObject.transform.localScale = checkScale
            else
              self.traceConplete.spriteName = "com_icon_lock"
              self.traceConplete:MakePixelPerfect()
              self.traceConplete.gameObject.transform.localScale = lockScale
            end
          end
          if self.traceContainer then
            self.traceContainer:SetActive(true)
          end
        end
        if isPrenameAdded and self.prequestDesc then
          self:OverseaLableStop(1)
          self.prequestDesc.text = string.gsub(checkQuest, "ffff00", "FFA823")
          self:OverseaLableStart(1)
        end
      else
        if self.traceConplete then
          self.traceConplete.gameObject:SetActive(false)
        end
        if desStr ~= "" then
          self.stepTarget.text = string.gsub(desStr, "ffff00", "FFA823")
          if self.traceContainer then
            self.traceContainer:SetActive(true)
          end
        elseif self.traceContainer then
          self.traceContainer:SetActive(false)
        end
      end
    else
      self.stepTarget.text = ""
      if self.traceContainer then
        self.traceContainer:SetActive(false)
      end
      if self.preQuestContainer then
        self.preQuestContainer:SetActive(false)
      end
      if self.tips then
        local deltasec = questData.accepttime - ServerTime.CurServerTime() / 1000
        if deltasec <= daySec then
          self.tips.text = ZhString.QuestManual_AcceptTimeTips1
        else
          local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(deltasec)
          if 0 < hour or 0 < min or 0 < sec then
            day = day + 1
          end
          self.tips.text = string.format(ZhString.QuestManual_AcceptTimeTips2, day)
        end
      end
    end
    self:OverseaLableStart(2)
    self.traceScrollView:ResetPosition()
  else
    self.stepName.text = data.questPreName
  end
  if self.traceGrid then
    self.traceGrid:Reposition()
  end
  if self.data.type then
    self:RefreshMark()
  end
  if self.effectContainer then
    self:PlayUIEffect(EffectMap.UI.MainViewTrace_QuestSwitch, self.effectContainer, true)
  end
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and self.traceScrollViewPanel then
    self.traceScrollViewPanel.depth = upPanel.depth + 1
    if self.preQuestScrollView then
      self.preQuestScrollView.depth = upPanel.depth + 1
    end
  end
end

function QuestTraceCell:RefreshMark()
  if self.data.type == SceneQuest_pb.EQUESTLIST_ACCEPT then
    local result = self:CheckCanMove()
    self.traceMark:SetActive(not result.hideall)
    if not result.hideall then
      self.tracelabel:SetActive(result.canmove)
      self.traceicon:SetActive(not result.canmove)
    end
    self.questState:SetActive(false)
  elseif self.data.type == SceneQuest_pb.EQUESTLIST_CANACCEPT then
    self.traceMark:SetActive(false)
    self.questState:SetActive(false)
  elseif self.data.type == SceneQuest_pb.EQUESTLIST_SUBMIT then
    self.traceMark:SetActive(false)
    self.questState:SetActive(true)
  elseif self.data.type == "branch" then
    local result = self:CheckCanMove()
    self.traceMark:SetActive(not result.hideall)
    if not result.hideall then
      self.tracelabel:SetActive(result.canmove)
      self.traceicon:SetActive(not result.canmove)
    end
    self.questState:SetActive(false)
  else
    self.traceMark:SetActive(false)
    self.questState:SetActive(false)
  end
end

function QuestTraceCell:SetIsMainViewTrace(b)
  self.isMainViewTrace = b
end

function QuestTraceCell:CheckCanMove()
  local result = {}
  result.hideall = false
  result.canmove = true
  if self.data and self.data.questData then
    local qData = self.data.questData
    if qData then
      local isInFuben = self:IsInFuben()
      if isInFuben then
        result.hideall = true
      elseif qData.map or qData.pos or qData.params and qData.params.distance or qData.params and qData.params.uniqueid then
        result.hideall = false
        result.canmove = true
      else
        result.hideall = false
        result.canmove = false
      end
    end
  end
  return result
end

function QuestTraceCell:CheckHideSelf()
  if self.data and self.data.gotomode then
    return false
  end
  if self.data and self.data.questData then
    if self.data then
      self:RefreshMark()
    end
    local qData = self.data.questData
    if qData then
      local isInFuben = self:IsInFuben()
      if isInFuben then
        return true
      else
        return false
      end
    end
  end
  return true
end

function QuestTraceCell:IsInFuben()
  local curRaidId = Game.MapManager:GetRaidID()
  if curRaidId == 10001 then
    curRaidId = nil
  end
  local specialRaid = Table_MapRaid[curRaidId]
  if specialRaid and specialRaid.Feature and specialRaid.Feature & 2 > 0 then
    curRaidId = nil
  end
  if curRaidId == nil or curRaidId == 0 then
    curRaidId = ServicePlayerProxy.Instance:GetCurMapImageId()
  end
  return curRaidId ~= nil and 0 < curRaidId
end

function QuestTraceCell:OverseaLableStart(_index)
  if BranchMgr.IsChina() then
    return
  end
  self:StartTweenLable(self.lableTweenInfo[_index].label, self.lableTweenInfo[_index].maxSize, self.lableTweenInfo[_index].tween, self.lableTweenInfo[_index].pos, 5, 1)
end

function QuestTraceCell:OverseaLableStop(_index)
  if BranchMgr.IsChina() then
    return
  end
  self:StopTweenLable(self.lableTweenInfo[_index].tween)
end
