autoImport("QuestionnaireOptionCell")
autoImport("FloatMessage")
QuestionnaireView = class("QuestionnaireView", BaseView)
QuestionnaireView.ViewType = UIViewType.NormalLayer
local texObjStaticNameMap = {
  ViewBg = "Questionnaire_bg_bottom01",
  Bg3 = "Questionnaire_bg_bottom",
  Pattern = "new_taskmanual_bg_pattern"
}
local floatMsgMoveDuration, floatMsgRetainedDuration, floatMsgTickId = 0.8, 1, 99
local picIns, questionnaireIns, tickManager

function QuestionnaireView:Init()
  if not picIns then
    picIns = PictureManager.Instance
    questionnaireIns = QuestionnaireProxy.Instance
    tickManager = TimeTickManager.Me()
  end
  self:InitData()
  self:LoadPrefabByConfig()
  self:FindObjs()
  self:InitView()
  self:AddListenEvts()
end

function QuestionnaireView:InitData()
  local viewData = self.viewdata.viewdata
  self.group = viewData and viewData.group or 1
  self.questionDataMap = questionnaireIns:GetQuestionDataMapByGroup(self.group)
  self.step = self.questionDataMap.min
  self.qNumber = 1
end

function QuestionnaireView:LoadPrefabByConfig()
  local partData = self.questionDataMap[self.step]
  self:_LoadPrefab(partData and partData.UI or 1)
end

function QuestionnaireView:_LoadPrefab(id)
  local obj = self:LoadPreferb("part/QuestionnairePart" .. id, self:FindGO("PartContainer"))
  if not obj then
    LogUtility.ErrorFormat("Cannot load questionnaire part with id={0}!", id)
    return
  end
  obj.transform.localPosition = LuaGeometry.Const_V3_zero
end

function QuestionnaireView:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.questionLabel = self:FindComponent("Question", UILabel)
  self.qnLabel = self:FindComponent("QuestionNumber", UILabel)
  self.progressLabel = self:FindComponent("Progress", UILabel)
  self.optionGrid = self:FindComponent("OptionGrid", UIGrid)
  for objName, _ in pairs(texObjStaticNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
end

function QuestionnaireView:InitView()
  self.optionGridCtrl = ListCtrl.new(self.optionGrid, QuestionnaireOptionCell, "QuestionnaireOptionCell")
  self.optionGridCells = self.optionGridCtrl:GetCells()
  self.nextBtn = self:FindGO("Next")
  self:AddClickEvent(self.nextBtn, function()
    local nextId
    for _, cell in pairs(self.optionGridCells) do
      if cell.toggle.value then
        nextId = cell.data and cell.data.id
        break
      end
    end
    if not nextId then
      self:ShowMsgByID(41361)
      return
    end
    if not self.questionDataMap[nextId] then
      QuestionnaireProxy.CallPaperResultInter(self.group, nextId)
      self:CloseSelf()
      return
    end
    self.step = nextId
    self.qNumber = self.qNumber + 1
    self:UpdatePart()
  end)
  self:AddButtonEvent("CloseButton", function()
    self:Close()
  end)
end

function QuestionnaireView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function QuestionnaireView:OnEnter()
  QuestionnaireView.super.OnEnter(self)
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:SetUI(texName, self[objName])
  end
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, function()
    self:Close()
  end)
  self:sendNotification(UIEvent.CloseUI, UIViewType.DialogLayer)
  self:sendNotification(UIEvent.CloseUI, UIViewType.DialogMaskLayer)
  tickManager:CreateOnceDelayTick(100, function()
    local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.FloatLayer)
    if layer then
      layer:Hide()
    end
  end, self)
  self.targetNpc = questionnaireIns:GetLastVisitedNpc()
  if self.targetNpc then
    self:CameraFocusAndRotateTo(self.targetNpc.assetRole.completeTransform, CameraConfig["Questionnaire_ViewPort" .. self.group] or CameraConfig.Questionnaire_ViewPort1, CameraConfig["Questionnaire_Rotation" .. self.group] or CameraConfig.Questionnaire_Rotation1)
    self:SetHideCreatureSceneUi(self.targetNpc, true)
  else
    LogUtility.Warning("Cannot find target NPC.")
  end
  self:SetHideCreatureSceneUi(Game.Myself, true)
  self:PlayUIEffect(EffectMap.UI["Questionnaire_Next" .. self.group] or EffectMap.UI.Questionnaire_Next1, self.nextBtn, false, function(obj, args, assetEffect)
    self.nextEffect = assetEffect
  end)
  self:UpdatePart()
end

