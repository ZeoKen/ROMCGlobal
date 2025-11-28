autoImport("TaskQuestCell")
TaskQuestExtraCell_TrainEscort = class("TaskQuestExtraCell_TrainEscort", TaskQuestCell)

function TaskQuestExtraCell_TrainEscort:initView()
  TaskQuestExtraCell_TrainEscort.super.initView(self)
  self.progressExtra = self:FindGO("progressExtra")
  if self.progressExtra then
    local p = self:FindGO("fg", self.progressExtra)
    self.progressSp = p:GetComponent(UISprite)
    self.progressSp.fillAmount = 0
  end
  self.phase3BirdContainer = self:FindGO("birdContainer", self.progressExtra)
  self.phase3StartAnchor = self:FindGO("start_anchor", self.progressExtra)
  self.phase3EndAnchor = self:FindGO("end_anchor", self.progressExtra)
  self.phase3birdAngry = self:FindGO("angry", self.phase3BirdContainer)
  self.phase3birdAngry:SetActive(false)
  self.phase3StartAnchorPos = self.phase3StartAnchor.transform.localPosition
  self.phase3EndAnchorPos = self.phase3EndAnchor.transform.localPosition
  self:CreateBirdEffect()
  self.endWidget = self:FindGO("endWidget")
  self:SetEvent(self.bgSprite.gameObject, function()
    self:OnClick()
  end)
end

function TaskQuestExtraCell_TrainEscort:AddLongPress()
end

function TaskQuestExtraCell_TrainEscort:AddCellClickEvent()
end

function TaskQuestExtraCell_TrainEscort:OnClick()
  if not self.data.is_inEscortMap then
    FuncShortCutFunc.Me():CallByID(GameConfig.TrainEscort.GotoShortCut)
  end
end

function TaskQuestExtraCell_TrainEscort:SetData(data)
  self.data = data
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  if not data.is_open then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self:OverSeaStopTweenLable()
  if not data.emptyCell then
    if not self.container.activeSelf then
      self.container:SetActive(true)
    end
    if self.widget.gameObject.activeSelf then
      self.widget.gameObject:SetActive(false)
    end
  else
    if self.container.activeSelf then
      self.container:SetActive(false)
    end
    if not self.widget.gameObject.activeSelf then
      self.widget.gameObject:SetActive(true)
    end
    return
  end
  self:SetTitleIcon(false)
  self.IconFromServer = nil
  self.ColorFromServer = nil
  self.specialIcon = nil
  self.groupid = nil
  self.nInvadeStyle = nil
  self.nInvadeItemId = nil
  self.nInvadeFinishTraceList = nil
  self.titleBg = nil
  self.iconStr = nil
  self.questList = nil
  local name = ZhString.TrainEscort_TheName
  self:SetTitleText(name)
  self.iconStr = "new-main_icon_activity"
  self:SetMyIconByServer(self.iconStr)
  local desStr = self:parseTranceInfo(data)
  self:SetIconObj(true)
  if StringUtil.ChLength(name) > 18 then
    self.title.fontSize = 18
  else
    self.title.fontSize = 20
  end
  if BranchMgr.IsChina() then
    UIUtil.WrapLabel(self.title)
  else
    self:OverSeaTweenLable()
  end
  if desStr ~= nil then
    self.desc:SetText(desStr)
  end
  self:initColor()
  self.ColorFromServer = 1
  self:ShowTitleColor()
  self:ShowDetail(data)
  local descHeight = self.desc.richLabel.height
  self.endWidget.transform.localPosition = LuaGeometry.GetTempVector3(60, -descHeight - 66, 0)
  self.progressExtra.transform.localPosition = LuaGeometry.GetTempVector3(107, -descHeight - 84, 0)
end

function TaskQuestExtraCell_TrainEscort:ShowTitleColor()
  self.title.color = LuaGeometry.GetTempColor()
  self.title.effectColor = LuaGeometry.GetTempColor(0.6235294117647059, 0.14901960784313725, 0.2823529411764706)
