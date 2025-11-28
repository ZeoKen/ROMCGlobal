JointInferencePanel = class("JointInferencePanel", ContainerView)
JointInferencePanel.ViewType = UIViewType.NormalLayer
autoImport("JointInferenceCheckEvidencePage")
autoImport("JointInferenceCheckPhotoPage")
autoImport("JointInferenceEvidenceComparePage")
autoImport("JointInferenceChoosePhotoPage")
autoImport("JointInferenceResultPage")
autoImport("EvidenceGridCell")
local bgTexturePath = "Sevenroyalfamilies_bg"
local decorateTextureNameMap = {
  Decorate16 = "Sevenroyalfamilies_bg_decoration16",
  Decorate17 = "Sevenroyalfamilies_bg_decoration17",
  Decorate18 = "Sevenroyalfamilies_bg_decoration18",
  Decorate19 = "Sevenroyalfamilies_bg_decoration19"
}
local picIns = PictureManager.Instance

function JointInferencePanel:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function JointInferencePanel:FindObjs()
  self.bgTexture = self:FindGO("bgTexture"):GetComponent(UITexture)
  self.checkEvidencePageObj = self:FindGO("CheckEvidencePage")
  self.checkPhotoPageObj = self:FindGO("CheckPhotoPage")
  self.evidenceComparePageObj = self:FindGO("EvidenceChomparePage")
  self.choosePhotoPageObj = self:FindGO("ChoosePhotoPage")
  self.resultPageObj = self:FindGO("ResultPage")
  self.checkEvidencePage = self:FindGO("JointInferenceCheckEvidencePage")
  self.questionNumLabel = self:FindGO("QuestionNum"):GetComponent(UILabel)
  self.questionLabel = self:FindGO("QuestionLabel"):GetComponent(UILabel)
  self.reportLabel = self:FindGO("ReportLabel"):GetComponent(UILabel)
  self.evidenceGrid = self:FindGO("EvidenceGrid"):GetComponent(UIGrid)
  self.evidenceGridCtrl = UIGridListCtrl.new(self.evidenceGrid, EvidenceGridCell, "ManorPartnerHeadCell")
  self.evidenceGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseEvidence, self)
  self.evidenceGridCtrl:AddEventListener(SevenRoyalFamilies.JointInferenceLongPressEvidence, self.HandleShowEvidenceDetail, self)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmBtn_BoxCollider = self.confirmBtn:GetComponent(BoxCollider)
  self.checkLabel = self:FindGO("CheckLabel"):GetComponent(UILabel)
  self.descBg = self:FindGO("DescBg")
  self.nameLabel = self:FindGO("NameLabel", self.descBg):GetComponent(UILabel)
  self.descLabel = self:FindGO("DescLabel", self.descBg):GetComponent(UILabel)
  self.descBg:SetActive(false)
  self.descScrollView = self:FindGO("DescScrollView"):GetComponent(UIScrollView)
  self.finishPanel = self:FindGO("FinishPanel")
  self.processLabel = self:FindGO("ProcessLabel", self.finishPanel):GetComponent(UILabel)
  self.finishPanel:SetActive(false)
  self.closeBtn = self:FindGO("CloseButton")
  self.tipsContainer = self:FindGO("TipsContainer")
  self.tipsRoot = self:FindGO("Root", self.tipsContainer)
  self.tipsRoot:SetActive(false)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.picBtn = self:FindGO("PicBtn")
  self.picturePanel = self:FindGO("PicturePanel")
  self.compareTexture = self:FindGO("CompareTexture", self.picturePanel):GetComponent(UITexture)
  self.dynamicBG = self:FindGO("DynamicBG", self.picturePanel):GetComponent(UISprite)
  self.closePictureBtn = self:FindGO("ClosePictureBtn", self.picturePanel)
  self.checkEvidencePage_TweenPos = self.checkEvidencePage:GetComponent(TweenPosition)
  self.checkEvidencePage_TweenAlpha = self.checkEvidencePage:GetComponent(TweenAlpha)
  self.checkPhoto_TweenPos = self.checkPhotoPageObj:GetComponent(TweenPosition)
  self.checkPhoto_TweenAlpha = self.checkPhotoPageObj:GetComponent(TweenAlpha)
  self.evidenceCompare_TweenPos = self.evidenceComparePageObj:GetComponent(TweenPosition)
  self.evidenceCompare_TweenAlpha = self.evidenceComparePageObj:GetComponent(TweenAlpha)
  self.choosePhoto_TweenPos = self.choosePhotoPageObj:GetComponent(TweenPosition)
  self.choosePhoto_TweenAlpha = self.choosePhotoPageObj:GetComponent(TweenAlpha)
  self.resultPage_TweenPos = self.resultPageObj:GetComponent(TweenPosition)
  self.resultPage_TweenAlpha = self.resultPageObj:GetComponent(TweenAlpha)
  self.checkEvidencePage_TweenPos:ResetToBeginning()
  self.checkEvidencePage_TweenAlpha:ResetToBeginning()
  self.line = self:FindGO("ActiveLine")
  self.line:SetActive(false)
  self.finishBGGO = self:FindGO("FinishBg")
  self.finishBG_TweenScale = self.finishBGGO:GetComponent(TweenScale)
  self.finishContainer = self:FindGO("Container", self.finishPanel)
  self.finishContainer_TweenAlpha = self.finishContainer:GetComponent(TweenAlpha)
  self.tips_TweenPos = self.tipsRoot:GetComponent(TweenPosition)
  self.tips_TweenPos:SetOnFinished(function()
    self.tipsRoot:SetActive(false)
  end)
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
end

