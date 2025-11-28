autoImport("MakeBaseView")
HollgrehennMakeView = class("HollgrehennMakeView", MakeBaseView)
HollgrehennMakeView.ViewType = MakeBaseView.ViewType

function HollgrehennMakeView:Init()
  self.type = BusinessmanMakeProxy.Skill.Hollgrehenn
  HollgrehennMakeView.super.Init(self)
end
