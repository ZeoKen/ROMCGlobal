JointInferenceResultPage = class("JointInferenceResultPage", SubView)
JointInferenceResultPage.ViewType = UIViewType.NormalLayer
local viewPath = ResourcePathHelper.UIView("JointInferenceResultPage")
local decorateTextureNameMap = {
  Decorate16 = "Sevenroyalfamilies_bg_decoration16",
  Decorate17 = "Sevenroyalfamilies_bg_decoration17",
  Decorate18 = "Sevenroyalfamilies_bg_decoration18",
  Decorate19 = "Sevenroyalfamilies_bg_decoration19"
}
local picIns = PictureManager.Instance

function JointInferenceResultPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.resultPageObj, true)
  obj.name = "JointInferenceResultPage"
end

function JointInferenceResultPage:Init()
  self:FindObjs()
  self:InitDatas()
  self:AddEvts()
  self:InitShow()
end

function JointInferenceResultPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("JointInferenceResultPage")
  self.reportLabel = self:FindGO("ReportLabel", self.gameObject):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture, self.gameObject)
  end
  self.reportScrollView = self:FindGO("ReportScrollView", self.gameObject):GetComponent(UIScrollView)
  self.reportPanel = self:FindGO("ReportScrollView", self.gameObject):GetComponent(UIPanel)
  self.table = self:FindGO("Table", self.gameObject):GetComponent(UITable)
  self.analysisPart = self:FindGO("LogicAnalysis", self.gameObject)
  self.analysisLabel = self:FindGO("AnalysisLabel", self.gameObject):GetComponent(UILabel)
  self.analysisPart:SetActive(false)
end

function JointInferenceResultPage:AddEvts()
  self:AddClickEvent(self.confirmBtn, function()
    self.container:QuestNotify()
    self.container:CloseSelf()
  end)
end

function JointInferenceResultPage:InitDatas()
end

function JointInferenceResultPage:InitShow()
end

function JointInferenceResultPage:SetData(data, analysisData)
  self.data = data
  if data and 0 < #data then
    local str = ZhString.QuestManual_TwoSpace
    for i = 1, #data do
      local messageInfo = Table_EvidenceMessage[data[i]]
      if messageInfo then
        str = str .. i .. "." .. OverSea.LangManager.Instance():GetLangByKey(messageInfo.Description) .. "\n" .. ZhString.QuestManual_TwoSpace
      end
    end
    self.reportLabel.text = str
  end
  if analysisData then
    self.analysisPart:SetActive(true)
    self.reportScrollView:ResetPosition()
    local str = ZhString.QuestManual_TwoSpace
    local info = Table_EvidenceMessage[analysisData]
    if info then
      str = str .. OverSea.LangManager.Instance():GetLangByKey(info.Description)
    end
    self.analysisLabel.text = str
  else
    self.reportScrollView:ResetPosition()
  end
  self.table:Reposition()
  self:PlayUISound(AudioMap.UI.InferenceReportIncome)
end

function JointInferenceResultPage:OnEnter()
  JointInferenceResultPage.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
end

function JointInferenceResultPage:OnExit()
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  JointInferenceResultPage.super.OnExit(self)
end
