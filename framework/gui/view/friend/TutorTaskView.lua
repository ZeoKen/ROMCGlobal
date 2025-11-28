autoImport("TutorTaskCell")
TutorTaskView = class("TutorTaskView", ContainerView)
TutorTaskView.ViewType = UIViewType.PopUpLayer
local emptyList = {}

function TutorTaskView:Init()
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:InitShow()
end

function TutorTaskView:FindObj()
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.empty = self:FindGO("Empty")
  self.tutorProgress = self:FindGO("TutorProgress")
  self.proficiencyTip = self:FindGO("ProficiencyTip"):GetComponent(UILabel)
  self.proficiencyProgress = self:FindComponent("Progress", UILabel)
  self.proficiencyProgressBar = self:FindComponent("ProgressSlider", UISlider)
  self.loading = self:FindGO("Loading")
end

function TutorTaskView:AddButtonEvt()
end

function TutorTaskView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.TutorTutorTaskUpdateNtf, self.UpdateView)
  self:AddListenEvt(ServiceEvent.TutorTutorTaskQueryCmd, self.RecvTutorTaskQuery)
  self:AddListenEvt(ServiceEvent.TutorTutorTaskTeacherRewardCmd, self.UpdateView)
end

function TutorTaskView:InitShow()
  local container = self:FindGO("ContentContainer")
  local wrapConfig = {
    wrapObj = container,
    pfbNum = 5,
    cellName = "TutorTaskCell",
    control = TutorTaskCell,
    dir = 1
  }
  self.itemWrapHelper = WrapCellHelper.new(wrapConfig)
  local viewdata = self.viewdata.viewdata
  if viewdata ~= nil then
    self.ownerGuid = viewdata
    local socialData = Game.SocialManager:Find(viewdata)
    if socialData ~= nil then
      self.title.text = string.format(ZhString.Tutor_TaskTitle, socialData.name)
      self.tutorProgress:SetActive(false)
    end
  else
  end
  local guid = self.ownerGuid or Game.Myself.data.id
  self.isQueryTask = TutorProxy.Instance:CallTutorTaskQueryCmd(guid)
  self.loading:SetActive(self.isQueryTask)
  self:UpdateView()
end

function TutorTaskView:UpdateView()
  if self.ownerGuid == nil then
    local isFull = TutorProxy.Instance:GetTutorProfic() >= GameConfig.Tutor.max_proficiency
    if not isFull then
      self:UpdateTask(Game.Myself.data.id)
    else
      self.itemWrapHelper:UpdateInfo(emptyList)
    end
    self.empty:SetActive(isFull)
  else
    self:UpdateTask(self.ownerGuid)
  end
end

function TutorTaskView:UpdateTask(guid)
  if self.isQueryTask then
    return
  end
  if guid ~= nil then
    local data = TutorProxy.Instance:GetTutorTaskItems(guid)
    if data then
      self.itemWrapHelper:UpdateInfo(data)
    end
  end
end

function TutorTaskView:UpdateProficiency()
  local proficiency = TutorProxy.Instance:GetTutorProfic()
  self.proficiencyTip.text = ZhString.Tutor_StudentPoint
  self.proficiencyProgress.text = TutorProxy.Instance:GetTutorProfic() .. "/" .. (GameConfig.Tutor.certificate_week_limit or 0)
  self.proficiencyProgressBar.value = TutorProxy.Instance:GetTutorProfic() / (GameConfig.Tutor.certificate_week_limit or 1)
end

function TutorTaskView:RecvTutorTaskQuery(note)
  local data = note.body
  if data then
    self.isQueryTask = false
    self.loading:SetActive(false)
    self:UpdateView()
  end
end

function TutorTaskView:UpdateHead()
  if not self.targetCell then
    local headCellObj = self:FindGO("PortraitCell")
    self.headCellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headCellObj)
    self.headCellObj.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
    self.targetCell = PlayerFaceCell.new(self.headCellObj)
    self.targetCell:HideHpMp()
    self.targetCell:HideLevel()
  end
  local headData = HeadImageData.new()
  headData:TransByMyself()
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
end
