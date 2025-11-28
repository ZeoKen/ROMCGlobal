autoImport("QuestionnaireChooseCell")
autoImport("RewardGridCell")
autoImport("PlayerSurveyClassCell")
PlayerSurveyView = class("PlayerSurveyView", BaseView)
PlayerSurveyView.ViewType = UIViewType.NormalLayer
local btnGray = {
  "new-com_btn_a_gray",
  LuaColor.New(0.9372549019607843, 0.9372549019607843, 0.9372549019607843),
  LuaColor.New(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
}
local btnLightBlue = {
  "new-com_btn_a",
  LuaColor.New(1, 1, 1),
  LuaColor.New(0.27058823529411763, 0.37254901960784315, 0.6823529411764706)
}
local bgTexture = "Questionnaire_bg_Pattern2"

function PlayerSurveyView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitData()
  self:InitShow()
end

function PlayerSurveyView:FindObjs()
  self.homePage = self:FindGO("HomePage")
  self.homePage_TweenRot = self.homePage:GetComponent(TweenRotation)
  self.titleRoot = self:FindGO("Title")
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.mainTip1 = self:FindGO("Label1"):GetComponent(UILabel)
  self.ruleTable = self:FindGO("RuleTable"):GetComponent(UITable)
  self.rule1 = self:FindGO("Rule1")
  self.rule1Label = self:FindGO("Label", self.rule1):GetComponent(UILabel)
  self.rewardGrid = self:FindGO("RewardGrid"):GetComponent(UIGrid)
  self.rewardGridCtrl = UIGridListCtrl.new(self.rewardGrid, RewardGridCell, "RewardGridCell")
  self.rewardGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickRewardCell, self)
  self.startBtn = self:FindGO("StartBtn")
  self.homePageCloseBtn = self:FindGO("HomePageCloseButton")
  self.dynamicBG = self:FindGO("DynamicBG")
  self.dynamicBG_TweenPos = self.dynamicBG:GetComponent(TweenPosition)
  self.dynamicBG_TweenRot = self.dynamicBG:GetComponent(TweenRotation)
  self.dynamicBG_TweenAlph = self.dynamicBG:GetComponent(TweenAlpha)
  self.behindDecorate1 = self:FindGO("BehindDecorate", self.homePage):GetComponent(UITexture)
  self.mainPage = self:FindGO("MainPage")
  self.mainPage_TweenAlpha = self.mainPage:GetComponent(TweenAlpha)
  self.mainPage_TweenRotation = self.mainPage:GetComponent(TweenRotation)
  self.mainPage_TweenPosition = self.mainPage:GetComponent(TweenPosition)
  self.chooseType = self:FindGO("ChooseType")
  self.questionTypeLabel = self:FindGO("QuestionTypeLabel"):GetComponent(UILabel)
  self.questionLabel = self:FindGO("QuestionLabel"):GetComponent(UILabel)
  self.chooseLimit = self:FindGO("ChooseLimit"):GetComponent(UILabel)
  self.stepLabel = self:FindGO("StepLabel"):GetComponent(UILabel)
  self.chooseScrollView = self:FindGO("ChooseScrollView"):GetComponent(UIScrollView)
  self.chooseTable = self:FindGO("ChooseTable"):GetComponent(UITable)
  self.chooseTogCtrl = UIGridListCtrl.new(self.chooseTable, QuestionnaireChooseCell, "QuestionnaireChooseCell")
  self.chooseTogCtrl:AddEventListener(MouseEvent.MouseClick, self.clickTogEvent, self)
  self.chooseTogCtrl:AddEventListener(PlayerSurveyEvent.OnManualInputChange, self.UpdateInputAnswer, self)
  self.chooseTogCtrl:AddEventListener(PlayerSurveyEvent.OnManualInputSubmit, self.UpdateInputAnswer, self)
  self.manualInputType = self:FindGO("ManualInputType")
  self.manualInput = self:FindGO("Input"):GetComponent(UIInput)
  self.classType = self:FindGO("ClassType")
  self.classScrollView = self:FindGO("ClassScrollView"):GetComponent(UIScrollView)
  self.classGrid = self:FindGO("ClassGrid"):GetComponent(UIGrid)
  self.classGridCtrl = UIGridListCtrl.new(self.classGrid, PlayerSurveyClassCell, "PlayerSurveyClassCell")
  self.classGridCtrl:AddEventListener(PlayerSurveyEvent.ClickClassTog, self.clickTogEvent, self)
  self.mainPageCloseBtn = self:FindGO("MainPageCloseBtn")
  self.previousBtn = self:FindGO("PreviousBtn")
  self.nextBtn = self:FindGO("NextBtn")
  self.nextBtnIcon = self.nextBtn:GetComponent(UISprite)
  self.nextBtnLabel = self:FindGO("Label", self.nextBtn):GetComponent(UILabel)
  self.nextBtn_BoxCollider = self.nextBtn:GetComponent(BoxCollider)
  self.submitBtn = self:FindGO("SubmitBtn")
  self.submitBtnIcon = self.submitBtn:GetComponent(UISprite)
  self.submitBtn_BoxCollider = self.submitBtn:GetComponent(BoxCollider)
  self.behindDecorate2 = self:FindGO("BehindDecorate", self.mainPage):GetComponent(UITexture)
