autoImport("BaseItemResultView")
PersonalArtifactResultView = class("PersonalArtifactResultView", BaseItemResultView)
PersonalArtifactResultView.Title = ZhString.PersonalArtifact_ResultTitle
PersonalArtifactResultView.PackageCheck = {18, 19}
PersonalArtifactResultView.ViewType = UIViewType.PopUpLayer

function PersonalArtifactResultView:AddListenEvts()
  self:AddListenEvt(ItemEvent.PersonalArtifactUpdate, self.OnItemUpdate)
end
