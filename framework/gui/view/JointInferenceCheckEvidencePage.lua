JointInferenceCheckEvidencePage = class("JointInferenceCheckEvidencePage", SubView)
JointInferenceCheckEvidencePage.ViewType = UIViewType.NormalLayer
local viewPath = ResourcePathHelper.UIView("JointInferenceCheckEvidencePage")

function JointInferenceCheckEvidencePage:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:AddMapEvts()
  self:InitShow()
end

function JointInferenceCheckEvidencePage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.checkEvidencePageObj, true)
  obj.name = "JointInferenceCheckEvidencePage"
end

function JointInferenceCheckEvidencePage:FindObjs()
  self:LoadSubView()
  self.questionNumLabel = self:FindGO("QuestionNum"):GetComponent(UILabel)
  self.questionLabel = self:FindGO("QuestionLabel"):GetComponent(UILabel)
  self.reportLabel = self:FindGO("ReportLabel"):GetComponent(UILabel)
  self.evidenceGrid = self:FindGO("EvidenceGrid"):GetComponent(UIGrid)
  self.evidenceGridCtrl = UIGridListCtrl.new(self.evidenceGrid, EvidenceGridCell, "ManorPartnerHeadCell")
end

function JointInferenceCheckEvidencePage:AddEvts()
end

function JointInferenceCheckEvidencePage:AddMapEvts()
end

function JointInferenceCheckEvidencePage:InitDatas()
end

function JointInferenceCheckEvidencePage:InitShow()
end

function JointInferenceCheckEvidencePage:RefreshQuestion(id)
  local questionId = id
  local staticData = Table_JointInference[id]
  if not staticData then
    return
  end
  self.questionLabel.text = staticData.Question or "???"
end