end

function TaskQuestExtraCell_TrainEscort:parseTranceInfo(data)
  local desc = ""
  if not data.is_inEscortMap then
    desc = ZhString.TrainEscort_TaskDesc_4
  elseif data.clientState == 0 then
    desc = string.format(ZhString.TrainEscort_Tip2, GameConfig.TrainEscort.StartTime, GameConfig.TrainEscort.EndTime)
  elseif data.clientState == 1 then
    desc = ZhString.TrainEscort_TaskDesc_1
  elseif data.clientState == 2 then
  elseif data.clientState == 3 then
    desc = ZhString.TrainEscort_TaskDesc_5
  elseif data.clientState == 4 then
    desc = ZhString.TrainEscort_TaskDesc_2
  elseif data.clientState == 999 then
    desc = ZhString.TrainEscort_TaskDesc_6
  end
  if data.clientState == 2 then
    local wait_sec = data.data.start_time - ServerTime.CurServerTime() / 1000
    if wait_sec < 0 then
      wait_sec = 0
    end
    self:SetClientState1CountDown(true, wait_sec)
    return
  else
    self:SetClientState1CountDown(false)
  end
  return desc
end

function TaskQuestExtraCell_TrainEscort:SetClientState1CountDown(isTrue, sec)
  TimeTickManager.Me():ClearTick(self, 1001)
  if isTrue then
    TimeTickManager.Me():CreateTick(0, 1000, function(self)
      local time = os.date("%M", sec) .. ":" .. os.date("%S", sec)
      time = string.format(ZhString.TrainEscort_Tip1, time)
      self.desc:SetText(time)
      sec = sec - 1
      if sec < 0 then
        TimeTickManager.Me():ClearTick(self, 1001)
      end
    end, self, 1001)
  end
end

function TaskQuestExtraCell_TrainEscort:ShowDetail(data)
  if not data or not data.is_inEscortMap then
    self.progressExtra:SetActive(false)
    return
  end
  if data.clientState == 1 or data.clientState == 3 or data.clientState == 4 then
    self.progressExtra:SetActive(true)
    local process = data.data.process / 100
    if 1 < process then
      process = 1
    elseif process < 0 then
      process = 0
    end
    self.progressSp.fillAmount = process
    self:UpdatePhase3BirdPosition(process)
    if data.clientState == 3 or data.clientState == 4 then
      self:SetPlayBirdEffect(false)
      self.phase3birdAngry:SetActive(true)
    else
      self:SetPlayBirdEffect(true)
      self.phase3birdAngry:SetActive(false)
    end
  else
    self.progressExtra:SetActive(false)
  end
end

function TaskQuestExtraCell_TrainEscort:CreateBirdEffect()
  if not self.phase3BridEffect then
    self.phase3BridEffect = self:PlayUIEffect(EffectMap.UI.TrainEscortBird, self.phase3BirdContainer, false, function(obj, args, assetEffect)
      self.phase3BridAnimator = assetEffect.effectObj:GetComponentInChildren(Animator, true)
      self:ShowDetail(self.data)
    end)
  end
end

function TaskQuestExtraCell_TrainEscort:UpdatePhase3BirdPosition(p)
  self.phase3BirdContainer.transform.localPosition = LuaVector3.Lerp(self.phase3StartAnchorPos, self.phase3EndAnchorPos, p)
end

function TaskQuestExtraCell_TrainEscort:SetPlayBirdEffect(isPlay)
  if self.phase3BridAnimator then
    if isPlay then
      self.phase3BridAnimator:Play("ufx_escprt_bird_am", -1, 0)
      self.phase3BridAnimator.speed = 1
    else
      self.phase3BridAnimator:Play("ufx_escprt_bird_am", -1, 0)
      self.phase3BridAnimator.speed = 0
    end
  end
end
