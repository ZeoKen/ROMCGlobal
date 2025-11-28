AndroidPermissionPanel = class("AndroidPermissionPanel", BaseView)
AndroidPermissionPanel.ViewType = UIViewType.PopUpLayer

function AndroidPermissionPanel:Init()
  self:InitData()
  self:AddEvt()
end

function AndroidPermissionPanel:InitData()
  local title = self:FindComponent("title", UILabel)
  title.text = self.viewdata.data.Title or ZhString.NoticeTitle
  local permissionMsg = self:FindComponent("permissionMsg", UILabel)
  permissionMsg.text = self.viewdata.data.Text
  local btnLable = self:FindComponent("Label", UILabel)
  btnLable.text = self.viewdata.data.button or ZhString.BFBuilding_button_use1
  self.Btn = self:FindGO("useBtn")
end

function AndroidPermissionPanel:AddEvt()
  self:AddClickEvent(self.Btn, function()
    if self.viewdata.confirmHandler ~= nil then
      self.viewdata.confirmHandler()
    end
    self:CloseSelf()
  end)
end
