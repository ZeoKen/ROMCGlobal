local baseCell = autoImport("BaseCell")
ActivityPuzzleCell = class("ActivityPuzzleCell", baseCell)

function ActivityPuzzleCell:Init()
  self:initView()
end

function ActivityPuzzleCell:initView()
  self.tabName = self:FindComponent("TabName", UILabel)
  self.tabTime = self:FindComponent("TabTime", UILabel)
  self.checkmark = self:FindGO("Checkmark")
end

function ActivityPuzzleCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.tabName.color = ActivityPuzzleView.ColorTheme[5].color
      self.tabTime.color = ActivityPuzzleView.ColorTheme[5].color
    else
      self.tabName.color = ActivityPuzzleView.ColorTheme[1].color
      self.tabTime.color = ActivityPuzzleView.ColorTheme[1].color
    end
  end
end

function ActivityPuzzleCell:SetData(data)
  self.data = data
  if not data.actid then
    return
  end
  self.actid = data.actid
  local ERedSys = SceneTip_pb.EREDSYS_PUZZLE
  local _RedTipProxy = RedTipProxy.Instance
  local isNew = _RedTipProxy:IsNew(ERedSys, data.actid)
  if isNew then
    _RedTipProxy:RegisterUI(ERedSys, self.gameObject, 8, {86, 45})
  else
    _RedTipProxy:UnRegisterUI(ERedSys, self.gameObject)
  end
  local StartTime, EndTime = ActivityPuzzleProxy.Instance:GetDuration(data.actid)
  self.staticData = Table_ActivityInfo[data.actid]
  self.tabName.text = self.staticData.ActivityName
  self.tabTime.text = string.format(ZhString.ActivityPuzzle_TimeFormat, os.date(ZhString.ActivityPuzzle_TimePeriod, StartTime), os.date(ZhString.ActivityPuzzle_TimePeriod, EndTime))
end