end

function PlayerSurveyView:AddEvts()
  self:AddClickEvent(self.startBtn, function()
    self.mainPage:SetActive(true)
    self.titleRoot:SetActive(false)
    self.homePageCloseBtn:SetActive(false)
    self.homePage_TweenRot:PlayForward()
    self.mainPage_TweenAlpha:ResetToBeginning()
    self.mainPage_TweenAlpha:PlayForward()
    self.mainPage_TweenPosition:PlayForward()
    self.mainPage_TweenRotation:PlayForward()
    self.dynamicBG_TweenPos:PlayForward()
    self.dynamicBG_TweenRot:PlayForward()
    self.dynamicBG_TweenAlph:PlayForward()
  end)
  self:AddClickEvent(self.homePageCloseBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.mainPageCloseBtn, function()
    MsgManager.ConfirmMsgByID(42035, function()
      self:CloseSelf()
    end)
  end)
  self:AddClickEvent(self.previousBtn, function()
    self:GoLeft()
  end)
  self:AddClickEvent(self.nextBtn, function()
    self:GoRight()
  end)
  self:AddClickEvent(self.submitBtn, function()
    MsgManager.ConfirmMsgByID(42036, function()
      self:SubmitSurvey()
    end)
  end)
  EventDelegate.Add(self.manualInput.onChange, function()
    self:UpdateInputAnswer()
  end)
  local onSubmit = function()
    xdlog("填空题 输入完成")
    self:UpdateInputAnswer()
  end
  EventDelegate.Add(self.manualInput.onSubmit, function()
    self:UpdateInputAnswer()
  end)
  self:AddSelectEvent(self.manualInput, onSubmit)
end

function PlayerSurveyView:AddMapEvts()
  self:AddListenEvt(PlayerSurveyEvent.OnManualInputSubmit, self.UpdateInputAnswer)
end

function PlayerSurveyView:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.answerList = {}
  self.myselfList = {}
  self.questionList = PlayerSurveyProxy.Instance:GetQuestionList()
  self.totalQuestionNum = self.questionList and #self.questionList or 0
  self.curQuestionIndex = 1
  self.startTimeStamp = ServerTime.CurServerTime() / 1000
end

