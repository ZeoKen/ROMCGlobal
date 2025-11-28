GvgQuestTip = class("GvgQuestTip", BaseTip)
autoImport("GvgQuestTableCell")
autoImport("GvgGroupQuestTableCell")

function GvgQuestTip:Init()
  GvgQuestTip.super.Init(self)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.table = self:FindGO("Table"):GetComponent(UITable)
  self.separator = self:FindGO("Separator")
  self.group = self:FindGO("Group")
  local groupTitle = self:FindGO("Title", self.group):GetComponent(UILabel)
  groupTitle.text = ZhString.MainViewGvgPage_GvgQuestTip_Group
  local groupGrid = self:FindGO("QuestTable", self.group):GetComponent(UITable)
  self.groupQuestList = UIGridListCtrl.new(groupGrid, GvgGroupQuestTableCell, "GvgQuestTableCell")
  self.personal = self:FindGO("Personal")
  local personalTitle = self:FindGO("Title", self.personal):GetComponent(UILabel)
  personalTitle.text = ZhString.MainViewGvgPage_GvgQuestTip_Personal
  self.personalRate = self:FindGO("Rate", self.personal):GetComponent(UILabel)
  local citytype = GvgProxy.Instance.cityType
  local config = GameConfig.GVGConfig.citytype_data[citytype]
  if config ~= nil then
    local rate = config.user_task_rate - 1
    if 0 < rate then
      self.personalRate.text = string.format(ZhString.MainViewGvgPage_GvgQuestTip_PersonalRate, rate * 100)
    else
      self.personalRate.gameObject:SetActive(false)
    end
  else
    self.personalRate.gameObject:SetActive(false)
  end
  local personalGrid = self:FindGO("QuestTable", self.personal):GetComponent(UITable)
  self.personalQuestList = UIGridListCtrl.new(personalGrid, GvgQuestTableCell, "GvgQuestTableCell")
  local emptyLabel = self:FindComponent("emptyLabel", UILabel)
  emptyLabel.text = ZhString.MainViewGvgPage_GvgQuestTip_Empty
  self.empty = self:FindGO("empty")
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
end

function GvgQuestTip:SetPos(pos)
  if self.gameObject ~= nil then
    local p = self.gameObject.transform.position
    pos.z = p.z
    self.gameObject.transform.position = pos
  else
    self.pos = pos
  end
end

function GvgQuestTip:SetData()
  local isEmpty = true
  local needSeparator = false
  local groupList = {}
  local groupTaskID = GvgProxy.Instance:GetGroupTaskID()
  if groupTaskID ~= nil then
    isEmpty = false
    needSeparator = true
    self:Show(self.group)
    groupList[#groupList + 1] = {
      taskid = groupTaskID,
      progress = GvgProxy.Instance:GetGroupTaskProgress()
    }
  else
    self:Hide(self.group)
  end
  self.groupQuestList:ResetDatas(groupList)
  local personalList = {}
  local infoDatas = GvgProxy.Instance.questInfoData
  for i = 1, #GvgProxy.GvgQuestListp do
    local single = GvgProxy.GvgQuestListp[i]
    personalList[#personalList + 1] = {
      key = single,
      value = infoDatas[single] or 0
    }
  end
  if 0 < #personalList then
    isEmpty = false
    self:Show(self.personal)
  else
    self:Hide(self.personal)
  end
  self.personalQuestList:ResetDatas(personalList)
  self.empty:SetActive(isEmpty)
  self.separator:SetActive(needSeparator)
end

function GvgQuestTip:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function GvgQuestTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function GvgQuestTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
