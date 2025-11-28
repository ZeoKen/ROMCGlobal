JointInferenceEvidenceComparePage = class("JointInferenceEvidenceComparePage", SubView)
JointInferenceEvidenceComparePage.ViewType = UIViewType.NormalLayer
autoImport("EvidenceGridCell")
local viewPath = ResourcePathHelper.UIView("JointInferenceEvidenceComparePage")
local effectPath = EffectMap.UI.SevenRoyalFamilies_EvidenceBook_UI01
local picIns = PictureManager.Instance

function JointInferenceEvidenceComparePage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.evidenceComparePageObj, true)
  obj.name = "JointInferenceEvidenceComparePage"
end

function JointInferenceEvidenceComparePage:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
end

function JointInferenceEvidenceComparePage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("JointInferenceEvidenceComparePage")
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.evidenceCell = self:FindGO("EvidenceCell")
  self.evidenceTexture = self:FindGO("Texture", self.evidenceCell):GetComponent(UITexture)
  self.evidenceCell_EffContainer = self:FindGO("EffectContainer", self.evidenceCell)
  self.targetEvidenceCell = self:FindGO("TargetEvidenceCell", self.gameObject)
  self.targetEvidenceTexture = self:FindGO("Texture", self.targetEvidenceCell):GetComponent(UITexture)
  self.targetEvidenceCell_EffContainer = self:FindGO("EffectContainer", self.targetEvidenceCell)
  self.listRoot = self:FindGO("ListRoot")
  self.evidenceScrollView = self:FindGO("EvidenceScrollView", self.listRoot):GetComponent(UIScrollView)
  self.evidenceGrid = self:FindGO("EvidenceGrid", self.listRoot):GetComponent(UIGrid)
  self.evidenceGridCtrl = UIGridListCtrl.new(self.evidenceGrid, EvidenceGridCell, "ManorPartnerHeadCell")
  self.evidenceGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleChooseEvidence, self)
  self.compareBtn = self:FindGO("CompareBtn", self.gameObject)
  self.compareBtn_BoxCollider = self.compareBtn:GetComponent(BoxCollider)
  self.leftIndicator = self:FindGO("LeftIndicator", self.gameObject)
  self.rightIndicator = self:FindGO("RightIndicator", self.gameObject)
  self.tipsContainer = self:FindGO("TipsContainer", self.gameObject)
  self.tipLabelGO = self:FindGO("TipLabel")
  self.tipLabel = self.tipLabelGO:GetComponent(UILabel)
  self.tipLabel_TweenAlpha = self.tipLabelGO:GetComponent(TweenAlpha)
  self.tipLabel_TweenAlpha:ResetToBeginning()
  self.clickCollider = self:FindGO("ClickCollider", self.tipsContainer):GetComponent(BoxCollider)
  self.clickCollider.enabled = false
  self.targetEvidenceCell_TweenPos = self.targetEvidenceCell:GetComponent(TweenPosition)
  self.targetEvidenceCell_TweenAlpha = self.targetEvidenceCell:GetComponent(TweenAlpha)
  self.targetEvidenceCell_TweenPos:SetOnFinished(function()
    if self.currentState == TNTStateEnum.FADE_OUT then
      self:PlayFadeIn()
    end
  end)
end

function JointInferenceEvidenceComparePage:AddEvts()
  self:AddClickEvent(self.compareBtn, function()
    xdlog("点击对比")
    self:DoSubmit()
  end)
  self:AddClickEvent(self.leftIndicator, function()
    self.curIndex = self.curIndex - 1
    if self.curIndex < 1 then
      self.curIndex = 1
    end
    self:SwitchEvidence(self.curIndex)
    self:RefreshIndicator()
    self:PlayFadeOut(30)
  end)
  self:AddClickEvent(self.rightIndicator, function()
    self.curIndex = self.curIndex + 1
    if self.curIndex > self.maxEvidenceNum then
      self.curIndex = self.maxEvidenceNum
    end
    self:SwitchEvidence(self.curIndex)
    self:RefreshIndicator()
    self:PlayFadeOut(-30)
  end)