function PlayerSurveyView:InitShow()
  if self.questionList and #self.questionList == 0 then
    return
  end
  PictureManager.Instance:SetUI(bgTexture, self.behindDecorate1)
  PictureManager.Instance:SetUI(bgTexture, self.behindDecorate2)
  self:UpdateQuestion(self.curQuestionIndex)
  self.curSurveyID = PlayerSurveyProxy.Instance.curSurveyID
  local surveyConfig = Table_Questionnaire[self.curSurveyID]
  if not surveyConfig then
    return
  end
  self.titleLabel.text = surveyConfig.Name
  local starttime, endtime
  if EnvChannel.IsTFBranch() then
    starttime = surveyConfig.BeginTimeTF
    endtime = surveyConfig.EndTimeTF
  else
    starttime = surveyConfig.BeginTime
    endtime = surveyConfig.EndTime
  end
  self.timeLabel.text = string.format(ZhString.PlayerSurveryView_ActivityTime, starttime, endtime)
  self:FillTextByHelpId(surveyConfig.DesID, self.mainTip1)
  self:FillTextByHelpId(surveyConfig.HelpID, self.rule1Label)
  local rewardList = {}
  local reward = surveyConfig.RewardItem
  if reward and 0 < #reward then
    for i = 1, #reward do
      local itemid, num = reward[i][1], reward[i][2]
      local data = {}
      data.itemData = ItemData.new("Reward", itemid)
      if data.itemData then
        data.num = num
        table.insert(rewardList, data)
      end
    end
  end
  self.rewardGridCtrl:ResetDatas(rewardList)
end

function PlayerSurveyView:GoLeft()
  if self.curQuestionIndex <= 1 then
    return
  end
  for i = self.curQuestionIndex, 1, -1 do
    if i ~= self.curQuestionIndex and TableUtility.ArrayFindIndex(self.myselfList, i) > 0 then
      xdlog("往前推上一题", i)
      self.curQuestionIndex = i
      break
    end
  end
  self:UpdateQuestion(self.curQuestionIndex)
end

function PlayerSurveyView:GoRight()
  if self.curQuestionIndex >= self.totalQuestionNum then
    return
  end
  local nextIndex = self:GetNextValidQuestion()
  if nextIndex ~= nil then
    self.curQuestionIndex = nextIndex
    xdlog("右键下一题 并刷新", self.curQuestionIndex)
    self:UpdateQuestion(self.curQuestionIndex)
  else
    self:UpdateBtns(self.curQuestionIndex, true)
  end
end

function PlayerSurveyView:MoveToNextValidQuestion()
  local nextIndex = self:GetNextValidQuestion()
  if nextIndex ~= nil then
    self.curQuestionIndex = nextIndex
    xdlog("移动到下一题 并刷新", self.curQuestionIndex)
    self:UpdateQuestion(self.curQuestionIndex)
  end
end

function PlayerSurveyView:GetNextValidQuestion()
  if self.curQuestionIndex >= self.totalQuestionNum then
    return nil
  end
  for i = self.curQuestionIndex + 1, self.totalQuestionNum do
    local single = self.questionList[i]
    if not single.PreQuestion or single.PreQuestion == _EmptyTable or self:CheckPreQuestion(single.PreQuestion) then
      xdlog("下一题ID", i)
      return i
    end
  end
  return nil
end

function PlayerSurveyView:CheckPreQuestion(prequestion)
  for i = 1, #prequestion do
    local single = prequestion[i]
    local index = single[1] and single[1] % self.curSurveyID
    if self.answerList[index] and self.answerList[index].chooseList and TableUtility.ArrayFindIndex(self.answerList[index].chooseList, single[2]) > 0 then
      xdlog("前置条件满足", single[2])
      return true
    end
  end
  return false
end

