local BaseCell = autoImport("BaseCell")
ReturnActivityTaskCell = class("ReturnActivityTaskCell", BaseCell)
autoImport("RewardGridCell")

function ReturnActivityTaskCell:Init()
  ReturnActivityTaskCell.super.Init(self)
  self:FindObjs()
end

function ReturnActivityTaskCell:FindObjs()
  self.taskLabel = self:FindGO("TaskLabel"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.itemGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.itemGridCtrl = UIGridListCtrl.new(self.itemGrid, RewardGridCell, "RewardGridCell")
  self.itemGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.processInfo = self:FindGO("ProcessInfo")
  self.processLabel = self:FindGO("ProcessLabel", self.processInfo):GetComponent(UILabel)
  self.processSlider = self:FindGO("Slider", self.processInfo):GetComponent(UISlider)
  self.funcBtn = self:FindGO("FuncBtn", self.processInfo)
  self.funcBtn_Icon = self.funcBtn:GetComponent(UISprite)
  self.funcBtn_Label = self:FindGO("Label", self.funcBtn):GetComponent(UILabel)
  self.funcBtn_BoxCollider = self.funcBtn:GetComponent(BoxCollider)
  self.funcBtn_BoxCollider.enabled = false
  self:AddClickEvent(self.funcBtn, function()
    if self.rewardReady then
      ServiceActivityCmdProxy.Instance:CallUserReturnQuestAwardCmd(self.id)
    elseif self.config and self.config.Goto then
      self:PassEvent(ReturnActivityEvent.ClickGoBtn, self)
    end
  end)
end

function ReturnActivityTaskCell:SetData(data)
  self.data = data
  self.id = data.id
  self.config = Table_Mission[self.id]
  self.taskLabel.text = self.config and self.config.Desc
  local rewards = self.config.Reward
  if rewards and 0 < #rewards then
    local rewardList = {}
    for i = 1, #rewards do
      local reward = rewards[i]
      local data = {}
      data.itemData = ItemData.new("Reward", reward[1])
      if data.itemData then
        data.num = reward[2]
        table.insert(rewardList, data)
      end
    end
    self.itemGridCtrl:ResetDatas(rewardList)
  end
  self.awarded = data.awarded
  if self.awarded then
    self.processInfo:SetActive(false)
    self.finishSymbol:SetActive(true)
    return
  else
    self.processInfo:SetActive(true)
    self.finishSymbol:SetActive(false)
  end
  local curProcess = data.process or 0
  local maxProcess = data.goal or 1
  self.processLabel.text = curProcess .. "/" .. maxProcess
  self.processSlider.value = curProcess / maxProcess
  self.funcBtn_BoxCollider.enabled = true
  if data.finish then
    self.rewardReady = true
    self.funcBtn_Icon.spriteName = "new-com_btn_c"
    self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1)
    self.funcBtn_Label.text = ZhString.AdventureAppendRewardPanel_Reward
  else
    self.rewardReady = false
    if self.config and self.config.Level and MyselfProxy.Instance:RoleLevel() < self.config.Level then
      self.funcBtn_BoxCollider.enabled = false
      self.funcBtn_Icon.spriteName = "new-com_btn_a_gray"
      self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
      self.funcBtn_Label.text = string.format(ZhString.ReturnActivityPanel_LevelLimit, self.config.Level)
    elseif self.config and self.config.Goto and self.config.Goto ~= _EmptyTable then
      self.funcBtn_Icon.spriteName = "new-com_btn_a"
      self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
      self.funcBtn_Label.text = ZhString.WorldMapMenuPopUp_MoveTo
    else
      self.funcBtn_BoxCollider.enabled = false
      self.funcBtn_Icon.spriteName = "new-com_btn_a_gray"
      self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
      self.funcBtn_Label.text = ZhString.AdventureAppendRewardPanel_Reward
    end
  end
end

function ReturnActivityTaskCell:RefreshStatus(data)
  self.awarded = data.awarded
  if self.awarded then
    self.processInfo:SetActive(false)
    self.finishSymbol:SetActive(true)
    return
  end
  local curProcess = data.process or 0
  local maxProcess = data.goal or 1
  self.processLabel.text = curProcess .. "/" .. maxProcess
  self.funcBtn_BoxCollider.enabled = true
  if curProcess >= maxProcess then
    self.rewardReady = true
    self.funcBtn_Icon.spriteName = "new-com_btn_c"
    self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1)
  else
    self.rewardReady = false
    if self.config and self.config.Goto then
      self.funcBtn_Icon.spriteName = "new-com_btn_a"
      self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
    else
      self.funcBtn_BoxCollider.enabled = false
      self.funcBtn_Icon.spriteName = "new-com_btn_a_gray"
      self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
    end
  end
end

function ReturnActivityTaskCell:HandleClickReward(cellCtrl)
  self:PassEvent(ReturnActivityEvent.ClickTaskReward, cellCtrl)
end
