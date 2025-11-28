MagicBoxPanel = class("MagicBoxPanel", ContainerView)
MagicBoxPanel.ViewType = UIViewType.NormalLayer
MagicBoxPanel.TabPage = {MagicBoxExtractionNewPage = 1, MagicBoxIllustrationPage = 2}
autoImport("MagicBoxExtractionPreviewPage")
autoImport("MagicBoxExtractionNewPage")
autoImport("MagicBoxIllustrationPage")

function MagicBoxPanel:Init()
  local viewdata = self.viewdata and self.viewdata.viewdata
  self.isPreview = viewdata and viewdata.preview
  self:FindObjs()
  self:InitShow()
  self:AddListener()
end

function MagicBoxPanel:FindObjs()
  self.extractionToggle = self:FindGO("ExtractionToggle")
  self.illustrationToggle = self:FindGO("IllustrationToggle")
  self.extractionPageObj = self:FindGO("MagicBoxExtractionPage")
  self.illustrationPageObj = self:FindGO("MagicBoxIllustrationPage")
  self.approveDragScrollView = self:FindGO("bg"):GetComponent(UIDragScrollView)
  self.applyDragScrollView = self:FindGO("leftBg"):GetComponent(UIDragScrollView)
end

function MagicBoxPanel:InitShow()
  if self.isPreview then
    local viewdata = self.viewdata and self.viewdata.viewdata
    local extractionDatas = viewdata and viewdata.slotdatas or {}
    self.applyView = self:AddSubView("MagicBoxExtractionPage", MagicBoxExtractionPreviewPage, {slotdatas = extractionDatas})
    self:AddTabChangeEvent(self.extractionToggle, self.extractionPageObj, PanelConfig.MagicBoxExtractionPreviewPage)
  else
    self.applyView = self:AddSubView("MagicBoxExtractionNewPage", MagicBoxExtractionNewPage)
    self:AddTabChangeEvent(self.extractionToggle, self.extractionPageObj, PanelConfig.MagicBoxExtractionPage)
  end
  self.approveView = self:AddSubView("MagicBoxIllustrationPage", MagicBoxIllustrationPage)
  self:AddTabChangeEvent(self.illustrationToggle, self.illustrationPageObj, PanelConfig.MagicBoxIllustrationPage)
  self.approveDragScrollView.scrollView = self.approveView.scrollView
  self.applyDragScrollView.scrollView = self.applyView.scrollView
end

function MagicBoxPanel:AddListener()
  self:AddListenEvt(MagicBoxEvent.CloseContainerview, self.CloseSelf)
end

function MagicBoxPanel:OnEnter()
  self:TabChangeHandler(MagicBoxPanel.TabPage.MagicBoxExtractionNewPage)
  self.applyView:OnEnter()
end

function MagicBoxPanel:OnExit()
  self.applyView:OnExit()
end
