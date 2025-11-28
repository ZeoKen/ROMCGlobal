autoImport("PhotoChooseCell")
JointInferenceChoosePhotoPage = class("JointInferenceChoosePhotoPage", SubView)
JointInferenceChoosePhotoPage.ViewType = UIViewType.NormalLayer
local viewPath = ResourcePathHelper.UIView("JointInferenceChoosePhotoPage")

function JointInferenceChoosePhotoPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.choosePhotoPageObj, true)
  obj.name = "JointInferenceChoosePhotoPage"
end

function JointInferenceChoosePhotoPage:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:InitShow()
end

function JointInferenceChoosePhotoPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("JointInferenceChoosePhotoPage")
  self.titleLabel = self:FindGO("TitleLabel"):GetComponent(UILabel)
  self.photoGrid = self:FindGO("PhotoGrid"):GetComponent(UIGrid)
  self.photoGridCtrl = UIGridListCtrl.new(self.photoGrid, PhotoChooseCell, "PhotoChooseCell")
  self.photoGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickPhoto, self)
  self.confirmBtn = self:FindGO("ConfirmBtn", self.gameObject)
  self.confirmBtn_BoxCollider = self.confirmBtn:GetComponent(BoxCollider)
  self.tipsContainer = self:FindGO("TipsContainer", self.gameObject)
  self.tipLabelGO = self:FindGO("TipLabel")
  self.tipLabel = self.tipLabelGO:GetComponent(UILabel)
  self.tipLabel_BG = self:FindGO("Bg", self.tipLabelGO)
  self.tipLabel_TweenAlpha = self.tipLabelGO:GetComponent(TweenAlpha)
  self.tipLabel_TweenAlpha:ResetToBeginning()
  self.clickCollider = self:FindGO("ClickCollider", self.tipsContainer):GetComponent(BoxCollider)
  self.clickCollider.enabled = false
end

function JointInferenceChoosePhotoPage:AddEvts()
  self:AddClickEvent(self.confirmBtn, function()
    if not self.curChoosePhoto then
      return
    end
    self:DoSubmit()
  end)
end

function JointInferenceChoosePhotoPage:InitDatas()
end

function JointInferenceChoosePhotoPage:InitShow()
end

function JointInferenceChoosePhotoPage:RefreshQuestion(id)
  local questionId = id
  local staticData = Table_JointInference[id]
  if not staticData then
    return
  end
  self.staticData = staticData
  self.titleLabel.text = staticData.Title or "???"
  self.tipsList = staticData.Tips
  self.answer = staticData.Answer and staticData.Answer[1]
  self.unlockedMessage = staticData.Message
  xdlog("答案", self.answer)
  local evidenceList = staticData.EvidenceList
  self.photoGridCtrl:ResetDatas(evidenceList)
  self:PlayDefaultQuestion()
  self:SetTextureGrey(self.confirmBtn)
  self.clickCollider.enabled = false
end

function JointInferenceChoosePhotoPage:HandleClickPhoto(cellCtrl)
  if not self.curChoosePhoto then
    self.curChoosePhoto = cellCtrl
    self.curChoosePhoto:SetChoose(true)
    self.curChoosePhotoIndex = cellCtrl.indexInList
  else
    if self.curChoosePhoto ~= cellCtrl then
      self.curChoosePhoto:SetChoose(false)
    else
      return
    end
    self.curChoosePhoto = cellCtrl
    self.curChoosePhoto:SetChoose(true)
    self.curChoosePhotoIndex = cellCtrl.indexInList
  end
  self:SetTextureWhite(self.confirmBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
end

function JointInferenceChoosePhotoPage:DoSubmit()
  self.clickCollider.enabled = true
  local answer = self:CheckAnswer()
  if answer then
    self:PlayTips(1)
  else
    self:PlayTips(2)
  end
  TimeTickManager.Me():CreateOnceDelayTick(1500, function(owner, deltaTime)
    if self:CheckAnswer() then
      self.clickCollider.enabled = true
      TimeTickManager.Me():ClearTick(self, 6)
      self.container:ProcessFinish(self.unlockedMessage)
    else
      self.clickCollider.enabled = false
    end
  end, self, 2)
end

function JointInferenceChoosePhotoPage:CheckAnswer()
  if not self.curChoosePhotoIndex and not self.answer then
    return
  end
  if self.curChoosePhotoIndex == self.answer then
    return true
  end
  return false
end

function JointInferenceChoosePhotoPage:PlayTips(type)
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
    NGUIMath.CalculateRelativeWidgetBounds(self.tipLabel_BG.transform)
    self.tipLabel_TweenAlpha:ResetToBeginning()
    self.tipLabel_TweenAlpha:PlayForward()
    TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
      self:PlayDefaultQuestion()
    end, self, 6)
  end
end

function JointInferenceChoosePhotoPage:PlayDefaultQuestion()
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
  NGUIMath.CalculateRelativeWidgetBounds(self.tipLabel_BG.transform)
end

function JointInferenceChoosePhotoPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  JointInferenceChoosePhotoPage.super.OnExit(self)
end