end

function JointInferenceEvidenceComparePage:AddMapEvts()
end

function JointInferenceEvidenceComparePage:InitDatas()
  self.evidenceList = {}
end

function JointInferenceEvidenceComparePage:InitShow()
  xdlog("initshow")
end

function JointInferenceEvidenceComparePage:HandleChooseEvidence(cellCtrl)
  if cellCtrl and cellCtrl.id then
    if self.curChooseEvidence then
      self.curChooseEvidence:SetChoose(false)
    end
    self.curChooseEvidence = cellCtrl
    self.curChooseEvidence:SetChoose(true)
    self.curChooseIndex = cellCtrl.indexInList
    if self.myEvidenceTexture then
      picIns.Instance:UnloadSevenRoyalFamiliesTexture(self.myEvidenceTexture, self.targetEvidenceTexture)
    end
    if self.targetEvidenceTexture then
      xdlog("texture存在", type)
    else
      redlog("targetEvidenceTexture 不存在")
    end
    self.myEvidenceTexture = self.evidenceList[self.curChooseIndex] and self.evidenceList[self.curChooseIndex][2]
    xdlog("texture name", cellCtrl.id, self.myEvidenceTexture)
    if self.myEvidenceTexture ~= nil and self.myEvidenceTexture ~= "" then
      picIns.Instance:SetSevenRoyalFamiliesTexture(self.myEvidenceTexture, self.targetEvidenceTexture)
    end
  end
  if self.curChooseEvidence then
    self.compareBtn_BoxCollider.enabled = true
    self:SetTextureColor(self.compareBtn)
    self:SetTextureWhite(self.compareBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
  end
end

function JointInferenceEvidenceComparePage:RefreshQuestion(id)
  local questionId = id
  local staticData = Table_JointInference[id]
  if not staticData then
    return
  end
  self.staticData = staticData
  self.titleLabel.text = staticData.Title or "???"
  self.answer = staticData.Answer
  self.unlockMessage = staticData.Message
  self.evidenceList = staticData.EvidenceList
  self.tipsList = staticData.Tips
  if self.evidenceList and #self.evidenceList > 0 then
    self.maxEvidenceNum = #self.evidenceList
    self:SwitchEvidence(1)
    self.curIndex = 1
    self:RefreshIndicator()
  end
  self.targetEvidenceTexturePath = staticData.CompareTexture
  if self.targetEvidenceTexturePath and self.targetEvidenceTexturePath ~= "" then
    picIns.Instance:SetSevenRoyalFamiliesTexture(self.targetEvidenceTexturePath, self.evidenceTexture)
  end
  self:PlayDefaultQuestion()
  self.clickCollider.enabled = false
end

function JointInferenceEvidenceComparePage:SwitchEvidence(index)
  if not self.evidenceList then
    return
  end
  if not self.evidenceList[index] then
    return
  end
  if self.compareTexturePath then
    picIns.Instance:UnloadSevenRoyalFamiliesTexture(self.compareTexturePath, self.targetEvidenceTexture)
  end
  self.compareTexturePath = self.evidenceList[index][2]
  if self.compareTexturePath ~= "" and self.compareTexturePath ~= nil then
    picIns.Instance:SetSevenRoyalFamiliesTexture(self.compareTexturePath, self.targetEvidenceTexture)
  end
  self:PlayUISound(AudioMap.UI.InferencePaperTurning)
end

function JointInferenceEvidenceComparePage:RefreshIndicator()
  if self.curIndex == 1 then
    self.leftIndicator:SetActive(false)
  else
    self.leftIndicator:SetActive(true)
  end
  if self.curIndex >= self.maxEvidenceNum then
    self.rightIndicator:SetActive(false)
  else
    self.rightIndicator:SetActive(true)
  end
end

function JointInferenceEvidenceComparePage:CheckAnswers()
  if not self.curIndex or not self.answer then
    return
  end
  if self.curIndex == self.answer[1] then
    return true
  end
  return false
end

function JointInferenceEvidenceComparePage:DoSubmit()
  self:PlayUIEffect(effectPath, self.evidenceCell_EffContainer, true)
  self:PlayUIEffect(effectPath, self.targetEvidenceCell_EffContainer, true)
  self:PlayUISound(AudioMap.UI.InferenceEvidenceScan)
  self.clickCollider.enabled = true
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    if self:CheckAnswers() then
      self:PlayTips(1)
      TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
        self.clickCollider.enabled = true
        TimeTickManager.Me():ClearTick(self, 6)
        self.container:ProcessFinish(self.unlockMessage)
      end, self, 3)
    else
      self:PlayTips(2)
      TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
        self.clickCollider.enabled = false
      end, self, 4)
    end
  end, self, 2)