function JointInferencePanel:AddEvts()
  self:AddClickEvent(self.confirmBtn, function()
    if not self.curChooseEvidence then
      return
    end
    xdlog("click confirm")
    self:CheckEvidenceCorrent()
  end)
  self:AddClickEvent(self.closeBtn, function()
    redlog("失败跳转")
    if self.questData then
      QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FailJump)
    end
    self:CloseSelf()
  end)
  self:AddClickEvent(self.picBtn, function()
    local texPath = self.staticData and self.staticData.CompareTexture
    if texPath and texPath ~= "" then
      self.compareTexturePath = texPath
      picIns:SetSevenRoyalFamiliesTexture(texPath, self.compareTexture)
      self.compareTexture:MakePixelPerfect()
      self.dynamicBG.width = self.compareTexture.width + 34
      self.dynamicBG.height = self.compareTexture.height + 34
      self.picturePanel:SetActive(true)
    end
  end)
  self:AddClickEvent(self.closePictureBtn, function()
    if self.compareTexturePath then
      picIns:UnloadSevenRoyalFamiliesTexture(self.compareTexturePath, self.compareTexture)
      self.compareTexturePath = nil
    end
    self.picturePanel:SetActive(false)
  end)
end

function JointInferencePanel:AddMapEvts()
end

function JointInferencePanel:InitDatas()
  self.curQuestionType = 1
  self.curQuestionID = 1
  self.curInferenceIndex = 1
  self.evidenceList = {}
  self.unlockedMessage = {}
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.questData = viewdata and viewdata.questData
  if self.questData then
    self.inferenceList = self.questData.params.ids
    self.logicAnalysisResult = self.questData.params.analysis
  else
    self.inferenceList = {
      9,
      11,
      12
    }
  end
end

function JointInferencePanel:InitShow()
  TimeTickManager.Me():CreateOnceDelayTick(500, function(owner, deltaTime)
    self:RefreshCurQuestion(self.inferenceList[self.curInferenceIndex])
  end, self, 8)
end

