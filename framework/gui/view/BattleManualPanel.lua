using("UnityEngine")
autoImport("SceneUser2_pb")
autoImport("ShangJiaCell")
autoImport("BMTopToggleCell")
autoImport("DungeonManualView")
BattleManualPanel = class("BattleManualPanel", ContainerView)
BattleManualPanel.ViewType = UIViewType.NormalLayer
local curcellid = 1
BattleManualPanel.TopLeftName = "战斗手册"
BattleManualPanel.TopToggleName = {
  [1] = {
    id = 1,
    NameZh = "地下城手册"
  },
  [2] = {id = 2, NameZh = "MVP攻略"},
  [3] = {
    id = 3,
    NameZh = "怪的秘密"
  },
  [4] = {
    id = 4,
    NameZh = "战斗小贴士"
  }
}

function BattleManualPanel:Init()
  self:initData()
  self:initView()
end

function BattleManualPanel:initData()
  self.QueueTable = {}
end

function BattleManualPanel:NPCDance()
end

function BattleManualPanel:ShowCustomPanel(PanelconifgPanel, PanelData, btnfunc)
end

function BattleManualPanel:HideCustomPanel(PanelconifgPanel)
end

function BattleManualPanel:initView()
  self.Top = self:FindGO("Top")
  self.UIGridP = self:FindGO("UIGridP", self.Top)
  self.UIGridP_UIGrid = self.UIGridP:GetComponent(UIGrid)
  self.TopToggle_UIGridListCtrl = UIGridListCtrl.new(self.UIGridP_UIGrid, BMTopToggleCell, "BMTopToggleCell")
  if GameConfig.BattleManualPanelTopToggleName then
    local finalTable = {}
    for k, v in pairs(GameConfig.BattleManualPanelTopToggleName) do
      if v.forbidden ~= 1 then
        if v.menu == nil then
          table.insert(finalTable, v)
        elseif FunctionUnLockFunc.Me():CheckCanOpen(v.menu) then
          table.insert(finalTable, v)
        end
      end
    end
    table.sort(finalTable, function(a, b)
      return a.id < b.id
    end)
    self.TopToggle_UIGridListCtrl:ResetDatas(finalTable)
  end
  self.TopToggle_UIGridListCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickTopCell, self)
  self.DungeonManualView = self:AddSubView("DungeonManualView", DungeonManualView)
  self.bgCt = self:FindGO("bgCt")
  self.bgCt_Label1 = self:FindGO("Label1", self.bgCt)
  self.bgCt_Label1_UILabel = self.bgCt_Label1:GetComponent(UILabel)
  if GameConfig.BattleManualPanelTopLeftName then
    self.bgCt_Label1_UILabel.text = GameConfig.BattleManualPanelTopLeftName
  end
  local cells = self.TopToggle_UIGridListCtrl:GetCells()
  if cells and 0 < #cells then
    local idx = 1
    for i = 1, #cells do
      if (cells[i].data.id or 1) == curcellid then
        idx = i
        break
      end
    end
    curcellid = cells[idx].data.id or 1
    cells[idx]:SetChoose(true)
    self.justTopcell = cells[idx]
    self:ClickTopCell(cells[idx])
  end
end

function BattleManualPanel:ClickTopCell(Cell)
  if self.justTopCell ~= Cell then
    if self.justTopcell then
      self.justTopcell:SetChoose(false)
    end
    self.justTopcell = Cell
    Cell:SetChoose(true)
  end
  curcellid = Cell.data.id or 1
  self.DungeonManualView:SwitchToTopId(curcellid)
end

function BattleManualPanel:InitShare()
end

function BattleManualPanel:ShareAndReward(sharetype, content_title, content_body, platform_type, texture)
end

function BattleManualPanel:RecvKFCEnrollCodeUserCmd(data)
end

function BattleManualPanel:RecvKFCHasEnrolledUserCmd(data)
end

function BattleManualPanel:RecvKFCEnrollUserCmd(data)
end

function BattleManualPanel:RecvKFCEnrollReplyUserCmd(data)
end

function BattleManualPanel:takePic()
end

function BattleManualPanel:PreTakePic()
end

function BattleManualPanel:StringIsNullOrEmpty(text)
end

function BattleManualPanel:InitHead()
end

function BattleManualPanel:OnEnter()
end

function BattleManualPanel:OnExit()
  self.QueueTable = {}
end

function BattleManualPanel:CheckGPS()
end

function BattleManualPanel:RecvKFCShareUserCmd(data)
end

function BattleManualPanel:SavePic(texture, name)
end

function BattleManualPanel:ShowNPC()
end

function BattleManualPanel:HideNPC()
end
