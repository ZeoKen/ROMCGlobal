autoImport("GemEmbedPreviewPage")
GemEmbedPreview = class("GemEmbedPreview", ContainerView)
GemEmbedPreview.ViewType = UIViewType.PopUpLayer

function GemEmbedPreview:Init()
  self.pageContainer = self:FindGO("PageContainer")
  if not self.pageContainer then
    LogUtility.Error("Cannot find PageContainer!")
    return
  end
  self:FindAndDeactivate("UpgradeTab")
  self:FindAndDeactivate("AppraiseTab")
  self:FindAndDeactivate("FunctionTab")
  self:FindAndDeactivate("SecretLandTab")
  self:FindAndDeactivate("TabLineBg")
  self.embedTab = self:FindComponent("EmbedTab", UIToggle)
  self:AddSubView("Preview", GemEmbedPreviewPage)
end

function GemEmbedPreview:OnEnter()
  GemEmbedPreview.super.OnEnter(self)
  self.embedTab.value = true
end

function GemEmbedPreview:FindAndDeactivate(name)
  local go = self:FindGO(name)
  if not go then
    return
  end
  go:SetActive(false)
end