function JointInferencePanel:RefreshCurQuestion(id)
  xdlog("当前联合推理ID", id)
  local questionId = id
  local staticData = Table_JointInference[id]
  if not staticData then
    redlog("联合推理缺少", id)
    return
  end
  self.checkPhotoPageObj:SetActive(false)
  self.evidenceComparePageObj:SetActive(false)
  self.choosePhotoPageObj:SetActive(false)
  self.staticData = staticData
  self.curChooseEvidence = nil
  local showList = {}
  self.evidenceList = staticData.AllEvidenceList
  for i = 1, #self.evidenceList do
    local id = self.evidenceList[i]
    local staticData = Table_Evidence[id]
    if staticData then
      local data = {staticData = staticData}
      table.insert(showList, data)
    end
  end
  if #showList == 0 then
    self:RunToQuestion()
    return
  end
  self.evidenceGridCtrl:ResetDatas(showList)
  self.checkEvidencePage_TweenPos:PlayForward()
  self.checkEvidencePage_TweenAlpha:ResetToBeginning()
  self.checkEvidencePage_TweenAlpha:PlayForward()
  self.line:SetActive(false)
  self.descBg:SetActive(false)
  local extendStr = #self.inferenceList == 1 and "" or self.curInferenceIndex .. "/" .. #self.inferenceList
  self.questionNumLabel.text = string.format(ZhString.JointInferencePanel_Question, extendStr)
  self.questionLabel.text = staticData.Question
  if self.unlockedMessage and 0 < #self.unlockedMessage then
    local str = ZhString.QuestManual_TwoSpace
    for i = 1, #self.unlockedMessage do
      local messageInfo = Table_EvidenceMessage[self.unlockedMessage[i]]
      if messageInfo then
        str = str .. i .. "." .. messageInfo.Description .. "\n" .. ZhString.QuestManual_TwoSpace
      end
    end
    self.reportLabel.text = str
  end
  local compareTexture = staticData.CompareTexture
  if compareTexture and compareTexture ~= "" then
    self.picBtn:SetActive(true)
  else
    self.picBtn:SetActive(false)
  end
  self.targetEvidence = staticData.TargetEvidence
  self.tipsList = staticData.Tips
  self:RefreshEvidenceChoose()
  self:SetTextureGrey(self.confirmBtn)
  self.confirmBtn_BoxCollider.enabled = false
end

