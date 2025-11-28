GuildApplyApprove = class("GuildApplyApprove", ContainerView)
GuildApplyApprove.ViewType = UIViewType.PopUpLayer
autoImport("GuildApplyListPopUp")
autoImport("GuildApprovePopUp")

function GuildApplyApprove:Init()
  self:FindObjs()
  self:InitShow()
end

function GuildApplyApprove:FindObjs()
  self.applyToggle = self:FindGO("ApplyToggle")
  self.approveToggle = self:FindGO("ApproveToggle")
  self.cando = GuildProxy.Instance:CanIDoAuthority(GuildAuthorityMap.Approve_Applied)
  self.approveToggle:SetActive(self.cando)
  self.applyObj = self:FindGO("ApplyView")
  self.approveObj = self:FindGO("ApproveView")
end

function GuildApplyApprove:InitShow()
  self.applyView = self:AddSubView("GuildApplyListPopUp", GuildApplyListPopUp)
  self.approveView = self:AddSubView("GuildApprovePopUp", GuildApprovePopUp)
  self:AddTabChangeEvent(self.applyToggle, self.applyObj, PanelConfig.GuildApplyListPopUp)
  self:AddTabChangeEvent(self.approveToggle, self.approveObj, PanelConfig.GuildApprovePopUp)
  self:TabChangeHandler(1)
end

function GuildApplyApprove:OnExit()
  if self.cando then
    EventManager.Me():PassEvent("Tog2Fix")
  end
end
