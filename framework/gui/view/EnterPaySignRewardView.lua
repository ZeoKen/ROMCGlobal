EnterPaySignRewardView = class("EnterPaySignRewardView", ContainerView)
EnterPaySignRewardView.ViewType = UIViewType.PopUpLayer

function EnterPaySignRewardView:Init()
  self.modelTexture = self:FindComponent("Texture", UITexture)
  self.skipBtn = self:FindGO("SkipBtn")
  self:AddClickEvent(self.skipBtn, function()
    self:OpenSignRewardView()
  end)
end

function EnterPaySignRewardView:OpenSignRewardView()
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PaySignRewardView,
    viewdata = {
      id = self.viewdata.viewdata.id
    }
  })
end

function EnterPaySignRewardView:OnEnter()
  self:CreateModel()
  TimeTickManager.Me():CreateOnceDelayTick(5000, function(owner, deltaTime)
    self:OpenSignRewardView()
  end, self, 1)
end

function EnterPaySignRewardView:CreateModel()
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.Body] = 2197
  parts[Asset_Role.PartIndexEx.LoadFirst] = true
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.modelTexture, parts, UIModelCameraTrans.Role, 0.35, nil, nil, nil, function(obj)
    self.model = obj
    self.model:GetRoleComplete().gameObject:SetActive(true)
  end)
  UIModelUtil.Instance:SetCellTransparent(self.modelTexture, LuaColor.New(0.6666666666666666, 0.6666666666666666, 0.6666666666666666, 0))
  self.model:SetPosition(LuaGeometry.GetTempVector3(0, 0.35))
  Asset_Role.DestroyPartArray(parts)
end

function EnterPaySignRewardView:OnExit()
  TimeTickManager.Me():ClearTick(self, 1)
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
  UIModelUtil.Instance:ResetTexture(self.modelTexture)
end