end

function JointInferenceEvidenceComparePage:PlayTips(type)
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
    self.tipLabel_TweenAlpha:ResetToBeginning()
    self.tipLabel_TweenAlpha:PlayForward()
    TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
      self:PlayDefaultQuestion()
    end, self, 6)
  end
end

function JointInferenceEvidenceComparePage:PlayDefaultQuestion()
  self.tipLabel_TweenAlpha:ResetToBeginning()
  self.tipLabel_TweenAlpha:PlayForward()
  local tipID = self.tipsList[3]
  local dialogData = DialogUtil.GetDialogData(tipID)
  if dialogData then
    if dialogData.Voice and dialogData.Voice ~= "" then
      FunctionPlotCmd.Me():PlayNpcVisitVocal(dialogData.Voice)
    end
    self.tipLabel.text = dialogData.Text
  end
end

function JointInferenceEvidenceComparePage:PlayFadeOut(offset)
  self.currentState = TNTStateEnum.FADE_OUT
  self.offset = offset
  self.targetEvidenceCell_TweenPos.from = LuaGeometry.GetTempVector3(170, -19.6, 0)
  self.targetEvidenceCell_TweenPos.to = LuaGeometry.GetTempVector3(170 + offset, -19.6, 0)
  self.targetEvidenceCell_TweenPos:ResetToBeginning()
  self.targetEvidenceCell_TweenPos:PlayForward()
  self.targetEvidenceCell_TweenAlpha.from = 1
  self.targetEvidenceCell_TweenAlpha.to = 0
  self.targetEvidenceCell_TweenAlpha:ResetToBeginning()
  self.targetEvidenceCell_TweenAlpha:PlayForward()
end

function JointInferenceEvidenceComparePage:PlayFadeIn()
  self.currentState = TNTStateEnum.FADE_IN
  self.targetEvidenceCell_TweenPos.from = LuaGeometry.GetTempVector3(170 - self.offset, -19.6, 0)
  self.targetEvidenceCell_TweenPos.to = LuaGeometry.GetTempVector3(170, -19.6, 0)
  self.targetEvidenceCell_TweenPos:ResetToBeginning()
  self.targetEvidenceCell_TweenPos:PlayForward()
  self.targetEvidenceCell_TweenAlpha.from = 0
  self.targetEvidenceCell_TweenAlpha.to = 1
  self.targetEvidenceCell_TweenAlpha:ResetToBeginning()
  self.targetEvidenceCell_TweenAlpha:PlayForward()
end

function JointInferenceEvidenceComparePage:OnExit()
  if self.targetEvidenceTexturePath then
    picIns.Instance:UnloadSevenRoyalFamiliesTexture(self.targetEvidenceTexturePath, self.evidenceTexture)
    self.targetEvidenceTexturePath = nil
  end
  if self.myEvidenceTexture then
    picIns.Instance:UnloadSevenRoyalFamiliesTexture(self.myEvidenceTexture, self.targetEvidenceTexture)
    self.myEvidenceTexture = nil
  end
  TimeTickManager.Me():ClearTick(self)
  JointInferenceEvidenceComparePage.super.OnExit(self)
end
