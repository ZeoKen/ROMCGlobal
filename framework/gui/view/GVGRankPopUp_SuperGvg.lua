local _ToggleConfig = {
  chooseLabColor = LuaColor.New(0.7098039215686275, 0.43137254901960786, 0.15294117647058825, 1),
  unChooseLabColor = LuaColor.New(0.25882352941176473, 0.5019607843137255, 0.7254901960784313, 1)
}
local _ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
autoImport("NewSuperGvgRankCombineCell")
GVGRankPopUp_SuperGvg = class("GVGRankPopUp_SuperGvg", SubView)

function GVGRankPopUp_SuperGvg:OnEnter()
  GVGRankPopUp_SuperGvg.super.OnEnter(self)
  ServiceGuildCmdProxy.Instance:CallQuerySuperGvgDataGuildCmd()
end

function GVGRankPopUp_SuperGvg:HandleQueryFunc()
  self:OnClickGradeSuperGvg(SuperGvgProxy.E_SuperGVGRank.Sun, true)
end

local _groupName = {
  [1] = ZhString.NewGvg_SuperGVG_Grade1,
  [2] = ZhString.NewGvg_SuperGVG_Grade2,
  [3] = ZhString.NewGvg_SuperGVG_Grade3
}

function GVGRankPopUp_SuperGvg:Init()
  self.root = self:FindGO("SuperGvgRoot")
  local _togRoot = self:FindGO("TogRoot", self.root)
  self.superGvgTogs = {}
  self.superGvgTogLabels = {}
  for i = 1, SuperGvgProxy.E_SuperGVGRank._count do
    self.superGvgTogs[i] = self:FindComponent("Tog" .. i, UIToggle, _togRoot)
    self.superGvgTogLabels[i] = self:FindComponent("Label", UILabel, self.superGvgTogs[i].gameObject)
    self.superGvgTogLabels[i].text = _groupName[i]
    self:AddToggleChange(self.superGvgTogs[i], self.superGvgTogLabels[i], self.OnClickGradeSuperGvg, i)
  end
  local WrapGO = self:FindGO("Wrap", self.root)
  local wraps = {
    wrapObj = WrapGO,
    pfbNum = 9,
    cellName = "NewSuperGvgRankCombineCell",
    control = NewSuperGvgRankCombineCell
  }
  self.rankWrap = WrapCellHelper.new(wraps)
  self.rankWrap:AddEventListener(MouseEvent.MouseClick, self.OnClickRankCell, self)
  self.gvgReportBtnGO = self:FindGO("ReportBtn", self.root)
  self:AddClickEvent(self.gvgReportBtnGO, function()
    local isInGvgMap = Game.MapManager:IsInSuperGvg()
    if isInGvgMap then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.GVGDetailView
      })
    else
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.LastGVGDetailView
      })
    end
  end)
end

function GVGRankPopUp_SuperGvg:AddToggleChange(toggle, label, handler, grade)
  EventDelegate.Add(toggle.onChange, function()
    if toggle.value then
      label.color = _ToggleConfig.chooseLabColor
      if handler then
        handler(self, grade)
      end
    else
      label.color = _ToggleConfig.unChooseLabColor
    end
  end)
end

function GVGRankPopUp_SuperGvg:OnClickRankCell(cell)
  local data = cell and cell.data
  if not data then
    return
  end
  GuildProxy.Instance:DoQueryGuildInfo(data)
end

function GVGRankPopUp_SuperGvg:OnTabView()
  self.container.emptyRoot:SetActive(#self.rankWrap:GetDatas() == 0)
end

function GVGRankPopUp_SuperGvg:OnClickGradeSuperGvg(grade, forceUpdate)
  if self.curGrade == grade and not forceUpdate then
    return
  end
  self.curGrade = grade
  self.superGvgTogs[grade]:Set(true)
  local data = SuperGvgProxy.Instance:GetRankDataByGrade(grade)
  data = _ReUniteCellData(data, 3)
  self.rankWrap:ResetDatas(data, true)
  self.container.emptyRoot:SetActive(#data == 0)
end