function JointInferencePanel:RefreshEvidenceChoose()
  local count = self.curChooseEvidence and #self.curChooseEvidence or 0
  local maxCount = #self.targetEvidence
  if #self.targetEvidence == 1 then
    self.checkLabel.text = ZhString.JointInferencePanel_AnswerCount
    if count == 0 then
      xdlog("gray1")
      self:SetTextureGrey(self.confirmBtn)
      self.confirmBtn_BoxCollider.enabled = false
    else
      self:SetTextureWhite(self.confirmBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
      self.confirmBtn_BoxCollider.enabled = true
    end
  else
    local extendStr = ""
    if count > maxCount then
      extendStr = string.format("[c][FF0000](%s/%s)[-][/c]", count, maxCount)
      self:SetTextureGrey(self.confirmBtn)
      self.confirmBtn_BoxCollider.enabled = false
    elseif count < maxCount then
      extendStr = string.format("[c][6D77B5](%s/%s)[-][/c]", count, maxCount)
      self:SetTextureGrey(self.confirmBtn)
      self.confirmBtn_BoxCollider.enabled = false
    elseif count == maxCount then
      extendStr = string.format("[c][009A5A](%s/%s)[-][/c]", count, maxCount)
      self:SetTextureWhite(self.confirmBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
      self.confirmBtn_BoxCollider.enabled = true
    end
    self.checkLabel.text = ZhString.JointInferencePanel_AnswerCount .. extendStr
  end
end

function JointInferencePanel:HandleChooseEvidence(cellCtrl)
  if cellCtrl and cellCtrl.id then
    if #self.targetEvidence == 1 then
      local cells = self.evidenceGridCtrl:GetCells()
      for i = 1, #cells do
        cells[i]:SetChoose(false)
      end
      cellCtrl:SetChoose(true)
    else
      cellCtrl:SwitchChoose()
    end
    self.nameLabel.text = cellCtrl.data.staticData.Name
    local itemConfig = Table_Item[cellCtrl.id]
    self.descLabel.text = itemConfig and itemConfig.Desc
  end
  self.curChooseEvidence = {}
  local str = ""
  local cells = self.evidenceGridCtrl:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    if cell.chooseSymbol.activeSelf then
      str = str .. cell.id .. ", "
      table.insert(self.curChooseEvidence, cell.id)
    end
  end
  xdlog(str)
  self.descScrollView:ResetPosition()
  if not self.curChooseEvidence or #self.curChooseEvidence == 0 then
    self.line:SetActive(false)
    self.descBg:SetActive(false)
  else
    self.line:SetActive(true)
    self.descBg:SetActive(true)
  end
  self.descScrollView:ResetPosition()
  self:RefreshEvidenceChoose()
end

function JointInferencePanel:HandleShowEvidenceDetail(cellCtrl)
  TipManager.Instance:ShowEvidenceDetailTip(cellCtrl.id, cellCtrl.icon, nil, {-180, 0})
end

function JointInferencePanel:CheckEvidenceCorrent()
  local corrent = true
  if not self.targetEvidence then
    return
  end
  if #self.curChooseEvidence ~= #self.targetEvidence then
    corrent = false
    redlog("数量不对", #self.targetEvidence)
    self:PlayTips(4)
    return
  end
  for i = 1, #self.targetEvidence do
    local single = self.targetEvidence[i]
    if TableUtility.ArrayFindIndex(self.curChooseEvidence, single) == 0 then
      corrent = false
      redlog("答案不符合")
      self:PlayTips(4)
      return
    end
  end
  if corrent then
    self:RunToQuestion()
  end
end

function JointInferencePanel:RunToQuestion()
  self.checkEvidencePage_TweenPos:PlayReverse()
  self.checkEvidencePage_TweenAlpha:PlayReverse()
  local id = self.inferenceList[self.curInferenceIndex]
  local staticData = Table_JointInference[id]
  if staticData then
    local type = staticData.Type
    if type == 1 then
      if not self.checkPhotoPage then
        self.checkPhotoPage = self:AddSubView("JointInferenceCheckPhotoPage", JointInferenceCheckPhotoPage)
      end
      self.checkPhotoPageObj:SetActive(true)
      self.checkPhoto_TweenPos:ResetToBeginning()
      self.checkPhoto_TweenPos:PlayForward()
      self.checkPhoto_TweenAlpha:ResetToBeginning()
      self.checkPhoto_TweenAlpha:PlayForward()
      self.checkPhotoPage:RefreshQuestion(id)
    elseif type == 2 then
      if not self.evidenceComparePage then
        self.evidenceComparePage = self:AddSubView("JointInferenceEvidenceComparePage", JointInferenceEvidenceComparePage)
      end
      self.evidenceComparePageObj:SetActive(true)
      self.evidenceCompare_TweenPos:ResetToBeginning()
      self.evidenceCompare_TweenPos:PlayForward()
      self.evidenceCompare_TweenAlpha:ResetToBeginning()
      self.evidenceCompare_TweenAlpha:PlayForward()
      self.evidenceComparePage:RefreshQuestion(id)
    elseif type == 3 then
      if not self.choosePhotoPage then
        self.choosePhotoPage = self:AddSubView("JointInferenceChoosePhotoPage", JointInferenceChoosePhotoPage)
      end
      self.choosePhotoPageObj:SetActive(true)
      self.choosePhoto_TweenPos:ResetToBeginning()
      self.choosePhoto_TweenPos:PlayForward()
      self.choosePhoto_TweenAlpha:ResetToBeginning()
      self.choosePhoto_TweenAlpha:PlayForward()
      self.choosePhotoPage:RefreshQuestion(id)
    end
  end
end

function JointInferencePanel:ProcessFinish(messageId)
  self.processLabel.text = self.curInferenceIndex .. "/" .. #self.inferenceList
  self.finishPanel:SetActive(true)
  self:PlayTweens()
  if messageId then
    table.insert(self.unlockedMessage, messageId)
  end
  TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    self.finishPanel:SetActive(false)
    self.curInferenceIndex = self.curInferenceIndex + 1
    if self.curInferenceIndex > #self.inferenceList then
      self.curInferenceIndex = #self.inferenceList
      xdlog("结算界面")
      if #self.unlockedMessage == 0 then
        self:QuestNotify()
        self:CloseSelf()
      else
        self:ShowResult()
      end
      return
    end
    self:RefreshCurQuestion(self.inferenceList[self.curInferenceIndex])
  end, self, 6)
end

function JointInferencePanel:ShowResult()
  self.checkEvidencePage:SetActive(false)
  self.checkPhotoPageObj:SetActive(false)
  self.evidenceComparePageObj:SetActive(false)
  self.choosePhotoPageObj:SetActive(false)
  self.resultPage = self:AddSubView("JointInferenceResultPage", JointInferenceResultPage)
  self.checkEvidencePage_TweenPos:PlayReverse()
  self.checkEvidencePage_TweenAlpha:PlayReverse()
  self.resultPage:SetData(self.unlockedMessage, self.logicAnalysisResult)
  self.resultPage_TweenPos:ResetToBeginning()
  self.resultPage_TweenPos:PlayForward()
  self.resultPage_TweenAlpha:ResetToBeginning()
  self.resultPage_TweenAlpha:PlayForward()
end

function JointInferencePanel:PlayTips(type)
  xdlog("播放提示", type)
  if not self.tipsList then
    return
  end
  if self.tipsList[type] then
    local tipID = self.tipsList[type]
    local dialogData = DialogUtil.GetDialogData(tipID)
    if dialogData then
      if dialogData.Voice and dialogData.Voice ~= "" then
        FunctionPlotCmd.Me():PlayNpcVisitVocal(dialogData.Voice)
      end
      self.tipLabel.text = dialogData.Text
    end
    self.tipsRoot:SetActive(true)
    self.tips_TweenPos:ResetToBeginning()
    self.tips_TweenPos:PlayForward()
  end
end

function JointInferencePanel:QuestNotify()
  xdlog("胜利跳转")
  if self.questData then
    QuestProxy.Instance:notifyQuestState(self.questData.scope, self.questData.id, self.questData.staticData.FinishJump)
  end
end

function JointInferencePanel:PlayTweens()
  self.finishBG_TweenScale:ResetToBeginning()
  self.finishContainer_TweenAlpha:ResetToBeginning()
  self.finishBG_TweenScale:PlayForward()
  self.finishContainer_TweenAlpha:PlayForward()
  self:PlayUISound(AudioMap.UI.InferenceResearchComplete)
end

function JointInferencePanel:OnEnter()
  JointInferencePanel.super.OnEnter(self)
  picIns:SetSevenRoyalFamiliesTexture(bgTexturePath, self.bgTexture)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  ServiceQuestProxy.Instance:CallEvidenceQueryCmd()
end

function JointInferencePanel:OnExit()
  TimeTickManager.Me():ClearTick(self)
  JointInferencePanel.super.OnExit(self)
  picIns:UnloadSevenRoyalFamiliesTexture(bgTexturePath, self.bgTexture)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  if self.compareTexturePath then
    picIns:UnloadSevenRoyalFamiliesTexture(self.compareTexturePath, self.compareTexture)
    self.compareTexturePath = nil
  end
end
