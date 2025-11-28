local BaseCell = autoImport("BaseCell")
DayloginCell = class("DayloginCell", BaseCell)

function DayloginCell:Init()
  DayloginCell.super.Init(self)
  self:FindObjs()
end

function DayloginCell:FindObjs()
  self.dayLabel = self:FindGO("Label"):GetComponent(UILabel)
  self.finishSymbol = self:FindGO("FinishSymbol")
  self.itemGrid = self:FindGO("ItemGrid"):GetComponent(UIGrid)
  self.itemGridCtrl = UIGridListCtrl.new(self.itemGrid, RewardGridCell, "RewardGridCell")
  self.itemGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.funcBtn = self:FindGO("FuncBtn", self.processInfo)
  self.funcBtn_Icon = self.funcBtn:GetComponent(UISprite)
  self.funcBtn_Label = self:FindGO("Label", self.funcBtn):GetComponent(UILabel)
  self.funcBtn_BoxCollider = self.funcBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.funcBtn, function()
    self:PassEvent(UICellEvent.OnRightBtnClicked, self)
  end)
end

function DayloginCell:SetData(data)
  self.data = data
  self.dayLabel.text = string.format(ZhString.PlayerRefluxView_Day, self.indexInList or 7)
  local active = data.active
  local received = data.received
  self.funcBtn:SetActive(true)
  self.finishSymbol:SetActive(false)
  if received then
    self.funcBtn:SetActive(false)
    self.finishSymbol:SetActive(true)
  elseif active then
    self.funcBtn_BoxCollider.enabled = true
    self.funcBtn_Icon.spriteName = "new-com_btn_c"
    self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1)
  else
    self.funcBtn_BoxCollider.enabled = false
    self.funcBtn_Icon.spriteName = "new-com_btn_a_gray"
    self.funcBtn_Label.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1)
  end
  self.itemGridCtrl:RemoveAll()
  local rewards = data.rewards
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
      self.itemGridCtrl:ResetDatas(rewardList)
    end
  end
end

function DayloginCell:HandleClickReward(cellCtrl)
  xdlog("PassEvent HandleClickReward")
  self:PassEvent(UICellEvent.OnMidBtnClicked, cellCtrl)
end

function DayloginCell:SetFuncLabel(text)
  self.funcBtn_Label.text = text
end
