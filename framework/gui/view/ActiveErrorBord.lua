ActiveErrorBord = class("ActiveErrorBord", ContainerView)
ActiveErrorBord.ViewType = UIViewType.PopUpLayer

function ActiveErrorBord:Init()
  self:initView()
  self:addViewEventListener()
end

local tempVector3 = LuaVector3.Zero()

function ActiveErrorBord:initView()
  local Title = self:FindComponent("Title", UILabel)
  Title.text = ZhString.ActiveErrorBord_ErrorTitle
  local cancel = self:FindComponent("cancelLabel", UILabel)
  cancel.text = ZhString.ActiveErrorBord_Cancel
  local cancelBtn = self:FindGO("cancelBtn")
  LuaVector3.Better_Set(tempVector3, 0, -86, 0)
  cancelBtn.transform.localPosition = tempVector3
  local confirmBtn = self:FindGO("confirmBtn")
  self:Hide(confirmBtn)
end

function ActiveErrorBord:addViewEventListener()
  self:AddButtonEvent("cancelBtn", function()
    self:CloseSelf()
  end)
end
