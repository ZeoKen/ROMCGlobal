autoImport("TutorGuideView")
autoImport("TutorView")
autoImport("StudentView")
TutorMainView = class("TutorMainView", SubView)

function TutorMainView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end

function TutorMainView:FindObj()
end

function TutorMainView:AddButtonEvt()
end

function TutorMainView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.SessionSocialityQuerySocialData, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialUpdate, self.UpdateView)
  self:AddListenEvt(ServiceEvent.SessionSocialitySocialDataUpdate, self.UpdateView)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateStudentViewProgress)
end

function TutorMainView:InitShow()
  self.tutorGuideView = self.container:AddSubView("TutorGuideView", TutorGuideView)
  self.tutorView = self.container:AddSubView("TutorView", TutorView, nil, PanelConfig.TutorView)
  self.studentView = self.container:AddSubView("StudentView", StudentView, nil, PanelConfig.TutorView)
end

function TutorMainView:ChangeView()
  self:UpdateView()
end

function TutorMainView:UpdateView()
  local _TutorProxy = TutorProxy.Instance
  local view
  if _TutorProxy:CheckAsStudentLevel() and _TutorProxy:GetMyTutor() ~= nil then
    view = self.tutorView
  elseif _TutorProxy:CanAsTutor() then
    view = self.studentView
  else
    view = self.tutorGuideView
  end
  if self.lastView == nil or self.lastView ~= view then
    if self.lastView ~= nil then
      self.lastView.gameObject:SetActive(false)
    end
    view:ChangeView()
    self.lastView = view
    view.gameObject:SetActive(true)
  end
end

function TutorMainView:UpdateStudentViewProgress()
  local _TutorProxy = TutorProxy.Instance
  if _TutorProxy:CanAsTutor() and #_TutorProxy:GetStudentList() > 0 then
    self.studentView:UpdateProgress()
  end
end