function QuestionnaireView:OnExit()
  for objName, texName in pairs(texObjStaticNameMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  self:CameraReset()
  if self.targetNpc then
    self:SetHideCreatureSceneUi(self.targetNpc, false)
  end
  self:SetHideCreatureSceneUi(Game.Myself, false)
  questionnaireIns:ClearLastVisitedNpc()
  UIManagerProxy.Instance:NeedEnableAndroidKey(true, UIManagerProxy.GetDefaultNeedEnableAndroidKeyCallback())
  local layer = UIManagerProxy.Instance:GetLayerByType(UIViewType.FloatLayer)
  if layer then
    layer:Show()
  end
  tickManager:ClearTick(self)
  if self.floatMsg then
    self.floatMsg:Destroy()
  end
  QuestionnaireView.super.OnExit(self)
end

function QuestionnaireView:OnShow()
  Game.Myself:UpdateEpNodeDisplay(true)
end

function QuestionnaireView:UpdatePart()
  local partData = self.questionDataMap[self.step]
  if not partData then
    LogUtility.WarningFormat("Cannot find question data with group={0} and number={1}", self.group, self.step)
    self:CloseSelf()
    return
  end
  self.titleLabel.text = partData.Title
  local progress, maxProgress = partData.Numeral[1], partData.Numeral[2]
  self.questionLabel.text = string.format(ZhString.Questionnaire_QuestionFormat, progress, partData.Question)
  UIUtil.FitLableSpaceChangeLine(self.questionLabel)
  self.optionGridCtrl:ResetDatas(StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(partData.Answer)))
  self.qnLabel.text = string.format("Q%s:", self.qNumber or 0)
  self.progressLabel.text = string.format("%s/%s", progress, maxProgress)
  for _, cell in pairs(self.optionGridCells) do
    cell.toggle.value = false
    EventDelegate.Set(cell.toggle.onChange, function()
      if self.nextEffect then
        self.nextEffect:ResetAction(cell.toggle.value and "state1002" or "state1001", 0, true)
      end
      for _, c in pairs(self.optionGridCells) do
        if c ~= cell then
          c.toggle.value = false
        end
      end
    end)
  end
  if self.nextEffect then
    self.nextEffect:ResetAction("state1001", 0, true)
  end
  self:UpdateNpcBehavior(partData.PaperEffect)
end

function QuestionnaireView:UpdateNpcBehavior(behaviorTable)
  if type(behaviorTable) ~= "table" then
    return
  end
  if type(behaviorTable[1]) == "table" then
    for i = 1, #behaviorTable do
      self:_UpdateNpcBehavior(behaviorTable[i])
    end
  elseif behaviorTable.type then
    self:_UpdateNpcBehavior(behaviorTable)
  end
end

function QuestionnaireView:_UpdateNpcBehavior(behavior)
  local t = behavior.type
  if t == "action" then
    self:NpcPlayAction(behavior.id)
  elseif t == "talk" then
    local d = DialogUtil.GetDialogData(behavior.id)
    if d then
      self:NpcSpeak(d.Text)
    else
      LogUtility.WarningFormat("Cannot find dialog data while dialog id = {0}", behavior.id)
    end
  end
end

function QuestionnaireView:NpcSpeak(text)
  if not self.targetNpc then
    return
  end
  self.targetNpc:GetSceneUI().roleTopUI:Speak(text)
end

function QuestionnaireView:NpcPlayAction(actionId)
  if not self.targetNpc then
    return
  end
  local actionData = Table_ActionAnime[actionId]
  if not actionData then
    return
  end
  self.targetNpc:Client_PlayAction(actionData.Name, nil, false)
end

local maskTypes = {
  MaskPlayerUIType.BloodType,
  MaskPlayerUIType.NameType
}

function QuestionnaireView:SetHideCreatureSceneUi(creature, isHide)
  if not creature then
    return
  end
  local methodName = isHide and "MaskUI" or "UnMaskUI"
  if creature[methodName] then
    for _, t in pairs(maskTypes) do
      creature[methodName](creature, PUIVisibleReason.InteractNpc, t)
    end
  end
end

function QuestionnaireView:ShowMsgByID(id)
  local data = Table_Sysmsg[id]
  if not data then
    redlog("Cannot find id " .. id .. " in Table_Sysmsg")
    return
  end
  if not self.floatMsg then
    self.floatMsg = FloatMessage.new(self:FindGO("FloatMsgContainer"))
  end
  local go = self.floatMsg.gameObject
  go:SetActive(true)
  self.floatMsg:SetMsg(data.Text)
  go.transform.localPosition = LuaGeometry.GetTempVector3(0, -60)
  TweenPosition.Begin(go, floatMsgMoveDuration, LuaGeometry.GetTempVector3(0, -10))
  tickManager:ClearTick(self, floatMsgTickId)
  tickManager:CreateOnceDelayTick((floatMsgMoveDuration + floatMsgRetainedDuration) * 1000, function(self)
    self.floatMsg.gameObject:SetActive(false)
  end, self, floatMsgTickId)
end

function QuestionnaireView:Close()
  local closeViewData = questionnaireIns:GetCloseViewQuestionDataByGroup(self.group)
  if closeViewData then
    QuestionnaireProxy.CallPaperResultInter(self.group, closeViewData.id)
  else
    LogUtility.WarningFormat("Cannot find close view question data when group = {0}", self.group)
  end
  self:CloseSelf()
end