function PlayerSurveyView:clickTogEvent(cellCtrl)
  local answerIndex = cellCtrl.indexInList
  if not self.answerList[self.curQuestionIndex] then
    self.answerList[self.curQuestionIndex] = {
      id = self.questionID
    }
  end
  local curTogCtrl = self.classChooseType and self.classGridCtrl or self.chooseTogCtrl
  local cells = curTogCtrl and curTogCtrl:GetCells()
  if self.chooseMax > 1 then
    local curChoose = 0
    for i = 1, #cells do
      local single = cells[i]
      if single.chooseStatus then
        curChoose = curChoose + 1
      end
    end
    if not cellCtrl.chooseStatus and curChoose >= self.chooseMax then
      MsgManager.ShowMsgByID(42037)
      return
    end
    cellCtrl:SwitchStatus()
    if self.questionType == 2 then
      if answerIndex == #cells then
        cellCtrl:SetInputField()
      end
      self.inputAnswer = cells[#cells].chooseStatus
    end
  else
    for i = 1, #cells do
      local single = cells[i]
      if single.indexInList == answerIndex then
        single:SetChoose(true)
      else
        single:SetChoose(false)
      end
    end
    if self.questionType == 2 then
      cells[#cells]:SetInputField()
      self.inputAnswer = cells[#cells].chooseStatus
    end
  end
  local tempList = {}
  for i = 1, #cells do
    if cells[i].chooseStatus then
      TableUtility.ArrayPushBack(tempList, cells[i].indexInList)
    end
  end
  if tempList and 0 < #tempList then
    self.answerList[self.curQuestionIndex].chooseList = tempList
  else
    redlog("当题无选择答案", answerIndex)
    self.answerList[self.curQuestionIndex].chooseList = nil
  end
  self:RefreshAnswerChoose()
  if self.chooseMax == 1 and self.questionType ~= 2 then
    self.nextBtn_BoxCollider.enabled = false
    TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
      local nextIndex = self:GetNextValidQuestion()
      if nextIndex ~= nil then
        self.curQuestionIndex = nextIndex
        self:UpdateQuestion(self.curQuestionIndex)
      else
        self:UpdateBtns(self.curQuestionIndex, true)
      end
    end, self, 10)
  else
    local index = self:GetNextValidQuestion()
    local canSubmit = index == nil
    self:UpdateBtns(self.curQuestionIndex, canSubmit)
  end
end

function PlayerSurveyView:UpdateInputAnswer(cellCtrl)
  local manualInput = ""
  if cellCtrl and cellCtrl.answerInput then
    manualInput = cellCtrl.answerInput.value
  else
    manualInput = self.manualInput.value
  end
  local length = string.len(manualInput)
  if 100 < #manualInput then
    manualInput = StringUtil.Sub(manualInput, 1, 100)
    if cellCtrl and cellCtrl.answerInput then
      cellCtrl:SetInputAnswer(manualInput)
    else
      self.manualInput.value = manualInput
    end
  end
  if not self.answerList[self.curQuestionIndex] then
    self.answerList[self.curQuestionIndex] = {
      id = self.questionID
    }
  end
  self.answerList[self.curQuestionIndex].manualInput = manualInput
  if manualInput == "" then
    self.answerList[self.curQuestionIndex].manualInput = nil
  end
  self:UpdateBtns(self.curQuestionIndex)
end

function PlayerSurveyView:UpdateQuestion(index)
  local data = self.questionList[index]
  if not data then
    return
  end
  self.questionType = data.Type
  self.questionID = data.id
  self.chooseMax = data.Max or 0
  local chooseDatas = data.Option
  self.classChooseType = data.Option and data.Option[1] and type(data.Option[1]) == "number" or false
  if data.Type == 3 then
    self.manualInputType:SetActive(true)
    self.chooseType:SetActive(false)
    self.classType:SetActive(false)
    self.questionTypeLabel.text = ZhString.PlayerSurveryView_ManualInput
  elseif self.classChooseType then
    self.manualInputType:SetActive(false)
    self.chooseType:SetActive(false)
    self.classType:SetActive(true)
    if data.Max and data.Max == 1 then
      self.questionTypeLabel.text = ZhString.PlayerSurveryView_SingleChoose
    else
      self.questionTypeLabel.text = ZhString.PlayerSurveryView_MultiChoose
    end
  else
    self.manualInputType:SetActive(false)
    self.chooseType:SetActive(true)
    self.classType:SetActive(false)
    if data.Max and data.Max == 1 then
      self.questionTypeLabel.text = ZhString.PlayerSurveryView_SingleChoose
    else
      self.questionTypeLabel.text = ZhString.PlayerSurveryView_MultiChoose
    end
  end
  self.questionLabel.text = data.Question
  if self.chooseMax > 1 then
    self.chooseLimit.text = string.format(ZhString.PlayerSurveryView_ChooseLimit, self.chooseMax)
  else
    self.chooseLimit.text = ""
  end
  if self.classChooseType then
    self.classGridCtrl:ResetDatas(chooseDatas)
    self.classScrollView:ResetPosition()
  else
    self.chooseTogCtrl:RemoveAll()
    self.chooseTogCtrl:ResetDatas(chooseDatas)
    self.chooseScrollView:ResetPosition()
  end
  self.stepLabel.text = self.curQuestionIndex .. "/" .. self.totalQuestionNum
  local hasAnswer = self:UpdateAnswers(index)
  if not hasAnswer then
    self:UpdateBtns(index)
  else
    local nextIndex = self:GetNextValidQuestion()
    local canSubmit = nextIndex == nil
    self:UpdateBtns(index, canSubmit)
  end
  if TableUtility.ArrayFindIndex(self.myselfList, index) == 0 then
    table.insert(self.myselfList, index)
    table.sort(self.myselfList, function(l, r)
      return l < r
    end)
  end
end

function PlayerSurveyView:UpdateAnswers()
  local cells = self.chooseTogCtrl:GetCells()
  if not self.answerList[self.curQuestionIndex] then
    self.manualInput.value = ""
    return false
  end
  local answers = self.answerList[self.curQuestionIndex].chooseList
  if answers then
    for i = 1, #cells do
      if TableUtility.ArrayFindIndex(answers, cells[i].indexInList) > 0 then
        cells[i]:SetChoose(true)
      else
        cells[i]:SetChoose(false)
      end
      if self.questionType == 2 and cells[i].indexInList == #cells then
        cells[i]:SetInputField()
      end
      local inputAnswer = self.answerList[self.curQuestionIndex].manualInput
      if cells[i].indexInList == #cells then
        cells[i]:SetInputAnswer(inputAnswer)
      end
    end
  end
  if self.questionType == 3 then
    self.manualInput.value = self.answerList[self.curQuestionIndex].manualInput or ""
  end
  return true
end

function PlayerSurveyView:UpdateBtns(index, canSubmit)
  if index == 1 then
    self.previousBtn:SetActive(false)
  elseif 1 < self.totalQuestionNum and 1 < index then
    self.previousBtn:SetActive(true)
  end
  if canSubmit then
    self.nextBtn:SetActive(false)
    local canSubmit = self:CheckCanSubmit()
    xdlog("cansubmit", canSubmit)
    self.submitBtn:SetActive(true)
    self.submitBtnIcon.alpha = canSubmit and 1 or 0.4
    self.submitBtn_BoxCollider.enabled = canSubmit
    return
  end
  if index < self.totalQuestionNum then
    self.nextBtn:SetActive(true)
    self.submitBtn:SetActive(false)
    local cfg
    if self.questionType == 1 then
      if self.answerList[index] and self.answerList[index].chooseList then
        cfg = btnLightBlue
        self.nextBtn_BoxCollider.enabled = true
      else
        cfg = btnGray
        self.nextBtn_BoxCollider.enabled = false
      end
    elseif self.questionType == 2 then
      if not self.answerList[index] or not self.answerList[index].chooseList then
        cfg = btnGray
        self.nextBtn_BoxCollider.enabled = false
      elseif self.answerList[index] and self.inputAnswer and not self.answerList[index].manualInput then
        cfg = btnGray
        self.nextBtn_BoxCollider.enabled = false
      else
        cfg = btnLightBlue
        self.nextBtn_BoxCollider.enabled = true
      end
    elseif self.questionType == 3 then
      if self.answerList[index] and self.answerList[index].manualInput then
        cfg = btnLightBlue
        self.nextBtn_BoxCollider.enabled = true
      else
        cfg = btnGray
        self.nextBtn_BoxCollider.enabled = false
      end
    end
    if cfg then
      self.nextBtnIcon.spriteName = cfg[1]
      self.nextBtnLabel.color = cfg[2]
      self.nextBtnLabel.effectColor = cfg[3]
    end
  else
    self.nextBtn:SetActive(false)
    local canSubmit = self:CheckCanSubmit()
    xdlog("cansubmit", canSubmit)
    self.submitBtn:SetActive(true)
    self.submitBtnIcon.alpha = canSubmit and 1 or 0.4
    self.submitBtn_BoxCollider.enabled = canSubmit
  end
end

function PlayerSurveyView:RefreshAnswerChoose()
  local removeList = {}
  for i = 1, #self.myselfList do
    local index = self.myselfList[i]
    local questionConfig = self.questionList[index]
    if questionConfig and questionConfig.PreQuestion and questionConfig.PreQuestion ~= _EmptyTable then
      local prequestion = questionConfig.PreQuestion
      local delete = true
      for j = 1, #prequestion do
        questionIndex = prequestion[j][1] and prequestion[j][1] % self.curSurveyID
        if self.answerList[questionIndex] and self.answerList[questionIndex].chooseList and TableUtility.ArrayFindIndex(self.answerList[questionIndex].chooseList, prequestion[j][2]) > 0 then
          delete = false
          break
        end
      end
      if delete then
        xdlog("需要移除答案", index)
        table.insert(removeList, index)
      end
    end
  end
  local tempList = {}
  for i = 1, #self.myselfList do
    if TableUtility.ArrayFindIndex(removeList, self.myselfList[i]) == 0 then
      table.insert(tempList, self.myselfList[i])
    end
  end
  self.myselfList = tempList
  for i = 1, #removeList do
    if self.answerList[removeList[i]] then
      self.answerList[removeList[i]] = nil
    end
  end
end

function PlayerSurveyView:SubmitSurvey()
  if self:CheckCanSubmit() then
    local QuestionData = {}
    QuestionData.id = PlayerSurveyProxy.Instance.curSurveyID
    QuestionData.results = {}
    QuestionData.time = ServerTime.CurServerTime() / 1000 - self.startTimeStamp
    for k, v in pairs(self.answerList) do
      local QuestionResult = {}
      QuestionResult.id = v.id
      QuestionResult.opts = v.chooseList
      QuestionResult.text = v.manualInput
      table.insert(QuestionData.results, QuestionResult)
    end
    xdlog("提交答案")
    ServiceItemProxy.Instance:CallQuestionResultItemCmd(QuestionData)
    self:CloseSelf()
  end
end

function PlayerSurveyView:CheckCanSubmit()
  if not self.answerList then
    return false
  end
  local canSubmit = true
  for i = 1, #self.myselfList do
    local index = self.myselfList[i]
    if not self.answerList[index] then
      redlog("有问题未回答", index)
      canSubmit = false
      break
    end
    local answer = self.answerList[index]
    local config = self.questionList[index]
    local type = config.Type
    if type == 1 or type == 2 then
      if not answer.chooseList then
        xdlog("选择题缺少答案", index)
        canSubmit = false
        break
      end
    elseif type == 3 and not answer.manualInput then
      xdlog("填空题缺少答案", index)
      canSubmit = false
      break
    end
  end
  return canSubmit
end

function PlayerSurveyView:HandleClickRewardCell(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data.itemData
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Center, {200, -150})
  end
end

function PlayerSurveyView:OnExit()
  PlayerSurveyView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(bgTexture, self.behindDecorate1)
  PictureManager.Instance:UnLoadUI(bgTexture, self.behindDecorate2)
end
