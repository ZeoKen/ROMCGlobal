autoImport("BattlePassTaskCell")
BattlePassTaskView = class("BattlePassTaskView", SubView)
local path = ResourcePathHelper.UIView("BattlePassTaskView")
local colorEffectBlue = Color(0.25882352941176473, 0.4823529411764706, 0.7568627450980392, 1)
local colorTitleGray = ColorUtil.TitleGray

function BattlePassTaskView:Init()
  self:LoadSubView(path)
  self:FindObjs()
  self:PageToggleChange(self.dailyToggle, self.dailyLab, colorEffectBlue, colorTitleGray, self.ShowUI, 1)
  self:PageToggleChange(self.weeklyToggle, self.weeklyLab, colorEffectBlue, colorTitleGray, self.ShowUI, 2)
  self:ShowUI(1)
end

function BattlePassTaskView:LoadSubView(path)
  self.gameObject = self:LoadPreferb_ByFullPath(path, self.container.taskViewPos, true)
  self.gameObject.name = "BattlePassTaskView"
end

function BattlePassTaskView:FindObjs()
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    self:CloseSelf()
  end)
  local dailyObj = self:FindGO("DailyToggle")
  self.dailyToggle = dailyObj:GetComponent(UIToggle)
  self.dailyLab = dailyObj:GetComponent(UILabel)
  self.dailyLab.text = ZhString.Servant_Recommend_PageDaily
  local weekObj = self:FindGO("WeeklyToggle")
  self.weeklyToggle = weekObj:GetComponent(UIToggle)
  self.weeklyLab = weekObj:GetComponent(UILabel)
  self.weeklyLab.text = ZhString.Servant_Recommend_PageWeek
  local taskGrid = self:FindComponent("Grid", UIGrid)
  self.taskList = UIGridListCtrl.new(taskGrid, BattlePassTaskCell, "BattlePassTaskCell")
  self.taskList:AddEventListener(NoviceBattlePassEvent.OnGotoBtnClick, self.HandleGotoBtnClick, self)
end

function BattlePassTaskView:PageToggleChange(toggle, label, toggleColor, normalColor, handler, param)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = toggleColor
      if handler ~= nil then
        handler(self, param)
      end
    else
      label.color = normalColor
    end
  end)
end

function BattlePassTaskView:ShowUI(type)
  local datas = BattlePassProxy.Instance:GetBattlePassTasksByType(type)
  self.taskList:ResetDatas(datas)
end

function BattlePassTaskView:HandleGotoBtnClick(cellCtrl)
  local staticData = Table_BattlePassTask[cellCtrl.id]
  if staticData then
    local go = staticData.Goto
    if go and 0 < #go then
      FuncShortCutFunc.Me():CallByID(go)
      return
    end
    local msg = staticData.Message
    if msg and 0 < #msg then
      if 1 < #msg then
        local param = {}
        for i = 2, #msg do
          param[#param + 1] = msg[i]
        end
        MsgManager.ShowMsgByIDTable(msg[1], param)
      else
        MsgManager.ShowMsgByID(msg[1])
      end
    end
  end
end

function BattlePassTaskView:CloseSelf()
  self.container:HideTaskPanel()
end
